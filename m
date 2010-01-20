Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238Ab0ATCKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0ATCKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168Ab0ATCKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:10:37 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61365 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab0ATCKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=iWAd0yxDV1GNVIaCT/0O1n4GkpT90y9BxIWrI3TDUygHu/sPlxhmRw9AFyfF/MHuLo
         pWHWRgKT3xf1z/zsPll/JZmU46IZ/wr94yLP5kgESlLESNbOiRp/W8cAzp5ZnWRm/zUe
         OGv1otsZROqSv+/UQ/EPCL9lGQEhNjy95vJwo=
MIME-Version: 1.0
Date: Wed, 20 Jan 2010 02:10:34 +0000
Message-ID: <6278d2221001191810m21f4cca1id3535de0bb677196@mail.gmail.com>
Subject: [2.6.33-rc4] ACPI hitting kmalloc(MAX_ORDER) limits...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: linux-acpi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.33-rc4 on an Ibase MI910 miniITX x86-64 mobo, ACPI
hits kmalloc MAX_ORDER limits [1] while parsing the AML; though a
warning, it is a regression over 2.6.32.

Would making the AML available help adding this to a testcase?

Thanks,
  Daniel

--- [1]

ACPI: SSDT 000000007fde8340 0026C (v01  PmRef  Cpu0Ist 00003000 INTL 20040311)

ACPI: SSDT 000000007fde8800 00152 (v01  PmRef  Cpu1Ist 00003000 INTL 20040311)

------------[ cut here ]------------

WARNING: at mm/page_alloc.c:1812 __alloc_pages_nodemask+0x1b4/0x710()

Hardware name: OEM

Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.33-rc4-310sd #2

Call Trace:

 [<ffffffff81044508>] warn_slowpath_common+0x78/0xb0

 [<ffffffff8104454f>] warn_slowpath_null+0xf/0x20

 [<ffffffff810b98b4>] __alloc_pages_nodemask+0x1b4/0x710

 [<ffffffff810241b5>] ? do_page_fault+0x255/0x320

 [<ffffffff8145a9de>] ? trace_hardirqs_off_thunk+0x3a/0x3c

 [<ffffffff8145bdc9>] ? error_exit+0x29/0xb0

 [<ffffffff810b9e28>] __get_free_pages+0x18/0x50

 [<ffffffff810e262a>] __kmalloc+0x20a/0x280

 [<ffffffff8107878d>] ? trace_hardirqs_on+0xd/0x10

 [<ffffffff812844ca>] acpi_ex_load_op+0x14b/0x2fb

 [<ffffffff81286d92>] acpi_ex_opcode_1A_1T_0R+0x25/0x4b

 [<ffffffff8127e49c>] acpi_ds_exec_end_op+0xea/0x3d6

 [<ffffffff812909b6>] acpi_ps_parse_loop+0x7d9/0x95f

 [<ffffffff8128fac5>] acpi_ps_parse_aml+0x9a/0x2b9

 [<ffffffff812911b6>] acpi_ps_execute_method+0x1c8/0x29a

 [<ffffffff8128c4a5>] acpi_ns_evaluate+0xe1/0x1a8

 [<ffffffff8128befe>] acpi_evaluate_object+0x184/0x27f

 [<ffffffff812777c8>] acpi_processor_set_pdc+0x23f/0x26c

 [<ffffffff812777fe>] early_init_pdc+0x9/0xf

 [<ffffffff8128df12>] acpi_ns_walk_namespace+0xb9/0x187

 [<ffffffff812777f5>] ? early_init_pdc+0x0/0xf

 [<ffffffff812777f5>] ? early_init_pdc+0x0/0xf

 [<ffffffff8128bd40>] acpi_walk_namespace+0x85/0xbf

 [<ffffffff81a8168e>] ? acpi_init+0x0/0x12a

 [<ffffffff81a8168e>] ? acpi_init+0x0/0x12a

 [<ffffffff81277562>] acpi_early_processor_set_pdc+0x3a/0x3c

 [<ffffffff81a81565>] acpi_bus_init+0xb5/0x1de

 [<ffffffff8124681e>] ? kobject_create_and_add+0x3e/0x80

 [<ffffffff81a7dac1>] ? genhd_device_init+0x0/0x7b

 [<ffffffff81a8168e>] ? acpi_init+0x0/0x12a

 [<ffffffff81a816ff>] acpi_init+0x71/0x12a

 [<ffffffff810001d7>] do_one_initcall+0x37/0x190

 [<ffffffff81a644f3>] kernel_init+0x1a8/0x1fd

 [<ffffffff81003a94>] kernel_thread_helper+0x4/0x10

 [<ffffffff8145b97c>] ? restore_args+0x0/0x30

 [<ffffffff81a6434b>] ? kernel_init+0x0/0x1fd

 [<ffffffff81003a90>] ? kernel_thread_helper+0x0/0x10

---[ end trace a7919e7f17c0a725 ]---

ACPI Error (psparse-0537): Method parse/execution failed
[\_PR_.CPU2._PDC] (Node ffff88007f8fa960)Y

ACPI Error (psparse-0537): Method parse/execution failed
[\_PR_.CPU3._PDC] (Node ffff88007f8fa9e0)Y

-- 
Daniel J Blueman
