Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbZLDW15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbZLDW15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZLDW1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:27:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbZLDW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:27:55 -0500
Message-ID: <4B198D5C.4020700@gmail.com>
Date: Fri, 04 Dec 2009 23:29:48 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: jeffm@suse.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/31] Constify struct item_operations for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct item_operations.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 fs/reiserfs/item_ops.c      |   12 ++++++------
 include/linux/reiserfs_fs.h |   24 ++++++++++++------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/reiserfs/item_ops.c b/fs/reiserfs/item_ops.c
index 72cb1cc..d0e3181 100644
--- a/fs/reiserfs/item_ops.c
+++ b/fs/reiserfs/item_ops.c
@@ -102,7 +102,7 @@ static void sd_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations stat_data_ops = {
+static const struct item_operations stat_data_ops = {
 	.bytes_number = sd_bytes_number,
 	.decrement_key = sd_decrement_key,
 	.is_left_mergeable = sd_is_left_mergeable,
@@ -196,7 +196,7 @@ static void direct_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations direct_ops = {
+static const struct item_operations direct_ops = {
 	.bytes_number = direct_bytes_number,
 	.decrement_key = direct_decrement_key,
 	.is_left_mergeable = direct_is_left_mergeable,
@@ -341,7 +341,7 @@ static void indirect_print_vi(struct virtual_item *vi)
 			 vi->vi_index, vi->vi_type, vi->vi_ih);
 }
 
-static struct item_operations indirect_ops = {
+static const struct item_operations indirect_ops = {
 	.bytes_number = indirect_bytes_number,
 	.decrement_key = indirect_decrement_key,
 	.is_left_mergeable = indirect_is_left_mergeable,
@@ -628,7 +628,7 @@ static void direntry_print_vi(struct virtual_item *vi)
 	printk("\n");
 }
 
-static struct item_operations direntry_ops = {
+static const struct item_operations direntry_ops = {
 	.bytes_number = direntry_bytes_number,
 	.decrement_key = direntry_decrement_key,
 	.is_left_mergeable = direntry_is_left_mergeable,
@@ -724,7 +724,7 @@ static void errcatch_print_vi(struct virtual_item *vi)
 			 "Invalid item type observed, run fsck ASAP");
 }
 
-static struct item_operations errcatch_ops = {
+static const struct item_operations errcatch_ops = {
 	errcatch_bytes_number,
 	errcatch_decrement_key,
 	errcatch_is_left_mergeable,
@@ -746,7 +746,7 @@ static struct item_operations errcatch_ops = {
 #error Item types must use disk-format assigned values.
 #endif
 
-struct item_operations *item_ops[TYPE_ANY + 1] = {
+const struct item_operations * const item_ops[TYPE_ANY + 1] = {
 	&stat_data_ops,
 	&indirect_ops,
 	&direct_ops,
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index dd31e7b..5a54e06 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1534,24 +1534,24 @@ static inline struct super_block *sb_from_bi(struct buffer_info *bi)
 */
 
 struct item_operations {
-	int (*bytes_number) (struct item_head * ih, int block_size);
-	void (*decrement_key) (struct cpu_key *);
-	int (*is_left_mergeable) (struct reiserfs_key * ih,
+	int (* const bytes_number) (struct item_head * ih, int block_size);
+	void (* const decrement_key) (struct cpu_key *);
+	int (* const is_left_mergeable) (struct reiserfs_key * ih,
 				  unsigned long bsize);
-	void (*print_item) (struct item_head *, char *item);
-	void (*check_item) (struct item_head *, char *item);
+	void (* const print_item) (struct item_head *, char *item);
+	void (* const check_item) (struct item_head *, char *item);
 
-	int (*create_vi) (struct virtual_node * vn, struct virtual_item * vi,
+	int (* const create_vi) (struct virtual_node * vn, struct virtual_item * vi,
 			  int is_affected, int insert_size);
-	int (*check_left) (struct virtual_item * vi, int free,
+	int (* const check_left) (struct virtual_item * vi, int free,
 			   int start_skip, int end_skip);
-	int (*check_right) (struct virtual_item * vi, int free);
-	int (*part_size) (struct virtual_item * vi, int from, int to);
-	int (*unit_num) (struct virtual_item * vi);
-	void (*print_vi) (struct virtual_item * vi);
+	int (* const check_right) (struct virtual_item * vi, int free);
+	int (* const part_size) (struct virtual_item * vi, int from, int to);
+	int (* const unit_num) (struct virtual_item * vi);
+	void (* const print_vi) (struct virtual_item * vi);
 };
 
-extern struct item_operations *item_ops[TYPE_ANY + 1];
+extern const struct item_operations * const item_ops[TYPE_ANY + 1];
 
 #define op_bytes_number(ih,bsize)                    item_ops[le_ih_k_type (ih)]->bytes_number (ih, bsize)
 #define op_is_left_mergeable(key,bsize)              item_ops[le_key_k_type (le_key_version (key), key)]->is_left_mergeable (key, bsize)

