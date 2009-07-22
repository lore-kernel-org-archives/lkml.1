Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZGVTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZGVTro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZGVTrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 15:47:36 -0400
Received: from cobra.newdream.net ([66.33.216.30]:48714 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbZGVTre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 15:47:34 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/19] ceph: Ceph distributed file system client v0.11
Date: Wed, 22 Jul 2009 12:51:34 -0700
Message-Id: <1248292313-31326-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v0.11 of the Ceph distributed file system client.  This set
addresses issues brought up last week, and adds/cleans up a lot of the
inline comments.  Thanks to Andi Kleen, Chris Wright, J Bruce Fields,
and Trond Myklebust for their feedback last time around.

Changes since v0.10:
 - killed max file size #define, now server-specified
 - simplified debug macro (use pr_debug) 
 - added a few missing '__attribute__ ((packed))'
 - kcalloc throughout
 - simplified export.c, now with useful comments
 - cleaned up mount code
 - kmem_cache for ceph_dentry_info, ceph_file_info
 - EBADF on bad caps (failed or partial reconnect to unresponsive server)
 - fixed a stray unaligned access
 - respond to control-c on slow/hung mount
 - some message encoding improvements to streamline future revisions
 - many more comments, some code cleanup

As before, my main question is: what would people like to see for this
to be merged into fs/?

Thanks-
sage

---
 Documentation/filesystems/ceph.txt |  140 ++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/ceph/Kconfig                    |   26 +
 fs/ceph/Makefile                   |   35 +
 fs/ceph/addr.c                     | 1092 ++++++++++++++
 fs/ceph/caps.c                     | 2642 +++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |   34 +
 fs/ceph/ceph_fs.h                  |  918 ++++++++++++
 fs/ceph/ceph_ver.h                 |    6 +
 fs/ceph/crush/crush.c              |  140 ++
 fs/ceph/crush/crush.h              |  188 +++
 fs/ceph/crush/hash.h               |   90 ++
 fs/ceph/crush/mapper.c             |  606 ++++++++
 fs/ceph/crush/mapper.h             |   20 +
 fs/ceph/debugfs.c                  |  462 ++++++
 fs/ceph/decode.h                   |  136 ++
 fs/ceph/dir.c                      | 1173 +++++++++++++++
 fs/ceph/export.c                   |  222 +++
 fs/ceph/file.c                     |  814 +++++++++++
 fs/ceph/inode.c                    | 2376 ++++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   64 +
 fs/ceph/ioctl.h                    |   12 +
 fs/ceph/mds_client.c               | 2833 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  325 +++++
 fs/ceph/mdsmap.c                   |  139 ++
 fs/ceph/mdsmap.h                   |   47 +
 fs/ceph/messenger.c                | 2367 ++++++++++++++++++++++++++++++
 fs/ceph/messenger.h                |  253 ++++
 fs/ceph/mon_client.c               |  478 ++++++
 fs/ceph/mon_client.h               |  103 ++
 fs/ceph/msgr.h                     |  156 ++
 fs/ceph/osd_client.c               | 1008 +++++++++++++
 fs/ceph/osd_client.h               |  125 ++
 fs/ceph/osdmap.c                   |  697 +++++++++
 fs/ceph/osdmap.h                   |   83 ++
 fs/ceph/rados.h                    |  419 ++++++
 fs/ceph/snap.c                     |  887 +++++++++++
 fs/ceph/super.c                    | 1162 +++++++++++++++
 fs/ceph/super.h                    |  955 ++++++++++++
 fs/ceph/types.h                    |   27 +
 41 files changed, 23262 insertions(+), 0 deletions(-)
