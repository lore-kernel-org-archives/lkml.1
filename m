Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbXKMKLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbXKMKLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXKMKKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:10:45 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50664 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXKMKKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:44 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/9 Unionfs updates/cleanups/fixes
Date: Tue, 13 Nov 2007 05:10:19 -0500
Message-Id: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  The main changes
here are bug fixes and improved cache-coherency methods.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc2-330-g325d22d), for the first time on MM
(mmotm-2007-11-10-19-05), as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download backported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (9):
      Unionfs: flush and release updates
      Unionfs: use i_size wrappers
      Unionfs: update cache-coherency detection heuristics
      Unionfs: writepage updates
      Unionfs: clear partial read in readpage
      Unionfs: debugging updates
      Unionfs: remove unnecessary lower atime updates
      Unionfs: fold do_readpage into unionfs_readpage
      Unionfs: move debugging checks inside locks

 Documentation/filesystems/unionfs/concepts.txt |   18 ++++++
 fs/unionfs/commonfops.c                        |   47 +++++++-----------
 fs/unionfs/debug.c                             |    2 
 fs/unionfs/dentry.c                            |   31 +++++++----
 fs/unionfs/file.c                              |   18 +-----
 fs/unionfs/inode.c                             |   29 +++++------
 fs/unionfs/mmap.c                              |   65 ++++++++-----------------
 fs/unionfs/rdstate.c                           |    4 -
 fs/unionfs/rename.c                            |    4 -
 fs/unionfs/super.c                             |    6 +-
 fs/unionfs/union.h                             |    5 +
 fs/unionfs/xattr.c                             |    8 +--
 12 files changed, 115 insertions(+), 122 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
