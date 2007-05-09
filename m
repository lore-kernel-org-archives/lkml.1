Return-Path: <linux-kernel-owner+w=401wt.eu-S969548AbXEIHDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969548AbXEIHDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967969AbXEIHCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:02:52 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967872AbXEIHCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:02:51 -0400
Date: Wed, 9 May 2007 00:02:06 -0700
Message-Id: <200705090702.l49726tb029871@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] i386: remove unused rdtsc() macro
To: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All users to the two-part rdtsc() macro have already switched to using
rdtscl() or rdtscll().  Remove the now-obsolete macro.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 include/asm-i386/msr.h      |    7 -------
 include/asm-i386/paravirt.h |    5 -----
 2 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/asm-i386/msr.h b/include/asm-i386/msr.h
index 26861df..c70773e 100644
--- a/include/asm-i386/msr.h
+++ b/include/asm-i386/msr.h
@@ -121,13 +121,6 @@ static inline void wrmsrl (unsigned long msr, unsigned long long val)
 		__err;							\
 	})
 
-#define rdtsc(low,high)						\
-	do {							\
-		u64 _l = native_read_tsc();			\
-		(low) = (u32)_l;				\
-		(high) = _l >> 32;				\
-	} while(0)
-
 #define rdtscl(low)						\
 	do {							\
 		(low) = native_read_tsc();			\
diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index e2e7f98..bc5c12c 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -560,11 +560,6 @@ static inline u64 paravirt_read_tsc(void)
 {
 	return PVOP_CALL0(u64, read_tsc);
 }
-#define rdtsc(low,high) do {			\
-	u64 _l = paravirt_read_tsc();		\
-	low = (u32)_l;				\
-	high = _l >> 32;			\
-} while(0)
 
 #define rdtscl(low) do {			\
 	u64 _l = paravirt_read_tsc();		\
-- 
1.5.1.3

