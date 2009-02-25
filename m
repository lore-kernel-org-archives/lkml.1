Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbZBYTgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbZBYTgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 14:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbZBYTgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 14:36:02 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:37550 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577AbZBYTgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 14:36:00 -0500
Date: Wed, 25 Feb 2009 11:36:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH] alpha: more u64/ull type fixes
Message-Id: <20090225113654.1f9614e8.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49A59D8F.0307:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

More alpha u64/ull fixes, on top of Andrew's 2 small patches.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: 
---
 arch/alpha/include/asm/machvec.h |    2 +-
 arch/alpha/kernel/proto.h        |   14 +++++++-------
 arch/alpha/kernel/sys_jensen.c   |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

--- lnx2629-rc5g3-alpha64.orig/arch/alpha/include/asm/machvec.h
+++ lnx2629-rc5g3-alpha64/arch/alpha/include/asm/machvec.h
@@ -80,7 +80,7 @@ struct alpha_machine_vector
 	void (*update_irq_hw)(unsigned long, unsigned long, int);
 	void (*ack_irq)(unsigned long);
 	void (*device_interrupt)(unsigned long vector);
-	void (*machine_check)(u64 vector, u64 la);
+	void (*machine_check)(unsigned long vector, unsigned long la);
 
 	void (*smp_callin)(void);
 	void (*init_arch)(void);
--- lnx2629-rc5g3-alpha64.orig/arch/alpha/kernel/proto.h
+++ lnx2629-rc5g3-alpha64/arch/alpha/kernel/proto.h
@@ -20,7 +20,7 @@ struct pci_controller;
 extern struct pci_ops apecs_pci_ops;
 extern void apecs_init_arch(void);
 extern void apecs_pci_clr_err(void);
-extern void apecs_machine_check(u64, u64);
+extern void apecs_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void apecs_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_cia.c */
@@ -29,7 +29,7 @@ extern void cia_init_pci(void);
 extern void cia_init_arch(void);
 extern void pyxis_init_arch(void);
 extern void cia_kill_arch(int);
-extern void cia_machine_check(u64, u64);
+extern void cia_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void cia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_irongate.c */
@@ -42,7 +42,7 @@ extern void irongate_machine_check(u64, 
 /* core_lca.c */
 extern struct pci_ops lca_pci_ops;
 extern void lca_init_arch(void);
-extern void lca_machine_check(u64, u64);
+extern void lca_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void lca_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_marvel.c */
@@ -72,14 +72,14 @@ extern struct pci_ops polaris_pci_ops;
 extern int polaris_read_config_dword(struct pci_dev *, int, u32 *);
 extern int polaris_write_config_dword(struct pci_dev *, int, u32);
 extern void polaris_init_arch(void);
-extern void polaris_machine_check(u64, u64);
+extern void polaris_machine_check(unsigned long vector, unsigned long la_ptr);
 #define polaris_pci_tbi ((void *)0)
 
 /* core_t2.c */
 extern struct pci_ops t2_pci_ops;
 extern void t2_init_arch(void);
 extern void t2_kill_arch(int);
-extern void t2_machine_check(u64, u64);
+extern void t2_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void t2_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_titan.c */
@@ -94,14 +94,14 @@ extern struct _alpha_agp_info *titan_agp
 extern struct pci_ops tsunami_pci_ops;
 extern void tsunami_init_arch(void);
 extern void tsunami_kill_arch(int);
-extern void tsunami_machine_check(u64, u64);
+extern void tsunami_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void tsunami_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_wildfire.c */
 extern struct pci_ops wildfire_pci_ops;
 extern void wildfire_init_arch(void);
 extern void wildfire_kill_arch(int);
-extern void wildfire_machine_check(u64, u64);
+extern void wildfire_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void wildfire_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern int wildfire_pa_to_nid(unsigned long);
 extern int wildfire_cpuid_to_nid(int);
--- lnx2629-rc5g3-alpha64.orig/arch/alpha/kernel/sys_jensen.c
+++ lnx2629-rc5g3-alpha64/arch/alpha/kernel/sys_jensen.c
@@ -244,7 +244,7 @@ jensen_init_arch(void)
 }
 
 static void
-jensen_machine_check (u64 vector, u64 la)
+jensen_machine_check (unsigned long vector, unsigned long la)
 {
 	printk(KERN_CRIT "Machine check\n");
 }
