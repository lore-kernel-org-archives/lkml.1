Return-Path: <linux-kernel-owner+w=401wt.eu-S1762448AbYBRVHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762448AbYBRVHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762837AbYBRVF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:05:58 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:46104 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762819AbYBRVF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:05:56 -0500
Message-ID: <47B9F331.7070808@free.fr>
Date: Mon, 18 Feb 2008 22:05:53 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47B9DDF4.8030605@linux.intel.com>
In-Reply-To: <47B9DDF4.8030605@linux.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 18.02.2008 20:35, Arjan van de Ven a écrit :
> Laurent Riffard wrote:
>> Le 16.02.2008 09:25, Andrew Morton a écrit :
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/ 
>>>
>>
>> Got this in dmesg output:
>>
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()
> 
> Can you try the patch below? It should print a bit more information so
> that we can figure out who's really at fault here.. (eg it's either
> the diagnostics that are wrong, or ACPI is doing something evil (on
> behalf of the bios), we need to know what address is being triggered)

I've got 2 new lines in dmesg output:

ACPI: EC: Look up EC in DSDT
ioremap: trying to map RAM page at 0       <===============
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:134 __ioremap+0xe8/0x1b6()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #41
 [<c0118989>] warn_on_slowpath+0x41/0x6d
 [<c0130ae6>] ? trace_hardirqs_off+0xb/0xd
 [<c0116326>] ? runqueue_is_locked+0x23/0x3f
 [<c0118d31>] ? release_console_sem+0x1be/0x1c6
 [<c0119304>] ? vprintk+0x2d0/0x31d
 [<c01129e6>] __ioremap+0xe8/0x1b6
 [<c0112acd>] ioremap_nocache+0xa/0xc
 [<c02a68a7>] acpi_os_map_memory+0x11/0x1a
 [<c020b6c7>] acpi_ex_system_memory_space_handler+0xd3/0x228
 [<c0203c08>] ? acpi_ev_address_space_dispatch+0x142/0x1a8
 [<c020b5f4>] ? acpi_ex_system_memory_space_handler+0x0/0x228
 [<c0203c2d>] acpi_ev_address_space_dispatch+0x167/0x1a8
 [<c020840d>] acpi_ex_access_region+0x1e4/0x270
 [<c02085ec>] acpi_ex_field_datum_io+0x153/0x2a1
 [<c0158af4>] ? cache_alloc_debugcheck_after+0xe9/0x165
 [<c02087cb>] acpi_ex_extract_from_field+0x91/0x224
 [<c0206bff>] ? acpi_ex_read_data_from_field+0x163/0x1b0
 [<c0206c1c>] acpi_ex_read_data_from_field+0x180/0x1b0
 [<c020d286>] acpi_ex_resolve_node_to_value+0x1aa/0x230
 [<c0207a62>] acpi_ex_resolve_to_value+0x270/0x2aa
 [<c0209e77>] acpi_ex_resolve_operands+0x24e/0x52f
 [<c0200857>] acpi_ds_exec_end_op+0xb7/0x4f4
 [<c0212d81>] acpi_ps_parse_loop+0x5e5/0x79c
 [<c021210c>] acpi_ps_parse_aml+0xb2/0x2dd
 [<c021353c>] acpi_ps_execute_method+0x13d/0x20d
 [<c020fba2>] acpi_ns_evaluate+0x10e/0x1b0
 [<c02164fa>] acpi_ut_evaluate_object+0x57/0x1a1
 [<c02166fe>] acpi_ut_execute_STA+0x22/0x7b
 [<c0218d91>] ? acpi_ut_release_mutex+0x85/0x8f
 [<c020f48d>] acpi_ns_get_device_callback+0x5a/0x121
 [<c021176e>] acpi_ns_walk_namespace+0xfa/0x114
 [<c020f3b1>] acpi_get_devices+0x47/0x5d
 [<c020f433>] ? acpi_ns_get_device_callback+0x0/0x121
 [<c021ce7a>] ? ec_parse_device+0x0/0x6e
 [<c03a4460>] acpi_ec_ecdt_probe+0xaa/0x10a
 [<c03a404b>] acpi_init+0x73/0x21e
 [<c023e5eb>] ? class_create+0x4b/0x64
 [<c0390652>] kernel_init+0xa3/0x1f3
 [<c0103a4e>] ? restore_nocheck_notrace+0x0/0xe
 [<c03905af>] ? kernel_init+0x0/0x1f3
 [<c03905af>] ? kernel_init+0x0/0x1f3
 [<c01045a7>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace 4eaa2a86a8e2da22 ]---
ioremap: trying to map RAM page at 0       <===============
Completing Region/Field/Buffer/Package initialization:................................................

Hope this helps.
-- 
laurent
