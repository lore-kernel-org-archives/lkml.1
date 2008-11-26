Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbYKZRwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbYKZRwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbYKZRwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:52:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:38819 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYKZRwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,670,1220252400"; 
   d="scan'208";a="408353954"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 26 Nov 2008 09:52:38 -0800
Subject: RE: 2.6.28-rc6-mmotm1126 - acpi AE_AM_INFINITE_LOOP errors..
Thread-Topic: 2.6.28-rc6-mmotm1126 - acpi AE_AM_INFINITE_LOOP errors..
Thread-Index: AclP7YcgIwnAMNqoR6SgQUe8vDvZ8QAAicTg
Message-ID: <4911F71203A09E4D9981D27F9D8308580DBD35F9@orsmsx503.amr.corp.intel.com>
References: <4018.1227716135@turing-police.cc.vt.edu>
            <4911F71203A09E4D9981D27F9D8308580DBD34C2@orsmsx503.amr.corp.intel.com>
 <4372.1227720950@turing-police.cc.vt.edu>
In-Reply-To: <4372.1227720950@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that would be my guess. I'll have to let other experts look at this.


>-----Original Message-----
>From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
>Sent: Wednesday, November 26, 2008 9:36 AM
>To: Moore, Robert
>Cc: linux-kernel@vger.kernel.org
>Subject: Re: 2.6.28-rc6-mmotm1126 - acpi AE_AM_INFINITE_LOOP errors..
>
>On Wed, 26 Nov 2008 08:24:26 PST, "Moore, Robert" said:
>>
>> You could try making the max loop count larger, it is a 32-bit value:
>>
>> acconfig.h
>>
>> /* Maximum number of While() loop iterations before forced abort */
>>
>> -#define ACPI_MAX_LOOP_ITERATIONS        0xFFFF
>> +#define ACPI_MAX_LOOP_ITERATIONS        0x00FFFFFF
>
>That "works", for some sub-optimal value of "works".  It does indeed
>shut up *some* of the messages, but boot was taking *forever* (or more
>correctly,
>I gave up when it had taken more than 6 minutes to get through the initial
>udev and modprobe flurry that usually takes all of 12 seconds or less to
>complete.
>
>I'm suspecting that something *else* is busticated in the ACPI code, and
>loops that used to complete quickly are missing whatever terminating
>condition they had, and the new infinite loop detector is in fact tripping
>properly and catching the (newly introduced) error condition?
>
>
>...
>[   13.042567] usb 3-1.2: configuration #1 chosen from 1 choice
>[   13.130251] ieee1394: Host added: ID:BUS[0-00:1023]
>GUID[4a4fc0000fbe9561]
>[   30.702013] Clocksource tsc unstable (delta = -6046116753 ns)
>[   41.726022] thermal: gave up waiting for init of module processor.
>[   41.741146] thermal: Unknown symbol acpi_processor_set_thermal_limit
>[   41.760231] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01cc]
>
>It went off to somewhere for 28 seconds trying to init the thermal code..
>
>[   42.213146] vendor=8086 device=27d2
>[   42.227850] iwl3945 0000:0c:00.0: PCI INT A disabled
>
>and went nappies here.. finally I did a alt-sysrq-t, and we're here, with
>several modprobes chugging along very slowly...
>
>[  127.995256] modprobe      D ffff88007edcb800  5176   862    861
>[  127.995256]  ffff88007ec639a8 0000000000000046 000000017e42f250
>ffffffff8079d7c0
>[  127.995256]  ffffffff8079d750 ffffffff8081e7c0 ffffffff8081e7c0
>ffff88007eddd7f0
>[  127.995256]  ffff88007f2677f0 ffff88007edddb48 000000008079ea80
>ffff88007edddb48
>[  127.995256] Call Trace:
>[  127.995256]  [<ffffffff80283516>] ? __alloc_pages_internal+0x10d/0x493
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff80568bc6>] schedule_timeout+0x22/0xb4
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff805699de>] __down_common+0x9d/0xdf
>[  127.995256]  [<ffffffff80569a31>] __down_timeout+0x11/0x13
>[  127.995256]  [<ffffffff8024f639>] down_timeout+0x48/0x61
>[  127.995256]  [<ffffffff803a5b1d>] acpi_os_wait_semaphore+0x49/0x58
>[  127.995256]  [<ffffffff803be893>] acpi_ut_acquire_mutex+0x3e/0x82
>[  127.995256]  [<ffffffff803b29ce>] acpi_ex_enter_interpreter+0xb/0x2b
>[  127.995256]  [<ffffffff803b5840>] acpi_ns_evaluate+0x1ac/0x230
>[  127.995256]  [<ffffffff803b52b4>] acpi_evaluate_object+0xfc/0x204
>[  127.995256]  [<ffffffff8038ebd3>] ? pci_get_subsys+0x7b/0x8f
>[  127.995256]  [<ffffffffa005fe16>] acpi_processor_start+0x1ba/0x78a
>[processor]
>[  127.995256]  [<ffffffff803c09b3>] acpi_start_single_object+0x2a/0x54
>[  127.995256]  [<ffffffff803c1fc7>] acpi_device_probe+0x78/0x8c
>[  127.995256]  [<ffffffff803f349f>] driver_probe_device+0xe7/0x195
>[  127.995256]  [<ffffffff803f35af>] __driver_attach+0x62/0x8c
>[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
>[  127.995256]  [<ffffffff803f2d10>] bus_for_each_dev+0x4c/0x83
>[  127.995256]  [<ffffffff803f32c3>] driver_attach+0x1c/0x1e
>[  127.995256]  [<ffffffff803f260d>] bus_add_driver+0xb5/0x1ff
>[  127.995256]  [<ffffffff803f37a0>] driver_register+0xa8/0x128
>[  127.995256]  [<ffffffffa006a000>] ? acpi_processor_init+0x0/0x10a
>[processor]
>[  127.995256]  [<ffffffff803c22f6>] acpi_bus_register_driver+0x3e/0x40
>[  127.995256]  [<ffffffffa006a097>] acpi_processor_init+0x97/0x10a
>[processor]
>[  127.995256]  [<ffffffff80209058>] _stext+0x58/0x138
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff8056aa0d>] ? _spin_unlock_irqrestore+0x5e/0x6c
>[  127.995256]  [<ffffffff8037b6e6>] ? __up_read+0x7c/0x85
>[  127.995256]  [<ffffffff8024ef3b>] ? up_read+0x9/0xb
>[  127.995256]  [<ffffffff8024fa3e>] ?
>__blocking_notifier_call_chain+0x58/0x6a
>[  127.995256]  [<ffffffff8025f536>] sys_init_module+0xbd/0x1db
>[  127.995256]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b
>
>[  127.995256] modprobe      R  running task     5240   878    875
>[  127.995256]  ffff88007e4838a8 0000000000000046 0000007b8081bba8
>ffffffff803b21c5
>[  127.995256]  ffff88007e483858 ffffffff8081e7c0 ffffffff8081e7c0
>ffff88007e76d040
>[  127.995256]  ffff88007f2347f0 ffff88007e76d3a0 0000000100000000
>ffff88007e76d398
>[  127.995256] Call Trace:
>[  127.995256]  [<ffffffff803b21c5>] ?
>acpi_ex_system_io_space_handler+0x0/0x44
>[  127.995256]  [<ffffffff802a2343>] ? __cache_free+0x41/0xf4
>[  127.995256]  [<ffffffff80568acb>] preempt_schedule_irq+0x4d/0x91
>[  127.995256]  [<ffffffff8020c676>] retint_kernel+0x26/0x30
>[  127.995256]  [<ffffffff803ae5ae>] ? acpi_ex_name_segment+0x5a/0xed
>[  127.995256]  [<ffffffff803ae5d3>] ? acpi_ex_name_segment+0x7f/0xed
>[  127.995256]  [<ffffffff803ae730>] acpi_ex_get_name_string+0xef/0x1ef
>[  127.995256]  [<ffffffff803a9463>] acpi_ds_create_operand+0x4e/0x209
>[  127.995256]  [<ffffffff803a9667>] acpi_ds_evaluate_name_path+0x49/0xff
>[  127.995256]  [<ffffffff803a832f>] acpi_ds_exec_end_op+0x94/0x3d9
>[  127.995256]  [<ffffffff803b8c1f>] acpi_ps_parse_loop+0x6d4/0x859
>[  127.995256]  [<ffffffff803b7e45>] acpi_ps_parse_aml+0x9a/0x2d9
>[  127.995256]  [<ffffffff803b93f2>] acpi_ps_execute_method+0x195/0x267
>[  127.995256]  [<ffffffff803b57e6>] acpi_ns_evaluate+0x152/0x230
>[  127.995256]  [<ffffffff803b52b4>] acpi_evaluate_object+0xfc/0x204
>[  127.995256]  [<ffffffffa0033403>] acpi_battery_update+0x9e/0x1df
>[battery]
>[  127.995256]  [<ffffffffa0033f25>] acpi_battery_add+0x8d/0x1d4 [battery]
>[  127.995256]  [<ffffffff803c1f98>] acpi_device_probe+0x49/0x8c
>[  127.995256]  [<ffffffff803f349f>] driver_probe_device+0xe7/0x195
>[  127.995256]  [<ffffffff803f35af>] __driver_attach+0x62/0x8c
>[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
>[  127.995256]  [<ffffffff803f2d10>] bus_for_each_dev+0x4c/0x83
>[  127.995256]  [<ffffffff803f32c3>] driver_attach+0x1c/0x1e
>[  127.995256]  [<ffffffff803f260d>] bus_add_driver+0xb5/0x1ff
>[  127.995256]  [<ffffffff803f37a0>] driver_register+0xa8/0x128
>[  127.995256]  [<ffffffffa0039000>] ? acpi_battery_init+0x0/0x45 [battery]
>[  127.995256]  [<ffffffff803c22f6>] acpi_bus_register_driver+0x3e/0x40
>[  127.995256]  [<ffffffffa003902a>] acpi_battery_init+0x2a/0x45 [battery]
>[  127.995256]  [<ffffffff80209058>] _stext+0x58/0x138
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff8056aa0d>] ? _spin_unlock_irqrestore+0x5e/0x6c
>[  127.995256]  [<ffffffff8037b6e6>] ? __up_read+0x7c/0x85
>[  127.995256]  [<ffffffff8024ef3b>] ? up_read+0x9/0xb
>[  127.995256]  [<ffffffff8024fa3e>] ?
>__blocking_notifier_call_chain+0x58/0x6a
>[  127.995256]  [<ffffffff8025f536>] sys_init_module+0xbd/0x1db
>[  127.995256]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b
>
>[  127.995256] modprobe      D ffff88007edcb440  5816   882    879
>[  127.995256]  ffff88007e433c08 0000000000000046 ffff88007e433b78
>ffffffff80376e5e
>[  127.995256]  ffff88007f411090 ffffffff8081e7c0 ffffffff8081e7c0
>ffff88007e4a57f0
>[  127.995256]  ffff88007e7627f0 ffff88007e4a5b48 000000007e433b98
>ffff88007e4a5b48
>[  127.995256] Call Trace:
>[  127.995256]  [<ffffffff80376e5e>] ? _atomic_dec_and_lock+0x5a/0x98
>[  127.995256]  [<ffffffff802f9623>] ? sysfs_addrm_finish+0x69/0x255
>[  127.995256]  [<ffffffff802f90e6>] ? __sysfs_get+0x4d/0x58
>[  127.995256]  [<ffffffff802f9266>] ? __sysfs_add_one+0x63/0x9e
>[  127.995256]  [<ffffffff80568bc6>] schedule_timeout+0x22/0xb4
>[  127.995256]  [<ffffffff802f993f>] ? create_dir+0x63/0x87
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff805699de>] __down_common+0x9d/0xdf
>[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
>[  127.995256]  [<ffffffff80569a7f>] __down+0x18/0x1a
>[  127.995256]  [<ffffffff8024f741>] down+0x39/0x4c
>[  127.995256]  [<ffffffff803f358b>] __driver_attach+0x3e/0x8c
>[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
>[  127.995256]  [<ffffffff803f2d10>] bus_for_each_dev+0x4c/0x83
>[  127.995256]  [<ffffffff803f32c3>] driver_attach+0x1c/0x1e
>[  127.995256]  [<ffffffff803f260d>] bus_add_driver+0xb5/0x1ff
>[  127.995256]  [<ffffffff803f37a0>] driver_register+0xa8/0x128
>[  127.995256]  [<ffffffffa0059000>] ? acpi_button_init+0x0/0x5e [button]
>[  127.995256]  [<ffffffff803c22f6>] acpi_bus_register_driver+0x3e/0x40
>[  127.995256]  [<ffffffffa005903c>] acpi_button_init+0x3c/0x5e [button]
>[  127.995256]  [<ffffffff80209058>] _stext+0x58/0x138
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff8056aa0d>] ? _spin_unlock_irqrestore+0x5e/0x6c
>[  127.995256]  [<ffffffff8037b6e6>] ? __up_read+0x7c/0x85
>[  127.995256]  [<ffffffff8024ef3b>] ? up_read+0x9/0xb
>[  127.995256]  [<ffffffff8024fa3e>] ?
>__blocking_notifier_call_chain+0x58/0x6a
>[  127.995256]  [<ffffffff8025f536>] sys_init_module+0xbd/0x1db
>[  127.995256]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b
>
>[  127.995256] modprobe      D ffff88007e736440  5816   953    952
>[  127.995256]  ffff88007e751958 0000000000000046 0000000000000040
>000000447e7cd440
>[  127.995256]  0000000000000003 ffffffff8081e7c0 ffffffff8081e7c0
>ffff88007e1e17f0
>[  127.995256]  ffff88007e64d7f0 ffff88007e1e1b48 000000018037b061
>ffff88007e1e1b48
>[  127.995256] Call Trace:
>[  127.995256]  [<ffffffff80568bc6>] schedule_timeout+0x22/0xb4
>[  127.995256]  [<ffffffff803b4d36>] ? acpi_ns_search_and_enter+0xbc/0x18a
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff805699de>] __down_common+0x9d/0xdf
>[  127.995256]  [<ffffffff80569a31>] __down_timeout+0x11/0x13
>[  127.995256]  [<ffffffff8024f639>] down_timeout+0x48/0x61
>[  127.995256]  [<ffffffff803a5b1d>] acpi_os_wait_semaphore+0x49/0x58
>[  127.995256]  [<ffffffff803be893>] acpi_ut_acquire_mutex+0x3e/0x82
>[  127.995256]  [<ffffffff803b29ce>] acpi_ex_enter_interpreter+0xb/0x2b
>[  127.995256]  [<ffffffff803b5840>] acpi_ns_evaluate+0x1ac/0x230
>[  127.995256]  [<ffffffff803b52b4>] acpi_evaluate_object+0xfc/0x204
>[  127.995256]  [<ffffffff802a3146>] ? kmem_cache_alloc+0xcd/0xec
>[  127.995256]  [<ffffffff803a652e>] acpi_evaluate_integer+0x93/0xd1
>[  127.995256]  [<ffffffff803c0762>] acpi_get_physical_pci_device+0x1e/0x53
>[  127.995256]  [<ffffffffa00cd7ce>] acpi_video_bus_add+0x1bc/0xe0a [video]
>[  127.995256]  [<ffffffff803c1f98>] acpi_device_probe+0x49/0x8c
>[  127.995256]  [<ffffffff803f349f>] driver_probe_device+0xe7/0x195
>[  127.995256]  [<ffffffff803f35af>] __driver_attach+0x62/0x8c
>[  127.995256]  [<ffffffff803f354d>] ? __driver_attach+0x0/0x8c
>[  127.995256]  [<ffffffff803f2d10>] bus_for_each_dev+0x4c/0x83
>[  127.995256]  [<ffffffff803f32c3>] driver_attach+0x1c/0x1e
>[  127.995256]  [<ffffffff803f260d>] bus_add_driver+0xb5/0x1ff
>[  127.995256]  [<ffffffff803f37a0>] driver_register+0xa8/0x128
>[  127.995256]  [<ffffffffa000c000>] ? acpi_video_init+0x0/0x5e [video]
>[  127.995256]  [<ffffffff803c22f6>] acpi_bus_register_driver+0x3e/0x40
>[  127.995256]  [<ffffffffa000c03c>] acpi_video_init+0x3c/0x5e [video]
>[  127.995256]  [<ffffffff80209058>] _stext+0x58/0x138
>[  127.995256]  [<ffffffff8022f214>] ? get_parent_ip+0x11/0x41
>[  127.995256]  [<ffffffff8056d949>] ? sub_preempt_count+0x35/0x49
>[  127.995256]  [<ffffffff8056aa0d>] ? _spin_unlock_irqrestore+0x5e/0x6c
>[  127.995256]  [<ffffffff8037b6e6>] ? __up_read+0x7c/0x85
>[  127.995256]  [<ffffffff8024ef3b>] ? up_read+0x9/0xb
>[  127.995256]  [<ffffffff8024fa3e>] ?
>__blocking_notifier_call_chain+0x58/0x6a
>[  127.995256]  [<ffffffff8025f536>] sys_init_module+0xbd/0x1db
>[  127.995256]  [<ffffffff8020bb3b>] system_call_fastpath+0x16/0x1b
>
>Eventually:
>
>[  204.927554] tpm_tis 00:0f: 1.2 TPM (device-id 0x1001, rev-id 2)
>[  266.745556] ACPI Error (psparse-0536): Method parse/execution failed
>[\SXX6] (Node ffff88007f851a98), AE_AML_INFINITE_LOOP
>[  266.756705] ACPI Error (psparse-0536): Method parse/execution failed
>[\SXX4] (Node ffff88007f851a58), AE_AML_INFINITE_LOOP
>[  266.768276] ACPI Error (psparse-0536): Method parse/execution failed
>[\SX11] (Node ffff88007f8519f8), AE_AML_INFINITE_LOOP
>[  266.779900] ACPI Error (psparse-0536): Method parse/execution failed
>[\_SB_.BIF_] (Node ffff88007f858458), AE_AML_INFINITE_LOOP
>[  266.791807] ACPI Error (psparse-0536): Method parse/execution failed
>[\_SB_.BAT0._BIF] (Node ffff88007f858398), AE_AML_INFINITE_LOOP
>[  266.803600] ACPI Exception (battery-0329): AE_AML_INFINITE_LOOP, ACPI:
>SSDT 7FE82138, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
>[  266.810266] Evaluating _BIF [20080926]
>[  266.810279] ACPI: Battery Slot [BAT0] (battery present)
>[  266.810394] input: Lid Switch as
>/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
>[  266.853545] ACPI: SSDT 7FE81EED, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL
>20050624)
>[  415.384183] SysRq : Resetting
>
>Enough was enough.
