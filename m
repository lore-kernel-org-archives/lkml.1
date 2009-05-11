Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZEKQ7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZEKQ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZEKQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 12:58:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:34717 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZEKQ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 12:58:55 -0400
Subject: [PATCH 1/15 -tip] x86: Add cpufeature for Processor Name
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Robert Richter <robert.richter@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242058494.5139.7.camel@ht.satnam>
References: <1242058494.5139.7.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 11 May 2009 22:11:59 +0530
Message-Id: <1242060119.5139.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Processor Name / Brand String (Function 8000_0002h, 8000_0003h, 8000_0004h)
Functions 8000_0002h, 8000_0003h, and 8000_0004h each return up to 16 ASCII bytes of the processor name in the EAX, EBX, ECX, and EDX registers.

X86_FEATURE_PNAME will be useful for displaying MSRs like AMD:
MSRC001_00[35:30] Processor Name String Registers

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/common.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 13cc6a5..f106cfc 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -155,6 +155,7 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
+#define X86_FEATURE_PNAME	(7*32+ 2) /* Processor Name */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e7fd5c4..59dd479 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -360,6 +360,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	cpuid(0x80000003, &v[4], &v[5], &v[6], &v[7]);
 	cpuid(0x80000004, &v[8], &v[9], &v[10], &v[11]);
 	c->x86_model_id[48] = 0;
+	set_cpu_cap(c, X86_FEATURE_PNAME);
 
 	/*
 	 * Intel chips right-justify this string for some dumb reason;
-- 
1.6.0.6



