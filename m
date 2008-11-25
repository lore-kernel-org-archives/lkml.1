Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYKYGjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYKYGjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 01:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYKYGjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 01:39:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:55738 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbYKYGjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 01:39:18 -0500
Date: Tue, 25 Nov 2008 07:39:10 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Hannes Eder <hannes@hanneseder.net>, David Howells <dhowells@redhat.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] CRED: fix sparse warnings
In-Reply-To: <1227574619.5511.33.camel@brick>
Message-ID: <Pine.LNX.4.64.0811250733100.3905@ask.diku.dk>
References: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com> 
 <5008.1227568869@redhat.com>  <154e089b0811241646y6ada2c97l5e45284969729e29@mail.gmail.com>
 <1227574619.5511.33.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lot more returns from void functions are attached at the end of this 
message, mostly for other architectures.  I don't have time at the moment 
to check them and clean up the spacing, though.

julia

-------------------
Semantic patch (http://www.emn.fr/x-info/coccinelle/):

This semantic patch only considers the case where the returned expression 
is a function call or a constant.

// apply all the if rules twice, to catch the else case
@@
identifier f;
expression f1;
statement S;
@@

void f(...) {
<...
if (...)
+ {
- return 
  f1(...);
+ return;
+ }
else S
...>
}

@@
identifier f;
expression f1;
statement S;
@@

void f(...) {
<...
if (...)
+ {
- return 
  f1(...);
+ return;
+ }
else S
...>
}

@@
identifier f;
constant C;
statement S;
@@

void f(...) {
<...
if (...)
- return C;
+ return;
else S
...>
}

@@
identifier f;
constant C;
statement S;
@@

void f(...) {
<...
if (...)
- return C;
+ return;
else S
...>
}

@@
identifier f;
expression f1;
statement S;
@@

void f(...) {
<...
if (...) {
...
- return 
  f1(...);
+ return;
 }
else S
...>
}

@@
identifier f;
expression f1;
statement S;
@@

void f(...) {
<...
if (...) {
...
- return 
  f1(...);
+ return;
 }
else S
...>
}

@@
identifier f;
constant C;
statement S;
@@

void f(...) {
<...
if (...) {
...
- return C;
+ return;
 }
else S
...>
}

@@
identifier f;
constant C;
statement S;
@@

void f(...) {
<...
if (...) {
...
- return C;
+ return;
 }
else S
...>
}

@@
identifier f;
expression f1;
@@

void f(...) {
  ...
- return 
  f1(...);
}

@@
identifier f;
constant C;
@@

void f(...) {
  ...
- return C;
+ return;
}

------------------------
Results:

diff -u -p a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
--- a/arch/alpha/include/asm/io.h 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/alpha/include/asm/io.h 2008-11-22 14:56:26.000000000 +0100
@@ -188,7 +188,7 @@ static inline void __iomem *generic_iore
 
 static inline void generic_iounmap(volatile void __iomem *a)
 {
-	return alpha_mv.mv_iounmap(a);
+	 alpha_mv.mv_iounmap(a);
 }
 
 static inline int generic_is_ioaddr(unsigned long a)
diff -u -p a/arch/alpha/kernel/err_titan.c b/arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/alpha/kernel/err_titan.c 2008-11-22 14:56:29.000000000 +0100
@@ -724,7 +724,9 @@ privateer_machine_check(u64 vector, u64 
 	 * Only handle system events here.
 	 */
 	if (vector != SCB_Q_SYSEVENT) 
-		return titan_machine_check(vector, la_ptr);
+		{ titan_machine_check(vector, la_ptr);
+		return;
+	}
 
 	/*
 	 * Report the event - System Events should be reported even if no
diff -u -p a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/alpha/kernel/sys_titan.c 2008-11-22 14:56:40.000000000 +0100
@@ -366,7 +366,7 @@ privateer_init_pci(void)
 	/*
 	 * Finish with the common version.
 	 */
-	return titan_init_pci();
+	 titan_init_pci();
 }
 
 
diff -u -p a/arch/arm/plat-omap/sram.c b/arch/arm/plat-omap/sram.c
--- a/arch/arm/plat-omap/sram.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/arm/plat-omap/sram.c 2008-11-22 14:57:50.000000000 +0100
@@ -255,7 +255,7 @@ void omap_sram_reprogram_clock(u32 dpllc
 	if (!_omap_sram_reprogram_clock)
 		omap_sram_error();
 
-	return _omap_sram_reprogram_clock(dpllctl, ckctl);
+	 _omap_sram_reprogram_clock(dpllctl, ckctl);
 }
 
 int __init omap1_sram_init(void)
@@ -282,7 +282,7 @@ void omap2_sram_ddr_init(u32 *slow_dll_c
 	if (!_omap2_sram_ddr_init)
 		omap_sram_error();
 
-	return _omap2_sram_ddr_init(slow_dll_ctrl, fast_dll_ctrl,
+	 _omap2_sram_ddr_init(slow_dll_ctrl, fast_dll_ctrl,
 				    base_cs, force_unlock);
 }
 
@@ -294,7 +294,7 @@ void omap2_sram_reprogram_sdrc(u32 perf_
 	if (!_omap2_sram_reprogram_sdrc)
 		omap_sram_error();
 
-	return _omap2_sram_reprogram_sdrc(perf_level, dll_val, mem_type);
+	 _omap2_sram_reprogram_sdrc(perf_level, dll_val, mem_type);
 }
 
 static u32 (*_omap2_set_prcm)(u32 dpll_ctrl_val, u32 sdrc_rfr_val, int bypass);
diff -u -p a/arch/avr32/mach-at32ap/include/mach/sram.h b/arch/avr32/mach-at32ap/include/mach/sram.h
--- a/arch/avr32/mach-at32ap/include/mach/sram.h 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/avr32/mach-at32ap/include/mach/sram.h 2008-11-22 14:58:04.000000000 +0100
@@ -24,7 +24,7 @@ static inline unsigned long sram_alloc(s
 
 static inline void sram_free(unsigned long addr, size_t len)
 {
-	return gen_pool_free(sram_pool, addr, len);
+	 gen_pool_free(sram_pool, addr, len);
 }
 
 #endif /* __ASM_AVR32_ARCH_SRAM_H */
diff -u -p a/arch/cris/mm/ioremap.c b/arch/cris/mm/ioremap.c
--- a/arch/cris/mm/ioremap.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/cris/mm/ioremap.c 2008-11-22 14:58:36.000000000 +0100
@@ -84,5 +84,7 @@ void __iomem *ioremap_nocache (unsigned 
 void iounmap(volatile void __iomem *addr)
 {
 	if (addr > high_memory)
-		return vfree((void *) (PAGE_MASK & (unsigned long) addr));
+		{ vfree((void *) (PAGE_MASK & (unsigned long) addr));
+		return;
+	}
 }
diff -u -p a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
--- a/arch/ia64/hp/common/hwsw_iommu.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/ia64/hp/common/hwsw_iommu.c 2008-11-22 14:56:27.000000000 +0100
@@ -106,9 +106,13 @@ hwsw_unmap_single_attrs(struct device *d
 			 int dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
-	else
-		return hwiommu_unmap_single_attrs(dev, iova, size, dir, attrs);
+		{ swiotlb_unmap_single_attrs(dev, iova, size, dir, attrs);
+		return;
+	}
+	else
+		{ hwiommu_unmap_single_attrs(dev, iova, size, dir, attrs);
+		return;
+	}
 }
 EXPORT_SYMBOL(hwsw_unmap_single_attrs);
 
@@ -128,9 +132,13 @@ hwsw_unmap_sg_attrs(struct device *dev, 
 		     int dir, struct dma_attrs *attrs)
 {
 	if (use_swiotlb(dev))
-		return swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
-	else
-		return hwiommu_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
+		{ swiotlb_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
+		return;
+	}
+	else
+		{ hwiommu_unmap_sg_attrs(dev, sglist, nents, dir, attrs);
+		return;
+	}
 }
 EXPORT_SYMBOL(hwsw_unmap_sg_attrs);
 
diff -u -p a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/asm/dma-mapping.h
--- a/arch/ia64/include/asm/dma-mapping.h 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/ia64/include/asm/dma-mapping.h 2008-11-22 15:03:07.000000000 +0100
@@ -84,13 +84,13 @@ static inline int dma_map_sg(struct devi
 static inline void dma_unmap_single(struct device *dev, dma_addr_t cpu_addr,
 				    size_t size, int dir)
 {
-	return dma_unmap_single_attrs(dev, cpu_addr, size, dir, NULL);
+	 dma_unmap_single_attrs(dev, cpu_addr, size, dir, NULL);
 }
 #define dma_unmap_sg_attrs	platform_dma_unmap_sg_attrs
 static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sgl,
 				int nents, int dir)
 {
-	return dma_unmap_sg_attrs(dev, sgl, nents, dir, NULL);
+	 dma_unmap_sg_attrs(dev, sgl, nents, dir, NULL);
 }
 #define dma_sync_single_for_cpu	platform_dma_sync_single_for_cpu
 #define dma_sync_sg_for_cpu	platform_dma_sync_sg_for_cpu
diff -u -p a/arch/ia64/include/asm/paravirt.h b/arch/ia64/include/asm/paravirt.h
--- a/arch/ia64/include/asm/paravirt.h 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/ia64/include/asm/paravirt.h 2008-11-22 15:03:06.000000000 +0100
@@ -147,7 +147,7 @@ __iosapic_read(char __iomem *iosapic, un
 static inline void
 __iosapic_write(char __iomem *iosapic, unsigned int reg, u32 val)
 {
-	return pv_iosapic_ops.__write(iosapic, reg, val);
+	 pv_iosapic_ops.__write(iosapic, reg, val);
 }
 
 /******************************************************************************
@@ -183,7 +183,7 @@ assign_irq_vector(int irq)
 static inline void
 free_irq_vector(int vector)
 {
-	return pv_irq_ops.free_irq_vector(vector);
+	 pv_irq_ops.free_irq_vector(vector);
 }
 
 static inline void
diff -u -p a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
--- a/arch/ia64/kernel/machvec.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/ia64/kernel/machvec.c 2008-11-22 14:56:39.000000000 +0100
@@ -51,13 +51,15 @@ machvec_init_from_cmdline(const char *cm
 	char *end;
 
 	if (! (start = strstr(cmdline, "machvec=")) )
-		return machvec_init(NULL);
+		{ machvec_init(NULL);
+		return;
+	}
 
 	strlcpy(str, start + strlen("machvec="), sizeof(str));
 	if ( (end = strchr(str, ' ')) )
 		*end = '\0';
 
-	return machvec_init(str);
+	 machvec_init(str);
 }
 
 #endif /* CONFIG_IA64_GENERIC */
diff -u -p a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
--- a/arch/ia64/kernel/msi_ia64.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/ia64/kernel/msi_ia64.c 2008-11-22 14:56:33.000000000 +0100
@@ -159,9 +159,11 @@ int arch_setup_msi_irq(struct pci_dev *p
 void arch_teardown_msi_irq(unsigned int irq)
 {
 	if (platform_teardown_msi_irq)
-		return platform_teardown_msi_irq(irq);
+		{ platform_teardown_msi_irq(irq);
+		return;
+	}
 
-	return ia64_teardown_msi_irq(irq);
+	 ia64_teardown_msi_irq(irq);
 }
 
 #ifdef CONFIG_DMAR
diff -u -p a/arch/mips/mm/page.c b/arch/mips/mm/page.c
--- a/arch/mips/mm/page.c 2008-11-17 12:16:39.000000000 +0100
+++ b/arch/mips/mm/page.c 2008-11-22 14:59:56.000000000 +0100
@@ -643,7 +643,9 @@ void clear_page(void *page)
 
 	/* if the page is not in KSEG0, use old way */
 	if ((long)KSEGX((unsigned long)page) != (long)CKSEG0)
-		return clear_page_cpu(page);
+		{ clear_page_cpu(page);
+		return;
+	}
 
 	page_descr[cpu].dscr_a = to_phys | M_DM_DSCRA_ZERO_MEM |
 				 M_DM_DSCRA_L2C_DEST | M_DM_DSCRA_INTERRUPT;
@@ -669,7 +671,9 @@ void copy_page(void *to, void *from)
 	/* if any page is not in KSEG0, use old way */
 	if ((long)KSEGX((unsigned long)to) != (long)CKSEG0
 	    || (long)KSEGX((unsigned long)from) != (long)CKSEG0)
-		return copy_page_cpu(to, from);
+		{ copy_page_cpu(to, from);
+		return;
+	}
 
 	page_descr[cpu].dscr_a = to_phys | M_DM_DSCRA_L2C_DEST |
 				 M_DM_DSCRA_INTERRUPT;
diff -u -p a/arch/parisc/include/asm/floppy.h b/arch/parisc/include/asm/floppy.h
--- a/arch/parisc/include/asm/floppy.h 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/parisc/include/asm/floppy.h 2008-11-22 14:59:01.000000000 +0100
@@ -180,7 +180,9 @@ static unsigned long vdma_mem_alloc(unsi
 static void _fd_dma_mem_free(unsigned long addr, unsigned long size)
 {
 	if((unsigned int) addr >= (unsigned int) high_memory)
-		return vfree((void *)addr);
+		{ vfree((void *)addr);
+		return;
+	}
 	else
 		free_pages(addr, get_order(size));		
 }
diff -u -p a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
--- a/arch/parisc/kernel/traps.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/parisc/kernel/traps.c 2008-11-22 14:59:09.000000000 +0100
@@ -223,7 +223,7 @@ show_stack:
 
 void show_stack(struct task_struct *t, unsigned long *sp)
 {
-	return parisc_show_stack(t, sp, NULL);
+	 parisc_show_stack(t, sp, NULL);
 }
 
 int is_valid_bugaddr(unsigned long iaoq)
diff -u -p a/arch/parisc/mm/ioremap.c b/arch/parisc/mm/ioremap.c
--- a/arch/parisc/mm/ioremap.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/parisc/mm/ioremap.c 2008-11-22 14:58:57.000000000 +0100
@@ -94,6 +94,8 @@ EXPORT_SYMBOL(__ioremap);
 void iounmap(const volatile void __iomem *addr)
 {
 	if (addr > high_memory)
-		return vfree((void *) (PAGE_MASK & (unsigned long __force) addr));
+		{ vfree((void *) (PAGE_MASK & (unsigned long __force) addr));
+		return;
+	}
 }
 EXPORT_SYMBOL(iounmap);
diff -u -p a/arch/powerpc/platforms/powermac/udbg_adb.c b/arch/powerpc/platforms/powermac/udbg_adb.c
--- a/arch/powerpc/platforms/powermac/udbg_adb.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/powerpc/platforms/powermac/udbg_adb.c 2008-11-22 14:57:40.000000000 +0100
@@ -146,7 +146,9 @@ static void udbg_adb_putc(char c)
 		btext_drawchar(c);
 #endif
 	if (udbg_adb_old_putc)
-		return udbg_adb_old_putc(c);
+		{ udbg_adb_old_putc(c);
+		return;
+		}
 }
 
 void __init udbg_adb_init_early(void)
diff -u -p a/arch/sh/kernel/cpu/clock.c b/arch/sh/kernel/cpu/clock.c
--- a/arch/sh/kernel/cpu/clock.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/sh/kernel/cpu/clock.c 2008-11-22 14:57:51.000000000 +0100
@@ -153,7 +153,7 @@ void clk_disable(struct clk *clk)
 	unsigned long flags;
 
 	if (!clk)
-		return -EINVAL;
+		return;
 
 	spin_lock_irqsave(&clock_lock, flags);
 	__clk_disable(clk);
diff -u -p a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
--- a/arch/sparc/include/asm/pci_64.h 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/sparc/include/asm/pci_64.h 2008-11-22 14:58:43.000000000 +0100
@@ -44,7 +44,7 @@ static inline void *pci_alloc_consistent
 static inline void pci_free_consistent(struct pci_dev *pdev, size_t size,
 				       void *vaddr, dma_addr_t dma_handle)
 {
-	return dma_free_coherent(&pdev->dev, size, vaddr, dma_handle);
+	 dma_free_coherent(&pdev->dev, size, vaddr, dma_handle);
 }
 
 static inline dma_addr_t pci_map_single(struct pci_dev *pdev, void *ptr,
diff -u -p a/arch/sparc/kernel/irq.c b/arch/sparc/kernel/irq.c
--- a/arch/sparc/kernel/irq.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/sparc/kernel/irq.c 2008-11-22 14:58:48.000000000 +0100
@@ -592,19 +592,19 @@ EXPORT_SYMBOL(request_irq);
 
 void disable_irq_nosync(unsigned int irq)
 {
-	return __disable_irq(irq);
+	 __disable_irq(irq);
 }
 EXPORT_SYMBOL(disable_irq_nosync);
 
 void disable_irq(unsigned int irq)
 {
-	return __disable_irq(irq);
+	 __disable_irq(irq);
 }
 EXPORT_SYMBOL(disable_irq);
 
 void enable_irq(unsigned int irq)
 {
-	return __enable_irq(irq);
+	 __enable_irq(irq);
 }
 
 EXPORT_SYMBOL(enable_irq);
diff -u -p a/arch/sparc/kernel/prom.c b/arch/sparc/kernel/prom.c
--- a/arch/sparc/kernel/prom.c 2008-11-17 12:16:40.000000000 +0100
+++ b/arch/sparc/kernel/prom.c 2008-11-22 14:58:50.000000000 +0100
@@ -244,17 +244,23 @@ static void __init __build_path_componen
 	if (parent != NULL) {
 		if (!strcmp(parent->type, "pci") ||
 		    !strcmp(parent->type, "pciex"))
-			return pci_path_component(dp, tmp_buf);
+			{ pci_path_component(dp, tmp_buf);
+			return;
+		}
 		if (!strcmp(parent->type, "sbus"))
-			return sbus_path_component(dp, tmp_buf);
+			{ sbus_path_component(dp, tmp_buf);
+			return;
+		}
 		if (!strcmp(parent->type, "ebus"))
-			return ebus_path_component(dp, tmp_buf);
+			{ ebus_path_component(dp, tmp_buf);
+			return;
+		}
 
 		/* "isa" is handled with platform naming */
 	}
 
 	/* Use platform naming convention.  */
-	return sparc32_path_component(dp, tmp_buf);
+	 sparc32_path_component(dp, tmp_buf);
 }
 
 static char * __init build_path_component(struct device_node *dp)
diff -u -p a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
--- a/drivers/ata/pata_icside.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/ata/pata_icside.c 2008-11-22 15:22:41.000000000 +0100
@@ -316,7 +316,9 @@ static void pata_icside_postreset(struct
 	struct pata_icside_state *state = ap->host->private_data;
 
 	if (classes[0] != ATA_DEV_NONE || classes[1] != ATA_DEV_NONE)
-		return ata_sff_postreset(link, classes);
+		{ ata_sff_postreset(link, classes);
+		return;
+	}
 
 	state->port[ap->port_no].disabled = 1;
 
diff -u -p a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
--- a/drivers/block/xen-blkfront.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/block/xen-blkfront.c 2008-11-22 15:16:00.000000000 +0100
@@ -1081,7 +1081,7 @@ module_init(xlblk_init);
 
 static void __exit xlblk_exit(void)
 {
-	return xenbus_unregister_driver(&blkfront);
+	 xenbus_unregister_driver(&blkfront);
 }
 module_exit(xlblk_exit);
 
diff -u -p a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
--- a/drivers/ide/alim15x3.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/ide/alim15x3.c 2008-11-22 15:22:59.000000000 +0100
@@ -591,7 +591,7 @@ static int __init ali15x3_ide_init(void)
 
 static void __exit ali15x3_ide_exit(void)
 {
-	return pci_unregister_driver(&alim15x3_pci_driver);
+	 pci_unregister_driver(&alim15x3_pci_driver);
 }
 
 module_init(ali15x3_ide_init);
diff -u -p a/drivers/ide/falconide.c b/drivers/ide/falconide.c
--- a/drivers/ide/falconide.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/ide/falconide.c 2008-11-22 15:23:03.000000000 +0100
@@ -49,7 +49,9 @@ static void falconide_input_data(ide_dri
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
 	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
-		return insw(data_addr, buf, (len + 1) / 2);
+		{ insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	insw_swapw(data_addr, buf, (len + 1) / 2);
 }
@@ -60,7 +62,9 @@ static void falconide_output_data(ide_dr
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
 	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
-		return outsw(data_addr, buf, (len + 1) / 2);
+		{ outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
diff -u -p a/drivers/ide/q40ide.c b/drivers/ide/q40ide.c
--- a/drivers/ide/q40ide.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/ide/q40ide.c 2008-11-22 15:23:10.000000000 +0100
@@ -78,7 +78,9 @@ static void q40ide_input_data(ide_drive_
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
 	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
-		return insw(data_addr, buf, (len + 1) / 2);
+		{ insw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	insw_swapw(data_addr, buf, (len + 1) / 2);
 }
@@ -89,7 +91,9 @@ static void q40ide_output_data(ide_drive
 	unsigned long data_addr = drive->hwif->io_ports.data_addr;
 
 	if (drive->media == ide_disk && rq && rq->cmd_type == REQ_TYPE_FS)
-		return outsw(data_addr, buf, (len + 1) / 2);
+		{ outsw(data_addr, buf, (len + 1) / 2);
+		return;
+	}
 
 	outsw_swapw(data_addr, buf, (len + 1) / 2);
 }
diff -u -p a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
--- a/drivers/isdn/i4l/isdn_net.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/isdn/i4l/isdn_net.c 2008-11-22 15:04:18.000000000 +0100
@@ -1978,7 +1978,9 @@ static void isdn_header_cache_update(str
 {
 	isdn_net_local *lp = dev->priv;
 	if (lp->p_encap == ISDN_NET_ENCAP_ETHER)
-		return eth_header_cache_update(hh, dev, haddr);
+		{ eth_header_cache_update(hh, dev, haddr);
+		return;
+	}
 }
 
 static const struct header_ops isdn_header_ops = {
diff -u -p a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/leds/leds-ams-delta.c 2008-11-22 15:04:14.000000000 +0100
@@ -151,7 +151,7 @@ static int __init ams_delta_led_init(voi
 
 static void __exit ams_delta_led_exit(void)
 {
-	return platform_driver_unregister(&ams_delta_led_driver);
+	 platform_driver_unregister(&ams_delta_led_driver);
 }
 
 module_init(ams_delta_led_init);
diff -u -p a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h 2008-11-17 12:16:40.000000000 +0100
+++ b/drivers/misc/sgi-xp/xp.h 2008-11-22 15:04:06.000000000 +0100
@@ -329,7 +329,7 @@ xpc_send_notify(short partid, int ch_num
 static inline void
 xpc_received(short partid, int ch_number, void *payload)
 {
-	return xpc_interface.received(partid, ch_number, payload);
+	 xpc_interface.received(partid, ch_number, payload);
 }
 
 static inline enum xp_retval
diff -u -p a/drivers/net/korina.c b/drivers/net/korina.c
--- a/drivers/net/korina.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/net/korina.c 2008-11-22 15:01:57.000000000 +0100
@@ -1216,7 +1216,7 @@ static int __init korina_init_module(voi
 
 static void korina_cleanup_module(void)
 {
-	return platform_driver_unregister(&korina_driver);
+	 platform_driver_unregister(&korina_driver);
 }
 
 module_init(korina_init_module);
diff -u -p a/drivers/net/ni52.c b/drivers/net/ni52.c
--- a/drivers/net/ni52.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/net/ni52.c 2008-11-22 15:08:48.000000000 +0100
@@ -1146,7 +1146,7 @@ static void ni52_timeout(struct net_devi
 		ni_attn586();
 		wait_for_scb_cmd(dev);
 		dev->trans_start = jiffies;
-		return 0;
+		return;
 	}
 #endif
 	{
diff -u -p a/drivers/net/niu.c b/drivers/net/niu.c
--- a/drivers/net/niu.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/net/niu.c 2008-11-22 15:14:49.000000000 +0100
@@ -8822,7 +8822,7 @@ static u64 niu_pci_map_page(struct devic
 static void niu_pci_unmap_page(struct device *dev, u64 dma_address,
 			       size_t size, enum dma_data_direction direction)
 {
-	return dma_unmap_page(dev, dma_address, size, direction);
+	 dma_unmap_page(dev, dma_address, size, direction);
 }
 
 static u64 niu_pci_map_single(struct device *dev, void *cpu_addr,
diff -u -p a/drivers/net/wireless/orinoco/airport.c b/drivers/net/wireless/orinoco/airport.c
--- a/drivers/net/wireless/orinoco/airport.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/net/wireless/orinoco/airport.c 2008-11-22 15:09:41.000000000 +0100
@@ -279,7 +279,7 @@ init_airport(void)
 static void __exit
 exit_airport(void)
 {
-	return macio_unregister_driver(&airport_driver);
+	 macio_unregister_driver(&airport_driver);
 }
 
 module_init(init_airport);
diff -u -p a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
--- a/drivers/parisc/gsc.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/parisc/gsc.c 2008-11-22 15:01:05.000000000 +0100
@@ -205,7 +205,9 @@ void gsc_fixup_irqs(struct parisc_device
 		/* work-around for 715/64 and others which have parent 
 		   at path [5] and children at path [5/0/x] */
 		if (padev->id.hw_type == HPHW_FAULTY)
-			return gsc_fixup_irqs(padev, ctrl, choose_irq);
+			{ gsc_fixup_irqs(padev, ctrl, choose_irq);
+			return;
+		}
 		choose_irq(padev, ctrl);
 	}
 	klist_iter_exit(&i);
diff -u -p a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/rtc/rtc-ds1511.c 2008-11-22 15:04:10.000000000 +0100
@@ -631,7 +631,7 @@ ds1511_rtc_init(void)
  static void __exit
 ds1511_rtc_exit(void)
 {
-	return platform_driver_unregister(&ds1511_rtc_driver);
+	 platform_driver_unregister(&ds1511_rtc_driver);
 }
 
 module_init(ds1511_rtc_init);
diff -u -p a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/rtc/rtc-stk17ta8.c 2008-11-22 15:04:09.000000000 +0100
@@ -400,7 +400,7 @@ static __init int stk17ta8_init(void)
 
 static __exit void stk17ta8_exit(void)
 {
-	return platform_driver_unregister(&stk17ta8_rtc_driver);
+	 platform_driver_unregister(&stk17ta8_rtc_driver);
 }
 
 module_init(stk17ta8_init);
diff -u -p a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
--- a/drivers/scsi/mac53c94.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/scsi/mac53c94.c 2008-11-22 15:03:09.000000000 +0100
@@ -555,7 +555,7 @@ static int __init init_mac53c94(void)
 
 static void __exit exit_mac53c94(void)
 {
-	return macio_unregister_driver(&mac53c94_driver);
+	 macio_unregister_driver(&mac53c94_driver);
 }
 
 module_init(init_mac53c94);
diff -u -p a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/scsi/mesh.c 2008-11-22 15:33:38.000000000 +0100
@@ -2067,7 +2067,7 @@ static int __init init_mesh(void)
 
 static void __exit exit_mesh(void)
 {
-	return macio_unregister_driver(&mesh_driver);
+	 macio_unregister_driver(&mesh_driver);
 }
 
 module_init(init_mesh);
diff -u -p a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/scsi/sgiwd93.c 2008-11-22 15:03:25.000000000 +0100
@@ -325,7 +325,7 @@ static int __init sgiwd93_module_init(vo
 
 static void __exit sgiwd93_module_exit(void)
 {
-	return platform_driver_unregister(&sgiwd93_driver);
+	 platform_driver_unregister(&sgiwd93_driver);
 }
 
 module_init(sgiwd93_module_init);
diff -u -p a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
--- a/drivers/serial/of_serial.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/serial/of_serial.c 2008-11-22 15:05:20.000000000 +0100
@@ -168,7 +168,7 @@ module_init(of_platform_serial_init);
 
 static void __exit of_platform_serial_exit(void)
 {
-	return of_unregister_platform_driver(&of_platform_serial_driver);
+	 of_unregister_platform_driver(&of_platform_serial_driver);
 };
 module_exit(of_platform_serial_exit);
 
diff -u -p a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
--- a/drivers/usb/musb/tusb6010.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/usb/musb/tusb6010.c 2008-11-22 15:09:09.000000000 +0100
@@ -605,7 +605,7 @@ void musb_platform_set_mode(struct musb 
 
 	if (musb->board_mode != MUSB_OTG) {
 		ERR("Changing mode currently only supported in OTG mode\n");
-		return -EINVAL;
+		return;
 	}
 
 	otg_stat = musb_readl(tbase, TUSB_DEV_OTG_STAT);
diff -u -p a/drivers/video/i810/i810_accel.c b/drivers/video/i810/i810_accel.c
--- a/drivers/video/i810/i810_accel.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/i810/i810_accel.c 2008-11-22 14:59:09.000000000 +0100
@@ -302,7 +302,9 @@ void i810fb_fillrect(struct fb_info *inf
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
 	    par->depth == 4) 
-		return cfb_fillrect(info, rect);
+		{ cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (par->depth == 1) 
 		color = rect->color;
@@ -328,7 +330,9 @@ void i810fb_copyarea(struct fb_info *inf
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
 	    par->depth == 4)
-		return cfb_copyarea(info, region);
+		{ cfb_copyarea(info, region);
+		return;
+	}
 
 	dx = region->dx * par->depth;
 	sx = region->sx * par->depth;
@@ -367,7 +371,9 @@ void i810fb_imageblit(struct fb_info *in
 	
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
 	    par->depth == 4 || image->depth != 1) 
-		return cfb_imageblit(info, image);
+		{ cfb_imageblit(info, image);
+		return;
+	}
 
 	switch (info->var.bits_per_pixel) {
 	case 8:
diff -u -p a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/intelfb/intelfbdrv.c 2008-11-22 14:57:41.000000000 +0100
@@ -1494,7 +1494,9 @@ static void intelfb_fillrect (struct fb_
 #endif
 
 	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_fillrect(info, rect);
+		{ cfb_fillrect(info, rect);
+		return;
+		}
 
 	if (rect->rop == ROP_COPY)
 		rop = PAT_ROP_GXCOPY;
@@ -1522,7 +1524,9 @@ static void intelfb_copyarea(struct fb_i
 #endif
 
 	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_copyarea(info, region);
+		{ cfb_copyarea(info, region);
+		return;
+		}
 
 	intelfbhw_do_bitblt(dinfo, region->sx, region->sy, region->dx,
 			    region->dy, region->width, region->height,
@@ -1541,7 +1545,9 @@ static void intelfb_imageblit(struct fb_
 
 	if (!ACCEL(dinfo, info) || dinfo->depth == 4
 	    || image->depth != 1)
-		return cfb_imageblit(info, image);
+		{ cfb_imageblit(info, image);
+		return;
+		}
 
 	if (dinfo->depth != 8) {
 		fgcolor = dinfo->pseudo_palette[image->fg_color];
@@ -1555,7 +1561,9 @@ static void intelfb_imageblit(struct fb_
 				    image->height, image->data,
 				    image->dx, image->dy,
 				    dinfo->pitch, info->var.bits_per_pixel))
-		return cfb_imageblit(info, image);
+		{ cfb_imageblit(info, image);
+		return;
+		}
 }
 
 static int intelfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
diff -u -p a/drivers/video/neofb.c b/drivers/video/neofb.c
--- a/drivers/video/neofb.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/neofb.c 2008-11-22 14:57:47.000000000 +0100
@@ -1453,7 +1453,8 @@ neo2200_imageblit(struct fb_info *info, 
 			 * is less than 16 bits wide. This is due to insufficient
 			 * padding when writing the image. We need to adjust
 			 * struct fb_pixmap. Not yet done. */
-			return cfb_imageblit(info, image);
+			 cfb_imageblit(info, image);
+			return;
 		}
 		bltCntl_flags = NEO_BC0_SRC_MONO;
 	} else if (image->depth == info->var.bits_per_pixel) {
@@ -1461,7 +1462,8 @@ neo2200_imageblit(struct fb_info *info, 
 	} else {
 		/* We don't currently support hardware acceleration if image
 		 * depth is different from display */
-		return cfb_imageblit(info, image);
+		 cfb_imageblit(info, image);
+		return;
 	}
 
 	switch (info->var.bits_per_pixel) {
diff -u -p a/drivers/video/nvidia/nv_accel.c b/drivers/video/nvidia/nv_accel.c
--- a/drivers/video/nvidia/nv_accel.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/nvidia/nv_accel.c 2008-11-22 14:58:22.000000000 +0100
@@ -301,7 +301,9 @@ void nvidiafb_copyarea(struct fb_info *i
 		return;
 
 	if (par->lockup)
-		return cfb_copyarea(info, region);
+		{ cfb_copyarea(info, region);
+		return;
+	}
 
 	NVDmaStart(info, par, BLIT_POINT_SRC, 3);
 	NVDmaNext(par, (region->sy << 16) | region->sx);
@@ -320,7 +322,9 @@ void nvidiafb_fillrect(struct fb_info *i
 		return;
 
 	if (par->lockup)
-		return cfb_fillrect(info, rect);
+		{ cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8)
 		color = rect->color;
diff -u -p a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/pm3fb.c 2008-11-22 14:57:40.000000000 +0100
@@ -540,7 +540,9 @@ static void pm3fb_imageblit(struct fb_in
 		break;
 	}
 	if (image->depth != 1)
-		return cfb_imageblit(info, image);
+		{ cfb_imageblit(info, image);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8) {
 		fgx |= fgx << 8;
diff -u -p a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c 2008-11-17 12:16:41.000000000 +0100
+++ b/drivers/video/via/viafbdev.c 2008-11-22 14:57:39.000000000 +0100
@@ -868,7 +868,9 @@ static void viafb_fillrect(struct fb_inf
 	int pitch;
 
 	if (!viafb_accel)
-		return cfb_fillrect(info, rect);
+		{ cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (!rect->width || !rect->height)
 		return;
@@ -935,7 +937,9 @@ static void viafb_copyarea(struct fb_inf
 	DEBUG_MSG(KERN_INFO "viafb_copyarea!!\n");
 
 	if (!viafb_accel)
-		return cfb_copyarea(info, area);
+		{ cfb_copyarea(info, area);
+		return;
+	}
 
 	if (!area->width || !area->height)
 		return;
@@ -992,7 +996,9 @@ static void viafb_imageblit(struct fb_in
 	int pitch;
 
 	if (!viafb_accel)
-		return cfb_imageblit(info, image);
+		{ cfb_imageblit(info, image);
+		return;
+	}
 
 	udata = (u32 *) image->data;
 
diff -u -p a/fs/udf/balloc.c b/fs/udf/balloc.c
--- a/fs/udf/balloc.c 2008-11-17 12:16:41.000000000 +0100
+++ b/fs/udf/balloc.c 2008-11-22 15:07:43.000000000 +0100
@@ -837,21 +837,25 @@ inline void udf_free_blocks(struct super
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
 
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
+		 udf_bitmap_free_blocks(sb, inode,
 					      map->s_uspace.s_bitmap,
 					      bloc, offset, count);
+					      return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_TABLE) {
-		return udf_table_free_blocks(sb, inode,
+		 udf_table_free_blocks(sb, inode,
 					     map->s_uspace.s_table,
 					     bloc, offset, count);
+					     return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP) {
-		return udf_bitmap_free_blocks(sb, inode,
+		 udf_bitmap_free_blocks(sb, inode,
 					      map->s_fspace.s_bitmap,
 					      bloc, offset, count);
+					      return;
 	} else if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE) {
-		return udf_table_free_blocks(sb, inode,
+		 udf_table_free_blocks(sb, inode,
 					     map->s_fspace.s_table,
 					     bloc, offset, count);
+					     return;
 	} else {
 		return;
 	}
diff -u -p a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
--- a/fs/xfs/xfs_inode.h 2008-11-17 12:16:41.000000000 +0100
+++ b/fs/xfs/xfs_inode.h 2008-11-22 15:11:47.000000000 +0100
@@ -323,7 +323,7 @@ static inline struct inode *VFS_I(struct
 static inline void xfs_destroy_inode(struct xfs_inode *ip)
 {
 	make_bad_inode(VFS_I(ip));
-	return destroy_inode(VFS_I(ip));
+	 destroy_inode(VFS_I(ip));
 }
 
 /*
diff -u -p a/include/asm-mn10300/io.h b/include/asm-mn10300/io.h
--- a/include/asm-mn10300/io.h 2008-11-17 12:16:41.000000000 +0100
+++ b/include/asm-mn10300/io.h 2008-11-22 14:57:27.000000000 +0100
@@ -77,7 +77,7 @@ static inline u8 inb_local(unsigned long
 
 static inline void outb_local(u8 b, unsigned long addr)
 {
-	return writeb(b, (volatile void __iomem *) addr);
+	 writeb(b, (volatile void __iomem *) addr);
 }
 
 static inline u8 inb(unsigned long addr)
@@ -97,17 +97,17 @@ static inline u32 inl(unsigned long addr
 
 static inline void outb(u8 b, unsigned long addr)
 {
-	return writeb(b, (volatile void __iomem *) addr);
+	 writeb(b, (volatile void __iomem *) addr);
 }
 
 static inline void outw(u16 b, unsigned long addr)
 {
-	return writew(b, (volatile void __iomem *) addr);
+	 writew(b, (volatile void __iomem *) addr);
 }
 
 static inline void outl(u32 b, unsigned long addr)
 {
-	return writel(b, (volatile void __iomem *) addr);
+	 writel(b, (volatile void __iomem *) addr);
 }
 
 #define inb_p(addr)	inb(addr)
@@ -174,7 +174,9 @@ extern void __outsl(unsigned long addr, 
 static inline void outsl(unsigned long addr, const void *buffer, int count)
 {
 	if ((unsigned long) buffer & 0x3)
-		return __outsl(addr, buffer, count);
+		{ __outsl(addr, buffer, count);
+		return;
+	}
 
 	if (count) {
 		const u32 *buf = buffer;
diff -u -p a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
--- a/include/rdma/ib_verbs.h 2008-11-17 12:16:41.000000000 +0100
+++ b/include/rdma/ib_verbs.h 2008-11-22 14:57:28.000000000 +0100
@@ -1640,7 +1640,7 @@ static inline void ib_dma_unmap_single_a
 					     enum dma_data_direction direction,
 					     struct dma_attrs *attrs)
 {
-	return dma_unmap_single_attrs(dev->dma_device, addr, size,
+	 dma_unmap_single_attrs(dev->dma_device, addr, size,
 				      direction, attrs);
 }
 
diff -u -p a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c 2008-11-17 12:16:42.000000000 +0100
+++ b/lib/swiotlb.c 2008-11-22 14:57:13.000000000 +0100
@@ -615,7 +615,7 @@ void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
 		     int dir)
 {
-	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
+	 swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
 }
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
@@ -774,7 +774,7 @@ void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		 int dir)
 {
-	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
+	 swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
 
 /*
diff -u -p a/mm/hugetlb.c b/mm/hugetlb.c
--- a/mm/hugetlb.c 2008-11-17 12:16:42.000000000 +0100
+++ b/mm/hugetlb.c 2008-11-22 14:58:39.000000000 +0100
@@ -372,7 +372,9 @@ static void clear_huge_page(struct page 
 	int i;
 
 	if (unlikely(sz > MAX_ORDER_NR_PAGES))
-		return clear_gigantic_page(page, addr, sz);
+		{ clear_gigantic_page(page, addr, sz);
+		return;
+	}
 
 	might_sleep();
 	for (i = 0; i < sz/PAGE_SIZE; i++) {
@@ -405,7 +407,9 @@ static void copy_huge_page(struct page *
 	struct hstate *h = hstate_vma(vma);
 
 	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES))
-		return copy_gigantic_page(dst, src, addr, vma);
+		{ copy_gigantic_page(dst, src, addr, vma);
+		return;
+	}
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); i++) {
diff -u -p a/security/security.c b/security/security.c
--- a/security/security.c 2008-11-17 12:16:42.000000000 +0100
+++ b/security/security.c 2008-11-22 15:04:51.000000000 +0100
@@ -225,12 +225,12 @@ int security_bprm_check(struct linux_bin
 
 void security_bprm_committing_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_committing_creds(bprm);
+	 security_ops->bprm_committing_creds(bprm);
 }
 
 void security_bprm_committed_creds(struct linux_binprm *bprm)
 {
-	return security_ops->bprm_committed_creds(bprm);
+	 security_ops->bprm_committed_creds(bprm);
 }
 
 int security_bprm_secureexec(struct linux_binprm *bprm)
@@ -613,7 +613,7 @@ int security_prepare_creds(struct cred *
 
 void security_commit_creds(struct cred *new, const struct cred *old)
 {
-	return security_ops->cred_commit(new, old);
+	 security_ops->cred_commit(new, old);
 }
 
 int security_kernel_act_as(struct cred *new, u32 secid)
diff -u -p a/sound/sound_core.c b/sound/sound_core.c
--- a/sound/sound_core.c 2008-11-17 12:16:42.000000000 +0100
+++ b/sound/sound_core.c 2008-11-22 15:04:51.000000000 +0100
@@ -457,7 +457,7 @@ EXPORT_SYMBOL(unregister_sound_mixer);
 
 void unregister_sound_midi(int unit)
 {
-	return sound_remove_unit(&chains[2], unit);
+	 sound_remove_unit(&chains[2], unit);
 }
 
 EXPORT_SYMBOL(unregister_sound_midi);
@@ -474,7 +474,7 @@ EXPORT_SYMBOL(unregister_sound_midi);
 
 void unregister_sound_dsp(int unit)
 {
-	return sound_remove_unit(&chains[3], unit);
+	 sound_remove_unit(&chains[3], unit);
 }
 
-------------

