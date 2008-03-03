Return-Path: <linux-kernel-owner+w=401wt.eu-S1762711AbYCCTRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762711AbYCCTRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbYCCTRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:17:09 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:54439 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYCCTRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:17:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qTo9Rto9T7AeykeAcfHzfma7T4z3aP8HkjCeKo4mzBCOjVMlbiibQmHWrLGerlCLpZHvA+oByW+nfxXlF8SpSTHGGV/LfaAiD2N3Xphv/q8RwhaG27mJMur+g1PHQq35aR6JEVkAFYN/f3M/fMSryB4Wr3nb+iZdFnwJFOrMEvU=
Subject: [PATCH] ppc: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 11:17:02 -0800
Message-Id: <1204571822.3266.38.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/ppc/8xx_io/fec.c               |    4 ++--
 arch/ppc/platforms/radstone_ppc7d.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/ppc/8xx_io/fec.c b/arch/ppc/8xx_io/fec.c
index 11b0aa6..1d4b49a 100644
--- a/arch/ppc/8xx_io/fec.c
+++ b/arch/ppc/8xx_io/fec.c
@@ -520,7 +520,7 @@ fec_enet_interrupt(int irq, void * dev_id)
 #ifdef	CONFIG_USE_MDIO
 			fec_enet_mii(dev);
 #else
-printk("%s[%d] %s: unexpected FEC_ENET_MII event\n", __FILE__,__LINE__,__FUNCTION__);
+printk("%s[%d] %s: unexpected FEC_ENET_MII event\n", __FILE__, __LINE__, __func__);
 #endif	/* CONFIG_USE_MDIO */
 		}
 
@@ -1441,7 +1441,7 @@ irqreturn_t mii_link_interrupt(int irq, void * dev_id)
 		fecp->fec_ecntrl = ecntrl;	/* restore old settings */
 	}
 #else
-printk("%s[%d] %s: unexpected Link interrupt\n", __FILE__,__LINE__,__FUNCTION__);
+printk("%s[%d] %s: unexpected Link interrupt\n", __FILE__, __LINE__, __func__);
 #endif	/* CONFIG_USE_MDIO */
 
 #ifndef CONFIG_RPXCLASSIC
diff --git a/arch/ppc/platforms/radstone_ppc7d.c b/arch/ppc/platforms/radstone_ppc7d.c
index 44d4398..fc928a2 100644
--- a/arch/ppc/platforms/radstone_ppc7d.c
+++ b/arch/ppc/platforms/radstone_ppc7d.c
@@ -512,7 +512,7 @@ static void __init ppc7d_init_irq(void)
 {
 	int irq;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 	i8259_init(0, 0);
 	mv64360_init_irq();
 
@@ -569,7 +569,7 @@ static int __init ppc7d_map_irq(struct pci_dev *dev, unsigned char idsel,
 	};
 	const long min_idsel = 10, max_idsel = 14, irqs_per_slot = 4;
 
-	pr_debug("%s: %04x/%04x/%x: idsel=%hx pin=%hu\n", __FUNCTION__,
+	pr_debug("%s: %04x/%04x/%x: idsel=%hx pin=%hu\n", __func__,
 		 dev->vendor, dev->device, PCI_FUNC(dev->devfn), idsel, pin);
 
 	return PCI_IRQ_TABLE_LOOKUP;
@@ -1300,7 +1300,7 @@ static void ppc7d_init2(void)
 	u32 data;
 	u8 data8;
 
-	pr_debug("%s: enter\n", __FUNCTION__);
+	pr_debug("%s: enter\n", __func__);
 
 	/* Wait for debugger? */
 	if (ppc7d_wait_debugger) {
@@ -1333,7 +1333,7 @@ static void ppc7d_init2(void)
         ppc_md.set_rtc_time = ppc7d_set_rtc_time;
         ppc_md.get_rtc_time = ppc7d_get_rtc_time;
 
-	pr_debug("%s: exit\n", __FUNCTION__);
+	pr_debug("%s: exit\n", __func__);
 }
 
 /* Called from machine_init(), early, before any of the __init functions
-- 
1.5.4.3.500.g83a2c



