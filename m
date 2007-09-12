Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbXILFcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbXILFcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXILFcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:32:15 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:41146 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754954AbXILFcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:32:14 -0400
Date: Wed, 12 Sep 2007 07:32:07 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Heiko Schocher <hs@denx.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Detlev Zundel <dzu@denx.de>
Message-ID: <20070912053207.GH23573@pengutronix.de>
References: <1189503798.6674.46.camel@Zeus.EmbLux>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1189503798.6674.46.camel@Zeus.EmbLux>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 18:50:48 up 161 days, 10:16, 11 users,  load average: 0.78, 0.33, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: SYSFS: need a noncaching read
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 11:43:17AM +0200, Heiko Schocher wrote:
> I have developed a device driver and use the sysFS to export some
> registers to userspace.

Uuuh, uggly. Don't do that. Device drivers are there to abstract things,
not to play around with registers from userspace.

> I opened the sysFS File for one register and did some reads from this
> File, but I alwas becoming the same value from the register, whats not
> OK, because they are changing. So I found out that the sysFS caches
> the reads ... :-(

Yes, it does. What you can do is close()ing the file handle between
accesses, which makes it work but is slow.

> Is there a way to retrigger the reads (in that way, that the sysFS
> rereads the values from the driver), without closing and opening the
> sysFS Files? Or must I better use the ioctl () Driver-interface for
> exporting these registers?

What kind of problem do you want to solve? Userspace is for
applications, and applications usually don't have to know about hardware
details like registers. So if you have to do something every 10 ms from
userspace, your design is probably wrong.

If you absolutely need to do such things from userspace, have a look at
uio. But in most cases the answer is: make a proper abstraction for the
problem you wanna solve and write a proper driver.

Robert
-- 
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de
