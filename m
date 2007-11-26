Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbXKZRUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbXKZRUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbXKZRUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:20:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327AbXKZRUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:20:03 -0500
Message-ID: <474B003D.7040908@redhat.com>
Date: Mon, 26 Nov 2007 11:19:57 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, mbligh@mbligh.org,
       Valerie Henson <val.henson@intel.com>
Subject: [PATCH] fix up ext2_fs.h for userspace after reservations backport
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Poschwatta <tp@fonz.de>

In commit a686cd898bd999fd026a51e90fb0a3410d258ddb:

 "Val's cross-port of the ext3 reservations code into ext2."

include/linux/ext2_fs.h got a new function whose return value is only
defined if __KERNEL__ is defined. Putting #ifdef __KERNEL__ around the
function seems to help, patch below.

BR, Tobias

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc1/include/linux/ext2_fs.h
===================================================================
--- linux-2.6.24-rc1.orig/include/linux/ext2_fs.h
+++ linux-2.6.24-rc1/include/linux/ext2_fs.h
@@ -563,11 +563,13 @@ enum {
 					 ~EXT2_DIR_ROUND)
 #define EXT2_MAX_REC_LEN		((1<<16)-1)
 
+#ifdef __KERNEL__
 static inline ext2_fsblk_t
 ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
 {
 	return group_no * (ext2_fsblk_t)EXT2_BLOCKS_PER_GROUP(sb) +
 		le32_to_cpu(EXT2_SB(sb)->s_es->s_first_data_block);
 }
+#endif
 
 #endif	/* _LINUX_EXT2_FS_H */

