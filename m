Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbZBXUqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbZBXUqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 15:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZBXUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 15:46:34 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:46202 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbZBXUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 15:46:33 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 1/2] x86_32: summit_32, use BAD_APICID
Date: Tue, 24 Feb 2009 21:41:32 +0100
Message-Id: <1235508093-18063-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <20090224175518.GA15616@elte.hu>
References: <20090224175518.GA15616@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BAD_APICID instead of 0xFF constants in summit_cpu_mask_to_apicid.

Also remove bogus comments about what we actually return.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/summit_32.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index cfe7b09..d02f438 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -303,12 +303,10 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 	int cpu;
 
 	num_bits_set = cpus_weight(*cpumask);
-	/* Return id to all */
 	if (num_bits_set >= nr_cpu_ids)
-		return 0xFF;
+		return BAD_APICID;
 	/*
-	 * The cpus in the mask must all be on the apic cluster.  If are not
-	 * on the same apicid cluster return default value of target_cpus():
+	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	cpu = first_cpu(*cpumask);
 	apicid = summit_cpu_to_logical_apicid(cpu);
@@ -318,9 +316,9 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 			int new_apicid = summit_cpu_to_logical_apicid(cpu);
 
 			if (APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
-				printk ("%s: Not a valid mask!\n", __func__);
+				printk("%s: Not a valid mask!\n", __func__);
 
-				return 0xFF;
+				return BAD_APICID;
 			}
 			apicid = apicid | new_apicid;
 			cpus_found++;
-- 
1.6.1.3

