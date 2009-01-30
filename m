Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbZA3ScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbZA3ScZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbZA3Sb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:31:57 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39525 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753704AbZA3Sb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:31:56 -0500
Subject: [PATCH] voyager: fix cpu bootmaps
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 18:31:57 +0000
Message-Id: <1233340317.3248.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 98a79d6a50181ca1ecf7400eda01d5dc1bc0dbf0
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Dec 13 21:19:41 2008 +1030

    cpumask: centralize cpu_online_map and cpu_possible_map

Broke voyager largely because it currently initialises the
possible_map by copying, which isn't possible in the new scheme.  Fix
this by using init_cpu_possible() instead and tidy up other of the
cpumask declarations which now have global variables.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/mach-voyager/voyager_smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 9840b7e..dcc07d5 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -378,7 +378,7 @@ void __init find_smp_config(void)
 	cpus_addr(phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	cpu_possible_map = phys_cpu_present_map;
+	init_cpu_possible(&phys_cpu_present_map);
 	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
 	       cpus_addr(phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
-- 
1.5.6.6



