Return-Path: <linux-kernel-owner+w=401wt.eu-S937743AbZFPGL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937743AbZFPGL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZFPGF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:05:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43331 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937242AbZFPGF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:05:57 -0400
Date: Tue, 16 Jun 2009 08:05:59 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 012/143] USB: move twl4030_usb's probe function to
	.devinit.text
Message-ID: <20090616060559.GA18333@pengutronix.de>
References: <20090616051356.GB23627@kroah.com> <1245129858-23818-12-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1245129858-23818-12-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Mon, Jun 15, 2009 at 10:22:07PM -0700, Greg Kroah-Hartman wrote:
> A pointer to twl4030_usb_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=y)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
> 
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
I wonder if this kind of error could be detected automatically.  That is
at probe time check if the probe function is in the .init.text section.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
