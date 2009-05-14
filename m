Return-Path: <linux-kernel-owner+w=401wt.eu-S1759706AbZENHlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706AbZENHlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbZENHkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:40:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:49379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbZENHkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:40:24 -0400
Subject: [PATCH 1/6] x86: mtrr replace MTRRcap_MSR with msr-index's
 MSR_MTRRcap
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242286304.4574.15.camel@localhost.localdomain>
References: <1242286304.4574.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 13:03:47 +0530
Message-Id: <1242286427.4574.17.camel@localhost.localdomain>
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
 arch/x86/kernel/cpu/mtrr/main.c    |    2 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index d21d4fb..b358320 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -310,7 +310,7 @@ void __init get_mtrr_state(void)
 
 	vrs = mtrr_state.var_ranges;
 
-	rdmsr(MTRRcap_MSR, lo, dummy);
+	rdmsr(MSR_MTRRcap, lo, dummy);
 	mtrr_state.have_fixed = (lo >> 8) & 1;
 
 	for (i = 0; i < num_var_ranges; i++)
@@ -707,7 +707,7 @@ int generic_validate_add_page(unsigned long base, unsigned long size, unsigned i
 static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
-	rdmsr(MTRRcap_MSR, config, dummy);
+	rdmsr(MSR_MTRRcap, config, dummy);
 	return (config & (1 << 10));
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 03cda01..8fc248b 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -104,7 +104,7 @@ static void __init set_num_var_ranges(void)
 	unsigned long config = 0, dummy;
 
 	if (use_intel()) {
-		rdmsr(MTRRcap_MSR, config, dummy);
+		rdmsr(MSR_MTRRcap, config, dummy);
 	} else if (is_cpu(AMD))
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 77f67f7..5d37fb1 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
-#define MTRRcap_MSR     0x0fe
 #define MTRRdefType_MSR 0x2ff
 
 #define MTRRfix64K_00000_MSR 0x250
-- 
1.6.0.6



