Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbXKZQpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbXKZQpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXKZQpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:08 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52740 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXKZQpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:07 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/16 Unionfs updates/fixes/cleanups
Date: Mon, 26 Nov 2007 11:43:57 -0500
Message-Id: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  The main changes
here are bug fixes (mostly discovered using ltp-full-20071031), as well as
full support for splice(2) and swapon(2).

These patches were tested (where appropriate) on Linus's 2.6.24 latest code
(as of v2.6.24-rc3-19-g2ffbb83), MM (mmotm-2007-11-21-16-25), as well as the
backports to 2.6.{23,22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs, nfs2/3/4,
jffs2, ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download back-ported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (15):
      Unionfs: use f_path instead of f_dentry/mnt
      Unionfs: minor coding standards applied
      Unionfs: minor cleanup in the debugging infrastructure
      Unionfs: set lower mnt after mkdir which resulted in copyup
      Unionfs: handle whiteouts more efficiently in filldir
      Unionfs: remove useless debugging messages
      Unionfs: release lower resources on successful rmdir
      Unionfs: don't create whiteouts on rightmost branch
      Unionfs: create opaque directories' whiteouts unconditionally
      Unionfs: update times in setattr
      Unionfs: reintroduce a bmap method
      Unionfs: support splice(2)
      Unionfs: prevent multiple writers to lower_page
      Unionfs: update our inode size correctly upon partial write
      Unionfs: use generic_file_aio_read/write

Hugh Dickins (1):
      Unionfs: minor cleanup in writepage

 commonfops.c |    5 ----
 copyup.c     |    4 +--
 debug.c      |   66 +++++++++++++++++++++++++++--------------------------------
 dentry.c     |   15 ++-----------
 dirfops.c    |   18 +++++++++++-----
 dirhelper.c  |    2 -
 fanout.h     |    2 -
 file.c       |   28 ++-----------------------
 inode.c      |   19 +++++++++++++++-
 mmap.c       |   52 +++++++++++++++++++++++++++++++++++-----------
 rdstate.c    |   11 ++++++---
 subr.c       |   14 ++++++++++++
 union.h      |    3 +-
 unlink.c     |   56 ++++++++++++++++++++++++++++++++++++++++++--------
 14 files changed, 182 insertions(+), 113 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
