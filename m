Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbZFHOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbZFHOgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbZFHOfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:35:05 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:52202 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbZFHOfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:35:03 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i17ch)
X-FB-SS: 5,13,
X-WSS-ID: 0KKXCHW-01-S5A-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] dma-debug: code style fixes
Date: Mon, 8 Jun 2009 16:34:07 +0200
Message-ID: <1244471650-4632-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0538 (UTC) FILETIME=[32430EA0:01C9E846]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the recent updates to dma-debug to conform with
coding style guidelines of Linux and the -tip tree.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index b8a61ff..9561825 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -501,8 +501,8 @@ out_err:
 static ssize_t filter_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
-	unsigned long flags;
 	char buf[NAME_MAX_LEN + 1];
+	unsigned long flags;
 	int len;
 
 	if (!current_driver_name[0])
@@ -523,9 +523,9 @@ static ssize_t filter_read(struct file *file, char __user *user_buf,
 static ssize_t filter_write(struct file *file, const char __user *userbuf,
 			    size_t count, loff_t *ppos)
 {
-	unsigned long flags;
 	char buf[NAME_MAX_LEN];
-	size_t len = NAME_MAX_LEN - 1;
+	unsigned long flags;
+	size_t len;
 	int i;
 
 	/*
@@ -534,7 +534,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * disabled. Since copy_from_user can fault and may sleep we
 	 * need to copy to temporary buffer first
 	 */
-	len = min(count, len);
+	len = min(count, NAME_MAX_LEN - 1);
 	if (copy_from_user(buf, userbuf, len))
 		return -EFAULT;
 
@@ -1040,18 +1040,19 @@ EXPORT_SYMBOL(debug_dma_map_sg);
 
 static int get_nr_mapped_entries(struct device *dev, struct scatterlist *s)
 {
-	struct dma_debug_entry *entry;
+	struct dma_debug_entry *entry, ref;
 	struct hash_bucket *bucket;
 	unsigned long flags;
-	int mapped_ents = 0;
-	struct dma_debug_entry ref;
+	int mapped_ents;
 
-	ref.dev = dev;
+	ref.dev      = dev;
 	ref.dev_addr = sg_dma_address(s);
-	ref.size = sg_dma_len(s),
+	ref.size     = sg_dma_len(s),
+
+	bucket       = get_hash_bucket(&ref, &flags);
+	entry        = hash_bucket_find(bucket, &ref);
+	mapped_ents  = 0;
 
-	bucket = get_hash_bucket(&ref, &flags);
-	entry = hash_bucket_find(bucket, &ref);
 	if (entry)
 		mapped_ents = entry->sg_mapped_ents;
 	put_hash_bucket(bucket, &flags);
-- 
1.6.3.1


