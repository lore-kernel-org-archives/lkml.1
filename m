Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbYCSUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbYCSUEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYCSTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:38:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756997AbYCSTiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:17 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 68/79] [PATCH] use physical id when disabling smp
Date: Wed, 19 Mar 2008 14:26:03 -0300
Message-Id: <12059478813309-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059478771019-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com> <12059477234148-git-send-email-gcosta@redhat.com> <12059477273855-git-send-email-gcosta@redhat.com> <1205947732309-git-send-email-gcosta@redhat.com> <12059477371787-git-send-email-gcosta@redhat.com> <12059477421707-git-send-email-gcosta@redhat.com> <12059477472416-git-send-email-gcosta@redhat.com> <12059477521176-git-send!
 -email-gcosta@redhat.com> <12059477561937-git-send-email-gcosta@redhat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

if smp configuration is not found at all, hook into 0.
This is done to match x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 75fb506..14db038 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -106,7 +106,11 @@ static void __init disable_smp(void)
 	cpu_possible_map = cpumask_of_cpu(0);
 	cpu_present_map = cpumask_of_cpu(0);
 	smpboot_clear_io_apic_irqs();
-	phys_cpu_present_map = physid_mask_of_physid(0);
+	if (smp_found_config)
+		phys_cpu_present_map =
+				physid_mask_of_physid(boot_cpu_physical_apicid);
+	else
+		phys_cpu_present_map = physid_mask_of_physid(0);
 	map_cpu_to_logical_apicid();
 	cpu_set(0, per_cpu(cpu_sibling_map, 0));
 	cpu_set(0, per_cpu(cpu_core_map, 0));
-- 
1.5.0.6

