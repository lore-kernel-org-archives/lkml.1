Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZGRG5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZGRG5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 02:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZGRG47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 02:56:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51186 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbZGRG46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 02:56:58 -0400
Date: Sat, 18 Jul 2009 08:56:57 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] Fix bad_srat() to clear all state
Message-ID: <20090718065657.GA2898@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bad_srat() to clear all state

Need to clear both nodes and nodes_add state for start/end. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/mm/srat_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc3-ak/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.31-rc3-ak.orig/arch/x86/mm/srat_64.c
+++ linux-2.6.31-rc3-ak/arch/x86/mm/srat_64.c
@@ -85,8 +85,10 @@ static __init void bad_srat(void)
 	acpi_numa = -1;
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		apicid_to_node[i] = NUMA_NO_NODE;
-	for (i = 0; i < MAX_NUMNODES; i++)
-		nodes_add[i].start = nodes[i].end = 0;
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		nodes[i].start = nodes[i].end = 0;
+		nodes_add[i].start = nodes_add[i].end = 0;
+	}
 	remove_all_active_ranges();
 }
 
