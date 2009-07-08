Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZGHQTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZGHQTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZGHQT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:19:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58213 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753785AbZGHQTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:19:25 -0400
Date: Wed, 8 Jul 2009 17:18:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090708171848.21633768@lxorguk.ukuu.org.uk>
In-Reply-To: <1247069202.4159.212.camel@mulgrave.site>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > That represents loss of functionality for loss of risk (a trade off).
> 
> Precisely ... that's what this whole thread is about.  Accepting the
> lawyer's argument that this patch eliminates the risk of suit under the
> FAT32 patents, does the loss of functionality it comes with represent an
> adequate reward?

You are missing the point still.

Ship with problem feature enabled	risk high    features high
Ship with problem off but in source	risk lower   features low
Ship with it ripped out			risk lowest  features low

So the only two logical positions to operate are low feature/lowest risk
and high feature/high risk. So if you decide not to ship the feature it'll
get ripped out entirely.

> OK, so we disagree on whether providing source code constitutes
> contributory infringement.

We disagree whether there is zero risk involved. If there is any risk
then the logical position if you've decided not to enable the feature is
not to ship source for it.

> OK, so rather than get into a what my lawyer says versus what your
> lawyer says argument, can we get back to the technical aspects of this
> and leave the lawyers retained by the vendors to sort out what they
> actually do?

Sure and I'd say the technical issues are simple

- Tridge's patch breaks stuff
- Tridge's patch masquerades as vfat but isn't.

We can fix those by only creating short names (but honouring existing
long ones) and by not claiming its vfat.

Alan
