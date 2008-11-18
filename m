Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYKRDlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYKRDlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 22:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYKRDja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 22:39:30 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:33618 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYKRDj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 22:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=voPYJoXbtHh72AYMldhSdHkrwfgLG6y6Xk8eyK/6OQsYGkFSFO4FaHWja22l0EohZL
         jdvq38XQFwWwARLQmgnlpX8sALFqT+GVKN6ate46WQWjo+LRzKgKd33G1cdWIkxx5Wx/
         Uguq7YshVLI2Om0tLGDHZU2T58ASxYfd9n4Ug=
Subject: [PATCH-mm 7/7] unaligned: remove last bits of the unaligned access
 helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Newton <will.newton@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 19:39:14 -0800
Message-Id: <1226979554.6150.272.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/unaligned/be_byteshift.h |   70 --------------------------------
 include/linux/unaligned/be_memmove.h   |   36 ----------------
 include/linux/unaligned/generic.h      |   68 -------------------------------
 include/linux/unaligned/le_byteshift.h |   70 --------------------------------
 include/linux/unaligned/le_memmove.h   |   36 ----------------
 include/linux/unaligned/memmove.h      |   45 --------------------
 6 files changed, 0 insertions(+), 325 deletions(-)

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
-- 
1.6.0.4.994.g16bd3e

