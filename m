Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbXJ3TlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbXJ3TlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXJ3Tkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:40:52 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45011 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbXJ3Tkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:40:51 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v3] 0/4 fs/ioctl.c coding style, function renaming/factoring
Date: Tue, 30 Oct 2007 15:39:55 -0400
Message-Id: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This series of 4 proposed patches (take 3) changes fs/ioctl.c and Unionfs as
follows.  This series is against v2.6.24-rc1-423-g97855b4.

Patch 1: just applies coding standards to fs/ioctl.c (while I'm at it, I
figured it's worth cleaning VFS files one at a time).

Patch 2: does two things:

(a) Renames the old vfs_ioctl to do_ioctl, because the comment above it
    clearly indicates that it is an internal function not to be exported to
    modules; therefore it should have a more traditional do_XXX "internal
    function" name.  The new do_ioctl is exported in fs.h but not to
    modules.

(b) Renames the old (static) do_ioctl to vfs_ioctl because the names vfs_XXX
    should preferably be reserved to callable VFS functions which modules
    may call, as other vfs_XXX functions already do.  Export the new
    vfs_ioctl to (GPL) modules so others can use it (including Unionfs and
    eCryptfs).

Patch 3: factors out the switch statements' cases for
FIBMAP/FIONBIO/FIOASYNC, into three small static helper functions.

Patch 4: demonstrates how Unionfs can use the new vfs_ioctl.  I successfully
tested unionfs with this new exported vfs_ioctl.  (eCryptfs could do the
same.)

I'd like to propose that the first 3 patches be merged in -mm and even
mainline, pending review.

Erez Zadok (4):
      VFS: apply coding standards to fs/ioctl.c
      VFS: swap do_ioctl and vfs_ioctl names
      VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
      Unionfs: use vfs_ioctl

 fs/compat_ioctl.c       |    2 
 fs/ioctl.c              |  224 ++++++++++++++++++++++++++++--------------------
 fs/unionfs/commonfops.c |   36 +------
 include/linux/fs.h      |    4 
 4 files changed, 141 insertions(+), 125 deletions(-)

Cheers,
Erez.
