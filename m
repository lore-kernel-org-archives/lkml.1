Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYGYQdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYGYQdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYGYQdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:33:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:38107 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYGYQdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=HJ6nZw6tWuSJU84yYC00ER6RDHd/RuaZ9ONc60Vyg9j6kQEz98tHPas8cggAfWVPGZ
         +hZOXJUGc0I/Or10q2vFqdiMrMV2dBra6UhiS3PHBoGUcUx8fNEAG80WnFVJDxzp+dMo
         /BqNPgMx+mLrc8F8wf7iDZpylHZ8+T8vtaLDQ=
Subject: [PATCH] byteorder: force in-place endian conversion to always
	evaluate args
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 09:33:41 -0700
Message-Id: <1217003621.5971.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller reported breakage in ide when the in-place byteorder helpers
were used as the macros do not always evaluate their args which led to
an infinite loop.

Just make them functions to ensure they always do so.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/byteorder/big_endian.h    |   60 ++++++++++++++++++++++++------
 include/linux/byteorder/little_endian.h |   60 ++++++++++++++++++++++++------
 2 files changed, 96 insertions(+), 24 deletions(-)

diff --git a/include/linux/byteorder/big_endian.h b/include/linux/byteorder/big_endian.h
index 961ed4b..b53ccd0 100644
--- a/include/linux/byteorder/big_endian.h
+++ b/include/linux/byteorder/big_endian.h
@@ -88,18 +88,54 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 {
 	return (__force __u16)*p;
 }
-#define __cpu_to_le64s(x) __swab64s((x))
-#define __le64_to_cpus(x) __swab64s((x))
-#define __cpu_to_le32s(x) __swab32s((x))
-#define __le32_to_cpus(x) __swab32s((x))
-#define __cpu_to_le16s(x) __swab16s((x))
-#define __le16_to_cpus(x) __swab16s((x))
-#define __cpu_to_be64s(x) do {} while (0)
-#define __be64_to_cpus(x) do {} while (0)
-#define __cpu_to_be32s(x) do {} while (0)
-#define __be32_to_cpus(x) do {} while (0)
-#define __cpu_to_be16s(x) do {} while (0)
-#define __be16_to_cpus(x) do {} while (0)
+
+static inline void __cpu_to_le64s(__u64 *p)
+{
+	__swab64s(x);
+}
+
+static inline void __le64_to_cpus(__u64 *p)
+{
+	__swab64s(x);
+}
+
+static inline void __cpu_to_le32s(__u32 *p)
+{
+	__swab32s(x);
+}
+
+static inline void __le32_to_cpus(__u32 *p)
+{
+	__swab32s(x);
+}
+
+static inline void __cpu_to_le16s(__u16 *p)
+{
+	__swab16s(x);
+}
+
+static inline void __le16_to_cpus(__u16 *p)
+{
+	__swab16s(x);
+}
+
+static inline void __cpu_to_be64s(__u64 *p)
+{}
+
+static inline void __be64_to_cpus(__u64 *p)
+{}
+
+static inline void __cpu_to_be32s(__u32 *p)
+{}
+
+static inline void __be32_to_cpus(__u32 *p)
+{}
+
+static inline void __cpu_to_be16s(__u16 *p)
+{}
+
+static inline void __be16_to_cpus(__u16 *p)
+{}
 
 #ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
diff --git a/include/linux/byteorder/little_endian.h b/include/linux/byteorder/little_endian.h
index 05dc7c3..5d12ff8 100644
--- a/include/linux/byteorder/little_endian.h
+++ b/include/linux/byteorder/little_endian.h
@@ -88,18 +88,54 @@ static inline __u16 __be16_to_cpup(const __be16 *p)
 {
 	return __swab16p((__u16 *)p);
 }
-#define __cpu_to_le64s(x) do {} while (0)
-#define __le64_to_cpus(x) do {} while (0)
-#define __cpu_to_le32s(x) do {} while (0)
-#define __le32_to_cpus(x) do {} while (0)
-#define __cpu_to_le16s(x) do {} while (0)
-#define __le16_to_cpus(x) do {} while (0)
-#define __cpu_to_be64s(x) __swab64s((x))
-#define __be64_to_cpus(x) __swab64s((x))
-#define __cpu_to_be32s(x) __swab32s((x))
-#define __be32_to_cpus(x) __swab32s((x))
-#define __cpu_to_be16s(x) __swab16s((x))
-#define __be16_to_cpus(x) __swab16s((x))
+
+static inline void __cpu_to_le64s(__u64 *p)
+{}
+
+static inline void __le64_to_cpus(__u64 *p)
+{}
+
+static inline void __cpu_to_le32s(__u32 *p)
+{}
+
+static inline void __le32_to_cpus(__u32 *p)
+{}
+
+static inline void __cpu_to_le16s(__u16 *p)
+{}
+
+static inline void __le16_to_cpus(__u16 *p)
+{}
+
+static inline void __cpu_to_be64s(__u64 *p)
+{
+	__swab64s(x);
+}
+
+static inline void __be64_to_cpus(__u64 *p)
+{
+	__swab64s(x);
+}
+
+static inline void __cpu_to_be32s(__u32 *p)
+{
+	__swab32s(x);
+}
+
+static inline void __be32_to_cpus(__u32 *p)
+{
+	__swab32s(x);
+}
+
+static inline void __cpu_to_be16s(__u16 *p)
+{
+	__swab16s(x);
+}
+
+static inline void __be16_to_cpus(__u16 *p)
+{
+	__swab16s(x);
+}
 
 #ifdef __KERNEL__
 #include <linux/byteorder/generic.h>
-- 
1.5.6.4.570.g052e



