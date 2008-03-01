Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbYCAQVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbYCAQVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbYCAQTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:19:48 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38964 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762403AbYCAQTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:19:46 -0500
Date: Sat, 1 Mar 2008 18:18:21 +0200
From: Adrian Bunk <bunk@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] block/genhd.c: proper externs
Message-ID: <20080301161821.GJ25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper externs for two structs in include/linux/genhd.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/proc/proc_misc.c   |    3 +--
 include/linux/genhd.h |    3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

0c8659ef7987be79262c88e423286bab3837a7dd foobar
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 468805d..2d56397 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -32,6 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#include <linux/genhd.h>
 #include <linux/smp.h>
 #include <linux/signal.h>
 #include <linux/module.h>
@@ -377,7 +378,6 @@ static int stram_read_proc(char *page, char **start, off_t off,
 #endif
 
 #ifdef CONFIG_BLOCK
-extern const struct seq_operations partitions_op;
 static int partitions_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &partitions_op);
@@ -389,7 +389,6 @@ static const struct file_operations proc_partitions_operations = {
 	.release	= seq_release,
 };
 
-extern const struct seq_operations diskstats_op;
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index cd048e3..32c2ac4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -22,6 +22,9 @@ extern struct device_type part_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
 
+extern const struct seq_operations partitions_op;
+extern const struct seq_operations diskstats_op;
+
 enum {
 /* These three have identical behaviour; use the second one if DOS FDISK gets
    confused about extended/logical partitions starting past cylinder 1023. */

