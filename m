Return-Path: <linux-kernel-owner+w=401wt.eu-S933087AbZADABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087AbZADABR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932694AbZADAAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:00:52 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:59199 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760245AbZADAAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:00:50 -0500
Message-ID: <495FFC30.3000302@ribosome.natur.cuni.cz>
Date: Sun, 04 Jan 2009 01:00:48 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081227 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Leandro Lucarella <llucax@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Resource map sanity check conflict on ACPI Non-volatile Storage
References: <20081231215929.GA24834@homero.springfield.home>
In-Reply-To: <20081231215929.GA24834@homero.springfield.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think your stacktrace is similar to mine, reported to LKML
under Subject: 2.6.28 regression: ACPI Non-volatile Storage
on Dec 30 2008. I haven't received any answer. Have also ASUS
product. Happens with -git2 as well.
Martin


Leandro Lucarella wrote:
> Hi. I've just upgraded to Linux 2.6.28 and when my system boot up I get
> this warning:
> 
> resource map sanity check conflict: 0x1dffff00 0x1e0000ff 0x1dfff000 0x1dffffff ACPI Non-volatile Storage
> 
> And then a stack trace. Should I be worried? (please Cc me)
> 
> Here is the trace:
> ---------->8---------->8---------->8---------->8---------->8----------
> Dec 31 15:13:38 homero kernel: ACPI: bus type pci registered
> Dec 31 15:13:38 homero kernel: PCI: PCI BIOS revision 2.10 entry at 0xf1b20, last bus=2
> Dec 31 15:13:38 homero kernel: PCI: Using configuration type 1 for base access
> Dec 31 15:13:38 homero kernel: resource map sanity check conflict: 0x1dffff00 0x1e0000ff 0x1dfff000 0x1dffffff ACPI Non-volatile Storage
> Dec 31 15:13:38 homero kernel: ------------[ cut here ]------------
> Dec 31 15:13:38 homero kernel: WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x57/0x213()
> Dec 31 15:13:38 homero kernel: Modules linked in:
> Dec 31 15:13:38 homero kernel: Pid: 1, comm: swapper Not tainted 2.6.28 #2
> Dec 31 15:13:38 homero kernel: Call Trace:
> Dec 31 15:13:38 homero kernel:  [<c0332276>] ? printk+0xf/0x11
> Dec 31 15:13:38 homero kernel:  [<c011b2e6>] warn_on_slowpath+0x41/0x62
> Dec 31 15:13:38 homero kernel:  [<c02652fc>] ? acpi_os_release_object+0x8/0xc
> Dec 31 15:13:38 homero kernel:  [<c027b839>] ? acpi_ut_delete_generic_state+0x13/0x15
> Dec 31 15:13:38 homero kernel:  [<c02652fc>] ? acpi_os_release_object+0x8/0xc
> Dec 31 15:13:38 homero kernel:  [<c027b5d4>] ? acpi_ut_delete_object_desc+0x38/0x3d
> Dec 31 15:13:38 homero kernel:  [<c0332276>] ? printk+0xf/0x11
> Dec 31 15:13:38 homero kernel:  [<c011f1ed>] ? iomem_map_sanity_check+0x6b/0x9a
> Dec 31 15:13:38 homero kernel:  [<c0112237>] __ioremap_caller+0x57/0x213
> Dec 31 15:13:38 homero kernel:  [<c027ad9a>] ? acpi_ut_update_ref_count+0x49/0x8d
> Dec 31 15:13:38 homero kernel:  [<c027ae98>] ? acpi_ut_update_object_reference+0xba/0x11b
> Dec 31 15:13:38 homero kernel:  [<c01124b3>] ioremap_nocache+0x10/0x12
> Dec 31 15:13:38 homero kernel:  [<c032eae5>] ? acpi_os_map_memory+0x11/0x1a
> Dec 31 15:13:38 homero kernel:  [<c032eae5>] acpi_os_map_memory+0x11/0x1a
> Dec 31 15:13:38 homero kernel:  [<c02709a8>] acpi_ex_system_memory_space_handler+0xd7/0x207
> Dec 31 15:13:38 homero kernel:  [<c02708d1>] ? acpi_ex_system_memory_space_handler+0x0/0x207
> Dec 31 15:13:38 homero kernel:  [<c0269e33>] acpi_ev_address_space_dispatch+0x12f/0x16f
> Dec 31 15:13:38 homero kernel:  [<c026dc8a>] acpi_ex_access_region+0x1b2/0x1c0
> Dec 31 15:13:38 homero kernel:  [<c026ddaf>] acpi_ex_field_datum_io+0x117/0x1ae
> Dec 31 15:13:38 homero kernel:  [<c026e103>] acpi_ex_write_with_update_rule+0xd5/0xde
> Dec 31 15:13:38 homero kernel:  [<c026e3ec>] acpi_ex_insert_into_field+0x2e0/0x300
> Dec 31 15:13:38 homero kernel:  [<c0272ee5>] ? acpi_ns_search_one_scope+0x15/0x3a
> Dec 31 15:13:38 homero kernel:  [<c026ca35>] acpi_ex_write_data_to_field+0x169/0x181
> Dec 31 15:13:38 homero kernel:  [<c0270b5a>] acpi_ex_store_object_to_node+0x82/0xb7
> Dec 31 15:13:38 homero kernel:  [<c0270cfd>] acpi_ex_store+0xa6/0x201
> Dec 31 15:13:38 homero kernel:  [<c026ecda>] acpi_ex_opcode_1A_1T_1R+0x3db/0x535
> Dec 31 15:13:38 homero kernel:  [<c026f3fb>] ? acpi_ex_resolve_operands+0x18f/0x438
> Dec 31 15:13:38 homero kernel:  [<c0267632>] acpi_ds_exec_end_op+0xe6/0x370
> Dec 31 15:13:38 homero kernel:  [<c027661e>] acpi_ps_parse_loop+0x5cd/0x71f
> Dec 31 15:13:38 homero kernel:  [<c0275a38>] acpi_ps_parse_aml+0x6d/0x267
> Dec 31 15:13:38 homero kernel:  [<c0276c85>] acpi_ps_execute_method+0x11c/0x1d7
> Dec 31 15:13:38 homero kernel:  [<c02738a0>] acpi_ns_evaluate+0x11c/0x1e4
> Dec 31 15:13:38 homero kernel:  [<c0279682>] acpi_ut_evaluate_object+0x51/0x158
> Dec 31 15:13:38 homero kernel:  [<c02797fa>] acpi_ut_execute_STA+0x1d/0x49
> Dec 31 15:13:38 homero kernel:  [<c026535f>] ? acpi_os_signal_semaphore+0x25/0x29
> Dec 31 15:13:38 homero kernel:  [<c0273286>] acpi_ns_get_device_callback+0x59/0x112
> Dec 31 15:13:38 homero kernel:  [<c026539e>] ? acpi_os_wait_semaphore+0x3b/0x48
> Dec 31 15:13:38 homero kernel:  [<c0274a42>] acpi_ns_walk_namespace+0x9a/0x110
> Dec 31 15:13:38 homero kernel:  [<c04691b2>] ? acpi_init+0x0/0x237
> Dec 31 15:13:38 homero kernel:  [<c02731b1>] acpi_get_devices+0x47/0x5d
> Dec 31 15:13:38 homero kernel:  [<c027322d>] ? acpi_ns_get_device_callback+0x0/0x112
> Dec 31 15:13:38 homero kernel:  [<c027f441>] ? ec_parse_device+0x0/0x80
> Dec 31 15:13:38 homero kernel:  [<c0469743>] acpi_ec_ecdt_probe+0xc3/0x123
> Dec 31 15:13:38 homero kernel:  [<c04691b2>] ? acpi_init+0x0/0x237
> Dec 31 15:13:38 homero kernel:  [<c046922f>] acpi_init+0x7d/0x237
> Dec 31 15:13:38 homero kernel:  [<c02a6233>] ? __class_create+0x44/0x5d
> Dec 31 15:13:38 homero kernel:  [<c04678bb>] ? fbmem_init+0x0/0x78
> Dec 31 15:13:38 homero kernel:  [<c010112f>] _stext+0x47/0x107
> Dec 31 15:13:38 homero kernel:  [<c0145e3a>] ? __alloc_pages_internal+0x91/0x354
> Dec 31 15:13:38 homero kernel:  [<c0243607>] ? idr_get_empty_slot+0x14f/0x238
> Dec 31 15:13:38 homero kernel:  [<c024384d>] ? ida_get_new_above+0x15d/0x177
> Dec 31 15:13:38 homero kernel:  [<c0243873>] ? ida_get_new+0xc/0xe
> Dec 31 15:13:38 homero kernel:  [<c018b833>] ? proc_register+0x33/0x11a
> Dec 31 15:13:38 homero kernel:  [<c018ba32>] ? create_proc_entry+0x7b/0x91
> Dec 31 15:13:38 homero kernel:  [<c01407d6>] ? register_irq_proc+0x65/0x81
> Dec 31 15:13:38 homero kernel:  [<c045049b>] kernel_init+0x6b/0xb9
> Dec 31 15:13:38 homero kernel:  [<c0450430>] ? kernel_init+0x0/0xb9
> Dec 31 15:13:38 homero kernel:  [<c0104453>] kernel_thread_helper+0x7/0x10
> Dec 31 15:13:38 homero kernel: ---[ end trace 4eaa2a86a8e2da22 ]---
> Dec 31 15:13:38 homero kernel: ACPI: Interpreter enabled
> Dec 31 15:13:38 homero kernel: ACPI: (supports S0 S1 S3 S4 S5)
> Dec 31 15:13:38 homero kernel: ACPI: Using IOAPIC for interrupt routing

[cut]
