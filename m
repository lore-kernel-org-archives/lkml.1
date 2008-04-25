Return-Path: <linux-kernel-owner+w=401wt.eu-S933213AbYDYWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213AbYDYWZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763048AbYDYWT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:19:57 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40558 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762537AbYDYWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:19:55 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/12 Unionfs updates/fixes/cleanups
Date: Fri, 25 Apr 2008 18:18:56 -0400
Message-Id: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patchsets related to Unionfs.  It includes
fixes to a few races discovered since moving to vm_ops->fault, and one small
optimiztion (skip copyup for when a file is opened for writing but no
writing takes place).

These patches were tested (where appropriate) on v2.6.25-4569-gb69d398, MM
(mmotm 2008-04-19-01-17), as well as the backports to
2.6.{25,24,23,22,21,20,19,18,9} on ext2/3/4, xfs (limited testing -- xfs was
oopsing a lot), reiserfs, nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and
squashfs (where available).  Also tested with LTP-full-20080229 and with a
continuous parallel kernel compile (while forcing cache flushing,
manipulating lower branches, etc.).  See http://unionfs.filesystems.org/ to
download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (12):
      Unionfs: minor code cleanups
      Unionfs: prevent races in unionfs_fault
      Unionfs: copy lower times in fsync/fasync only when needed
      Unionfs: lock inode around calls to notify_change()
      Unionfs: stop as soon as first writeable branch is found
      Unionfs: don't dereference dentry without lower branches in d_release
      Unionfs: set append offset correctly for copied-up files
      Unionfs: copyup only if file is being written to
      Unionfs: reorganize file_revalidate for un/locking callers
      Unionfs: maintain one-open-file invariant for non-directories
      Unionfs: set lower file to NULL in file_release
      Unionfs: lock parent dentry branch config in write

 commonfops.c |  248 ++++++++++++++++++++++++++++++++++++++---------------------
 copyup.c     |    2 
 dentry.c     |    4 
 file.c       |   32 +++----
 inode.c      |   43 ++++------
 mmap.c       |   21 +++-
 union.h      |    2 
 7 files changed, 216 insertions(+), 136 deletions(-)

Thanks.
---
Erez Zadok
ezk@cs.sunysb.edu
