Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXIZSlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXIZSlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbXIZSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:40:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbXIZSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:40:56 -0400
Date: Wed, 26 Sep 2007 19:40:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Newall <david@davidnewall.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070926184032.GR8181@ftp.linux.org.uk>
References: <46F0CD96.9030807@prepere.com> <20070919104018.3a6bcfb1@the-village.bc.nu> <46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu> <46F1A196.8060108@davidnewall.com> <46F401D6.6060609@cfl.rr.com> <20070921191012.15a0b51b@the-village.bc.nu> <46F9752C.5080807@cfl.rr.com> <20070926002340.GL8181@ftp.linux.org.uk> <46FA35A6.1070400@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA35A6.1070400@davidnewall.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 08:04:14PM +0930, David Newall wrote:
> Al Viro wrote:
> >Oh, for fsck sake...  Folks, it's standard-required behaviour.  Ability
> >to chroot() implies the ability to break out of it.  Could we please
> >add that (along with reference to SuS) to l-k FAQ and be done with that
> >nonsense?
> 
> I'm pretty confident that it's only standard behavior for Linux.  Every 
> other unix says it's not allowed.

OK, the possibilities are
	* you've discovered a bug in all Unices (BTW, even FreeBSD *does*
allow to break out of some chroots in that fashion; RTFS and you'll see -
just pay attention to setting fdp->fd_jdir logics in kern/vfs_syscalls.c:
change_root(); it sets jail boundary on _first_ chroot and if you've got
nested chroots, you can leave them just fine by use of SCM_RIGHTS to hold
directory descriptor).  All hail David, nevermind that this behaviour had
been described in Unix FAQs since _way_ back.
	* you've misunderstood the purpose of chroot(), the fact that
behaviour in question is at the very least extremely common on Unix and
the fact that any code relying on root-proof chroot(2) is broken and needs
to be fixed, simply because chroot is _not_ root-proof on (at least) almost
all systems.

Note that the last statement applies in both cases; it's simply reality.
Insisting that behaviour known for decades is a bug since it contradicts
your rather convoluted reading of the standards...  Looks rather silly,
IMO, but that has zero practical consequences anyway.  Userland code can't
rely on root-proof chroot(2), period.
