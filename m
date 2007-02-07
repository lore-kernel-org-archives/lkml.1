Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXBGNLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXBGNLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030205AbXBGNLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:11:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965564AbXBGNLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:11:43 -0500
Subject: [GFS2 & DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Wed, 07 Feb 2007 13:20:26 +0000
Message-Id: <1170854426.11001.432.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 & DLM changes. They are as per
the patches posted recently on lkml, except for three minor changes
(two small bug fixes and a function which should have been static) which
are marked with [*] in the list below. All the other patches have
been in -mm, most of them for a number of weeks. None of the patches touch
any code outside the gfs2 and dlm directories,

Steve.

The following changes since commit 62d0cfcb27cf755cebdc93ca95dabc83608007cd:
  Linus Torvalds (1):
        Linux 2.6.20

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Adrian Bunk (4):
      [DLM] fs/dlm/lowcomms-tcp.c: remove 2 functions
      [GFS2] make gfs2_change_nlink_i() static
      [GFS2/DLM] fix GFS2 circular dependency
      [GFS2] make gfs2_writepages() static [*]

David Teigland (18):
      [GFS2] don't try to lockfs after shutdown
      [DLM] fix resend rcom lock
      [DLM] fix old rcom messages
      [DLM] add version check
      [DLM] fix send_args() lvb copying
      [DLM] fix receive_request() lvb copying
      [DLM] fix lost flags in stub replies
      [DLM] change some log_error to log_debug
      [DLM] rename dlm_config_info fields
      [DLM] add config entry to enable log_debug
      [DLM] expose dlm_config_info fields in configfs
      [DLM] fix user unlocking
      [DLM] fix master recovery
      [DLM] saved dlm message can be dropped
      [DLM] can miss clearing resend flag
      [GFS2] increase default lock limit
      [GFS2] make lock_dlm drop_count tunable in sysfs
      [DLM] zero new user lvbs

Eric Sandeen (2):
      [GFS2] use CURRENT_TIME_SEC instead of get_seconds in gfs2
      [GFS2] more CURRENT_TIME_SEC

Patrick Caulfield (7):
      [DLM] Fix schedule() calls
      [DLM] Fix spin lock already unlocked bug
      [DLM] Use workqueues for dlm lowcomms
      [DLM] lowcomms tidy
      [DLM] fix lowcomms receiving
      [DLM] Make sock_sem into a mutex
      [DLM] fix softlockup in dlm_recv

Randy Dunlap (2):
      [GFS2/DLM] use sysfs
      [DLM/GFS2] indent help text

Robert Peterson (1):
      [GFS2] gfs2 knows of directories which it chooses not to display

Russell Cattelan (2):
      [GFS2] BZ 217008 fsfuzzer fix.
      [GFS2] Fix unlink deadlocks

S. Wendy Cheng (2):
      [GFS2] Fix change nlink deadlock
      [GFS2] Fix gfs2_rename deadlock

Steven Whitehouse (18):
      [GFS2] Fix DIO deadlock
      [GFS2] Fail over to readpage for stuffed files
      [GFS2] Fix ordering of page disposal vs. glock_dq
      [GFS2] Add writepages for "data=writeback" mounts
      [GFS2] Clean up/speed up readdir
      [GFS2] Remove max_atomic_write tunable
      [GFS2] Shrink gfs2_inode memory by half
      [GFS2] Remove the "greedy" function from glock.[ch]
      [GFS2] Remove unused go_callback operation
      [GFS2] Remove local exclusive glock mode
      [GFS2] Tidy up glops calls
      [GFS2] Remove queue_empty() function
      [GFS2] Compile fix for glock.c
      [GFS2] Fix typo in glock.c
      [GFS2] Fix recursive locking attempt with NFS
      [GFS2] Fix list corruption in lops.c
      [GFS2] Put back semaphore to avoid umount problem
      [GFS2] Unlock page on prepare_write try lock failure [*]

Wendy Cheng (1):
      [GFS2] nfsd readdirplus assertion failure [*]

 fs/dlm/Kconfig                 |   18 +-
 fs/dlm/config.c                |  154 ++++++++++++++++--
 fs/dlm/config.h                |   17 +-
 fs/dlm/dlm_internal.h          |   20 ++-
 fs/dlm/lock.c                  |   87 +++++++---
 fs/dlm/lockspace.c             |   10 +-
 fs/dlm/lowcomms-sctp.c         |  151 ++++++++---------
 fs/dlm/lowcomms-tcp.c          |  361 +++++++++++-----------------------------
 fs/dlm/midcomms.c              |    4 +-
 fs/dlm/rcom.c                  |   85 ++++++----
 fs/dlm/recover.c               |    8 +-
 fs/dlm/recoverd.c              |   22 ++--
 fs/dlm/user.c                  |    9 +
 fs/dlm/util.c                  |    4 +
 fs/gfs2/Kconfig                |   47 +++---
 fs/gfs2/bmap.c                 |   10 +-
 fs/gfs2/dir.c                  |   25 ++--
 fs/gfs2/dir.h                  |   21 +--
 fs/gfs2/eattr.c                |    8 +-
 fs/gfs2/glock.c                |  316 +++++++++---------------------------
 fs/gfs2/glock.h                |   11 --
 fs/gfs2/glops.c                |  136 +++++----------
 fs/gfs2/incore.h               |   18 +--
 fs/gfs2/inode.c                |   61 ++++----
 fs/gfs2/lm.c                   |    8 +-
 fs/gfs2/locking/dlm/lock_dlm.h |    2 +-
 fs/gfs2/locking/dlm/main.c     |    6 -
 fs/gfs2/locking/dlm/mount.c    |    6 +-
 fs/gfs2/locking/dlm/sysfs.c    |   13 ++
 fs/gfs2/lops.c                 |   14 ++-
 fs/gfs2/ops_address.c          |  134 +++++++++------
 fs/gfs2/ops_dentry.c           |   16 ++-
 fs/gfs2/ops_export.c           |   15 +-
 fs/gfs2/ops_file.c             |   52 +------
 fs/gfs2/ops_inode.c            |   55 +++++--
 fs/gfs2/ops_super.c            |   11 +-
 fs/gfs2/ops_vm.c               |   24 +---
 fs/gfs2/super.c                |   16 +--
 fs/gfs2/sys.c                  |   10 -
 39 files changed, 866 insertions(+), 1119 deletions(-)


