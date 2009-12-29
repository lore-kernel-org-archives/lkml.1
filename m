Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZL2Tvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZL2Tvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZL2Tva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:51:30 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:62046 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZL2Tv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:51:29 -0500
Date: Tue, 29 Dec 2009 14:51:11 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ACPI warning from alloc_pages_nodemask on boot (2.6.33 regression)
In-reply-to: <20091229094202.25818e9b@nehalam>
Message-id: <alpine.LFD.2.00.0912291435070.14938@localhost.localdomain>
References: <20091229094202.25818e9b@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Dec 2009, Stephen Hemminger wrote:

> Running 2.6.33-rc2 shows new warning during boot.
> This is Asus P6T board with i7 CPU (920). I have DMA
> debug and lockdep turned on in config so more checking than
> usual.
> 
> 
> [    1.548537] Total of 8 processors activated (42764.23 BogoMIPS).
> [    1.553064] regulator: core version 0.5
> [    1.553090] Time: 17:21:29  Date: 12/29/09
> [    1.553243] NET: Registered protocol family 16
> [    1.553613] ACPI: bus type pci registered
> [    1.553733] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
> [    1.553736] PCI: not using MMCONFIG
> [    1.553738] PCI: Using configuration type 1 for base access
> [    1.555326] bio: create slab <bio-0> at 0
> [    1.562336] ACPI: EC: Look up EC in DSDT
> [    1.573083] ACPI: Executed 1 blocks of module-level executable AML code

Could be an issue with the new module-level Windows compatibility feature.

> [    1.611664] ACPI Warning: Incorrect checksum in table [OEMB] - 94, should be 8C (20091214/tbutils-314)
> [    1.611698] ACPI: SSDT 00000000bf7980c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
> [    1.613966] ACPI: SSDT 00000000bf7984d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20060113)
> [    1.616242] ACPI: SSDT 00000000bf7988e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20060113)
> [    1.618526] ACPI: SSDT 00000000bf798cf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20060113)
> [    1.620817] ACPI: SSDT 00000000bf799100 00403 (v01 DpgPmm  P005Ist 00000012 INTL 20060113)
> [    1.623112] ACPI: SSDT 00000000bf799510 00403 (v01 DpgPmm  P006Ist 00000012 INTL 20060113)
> [    1.625409] ACPI: SSDT 00000000bf799920 00403 (v01 DpgPmm  P007Ist 00000012 INTL 20060113)
> [    1.627734] ACPI: SSDT 00000000bf799d30 00403 (v01 DpgPmm  P008Ist 00000012 INTL 20060113)
> [    1.630020] ------------[ cut here ]------------
> [    1.630026] WARNING: at mm/page_alloc.c:1812 __alloc_pages_nodemask+0x617/0x730()

        if (order >= MAX_ORDER) {
                WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
                return NULL;
        }

I don't know what the mm alloc code is complaining about here.

