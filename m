Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZCKArf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZCKArf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZCKAqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:46:38 -0400
Received: from www.tglx.de ([62.245.132.106]:40017 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526AbZCKAqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:46:37 -0400
Message-Id: <20090311003235.533578955@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Mar 2009 00:45:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Luck <tony.luck@intel.com>
Subject: [patch 02/18] ia64: convert obsolete no_irq_type to no_irq_chip
References: <20090311003204.592133594@linutronix.de>
Content-Disposition: inline; filename=ia64-convert-obsolete-no-irq-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

convert the last remaining users to no_irq_chip

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/hp/sim/hpsim_irq.c |    2 +-
 arch/ia64/kernel/iosapic.c   |    2 +-
 arch/ia64/sn/kernel/irq.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -45,7 +45,7 @@ hpsim_irq_init (void)
 
 	for (i = 0; i < NR_IRQS; ++i) {
 		idesc = irq_desc + i;
-		if (idesc->chip == &no_irq_type)
+		if (idesc->chip == &no_irq_chip)
 			idesc->chip = &irq_type_hp_sim;
 	}
 }
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -648,7 +648,7 @@ register_intr (unsigned int gsi, int irq
 
 	idesc = irq_desc + irq;
 	if (irq_type != NULL && idesc->chip != irq_type) {
-		if (idesc->chip != &no_irq_type)
+		if (idesc->chip != &no_irq_chip)
 			printk(KERN_WARNING
 			       "%s: changing vector %d from %s to %s\n",
 			       __func__, irq_to_vector(irq),
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -299,7 +299,7 @@ void sn_irq_init(void)
 	ia64_last_device_vector = IA64_SN2_LAST_DEVICE_VECTOR;
 
 	for (i = 0; i < NR_IRQS; i++) {
-		if (base_desc[i].chip == &no_irq_type) {
+		if (base_desc[i].chip == &no_irq_chip) {
 			base_desc[i].chip = &irq_type_sn;
 		}
 	}


