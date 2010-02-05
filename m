Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab0BEOin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 09:38:43 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:56967 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749Ab0BEOhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 09:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h1aOGAYx4CcROni/PafHpDTC9A+zICw6FHzDlGfs/OKwZBEurNMjL3DxTWT/Y3N3pi
         YIKUa7Q3wsZ9H3x7wfcN8Bl4XilxhzR/ijGV3/t75ZCsKDgkbPUN3jtYulBaGjfGsYQC
         fKcQ9W3rjfwDx5R3VFByAVyDQ7KHTCVW2xVX8=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] x86-32: Remove _local variants of in/out from io_32.h
Date: Fri,  5 Feb 2010 09:37:04 -0500
Message-Id: <1265380629-3212-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were leftover from the numaq support that was removed in commit
1fba38703d0ce8a5ff0fad9df3eccc6b55cf2cfb.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/io_32.h |   34 ++++------------------------------
 1 files changed, 4 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/io_32.h b/arch/x86/include/asm/io_32.h
index e16b9db..72a6a4a 100644
--- a/arch/x86/include/asm/io_32.h
+++ b/arch/x86/include/asm/io_32.h
@@ -120,47 +120,21 @@ static inline void slow_down_io(void)
 
 #endif
 
-#define __BUILDIO(bwl, bw, type)				\
-static inline void out##bwl(unsigned type value, int port)	\
-{								\
-	out##bwl##_local(value, port);				\
-}								\
-								\
-static inline unsigned type in##bwl(int port)			\
-{								\
-	return in##bwl##_local(port);				\
-}
-
 #define BUILDIO(bwl, bw, type)						\
-static inline void out##bwl##_local(unsigned type value, int port)	\
+static inline void out##bwl(unsigned type value, int port)		\
 {									\
-	asm volatile("out" #bwl " %" #bw "0, %w1"		\
+	asm volatile("out" #bwl " %" #bw "0, %w1"			\
 		     : : "a"(value), "Nd"(port));			\
 }									\
 									\
-static inline unsigned type in##bwl##_local(int port)			\
+static inline unsigned type in##bwl(int port)				\
 {									\
 	unsigned type value;						\
-	asm volatile("in" #bwl " %w1, %" #bw "0"		\
+	asm volatile("in" #bwl " %w1, %" #bw "0"			\
 		     : "=a"(value) : "Nd"(port));			\
 	return value;							\
 }									\
 									\
-static inline void out##bwl##_local_p(unsigned type value, int port)	\
-{									\
-	out##bwl##_local(value, port);					\
-	slow_down_io();							\
-}									\
-									\
-static inline unsigned type in##bwl##_local_p(int port)			\
-{									\
-	unsigned type value = in##bwl##_local(port);			\
-	slow_down_io();							\
-	return value;							\
-}									\
-									\
-__BUILDIO(bwl, bw, type)						\
-									\
 static inline void out##bwl##_p(unsigned type value, int port)		\
 {									\
 	out##bwl(value, port);						\
-- 
1.6.6

