Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXIZD1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXIZD1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 23:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbXIZD11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 23:27:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34318 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXIZD1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 23:27:25 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/25 Unionfs updates/cleanups/fixes
Date: Tue, 25 Sep 2007 23:09:39 -0400
Message-Id: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  Aside from a few
minor cleanups/fixes, the two main changes are (1) lower nameidata support
so we can stack on nfsv4, and (2) un/likely optimizations.  These patches
were tested (where appropriate) on our 2.6.23-rc8 latest code, as well as
the backports to 2.6.{22,21,20,19,18,9} on ext2/3/4, xfs, reiserfs,
nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and squashfs (where available).  See
http://unionfs.filesystems.org/ to download backported unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (22):
      Unionfs: display informational messages only if debug is on
      Unionfs: cast page->index loff_t before shifting
      Unionfs: minor coding style updates
      Unionfs: add lower nameidata debugging support
      Unionfs: lower nameidata support for nfsv4
      Unionfs: add un/likely conditionals on common fileops
      Unionfs: add un/likely conditionals on copyup ops
      Unionfs: add un/likely conditionals on debug ops
      Unionfs: add un/likely conditionals on dentry ops
      Unionfs: add un/likely conditionals on dir ops
      Unionfs: add un/likely conditionals on headers
      Unionfs: add un/likely conditionals on fileops
      Unionfs: add un/likely conditionals on inode ops
      Unionfs: add un/likely conditionals on lookup ops
      Unionfs: add un/likely conditionals on super ops
      Unionfs: add un/likely conditionals on mmap ops
      Unionfs: add un/likely conditionals on rename ops
      Unionfs: add un/likely conditionals on readdir ops
      Unionfs: add un/likely conditionals on common subr
      Unionfs: add un/likely conditionals on unlink ops
      Unionfs: add un/likely conditionals on xattr ops
      Unionfs: use poison.h for safe poison pointers

Josef 'Jeff' Sipek (2):
      Unionfs: Simplify unionfs_get_nlinks
      Unionfs: Remove unused #defines

Olivier Blin (1):
      Unionfs: cache-coherency fixes

 commonfops.c |   98 +++++++++++++++----------------
 copyup.c     |  102 ++++++++++++++++----------------
 debug.c      |  140 ++++++++++++++++++++++++++------------------
 dentry.c     |   87 +++++++++++++++------------
 dirfops.c    |   22 +++---
 dirhelper.c  |   30 ++++-----
 fanout.h     |   13 ++--
 file.c       |   38 ++++++------
 inode.c      |  186 +++++++++++++++++++++++++++++++----------------------------
 lookup.c     |   60 +++++++++++--------
 main.c       |  102 ++++++++++++++++----------------
 mmap.c       |   33 +++++-----
 rdstate.c    |   15 ++--
 rename.c     |   96 +++++++++++++++---------------
 sioq.c       |    4 -
 subr.c       |   67 ++++++---------------
 super.c      |   90 ++++++++++++++--------------
 union.h      |   19 +++---
 unlink.c     |   32 +++++-----
 xattr.c      |   12 +--
 20 files changed, 647 insertions(+), 599 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
