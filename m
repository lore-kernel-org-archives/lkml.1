Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZGEQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZGEQdZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbZGEQco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:32:44 -0400
Received: from fifo99.com ([67.223.236.141]:41194 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbZGEQcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:32:42 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 3/4] staging: android: lowmemorykiller: delete the decription file
Date: Sun,  5 Jul 2009 09:32:44 -0700
Message-Id: <1246811565-8548-3-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1246811565-8548-2-git-send-email-dwalker@fifo99.com>
References: <>
 <1246811565-8548-1-git-send-email-dwalker@fifo99.com>
 <1246811565-8548-2-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the lowmemorykiller.txt into the actual source file which is really the
correct place for it, and delete lowmemorykiller.txt.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/lowmemorykiller.c   |   16 ++++++++++++++++
 drivers/staging/android/lowmemorykiller.txt |   16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)
 delete mode 100644 drivers/staging/android/lowmemorykiller.txt

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index fb066a3..f13c6fc 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -1,5 +1,21 @@
 /* drivers/misc/lowmemorykiller.c
  *
+ * The lowmemorykiller driver lets user-space specify a set of memory thresholds
+ * where processes with a range of oom_adj values will get killed. Specify the
+ * minimum oom_adj values in /sys/module/lowmemorykiller/parameters/adj and the
+ * number of free pages in /sys/module/lowmemorykiller/parameters/minfree. Both
+ * files take a comma separated list of numbers in ascending order.
+ *
+ * For example, write "0,8" to /sys/module/lowmemorykiller/parameters/adj and
+ * "1024,4096" to /sys/module/lowmemorykiller/parameters/minfree to kill processes
+ * with a oom_adj value of 8 or higher when the free memory drops below 4096 pages
+ * and kill processes with a oom_adj value of 0 or higher when the free memory
+ * drops below 1024 pages.
+ *
+ * The driver considers memory used for caches to be free, but if a large
+ * percentage of the cached memory is locked this can be very inaccurate
+ * and processes may not get killed until the normal oom killer is triggered.
+ *
  * Copyright (C) 2007-2008 Google, Inc.
  *
  * This software is licensed under the terms of the GNU General Public
diff --git a/drivers/staging/android/lowmemorykiller.txt b/drivers/staging/android/lowmemorykiller.txt
deleted file mode 100644
index bd5c0c0..0000000
--- a/drivers/staging/android/lowmemorykiller.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-The lowmemorykiller driver lets user-space specify a set of memory thresholds
-where processes with a range of oom_adj values will get killed. Specify the
-minimum oom_adj values in /sys/module/lowmemorykiller/parameters/adj and the
-number of free pages in /sys/module/lowmemorykiller/parameters/minfree. Both
-files take a comma separated list of numbers in ascending order.
-
-For example, write "0,8" to /sys/module/lowmemorykiller/parameters/adj and
-"1024,4096" to /sys/module/lowmemorykiller/parameters/minfree to kill processes
-with a oom_adj value of 8 or higher when the free memory drops below 4096 pages
-and kill processes with a oom_adj value of 0 or higher when the free memory
-drops below 1024 pages.
-
-The driver considers memory used for caches to be free, but if a large
-percentage of the cached memory is locked this can be very inaccurate
-and processes may not get killed until the normal oom killer is triggered.
-
-- 
1.5.4.3

