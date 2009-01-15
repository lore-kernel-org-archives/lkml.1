Return-Path: <linux-kernel-owner+w=401wt.eu-S1760461AbZAOAzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760461AbZAOAzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759313AbZAOAyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:54:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:29942 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759008AbZAOAyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:54:36 -0500
From: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
To: greg@kroah.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH] Staging: android: Add lowmemorykiller documentation.
Date: Wed, 14 Jan 2009 16:54:16 -0800
Message-Id: <1231980856-30600-1-git-send-email-arve@android.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090115001224.GC11328@kroah.com>
References: <20090115001224.GC11328@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arve Hjønnevåg <arve@android.com>
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
1.6.1

