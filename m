Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbYAZFGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbYAZFGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 00:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYAZFFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 00:05:43 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47439 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbYAZFFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 00:05:25 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 0/4 Unionfs updates/fixes/cleanups
Date: Sat, 26 Jan 2008 00:04:58 -0500
Message-Id: <12013239022656-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  This is the
fifth set of patchsets resulting from an lkml review of the entire unionfs
code base, in preparation for a merge into mainline.  The most significant
changes here are a few locking related fixes, and a correction to broken
logic which didn't allow writing to the first available writable branch.

These patches were tested (where appropriate) on 2.6.24, MM, as well as the
backports to 2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4,
jffs2, ramfs, tmpfs, cramfs, and squashfs (where available).  Also tested
with LTP-full and with a continuous parallel kernel compile (while forcing
cache flushing, manipulating lower branches, etc.).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (4):
      Unionfs: use first writable branch (fix/cleanup)
      Unionfs: remove unnecessary call to d_iput
      Unionfs: d_parent related locking fixes
      Unionfs: lock_rename related locking fixes

 copyup.c |   16 --
 inode.c  |  395 ++++++++++++++++++++++++---------------------------------------
 rename.c |   16 ++
 union.h  |    4 
 4 files changed, 174 insertions(+), 257 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
