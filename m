Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZIVRlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZIVRlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZIVRlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:41:05 -0400
Received: from cobra.newdream.net ([66.33.216.30]:41668 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbZIVRlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:41:04 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Cc: yehuda@newdream.net, Sage Weil <sage@newdream.net>
Subject: [PATCH 00/21] ceph distributed file system client
Date: Tue, 22 Sep 2009 10:38:28 -0700
Message-Id: <1253641129-28434-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v0.15 of the Ceph distributed file system client.  Changes since
v0.14:

 - checkpatch, sparse cleanups
 - ioctl number documented
 - some message api simplifications, avoiding more memory allocations
 - message pools to avoid additional ENOMEM situations
 - new ioctl to determine object name and location/address for given file offset
 - osd failure handling bug fix
 - debugfs cleanups

I've pretty much run out of substantiative feedback to address with
this code.  There are a few more memory preallocation issues I am
continuing to look at, but I don't think they are show stoppers.  The
code has been running on my test cluster for the last week without
problems, and would greatly benefit from broader testing.

Any additional review, or suggestions for how to get this merged are
much appreciated.

Thanks-
sage

Kernel client git tree:
        git://ceph.newdream.net/linux-ceph-client.git

System:
	git://ceph.newdream.net/ceph.git

---
 Documentation/filesystems/ceph.txt   |  140 ++
 Documentation/ioctl/ioctl-number.txt |    1 +
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/ceph/Kconfig                      |   26 +
 fs/ceph/Makefile                     |   35 +
 fs/ceph/addr.c                       | 1117 +++++++++++++
 fs/ceph/buffer.h                     |   83 +
 fs/ceph/caps.c                       | 2800 ++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h                 |   35 +
 fs/ceph/ceph_fs.h                    |  937 +++++++++++
 fs/ceph/ceph_ver.h                   |    6 +
 fs/ceph/crush/crush.c                |  140 ++
 fs/ceph/crush/crush.h                |  188 +++
 fs/ceph/crush/hash.h                 |   90 ++
 fs/ceph/crush/mapper.c               |  589 +++++++
 fs/ceph/crush/mapper.h               |   20 +
 fs/ceph/debugfs.c                    |  430 +++++
 fs/ceph/decode.h                     |  136 ++
 fs/ceph/dir.c                        | 1175 ++++++++++++++
 fs/ceph/export.c                     |  222 +++
 fs/ceph/file.c                       |  902 +++++++++++
 fs/ceph/inode.c                      | 2404 ++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                      |  157 ++
 fs/ceph/ioctl.h                      |   39 +
 fs/ceph/mds_client.c                 | 2915 ++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h                 |  321 ++++
 fs/ceph/mdsmap.c                     |  139 ++
 fs/ceph/mdsmap.h                     |   47 +
 fs/ceph/messenger.c                  | 1868 ++++++++++++++++++++++
 fs/ceph/messenger.h                  |  255 +++
 fs/ceph/mon_client.c                 |  694 ++++++++
 fs/ceph/mon_client.h                 |  109 ++
 fs/ceph/msgpool.c                    |  167 ++
 fs/ceph/msgpool.h                    |   26 +
 fs/ceph/msgr.h                       |  157 ++
 fs/ceph/osd_client.c                 | 1292 +++++++++++++++
 fs/ceph/osd_client.h                 |  144 ++
 fs/ceph/osdmap.c                     |  872 ++++++++++
 fs/ceph/osdmap.h                     |   94 ++
 fs/ceph/rados.h                      |  426 +++++
 fs/ceph/snap.c                       |  897 +++++++++++
 fs/ceph/super.c                      | 1015 ++++++++++++
 fs/ceph/super.h                      |  945 +++++++++++
 fs/ceph/types.h                      |   27 +
 45 files changed, 24084 insertions(+), 0 deletions(-)
