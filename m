Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZCMIQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZCMIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757360AbZCMIMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:25 -0400
Received: from gw.goop.org ([64.81.55.164]:34806 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356AbZCMIMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Hannes Eder <hannes@hanneseder.net>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/24] NULL noise: arch/x86/xen/smp.c
Date: Fri, 13 Mar 2009 01:11:45 -0700
Message-Id: <1236931920-6861-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Fix this sparse warnings:
  arch/x86/xen/smp.c:316:52: warning: Using plain integer as NULL pointer
  arch/x86/xen/smp.c:421:60: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 8d47056..304d832 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -317,7 +317,7 @@ static int __cpuinit xen_cpu_up(unsigned int cpu)
 	BUG_ON(rc);
 
 	while(per_cpu(cpu_state, cpu) != CPU_ONLINE) {
-		HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+		HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 		barrier();
 	}
 
@@ -422,7 +422,7 @@ static void xen_smp_send_call_function_ipi(const struct cpumask *mask)
 	/* Make sure other vcpus get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
-			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
+			HYPERVISOR_sched_op(SCHEDOP_yield, NULL);
 			break;
 		}
 	}
-- 
1.6.0.6