> [    1.630028] Hardware name: System Product Name
> [    1.630029] Modules linked in:
> [    1.630032] Pid: 1, comm: swapper Not tainted 2.6.33-rc2 #4
> [    1.630034] Call Trace:
> [    1.630038]  [<ffffffff810532a8>] warn_slowpath_common+0x78/0xb0
> [    1.630041]  [<ffffffff810532ef>] warn_slowpath_null+0xf/0x20
> [    1.630044]  [<ffffffff810e65a7>] __alloc_pages_nodemask+0x617/0x730
> [    1.630048]  [<ffffffff81114d14>] alloc_page_interleave+0x34/0x90
> [    1.630050]  [<ffffffff81115444>] alloc_pages_current+0xc4/0xd0
> [    1.630053]  [<ffffffff810e5549>] __get_free_pages+0x9/0x50
> [    1.630055]  [<ffffffff8111ef3b>] __kmalloc+0x1bb/0x1f0
> [    1.630059]  [<ffffffff81089bdd>] ? trace_hardirqs_on+0xd/0x10
> [    1.630064]  [<ffffffff812cae3e>] acpi_os_allocate+0x25/0x27
> [    1.630067]  [<ffffffff812cafab>] acpi_ex_load_op+0xd8/0x260
> [    1.630070]  [<ffffffff812cd89e>] acpi_ex_opcode_1A_1T_0R+0x25/0x4b
> [    1.630073]  [<ffffffff812c5008>] acpi_ds_exec_end_op+0xea/0x3d6
> [    1.630076]  [<ffffffff812d7532>] acpi_ps_parse_loop+0x7d9/0x95f
> [    1.630079]  [<ffffffff812c58cf>] ? acpi_ds_call_control_method+0x166/0x1d7
> [    1.630082]  [<ffffffff812d6641>] acpi_ps_parse_aml+0x9a/0x2b9
> [    1.630085]  [<ffffffff812d7d3a>] acpi_ps_execute_method+0x1c8/0x29a
> [    1.630088]  [<ffffffff812d2f4d>] acpi_ns_evaluate+0xe1/0x1a8
> [    1.630090]  [<ffffffff812d29a1>] acpi_evaluate_object+0xf9/0x1f2
> [    1.630094]  [<ffffffff812bda07>] acpi_processor_set_pdc+0x1be/0x1e8
> [    1.630097]  [<ffffffff812bda3a>] early_init_pdc+0x9/0xf
> [    1.630100]  [<ffffffff812d4a96>] acpi_ns_walk_namespace+0xb9/0x187
> [    1.630102]  [<ffffffff812bda31>] ? early_init_pdc+0x0/0xf
> [    1.630105]  [<ffffffff812bda31>] ? early_init_pdc+0x0/0xf
> [    1.630108]  [<ffffffff812d27e0>] acpi_walk_namespace+0x85/0xbf
> [    1.630111]  [<ffffffff81cc7da9>] ? acpi_init+0x0/0x12f
> [    1.630113]  [<ffffffff81cc7da9>] ? acpi_init+0x0/0x12f
> [    1.630116]  [<ffffffff812bd7c6>] acpi_early_processor_set_pdc+0x3a/0x3c
> [    1.630119]  [<ffffffff81cc7c80>] acpi_bus_init+0xb5/0x1de
> [    1.630123]  [<ffffffff8128239e>] ? kobject_create_and_add+0x3e/0x80
> [    1.630126]  [<ffffffff81cc2f0c>] ? genhd_device_init+0x0/0x7b
> [    1.630128]  [<ffffffff81cc7da9>] ? acpi_init+0x0/0x12f
> [    1.630131]  [<ffffffff81cc7e1a>] acpi_init+0x71/0x12f
> [    1.630134]  [<ffffffff81002047>] do_one_initcall+0x37/0x1a0
> [    1.630137]  [<ffffffff81ca1731>] kernel_init+0x166/0x1bc
> [    1.630140]  [<ffffffff8100a3e4>] kernel_thread_helper+0x4/0x10
> [    1.630144]  [<ffffffff814f95d0>] ? restore_args+0x0/0x30
> [    1.630147]  [<ffffffff81ca15cb>] ? kernel_init+0x0/0x1bc
> [    1.630149]  [<ffffffff8100a3e0>] ? kernel_thread_helper+0x0/0x10
> [    1.630156] ---[ end trace f17e946d22a56015 ]---
> [    1.630159] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P009._OSC] (Node ffff8801b9069c20), AE_NO_MEMORY
> [    1.630196] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.P009._PDC] (Node ffff8801b9069c00), AE_NO_MEMORY

We've changed both the _OSC and _PDC code in this release.
In particular, _PDC is being evaluated earler than last release
in an attempt to be more Windows compatible...

Stephen,
Please attach the output from acpidump to a new bugzilla entry
and point this thread to it.

thanks,
Len Brown, Intel Open Source Technology Center



