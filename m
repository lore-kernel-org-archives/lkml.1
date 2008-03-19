Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYCST4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYCST4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756886AbYCSThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbYCSThl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:41 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 13/79] [PATCH] move setup_secondary_clock a little bit down in the function
Date: Wed, 19 Mar 2008 14:25:08 -0300
Message-Id: <12059476351524-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476302473-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

This is done so we call setup_secondary_clock() in the same place x86_64
does. A separate patch for this is appearantly not needed. But clock
initialization is such a delicate thing, that it's safer to do this way

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 6c16165..4e5416e 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -185,7 +185,6 @@ static void __cpuinit start_secondary(void *unused)
 	 */
 	check_tsc_sync_target();
 
-	setup_secondary_clock();
 	if (nmi_watchdog == NMI_IO_APIC) {
 		disable_8259A_irq(0);
 		enable_NMI_through_LVT0();
@@ -214,6 +213,8 @@ static void __cpuinit start_secondary(void *unused)
 	unlock_ipi_call_lock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
+	setup_secondary_clock();
+
 	wmb();
 	cpu_idle();
 }
-- 
1.5.0.6

