Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXE1Qcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXE1Qcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXE1QcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:32:25 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54740 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966AbXE1QcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:32:25 -0400
Date: Mon, 28 May 2007 18:32:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Cc: sam@ravnborg.org
Subject: ARM: Section mismatch warnings
Message-ID: <20070528163253.GA29174@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell.

I've been building all defconfigs for ARM on latest -linus tree
and got the following results with respect to section mismatch warnings.

Unpatched: 105 section mismatch warnings

Applied a path to ignore section mismatch warnings from variables named *_timer.
Result: 39 section mismatch warnings.
I will carry this patch in kbuild.git since it touches only modpost.c

39 looked like a managebale set of warnings so I took a closer look.
With patches that I will post as follow-up for this mail:
Result: 19 section mismatch warnings (where some are duplicates from more than one defconfig).


The remaining warnings are the following:

# This symbol is exported and marked __init.
# Eiteher drop the export or drop the __init marking.
o-arm-mx1ads/log.out:WARNING: arch/arm/mach-imx/built-in.o(__ksymtab+0x80): Section mismatch: reference to .init.text:set_imx_fb_info (after '__ksymtab_set_imx_fb_info')

# These are all almost trivial if one knows the device-model. I did not know enough about the devicemodel to fix them.
# I suspect several symbols should NOT be marked __init since they are used in .add assignments and the like
# or mayby __Devinit since they are used only in HOTPLUG scenarios.
o-arm-ks8695/log.out:WARNING: arch/arm/mach-ks8695/built-in.o(.data+0x108): Section mismatch: reference to .init.text:micrel_pci_map_irq (after 'micrel_pci')
o-arm-lubbock/log.out:WARNING: drivers/built-in.o(.text+0x39f2c): Section mismatch: reference to .init.text:pcmcia_lubbock_init (between 'pcmcia_probe' and 'sa1111_pcmcia_socket_suspend')
o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1748): Section mismatch: reference to .init.text:sa1110_mb_disable (between 'neponset_init' and 'neponset_resume')
o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x17ac): Section mismatch: reference to .init.data:devices (between 'neponset_init' and 'neponset_resume')
o-arm-neponset/log.out:WARNING: drivers/built-in.o(.text+0x4e0a8): Section mismatch: reference to .init.text:pcmcia_neponset_init (between 'pcmcia_probe' and 'sa1111_pcmcia_socket_suspend')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2410/built-in.o(.text+0x80): Section mismatch: reference to .init.data:s3c2410_dma_order (between 's3c2410_dma_add' and 's3c2410_pm_add')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2410/built-in.o(.text+0x84): Section mismatch: reference to .init.data:s3c2410_dma_sel (between 's3c2410_dma_add' and 's3c2410_pm_add')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2412/built-in.o(.text+0x738): Section mismatch: reference to .init.data:s3c2412_dma_sel (between 's3c2412_dma_add' and 's3c2412_pm_prepare')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2440/built-in.o(.text+0x4b8): Section mismatch: reference to .init.data:s3c2440_dma_order (between 's3c2440_dma_add' and 'anubis_nand_select')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2440/built-in.o(.text+0x4bc): Section mismatch: reference to .init.data:s3c2440_dma_sel (between 's3c2440_dma_add' and 'anubis_nand_select')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0x1ac): Section mismatch: reference to .init.text:s3c2443_add_sub (between 's3c2443_irq_add' and 's3c2443_irq_wdtac97_mask')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0x1c8): Section mismatch: reference to .init.text:s3c2443_add_sub (between 's3c2443_irq_add' and 's3c2443_irq_wdtac97_mask')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0x1e4): Section mismatch: reference to .init.text:s3c2443_add_sub (between 's3c2443_irq_add' and 's3c2443_irq_wdtac97_mask')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0x200): Section mismatch: reference to .init.text:s3c2443_add_sub (between 's3c2443_irq_add' and 's3c2443_irq_wdtac97_mask')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0x21c): Section mismatch: reference to .init.text:s3c2443_add_sub (between 's3c2443_irq_add' and 's3c2443_irq_wdtac97_mask')
o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2443/built-in.o(.text+0xf0c): Section mismatch: reference to .init.data:s3c2443_dma_sel (after 's3c2443_dma_add')

# Assembler stuff. It looked to me like __INIT was used wrongly but then I did not feel confident enough to patch it up - and I cannot test it.
o-arm-realview-smp/log.out:WARNING: arch/arm/vfp/built-in.o(.data+0x0): Section mismatch: reference to .init.text:vfp_testing_entry (between 'vfp_vector' and 'vfp_notifier_block')
o-arm-versatile/log.out:WARNING: arch/arm/vfp/built-in.o(.data+0x0): Section mismatch: reference to .init.text:vfp_testing_entry (between 'vfp_vector' and 'vfp_notifier_block')

	Sam
