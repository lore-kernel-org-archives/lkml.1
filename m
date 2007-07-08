Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXGHHWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXGHHWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 03:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXGHHWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 03:22:42 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:43987 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbXGHHWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 03:22:42 -0400
To: pavel@ucw.cz
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <20070707233315.GB3820@elf.ucw.cz> (message from Pavel Machek on
	Sun, 8 Jul 2007 01:33:15 +0200)
Subject: Re: malicious filesystems (was Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway)
References: <Pine.LNX.4.44L0.0707041045150.25704-100000@netrider.rowland.org> <18060.14856.824473.325660@cargo.ozlabs.ibm.com> <200707050858.03638.oliver@neukum.org> <E1I6MWb-0008Tq-00@dorka.pomaz.szeredi.hu> <20070705091801.GB3084@elf.ucw.cz> <E1I6NgZ-0000F6-00@dorka.pomaz.szeredi.hu> <20070705115400.GF3984@ucw.cz> <E1I6Q73-0000Xi-00@dorka.pomaz.szeredi.hu> <20070707121729.GC3111@elf.ucw.cz> <E1I7H6v-0006pf-00@dorka.pomaz.szeredi.hu> <20070707233315.GB3820@elf.ucw.cz>
Message-Id: <E1I7R5c-0007q3-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 08 Jul 2007 09:21:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > We can just wait for all fuse requests to be serviced before
> > > proceeding further with freeze, right?
> > 
> > Right.  Nice way to slow down or stop the suspend with an unprivileged
> > process.  Avoiding that sort of DoS is one of the design goals of
> > fuse.
> 
> So you want me to handle _malicious_ filesystems now?

What I'd like, is a suspend, that works reliably, regardless of the
state of any userspace filesystem, network servers and such.

> That should be easy... :-). You already have nasty deadlocks in FUSE,
> and you solve them by "root can echo 1 > abort"... so allow me the
> same possibility.
> 
> We can tell fused we are freezing, and if all the requests are not
> serviced within, say, 30 seconds, we call the filesystem malicious and
> do echo 1 > abort.

Arbitrary time limits, nice.  Not.

This freezer is like an old house that's close to collapsing, and you
are basically just thinking of where to prop it up further.  To
continute this brilliant analogy, Rafael's patch at least demolishes
the worst part of the house, where bricks are already falling on our
head ;)

> Not ideal, but neither is allowing malicious filesystems in the first
> place...

Malicious programs are not something specific to fuse.  A lot of the
multiuser/multitasking OS design is about isolating things, so such a
program is limited in the damage it can do.

> > Look at it this way: the task of the freezer is to stop new I/O
> > hitting the hardware.  But it is totally indiscriminate about what it
> > stops, it tries to stop _everything_ even things which have nothing to
> > do with hardware.
> > 
> > Not nice.
> 
> Not nice, but we don't know any better for now. "Just fix all the
> drivers" basically means "just fix 90% of kernel".

And how much of that 90% currently has any power management?

Miklos
