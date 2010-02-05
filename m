Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934057Ab0BEWt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:49:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:37610 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041Ab0BEWtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:49:22 -0500
Date: Fri, 5 Feb 2010 22:49:01 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1265380629-3212-3-git-send-email-brgerst@gmail.com>
References: <1265380629-3212-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/io] x86-32: Remove _local variants of in/out from io_32.h
Message-ID: <tip-bd2984e96452855d148ebce76f696dcecbc96340@git.kernel.org>
Git-Commit-ID: bd2984e96452855d148ebce76f696dcecbc96340
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:49:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd2984e96452855d148ebce76f696dcecbc96340
Gitweb:     http://git.kernel.org/tip/bd2984e96452855d148ebce76f696dcecbc96340
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 5 Feb 2010 09:37:04 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 13:57:18 -0800

x86-32: Remove _local variants of in/out from io_32.h

These were leftover from the numaq support that was removed in commit
1fba38703d0ce8a5ff0fad9df3eccc6b55cf2cfb.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1265380629-3212-3-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
