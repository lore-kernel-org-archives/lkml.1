Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYHWW4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYHWW4p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 18:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYHWW4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 18:56:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37505 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbYHWW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 18:56:36 -0400
Date: Sat, 23 Aug 2008 18:56:34 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] include: linux/fs.h: put declarations in __KERNEL__
Message-ID: <alpine.LNX.1.10.0808231854460.7980@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent 6450f65168bcf3c03b5fb44c2fe96682c0d3086b
commit 738da10c6393d13d7a757b1e4cb1fb2c7f98dc56
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sat Aug 23 18:53:37 2008 -0400

include: linux/fs.h: put declarations in __KERNEL__

An anonymous user tried to use symbols from /usr/include/linux/fs.h.
Since these however are not defined in libc, but are specific to the
kernel, they should be in an #ifdef __KERNEL__ section. Move them
there.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/fs.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 580b513..6d7b4a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -21,7 +21,6 @@
 
 /* Fixed constants first: */
 #undef NR_OPEN
-extern int sysctl_nr_open;
 #define INR_OPEN 1024		/* Initial setting for nfile rlimits */
 
 #define BLOCK_SIZE_BITS 10
@@ -38,21 +37,13 @@ struct files_stat_struct {
 	int nr_free_files;	/* read only */
 	int max_files;		/* tunable */
 };
-extern struct files_stat_struct files_stat;
-extern int get_max_files(void);
 
 struct inodes_stat_t {
 	int nr_inodes;
 	int nr_unused;
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
-extern struct inodes_stat_t inodes_stat;
 
-extern int leases_enable, lease_break_time;
-
-#ifdef CONFIG_DNOTIFY
-extern int dir_notify_enable;
-#endif
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -310,6 +301,15 @@ extern void __init inode_init(void);
 extern void __init inode_init_early(void);
 extern void __init files_init(unsigned long);
 
+extern struct files_stat_struct files_stat;
+extern int get_max_files(void);
+extern int sysctl_nr_open;
+extern struct inodes_stat_t inodes_stat;
+extern int leases_enable, lease_break_time;
+#ifdef CONFIG_DNOTIFY
+extern int dir_notify_enable;
+#endif
+
 struct buffer_head;
 typedef int (get_block_t)(struct inode *inode, sector_t iblock,
 			struct buffer_head *bh_result, int create);
