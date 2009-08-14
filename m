Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZHNS6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZHNS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 14:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHNS6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 14:58:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38387 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZHNS6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 14:58:18 -0400
Date: Fri, 14 Aug 2009 20:57:31 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Zan Lynx <zlynx@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
Message-ID: <20090814185731.GN13320@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A85AAC4.7050505@acm.org>
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
X-Uptime: 20:48:24 up 9 days,  6:07,  5 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zan,

On Fri, Aug 14, 2009 at 12:19:48PM -0600, Zan Lynx wrote:
> > That's factor 70 away from the 110 ms boot time Tim has talked about
> > some days ago (and he measured on an ARM cpu which had almost half
> > the speed of this one), and I'm wondering what we can do to improve
> > the boot time.
>
> 2.4s in uncompression? That seems like an obvious target for
> improvement.

Indeed, we'll check that.

However, I have a little bit the impression that most systems which are
hyped as "fast boot" out there are optimized so aggressively that they
are not really usable in real life applications any more. So we try to
configure the systems in a "realistic" way. I know that we won't get the
last milliseconds that way - but I'd like to find out how far we can go.

> Your kernel seems awfully large. 3104K code? You should definitely find
> out what is making it that big and cut out everything you do not need.

Definitely, will audit again.

> You might even try some of the embedded system scripts that rip out
> all the printk strings.

Hmm, that's definitely in the "last-minute-before-product" category.

> If you get the kernel size way down then use a uncompressed kernel and
> it should boot a lot faster if the bottleneck is CPU speed.

I'll try that.

> However, it is probably IO speed. There could be something really wrong
> and slow with your MTD. Does it DMA or is it doing something crazy like
> using the CPU to read a byte at a time?

Will check.

> Or maybe its cheap and slow flash. In that case I think your only hope
> is to make all the code as small as possible and/or find a different
> flash filesystem that does not have to read so much of the device to
> mount. Perhaps use a read-only compressed filesystem for the system
> binaries and reflash it for software upgrades. Only init and mount the
> writable flash for user-storable data well after system boot has
> finished.

That would be also a last-minute change, but surely worth to be
evaluated.

We recently changed from jffs2 to ubifs and hoped to gain speed during
that step.

Thanks for your feedback!

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
