Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYAJCRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYAJCRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYAJCQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:16:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37428 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYAJCQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:16:51 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/4 Unionfs updates/fixes/cleanups
Date: Wed,  9 Jan 2008 21:16:28 -0500
Message-Id: <1199931392670-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  This is the
fourth set of patchsets resulting from an lkml review of the entire unionfs
code base, in preparation for a merge into mainline.  The most significant
changes here are a few locking/race bugfix related to branch-management.

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc7-71-gfd0b45d), MM, as well as the backports to
2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4, jffs2,
ramfs, tmpfs, cramfs, and squashfs (where available).  Also tested with
LTP-full and with a continuous parallel kernel compile (while forcing cache
flushing, manipulating lower branches, etc.).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (4):
      Unionfs: merged several printk KERN_CONT together into one pr_debug
      Unionfs: mmap fixes
      Unionfs: branch-management related locking fixes
      Unionfs: ensure we have lower dentries in d_iput

 commonfops.c |    6 ++++++
 debug.c      |   51 +++++++++++++++++++++++++--------------------------
 dentry.c     |    9 +++++++--
 inode.c      |   17 +++++++++++++++++
 mmap.c       |   26 +++++++++++++++++++++-----
 5 files changed, 76 insertions(+), 33 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
