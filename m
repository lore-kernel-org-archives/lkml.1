Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZFSOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZFSOu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbZFSOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:50:19 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:34070 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbZFSOuS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:50:18 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzzz1202hzzz32i17ch6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KLHQJD-02-09N-01
Date: Fri, 19 Jun 2009 16:49:50 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] mce3: two micro-improvements
Message-ID: <20090619144950.GA2192@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Jun 2009 14:49:54.0450 (UTC) FILETIME=[35097F20:01C9F0ED]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is against tip/x86/mce3.

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 19 Jun 2009 16:42:18 +0200
Subject: [PATCH] mce3: two micro-improvements

CC: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h       |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 5cdd8d1..b50b9e9 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -9,7 +9,7 @@
  */
 
 #define MCG_BANKCNT_MASK	0xff         /* Number of Banks */
-#define MCG_CTL_P		(1ULL<<8)    /* MCG_CAP register available */
+#define MCG_CTL_P		(1ULL<<8)    /* MCG_CTL register available */
 #define MCG_EXT_P		(1ULL<<9)    /* Extended registers available */
 #define MCG_CMCI_P		(1ULL<<10)   /* CMCI supported */
 #define MCG_EXT_CNT_MASK	0xff0000     /* Number of Extended registers */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 284d1de..7da8fec 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -242,7 +242,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 	/*
 	 * Make sure only one CPU runs in machine check panic
 	 */
-	if (atomic_add_return(1, &mce_paniced) > 1)
+	if (atomic_inc_return(&mce_paniced) > 1)
 		wait_for_panic();
 	barrier();
 
@@ -705,7 +705,7 @@ static int mce_start(int *no_way_out)
 	 * global_nwo should be updated before mce_callin
 	 */
 	smp_wmb();
-	order = atomic_add_return(1, &mce_callin);
+	order = atomic_inc_return(&mce_callin);
 
 	/*
 	 * Wait for everyone.
-- 
1.6.3.1

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

