Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXJUXwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXJUXwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXJUXvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:51:45 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49185 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbXJUXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:51:44 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/9 Unionfs updates/cleanups/fixes
Date: Sun, 21 Oct 2007 19:51:13 -0400
Message-Id: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  The main change
here is that unionfs now has its own ->writepages method.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.23-6623-g55b70a0), as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download backported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Andrew Morton (2):
      Unionfs: security convert lsm into a static interface fix
      Unionfs: slab api remove useless ctor parameter and reorder parameters

Erez Zadok (6):
      Unionfs: support lower filesystems without writeback capability
      Unionfs: don't printk trivial message upon normal rename-copyup
      Unionfs: don't bother validating dentry if it has no lower branches
      Unionfs: convert a printk to pr_debug in release
      Unionfs: remove for_writepages nfs workaround
      Unionfs: remove obsolete #define and comment

Jeff Layton (1):
      Unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID

 fs/unionfs/debug.c       |    4 +++
 fs/unionfs/dentry.c      |    6 ++--
 fs/unionfs/inode.c       |    7 +++++
 fs/unionfs/mmap.c        |   62 +++++++++++++++++------------------------------
 fs/unionfs/rename.c      |    8 +++---
 fs/unionfs/super.c       |    4 +--
 fs/unionfs/union.h       |    1 
 include/linux/union_fs.h |    3 --
 security/security.c      |    2 +
 9 files changed, 47 insertions(+), 50 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
