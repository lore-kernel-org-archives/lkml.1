Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010AbYKRDk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbYKRDk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYKRDjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:19 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:23939 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbYKRDjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uyXDo79IY+ITcxxMqBfVwWiwFMR3+OUopcJrwSVf98UgrV1fOXDe2n8fNoPHDhQfJI
         CtIh8OrzhAo0NK+jleBeytBpUKo+sOENfGGEv/26+xbDHTH3ZpNCpE5Pqq0A+5741y5g
         i18aledHVbMWKXUjK1Oxt2zTl93u8vjKaEfHQ=
Subject: [PATCH-mm 4/7] unaligned: remove packed-struct and unaligned
 access_ok headers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:11 -0800
Message-Id: <1226979552.6150.269.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm-generic version of unaligned.h now contains these bits.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/unaligned/access_ok.h     |   67 -------------------------------
 include/linux/unaligned/be_struct.h     |   36 ----------------
 include/linux/unaligned/le_struct.h     |   36 ----------------
 include/linux/unaligned/packed_struct.h |   46 ---------------------
 4 files changed, 0 insertions(+), 185 deletions(-)

diff --git a/include/linux/unaligned/access_ok.h b/include/linux/unaligned/access_ok.h
deleted file mode 100644
index 99c1b4d..0000000
--- a/include/linux/unaligned/access_ok.h
+++ /dev/null
@@ -1,67 +0,0 @@
-#ifndef _LINUX_UNALIGNED_ACCESS_OK_H
-#define _LINUX_UNALIGNED_ACCESS_OK_H
-
-#include <linux/kernel.h>
-#include <asm/byteorder.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return le16_to_cpup((__le16 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return le32_to_cpup((__le32 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return le64_to_cpup((__le64 *)p);
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return be16_to_cpup((__be16 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return be32_to_cpup((__be32 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return be64_to_cpup((__be64 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	*((__le16 *)p) = cpu_to_le16(val);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	*((__le32 *)p) = cpu_to_le32(val);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	*((__le64 *)p) = cpu_to_le64(val);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	*((__be16 *)p) = cpu_to_be16(val);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	*((__be32 *)p) = cpu_to_be32(val);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	*((__be64 *)p) = cpu_to_be64(val);
-}
-
-#endif /* _LINUX_UNALIGNED_ACCESS_OK_H */
diff --git a/include/linux/unaligned/be_struct.h b/include/linux/unaligned/be_struct.h
deleted file mode 100644
index 1324158..0000000
--- a/include/linux/unaligned/be_struct.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_STRUCT_H
-#define _LINUX_UNALIGNED_BE_STRUCT_H
-
-#include <linux/unaligned/packed_struct.h>
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_cpu16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_cpu32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_cpu64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_cpu16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_cpu32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_cpu64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_BE_STRUCT_H */
diff --git a/include/linux/unaligned/le_struct.h b/include/linux/unaligned/le_struct.h
deleted file mode 100644
index 088c457..0000000
--- a/include/linux/unaligned/le_struct.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_STRUCT_H
-#define _LINUX_UNALIGNED_LE_STRUCT_H
-
-#include <linux/unaligned/packed_struct.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_cpu16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_cpu32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_cpu64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_cpu16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_cpu32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_cpu64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_STRUCT_H */
diff --git a/include/linux/unaligned/packed_struct.h b/include/linux/unaligned/packed_struct.h
deleted file mode 100644
index 2498bb9..0000000
--- a/include/linux/unaligned/packed_struct.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef _LINUX_UNALIGNED_PACKED_STRUCT_H
-#define _LINUX_UNALIGNED_PACKED_STRUCT_H
-
-#include <linux/kernel.h>
-
-struct __una_u16 { u16 x __attribute__((packed)); };
-struct __una_u32 { u32 x __attribute__((packed)); };
-struct __una_u64 { u64 x __attribute__((packed)); };
-
-static inline u16 __get_unaligned_cpu16(const void *p)
-{
-	const struct __una_u16 *ptr = (const struct __una_u16 *)p;
-	return ptr->x;
-}
-
-static inline u32 __get_unaligned_cpu32(const void *p)
-{
-	const struct __una_u32 *ptr = (const struct __una_u32 *)p;
-	return ptr->x;
-}
-
-static inline u64 __get_unaligned_cpu64(const void *p)
-{
-	const struct __una_u64 *ptr = (const struct __una_u64 *)p;
-	return ptr->x;
-}
-
-static inline void __put_unaligned_cpu16(u16 val, void *p)
-{
-	struct __una_u16 *ptr = (struct __una_u16 *)p;
-	ptr->x = val;
-}
-
-static inline void __put_unaligned_cpu32(u32 val, void *p)
-{
-	struct __una_u32 *ptr = (struct __una_u32 *)p;
-	ptr->x = val;
-}
-
-static inline void __put_unaligned_cpu64(u64 val, void *p)
-{
-	struct __una_u64 *ptr = (struct __una_u64 *)p;
-	ptr->x = val;
-}
-
-#endif /* _LINUX_UNALIGNED_PACKED_STRUCT_H */
-- 
1.6.0.4.994.g16bd3e


