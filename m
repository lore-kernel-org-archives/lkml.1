Return-Path: <linux-kernel-owner+w=401wt.eu-S1760562AbXGCX0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562AbXGCX0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXGCXZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:25:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387AbXGCXZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:25:57 -0400
Date: Tue, 3 Jul 2007 16:25:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [PATCH 2.6.21 1/3] x86_64 EFI64 support Try #2
Message-Id: <20070703162545.1f626fa1.akpm@linux-foundation.org>
In-Reply-To: <20070702170707.688670000@em64tdvp.jf.intel.com>
References: <20070702170614.769378000@em64tdvp.jf.intel.com>
	<20070702170707.688670000@em64tdvp.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2007 10:06:15 -0700
Chandramouli Narayanan <mouli@linux.intel.com> wrote:
>

You just sent three patches, all with the same name.  Please take care to
choose different and good Subject:s for each patch. 
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt covers this a bit.

> EFI x86_64 support Patch 1 of 3 (try #2)
> ----------------------------------------
> - Being experimental, dropped default option for CONFIG_EFI.
> 
> - Implemented EFI to E820 memory map conversion. This is based on
>   bootloader support. The ELILO bootloader x86_64 support has been
>   updated to pass E820 map to kernel. This simplified kernel efi code.
>   Also the duplicate code for setting up page table for
>   EFI run time is gotten rid of with simpler patch.
> 
>   ------------------------------------------------------------------
>   NOTE: The ELILO patch to perform EFI to E820 map conversion is being
>   submitted to sourceforge project maintainer. 
>   ------------------------------------------------------------------
> 
> - UEFI wrapper code in earlier patch is now replaced with code adapted from
>   NDIS wrapper sourceforge project.
> 
> - Parameters in EFI calls are cast to (u64) to rid build warnings.
> 
> - Code that is supposed to be __init only in arch/x86_64/kernel/efi.c 
>   is prefixed as such.
> 
> - Documentation/x86_64/uefi.txt adds instructions on how to set up EFI64
>   system.
> 
> - Documentation/i386/zero-page.txt notes differences in the boot parameters
>   for x86_64. The efi init code uses these parameters passed by the bootloader.
> 
> - Added missing KERN_ prefixes in EFI code. probe_kernel_address() used for
>   checking firmware vendor in efi init code.
> 
> - The dependency on X86_64 in the configuration of EFI_RTC is dropped
>   since we have hardware realtime clock support
> 
> Issues _not_ addressed (per feedback from Eric Biederman)
> 
> - Virtual mode support is still retained in this patch. On looking at the 
>   configuration options, the EFI variable support is required at runtime.
>   For instance, the firmware driver configuration support with EFI variable
>   via sysfs would require this. I'm not sure if virtual mode support
>   can be killed altogether. More investigation needed here.
> 
> - The variable efi_enabled is used throughout across architecutres if
>   CONFIG_EFI option is enabled. The i386 code also uses this variable.
>   This is something that can be revisited with code consolidation across
>   architectures.
> 
> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>

All the above text tells us the differences between.  v2 and v3.  It all
will be of minimal interest for the final got commit and hence it will be
removed (by me, typically).

That will leave us with no cvhangelog for this patch.

Please provide a changelog with this patch.  The above-linked-to document
has some guidelines.



Please feed these patches through the latest version of
scripts/checkpatch.pl and consider addressing the resulting warnings.  Many
are generated.


> + *  Copyright (C) 2006 Giridhar Pemmasani
> + *  Copyright (C) 2007-2010 Intel Corp
> + *  	Contributed by Chandramouli Narayanan<mouli@linux.intel.com>
> + *	Adapted NDIS wrapper macros from http://ndiswrapper.sourceforge.net
> + *	for EFI x86_64 linux support
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + *  GNU General Public License for more details.
> + *
> + */
> +extern efi_status_t LIN2WIN0(void *fp);
> +extern efi_status_t LIN2WIN1(void *fp, u64 arg1);
> +extern efi_status_t LIN2WIN2(void *fp, u64 arg1, u64 arg2);
> +extern efi_status_t LIN2WIN3(void *fp, u64 arg1, u64 arg2, u64 arg3);
> +extern efi_status_t LIN2WIN4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
> +extern efi_status_t LIN2WIN5(
> +	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5);
> +extern efi_status_t LIN2WIN6(
> +	void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4, u64 arg5, u64 arg6);

Why are these all-upper-case?  That convention is conventionally used for
macros.

> --- linux-2.6.21-orig/arch/x86_64/kernel/efi.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi.c	2007-06-26 14:39:27.000000000 -0700
> @@ -0,0 +1,531 @@
> +/*
> + * Extensible Firmware Interface
> + *
> + * Based on Extensible Firmware Interface Specification version 1.0
> + *
> + * Copyright (C) 1999 VA Linux Systems
> + * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
> + * Copyright (C) 1999-2002 Hewlett-Packard Co.
> + *	David Mosberger-Tang <davidm@hpl.hp.com>
> + *	Stephane Eranian <eranian@hpl.hp.com>
> + * Copyright (C) 2005-2008 Intel Co.
> + *	Fenghua Yu <fenghua.yu@intel.com>
> + *	Bibo Mao <bibo.mao@intel.com>
> + *	Chandramouli Narayanan <mouli@linux.intel.com>
> + *
> + * Code to convert EFI to E820 map has been implemented in elilo bootloader
> + * based on a EFI patch by Edgar Hucek. Based on the E820 map, the page table
> + * is setup appropriately for EFI runtime code. NDIS wrapper code from
> + * sourceforge project is adapted here for UEFI wrapper call.
> + * - mouli 06/14/2007.
> + * 
> + * All EFI Runtime Services are not implemented yet as EFI only
> + * supports physical mode addressing on SoftSDV. This is to be fixed
> + * in a future version.  --drummond 1999-07-20
> + *
> + * Implemented EFI runtime services and virtual mode calls.  --davidm
> + *
> + * Goutham Rao: <goutham.rao@intel.com>
> + *	Skip non-WB memory and ignore empty memory ranges.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/types.h>
> +#include <linux/time.h>
> +#include <linux/spinlock.h>
> +#include <linux/bootmem.h>
> +#include <linux/ioport.h>
> +#include <linux/module.h>
> +#include <linux/efi.h>
> +#include <linux/uaccess.h>
> +
> +#include <asm/setup.h>
> +#include <asm/bootsetup.h>
> +#include <asm/io.h>
> +#include <asm/page.h>
> +#include <asm/e820.h>
> +#include <asm/pgtable.h>
> +#include <asm/tlbflush.h>
> +#include <asm/cacheflush.h>
> +#include <asm/proto.h>
> +#include <asm-x86_64/eficallwrap.h>
> +
> +#define EFI_DEBUG	0
> +#define PFX 		"EFI: "
> +
> +struct efi efi;
> +EXPORT_SYMBOL(efi);

Why is this exported?

> +extern void (*machine_emergency_restart_func)(void);

Never put extern declarations in C files.  Find a suitable header and
ensure that the header is included by all code which uses the symbol, as
well as the code which defines it.

> +struct efi efi_phys __initdata;
> +struct efi_memory_map memmap;
> +static efi_system_table_t efi_systab __initdata;
> +
> +static unsigned long efi_rt_eflags;
> +/* efi_rt_lock protects efi physical mode call */
> +static spinlock_t efi_rt_lock = SPIN_LOCK_UNLOCKED;
> +static pgd_t save_pgd;
>
> ...
>
> +static void __init efi_call_phys_prelog(void) __acquires(efi_rt_lock)
> +{
> +	unsigned long vaddress;
> +
> +	spin_lock(&efi_rt_lock);
> +	local_irq_save(efi_rt_eflags);

I suspect the above two statements are in the wrong order.

> +	vaddress = (unsigned long)__va(0x0UL);	
> +	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
> +	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
> +	
> +	global_flush_tlb();
> +}
> +
> +static void __init efi_call_phys_epilog(void) __releases(efi_rt_lock)
> +{
> +	/*
> +	 * After the lock is released, the original page table is restored.
> +	 */
> +	set_pgd(pgd_offset_k(0x0UL), save_pgd);
> +	global_flush_tlb();
> +	local_irq_restore(efi_rt_eflags);
> +	spin_unlock(&efi_rt_lock);

Ditto.

> +}
> +
> +static efi_status_t __init phys_efi_set_virtual_address_map(
> +			unsigned long memory_map_size, 
> +			unsigned long descriptor_size,
> +			u32 descriptor_version, efi_memory_desc_t *virtual_map)
> +{
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = LIN2WIN4(efi_phys.set_virtual_address_map,
> +					(u64)memory_map_size,
> +					(u64)descriptor_size,
> +					(u64)descriptor_version, 
> +					(u64)virtual_map);
> +	efi_call_phys_epilog();
> +	return status;
> +}
> +
> +static efi_status_t __init phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
> +{
> +
> +	efi_status_t status;
> +
> +	efi_call_phys_prelog();
> +	status = LIN2WIN2(efi_phys.get_time,
> +					(u64)tm,
> +					(u64)tc);
> +	efi_call_phys_epilog();
> +	return status;
> +}
> +
> +inline int efi_set_rtc_mmss(unsigned long nowtime)

Remove `inline'.

> +{
> +	int real_seconds, real_minutes;
> +	efi_status_t 	status;
> +	efi_time_t 	eft;
> +	efi_time_cap_t 	cap;
> +
> +	spin_lock(&efi_rt_lock);
> +	status = efi.get_time(&eft, &cap);
> +	spin_unlock(&efi_rt_lock);

It is very unusual for any time-related low-level lock to be taken in a
non-irq-safe fashion.  Is this code correct?

> +	if (status != EFI_SUCCESS) {
> +		printk(KERN_ERR PFX "Oops: efitime: can't read time!\n");
> +		return -1;
> +	}
> +
> +	real_seconds = nowtime % 60;
> +	real_minutes = nowtime / 60;
> +	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
> +		real_minutes += 30;
> +	real_minutes %= 60;
> +	eft.minute = real_minutes;
> +	eft.second = real_seconds;
> +
> +	spin_lock(&efi_rt_lock);
> +	status = efi.set_time(&eft);
> +	spin_unlock(&efi_rt_lock);
> +	if (status != EFI_SUCCESS) {
> +		printk(KERN_ERR PFX "Oops: efitime: can't write time!\n");
> +		return -1;
> +	}
> +	return 0;
> +}
> +/*

Missing newline.

> + * This is used during kernel init before runtime
> + * services have been remapped and also during suspend, therefore,
> + * we'll need to call both in physical and virtual modes.
> + */
> +inline unsigned long efi_get_time(void)

Remove inline

> +{
> +	efi_status_t status;
> +	efi_time_t eft;
> +	efi_time_cap_t cap;
> +
> +	if (efi.get_time) {
> +		/* if we are in virtual mode use remapped function */
> + 		status = efi.get_time(&eft, &cap);
> +	} else {
> +		/* we are in physical mode */
> +		status = phys_efi_get_time(&eft, &cap);
> +	}
> +	if (status != EFI_SUCCESS)
> +		printk(KERN_ERR PFX "Oops: efitime: can't read time status: 0x%lx\n",status);

Missing space, line too long (checkpatch will point these out)

> +
> +	return mktime(eft.year, eft.month, eft.day, eft.hour,
> +			eft.minute, eft.second);
> +}
> +
> +/*
> + * We need to map the EFI memory map again after paging_init().
> + */
> +void __init efi_map_memmap(void)
> +{
> +	int i;
> +
> +	memmap.map = __va((unsigned long)memmap.phys_map);
> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> +
> +	/* Make EFI runtime code area executable */
> +	for (i = 0; i < e820.nr_map; i++) {
> +		switch (e820.map[i].type) {
> +		case E820_RUNTIME_CODE:
> +			init_memory_mapping(
> +				e820.map[i].addr,
> +				e820.map[i].addr + e820.map[i].size);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +}
> +
> +/* Override function for emergency restart on EFI enabled systems */
> +static void efi_emergency_restart(void)
> +{
> +	/* If EFI enabled, reset system through EFI protocol. */
> +	efi.reset_system(EFI_RESET_WARM, EFI_SUCCESS, 0, NULL);
> +	return;
> +}
> +
> +void __init efi_init(void)
> +{
> +	efi_config_table_t *config_tables;
> +	efi_runtime_services_t *runtime;
> +	efi_char16_t *c16;
> +	char vendor[100] = "unknown";
> +	int i = 0;
> +
> +	memset(&efi, 0, sizeof(efi) );

Rendom extra space

> +	memset(&efi_phys, 0, sizeof(efi_phys));
> +
> +	efi_phys.systab = (efi_system_table_t *)EFI_SYSTAB;
> +	memmap.phys_map = (void*)EFI_MEMMAP;
> +	memmap.nr_map = EFI_MEMMAP_SIZE/EFI_MEMDESC_SIZE;
> +	memmap.desc_version = EFI_MEMDESC_VERSION;
> +	memmap.desc_size = EFI_MEMDESC_SIZE;
> +
> +	efi.systab = (efi_system_table_t *) early_ioremap(
> +						(unsigned long)efi_phys.systab,
> +						sizeof(efi_system_table_t));

early_ioremap() returns void*: unneeded cast.

> +	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
> +	efi.systab = &efi_systab;
> +	/*
> +	 * Verify the EFI Table
> +	 */
> +	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
> +		printk(KERN_ERR PFX "Woah! EFI system table signature incorrect\n");
> +	if ((efi.systab->hdr.revision ^ EFI_SYSTEM_TABLE_REVISION) >> 16 != 0)
> +		printk(KERN_ERR PFX
> +		       "Warning: EFI system table major version mismatch: "
> +		       "got %d.%02d, expected %d.%02d\n",
> +		       efi.systab->hdr.revision >> 16,
> +		       efi.systab->hdr.revision & 0xffff,
> +		       EFI_SYSTEM_TABLE_REVISION >> 16,
> +		       EFI_SYSTEM_TABLE_REVISION & 0xffff);
> +	/*
> +	 * Grab some details from the system table
> +	 */
> +	config_tables = (efi_config_table_t *)efi.systab->tables;
> +	runtime = efi.systab->runtime;
> +
> +	/*
> +	 * Show what we know for posterity
> +	 */
> +	c16 = (efi_char16_t *) early_ioremap(efi.systab->fw_vendor, 2);

Ditto

> +	if (!probe_kernel_address(c16, i)) {
> +		for (i = 0; i < sizeof(vendor) && *c16; ++i) 
> +			vendor[i] = *c16++;
> +		vendor[i] = '\0';
> +	}
> +
> +	printk(KERN_INFO PFX "EFI v%u.%.02u by %s \n",
> +	       efi.systab->hdr.revision >> 16,
> +	       efi.systab->hdr.revision & 0xffff, vendor);
> +
> +	/*
> +	 * Let's see what config tables the firmware passed to us.
> +	 */
> +	config_tables = (efi_config_table_t *)early_ioremap( efi.systab->tables,
> +			        efi.systab->nr_tables * sizeof(efi_config_table_t));
> +	if (config_tables == NULL)
> +		printk(KERN_ERR PFX "Could not map EFI Configuration Table!\n");
> +
> +	for (i = 0; i < efi.systab->nr_tables; i++) {
> +		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
> +			efi.mps = config_tables[i].table;
> +			printk(KERN_INFO " MPS=0x%lx ", config_tables[i].table);
> +		} else
> +		    if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
> +			efi.acpi20 = config_tables[i].table;
> +			printk(KERN_INFO " ACPI 2.0=0x%lx ", config_tables[i].table);
> +		} else
> +		    if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
> +			efi.acpi = config_tables[i].table;
> +			printk(KERN_INFO " ACPI=0x%lx ", config_tables[i].table);
> +		} else
> +		    if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
> +			efi.smbios = config_tables[i].table;
> +			printk(KERN_INFO " SMBIOS=0x%lx ", config_tables[i].table);
> +		} else
> +		    if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
> +			efi.hcdp = config_tables[i].table;
> +			printk(KERN_INFO " HCDP=0x%lx ", config_tables[i].table);
> +		} else
> +		    if (efi_guidcmp(config_tables[i].guid, UGA_IO_PROTOCOL_GUID) == 0) {
> +			efi.uga = config_tables[i].table;
> +			printk(KERN_INFO " UGA=0x%lx ", config_tables[i].table);
> +		}
> +	}
> +	printk(KERN_INFO "\n");

The KERN_* is only meaningful at the start of the output line, and this one
is being emitted at the end of the input line.  Usually..

> +	/*
> +	 * Check out the runtime services table. We need to map
> +	 * the runtime services table so that we can grab the physical
> +	 * address of several of the EFI runtime functions, needed to
> +	 * set the firmware into virtual mode.
> +	 */
> +	runtime = (efi_runtime_services_t *) early_ioremap((unsigned long)
> +						efi.systab->runtime,
> +				      		sizeof(efi_runtime_services_t));

Unneeded cast (please check all patches)

> +	if (runtime != NULL) {
> +		/*
> +	 	 * We will only need *early* access to the following
> +		 * two EFI runtime services before set_virtual_address_map
> +		 * is invoked.
> + 	 	 */
> +		efi_phys.get_time = (efi_get_time_t *) runtime->get_time;
> +		efi_phys.set_virtual_address_map =
> +			(efi_set_virtual_address_map_t *)runtime->set_virtual_address_map;
> +	} else
> +		printk(KERN_ERR PFX "Could not map the runtime service table!\n");
> +	/* Map the EFI memory map for use until paging_init() */
> +	memmap.map = (efi_memory_desc_t *) early_ioremap(
> +					(unsigned long) EFI_MEMMAP,
> +					 EFI_MEMMAP_SIZE);
> +	if (memmap.map == NULL)
> +		printk(KERN_ERR PFX "Could not map the EFI memory map!\n");
> +        if (EFI_MEMDESC_SIZE != sizeof(efi_memory_desc_t)) {
> +                printk(KERN_WARNING PFX "Kernel-defined memdesc" 
> +			"doesn't match the one from EFI!\n");
> +        }
> +	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
> +	/* Override the emergency restart function */
> +	machine_emergency_restart_func = efi_emergency_restart;
> +}
> +
> +/*
> + * This function will switch the EFI runtime services to virtual mode.
> + * Essentially, look through the EFI memmap and map every region that
> + * has the runtime attribute bit set in its memory descriptor and update
> + * that memory descriptor with the virtual address obtained from ioremap().
> + * This enables the runtime services to be called without having to
> + * thunk back into physical mode for every invocation.
> + */
> +void __init efi_enter_virtual_mode(void)
> +{
> +	efi_memory_desc_t *md;
> +	efi_status_t status;
> +	unsigned long end;
> +	void *p;
> +
> +	efi.systab = NULL;
> +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +		md = p;
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +			continue;
> +		if (md->attribute & EFI_MEMORY_WB)
> +			md->virt_addr = (unsigned long)__va(md->phys_addr);
> +		else if (md->attribute & (EFI_MEMORY_UC | EFI_MEMORY_WC))
> +			md->virt_addr = (unsigned long)ioremap(md->phys_addr,
> +					 md->num_pages << EFI_PAGE_SHIFT);
> +		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
> +		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
> +				((unsigned long)efi_phys.systab < end))
> +			efi.systab = (efi_system_table_t *) 
> +					(md->virt_addr - md->phys_addr +
> +					(unsigned long)efi_phys.systab);
> +	}
> +
> +	if (!efi.systab)
> +		BUG();

BUG_ON()

> +	status = phys_efi_set_virtual_address_map(
> +			memmap.desc_size * memmap.nr_map,
> +			memmap.desc_size,
> +			memmap.desc_version,
> +		       	memmap.phys_map);
> +
> +	if (status != EFI_SUCCESS) {
> +		printk (KERN_ALERT "You are screwed! "
> +			"Unable to switch EFI into virtual mode "
> +			"(status=%lx)\n", status);
> +		panic("EFI call to SetVirtualAddressMap() failed!");
> +	}
> +	/*
> +	 * Now that EFI is in virtual mode, update the function
> +	 * pointers in the runtime service table to the new virtual addresses.
> +	 *
> +	 * Call EFI services through wrapper functions.
> +	 */
> +
> +	efi.get_time = (efi_get_time_t *)_efi_get_time;
> +	efi.set_time = (efi_set_time_t *)_efi_set_time;
> +	efi.get_wakeup_time = (efi_get_wakeup_time_t *)_efi_get_wakeup_time;
> +	efi.set_wakeup_time = (efi_set_wakeup_time_t *)_efi_set_wakeup_time;
> +	efi.get_variable = (efi_get_variable_t *)_efi_get_variable;
> +	efi.get_next_variable = (efi_get_next_variable_t *)_efi_get_next_variable;
> +	efi.set_variable = (efi_set_variable_t *)_efi_set_variable;
> +	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
> +					_efi_get_next_high_mono_count;
> +	efi.reset_system = (efi_reset_system_t *)_efi_reset_system;
> +	efi.set_virtual_address_map = (efi_set_virtual_address_map_t *)
> +					_efi_set_virtual_address_map;
> +}
> +
> --- linux-2.6.21-orig/arch/x86_64/kernel/efi_callwrap.c	1969-12-31 16:00:00.000000000 -0800
> +++ linux-2.6.21-uefi-finaltest4/arch/x86_64/kernel/efi_callwrap.c	2007-06-25 14:36:32.000000000 -0700
> @@ -0,0 +1,202 @@
> +/*
> + *  Copyright (C) 2006 Giridhar Pemmasani
> + *  Copyright (C) 2007-2010 Intel Corp
> + *  	Contributed by Chandramouli Narayanan<mouli@linux.intel.com>
> + *	Adapted NDIS wrapper macros from http://ndiswrapper.sourceforge.net
> + *	for EFI x86_64 linux support
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + *  GNU General Public License for more details.
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/mm.h>
> +#include <linux/types.h>
> +#include <linux/time.h>
> +#include <linux/spinlock.h>
> +#include <linux/bootmem.h>
> +#include <linux/ioport.h>
> +#include <linux/module.h>
> +#include <linux/efi.h>
> +
> +#define alloc_win_stack_frame(argc)		\
> +	"subq $" #argc "*8, %%rsp\n\t"
> +#define free_win_stack_frame(argc)		\
> +	"addq $" #argc "*8, %%rsp\n\t"
> +
> +/* m is index of Windows arg required, n is total number of args to
> + * function Windows arg 1 should be at 0(%rsp), arg 2 at 8(%rsp) and
> + * so on, after stack frame is allocated, which starts at -n*8(%rsp)
> + * when stack frame is allocated. 4 > m >= n.
> +*/
> +
> +#define lin2win_win_arg(m,n) "(" #m "-1-" #n ")*8(%%rsp)"
> +
> +/* volatile args for Windows function must be in clobber / output list */
> +
> +efi_status_t LIN2WIN0(void *func)
> +{									
> +	u64 ret, dummy;
> +	register u64 r8 __asm__("r8");
> +	register u64 r9 __asm__("r9");
> +	register u64 r10 __asm__("r10");
> +	register u64 r11 __asm__("r11");
> +	__asm__ __volatile__(					
> +		alloc_win_stack_frame(4)				
> +		"call *%[fptr]\n\t"					
> +		free_win_stack_frame(4)					
> +		: "=a" (ret), "=c" (dummy), "=d" (dummy),		
> +		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)		
> +		: [fptr] "r" (func));					
> +	return ret;								
> +}
> +
> +efi_status_t LIN2WIN1(void *func, u64 arg1)
> +{
> +	u64 ret, dummy;
> +	register u64 r8 __asm__("r8");
> +	register u64 r9 __asm__("r9");
> +	register u64 r10 __asm__("r10");
> +	register u64 r11 __asm__("r11");
> +	__asm__ __volatile__(
> +		alloc_win_stack_frame(4)
> +		"call *%[fptr]\n\t"
> +		free_win_stack_frame(4)	
> +		: "=a" (ret), "=c" (dummy), "=d" (dummy),
> +		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
> +		: "c" (arg1),
> +		  [fptr] "r" (func));
> +	return ret;
> +}
> +
> +efi_status_t LIN2WIN2(void *func, u64 arg1, u64 arg2)
> +{
> +	u64 ret, dummy;
> +	register u64 r8 __asm__("r8");
> +	register u64 r9 __asm__("r9");
> +	register u64 r10 __asm__("r10");
> +	register u64 r11 __asm__("r11");
> +	__asm__ __volatile__(
> +		alloc_win_stack_frame(4)
> +		"call *%[fptr]\n\t"
> +		free_win_stack_frame(4)
> +		: "=a" (ret), "=c" (dummy), "=d" (dummy),
> +		  "=r" (r8), "=r" (r9), "=r" (r10), "=r" (r11)
> +		: "c" (arg1), "d" (arg2),
> +		  [fptr] "r" (func));
> +	return ret;
> +}

Maybe all these should have been coded in assembler.

> +EXPORT_SYMBOL_GPL(LIN2WIN0);
> +EXPORT_SYMBOL_GPL(LIN2WIN1);
> +EXPORT_SYMBOL_GPL(LIN2WIN2);
> +EXPORT_SYMBOL_GPL(LIN2WIN3);
> +EXPORT_SYMBOL_GPL(LIN2WIN4);
> +EXPORT_SYMBOL_GPL(LIN2WIN5);
> +EXPORT_SYMBOL_GPL(LIN2WIN6);

efi was exported non-gpl, these are exported gpl.  How come?

Are these exports needed?  For what?


