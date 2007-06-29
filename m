Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbXF2QQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbXF2QQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758920AbXF2QQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:16:14 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:32955 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbXF2QQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:16:13 -0400
To: alan@lxorguk.ukuu.org.uk
CC: mista.tapas@gmx.net, bunk@stusta.de, nix@esperi.org.uk, galibert@pobox.com,
       tiwai@suse.de, kloczek@rudy.mif.pg.gda.pl, linux-kernel@vger.kernel.org
In-reply-to: <E1I4IoZ-0003Hm-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Fri, 29 Jun 2007 17:55:19 +0200)
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <20070624200837.16e11305@the-village.bc.nu>
	<87tzssextf.fsf@hades.wkstn.nix>
	<20070628210614.GC6087@stusta.de>
	<200706291352.42833.mista.tapas@gmx.net>
	<E1I4HtE-0003A5-00@dorka.pomaz.szeredi.hu> <20070629164945.26891025@the-village.bc.nu> <E1I4IoZ-0003Hm-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1I4J76-0003MW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 29 Jun 2007 18:14:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Not as if it would be hard to add ioctl support to fuse.  What fuse
> > > can't handle is the data argument of ioctl(), so the most it could do
> > > is give the filesystem a pid (tid) and a virtual address.  The
> > > userspace fs could then get/put the data through /proc/<pid>/mem.
> > 
> > Hork...
> > 
> > Identify the generic ioctls that are relevant to a FUSE file system and
> > have real meaning *and* are useful.
> 
> I don't think there are any such.
> 
> The point in this thread was I think about emulating an OSS sound
> device through a fuse fs.  In that case fuse would need _generic_
> ioctl support, which simply can't be done without weird userspace
> hacks.

Well, had a look at what FUSD does.  It assumes that the ioctl
argument is stuctured according to the command.  If all OSS ioctls are
like that, then fine, fuse can support it properly.

The drawback of this is that ioctls which aren't structured properly
could cause weird failures due to wrong data being accessed by the
poor unknowing kernel.

Miklos
