Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbZA1X6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbZA1X6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758429AbZA1Xoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:44:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:37599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758375AbZA1Xoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:44:37 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 034/114] x86, apic: rename genapic::apic_destination_logical to genapic::dest_logical
Date: Wed, 28 Jan 2009 23:41:40 +0000
Message-Id: <1233186180-29883-35-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:44:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field name was unreasonably long - shorten it.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h      |    2 +-
 arch/x86/kernel/genapic_flat_64.c   |   10 +++++-----
 arch/x86/kernel/genx2apic_cluster.c |    8 ++++----
 arch/x86/kernel/genx2apic_phys.c    |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c    |    2 +-
 arch/x86/kernel/io_apic.c           |    2 +-
 arch/x86/kernel/ipi.c               |    2 +-
 arch/x86/kernel/smpboot.c           |    2 +-
 arch/x86/mach-generic/bigsmp.c      |    2 +-
 arch/x86/mach-generic/default.c     |    2 +-
 arch/x86/mach-generic/es7000.c      |    2 +-
 arch/x86/mach-generic/numaq.c       |    2 +-
 arch/x86/mach-generic/summit.c      |    2 +-
 13 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 7aee4a4..f9d1ec0 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -30,7 +30,7 @@ struct genapic {
 
 	int disable_esr;
 
-	int apic_destination_logical;
+	int dest_logical;
 	unsigned long (*check_apicid_used)(physid_mask_t bitmap, int apicid);
 	unsigned long (*check_apicid_present)(int apicid);
 
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index fd242c6..d22cbda 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -74,7 +74,7 @@ static inline void _flat_send_IPI_mask(unsigned long mask, int vector)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	__send_IPI_dest_field(mask, vector, apic->apic_destination_logical);
+	__send_IPI_dest_field(mask, vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -114,7 +114,7 @@ static void flat_send_IPI_allbutself(int vector)
 			_flat_send_IPI_mask(mask, vector);
 		}
 	} else if (num_online_cpus() > 1) {
-		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->apic_destination_logical);
+		__send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->dest_logical);
 	}
 }
 
@@ -123,7 +123,7 @@ static void flat_send_IPI_all(int vector)
 	if (vector == NMI_VECTOR)
 		flat_send_IPI_mask(cpu_online_mask, vector);
 	else
-		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->apic_destination_logical);
+		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
 }
 
 static unsigned int get_apic_id(unsigned long x)
@@ -185,7 +185,7 @@ struct genapic apic_flat =  {
 
 	.target_cpus			= flat_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
@@ -331,7 +331,7 @@ struct genapic apic_physflat =  {
 
 	.target_cpus			= physflat_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= 0,
+	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index a76e75e..b91a48e 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -64,7 +64,7 @@ static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
 	for_each_cpu(query_cpu, mask)
 		__x2apic_send_IPI_dest(
 			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->apic_destination_logical);
+			vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -80,7 +80,7 @@ static void x2apic_send_IPI_mask_allbutself(const struct cpumask *mask,
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->apic_destination_logical);
+				vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -95,7 +95,7 @@ static void x2apic_send_IPI_allbutself(int vector)
 		if (query_cpu != this_cpu)
 			__x2apic_send_IPI_dest(
 				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->apic_destination_logical);
+				vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
 
@@ -187,7 +187,7 @@ struct genapic apic_x2apic_cluster = {
 
 	.target_cpus			= x2apic_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 9b6d68d..f070e86 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -183,7 +183,7 @@ struct genapic apic_x2apic_phys = {
 
 	.target_cpus			= x2apic_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= 0,
+	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 0a75680..c8a8915 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -248,7 +248,7 @@ struct genapic apic_x2apic_uv_x = {
 
 	.target_cpus			= uv_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
 	.check_apicid_present		= NULL,
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 17526d7..7f8b32b 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -806,7 +806,7 @@ void send_IPI_self(int vector)
 	 * Wait for idle.
 	 */
 	apic_wait_icr_idle();
-	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | apic->apic_destination_logical;
+	cfg = APIC_DM_FIXED | APIC_DEST_SELF | vector | apic->dest_logical;
 	/*
 	 * Send the IPI. The write to APIC_ICR fires this off.
 	 */
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index 400b7bd..e2e4895 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -30,7 +30,7 @@
 
 static inline int __prepare_ICR(unsigned int shortcut, int vector)
 {
-	unsigned int icr = shortcut | apic->apic_destination_logical;
+	unsigned int icr = shortcut | apic->dest_logical;
 
 	switch (vector) {
 	default:
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f0a1737..45c096f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -583,7 +583,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI |  apic->apic_destination_logical, logical_apicid);
+	apic_icr_write(APIC_DM_NMI | apic->dest_logical, logical_apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
diff --git a/arch/x86/mach-generic/bigsmp.c b/arch/x86/mach-generic/bigsmp.c
index 13ee7dc..7c52840 100644
--- a/arch/x86/mach-generic/bigsmp.c
+++ b/arch/x86/mach-generic/bigsmp.c
@@ -70,7 +70,7 @@ struct genapic apic_bigsmp = {
 
 	.target_cpus			= bigsmp_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= 0,
+	.dest_logical			= 0,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index d3fe801..53fa1ad 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -37,7 +37,7 @@ struct genapic apic_default = {
 
 	.target_cpus			= default_target_cpus,
 	.disable_esr			= 0,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 61b5da2..50fed02 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -113,7 +113,7 @@ struct genapic apic_es7000 = {
 
 	.target_cpus			= es7000_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= 0,
+	.dest_logical			= 0,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
diff --git a/arch/x86/mach-generic/numaq.c b/arch/x86/mach-generic/numaq.c
index f3b7840..1fb1b1a 100644
--- a/arch/x86/mach-generic/numaq.c
+++ b/arch/x86/mach-generic/numaq.c
@@ -57,7 +57,7 @@ struct genapic apic_numaq = {
 
 	.target_cpus			= numaq_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
diff --git a/arch/x86/mach-generic/summit.c b/arch/x86/mach-generic/summit.c
index 95e075b..5c27d4d 100644
--- a/arch/x86/mach-generic/summit.c
+++ b/arch/x86/mach-generic/summit.c
@@ -50,7 +50,7 @@ struct genapic apic_summit = {
 
 	.target_cpus			= summit_target_cpus,
 	.disable_esr			= 1,
-	.apic_destination_logical	= APIC_DEST_LOGICAL,
+	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= check_apicid_used,
 	.check_apicid_present		= check_apicid_present,
 
-- 
1.6.0.2

