Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbYCSTlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbYCSTlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYCSTak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221AbYCSTai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:38 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 14/79] [PATCH] move state update out of ipi_lock
Date: Wed, 19 Mar 2008 14:25:09 -0300
Message-Id: <12059476393279-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476351524-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

it does not need to be inside lock. Do the way i386 does.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index c213345..cfcfd2c 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -233,10 +233,10 @@ void __cpuinit start_secondary(void)
 	 */
 	spin_unlock(&vector_lock);
 	cpu_set(smp_processor_id(), cpu_online_map);
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
-
 	unlock_ipi_call_lock();
 
+	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+
 	setup_secondary_clock();
 
 	cpu_idle();
-- 
1.5.0.6

