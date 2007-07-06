Return-Path: <linux-kernel-owner+w=401wt.eu-S1762687AbXGFHhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687AbXGFHhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbXGFHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:37:08 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:51787 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbXGFHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:37:07 -0400
To: nigel@suspend2.net
CC: miklos@szeredi.hu, nigel@suspend2.net, rjw@sisk.pl, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, oliver@neukum.org,
       paulus@samba.org, mingo@elte.hu
In-reply-to: <200707061719.36054.nigel@nigel.suspend2.net> (message from Nigel
	Cunningham on Fri, 6 Jul 2007 17:19:34 +1000)
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
References: <200707041658.59588.rjw@sisk.pl> <200707061707.23316.nigel@nigel.suspend2.net> <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu> <200707061719.36054.nigel@nigel.suspend2.net>
Message-Id: <E1I6iMD-0003Gl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 09:36:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > To get more serious and practical though, I think the solution is to
> > > fuzz the userspace/kernelspace distinction. What we really want to
> > > do is freeze things that submit I/O, then sync, then freeze anything
> > > that processes I/O and needs to be frozen. In effect, redefine fuse
> > > processes as freezeable kernel threads.
> > 
> > Another myth, that has been debunked already.  The problem is: how do
> > you define fuse processes?  There's no theoretical or even practial
> > way to do that.
> 
> No theoretical or practical way?! I'll freely admit to being quite ignorant 
> about fuse, but surely there's some way by which they can be distinguished.

How?  OK, there are some tasks, that read and/or write /dev/fuse. And
there are some that just communicate in some way with the above.

These could all be considered "fuse tasks", but those that don't do
I/O on /dev/fuse are indistinguishable from non-fuse tasks.

And for example sshfs does have such a thread, which is in the reply
chain, yet never communicates directly with the fuse kernel module.

Miklos
