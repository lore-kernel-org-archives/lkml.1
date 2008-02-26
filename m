Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYBZHLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYBZHLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYBZHLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:11:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36721 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbYBZHLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:11:13 -0500
Date: Mon, 25 Feb 2008 23:20:01 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: remove wrong setting about CONSTANT_TSC for intel cpu
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802252320.01534.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_init_intel is introduced by

commit 2b16a2353814a513cdb5c5c739b76a19d7ea39ce
Author: Andi Kleen <ak@suse.de>
Date:   Wed Jan 30 13:32:40 2008 +0100

    x86: move X86_FEATURE_CONSTANT_TSC into early cpu feature detection

set CONSTANT_TSC for intel cpus

but it already set in init_intel

don't need to set that two times in early_init_intel() and init_intel. this patch remove one.

also fix error in early_init_intel and reference about x86_capality, because it
is array already.., prevent possible data corruption...

this should be applied for 2.6.25

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com> 

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 62d3f14..210134c 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1027,7 +1027,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_bit(X86_FEATURE_CONSTANT_TSC, &c->x86_capability);
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 }
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
@@ -1071,9 +1071,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	if (c->x86 == 15)
 		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
