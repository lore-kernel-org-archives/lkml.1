Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXC1Qkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXC1Qkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXC1Qkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:40:43 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37631 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXC1Qkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:40:41 -0400
Subject: [Patch -mm] integrity: ima cleanup
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, sailer@us.ibm.com, zohar@us.ibm.com,
       akpm@osdl.org
Content-Type: text/plain
Date: Wed, 28 Mar 2007 12:39:33 -0400
Message-Id: <1175099973.16382.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleanups the few Lindent and sparse msgs

signed-off-by: Mimi Zohar <zohar@us.ibm.com>
signed-off-by: Kylene Hall <kjhall@us.ibm.com>
---

Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima.h
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima.h
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima.h
@@ -52,7 +52,7 @@ struct ima_measure_entry {
 
 struct ima_queue_entry {
 	struct hlist_node hnext;	/* place in hash collision list */
-	struct list_head later;	/* place in ima_measurements list */
+	struct list_head later;		/* place in ima_measurements list */
 	struct ima_measure_entry *entry;
 };
 
@@ -72,7 +72,7 @@ struct ima_queue_entry *ima_lookup_diges
 extern spinlock_t ima_queue_lock;
 
 struct ima_h_table {
-	atomic_t len;	/* number of stored measurements in the list */
+	atomic_t len;		/* number of stored measurements in the list */
 	atomic_t violations;
 	unsigned int max_htable_size;
 	struct hlist_head queue[IMA_MEASURE_HTABLE_SIZE];
@@ -82,7 +82,7 @@ extern struct ima_h_table ima_htable;
 
 /* TPM "Glue" definitions */
 
-#define IMA_TPM ((TPM_ANY_TYPE<<16)| TPM_ANY_NUM)
+#define IMA_TPM ((((u32)TPM_ANY_TYPE)<<16)| (u32)TPM_ANY_NUM)
 static inline void ima_extend(const u8 * hash)
 {
 	if (!ima_used_chip)
Index: linux-2.6.21-rc5-mm2/security/evm/ima/ima_fs.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/security/evm/ima/ima_fs.c
+++ linux-2.6.21-rc5-mm2/security/evm/ima/ima_fs.c
@@ -69,12 +69,11 @@ static void *ima_measurements_start(stru
 	return NULL;
 }
 
-static void *ima_measurements_next(struct seq_file *m, void *v,
-				   loff_t * pos)
+static void *ima_measurements_next(struct seq_file *m, void *v, loff_t * pos)
 {
 	/* lock protects when reading beyond last element
 	 * against concurrent list-extension */
-	struct list_head *lpos = (struct list_head *) v;
+	struct list_head *lpos = (struct list_head *)v;
 
 	rcu_read_lock();
 	lpos = rcu_dereference(lpos->next);
@@ -88,7 +87,6 @@ static void ima_measurements_stop(struct
 {
 }
 
-
 /* print format:
  *       32bit-le=pcr#
  *       32bit-le=type# << flag
@@ -207,8 +205,7 @@ static struct seq_operations ima_ascii_m
 	.show = ima_ascii_measurements_show
 };
 
-static int ima_ascii_measurements_open(struct inode *inode,
-				       struct file *file)
+static int ima_ascii_measurements_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &ima_ascii_measurements_seqops);
 }
@@ -255,8 +252,7 @@ int ima_fs_init(void)
 
 	violations =
 	    securityfs_create_file("violations", S_IRUSR | S_IRGRP,
-				   ima_dir, NULL,
-				   &ima_htable_violations_ops);
+				   ima_dir, NULL, &ima_htable_violations_ops);
 	if (!violations || IS_ERR(violations))
 		goto out;
 	return 0;



