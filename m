Return-Path: <linux-kernel-owner+w=401wt.eu-S1752740AbXJAFv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbXJAFv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXJAFvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40587 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbXJAFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:13 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org
Subject: [GIT PULL -mm] 00/19 Unionfs updates/cleanups/fixes
Date: Mon,  1 Oct 2007 01:50:37 -0400
Message-Id: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following is a series of patches related to Unionfs.  The main changes
here are compliance with coding style and assorted cleanups, based on lkml
comments and advise.  Specifically, the un/likely updates from the previous
series of patches was completely redone; the number of un/likely instances
was reduced from 546 to 163 and what's left are considered highly unlikely
(99% or higher threshold).

These patches were tested (where appropriate) on our 2.6.23-rc8 latest code,
as well as the backports to 2.6.{22,21,20,19,18,9} on ext2/3/4, xfs,
reiserfs, nfs2/3/4, jffs2, ramfs, tmpfs, cramfs, and squashfs (where
available).  See http://unionfs.filesystems.org/ to download backported
unionfs code.

Please pull from the 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/ezk/unionfs.git

to receive the following:

Erez Zadok (19):
      Unionfs: compile if debug is off
      Unionfs: add un/likely on conditionals
      Unionfs: minor comment cleanups
      Unionfs: use consistent printk prefixes
      Unionfs: use UNIONFS_NAME macro
      Unionfs: properly indent static struct
      Unionfs: remove unnecessary if condition
      Unionfs: use page_offset() helper
      Unionfs: use pr_debug() instead of custom dprintk()
      Unionfs: convert all appropriate printk's to pr_debug calls
      Unionfs: add missing newlines in printk's
      Unionfs: update/assign a KERN_* level to all printk statements
      Unionfs: remove periods from the end of printk strings
      Unionfs: use braces in both branches of conditionals
      Unionfs: coding style: proper spacing
      Unionfs: coding style: take assignments out of "if" conditions
      Unionfs: coding style: avoid multiple assignments on same line
      Unionfs: coding style: miscellaneous fixes
      Unionfs: coding style: avoid lines longer than 80 chars

 Makefile     |    4 
 commonfops.c |   86 ++++++------
 copyup.c     |   31 ++--
 debug.c      |  406 +++++++++++++++++++++++++++++------------------------------
 dentry.c     |   66 ++++-----
 dirfops.c    |   32 ++--
 dirhelper.c  |   13 +
 fanout.h     |   11 +
 file.c       |   29 ++--
 inode.c      |   82 ++++++-----
 lookup.c     |   29 ++--
 main.c       |   80 ++++++-----
 mmap.c       |   18 +-
 rdstate.c    |   18 +-
 rename.c     |   59 ++++----
 subr.c       |   13 +
 super.c      |  102 +++++++-------
 union.h      |   52 +++----
 unlink.c     |   22 +--
 xattr.c      |   16 +-
 20 files changed, 622 insertions(+), 547 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
