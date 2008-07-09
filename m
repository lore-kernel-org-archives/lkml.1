Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYGIQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYGIQyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYGIQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:38 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42836 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751889AbYGIQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:31 -0400
Message-Id: <20080709165131.080944000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:42 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 13/15] x86_64: Replace xxx_pda() operations in include_asm-x86_topology_h
Content-Disposition: inline; filename=incl_pda_ops_include_asm-x86_topology_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * It is now possible to use percpu operations for pda access
    since the pda is in the percpu area. Drop the pda operations.

    Thus:

	read_pda     --> x86_read_percpu
	write_pda    --> x86_write_percpu
	add_pda (+1) --> x86_inc_percpu
	or_pda       --> x86_or_percpu

Based on linux-2.6.tip/master

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/topology.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/include/asm-x86/topology.h	2008-07-01 10:41:33.000000000 -0700
+++ linux-2.6.tip/include/asm-x86/topology.h	2008-07-01 10:49:15.420385902 -0700
@@ -77,7 +77,7 @@ extern cpumask_t *node_to_cpumask_map;
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
 
 /* Returns the number of the current Node. */
-#define numa_node_id()		read_pda(nodenumber)
+#define numa_node_id()		x86_read_percpu(pda.nodenumber)
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);

-- 
