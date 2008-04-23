Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbYDWAWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbYDWAWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 20:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYDWAWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 20:22:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbYDWAWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 20:22:21 -0400
Date: Wed, 23 Apr 2008 01:22:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] VFS patches (second series)
Message-ID: <20080423002219.GW27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	More namespace.c sanitizing (saner locking rules, further trimming
of stack footprint).  Preparation for mountinfo merge (allowing seq_file
->show() to tell seq_file that output for this entry is to be discarded).
A couple of fixes - one for long-standing race in /proc/*/fd readdir,
another for breakage introduced on pipe() failure exit in ro-bind series
(this one is probably the most urgent in the entire pile).  And misc
cleanups...

	There will be probably 3 or 4 more series in this cycle - this
is not the last one...

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (9):
      move a bunch of declarations to fs/internal.h
      lock exclusively in collect_mounts() and drop_collected_mounts()
      switch a bunch of LSM hooks from nameidata to path
      get rid of more nameidata passing in namespace.c
      umount_tree() will unhash everything itself
      teach seq_file to discard entries
      double-free of inode on alloc_file() failure exit in create_write_pipe()
      proc_readfd_common() race fix
      get rid of __exit_files(), __exit_fs() and __put_fs_struct()

Diffstat:
 fs/internal.h              |   11 +++++++
 fs/namespace.c             |   66 +++++++++++++++++++++----------------------
 fs/pipe.c                  |    3 ++
 fs/pnode.c                 |    4 +-
 fs/pnode.h                 |    1 +
 fs/proc/base.c             |    4 +--
 fs/seq_file.c              |   16 ++++++++--
 fs/super.c                 |    1 +
 include/linux/dcache.h     |    1 -
 include/linux/fs.h         |    6 ----
 include/linux/mount.h      |    2 -
 include/linux/security.h   |   52 +++++++++++++++++-----------------
 include/linux/seq_file.h   |    2 +
 kernel/exit.c              |   27 ++++--------------
 security/dummy.c           |   10 +++---
 security/security.c        |   20 ++++++------
 security/selinux/hooks.c   |    8 ++--
 security/smack/smack_lsm.c |    4 +-
 18 files changed, 118 insertions(+), 120 deletions(-)
