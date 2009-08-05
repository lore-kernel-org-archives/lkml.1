Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbZHEW3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbZHEW3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 18:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZHEW3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 18:29:44 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52517 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZHEW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 18:29:41 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 00/19] ceph distributed file system client
Date: Wed,  5 Aug 2009 15:30:20 -0700
Message-Id: <1249511439-31088-1-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is v0.12 of the Ceph distributed file system client.  Changes since
v0.11 include:

 - mapping_set_error on failed writepage
 - document correct debugfs mount point
 - simplified layout/striping ioctls
 - removed bad kmalloc in writepages
 - use mempools for writeback allocations where appropriate (*)
 - fixed a problem with capability, snap metadata writeback
 - cleaned up f(data)sync wrt metadata writeback

(*) There are still some OOM possibilities on writeback in the
messenger library.  It's possible to avoid this with the careful use
of mempools, but I'd like to avoid doing so until it's clear the
protocol isn't going to change further.

The client seems to be quite stable in a single mds, no snapshot
scenario (including recovery from mds, osd restarts).  Thorough
testing of snapshots and multiple MDSs is coming next.  Client
authentication (beyond the current host ip checking) is the other main
item on the client todo list.

As always, I'm very interested in hearing what people would like to
see for this to be merged.

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
 fs/ceph/addr.c                     | 1104 ++++++++++++++
 fs/ceph/caps.c                     | 2785 +++++++++++++++++++++++++++++++++++
 fs/ceph/ceph_debug.h               |   34 +
 fs/ceph/ceph_fs.h                  |  914 ++++++++++++
 fs/ceph/ceph_ver.h                 |    6 +
 fs/ceph/crush/crush.c              |  140 ++
 fs/ceph/crush/crush.h              |  188 +++
 fs/ceph/crush/hash.h               |   90 ++
 fs/ceph/crush/mapper.c             |  606 ++++++++
 fs/ceph/crush/mapper.h             |   20 +
 fs/ceph/debugfs.c                  |  461 ++++++
 fs/ceph/decode.h                   |  136 ++
 fs/ceph/dir.c                      | 1173 +++++++++++++++
 fs/ceph/export.c                   |  222 +++
 fs/ceph/file.c                     |  750 ++++++++++
 fs/ceph/inode.c                    | 2378 ++++++++++++++++++++++++++++++
 fs/ceph/ioctl.c                    |   98 ++
 fs/ceph/ioctl.h                    |   20 +
 fs/ceph/mds_client.c               | 2865 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h               |  326 ++++
 fs/ceph/mdsmap.c                   |  139 ++
 fs/ceph/mdsmap.h                   |   47 +
 fs/ceph/messenger.c                | 2370 +++++++++++++++++++++++++++++
 fs/ceph/messenger.h                |  253 ++++
 fs/ceph/mon_client.c               |  478 ++++++
 fs/ceph/mon_client.h               |  103 ++
 fs/ceph/msgr.h                     |  156 ++
 fs/ceph/osd_client.c               | 1096 ++++++++++++++
 fs/ceph/osd_client.h               |  136 ++
 fs/ceph/osdmap.c                   |  697 +++++++++
 fs/ceph/osdmap.h                   |   83 ++
 fs/ceph/rados.h                    |  419 ++++++
 fs/ceph/snap.c                     |  896 +++++++++++
 fs/ceph/super.c                    | 1173 +++++++++++++++
 fs/ceph/super.h                    |  963 ++++++++++++
 fs/ceph/types.h                    |   27 +
 41 files changed, 23555 insertions(+), 0 deletions(-)
