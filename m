Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbYKUKqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbYKUKqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYKUKou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:50 -0500
Received: from ozlabs.org ([203.10.76.45]:45221 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYKUKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:49 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 6/8] cpumask: sh: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Paul Mundt <lethal@linux-sh.org>
Message-Id: <20081121104447.DCBADDDEEA@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/include/asm/topology.h |    1 +
 1 file changed, 1 insertion(+)

diff -r 1d66543b99ba arch/sh/include/asm/topology.h
--- a/arch/sh/include/asm/topology.h	Thu Nov 06 23:32:39 2008 +1100
+++ b/arch/sh/include/asm/topology.h	Thu Nov 06 23:33:08 2008 +1100
@@ -33,6 +33,7 @@
 #define parent_node(node)	((void)(node),0)
 
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
+#define cpumask_of_node(node)	((void)node, cpu_online_mask)
 #define node_to_first_cpu(node)	((void)(node),0)
 
 #define pcibus_to_node(bus)	((void)(bus), -1)

