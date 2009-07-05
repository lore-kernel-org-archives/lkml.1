Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZGEQdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZGEQdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756892AbZGEQcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:32:43 -0400
Received: from fifo99.com ([67.223.236.141]:41190 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZGEQcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:32:42 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@fifo99.com>
Subject: [PATCH 2/4] staging: android: lowmemorykiller: remove a predefine
Date: Sun,  5 Jul 2009 09:32:43 -0700
Message-Id: <1246811565-8548-2-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1246811565-8548-1-git-send-email-dwalker@fifo99.com>
References: <>
 <1246811565-8548-1-git-send-email-dwalker@fifo99.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved the struct shrinker down so that the predefine isn't needed.

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 drivers/staging/android/lowmemorykiller.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index f934393..fb066a3 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -19,12 +19,6 @@
 #include <linux/oom.h>
 #include <linux/sched.h>
 
-static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask);
-
-static struct shrinker lowmem_shrinker = {
-	.shrink = lowmem_shrink,
-	.seeks = DEFAULT_SEEKS * 16
-};
 static uint32_t lowmem_debug_level = 2;
 static int lowmem_adj[6] = {
 	0,
@@ -140,6 +134,11 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	return rem;
 }
 
+static struct shrinker lowmem_shrinker = {
+	.shrink = lowmem_shrink,
+	.seeks = DEFAULT_SEEKS * 16
+};
+
 static int __init lowmem_init(void)
 {
 	register_shrinker(&lowmem_shrinker);
-- 
1.5.4.3

