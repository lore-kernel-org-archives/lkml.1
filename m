Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbYICJjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbYICJjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYICJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:38:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:44241 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYICJiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:38:07 -0400
Subject: [PATCH 3/8] IA64: Use <asm-generic/statfs.h>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1220275314.2982.83.camel@pmac.infradead.org>
References: <1220275314.2982.83.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:38:04 +0100
Message-Id: <1220434684.2985.63.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/ia64/include/asm/statfs.h |   52 ++++------------------------------------
 1 files changed, 5 insertions(+), 47 deletions(-)

diff --git a/arch/ia64/include/asm/statfs.h b/arch/ia64/include/asm/statfs.h
index 8110979..1e58966 100644
--- a/arch/ia64/include/asm/statfs.h
+++ b/arch/ia64/include/asm/statfs.h
@@ -8,55 +8,13 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co
  */
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
 /*
- * This is ugly --- we're already 64-bit, so just duplicate the definitions
+ * We need compat_statfs64 to be packed, because the i386 ABI won't
+ * add padding at the end to bring it to a multiple of 8 bytes, but
+ * the IA64 ABI will.
  */
-struct statfs {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
-
-
-struct statfs64 {
-	long f_type;
-	long f_bsize;
-	long f_blocks;
-	long f_bfree;
-	long f_bavail;
-	long f_files;
-	long f_ffree;
-	__kernel_fsid_t f_fsid;
-	long f_namelen;
-	long f_frsize;
-	long f_spare[5];
-};
+#define ARCH_PACK_COMPAT_STATFS64 __attribute__((packed,aligned(4)))
 
-struct compat_statfs64 {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u64 f_blocks;
-	__u64 f_bfree;
-	__u64 f_bavail;
-	__u64 f_files;
-	__u64 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-} __attribute__((packed));
+#include <asm-generic/statfs.h>
 
 #endif /* _ASM_IA64_STATFS_H */
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



