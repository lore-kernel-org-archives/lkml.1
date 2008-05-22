Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYEVUb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYEVUb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYEVUbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:31:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYEVUbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:31:18 -0400
Date: Thu, 22 May 2008 15:44:10 -0400
Message-Id: <200805221944.m4MJiAaZ029843@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Remove workaround for prescott (32bit P4) from 64-bit code.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/intel_64.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_64.c b/arch/x86/kernel/cpu/intel_64.c
index 9b7c5f1..380df07 100644
--- a/arch/x86/kernel/cpu/intel_64.c
+++ b/arch/x86/kernel/cpu/intel_64.c
@@ -78,11 +78,6 @@ void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		unsigned eax = cpuid_eax(0x80000008);
 		c->x86_virt_bits = (eax >> 8) & 0xff;
 		c->x86_phys_bits = eax & 0xff;
-		/* CPUID workaround for Intel 0F34 CPU */
-		if (c->x86_vendor == X86_VENDOR_INTEL &&
-		    c->x86 == 0xF && c->x86_model == 0x3 &&
-		    c->x86_mask == 0x4)
-			c->x86_phys_bits = 36;
 	}
 
 	if (c->x86 == 15)
-- 
1.5.5.1

