Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYBRFGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYBRFGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYBRFGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:06:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:32673 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYBRFGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:06:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,369,1199692800"; 
   d="scan'208";a="380324303"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Date: Sun, 17 Feb 2008 23:58:03 -0500
Message-ID: <CFF307C98FEABE47A452B27C06B85BB604826004@hdsmsx411.amr.corp.intel.com>
In-Reply-To: <47B75B10.3070700@linux.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
Thread-Index: Achw5ngO8VXljkTSRDOQojDEIPoVXgBBD06Q
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47B75B10.3070700@linux.intel.com>
From: "Brown, Len" <len.brown@intel.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Laurent Riffard" <laurent.riffard@free.fr>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "Stuart Bennett" <sb476@cam.ac.uk>
X-OriginalArrivalTime: 18 Feb 2008 04:58:06.0816 (UTC) FILETIME=[D9AA4600:01C871EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> evxfevnt-0091 [00] enable                : Transition to 
>ACPI mode successful
>> khelper used greatest stack depth: 3144 bytes left
>> net_namespace: 304 bytes
>> NET: Registered protocol family 16
>> ACPI: bus type pci registered
>> khelper used greatest stack depth: 3032 bytes left
>> PCI: PCI BIOS revision 2.10 entry at 0xf1180, last bus=1
>> PCI: Using configuration type 1
>> Setting up standard PCI resources
>> evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F 
>[_GPE] 2 regs on int 0x9
>> evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, 
>Enabled 0 Runtime GPEs in this block
>> ACPI: EC: Look up EC in DSDT
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #40
>>  [<c0118955>] warn_on_slowpath+0x41/0x6d
>>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>>  [<c01fdd89>] ? acpi_os_release_object+0x8/0xc
>>  [<c02188d4>] ? acpi_ut_delete_object_desc+0x39/0x3e
>>  [<c0217f05>] ? acpi_ut_delete_internal_obj+0x2c1/0x2c9
>>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>>  [<c0131cde>] ? trace_hardirqs_on_caller+0xdf/0x100
>>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>>  [<c01129c5>] __ioremap+0xc7/0x182
>>  [<c0112a99>] ioremap_nocache+0xa/0xc
>>  [<c02a6877>] acpi_os_map_memory+0x11/0x1a
>>  [<c020b697>] acpi_ex_system_memory_space_handler+0xd3/0x228
>>  [<c0203bd8>] ? acpi_ev_address_space_dispatch+0x142/0x1a8
>>  [<c020b5c4>] ? acpi_ex_system_memory_space_handler+0x0/0x228
>>  [<c0203bfd>] acpi_ev_address_space_dispatch+0x167/0x1a8
>>  [<c02083dd>] acpi_ex_access_region+0x1e4/0x270
>>  [<c02085bc>] acpi_ex_field_datum_io+0x153/0x2a1
>>  [<c0158ac0>] ? cache_alloc_debugcheck_after+0xe9/0x165
>>  [<c020879b>] acpi_ex_extract_from_field+0x91/0x224
>>  [<c0206bcf>] ? acpi_ex_read_data_from_field+0x163/0x1b0
>>  [<c0206bec>] acpi_ex_read_data_from_field+0x180/0x1b0
>>  [<c020d256>] acpi_ex_resolve_node_to_value+0x1aa/0x230
>>  [<c0207a32>] acpi_ex_resolve_to_value+0x270/0x2aa
>>  [<c0209e47>] acpi_ex_resolve_operands+0x24e/0x52f
>
>Len: This WARN_ON says that ACPI is trying to call ioremap() 
>on memory that the e820_table
>lists as "kernel owned". Do you know why ACPI would do this? 
>Would ACPI get upset if
>the kernel would tell it to take a hike?

Depends on the BIOS -- as it is the BIOS AML that is making this
request.

-Len
