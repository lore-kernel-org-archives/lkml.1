Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYICJiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYICJiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYICJh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:37:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:44240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYICJh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:37:58 -0400
Subject: [PATCH 2/8] ARM: Use <asm-generic/statfs.h>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1220275314.2982.83.camel@pmac.infradead.org>
References: <1220275314.2982.83.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 10:37:56 +0100
Message-Id: <1220434676.2985.62.camel@pmac.infradead.org>
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
 arch/arm/include/asm/statfs.h |   34 ++--------------------------------
 1 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/arch/arm/include/asm/statfs.h b/arch/arm/include/asm/statfs.h
index a02e6a8..079447c 100644
--- a/arch/arm/include/asm/statfs.h
+++ b/arch/arm/include/asm/statfs.h
@@ -1,42 +1,12 @@
 #ifndef _ASMARM_STATFS_H
 #define _ASMARM_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
-typedef __kernel_fsid_t	fsid_t;
-#endif
-
-struct statfs {
-	__u32 f_type;
-	__u32 f_bsize;
-	__u32 f_blocks;
-	__u32 f_bfree;
-	__u32 f_bavail;
-	__u32 f_files;
-	__u32 f_ffree;
-	__kernel_fsid_t f_fsid;
-	__u32 f_namelen;
-	__u32 f_frsize;
-	__u32 f_spare[5];
-};
-
 /*
  * With EABI there is 4 bytes of padding added to this structure.
  * Let's pack it so the padding goes away to simplify dual ABI support.
  * Note that user space does NOT have to pack this structure.
  */
-struct statfs64 {
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
-} __attribute__ ((packed,aligned(4)));
+#define ARCH_PACK_STATFS64 __attribute__((packed,aligned(4)))
 
+#include <asm-generic/statfs.h>
 #endif
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



