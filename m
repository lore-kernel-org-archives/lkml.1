Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbZENHlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbZENHlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760662AbZENHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:41:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49405 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbZENHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:41:08 -0400
Subject: [PATCH 2/6] x86: mtrr replace MTRRfix64K_00000_MSR with
 msr-index's MSR_MTRRfix64K_00000
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242286427.4574.17.camel@localhost.localdomain>
References: <1242286304.4574.15.camel@localhost.localdomain>
	 <1242286427.4574.17.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:04:44 +0530
Message-Id: <1242286484.4574.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use standard msr-index.h's MSR declaration and no need to declare again.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    4 ++--
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index b358320..2809970 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -20,7 +20,7 @@ struct fixed_range_block {
 };
 
 static struct fixed_range_block fixed_range_blocks[] = {
-	{ MTRRfix64K_00000_MSR, 1 }, /* one  64k MTRR  */
+	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
 	{ MTRRfix16K_80000_MSR, 2 }, /* two  16k MTRRs */
 	{ MTRRfix4K_C0000_MSR,  8 }, /* eight 4k MTRRs */
 	{}
@@ -194,7 +194,7 @@ get_fixed_ranges(mtrr_type * frs)
 
 	k8_check_syscfg_dram_mod_en();
 
-	rdmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
+	rdmsr(MSR_MTRRfix64K_00000, p[0], p[1]);
 
 	for (i = 0; i < 2; i++)
 		rdmsr(MTRRfix16K_80000_MSR + i, p[2 + i * 2], p[3 + i * 2]);
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 5d37fb1..7f23cae 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -7,7 +7,6 @@
 
 #define MTRRdefType_MSR 0x2ff
 
-#define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
 #define MTRRfix4K_C0000_MSR 0x268
-- 
1.6.0.6



