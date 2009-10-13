Return-Path: <linux-kernel-owner+w=401wt.eu-S1760417AbZJMPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760417AbZJMPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbZJMPoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:44:34 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:14306 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbZJMPod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:44:33 -0400
X-SpamScore: 2
X-BigFish: VPS2(zzzz1202hzzz32i2a8I6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KRGMCS-03-4FL-02
X-M-MSG: 
Date: Tue, 13 Oct 2009 17:44:28 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/2] x86, mce: Add a global MCE init helper
Message-ID: <20091013154428.GB14900@aftab>
References: <20091012103333.GB20051@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091012103333.GB20051@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Oct 2009 15:43:40.0748 (UTC) FILETIME=[EFFA80C0:01CA4C1B]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a99c2033750588600bc8ff44dbe6d22c1a064238 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 13 Oct 2009 16:36:34 +0200
Subject: [PATCH 2/2] x86, mce: Add a global MCE init helper

Add an early pre-smp initcall for global MCE functionality setup.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b4a5eca..3f7ac16 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1429,8 +1429,6 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 
-	if (raw_smp_processor_id() == 0)
-		atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
 }
 
 /*
@@ -1650,6 +1648,14 @@ static int __init mcheck_enable(char *str)
 }
 __setup("mce", mcheck_enable);
 
+static int __init mcheck_init(void)
+{
+	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
+
+	return 0;
+}
+early_initcall(mcheck_init);
+
 /*
  * Sysfs support
  */
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

