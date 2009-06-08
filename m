Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZFHOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZFHOfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZFHOe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:34:58 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:39028
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755867AbZFHOe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:34:56 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKXCHZ-01-S5G-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/5] dma-debug: use pr_* instead of printk(KERN_* ...)
Date: Mon, 8 Jun 2009 16:34:08 +0200
Message-ID: <1244471650-4632-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
References: <1244471650-4632-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 08 Jun 2009 14:34:14.0538 (UTC) FILETIME=[32430EA0:01C9E846]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pr_* macros are shorter than the old printk(KERN_ ...) variant.
Change the dma-debug code to use the new macros and save a few
unnecessary line breaks. If lines don't break the source code can also
be grepped more easily.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 9561825..24c4a2c 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -139,7 +139,7 @@ static inline void dump_entry_trace(struct dma_debug_entry *entry)
 {
 #ifdef CONFIG_STACKTRACE
 	if (entry) {
-		printk(KERN_WARNING "Mapped at:\n");
+		pr_warning("Mapped at:\n");
 		print_stack_trace(&entry->stacktrace, 0);
 	}
 #endif
@@ -377,8 +377,7 @@ static struct dma_debug_entry *dma_entry_alloc(void)
 	spin_lock_irqsave(&free_entries_lock, flags);
 
 	if (list_empty(&free_entries)) {
-		printk(KERN_ERR "DMA-API: debugging out of memory "
-				"- disabling\n");
+		pr_err("DMA-API: debugging out of memory - disabling\n");
 		global_disable = true;
 		goto out;
 	}
@@ -483,8 +482,7 @@ static int prealloc_memory(u32 num_entries)
 	num_free_entries = num_entries;
 	min_free_entries = num_entries;
 
-	printk(KERN_INFO "DMA-API: preallocated %d debug entries\n",
-			num_entries);
+	pr_info("DMA-API: preallocated %d debug entries\n", num_entries);
 
 	return 0;
 
@@ -534,7 +532,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * disabled. Since copy_from_user can fault and may sleep we
 	 * need to copy to temporary buffer first
 	 */
-	len = min(count, NAME_MAX_LEN - 1);
+	len = min(count, (size_t)(NAME_MAX_LEN - 1));
 	if (copy_from_user(buf, userbuf, len))
 		return -EFAULT;
 
@@ -557,8 +555,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 		 * switched off.
 		 */
 		if (current_driver_name[0])
-			printk(KERN_INFO "DMA-API: switching off dma-debug "
-					 "driver filter\n");
+			pr_info("DMA-API: switching off dma-debug driver filter\n");
 		current_driver_name[0] = 0;
 		current_driver = NULL;
 		goto out_unlock;
@@ -576,8 +573,8 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	current_driver_name[i] = 0;
 	current_driver = NULL;
 
-	printk(KERN_INFO "DMA-API: enable driver filter for driver [%s]\n",
-	       current_driver_name);
+	pr_info("DMA-API: enable driver filter for driver [%s]\n",
+		current_driver_name);
 
 out_unlock:
 	write_unlock_irqrestore(&driver_name_lock, flags);
@@ -594,7 +591,7 @@ static int dma_debug_fs_init(void)
 {
 	dma_debug_dent = debugfs_create_dir("dma-api", NULL);
 	if (!dma_debug_dent) {
-		printk(KERN_ERR "DMA-API: can not create debugfs directory\n");
+		pr_err("DMA-API: can not create debugfs directory\n");
 		return -ENOMEM;
 	}
 
@@ -693,7 +690,7 @@ void dma_debug_add_bus(struct bus_type *bus)
 
 	nb = kzalloc(sizeof(struct notifier_block), GFP_KERNEL);
 	if (nb == NULL) {
-		printk(KERN_ERR "dma_debug_add_bus: out of memory\n");
+		pr_err("dma_debug_add_bus: out of memory\n");
 		return;
 	}
 
@@ -718,8 +715,7 @@ void dma_debug_init(u32 num_entries)
 	}
 
 	if (dma_debug_fs_init() != 0) {
-		printk(KERN_ERR "DMA-API: error creating debugfs entries "
-				"- disabling\n");
+		pr_err("DMA-API: error creating debugfs entries - disabling\n");
 		global_disable = true;
 
 		return;
@@ -729,8 +725,7 @@ void dma_debug_init(u32 num_entries)
 		num_entries = req_entries;
 
 	if (prealloc_memory(num_entries) != 0) {
-		printk(KERN_ERR "DMA-API: debugging out of memory error "
-				"- disabled\n");
+		pr_err("DMA-API: debugging out of memory error - disabled\n");
 		global_disable = true;
 
 		return;
@@ -738,7 +733,7 @@ void dma_debug_init(u32 num_entries)
 
 	nr_total_entries = num_free_entries;
 
-	printk(KERN_INFO "DMA-API: debugging enabled by kernel config\n");
+	pr_info("DMA-API: debugging enabled by kernel config\n");
 }
 
 static __init int dma_debug_cmdline(char *str)
@@ -747,8 +742,7 @@ static __init int dma_debug_cmdline(char *str)
 		return -EINVAL;
 
 	if (strncmp(str, "off", 3) == 0) {
-		printk(KERN_INFO "DMA-API: debugging disabled on kernel "
-				 "command line\n");
+		pr_info("DMA-API: debugging disabled on kernel command line\n");
 		global_disable = true;
 	}
 
@@ -1239,8 +1233,8 @@ static int __init dma_debug_driver_setup(char *str)
 	}
 
 	if (current_driver_name[0])
-		printk(KERN_INFO "DMA-API: enable driver filter for "
-				 "driver [%s]\n", current_driver_name);
+		pr_info("DMA-API: enable driver filter for driver [%s]\n",
+			current_driver_name);
 
 
 	return 1;
-- 
1.6.3.1


