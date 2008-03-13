Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYCMBCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYCMBCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 21:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYCMBBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 21:01:41 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:53900 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbYCMBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 21:01:40 -0400
Message-Id: <20080313004903.046240368@linux-m68k.org>
References: <20080313002235.351414762@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Thu, 13 Mar 2008 01:22:40 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 5/4] 2.6.25-rc5-mm1 specifc div64_u64 fixes
Content-Disposition: inline; filename=div64_mm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename a few more div64_u64 which are only in -mm.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/x86/kvm/i8254.c |    6 +++---
 kernel/time.c        |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-mm/arch/x86/kvm/i8254.c
===================================================================
--- linux-2.6-mm.orig/arch/x86/kvm/i8254.c
+++ linux-2.6-mm/arch/x86/kvm/i8254.c
@@ -35,7 +35,7 @@
 #include "i8254.h"
 
 #ifndef CONFIG_X86_64
-#define mod_64(x, y) ((x) - (y) * div64_64(x, y))
+#define mod_64(x, y) ((x) - (y) * div64_u64(x, y))
 #else
 #define mod_64(x, y) ((x) % (y))
 #endif
@@ -60,8 +60,8 @@ static u64 muldiv64(u64 a, u32 b, u32 c)
 	rl = (u64)u.l.low * (u64)b;
 	rh = (u64)u.l.high * (u64)b;
 	rh += (rl >> 32);
-	res.l.high = div64_64(rh, c);
-	res.l.low = div64_64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
+	res.l.high = div64_u64(rh, c);
+	res.l.low = div64_u64(((mod_64(rh, c) << 32) + (rl & 0xffffffff)), c);
 	return res.ll;
 }
 
Index: linux-2.6-mm/kernel/time.c
===================================================================
--- linux-2.6-mm.orig/kernel/time.c
+++ linux-2.6-mm/kernel/time.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(jiffies_to_usecs);
 
 u64 jiffies_64_to_usecs(const u64 j)
 {
-	return div64_64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
+	return div64_u64(j*HZ_TO_USEC_NUM + HZ_TO_USEC_DEN-1, HZ_TO_USEC_DEN);
 }
 EXPORT_SYMBOL(jiffies_64_to_usecs);
 

-- 

