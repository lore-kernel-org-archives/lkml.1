Return-Path: <linux-kernel-owner+w=401wt.eu-S969094AbXEIHC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969094AbXEIHC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 03:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbXEIHCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:02:50 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXEIHCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:02:49 -0400
Date: Wed, 9 May 2007 00:02:00 -0700
Message-Id: <200705090702.l49720aC029866@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] i386: cpu/transmeta.c: fix definition of USER686
To: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of USER686 is supposed to be a mask of feature bits,
not an OR of feature numbers!  It happened to work anyway on the only
processor affected, simply by pure coincidence.  Fix.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/kernel/cpu/transmeta.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/i386/kernel/cpu/transmeta.c b/arch/i386/kernel/cpu/transmeta.c
index 6471a5a..200fb3f 100644
--- a/arch/i386/kernel/cpu/transmeta.c
+++ b/arch/i386/kernel/cpu/transmeta.c
@@ -77,8 +77,10 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
 	
 	/* If we can run i686 user-space code, call us an i686 */
-#define USER686 (X86_FEATURE_TSC|X86_FEATURE_CX8|X86_FEATURE_CMOV)
-        if ( c->x86 == 5 && (c->x86_capability[0] & USER686) == USER686 )
+#define USER686 ((1 << X86_FEATURE_TSC)|\
+		 (1 << X86_FEATURE_CX8)|\
+		 (1 << X86_FEATURE_CMOV))
+        if (c->x86 == 5 && (c->x86_capability[0] & USER686) == USER686)
 		c->x86 = 6;
 
 #ifdef CONFIG_SYSCTL
-- 
1.5.1.3

