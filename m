Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYG3Aza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYG3Aza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 20:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYG3AzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 20:55:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:59233 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYG3AzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 20:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Gq4VrMeyBQgTgxot+ZGbZ7sOnJF9lDZ1hSTajkNAjsMA/POFGw81IKKSPNkcwuq4yp
         od73yIJlvngniq7WoXQMwy37h/79TpTxJOLUBWJoS/YYTkHZwHtNXknKEAF3OGM5ru7z
         9OLzyP3F1yHgdJnaL392tQLmTuiFrm16i5Hk4=
Subject: [PATCH 01/24] byteorder: update arch override definitions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 17:55:17 -0700
Message-Id: <1217379317.23389.112.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus prefers the actual function name be used as the guard.

Makes it greppable for all places that define/use the __arch
version.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, an update for byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch

Linus expressed his dislike for the HAVE_ARCH_ format as it becomes ungreppable to
see who actually uses it.

New versions of all the arch wire-ups as well, with acks for avr32 and mips from
arch maintainers.

 include/linux/swab.h |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/swab.h b/include/linux/swab.h
index 8f955b2..270d5c2 100644
--- a/include/linux/swab.h
+++ b/include/linux/swab.h
@@ -45,9 +45,9 @@
 
 static inline __attribute_const__ __u16 ___swab16(__u16 val)
 {
-#ifdef HAVE_ARCH_SWAB16
+#ifdef __arch_swab16
 	return __arch_swab16(val);
-#elif defined(HAVE_ARCH_SWAB16P)
+#elif defined(__arch_swab16p)
 	return __arch_swab16p(&val);
 #else
 	return __const_swab16(val);
@@ -56,9 +56,9 @@ static inline __attribute_const__ __u16 ___swab16(__u16 val)
 
 static inline __attribute_const__ __u32 ___swab32(__u32 val)
 {
-#ifdef HAVE_ARCH_SWAB32
+#ifdef __arch_swab32
 	return __arch_swab32(val);
-#elif defined(HAVE_ARCH_SWAB32P)
+#elif defined(__arch_swab32p)
 	return __arch_swab32p(&val);
 #else
 	return __const_swab32(val);
@@ -67,9 +67,9 @@ static inline __attribute_const__ __u32 ___swab32(__u32 val)
 
 static inline __attribute_const__ __u64 ___swab64(__u64 val)
 {
-#ifdef HAVE_ARCH_SWAB64
+#ifdef __arch_swab64
 	return __arch_swab64(val);
-#elif defined(HAVE_ARCH_SWAB64P)
+#elif defined(__arch_swab64p)
 	return __arch_swab64p(&val);
 #elif defined(__SWAB_64_THRU_32__)
 	__u32 h = val >> 32;
@@ -82,9 +82,9 @@ static inline __attribute_const__ __u64 ___swab64(__u64 val)
 
 static inline __attribute_const__ __u32 ___swahw32(__u32 val)
 {
-#ifdef HAVE_ARCH_SWAHW32
+#ifdef __arch_swahw32
 	return __arch_swahw32(val);
-#elif defined(HAVE_ARCH_SWAHW32P)
+#elif defined(__arch_swahw32p)
 	return __arch_swahw32p(&val);
 #else
 	return __const_swahw32(val);
@@ -93,9 +93,9 @@ static inline __attribute_const__ __u32 ___swahw32(__u32 val)
 
 static inline __attribute_const__ __u32 ___swahb32(__u32 val)
 {
-#ifdef HAVE_ARCH_SWAHB32
+#ifdef __arch_swahb32
 	return __arch_swahb32(val);
-#elif defined(HAVE_ARCH_SWAHB32P)
+#elif defined(__arch_swahb32p)
 	return __arch_swahb32p(&val);
 #else
 	return __const_swahb32(val);
@@ -157,7 +157,7 @@ static inline __attribute_const__ __u32 ___swahb32(__u32 val)
  */
 static inline __u16 __swab16p(const __u16 *p)
 {
-#ifdef HAVE_ARCH_SWAB16P
+#ifdef __arch_swab16p
 	return __arch_swab16p(p);
 #else
 	return __swab16(*p);
@@ -170,7 +170,7 @@ static inline __u16 __swab16p(const __u16 *p)
  */
 static inline __u32 __swab32p(const __u32 *p)
 {
-#ifdef HAVE_ARCH_SWAB32P
+#ifdef __arch_swab32p
 	return __arch_swab32p(p);
 #else
 	return __swab32(*p);
@@ -183,7 +183,7 @@ static inline __u32 __swab32p(const __u32 *p)
  */
 static inline __u64 __swab64p(const __u64 *p)
 {
-#ifdef HAVE_ARCH_SWAB64P
+#ifdef __arch_swab64p
 	return __arch_swab64p(p);
 #else
 	return __swab64(*p);
@@ -198,7 +198,7 @@ static inline __u64 __swab64p(const __u64 *p)
  */
 static inline __u32 __swahw32p(const __u32 *p)
 {
-#ifdef HAVE_ARCH_SWAHW32P
+#ifdef __arch_swahw32p
 	return __arch_swahw32p(p);
 #else
 	return __swahw32(*p);
@@ -213,7 +213,7 @@ static inline __u32 __swahw32p(const __u32 *p)
  */
 static inline __u32 __swahb32p(const __u32 *p)
 {
-#ifdef HAVE_ARCH_SWAHB32P
+#ifdef __arch_swahb32p
 	return __arch_swahb32p(p);
 #else
 	return __swahb32(*p);
@@ -226,7 +226,7 @@ static inline __u32 __swahb32p(const __u32 *p)
  */
 static inline void __swab16s(__u16 *p)
 {
-#ifdef HAVE_ARCH_SWAB16S
+#ifdef __arch_swab16s
 	__arch_swab16s(p);
 #else
 	*p = __swab16p(p);
@@ -238,7 +238,7 @@ static inline void __swab16s(__u16 *p)
  */
 static inline void __swab32s(__u32 *p)
 {
-#ifdef HAVE_ARCH_SWAB32S
+#ifdef __arch_swab32s
 	__arch_swab32s(p);
 #else
 	*p = __swab32p(p);
@@ -251,7 +251,7 @@ static inline void __swab32s(__u32 *p)
  */
 static inline void __swab64s(__u64 *p)
 {
-#ifdef HAVE_ARCH_SWAB64S
+#ifdef __arch_swab64s
 	__arch_swab64s(p);
 #else
 	*p = __swab64p(p);
@@ -266,7 +266,7 @@ static inline void __swab64s(__u64 *p)
  */
 static inline void __swahw32s(__u32 *p)
 {
-#ifdef HAVE_ARCH_SWAHW32S
+#ifdef __arch_swahw32s
 	__arch_swahw32s(p);
 #else
 	*p = __swahw32p(p);
@@ -281,7 +281,7 @@ static inline void __swahw32s(__u32 *p)
  */
 static inline void __swahb32s(__u32 *p)
 {
-#ifdef HAVE_ARCH_SWAHB32S
+#ifdef __arch_swahb32s
 	__arch_swahb32s(p);
 #else
 	*p = __swahb32p(p);
-- 
1.6.0.rc1.154.ge3fc


