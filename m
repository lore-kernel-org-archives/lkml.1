Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbXGVOL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbXGVOL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGVOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:11:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49943 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbXGVOLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:11:48 -0400
Date: Sun, 22 Jul 2007 15:11:47 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] misc audit
Message-ID: <20070722141147.GZ21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

... aka conservative part of audit tree; the rest would better spend a bit
in -mm.  Please pull from

git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b39

Al Viro (1):
      get rid of AVC_PATH postponed treatment
Eric Paris (1):
      allow audit filtering on bit & operations
Klaus Weidner (1):
      audit: fix broken class-based syscall audit
Steve Grubb (1):
      Make IPC mode consistent
 include/linux/audit.h  |   32 ++++++++++++++++--------------
 kernel/auditfilter.c   |   13 +++++++++++-
 kernel/auditsc.c       |   51 +----------------------------------------------
 security/selinux/avc.c |   15 +++++++------
 4 files changed, 39 insertions(+), 72 deletions(-)

More questionable stuff is in 
git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ mm.b39
and that one is -mm fodder.  Again, *that* branch is not for immediate
mainline merge; there (on top of audit.b39)
Al Viro (5):
      pass dentry to audit_inode()/audit_inode_child()
      new helpers - collect_mounts() and release_collected_mounts()
      new helper - inotify_clone_watch()
      new helper - inotify_evict_watch()
      audit: watching subtrees
 fs/dcache.c              |    2 +-
 fs/debugfs/inode.c       |    2 +-
 fs/inotify.c             |   43 +++
 fs/namei.c               |   10 +-
 fs/namespace.c           |   22 ++-
 fs/open.c                |    4 +-
 fs/pnode.h               |    1 +
 fs/xattr.c               |    8 +-
 include/linux/audit.h    |   19 +-
 include/linux/dcache.h   |    1 +
 include/linux/fs.h       |    2 +
 include/linux/fsnotify.h |    9 +-
 include/linux/inotify.h  |    2 +
 ipc/mqueue.c             |    8 +-
 kernel/Makefile          |    2 +-
 kernel/audit.c           |   82 +++++
 kernel/audit.h           |   22 ++-
 kernel/audit_tree.c      |  887 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditfilter.c     |   43 ++-
 kernel/auditsc.c         |  215 +++++++++++-
 20 files changed, 1343 insertions(+), 41 deletions(-)
 create mode 100644 kernel/audit_tree.c

