Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYGGHxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYGGHxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 03:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYGGHxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 03:53:37 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:53935 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYGGHxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 03:53:36 -0400
Date: Mon, 7 Jul 2008 09:53:34 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Michael Chan <mchan@broadcom.com>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bnx2 - use request_firmware()
Message-ID: <20080707075333.GA13723@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Michael Chan <mchan@broadcom.com>,
	'David Woodhouse' <dwmw2@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1215251041.3189.69.camel@shinybook.infradead.org> <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 09:21:21PM -0700, Michael Chan wrote:
> I cannot sign off on this until I understand more about the impact
> of this change.

The change is targeted for the firmware tree. The firmware tree
seperates the firmwares from the driver _within_ the kernel tree. Both
parts are still shipped in the same tree. The driver themself is
modified to use request_firmware. If the driver is builtin the kernel,
the firmware is appended to vmlinux where request_firmware is able to
find them. If it is built as a module the firmware is copied into
/lib/firmware during installation where the famous hotplug handler can
find it.

So the impact is that you need a hotplug handler in the module case.
Most of the modern wireless cards drivers (e.g. b43, iwl*) needs them
anyway.

My patch does not yet include the firmware move within the tree because
it would make the patch really large. Will do that.

>                  Unlike the tg3 firmware which hasn't changed for at
> least 4 or 5 years, the bnx2 firmware is constantly changing and it
> has to match the driver.  For example, we'll be adding multi-tx ring
> to the driver soon and it will require the feature in the firmware.

Thats why the firmware files got a "version" string included. You can
change it for incompatible changes in the firmware. Your workflow will
not change drastically. You still can modify the firmware and the source
in one tree.

Also it is not that uncommon that you need to update firmwares for new
kernel versions in other devices.

Bastian

-- 
Fascinating, a totally parochial attitude.
		-- Spock, "Metamorphosis", stardate 3219.8
