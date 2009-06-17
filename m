Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbZFQWYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbZFQWYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 18:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZFQWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 18:24:42 -0400
Received: from Cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:56975 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbZFQWYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 18:24:42 -0400
From: Frans Pop <elendil@planet.nl>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
Date: Thu, 18 Jun 2009 00:24:41 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, Jiri Kosina <jkosina@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0906161429060.5125-100000@iolanthe.rowland.org> <1245275412.22520.7.camel@localhost>
In-Reply-To: <1245275412.22520.7.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906180024.42998.elendil@planet.nl>
X-OriginalArrivalTime: 17 Jun 2009 22:24:43.0414 (UTC) FILETIME=[69B37360:01C9EF9A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 June 2009, Thomas Meyer wrote:
> Sure. Rearranging the usb devices and removing some hubs makes the
> problem go away in most cases...

I see that you still have the Broadcom "Wireless RNDIS device" attached 
that was my initial suspect after looking through your boot log.

Does removing that device make the problem go away? Can you reproduce the 
problem at all without that device connected (during boot)?

Probably moving that device to a different controller than used for your 
keyboard and mouse will also get rid of the problem. Correct?

If removing that device does solve the problem, I would guess that without 
it you will also no longer have that "PME+" value in the output of lspci 
for the USB Controller it is connected to.

Hopefully someone else can then explain how/why that device forces the 
PME+ setting for the controller.

But I must also say that to me it seems rather fragile that in default 
configuration a random USB device can suddenly cause wakeups as result of 
a change caused by a totally different device.

Cheers,
FJP
