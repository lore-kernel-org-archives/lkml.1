Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbYARJAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbYARJAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbYARI74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:59:56 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55522 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbYARI7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:59:54 -0500
Date: Fri, 18 Jan 2008 01:05:53 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: only call early_init_amd one time
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801180105.53434.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: only call early_init_amd one time

Andi's patch
"
    x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection

    Need this in the next patch in time_init and that happens early.

    This includes a minor fix on i386 where early_intel_workarounds()
    [which is now called early_init_intel] really executes early as
    the comments say.
"
calling early_init_amd in early_identify_cpu and identify_cpu two times.

this patch remove the one in identify_cpu

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index aeaa17d..d236593 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1029,6 +1029,9 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
 		break;
+	case X86_VENDOR_INTEL:
+		early_init_intel(c);
+		break;
 	}
 
 }
@@ -1095,14 +1098,6 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	numa_add_cpu(smp_processor_id());
 #endif
 
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		early_init_amd(c);
-		break;
-	case X86_VENDOR_INTEL:
-		early_init_intel(c);
-		break;
-	}
 }
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
