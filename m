Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbYDZPCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbYDZPCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYDZPCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:02:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19757 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYDZPCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:02:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=W5MBZS5krtM8+OMVf8KRg9NERlxhsLI/QHumSADApiKVIWrifNCj42+HoimBRl0oi50zA7/nF+UtANsW/QOHADANDxjbNB29zYpCyqWmgFm1G21BhhMa581lZzbI2t0Hovwln7Bx7MeqNuPQU/vzbqFzZq/nbbFHnFRkegKOh5Y=
Message-ID: <481343ED.1060002@gmail.com>
Date: Sat, 26 Apr 2008 19:02:05 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: mainline boot failures I: qemu
References: <20080426140210.GA13365@basil.nowhere.org>
In-Reply-To: <20080426140210.GA13365@basil.nowhere.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> FYI
> 
> I see lots of boot failures on various setups with current mainline
> (git8, b1721d0da266b4af8cb4419473b4ca36206ab200). Unfortunately 
> they are all different. 
> 
> All with a defconfig kernel.

I'm experiencing a boot failure with current mainline and QEMU, too.
The last commit is same as yours (b1721d0da266b4), but the boot log
is different:

<<<<<<<<<

qemu-0.9.1/bin/qemu-system-x86_64 image_64.raw \
        -kernel src/linux-2.6/arch/x86/boot/bzImage \
        -append "console=ttyS0 root=/dev/hda1 ro" -nographic \
        -redir tcp:2222::22 -m 512
Could not open '/dev/kqemu' - QEMU acceleration layer not activated: No such file or directory
Linux version 2.6.25-05096-gb1721d0-dirty (dmitri.vorobiev@amber.auriga.ru) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Sat Apr 26 18:54:05 MSD 2008
Command line: console=ttyS0 root=/dev/hda1 ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
max_pfn_mapped = 1048576
x86: PAT support disabled.
WARNING: strange, CPU MTRRs all blank?
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/main.c:696 mtrr_trim_uncached_memory+0x16b/0x176()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.25-05096-gb1721d0-dirty #1

Call Trace:
 [<ffffffff8022e991>] warn_on_slowpath+0x51/0x63
 [<ffffffff8022f6ad>] printk+0x4e/0x56
 [<ffffffff807be718>] do_early_param+0x37/0x7d
 [<ffffffff807c6df0>] mtrr_trim_uncached_memory+0x16b/0x176
 [<ffffffff807c46d5>] setup_arch+0x204/0x3b8
 [<ffffffff807beaa2>] start_kernel+0x6e/0x2fb
 [<ffffffff807be3ce>] x86_64_start_kernel+0x1dd/0x1e4

---[ end trace ca143223eefdc828 ]---
init_memory_mapping
DMI not present or invalid.
ACPI: RSDP 000FA5E0, 0014 (r0 QEMU  )
ACPI: RSDT 1FFF0000, 002C (r0 QEMU   QEMURSDT        1 QEMU        1)
ACPI: FACP 1FFF002C, 0074 (r0 QEMU   QEMUFACP        1 QEMU        1)
ACPI: DSDT 1FFF0100, 0832 (r1   BXPC   BXDSDT        1 INTL 20060912)
ACPI: FACS 1FFF00C0, 0040
ACPI: APIC 1FFF0938, 0040 (r0 QEMU   QEMUAPIC        1 QEMU        1)
No NUMA configuration found
Faking a node at 0000000000000000-000000001fff0000
Bootmem setup node 0 0000000000000000-000000001fff0000
  NODE_DATA [000000000000b000 - 0000000000011fff]
  bootmap [0000000000012000 -  0000000000015fff] pages 4
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] TRAMPOLINE
early res: 2 [200000-8dc9c7] TEXT DATA BSS
early res: 3 [9fc00-fffff] BIOS reserved
early res: 4 [8000-afff] PGTABLE
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   131056
ACPI: PM-Timer IO Port: 0xb008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:dffc0000)
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PERCPU: Allocating 35928 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 127310
Policy zone: DMA32
Kernel command line: console=ttyS0 root=/dev/hda1 ro
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 3391.388 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
Memory: 508168k/524224k available (3529k kernel code, 15668k reserved, 2073k data, 432k init)
Calibrating delay using timer specific routine.. 6990.20 BogoMIPS (lpj=13980418)Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
SMP alternatives: switching to UP code
Freeing SMP alternatives: 32k freed
ACPI: Core revision 20070126
CPU0: QEMU Virtual CPU version 0.9.1 stepping 03
Using local APIC timer interrupts.
Detected 62.505 MHz APIC timer.
Brought up 1 CPUs
Total of 1 processors activated (6990.20 BogoMIPS).
net_namespace: 568 bytes
NET: Registered protocol family 16
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffff8022518c>] __dequeue_entity+0x2e/0x68
PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 11, comm: khelper Not tainted 2.6.25-05096-gb1721d0-dirty #1
RIP: 0010:[<ffffffff8022518c>]  [<ffffffff8022518c>] __dequeue_entity+0x2e/0x68
RSP: 0000:ffff81001f91ddd0  EFLAGS: 00000006
RAX: 0000000000000000 RBX: ffff81000100a460 RCX: 000000000405dd72
RDX: 0000000000000000 RSI: ffff810001005900 RDI: ffff810001005910
RBP: ffff81001f91ddf0 R08: ffff81000100a460 R09: ffff81000100a488
R10: 0000000000000001 R11: 0000000000000000 R12: ffff810001005910
R13: ffff810001005900 R14: ffffffff807e71c0 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffffffff80779000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
Process khelper (pid: 11, threadinfo ffff81001f91c000, task ffff81001f916bf0)
Stack:  ffff81001f91ddf0 ffff810001005900 ffff81000100a460 ffff81001f916be0
 ffff81001f91de10 ffffffff802251de ffff81000100a460 ffff810001005900
 ffff81001f91de30 ffffffff80225277 ffff81000100a400 ffff81001f907710
Call Trace:
 [<ffffffff802251de>] set_next_entity+0x18/0x3a
 [<ffffffff80225277>] pick_next_task_fair+0x48/0x5f
 [<ffffffff8056afca>] schedule+0x346/0x572
 [<ffffffff80231ef5>] do_exit+0x615/0x619
 [<ffffffff8023c9bf>] ? ____call_usermodehelper+0x123/0x124
 [<ffffffff8022a281>] ? schedule_tail+0x28/0x5d
 [<ffffffff8020beb8>] ? child_rip+0xa/0x12
 [<ffffffff8023c89c>] ? ____call_usermodehelper+0x0/0x124
 [<ffffffff8020beae>] ? child_rip+0x0/0x12


Code: e5 41 55 49 89 f5 41 54 4c 8d 66 10 53 48 89 fb 48 83 ec 08 4c 39 67 30 75 2a 4c 89 e7 e8 0b b0 12 00 47 85 c0 48 89 43 30 74 19 <48> 8b 40 40 48 8b 4b 20 48 89 c2 48 29 ca 48 85 d2 48 0f 4e c1
RIP  [<ffffffff8022518c>] __dequeue_entity+0x2e/0x68
 RSP <ffff81001f91ddd0>
CR2: 0000000000000040
---[ end trace ca143223eefdc828 ]---
Fixing recursive fault but reboot is needed!

<<<<<<<<<

Have not investigated the crash, am just reporting it.

Thanks,
Dimitri

