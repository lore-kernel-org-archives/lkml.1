Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZBXRir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZBXRir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758651AbZBXRiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:38:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:34396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbZBXRiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:38:15 -0500
From: jirislaby@gmail.com
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86_32: summit_32, use BAD_APICID
Date: Tue, 24 Feb 2009 18:38:14 +0100
Message-Id: <1235497095-4896-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Use BAD_APICID instead of 0xFF constants in summit_cpu_mask_to_apicid.

Also remove bogus comments about what we actually return.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/summit_32.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 1e733ef..b10133a 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -309,12 +309,10 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
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
@@ -325,9 +323,9 @@ static inline unsigned int summit_cpu_mask_to_apicid(const cpumask_t *cpumask)
 
 			if (apicid_cluster(apicid) !=
 					apicid_cluster(new_apicid)) {
-				printk ("%s: Not a valid mask!\n", __func__);
+				printk("%s: Not a valid mask!\n", __func__);
 
-				return 0xFF;
+				return BAD_APICID;
 			}
 			apicid = apicid | new_apicid;
 			cpus_found++;
-- 
1.6.1.3

