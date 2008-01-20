Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYATGZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYATGZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 01:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYATGYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 01:24:55 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:34541 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752315AbYATGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 01:24:54 -0500
Message-ID: <4792E92E.7030202@linux.vnet.ibm.com>
Date: Sun, 20 Jan 2008 11:54:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1 kernel panic while bootup
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <478F5E05.2020106@linux.vnet.ibm.com> <20080117105411.135d76df.akpm@linux-foundation.org>
In-Reply-To: <20080117105411.135d76df.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 17 Jan 2008 19:24:13 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Hi Andrew,
>>
>> The 2.6.24-rc8-mm1 kernel panic while bootup with bootup message
> 
> Can you please bisect it?  I'd start with git-x86.  These:
> 
>     ssb-add-ssb_pcihost_set_power_state-function.patch
>     b44-power-down-phy-when-interface-down.patch
>     drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
>     drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
>     drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
> ->  git-ipwireless_cs.patch


The kernel boots up while patches applied till here and fails with the next check point.
of iommu-sg-merging-add-device_dma_parameters-structure.patch.

>     #
>     revert-kvm-stuff-to-make-git-x86-apply.patch
>     git-x86.patch
>     git-x86-fixup.patch
>     git-x86-fixup-2.patch
>     acpi-default-unmap-fixpatch.patch
>     git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
>     git-x86-fix-doubly-merged-patch.patch
>     pci-dont-load-acpi_php-when-acpi-is-disabled.patch
>     pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
>     #
>     #X86-ANDI-START
>     #X86-ANDI-END
>     #
>     #
> ->  iommu-sg-merging-add-device_dma_parameters-structure.patch
> 
> would be suitable test points.
> 
>> Dual Core AMD Opteron(tm) Processor 270 stepping 02
>> Unable to handle kernel paging request at 0000000000004a78 RIP: 
>>  [<ffffffff8026f966>] __alloc_pages+0x40/0x31e
>> PGD 0 
>> Oops: 0000 [1] SMP 
>> last sysfs file: 
>> CPU 0 
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.24-rc8-mm1-autotest #1
>> RIP: 0010:[<ffffffff8026f966>]  [<ffffffff8026f966>] __alloc_pages+0x40/0x31e
>> RSP: 0000:ffff81003f9b9c60  EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
>> RDX: 0000000000004a70 RSI: 0000000000000605 RDI: ffffffff805a6f66
>> RBP: 00000000000000d0 R08: 00380800000000c0 R09: 000000000003db89
>> R10: ffffe20000fe6880 R11: ffffffff806287b0 R12: 0000000000004a70
>> R13: 0000000000000000 R14: 0000000000000286 R15: ffff81003f9b6000
>> FS:  0000000000000000(0000) GS:ffffffff80664000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> CR2: 0000000000004a78 CR3: 0000000000201000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process swapper (pid: 1, threadinfo ffff81003f9b8000, task ffff81003f9b6000)
>> Stack:  000000000000c0d0 0000001000000000 ffffffff8027574f ffff81000000e5c8
>>  000000000000c0d0 ffffffff8026f320 ffff81003f9b9c88 0000000000000000
>>  0000000000000000 ffffffff807fac90 ffffffff807fac90 0000000000000286
>> Call Trace:
>>  [<ffffffff8027574f>] ? zone_statistics+0x3f/0x97
>>  [<ffffffff8026f320>] ? get_page_from_freelist+0x463/0x5b5
>>  [<ffffffff8028d7b8>] ? new_slab+0x10e/0x261
>>  [<ffffffff8028d92b>] ? get_new_slab+0x20/0xaa
>>  [<ffffffff8028dad8>] ? __slab_alloc+0x123/0x182
>>  [<ffffffff8026e5a1>] ? process_zones+0x79/0x15e
>>  [<ffffffff8028db73>] ? kmem_cache_alloc_node+0x3c/0x70
>>  [<ffffffff8026e5a1>] ? process_zones+0x79/0x15e
>>  [<ffffffff804f15b9>] ? _spin_lock_irqsave+0x9/0xe
>>  [<ffffffff8026e6b9>] ? pageset_cpuup_callback+0x33/0x91
>>  [<ffffffff804f37b9>] ? notifier_call_chain+0x29/0x56
>>  [<ffffffff80254b09>] ? _cpu_up+0x68/0x101
>>  [<ffffffff80254bf6>] ? cpu_up+0x54/0x61
>>  [<ffffffff808a4581>] ? kernel_init+0xbf/0x2ef
>>  [<ffffffff804f15a1>] ? _spin_unlock_irq+0x9/0xc
>>  [<ffffffff8020cc08>] ? child_rip+0xa/0x12
>>  [<ffffffff808a44c2>] ? kernel_init+0x0/0x2ef
>>  [<ffffffff8020cbfe>] ? child_rip+0x0/0x12
> 
> Who added these question marks to the backtrace output and what are they for?
> 
>> Code: 83 ec 38 65 4c 8b 3c 25 00 00 00 00 83 e0 10 89 44 24 0c 74 16 be 05 06 00 00 48 c7 c7 66 6f 5a 80 e8 a9 f4 fb ff e8 20 05 28 00 <49> 83 7c 24 08 00 49 8d 44 24 08 48 89 44 24 18 75 1a 48 c7 44 
>> RIP  [<ffffffff8026f966>] __alloc_pages+0x40/0x31e
>>  RSP <ffff81003f9b9c60>
>> CR2: 0000000000004a78


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
