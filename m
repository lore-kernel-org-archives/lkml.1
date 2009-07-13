Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZGMUPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZGMUPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbZGMUPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:15:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37568 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZGMUPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:15:33 -0400
Date: Mon, 13 Jul 2009 16:14:37 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org
Subject: Fix warning in pvclock.c
Message-ID: <20090713201437.GA12165@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when building 32-bit, I see this ..
arch/x86/kernel/pvclock.c:63:7: warning: "__x86_64__" is not defined

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 4f9c55f..03801f2 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -60,7 +60,7 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 		"adc  %5,%%edx ; "
 		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
 		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
-#elif __x86_64__
+#elif defined(__x86_64__)
 	__asm__ (
 		"mul %%rdx ; shrd $32,%%rdx,%%rax"
 		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
