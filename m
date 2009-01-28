Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZA1XbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZA1XbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZA1X2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:16 -0500
Received: from kroah.org ([198.145.64.141]:56990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756908AbZA1X2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/10] Staging: android: Add lowmemorykiller documentation.
Date: Wed, 28 Jan 2009 15:26:46 -0800
Message-Id: <1233185210-23098-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/lowmemorykiller.txt |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/android/lowmemorykiller.txt

diff --git a/drivers/staging/android/lowmemorykiller.txt b/drivers/staging/android/lowmemorykiller.txt
new file mode 100644
index 0000000..bd5c0c0
--- /dev/null
+++ b/drivers/staging/android/lowmemorykiller.txt
@@ -0,0 +1,16 @@
+The lowmemorykiller driver lets user-space specify a set of memory thresholds
+where processes with a range of oom_adj values will get killed. Specify the
+minimum oom_adj values in /sys/module/lowmemorykiller/parameters/adj and the
+number of free pages in /sys/module/lowmemorykiller/parameters/minfree. Both
+files take a comma separated list of numbers in ascending order.
+
+For example, write "0,8" to /sys/module/lowmemorykiller/parameters/adj and
+"1024,4096" to /sys/module/lowmemorykiller/parameters/minfree to kill processes
+with a oom_adj value of 8 or higher when the free memory drops below 4096 pages
+and kill processes with a oom_adj value of 0 or higher when the free memory
+drops below 1024 pages.
+
+The driver considers memory used for caches to be free, but if a large
+percentage of the cached memory is locked this can be very inaccurate
+and processes may not get killed until the normal oom killer is triggered.
+
-- 
1.6.0.2

