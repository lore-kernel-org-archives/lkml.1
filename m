Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbYEPOU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbYEPOU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYEPOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:20:47 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:48644 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYEPOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:20:46 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC 2/2] AUFS: merging/stacking several filesystems 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080511215458.44021c4a.akpm@linux-foundation.org>
References: <7016.1207113135@jrobl> <8157.1207205925@jrobl> <9316.1210567436@jrobl> <20080511215458.44021c4a.akpm@linux-foundation.org>
Date: Fri, 16 May 2008 23:20:40 +0900
Message-ID: <13179.1210947640@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton:
> On Mon, 12 May 2008 13:43:56 +0900 hooanon05@yahoo.co.jp wrote:
> 
> > 
> > > > Here are some of them and the intention of this post is to get some
> > > > initial feedback about its design.
> > 	:::
> > 
> > I have posted some of ideas, design or approaches which are implemented
> > in AUFS stackable filesystem about a month before.
> > While I have a plan to implement some more features still, the current
> > AUFS status is better and used many people for years.
> > Since I have received requests to submit AUFS into the mainline more
> > than once, Now I'd ask you to include AUFS into mainline.
> > But the source is large (see below).
> > Should I send all of these files to this ML, or ask you to download them
> > from CVS?
> > If AUFS was much smaller, I would send files here without asking.
> > 
> 
> Yup, prepare a patch series and email them out.  cc linux-kernel too.

Ok, I will send these patches to two MLs.
I'd ask linux-kernel people to read previous posts too.
http://marc.info/?l=linux-fsdevel&m=120716468102834&w=2
http://marc.info/?l=linux-fsdevel&m=120720593114664&w=2

 Documentation/filesystems/aufs/README      |  374 +++++++
 Documentation/filesystems/aufs/aufs.5      | 1608 ++++++++++++++++++++++++++++
 Documentation/filesystems/aufs/aulchown.c  |   29 +
 Documentation/filesystems/aufs/auplink     |  170 +++
 Documentation/filesystems/aufs/mount.aufs  |  205 ++++
 Documentation/filesystems/aufs/umount.aufs |   33 +
 fs/Kconfig                                 |    2 +
 fs/Makefile                                |    1 +
 fs/aufs/Kconfig                            |  203 ++++
 fs/aufs/Makefile                           |   57 +
 fs/aufs/aufs.h                             |   56 +
 fs/aufs/br_fuse.c                          |  109 ++
 fs/aufs/br_nfs.c                           |  391 +++++++
 fs/aufs/br_xfs.c                           |   69 ++
 fs/aufs/branch.c                           |  933 ++++++++++++++++
 fs/aufs/branch.h                           |  345 ++++++
 fs/aufs/cpup.c                             | 1043 ++++++++++++++++++
 fs/aufs/cpup.h                             |   82 ++
 fs/aufs/dcsub.c                            |  246 +++++
 fs/aufs/dcsub.h                            |   54 +
 fs/aufs/debug.c                            |  485 +++++++++
 fs/aufs/debug.h                            |  210 ++++
 fs/aufs/dentry.c                           | 1020 ++++++++++++++++++
 fs/aufs/dentry.h                           |  384 +++++++
 fs/aufs/dinfo.c                            |  425 ++++++++
 fs/aufs/dir.c                              |  573 ++++++++++
 fs/aufs/dir.h                              |  146 +++
 fs/aufs/dlgt.c                             |  113 ++
 fs/aufs/export.c                           |  597 +++++++++++
 fs/aufs/f_op.c                             |  665 ++++++++++++
 fs/aufs/file.c                             |  822 ++++++++++++++
 fs/aufs/file.h                             |  246 +++++
 fs/aufs/finfo.c                            |  185 ++++
 fs/aufs/hin_or_dlgt.c                      |  708 ++++++++++++
 fs/aufs/hinode.h                           |  188 ++++
 fs/aufs/hinotify.c                         | 1114 +++++++++++++++++++
 fs/aufs/i_op.c                             |  844 +++++++++++++++
 fs/aufs/i_op_add.c                         |  828 ++++++++++++++
 fs/aufs/i_op_del.c                         |  582 ++++++++++
 fs/aufs/i_op_ren.c                         |  832 ++++++++++++++
 fs/aufs/iinfo.c                            |  290 +++++
 fs/aufs/inode.c                            |  425 ++++++++
 fs/aufs/inode.h                            |  336 ++++++
 fs/aufs/misc.c                             |  307 ++++++
 fs/aufs/misc.h                             |  201 ++++
 fs/aufs/module.c                           |  243 +++++
 fs/aufs/module.h                           |   78 ++
 fs/aufs/opts.c                             | 1493 ++++++++++++++++++++++++++
 fs/aufs/opts.h                             |  245 +++++
 fs/aufs/plink.c                            |  349 ++++++
 fs/aufs/robr.c                             |  111 ++
 fs/aufs/sbinfo.c                           |  268 +++++
 fs/aufs/super.c                            |  891 +++++++++++++++
 fs/aufs/super.h                            |  410 +++++++
 fs/aufs/sysaufs.c                          |  104 ++
 fs/aufs/sysaufs.h                          |  150 +++
 fs/aufs/sysfs.c                            |  459 ++++++++
 fs/aufs/sysrq.c                            |  112 ++
 fs/aufs/vdir.c                             |  963 +++++++++++++++++
 fs/aufs/vfsub.c                            |  653 +++++++++++
 fs/aufs/vfsub.h                            |  493 +++++++++
 fs/aufs/wbr_policy.c                       |  693 ++++++++++++
 fs/aufs/whout.c                            | 1058 ++++++++++++++++++
 fs/aufs/whout.h                            |  140 +++
 fs/aufs/wkq.c                              |  321 ++++++
 fs/aufs/wkq.h                              |  160 +++
 fs/aufs/xino.c                             | 1249 +++++++++++++++++++++
 fs/namei.c                                 |    2 +-
 include/linux/aufs_type.h                  |  111 ++
 include/linux/lockdep.h                    |    4 +
 include/linux/namei.h                      |    1 +
 71 files changed, 29296 insertions(+), 1 deletions(-)


Junjiro Okajima
