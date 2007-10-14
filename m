Return-Path: <linux-kernel-owner+w=401wt.eu-S1763467AbXJNSgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763467AbXJNSgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763323AbXJNSfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47917 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbXJNSfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:03 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] endian-clean in_le64/out_le64
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Message-Id: <E1Ih8Im-00041u-6N@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:00 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-powerpc/io.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-powerpc/io.h b/include/asm-powerpc/io.h
index affba70..0d0589e 100644
--- a/include/asm-powerpc/io.h
+++ b/include/asm-powerpc/io.h
@@ -138,12 +138,12 @@ DEF_MMIO_IN_BE(in_be64, 64, ld);
 /* There is no asm instructions for 64 bits reverse loads and stores */
 static inline u64 in_le64(const volatile u64 __iomem *addr)
 {
-	return le64_to_cpu(in_be64(addr));
+	return swab64(in_be64(addr));
 }
 
 static inline void out_le64(volatile u64 __iomem *addr, u64 val)
 {
-	out_be64(addr, cpu_to_le64(val));
+	out_be64(addr, swab64(val));
 }
 #endif /* __powerpc64__ */
 
-- 
1.5.3.GIT


