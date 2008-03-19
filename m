Return-Path: <linux-kernel-owner+w=401wt.eu-S1761644AbYCST6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761644AbYCST6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbYCSThz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbYCSTht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:49 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 26/79] [PATCH] make node to apic mapping declarations unconditional
Date: Wed, 19 Mar 2008 14:25:21 -0300
Message-Id: <12059476932397-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059476883852-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

Instead of declaring them inside of X86_64 ifdef, do it
unconditionally

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 include/asm-x86/topology.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index fd38c3a..5bc825b 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -33,15 +33,15 @@ struct pci_bus;
 /* Mappings between logical cpu number and node number */
 #ifdef CONFIG_X86_32
 extern int cpu_to_node_map[];
-
 #else
-DECLARE_PER_CPU(int, x86_cpu_to_node_map);
-extern int x86_cpu_to_node_map_init[];
-extern void *x86_cpu_to_node_map_early_ptr;
 /* Returns the number of the current Node. */
 #define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
 #endif
 
+DECLARE_PER_CPU(int, x86_cpu_to_node_map);
+extern int x86_cpu_to_node_map_init[];
+extern void *x86_cpu_to_node_map_early_ptr;
+
 extern cpumask_t node_to_cpumask_map[];
 
 #define NUMA_NO_NODE	(-1)
-- 
1.5.0.6

