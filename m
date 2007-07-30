Return-Path: <linux-kernel-owner+w=401wt.eu-S967168AbXG3SuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967168AbXG3SuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762915AbXG3SuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:50:11 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57322 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235AbXG3SuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:50:10 -0400
Date: Mon, 30 Jul 2007 20:51:24 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       J.E.J.Bottomley@HansenPartnership.com
Subject: Re: Section mismatch warnings
Message-ID: <20070730185124.GA29116@uranus.ravnborg.org>
References: <46AE2459.7080905@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AE2459.7080905@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 07:48:09PM +0200, Gabriel C wrote:
> Hi Sam ,
> 
> I get this warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-36 ) :
> 
> 
> ...
> 
I only looked at the Section mismatch warnings.
They are fixed by following patch.

James - I assume you will take this forward?

	Sam 

[PATCH] i386/voyager: fix section mismatch warnings
> WARNING: vmlinux.o(.text+0xeaf7): Section mismatch: reference to .init.text:init_gdt (between 'voyager_smp_prepare_boot_cpu' and 'smp_vic_cmn_interrupt')

voyager_smp_prepare_boot_cpu is marked __devinit and calls init_gdt.
init_gdt is marked __cpuinit

Fix seems to make voyager_smp_prepare_boot_cpu __init since I cannot see that
function being used for HOTPLUG. Maybe HOTPLUG_CPU but not HOTPLUG.

> WARNING: vmlinux.o(.text+0x104e3): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')

> WARNING: vmlinux.o(.text+0x1050a): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10510): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10517): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x1054a): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x1055b): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10765): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10778): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x107b6): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x107c9): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x1090e): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10935): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10944): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x10951): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x109aa): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x109b4): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x109ba): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x109c1): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
> WARNING: vmlinux.o(.text+0x109e4): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
voyager_cat_init is used only by smp_boot_cpus that is marked __init.
So fix is to mark voyager_cat_init as __init

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/arch/i386/mach-voyager/voyager_cat.c b/arch/i386/mach-voyager/voyager_cat.c
index 26a2d4c..f5acf06 100644
--- a/arch/i386/mach-voyager/voyager_cat.c
+++ b/arch/i386/mach-voyager/voyager_cat.c
@@ -568,8 +568,7 @@ static voyager_module_t *voyager_initial_module;
  * boot cpu *after* all memory initialisation has been done (so we can
  * use kmalloc) but before smp initialisation, so we can probe the SMP
  * configuration and pick up necessary information.  */
-void
-voyager_cat_init(void)
+void __init voyager_cat_init(void)
 {
 	voyager_module_t **modpp = &voyager_initial_module;
 	voyager_asic_t **asicpp;
diff --git a/arch/i386/mach-voyager/voyager_smp.c b/arch/i386/mach-voyager/voyager_smp.c
index b87f854..ac06a1c 100644
--- a/arch/i386/mach-voyager/voyager_smp.c
+++ b/arch/i386/mach-voyager/voyager_smp.c
@@ -1899,7 +1899,7 @@ voyager_smp_prepare_cpus(unsigned int max_cpus)
 	smp_boot_cpus();
 }
 
-static void __devinit voyager_smp_prepare_boot_cpu(void)
+static void __init voyager_smp_prepare_boot_cpu(void)
 {
 	init_gdt(smp_processor_id());
 	switch_to_new_gdt();
