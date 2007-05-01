Return-Path: <linux-kernel-owner+w=401wt.eu-S1423793AbXEAEKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423793AbXEAEKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946598AbXEAEAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:00:42 -0400
Received: from mx1.suse.de ([195.135.220.2]:60943 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932212AbXEAD6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:17 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/30] x86_64: Don't enable NUMA for a single node in K8 NUMA scanning
Message-Id: <20070501035816.51A1613CAF@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:16 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This was supposed to see the full memory on a ASUS A8SX motherboard
with 4GB RAM where the northbridge reports less memory, but it didn't
help there. But it's a reasonable change so let's include it anyways.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/k8topology.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/arch/x86_64/mm/k8topology.c
===================================================================
--- linux.orig/arch/x86_64/mm/k8topology.c
+++ linux/arch/x86_64/mm/k8topology.c
@@ -62,6 +62,8 @@ int __init k8_scan_nodes(unsigned long s
 
 	reg = read_pci_config(0, nb, 0, 0x60); 
 	numnodes = ((reg >> 4) & 0xF) + 1;
+	if (numnodes <= 1)
+		return -1;
 
 	printk(KERN_INFO "Number of nodes %d\n", numnodes);
 
