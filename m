Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZLNAOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZLNAOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbZLNAOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:14:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34241 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbZLMX5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:55 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jeffm@suse.com, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: [PATCH 2/2] Constify struct item_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:50 +0100
Message-Id: <48e74954671a5f0d17c60ace50e5884fdc7ab353.1260662998.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662998.git.re.emese@gmail.com>
References: <cover.1260662998.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/linux/reiserfs_fs.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index a05b4a2..10c0e52 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1590,24 +1590,24 @@ static inline struct super_block *sb_from_bi(struct buffer_info *bi)
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
-- 
1.6.5.3

