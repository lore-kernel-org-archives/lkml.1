Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYIFGuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYIFGuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 02:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYIFGug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 02:50:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYIFGuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 02:50:35 -0400
Date: Fri, 5 Sep 2008 23:50:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi +
 vmap_pte_range)
Message-Id: <20080905235014.fc31b2b0.akpm@linux-foundation.org>
In-Reply-To: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008 08:45:58 +0200 Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> Hi,
> 
> There is a dmesg dump  below from my Compaq AP550 workstation.
> It has 3 WARN_ON() dumps: 1 from acpi layer and 2 from vmap_pte_range()
> There is no such thing in 2.6.27-rc4 which I use daily so I assume
> it is something in the -mm tree.
> 

yup thanks.  The acpi guys and Rusty are still scratching each others
heads over the acpi procfs one.

> Intel 82802 RNG detected
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel i840 Chipset
> ------------[ cut here ]------------
> WARNING: at mm/vmalloc.c:105 vmap_pte_range+0xcb/0x100()
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-mm1 #1
>  [<c012526f>] warn_on_slowpath+0x5f/0x90
>  [<c0217a5e>] fbcon_clear+0x13e/0x1a0
>  [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
>  [<c01460cc>] generic_exec_single+0x9c/0xa0
>  [<c0109776>] read_tsc+0x6/0x30
>  [<c013e4f8>] getnstimeofday+0x38/0x150
>  [<c015496c>] buffered_rmqueue+0x12c/0x210
>  [<c011b53c>] update_curr+0x4c/0x70
>  [<c016768b>] vmap_pte_range+0xcb/0x100
>  [<c01676ed>] vmap_pmd_range+0x2d/0x40
>  [<c016772d>] vmap_pud_range+0x2d/0x40
>  [<c01677a6>] vmap_page_range+0x66/0x90
>  [<c016844f>] map_vm_area+0x2f/0x50
>  [<c0168996>] __vmalloc_area_node+0xb6/0x110
>  [<c0168a95>] __vmalloc_node+0x85/0xb0
>  [<c02603a2>] agp_backend_initialize+0x82/0x230
>  [<c0168b01>] vmalloc+0x21/0x30
>  [<c02603a2>] agp_backend_initialize+0x82/0x230
>  [<c02603a2>] agp_backend_initialize+0x82/0x230
>  [<c027f790>] __driver_attach+0x0/0xc0
>  [<c02606b5>] agp_add_bridge+0x55/0x1a0
>  [<c020955a>] pci_call_probe+0xa/0x10
>  [<c02095ae>] __pci_device_probe+0x4e/0x60
>  [<c02095e6>] pci_device_probe+0x26/0x60
>  [<c027f5cb>] really_probe+0x9b/0x130
>  [<c02094b0>] pci_match_device+0x10/0xb0
>  [<c027f6af>] driver_probe_device+0x3f/0x60
>  [<c027f819>] __driver_attach+0x89/0xc0
>  [<c027e519>] bus_for_each_dev+0x39/0x60
>  [<c027f866>] driver_attach+0x16/0x20
>  [<c027f790>] __driver_attach+0x0/0xc0
>  [<c027ed29>] bus_add_driver+0x109/0x1a0
>  [<c01f85ed>] kset_find_obj+0x2d/0x60
>  [<c0209660>] pci_device_shutdown+0x0/0x20
>  [<c0209660>] pci_device_shutdown+0x0/0x20
>  [<c027fcff>] driver_register+0x3f/0xd0
>  [<c0125b17>] printk+0x17/0x20
>  [<c0482250>] agp_intel_init+0x0/0x20
>  [<c02096c7>] __pci_register_driver+0x47/0x80
>  [<c0482250>] agp_intel_init+0x0/0x20
>  [<c0101032>] _stext+0x32/0x180
>  [<c0111da1>] xapic_wait_icr_idle+0x11/0x20
>  [<c011aeb4>] resched_task+0x54/0x60
>  [<c011e76e>] try_to_wake_up+0x12e/0x140
>  [<c0135211>] __create_workqueue_key+0x131/0x150
>  [<c046a8d3>] do_initcalls+0x53/0xd0
>  [<c046a9a0>] kernel_init+0x0/0xb0
>  [<c046a9f5>] kernel_init+0x55/0xb0
>  [<c0103f3b>] kernel_thread_helper+0x7/0x1c
>  =======================
> ---[ end trace 4eaa2a86a8e2da22 ]---
> agpgart-intel 0000:00:00.0: can't allocate memory for key lists
> agpgart-intel 0000:00:00.0: agp_backend_initialize() failed
> agpgart-intel: probe of 0000:00:00.0 failed with error -12

This one I reported to Nick and Dave yesterday - no response as yet.

> ------------[ cut here ]------------
> WARNING: at mm/vmalloc.c:105 vmap_pte_range+0xcb/0x100()
> Modules linked in:
> Pid: 776, comm: modprobe Tainted: G        W 2.6.27-rc5-mm1 #1
>  [<c012526f>] warn_on_slowpath+0x5f/0x90
>  [<c01617e9>] handle_mm_fault+0x1d9/0x210
>  [<c01bd0a0>] ext3_get_block+0x0/0x100
>  [<c011759b>] do_page_fault+0x12b/0x4f0
>  [<c0105dde>] do_IRQ+0x7e/0xd0
>  [<c0154ce4>] __alloc_pages_internal+0x94/0x410
>  [<c0117470>] do_page_fault+0x0/0x4f0
>  [<c038506a>] error_code+0x72/0x78
>  [<c015496c>] buffered_rmqueue+0x12c/0x210
>  [<c014fbab>] find_get_page+0x2b/0xa0
>  [<c016768b>] vmap_pte_range+0xcb/0x100
>  [<c01676ed>] vmap_pmd_range+0x2d/0x40
>  [<c016772d>] vmap_pud_range+0x2d/0x40
>  [<c01677a6>] vmap_page_range+0x66/0x90
>  [<c016844f>] map_vm_area+0x2f/0x50
>  [<c0168996>] __vmalloc_area_node+0xb6/0x110
>  [<c0168a95>] __vmalloc_node+0x85/0xb0
>  [<c0148eb9>] load_module+0x89/0xd90
>  [<c0168b01>] vmalloc+0x21/0x30
>  [<c0148eb9>] load_module+0x89/0xd90
>  [<c0148eb9>] load_module+0x89/0xd90
>  [<c01380e0>] autoremove_wake_function+0x0/0x50
>  [<c0177db0>] vfs_read+0x90/0x150
>  [<c0149c44>] sys_init_module+0x44/0x1a0
>  [<c0178111>] sys_read+0x41/0x70
>  [<c01031fa>] syscall_call+0x7/0xb
>  =======================
> ---[ end trace 4eaa2a86a8e2da22 ]---
> Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
> Intel ICH 0000:00:1f.5: setting latency timer to 64

That's coming out of the module loader and is a new one.  It's the same
warning as the agp one:


: static int vmap_pte_range(pmd_t *pmd, unsigned long addr,
: 		unsigned long end, pgprot_t prot, struct page **pages, int *nr)
: {
: 	pte_t *pte;
: 
: 	/*
: 	 * nr is a running index into the array which helps higher level
: 	 * callers keep track of where we're up to.
: 	 */
: 
: 	pte = pte_alloc_kernel(pmd, addr);
: 	if (!pte)
: 		return -ENOMEM;
: 	do {
: 		struct page *page = pages[*nr];
: 
: -->>		if (WARN_ON(!pte_none(*pte)))
: 			return -EBUSY;
: 		if (WARN_ON(!page))
: 			return -ENOMEM;
: 		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
: 		(*nr)++;
: 	} while (pte++, addr += PAGE_SIZE, addr != end);
: 	return 0;
: }
: 

I'm suspecting an overactive assertion in the new vmap code?
