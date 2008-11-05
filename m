Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbYKESR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbYKESR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYKESQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:16:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:5002 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYKESQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:16:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=GauW12KX58mDeAtsz6WtFn0z/E6Tb9kzqYr9laeViAKOc5LQjDDRHNIjNbKU0krKQC
         0wRktYgNifHh3XeSkwEzMOQbhQNSgs+ROwGuGTxC5TNWP3dulcvIPZzOG25VENZLDwpf
         wfW2VDQZSf1apS5AnYXzxwhboPa3EYvrITnr0=
Subject: [RFC-PATCH 5/5] unaligned: remove old implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 10:16:18 -0800
Message-Id: <1225908978.5991.184.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/unaligned/access_ok.h     |   67 -----------------------------
 include/linux/unaligned/be_byteshift.h  |   70 -------------------------------
 include/linux/unaligned/be_memmove.h    |   36 ----------------
 include/linux/unaligned/be_struct.h     |   36 ----------------
 include/linux/unaligned/generic.h       |   68 ------------------------------
 include/linux/unaligned/le_byteshift.h  |   70 -------------------------------
 include/linux/unaligned/le_memmove.h    |   36 ----------------
 include/linux/unaligned/le_struct.h     |   36 ----------------
 include/linux/unaligned/memmove.h       |   45 --------------------
 include/linux/unaligned/packed_struct.h |   46 --------------------
 10 files changed, 0 insertions(+), 510 deletions(-)

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
diff --git a/include/linux/unaligned/be_byteshift.h b/include/linux/unaligned/be_byteshift.h
deleted file mode 100644
index 46dd12c..0000000
--- a/include/linux/unaligned/be_byteshift.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_BYTESHIFT_H
-#define _LINUX_UNALIGNED_BE_BYTESHIFT_H
-
-#include <linux/kernel.h>
-
-static inline u16 __get_unaligned_be16(const u8 *p)
-{
-	return p[0] << 8 | p[1];
-}
-
-static inline u32 __get_unaligned_be32(const u8 *p)
-{
-	return p[0] << 24 | p[1] << 16 | p[2] << 8 | p[3];
-}
-
-static inline u64 __get_unaligned_be64(const u8 *p)
-{
-	return (u64)__get_unaligned_be32(p) << 32 |
-	       __get_unaligned_be32(p + 4);
-}
-
-static inline void __put_unaligned_be16(u16 val, u8 *p)
-{
-	*p++ = val >> 8;
-	*p++ = val;
-}
-
-static inline void __put_unaligned_be32(u32 val, u8 *p)
-{
-	__put_unaligned_be16(val >> 16, p);
-	__put_unaligned_be16(val, p + 2);
-}
-
-static inline void __put_unaligned_be64(u64 val, u8 *p)
-{
-	__put_unaligned_be32(val >> 32, p);
-	__put_unaligned_be32(val, p + 4);
-}
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_be16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_be32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_be64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_be16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_be32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_be64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_BE_BYTESHIFT_H */
diff --git a/include/linux/unaligned/be_memmove.h b/include/linux/unaligned/be_memmove.h
deleted file mode 100644
index c2a76c5..0000000
--- a/include/linux/unaligned/be_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_BE_MEMMOVE_H
-#define _LINUX_UNALIGNED_BE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_be16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_be32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_be64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_be16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_be32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_be64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
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
diff --git a/include/linux/unaligned/generic.h b/include/linux/unaligned/generic.h
deleted file mode 100644
index 02d97ff..0000000
--- a/include/linux/unaligned/generic.h
+++ /dev/null
@@ -1,68 +0,0 @@
-#ifndef _LINUX_UNALIGNED_GENERIC_H
-#define _LINUX_UNALIGNED_GENERIC_H
-
-/*
- * Cause a link-time error if we try an unaligned access other than
- * 1,2,4 or 8 bytes long
- */
-extern void __bad_unaligned_access_size(void);
-
-#define __get_unaligned_le(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_le16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_le32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_le64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __get_unaligned_be(ptr) ((__force typeof(*(ptr)))({			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 1, *(ptr),			\
-	__builtin_choose_expr(sizeof(*(ptr)) == 2, get_unaligned_be16((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 4, get_unaligned_be32((ptr)),	\
-	__builtin_choose_expr(sizeof(*(ptr)) == 8, get_unaligned_be64((ptr)),	\
-	__bad_unaligned_access_size()))));					\
-	}))
-
-#define __put_unaligned_le(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_le16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_le32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_le64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#define __put_unaligned_be(val, ptr) ({					\
-	void *__gu_p = (ptr);						\
-	switch (sizeof(*(ptr))) {					\
-	case 1:								\
-		*(u8 *)__gu_p = (__force u8)(val);			\
-		break;							\
-	case 2:								\
-		put_unaligned_be16((__force u16)(val), __gu_p);		\
-		break;							\
-	case 4:								\
-		put_unaligned_be32((__force u32)(val), __gu_p);		\
-		break;							\
-	case 8:								\
-		put_unaligned_be64((__force u64)(val), __gu_p);		\
-		break;							\
-	default:							\
-		__bad_unaligned_access_size();				\
-		break;							\
-	}								\
-	(void)0; })
-
-#endif /* _LINUX_UNALIGNED_GENERIC_H */
diff --git a/include/linux/unaligned/le_byteshift.h b/include/linux/unaligned/le_byteshift.h
deleted file mode 100644
index 59777e9..0000000
--- a/include/linux/unaligned/le_byteshift.h
+++ /dev/null
@@ -1,70 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_BYTESHIFT_H
-#define _LINUX_UNALIGNED_LE_BYTESHIFT_H
-
-#include <linux/kernel.h>
-
-static inline u16 __get_unaligned_le16(const u8 *p)
-{
-	return p[0] | p[1] << 8;
-}
-
-static inline u32 __get_unaligned_le32(const u8 *p)
-{
-	return p[0] | p[1] << 8 | p[2] << 16 | p[3] << 24;
-}
-
-static inline u64 __get_unaligned_le64(const u8 *p)
-{
-	return (u64)__get_unaligned_le32(p + 4) << 32 |
-	       __get_unaligned_le32(p);
-}
-
-static inline void __put_unaligned_le16(u16 val, u8 *p)
-{
-	*p++ = val;
-	*p++ = val >> 8;
-}
-
-static inline void __put_unaligned_le32(u32 val, u8 *p)
-{
-	__put_unaligned_le16(val >> 16, p + 2);
-	__put_unaligned_le16(val, p);
-}
-
-static inline void __put_unaligned_le64(u64 val, u8 *p)
-{
-	__put_unaligned_le32(val >> 32, p + 4);
-	__put_unaligned_le32(val, p);
-}
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_le16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_le32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_le64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_le16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_le32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_le64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_BYTESHIFT_H */
diff --git a/include/linux/unaligned/le_memmove.h b/include/linux/unaligned/le_memmove.h
deleted file mode 100644
index 269849b..0000000
--- a/include/linux/unaligned/le_memmove.h
+++ /dev/null
@@ -1,36 +0,0 @@
-#ifndef _LINUX_UNALIGNED_LE_MEMMOVE_H
-#define _LINUX_UNALIGNED_LE_MEMMOVE_H
-
-#include <linux/unaligned/memmove.h>
-
-static inline u16 get_unaligned_le16(const void *p)
-{
-	return __get_unaligned_memmove16((const u8 *)p);
-}
-
-static inline u32 get_unaligned_le32(const void *p)
-{
-	return __get_unaligned_memmove32((const u8 *)p);
-}
-
-static inline u64 get_unaligned_le64(const void *p)
-{
-	return __get_unaligned_memmove64((const u8 *)p);
-}
-
-static inline void put_unaligned_le16(u16 val, void *p)
-{
-	__put_unaligned_memmove16(val, p);
-}
-
-static inline void put_unaligned_le32(u32 val, void *p)
-{
-	__put_unaligned_memmove32(val, p);
-}
-
-static inline void put_unaligned_le64(u64 val, void *p)
-{
-	__put_unaligned_memmove64(val, p);
-}
-
-#endif /* _LINUX_UNALIGNED_LE_MEMMOVE_H */
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
diff --git a/include/linux/unaligned/memmove.h b/include/linux/unaligned/memmove.h
deleted file mode 100644
index eeb5a77..0000000
--- a/include/linux/unaligned/memmove.h
+++ /dev/null
@@ -1,45 +0,0 @@
-#ifndef _LINUX_UNALIGNED_MEMMOVE_H
-#define _LINUX_UNALIGNED_MEMMOVE_H
-
-#include <linux/kernel.h>
-#include <linux/string.h>
-
-/* Use memmove here, so gcc does not insert a __builtin_memcpy. */
-
-static inline u16 __get_unaligned_memmove16(const void *p)
-{
-	u16 tmp;
-	memmove(&tmp, p, 2);
-	return tmp;
-}
-
-static inline u32 __get_unaligned_memmove32(const void *p)
-{
-	u32 tmp;
-	memmove(&tmp, p, 4);
-	return tmp;
-}
-
-static inline u64 __get_unaligned_memmove64(const void *p)
-{
-	u64 tmp;
-	memmove(&tmp, p, 8);
-	return tmp;
-}
-
-static inline void __put_unaligned_memmove16(u16 val, void *p)
-{
-	memmove(p, &val, 2);
-}
-
-static inline void __put_unaligned_memmove32(u32 val, void *p)
-{
-	memmove(p, &val, 4);
-}
-
-static inline void __put_unaligned_memmove64(u64 val, void *p)
-{
-	memmove(p, &val, 8);
-}
-
-#endif /* _LINUX_UNALIGNED_MEMMOVE_H */
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
1.6.0.3.756.gb776d

