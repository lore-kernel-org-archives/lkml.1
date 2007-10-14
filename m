Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbXJNSge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbXJNSge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761081AbXJNSfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47920 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762819AbXJNSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:11 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] frv: missing casts in cmpxchg()
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Message-Id: <E1Ih8Iw-00042W-7v@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-frv/system.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
index 6931af5..9f5663b 100644
--- a/include/asm-frv/system.h
+++ b/include/asm-frv/system.h
@@ -253,7 +253,10 @@ extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
 	__typeof__(*(ptr)) __xg_new = (new);					\
 										\
 	switch (sizeof(__xg_orig)) {						\
-	case 4: __xg_orig = __cmpxchg_32(__xg_ptr, __xg_test, __xg_new); break;	\
+	case 4: __xg_orig = (__force __typeof__(*ptr))				\
+			__cmpxchg_32((__force uint32_t *)__xg_ptr,		\
+					 (__force uint32_t)__xg_test,		\
+					 (__force uint32_t)__xg_new); break;	\
 	default:								\
 		__xg_orig = 0;							\
 		asm volatile("break");						\
-- 
1.5.3.GIT


