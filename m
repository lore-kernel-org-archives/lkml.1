Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbXFTK03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbXFTK03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760936AbXFTKXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:49 -0400
Received: from mail.suse.de ([195.135.220.2]:48432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068AbXFTKXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:40 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: yhlu.kernel@gmail.com, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: [PATCH for 2.6.22] [10/10] x86_64: fix link warning between for .text and .init.text
Message-Id: <20070620102339.2812014ACF@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Yinghai Lu" <yhlu.kernel@gmail.com>

WARNING: arch/x86_64/kernel/built-in.o(.text+0xace9): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: arch/x86_64/kernel/built-in.o(.text+0xad09): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: arch/x86_64/kernel/built-in.o(.text+0xad38): Section
mismatch: reference to .init.text: (between 'get_mtrr_state' and
'mtrr_wrmsr')
WARNING: drivers/built-in.o(.text+0x3a680): Section mismatch:
reference to .init.text:acpi_map_pxm_to_node (between 'acpi_get_node'
and 'acpi_lock_ac_dir')

AK: also marked mtrr_bp_init __init to avoid some more warnings

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/cpu/mtrr/generic.c |    4 ++--
 arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/i386/kernel/cpu/mtrr/generic.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/generic.c
+++ linux/arch/i386/kernel/cpu/mtrr/generic.c
@@ -42,7 +42,7 @@ static int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
-static void __init
+static void
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
 	rdmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
@@ -68,7 +68,7 @@ void mtrr_save_fixed_ranges(void *info)
 	get_fixed_ranges(mtrr_state.fixed_ranges);
 }
 
-static void __cpuinit print_fixed(unsigned base, unsigned step, const mtrr_type*types)
+static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
 {
 	unsigned i;
 
Index: linux/arch/i386/kernel/cpu/mtrr/main.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mtrr/main.c
+++ linux/arch/i386/kernel/cpu/mtrr/main.c
@@ -644,7 +644,7 @@ static struct sysdev_driver mtrr_sysdev_
  * initialized (i.e. before smp_init()).
  * 
  */
-void mtrr_bp_init(void)
+__init void mtrr_bp_init(void)
 {
 	init_ifs();
 
