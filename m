Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZC2CGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZC2CGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbZC2CEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:12 -0400
Received: from ozlabs.org ([203.10.76.45]:46568 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbZC2CEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:07 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 10/10] cpumask: remove the now-obsoleted pcibus_to_cpumask(): generic
Message-Id: <20090329020405.082A4DDE23@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: reduce stack usage for large NR_CPUS

cpumask_of_pcibus() is the new version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/asm-generic/topology.h |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -47,13 +47,6 @@
 #define pcibus_to_node(bus)	((void)(bus), -1)
 #endif
 
-#ifndef pcibus_to_cpumask
-#define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
-					CPU_MASK_ALL : \
-					node_to_cpumask(pcibus_to_node(bus)) \
-				)
-#endif
-
 #ifndef cpumask_of_pcibus
 #define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
 				 cpu_all_mask :				\

