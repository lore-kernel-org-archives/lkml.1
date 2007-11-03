Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbXKCBXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbXKCBXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXKCBXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:23:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35195 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbXKCBXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:23:12 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/8 Unionfs updates/cleanups/fixes
Date: Fri,  2 Nov 2007 21:22:41 -0400
Message-Id: <11940529692937-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  The main change
here is that we dropped ->sync_page and rewritten ->writepage.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc1-521-g54866f0), as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download backported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (8):
      Unionfs: delete whiteouts in sticky directories
      Unionfs: cleanup permission checking code
      Unionfs: update usage.txt documentation
      Unionfs: mmap updates
      Unionfs: avoid a deadlock during branch-management on a pivot_root'ed union
      Unionfs: don't bother validating inode if it has no lower branches
      Unionfs: don't printk an error if it's due to common copyup
      Unionfs/VFS: no need to export 2 symbols in security/security.c

 Documentation/filesystems/unionfs/usage.txt |   17 +++
 fs/unionfs/commonfops.c                     |    4 
 fs/unionfs/debug.c                          |    6 +
 fs/unionfs/inode.c                          |   96 ++++++-----------
 fs/unionfs/mmap.c                           |  156 ++++++++++------------------
 fs/unionfs/rename.c                         |    2 
 fs/unionfs/subr.c                           |    8 +
 fs/unionfs/union.h                          |   39 +++++--
 security/security.c                         |    2 
 9 files changed, 158 insertions(+), 172 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
