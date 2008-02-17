Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYBQC6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYBQC6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 21:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYBQC5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 21:57:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36230 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYBQC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 21:57:42 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/17 Unionfs updates/fixes/cleanups
Date: Sat, 16 Feb 2008 21:57:09 -0500
Message-Id: <12032170461107-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  The most
significant changes are several fixes to races/locking.  This release also
supports newer APIs in 2.6.25-rc: not using iget/read_inode, using the
changed d_path, using the revised nameidata which embeds a struct path, and
using path_get/put.

These patches were tested (where appropriate) on 2.6.25, MM, as well as the
backports to 2.6.{24,23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs,
nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and squashfs (where available).  Also
tested with LTP-full and with a continuous parallel kernel compile (while
forcing cache flushing, manipulating lower branches, etc.).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Andrew Morton (1):
      Unionfs: embed a struct path into struct nameidata instead of nd dentrymnt

David Howells (1):
      Unionfs: stop using iget() and read_inode()

Erez Zadok (14):
      Unionfs: grab lower super_block references
      Unionfs: ensure consistent lower inodes types
      Unionfs: document behavior when the lower topology changes
      Unionfs: uninline unionfs_copy_attr_times and unionfs_copy_attr_all
      Unionfs: initialize path_save variable
      Unionfs: extend dentry branch configuration lock in open
      Unionfs: follow_link locking fixes
      Unionfs: improve debugging in copy_attr_times
      Unionfs: revalidation code cleanup and refactoring
      Unionfs: factor out revalidation routine
      Unionfs: lock parents' branch configuration fixes
      Unionfs: branch management/configuration fixes
      Unionfs: use dget_parent in revalidation code
      VFS/Unionfs: use generic path_get/path_put functions

Jan Blunck (1):
      Unionfs: use the new path_put

 Documentation/filesystems/unionfs/concepts.txt |   13 +
 fs/unionfs/commonfops.c                        |   54 ++++---
 fs/unionfs/copyup.c                            |    3 
 fs/unionfs/dentry.c                            |  182 ++++++++++++++-----------
 fs/unionfs/fanout.h                            |   50 ------
 fs/unionfs/inode.c                             |   78 +++++++---
 fs/unionfs/lookup.c                            |   13 +
 fs/unionfs/main.c                              |   26 +--
 fs/unionfs/mmap.c                              |   17 --
 fs/unionfs/rename.c                            |    7 
 fs/unionfs/subr.c                              |   56 +++++++
 fs/unionfs/super.c                             |   72 ++++++---
 fs/unionfs/union.h                             |   13 +
 fs/unionfs/unlink.c                            |   11 +
 include/linux/namei.h                          |   12 -
 15 files changed, 366 insertions(+), 241 deletions(-)

Thanks.
---
Erez Zadok
ezk@cs.sunysb.edu
