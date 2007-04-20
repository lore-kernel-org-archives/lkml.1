Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXDTUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXDTUp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754503AbXDTUpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:45:55 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59146 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbXDTUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:45:54 -0400
To: drepper@gmail.com
CC: agruen@suse.de, alan@lxorguk.ukuu.org.uk, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       akpm@linux-foundation.org
In-reply-to: <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
	(drepper@gmail.com)
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
References: <20070412090809.917795000@suse.de>
	 <200704201721.29825.agruen@suse.de>
	 <a36005b50704200824i228f98ccq80f88a0f9d64abb2@mail.gmail.com>
	 <200704201840.07247.agruen@suse.de> <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
Message-Id: <E1Hezy0-0001Pf-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 20 Apr 2007 22:44:28 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I gave a chroot example that showed that in the current
> > implementation, you can get pretty random clashes between mounts; there are
> > other cases with lazy unmounts as well.
> 
> Irrelevant as well.  If you create chroot problems it's your problem.
> 
> The fact is that if you have a normal setup the code works fine.  All
> other situations cannot be handled with the current kernel interface.
> 
> This does not give anybody the right to say "since the code doesn't
> always work we can break it completely".  That's completely
> unacceptable.

I'm not sure I understand the situation completely.  What exactly is
broken in libc by removing unreachable mounts from /proc/mounts?

Is it the situation when
 - file descriptor is opened
 - process does chroot
 - process does fstatvfs on file descriptor
?

In that case currently fstatvfs() _usually_ gives the correct results,
but can give wrong results if mounts paths accidently clash in
/proc/mounts?

Also isn't it the case, that fstatvfs() or statvfs() performed within
the chroot could also give incorrect result for a _reachable_ mount if
it clashes with an unreachable mount?

If this is the case, I would think that removing the unreachable
mounts from /proc/mounts, would actually be fixing this second case,
which is more likely to be used anyway.

BTW, this patch, or at least a predecessor is in -mm, and it very much
feels the Right Thing(tm).  The /proc/mounts under a chroot
environment actually looks sane, instead of some random crap, that it
was previously.

While we should make every effort to keep the kernel interfaces
stable, this shouldn't prevent us from fixing bugs.  And this one is
clearly a bug, even if not a very serious one.

Miklos
