Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbZIHXAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbZIHXAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZIHW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:57:41 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57532 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZIHW5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:57:38 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/20] ceph distributed file system client
Date: Tue,  8 Sep 2009 15:56:21 -0700
Message-Id: <1252450601-17610-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v0.14 of the Ceph distributed file system client.  Changes since
v0.12 (the last release posted) include:

 - refactored, simplified network message library
   - now strictly client/server
   - simplified callback vector
   - fewer memory allocations
 - improved client/monitor protocol
 - fixed EOF vs (short) read behavior with multi-client sharing
 - cleanup, refactoring in osd reply code
 - bug fixes

The biggest change is in the message library.  A whole class of
potential memory allocations have been removed, the groundwork has
been laid to reserve memory for incoming messages, and lots of code
got removed in the process.

This is mainly motivated by the desire to eliminate any memory
allocations during writeback; we're pretty close to having that
resolved.  If there are other areas of concern (general or specific)
with this patchset, please speak up.

We would like to see this merged soon.  What is the next step here?

Thanks,
sage


Kernel client git tree:
        git://ceph.newdream.net/linux-ceph-client.git

System:
	git://ceph.newdream.net/ceph.git

---
 Documentation/filesystems/ceph.txt |  140 ++
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/ceph/Kconfig                    |   26 +
 fs/ceph/Makefile                   |   35 +
 fs/ceph/addr.c                     | 1170 +++++++++++++++
 fs/ceph/buffer.h                   |   93 ++
 fs/ceph/caps.c                     | 2768 ++++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |   34 +
 fs/ceph/ceph_fs.h                  |  935 ++++++++++++
 fs/ceph/ceph_ver.h                 |    6 +
 fs/ceph/crush/crush.c              |  140 ++
 fs/ceph/crush/crush.h              |  188 +++
 fs/ceph/crush/hash.h               |   90 ++
 fs/ceph/crush/mapper.c             |  588 ++++++++
 fs/ceph/crush/mapper.h             |   20 +
 fs/ceph/debugfs.c                  |  455 ++++++
 fs/ceph/decode.h                   |  136 ++
 fs/ceph/dir.c                      | 1175 +++++++++++++++
 fs/ceph/export.c                   |  235 +++
 fs/ceph/file.c                     |  916 +++++++++++
 fs/ceph/inode.c                    | 2398 +++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   98 ++
 fs/ceph/ioctl.h                    |   20 +
 fs/ceph/mds_client.c               | 2913 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  320 ++++
 fs/ceph/mdsmap.c                   |  139 ++
 fs/ceph/mdsmap.h                   |   47 +
 fs/ceph/messenger.c                | 1815 ++++++++++++++++++++++
 fs/ceph/messenger.h                |  263 ++++
 fs/ceph/mon_client.c               |  651 ++++++++
 fs/ceph/mon_client.h               |  102 ++
 fs/ceph/msgr.h                     |  158 ++
 fs/ceph/osd_client.c               | 1278 ++++++++++++++++
 fs/ceph/osd_client.h               |  142 ++
 fs/ceph/osdmap.c                   |  871 +++++++++++
 fs/ceph/osdmap.h                   |   94 ++
 fs/ceph/rados.h                    |  427 ++++++
 fs/ceph/snap.c                     |  896 +++++++++++
 fs/ceph/super.c                    | 1035 +++++++++++++
 fs/ceph/super.h                    |  961 ++++++++++++
 fs/ceph/types.h                    |   27 +
 42 files changed, 23807 insertions(+), 0 deletions(-)
