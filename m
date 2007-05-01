Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXEAOQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXEAOQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 10:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbXEAOQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 10:16:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbXEAOQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 10:16:17 -0400
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 15:11:39 +0100
Message-Id: <1178028699.5462.209.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches from the GFS2/DLM -nmw git tree,

Steve.



The following changes since commit dc87c3985e9b442c60994308a96f887579addc39:
  Linus Torvalds (1):
        libata: honour host controllers that want just one host

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Adrian Bunk (1):
      [DLM] fs/dlm/ast.c should #include "ast.h"

Benjamin Marzinski (2):
      [GFS2] Fix log entry list corruption
      [GFS2] flush the log if a transaction can't allocate space

David Teigland (8):
      [DLM] overlapping cancel and unlock
      [GFS2] use log_error before LM_OUT_ERROR
      [DLM] split create_message function
      [DLM] add orphan purging code (1/2)
      [DLM] interface for purge (2/2)
      [DLM] change lkid format
      [DLM] fix mode munging
      [DLM] lowcomms style

Josef Bacik (2):
      [DLM] Fix dlm_lowcoms_stop hang
      [GFS2] use lib/parser for parsing mount options

Josef Whiter (2):
      [GFS2] fix bz 231369, gfs2 will oops if you specify an invalid mount option
      [GFS2] Fix bz 231380, unlock page before dequeing glocks in gfs2_commit_write

Patrick Caulfield (6):
      [DLM] Fix uninitialised variable in receiving
      [DLM] Don't delete misc device if lockspace removal fails
      [DLM] fix coverity-spotted stupidity
      [DLM] Remove redundant assignment
      [DLM] Consolidate transport protocols
      [DLM] Lowcomms nodeid range & initialisation fixes

Robert Peterson (4):
      [GFS2] Add gfs2_tool lockdump support to gfs2 (bz 228540)
      [GFS2] Red Hat bz 228540: owner references
      [GFS2] bz 236008: Kernel gpf doing cat /debugfs/gfs2/xxx (lock dump)
      [GFS2] lockdump improvements

Steven Whitehouse (8):
      [GFS2] Fix bz 224480 and cleanup glock demotion code
      [GFS2] Fix a bug on i386 due to evaluation order
      [GFS2] Speed up lock_dlm's locking (move sprintf)
      [GFS2] Set drop_count to 0 (off) by default
      [GFS2] Fix bz 234168 (ignoring rgrp flags)
      [GFS2] Patch to detect corrupt number of dir entries in leaf and/or inode blocks
      [GFS2] Patch to fix mmap of stuffed files
      [GFS2] Uncomment sprintf_symbol calling code

akpm@linux-foundation.org (1):
      [GFS2] printk warning fixes

 fs/dlm/Kconfig                 |   31 +-
 fs/dlm/Makefile                |    6 +-
 fs/dlm/ast.c                   |    1 +
 fs/dlm/config.c                |   10 +-
 fs/dlm/config.h                |    3 +-
 fs/dlm/dlm_internal.h          |   11 +-
 fs/dlm/lock.c                  |  955 ++++++++++++++++++++------
 fs/dlm/lock.h                  |    2 +
 fs/dlm/lockspace.c             |    4 +-
 fs/dlm/lowcomms-sctp.c         | 1210 --------------------------------
 fs/dlm/lowcomms-tcp.c          | 1007 ---------------------------
 fs/dlm/lowcomms.c              | 1475 ++++++++++++++++++++++++++++++++++++++++
 fs/dlm/user.c                  |  163 +++--
 fs/gfs2/dir.c                  |   38 +-
 fs/gfs2/glock.c                |  619 ++++++++++-------
 fs/gfs2/glock.h                |    8 +-
 fs/gfs2/incore.h               |   14 +-
 fs/gfs2/locking/dlm/lock.c     |   14 +-
 fs/gfs2/locking/dlm/lock_dlm.h |    3 +-
 fs/gfs2/lops.c                 |   20 +-
 fs/gfs2/main.c                 |    4 +-
 fs/gfs2/mount.c                |  239 ++++---
 fs/gfs2/ops_address.c          |   21 +-
 fs/gfs2/ops_fstype.c           |    4 +
 fs/gfs2/ops_super.c            |   28 +-
 fs/gfs2/rgrp.c                 |   12 +-
 include/linux/dlm_device.h     |    9 +-
 27 files changed, 3005 insertions(+), 2906 deletions(-)
 delete mode 100644 fs/dlm/lowcomms-sctp.c
 delete mode 100644 fs/dlm/lowcomms-tcp.c
 create mode 100644 fs/dlm/lowcomms.c


