Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbYDXXUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbYDXXUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbYDXXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:08:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbYDXXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:06:42 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 23/24] types: add C99-style constructors to <asm-generic/int-*.h>
Date: Thu, 24 Apr 2008 16:05:51 -0700
Message-Id: <1209078352-7593-45-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1209078352-7593-44-git-send-email-hpa@zytor.com>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
 <1209078352-7593-2-git-send-email-hpa@zytor.com>
 <1209078352-7593-3-git-send-email-hpa@zytor.com>
 <1209078352-7593-4-git-send-email-hpa@zytor.com>
 <1209078352-7593-5-git-send-email-hpa@zytor.com>
 <1209078352-7593-6-git-send-email-hpa@zytor.com>
 <1209078352-7593-7-git-send-email-hpa@zytor.com>
 <1209078352-7593-8-git-send-email-hpa@zytor.com>
 <1209078352-7593-9-git-send-email-hpa@zytor.com>
 <1209078352-7593-10-git-send-email-hpa@zytor.com>
 <1209078352-7593-11-git-send-email-hpa@zytor.com>
 <1209078352-7593-12-git-send-email-hpa@zytor.com>
 <1209078352-7593-13-git-send-email-hpa@zytor.com>
 <1209078352-7593-14-git-send-email-hpa@zytor.com>
 <1209078352-7593-15-git-send-email-hpa@zytor.com>
 <1209078352-7593-16-git-send-email-hpa@zytor.com>
 <1209078352-7593-17-git-send-email-hpa@zytor.com>
 <1209078352-7593-18-git-send-email-hpa@zytor.com>
 <1209078352-7593-19-git-send-email-hpa@zytor.com>
 <1209078352-7593-20-git-send-email-hpa@zytor.com>
 <1209078352-7593-21-git-send-email-hpa@zytor.com>
 <1209078352-7593-22-git-send-email-hpa@zytor.com>
 <1209078352-7593-23-git-send-email-hpa@zytor.com>
 <1209078352-7593-24-git-send-email-hpa@zytor.com>
 <1209078352-7593-25-git-send-email-hpa@zytor.com>
 <1209078352-7593-26-git-send-email-hpa@zytor.com>
 <1209078352-7593-27-git-send-email-hpa@zytor.com>
 <1209078352-7593-28-git-send-email-hpa@zytor.com>
 <1209078352-7593-29-git-send-email-hpa@zytor.com>
 <1209078352-7593-30-git-send-email-hpa@zytor.com>
 <1209078352-7593-31-git-send-email-hpa@zytor.com>
 <1209078352-7593-32-git-send-email-hpa@zytor.com>
 <1209078352-7593-33-git-send-email-hpa@zytor.com>
 <1209078352-7593-34-git-send-email-hpa@zytor.com>
 <1209078352-7593-35-git-send-email-hpa@zytor.com>
 <1209078352-7593-36-git-send-email-hpa@zytor.com>
 <1209078352-7593-37-git-send-email-hpa@zytor.com>
 <1209078352-7593-38-git-send-email-hpa@zytor.com>
 <1209078352-7593-39-git-send-email-hpa@zytor.com>
 <1209078352-7593-40-git-send-email-hpa@zytor.com>
 <1209078352-7593-41-git-send-email-hpa@zytor.com>
 <1209078352-7593-42-git-send-email-hpa@zytor.com>
 <1209078352-7593-43-git-send-email-hpa@zytor.com>
 <1209078352-7593-44-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add C99-style constructor macros for fixed types to
<asm-generic/int-*.h>.  Since Linux uses names like "u64" instead of
"uint64_t", the constructor macros are called U64_C() instead of
UINT64_C() and so forth.

These macros allow specific sizes to be specified as
U64_C(0x123456789abcdef), without gcc issuing warnings as it will if
one writes (u64)0x123456789abcdef.

When used from assembly, these macros pass their argument unchanged.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-generic/int-l64.h  |   20 ++++++++++++++++++++
 include/asm-generic/int-ll64.h |   20 ++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
index 629b5a4..2af9b75 100644
--- a/include/asm-generic/int-l64.h
+++ b/include/asm-generic/int-l64.h
@@ -44,6 +44,26 @@ typedef unsigned int u32;
 typedef signed long s64;
 typedef unsigned long u64;
 
+#define S8_C(x)  x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## L
+#define U64_C(x) x ## UL
+
+#else /* __ASSEMBLY__ */
+
+#define S8_C(x)  x
+#define U8_C(x)  x
+#define S16_C(x) x
+#define U16_C(x) x
+#define S32_C(x) x
+#define U32_C(x) x
+#define S64_C(x) x
+#define U64_C(x) x
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-generic/int-ll64.h b/include/asm-generic/int-ll64.h
index 1e5ffec..2609489 100644
--- a/include/asm-generic/int-ll64.h
+++ b/include/asm-generic/int-ll64.h
@@ -49,6 +49,26 @@ typedef unsigned int u32;
 typedef signed long long s64;
 typedef unsigned long long u64;
 
+#define S8_C(x)  x
+#define U8_C(x)  x ## U
+#define S16_C(x) x
+#define U16_C(x) x ## U
+#define S32_C(x) x
+#define U32_C(x) x ## U
+#define S64_C(x) x ## LL
+#define U64_C(x) x ## ULL
+
+#else /* __ASSEMBLY__ */
+
+#define S8_C(x)  x
+#define U8_C(x)  x
+#define S16_C(x) x
+#define U16_C(x) x
+#define S32_C(x) x
+#define U32_C(x) x
+#define S64_C(x) x
+#define U64_C(x) x
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
-- 
1.5.4.1

