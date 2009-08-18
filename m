Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbZHRKWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbZHRKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZHRKWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:22:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52316 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZHRKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:22:23 -0400
Date: Tue, 18 Aug 2009 12:21:36 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Johannes Stezenbach <js@sig21.net>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090818102136.GN29655@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de> <20090815103532.GA5596@sig21.net> <4A8A7D38.5020201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A8A7D38.5020201@gmail.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 12:13:13 up 12 days, 21:32, 53 users,  load average: 6.51, 6.04,
	4.11
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco,

On Tue, Aug 18, 2009 at 12:06:48PM +0200, Marco Stornelli wrote:
> Yeah, I agree, do you really need udevd, device file creation at every
> start-up in /dev? Usually static devices nodes and mdev for hotplug are
> enough or at least you could use a simple script to create only once
> time the devices file (mdev -s). About the fs, do you really need a
> rootfs with ubifs? I mean, you could "split" your fs. You could use a
> read-only fs (SquashFS for example) for your root-fs, ubifs for
> permanent storage data (mounted under /data for example) and a ram fs
> for volatile data.

Well, we try to find out what is possible with a fast booting Linux
system which *still* is as "vanilla" as possible.

All the "boot-in-one-second" systems out there are highly squeezed,
which is surely good if you have a scenario with high production
volumes. You can do the optimization in the last steps then and it
doesn't really matter how much time you spend with testing to come from
a system that works for a developer to a production system.

For most of our use cases here at Pengutronix, we see that:

- Customers want in-system upgradability on a per-packet base; so the
  flash filesystems should be normally r/o, but may be remounted r/w.

- Development systems should be close to production systems, in order to
  be able to have more "early testing"; so things like printk-ripout or
  special non-mainline patches/tweaks should be avoided as far as
  possible.

- In general we want to have our systems close to what the mainline
  does; Automation & Embedded is only a small market, and anything
  which is *not* specific to these markets but mainline is good.

So let's see what we'll reach while trying what people have suggested.

Thanks,
rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
