Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXLRV01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXLRV01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXLRV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:26:17 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36927 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbXLRV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:26:15 -0500
Message-ID: <47683ADE.3080107@cosmosbay.com>
Date: Tue, 18 Dec 2007 22:25:50 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] procfs : Move some extern declaration from fs/proc/proc_misc.c
 to include/linux/seq_file.h
Content-Type: multipart/mixed;
 boundary="------------020903070902090605040004"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 18 Dec 2007 22:25:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020903070902090605040004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some 'extern struct seq_operations' are wrongly defined in fs/proc/proc_misc.c 
(they miss a const qualifier)

In order to fix this correctly, move the "extern ... " declaration from .c 
file to an appropriate include file, as advised by checkpatch.pl

Note : "extern struct seq_operations cpuinfo_op;" will be taken into account
in a separate patch, since its const status is arch dependant.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

  fs/proc/proc_misc.c      |    9 ---------
  include/linux/seq_file.h |   11 +++++++++++
  2 files changed, 11 insertions(+), 9 deletions(-)


--------------020903070902090605040004
Content-Type: text/plain;
 name="seq.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="seq.patch"

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index e0d064e..6344881 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -216,7 +216,6 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 #undef K
 }
 
-extern struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -230,7 +229,6 @@ static const struct file_operations fragmentation_file_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -243,7 +241,6 @@ static const struct file_operations pagetypeinfo_file_ops = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -340,7 +337,6 @@ static const struct file_operations proc_devinfo_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations vmstat_op;
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
@@ -371,7 +367,6 @@ static int stram_read_proc(char *page, char **start, off_t off,
 #endif
 
 #ifdef CONFIG_BLOCK
-extern struct seq_operations partitions_op;
 static int partitions_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &partitions_op);
@@ -383,7 +378,6 @@ static const struct file_operations proc_partitions_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations diskstats_op;
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
@@ -397,7 +391,6 @@ static const struct file_operations proc_diskstats_operations = {
 #endif
 
 #ifdef CONFIG_MODULES
-extern struct seq_operations modules_op;
 static int modules_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &modules_op);
@@ -424,7 +417,6 @@ static const struct file_operations proc_slabinfo_operations = {
 };
 
 #ifdef CONFIG_DEBUG_SLAB_LEAK
-extern struct seq_operations slabstats_op;
 static int slabstats_open(struct inode *inode, struct file *file)
 {
 	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -598,7 +590,6 @@ static void int_seq_stop(struct seq_file *f, void *v)
 }
 
 
-extern int show_interrupts(struct seq_file *f, void *v); /* In arch code */
 static struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index ebbc02b..90a1cdd 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -63,5 +63,16 @@ extern struct list_head *seq_list_start_head(struct list_head *head,
 extern struct list_head *seq_list_next(void *v, struct list_head *head,
 		loff_t *ppos);
 
+int show_interrupts(struct seq_file *f, void *v); /* In arch code */
+
+extern const struct seq_operations modules_op;
+extern const struct seq_operations slabstats_op;
+extern struct seq_operations diskstats_op;
+extern struct seq_operations partitions_op;
+extern const struct seq_operations vmstat_op;
+extern const struct seq_operations zoneinfo_op;
+extern const struct seq_operations pagetypeinfo_op;
+extern const struct seq_operations fragmentation_op;
+
 #endif
 #endif

--------------020903070902090605040004--
