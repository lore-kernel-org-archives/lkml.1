Return-Path: <linux-kernel-owner+w=401wt.eu-S1760451AbYEFIuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451AbYEFIuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYEFIt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:49:57 -0400
Received: from smtp.nokia.com ([192.100.122.230]:45092 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbYEFIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:49:56 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 2] UBIFS - new flash file system
Date: Tue,  6 May 2008 13:35:31 +0300
Message-Id: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
X-OriginalArrivalTime: 06 May 2008 08:49:46.0152 (UTC) FILETIME=[22892280:01C8AF56]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here is the second round of UBIFS submission. Please, refer the following
URL if you are not familiar what is UBIFS about:

http://kerneltrap.org/mailarchive/linux-kernel/2008/3/27/1273514

Additionally, there is a excellent introductional LWN article written by
Jonathan Corbet:
http://lwn.net/Articles/276025/
(thanks Jonathan).

We've addressed most of the requests from the first round and the following
is a rough change log:
* Store milliseconds for [mca]time stamps in the inodes, not only seconds
  (requested by Andi Kleen)
* Documentation/filesystems/ubifs.txt has been added (requested by Josh Boyer)
* do_div() is not anymore used with 'unsigned long long' values
  (requested by Andrew Morton)
* The amount of debugging-related config options was lessened and module
  parameters were introduced instead (requested by Pekka Enberg and
  Christoph Hellwig)
* Many assertions were removed (requested by Pekka Enberg)
* Some debugging checks like custom memory leak and memory pressure checks
  were removed (requested by Pekka Enberg)

Besides, several bugs were fixed both in UBIFS and mkfs.ubifs. The on-flash
format has also been changed because of the inode time-stamp format changes
(milliseconds were added).

We've got few users outside of Nokia who seem to be happy with UBIFS and
utilize it. There were some positive feed-backs from the community, e.g.
http://kerneltrap.org/mailarchive/linux-kernel/2008/4/18/1466334
(thanks Thomas).

We kindly ask for more review and feed-back. We'd also like to get into
Andrew's mm tree.

Thank you,
Adrian Hunter
Artem Bityutskiy

git-diff --stat --summary -M v2.6.25
 Documentation/filesystems/ubifs.txt |  163 ++
 fs/Kconfig                          |    3 +
 fs/Makefile                         |    1 +
 fs/fs-writeback.c                   |    8 +
 fs/ubifs/Kconfig                    |   47 +
 fs/ubifs/Kconfig.debug              |   30 +
 fs/ubifs/Makefile                   |    9 +
 fs/ubifs/budget.c                   |  857 +++++++++
 fs/ubifs/build.c                    | 1374 +++++++++++++++
 fs/ubifs/commit.c                   |  709 ++++++++
 fs/ubifs/compress.c                 |  253 +++
 fs/ubifs/debug.c                    | 1463 ++++++++++++++++
 fs/ubifs/debug.h                    |  392 +++++
 fs/ubifs/dir.c                      |  978 +++++++++++
 fs/ubifs/file.c                     |  902 ++++++++++
 fs/ubifs/find.c                     |  957 +++++++++++
 fs/ubifs/gc.c                       |  773 +++++++++
 fs/ubifs/io.c                       |  921 ++++++++++
 fs/ubifs/ioctl.c                    |  205 +++
 fs/ubifs/journal.c                  | 1264 ++++++++++++++
 fs/ubifs/key.h                      |  507 ++++++
 fs/ubifs/log.c                      |  799 +++++++++
 fs/ubifs/lprops.c                   | 1353 +++++++++++++++
 fs/ubifs/lpt.c                      | 2243 ++++++++++++++++++++++++
 fs/ubifs/lpt_commit.c               | 1625 ++++++++++++++++++
 fs/ubifs/master.c                   |  387 +++++
 fs/ubifs/misc.h                     |  310 ++++
 fs/ubifs/orphan.c                   |  955 +++++++++++
 fs/ubifs/recovery.c                 | 1439 ++++++++++++++++
 fs/ubifs/replay.c                   | 1008 +++++++++++
 fs/ubifs/sb.c                       |  612 +++++++
 fs/ubifs/scan.c                     |  362 ++++
 fs/ubifs/shrinker.c                 |  322 ++++
 fs/ubifs/super.c                    |  525 ++++++
 fs/ubifs/tnc.c                      | 3240 +++++++++++++++++++++++++++++++++++
 fs/ubifs/tnc_commit.c               | 1097 ++++++++++++
 fs/ubifs/tnc_misc.c                 |  259 +++
 fs/ubifs/ubifs-media.h              |  719 ++++++++
 fs/ubifs/ubifs.h                    | 1563 +++++++++++++++++
 fs/ubifs/xattr.c                    |  582 +++++++
 include/linux/writeback.h           |    1 +
 init/do_mounts.c                    |    3 +-
 42 files changed, 31219 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/filesystems/ubifs.txt
 create mode 100644 fs/ubifs/Kconfig
 create mode 100644 fs/ubifs/Kconfig.debug
 create mode 100644 fs/ubifs/Makefile
 create mode 100644 fs/ubifs/budget.c
 create mode 100644 fs/ubifs/build.c
 create mode 100644 fs/ubifs/commit.c
 create mode 100644 fs/ubifs/compress.c
 create mode 100644 fs/ubifs/debug.c
 create mode 100644 fs/ubifs/debug.h
 create mode 100644 fs/ubifs/dir.c
 create mode 100644 fs/ubifs/file.c
 create mode 100644 fs/ubifs/find.c
 create mode 100644 fs/ubifs/gc.c
 create mode 100644 fs/ubifs/io.c
 create mode 100644 fs/ubifs/ioctl.c
 create mode 100644 fs/ubifs/journal.c
 create mode 100644 fs/ubifs/key.h
 create mode 100644 fs/ubifs/log.c
 create mode 100644 fs/ubifs/lprops.c
 create mode 100644 fs/ubifs/lpt.c
 create mode 100644 fs/ubifs/lpt_commit.c
 create mode 100644 fs/ubifs/master.c
 create mode 100644 fs/ubifs/misc.h
 create mode 100644 fs/ubifs/orphan.c
 create mode 100644 fs/ubifs/recovery.c
 create mode 100644 fs/ubifs/replay.c
 create mode 100644 fs/ubifs/sb.c
 create mode 100644 fs/ubifs/scan.c
 create mode 100644 fs/ubifs/shrinker.c
 create mode 100644 fs/ubifs/super.c
 create mode 100644 fs/ubifs/tnc.c
 create mode 100644 fs/ubifs/tnc_commit.c
 create mode 100644 fs/ubifs/tnc_misc.c
 create mode 100644 fs/ubifs/ubifs-media.h
 create mode 100644 fs/ubifs/ubifs.h
 create mode 100644 fs/ubifs/xattr.c
