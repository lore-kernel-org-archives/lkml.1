Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbXJLHuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbXJLHuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXJLHur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:50:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbXJLHuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:50:46 -0400
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <11914877842142-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 12 Oct 2007 08:47:59 +0100
Message-Id: <1192175279.1068.394.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There have been no changes since I posted the patches for review a few
days ago. Please consider pulling the following changes from the
GFS2/DLM -nmw git tree:

The following changes since commit bbf25010f1a6b761914430f5fca081ec8c7accd1:
  Linus Torvalds (1):
        Linux 2.6.23

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Abhijith Das (5):
      [GFS2] Force unstuff of hidden quota inode
      [GFS2] Fix quota do_list operation hang
      [GFS2] Wendy's dump lockname in hex & fix glock dump
      [GFS2] panic after can't parse mount arguments
      [GFS2] flocks from same process trip kernel BUG at fs/gfs2/glock.c:1118!

Benjamin Marzinski (3):
      [GFS2] Add NULL entry to token table
      [GFS2] delay glock demote for a minimum hold time
      [GFS2] Alternate gfs2_iget to avoid looking up inodes being freed

Bob Peterson (9):
      [GFS2] Move some code inside the log lock
      [GFS2] Revert part of earlier log.c changes
      [GFS2] Prevent infinite loop in try_rgrp_unlink()
      [GFS2] Detach buf data during in-place writeback
      [GFS2] invalid metadata block - REVISED
      [GFS2] Ensure journal file cache is flushed after recovery
      [GFS2] Patch to protect sd_log_num_jdata
      [GFS2] Fix ordering of dirty/journal for ordered buffer unstuffing
      [GFS2] GFS2: chmod hung - fix race in thread creation

David Teigland (1):
      [DLM] block dlm_recv in recovery transition

Denis Cheng (7):
      [GFS2] use an temp variable to reduce a spin_unlock
      [GFS2] mark struct *_operations const
      [GFS2] use the declaration of gfs2_dops in the header file instead
      [GFS2] use list_for_each_entry instead
      [GFS2] unneeded typecast
      [GFS2] better code for translating characters
      [GFS2] fixed a NULL pointer assignment BUG

Jesper Juhl (1):
      [GFS2] Clean up duplicate includes in fs/gfs2/

Josef Whiter (1):
      [GFS2] Fix calculation of demote state

Patrick Caulfield (3):
      [DLM] Fix lowcomms socket closing
      [DLM] Make dlm_sendd cond_resched more
      [DLM] don't overwrite castparam if it's NULL

Steve French (1):
      [GFS2] GFS2 not checking pointer on create when running under nfsd

Steven Whitehouse (16):
      [GFS2] Fix two races relating to glock callbacks
      [GFS2] Fix an oops in glock dumping
      [GFS2] Reduce number of gfs2_scand processes to one
      [GFS2] Clean up invalidatepage/releasepage
      [GFS2] Add a missing gfs2_trans_add_bh()
      [GFS2] Correct lock ordering in unlink
      [GFS2] Introduce gfs2_remove_from_ail
      [GFS2] Don't mark jdata dirty in gfs2_unstuffer_page()
      [GFS2] Move pin/unpin into lops.c, clean up locking
      [GFS2] Clean up ordered write code
      [GFS2] Replace revoke structure with bufdata structure
      [GFS2] Use slab operations for all gfs2_bufdata allocations
      [GFS2] Clean up gfs2_trans_add_revoke()
      [GFS2] Clean up journaled data writing
      [GFS2] Don't try to remove buffers that don't exist
      [GFS2] Get superblock a different way

Wendy Cheng (4):
      [GFS2] Reduce truncate IO traffic
      [GFS2] fix inode meta data corruption
      [GFS2] Move inode deletion out of blocking_cb
      [GFS2] Data corruption fix

 fs/dlm/dlm_internal.h          |    1 +
 fs/dlm/lock.c                  |  142 +++++++-----
 fs/dlm/lock.h                  |    3 +-
 fs/dlm/lockspace.c             |    1 +
 fs/dlm/lowcomms.c              |   23 +--
 fs/dlm/member.c                |   41 +++--
 fs/dlm/midcomms.c              |   17 +--
 fs/dlm/rcom.c                  |   36 +---
 fs/dlm/rcom.h                  |    5 +-
 fs/dlm/recoverd.c              |   11 +-
 fs/dlm/requestqueue.c          |   58 ++---
 fs/dlm/requestqueue.h          |    4 +-
 fs/gfs2/bmap.c                 |   35 +++-
 fs/gfs2/daemon.c               |   24 --
 fs/gfs2/daemon.h               |    1 -
 fs/gfs2/dir.c                  |    3 +-
 fs/gfs2/eaops.c                |    8 +-
 fs/gfs2/eaops.h                |    4 +-
 fs/gfs2/glock.c                |  293 ++++++++++++++++---------
 fs/gfs2/glock.h                |    5 +-
 fs/gfs2/glops.c                |   24 +--
 fs/gfs2/incore.h               |   31 ++--
 fs/gfs2/inode.c                |   78 ++++++-
 fs/gfs2/inode.h                |    3 +-
 fs/gfs2/locking/dlm/lock_dlm.h |    1 -
 fs/gfs2/locking/dlm/plock.c    |   11 +-
 fs/gfs2/locking/dlm/thread.c   |   20 +-
 fs/gfs2/locking/nolock/main.c  |    1 -
 fs/gfs2/log.c                  |  230 +++++++++++++-------
 fs/gfs2/log.h                  |    2 +
 fs/gfs2/lops.c                 |  470 ++++++++++++++++++++--------------------
 fs/gfs2/main.c                 |    3 +
 fs/gfs2/meta_io.c              |  136 +++---------
 fs/gfs2/meta_io.h              |    6 +-
 fs/gfs2/mount.c                |    5 +-
 fs/gfs2/ops_address.c          |  146 ++++---------
 fs/gfs2/ops_export.c           |    2 +-
 fs/gfs2/ops_file.c             |   13 +-
 fs/gfs2/ops_fstype.c           |   40 ++--
 fs/gfs2/ops_inode.c            |   38 +++-
 fs/gfs2/ops_super.c            |   14 +-
 fs/gfs2/quota.c                |   13 +
 fs/gfs2/recovery.c             |    2 +-
 fs/gfs2/rgrp.c                 |   39 ++--
 fs/gfs2/super.c                |    1 -
 fs/gfs2/sys.c                  |    2 -
 fs/gfs2/trans.c                |   22 +-
 fs/gfs2/trans.h                |    2 +-
 include/linux/gfs2_ondisk.h    |   30 +++-
 49 files changed, 1139 insertions(+), 961 deletions(-)


