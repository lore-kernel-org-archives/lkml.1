Return-Path: <linux-kernel-owner+w=401wt.eu-S1760852AbZEBUDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760852AbZEBUDc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 16:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbZEBUCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 16:02:00 -0400
Received: from www.tglx.de ([62.245.132.106]:55724 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759482AbZEBUB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 16:01:58 -0400
Message-Id: <20090502195925.576398027@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 02 May 2009 20:00:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Richard Henderson <rth@twiddle.net>
Subject: [patch 05/11] alpha: remove obsolete hw_interrupt_type
References: <20090502195607.539955644@linutronix.de>
Content-Disposition: inline;
	filename=alpha-remove-obsolete-hw-interrupt-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Convert the last remaining users to struct irq_chip and remove the
define.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
CC: Richard Henderson <rth@twiddle.net>

---
 arch/alpha/kernel/irq_alpha.c     |    2 +-
 arch/alpha/kernel/irq_i8259.c     |    2 +-
 arch/alpha/kernel/irq_impl.h      |    2 +-
 arch/alpha/kernel/irq_pyxis.c     |    2 +-
 arch/alpha/kernel/irq_srm.c       |    2 +-
 arch/alpha/kernel/sys_alcor.c     |    2 +-
 arch/alpha/kernel/sys_cabriolet.c |    2 +-
 arch/alpha/kernel/sys_dp264.c     |    6 +++---
 arch/alpha/kernel/sys_eb64p.c     |    2 +-
 arch/alpha/kernel/sys_eiger.c     |    2 +-
 arch/alpha/kernel/sys_jensen.c    |    2 +-
 arch/alpha/kernel/sys_marvel.c    |   10 +++++-----
 arch/alpha/kernel/sys_mikasa.c    |    2 +-
 arch/alpha/kernel/sys_noritake.c  |    2 +-
 arch/alpha/kernel/sys_rawhide.c   |    2 +-
 arch/alpha/kernel/sys_rx164.c     |    2 +-
 arch/alpha/kernel/sys_sable.c     |    2 +-
 arch/alpha/kernel/sys_takara.c    |    2 +-
 arch/alpha/kernel/sys_titan.c     |    4 ++--
 arch/alpha/kernel/sys_wildfire.c  |    2 +-
 20 files changed, 27 insertions(+), 27 deletions(-)

Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -227,7 +227,7 @@ struct irqaction timer_irqaction = {
 	.name		= "timer",
 };
 
-static struct hw_interrupt_type rtc_irq_type = {
+static struct irq_chip rtc_irq_type = {
 	.typename	= "RTC",
 	.startup	= rtc_startup,
 	.shutdown	= rtc_enable_disable,
Index: linux-2.6/arch/alpha/kernel/irq_i8259.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_i8259.c
+++ linux-2.6/arch/alpha/kernel/irq_i8259.c
@@ -83,7 +83,7 @@ i8259a_end_irq(unsigned int irq)
 		i8259a_enable_irq(irq);
 }
 
-struct hw_interrupt_type i8259a_irq_type = {
+struct irq_chip i8259a_irq_type = {
 	.typename	= "XT-PIC",
 	.startup	= i8259a_startup_irq,
 	.shutdown	= i8259a_disable_irq,
Index: linux-2.6/arch/alpha/kernel/irq_impl.h
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_impl.h
+++ linux-2.6/arch/alpha/kernel/irq_impl.h
@@ -36,7 +36,7 @@ extern void i8259a_disable_irq(unsigned 
 extern void i8259a_mask_and_ack_irq(unsigned int);
 extern unsigned int i8259a_startup_irq(unsigned int);
 extern void i8259a_end_irq(unsigned int);
-extern struct hw_interrupt_type i8259a_irq_type;
+extern struct irq_chip i8259a_irq_type;
 extern void init_i8259a_irqs(void);
 
 extern void handle_irq(int irq);
Index: linux-2.6/arch/alpha/kernel/irq_pyxis.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_pyxis.c
+++ linux-2.6/arch/alpha/kernel/irq_pyxis.c
@@ -70,7 +70,7 @@ pyxis_mask_and_ack_irq(unsigned int irq)
 	*(vulp)PYXIS_INT_MASK;
 }
 
-static struct hw_interrupt_type pyxis_irq_type = {
+static struct irq_chip pyxis_irq_type = {
 	.typename	= "PYXIS",
 	.startup	= pyxis_startup_irq,
 	.shutdown	= pyxis_disable_irq,
Index: linux-2.6/arch/alpha/kernel/irq_srm.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_srm.c
+++ linux-2.6/arch/alpha/kernel/irq_srm.c
@@ -48,7 +48,7 @@ srm_end_irq(unsigned int irq)
 }
 
 /* Handle interrupts from the SRM, assuming no additional weirdness.  */
-static struct hw_interrupt_type srm_irq_type = {
+static struct irq_chip srm_irq_type = {
 	.typename	= "SRM",
 	.startup	= srm_startup_irq,
 	.shutdown	= srm_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_alcor.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_alcor.c
+++ linux-2.6/arch/alpha/kernel/sys_alcor.c
@@ -89,7 +89,7 @@ alcor_end_irq(unsigned int irq)
 		alcor_enable_irq(irq);
 }
 
-static struct hw_interrupt_type alcor_irq_type = {
+static struct irq_chip alcor_irq_type = {
 	.typename	= "ALCOR",
 	.startup	= alcor_startup_irq,
 	.shutdown	= alcor_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_cabriolet.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_cabriolet.c
+++ linux-2.6/arch/alpha/kernel/sys_cabriolet.c
@@ -71,7 +71,7 @@ cabriolet_end_irq(unsigned int irq)
 		cabriolet_enable_irq(irq);
 }
 
-static struct hw_interrupt_type cabriolet_irq_type = {
+static struct irq_chip cabriolet_irq_type = {
 	.typename	= "CABRIOLET",
 	.startup	= cabriolet_startup_irq,
 	.shutdown	= cabriolet_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -194,7 +194,7 @@ clipper_set_affinity(unsigned int irq, c
 	spin_unlock(&dp264_irq_lock);
 }
 
-static struct hw_interrupt_type dp264_irq_type = {
+static struct irq_chip dp264_irq_type = {
 	.typename	= "DP264",
 	.startup	= dp264_startup_irq,
 	.shutdown	= dp264_disable_irq,
@@ -205,7 +205,7 @@ static struct hw_interrupt_type dp264_ir
 	.set_affinity	= dp264_set_affinity,
 };
 
-static struct hw_interrupt_type clipper_irq_type = {
+static struct irq_chip clipper_irq_type = {
 	.typename	= "CLIPPER",
 	.startup	= clipper_startup_irq,
 	.shutdown	= clipper_disable_irq,
@@ -294,7 +294,7 @@ clipper_srm_device_interrupt(unsigned lo
 }
 
 static void __init
-init_tsunami_irqs(struct hw_interrupt_type * ops, int imin, int imax)
+init_tsunami_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
Index: linux-2.6/arch/alpha/kernel/sys_eb64p.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eb64p.c
+++ linux-2.6/arch/alpha/kernel/sys_eb64p.c
@@ -69,7 +69,7 @@ eb64p_end_irq(unsigned int irq)
 		eb64p_enable_irq(irq);
 }
 
-static struct hw_interrupt_type eb64p_irq_type = {
+static struct irq_chip eb64p_irq_type = {
 	.typename	= "EB64P",
 	.startup	= eb64p_startup_irq,
 	.shutdown	= eb64p_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_eiger.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_eiger.c
+++ linux-2.6/arch/alpha/kernel/sys_eiger.c
@@ -80,7 +80,7 @@ eiger_end_irq(unsigned int irq)
 		eiger_enable_irq(irq);
 }
 
-static struct hw_interrupt_type eiger_irq_type = {
+static struct irq_chip eiger_irq_type = {
 	.typename	= "EIGER",
 	.startup	= eiger_startup_irq,
 	.shutdown	= eiger_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_jensen.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_jensen.c
+++ linux-2.6/arch/alpha/kernel/sys_jensen.c
@@ -118,7 +118,7 @@ jensen_local_end(unsigned int irq)
 		i8259a_end_irq(1);
 }
 
-static struct hw_interrupt_type jensen_local_irq_type = {
+static struct irq_chip jensen_local_irq_type = {
 	.typename	= "LOCAL",
 	.startup	= jensen_local_startup,
 	.shutdown	= jensen_local_shutdown,
Index: linux-2.6/arch/alpha/kernel/sys_marvel.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_marvel.c
+++ linux-2.6/arch/alpha/kernel/sys_marvel.c
@@ -169,7 +169,7 @@ marvel_irq_noop_return(unsigned int irq)
 	return 0; 
 }
 
-static struct hw_interrupt_type marvel_legacy_irq_type = {
+static struct irq_chip marvel_legacy_irq_type = {
 	.typename	= "LEGACY",
 	.startup	= marvel_irq_noop_return,
 	.shutdown	= marvel_irq_noop,
@@ -179,7 +179,7 @@ static struct hw_interrupt_type marvel_l
 	.end		= marvel_irq_noop,
 };
 
-static struct hw_interrupt_type io7_lsi_irq_type = {
+static struct irq_chip io7_lsi_irq_type = {
 	.typename	= "LSI",
 	.startup	= io7_startup_irq,
 	.shutdown	= io7_disable_irq,
@@ -189,7 +189,7 @@ static struct hw_interrupt_type io7_lsi_
 	.end		= io7_end_irq,
 };
 
-static struct hw_interrupt_type io7_msi_irq_type = {
+static struct irq_chip io7_msi_irq_type = {
 	.typename	= "MSI",
 	.startup	= io7_startup_irq,
 	.shutdown	= io7_disable_irq,
@@ -273,8 +273,8 @@ init_one_io7_msi(struct io7 *io7, unsign
 
 static void __init
 init_io7_irqs(struct io7 *io7, 
-	      struct hw_interrupt_type *lsi_ops,
-	      struct hw_interrupt_type *msi_ops)
+	      struct irq_chip *lsi_ops,
+	      struct irq_chip *msi_ops)
 {
 	long base = (io7->pe << MARVEL_IRQ_VEC_PE_SHIFT) + 16;
 	long i;
Index: linux-2.6/arch/alpha/kernel/sys_mikasa.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_mikasa.c
+++ linux-2.6/arch/alpha/kernel/sys_mikasa.c
@@ -68,7 +68,7 @@ mikasa_end_irq(unsigned int irq)
 		mikasa_enable_irq(irq);
 }
 
-static struct hw_interrupt_type mikasa_irq_type = {
+static struct irq_chip mikasa_irq_type = {
 	.typename	= "MIKASA",
 	.startup	= mikasa_startup_irq,
 	.shutdown	= mikasa_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_noritake.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_noritake.c
+++ linux-2.6/arch/alpha/kernel/sys_noritake.c
@@ -73,7 +73,7 @@ noritake_end_irq(unsigned int irq)
                 noritake_enable_irq(irq);
 }
 
-static struct hw_interrupt_type noritake_irq_type = {
+static struct irq_chip noritake_irq_type = {
 	.typename	= "NORITAKE",
 	.startup	= noritake_startup_irq,
 	.shutdown	= noritake_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_rawhide.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rawhide.c
+++ linux-2.6/arch/alpha/kernel/sys_rawhide.c
@@ -135,7 +135,7 @@ rawhide_end_irq(unsigned int irq)
 		rawhide_enable_irq(irq);
 }
 
-static struct hw_interrupt_type rawhide_irq_type = {
+static struct irq_chip rawhide_irq_type = {
 	.typename	= "RAWHIDE",
 	.startup	= rawhide_startup_irq,
 	.shutdown	= rawhide_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_rx164.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_rx164.c
+++ linux-2.6/arch/alpha/kernel/sys_rx164.c
@@ -72,7 +72,7 @@ rx164_end_irq(unsigned int irq)
 		rx164_enable_irq(irq);
 }
 
-static struct hw_interrupt_type rx164_irq_type = {
+static struct irq_chip rx164_irq_type = {
 	.typename	= "RX164",
 	.startup	= rx164_startup_irq,
 	.shutdown	= rx164_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_sable.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_sable.c
+++ linux-2.6/arch/alpha/kernel/sys_sable.c
@@ -501,7 +501,7 @@ sable_lynx_mask_and_ack_irq(unsigned int
 	spin_unlock(&sable_lynx_irq_lock);
 }
 
-static struct hw_interrupt_type sable_lynx_irq_type = {
+static struct irq_chip sable_lynx_irq_type = {
 	.typename	= "SABLE/LYNX",
 	.startup	= sable_lynx_startup_irq,
 	.shutdown	= sable_lynx_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_takara.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_takara.c
+++ linux-2.6/arch/alpha/kernel/sys_takara.c
@@ -74,7 +74,7 @@ takara_end_irq(unsigned int irq)
 		takara_enable_irq(irq);
 }
 
-static struct hw_interrupt_type takara_irq_type = {
+static struct irq_chip takara_irq_type = {
 	.typename	= "TAKARA",
 	.startup	= takara_startup_irq,
 	.shutdown	= takara_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -183,7 +183,7 @@ titan_srm_device_interrupt(unsigned long
 
 
 static void __init
-init_titan_irqs(struct hw_interrupt_type * ops, int imin, int imax)
+init_titan_irqs(struct irq_chip * ops, int imin, int imax)
 {
 	long i;
 	for (i = imin; i <= imax; ++i) {
@@ -192,7 +192,7 @@ init_titan_irqs(struct hw_interrupt_type
 	}
 }
 
-static struct hw_interrupt_type titan_irq_type = {
+static struct irq_chip titan_irq_type = {
        .typename       = "TITAN",
        .startup        = titan_startup_irq,
        .shutdown       = titan_disable_irq,
Index: linux-2.6/arch/alpha/kernel/sys_wildfire.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_wildfire.c
+++ linux-2.6/arch/alpha/kernel/sys_wildfire.c
@@ -157,7 +157,7 @@ wildfire_end_irq(unsigned int irq)
 		wildfire_enable_irq(irq);
 }
 
-static struct hw_interrupt_type wildfire_irq_type = {
+static struct irq_chip wildfire_irq_type = {
 	.typename	= "WILDFIRE",
 	.startup	= wildfire_startup_irq,
 	.shutdown	= wildfire_disable_irq,


