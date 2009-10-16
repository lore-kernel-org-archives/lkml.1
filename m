Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZJPKc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZJPKc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZJPKcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:32:25 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48262 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbZJPKcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:32:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KRLRWQ-01-0TQ-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH 2/2] x86, mce: Add a global MCE init helper
Date: Fri, 16 Oct 2009 12:31:33 +0200
Message-ID: <1255689093-26921-2-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255689093-26921-1-git-send-email-borislav.petkov@amd.com>
References: <1255689093-26921-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 16 Oct 2009 10:30:39.0040 (UTC) FILETIME=[B4728C00:01CA4E4B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an early initcall (pre SMP) which sets up global MCE functionality.

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


