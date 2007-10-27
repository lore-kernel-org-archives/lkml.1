Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXJ0XLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXJ0XLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbXJ0XK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:10:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36941 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXJ0XK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:10:58 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] 0/3 fs/ioctl.c coding style, rename vfs_ioctl/do_ioctl
Date: Sat, 27 Oct 2007 19:10:42 -0400
Message-Id: <11935266454097-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This series of three proposed patches changes fs/ioctl.c and Unionfs as
follows.  This series is against v2.6.24-rc1-192-gef49c32.

Patch 1: just applies coding standards to fs/ioctl.c (while I'm at it, I
figured it's worth cleaning VFS files one at a time).

Patch 2: does two things:

(a) Renames the old vfs_ioctl to do_ioctl, because the comment above the old
    vfs_ioctl clearly indicates that it is an internal function not to be
    exported to modules; therefore it should have a more traditional do_XXX
    "internal function" name.  The new do_ioctl is exported in fs.h but not
    to modules.

(b) Renames the old (static) do_ioctl to vfs_ioctl because the names vfs_XXX
    should preferably be reserved to callable VFS functions which modules
    may call, as other vfs_XXX functions already do.  Export the new
    vfs_ioctl to modules so others can use it (including Unionfs and
    eCryptfs).

Patch 3: demonstrates how Unionfs can use the new vfs_ioctl.  I successfully
tested unionfs with this new exported vfs_ioctl.  (eCryptfs could do the
same.)

I'd like to propose that the first two patches be merged in -mm and even
mainline, pending review.

Erez Zadok (3):
      VFS: apply coding standards to fs/ioctl.c
      VFS: swap do_ioctl and vfs_ioctl names
      Unionfs: use vfs_ioctl

 fs/compat_ioctl.c       |    2 
 fs/ioctl.c              |  176 ++++++++++++++++++++++++------------------------
 fs/unionfs/commonfops.c |   22 +-----
 include/linux/fs.h      |    3 

Cheers,
Erez.
