Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZDCMCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZDCMCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbZDCMCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:02:16 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:54402 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbZDCMCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=d/UlhVFzzYFgjmOQVsd0Cu02iyQkrTYASZUC6pzmm+v5InYUek6r1ZT2Srnl+A+NhB
         WhNsDMqnK75fv/q1tpY3iW9db7lPuTohjwTSrKPwRGK3qd1CX3GpECc08xto6Bu49Zd9
         E9NNyJpAfabEwO1JfzvBuvG6C9bLSs2500/Z4=
MIME-Version: 1.0
Date: Fri, 3 Apr 2009 14:02:05 +0200
X-Google-Sender-Auth: 61784b436b14d7ba
Message-ID: <3efb10970904030502q1068731fl5b92f93d5341b43e@mail.gmail.com>
Subject: Re: System deadlock on 2.6.24-rt20 (-rt27 panics on 
	locking-api-selftests)
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

2009/4/3 Remy Bohmer <linux@bohmer.net>:
> Hello Thomas,
>
>>> Does anybody recognise these backtraces? And if so, is there a fix for
>>> it already?
>>
>> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24.7-rt27.bz2

I integrated -rt27, but this one fails on the locking api-selftests.
Is this a bug in the selftest? Or is there a real locking bug behind
it?

Kind regards,

Remy


[    0.000000] Linux version 2.6.24.7-rt27 (bvdm@pc2-bvdm) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-13)) #11 SMP PREEMP
T RT Fri Apr 3 13:33:47 CEST 2009
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f6e0000 (usable)
[    0.000000]  BIOS-e820: 000000007f6e0000 - 000000007f6e7000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f6e7000 - 000000007f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] 1142MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f7a00
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   521952
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   521952
[    0.000000] DMI 2.4 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F7A30, 0024 (r2 PTLTD )
[    0.000000] ACPI: XSDT 7F6E23E6, 0064 (r1 PTLTD  	 XSDT      50000
LTP        0)
[    0.000000] ACPI: FACP 7F6E24BE, 00F4 (r3 FSC                50000
       F4240)
[    0.000000] ACPI: DSDT 7F6E25B2, 475B (r1 FSC    D2151       50000
MSFT  3000001)
[    0.000000] ACPI: FACS 7F6E7FC0, 0040
[    0.000000] ACPI: ASF! 7F6E6D0D, 0085 (r16 OEMID  OEMTBL      50000
PTL         1)
[    0.000000] ACPI: SSDT 7F6E6D92, 00B6 (r1 FSC    EISTCPU0    50000
CSF        1)
[    0.000000] ACPI: SSDT 7F6E6E48, 00B6 (r1 FSC    EISTCPU1    50000
CSF        1)
[    0.000000] ACPI: MCFG 7F6E6EFE, 0040 (r1 PTLTD    MCFG      50000
LTP        0)
[    0.000000] ACPI: HPET 7F6E6F3E, 0038 (r1 PTLTD  HPETTBL     50000
LTP        1)
[    0.000000] ACPI: APIC 7F6E6F76, 0062 (r1 FSC    	 APIC      50000
CSF        0)
[    0.000000] ACPI: BOOT 7F6E6FD8, 0028 (r1 PTLTD  $SBFTBL$    50000
LTP        1)
[    0.000000] ACPI: DMI detected: Fujitsu Siemens
[    0.000000] ACPI: PM-Timer IO Port: 0xf008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap:
80000000:7ec00000)
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 510229
[    0.000000] Kernel command line: ro root=/dev/lvmbase/root1
printk.time=1 console=ttyS0,115200 earlyprintk=ttyS0,115200
clocksource=acpi_pm nodmraid
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2128.085 MHz processor.
[   84.043390] Console: colour VGA+ 80x25
[   84.046954] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[   84.054653] ... MAX_LOCKDEP_SUBCLASSES:      8
[   84.059065] ... MAX_LOCK_DEPTH:             30
[   84.063477] ... MAX_LOCKDEP_KEYS:         2048
[   84.067889] ... CLASSHASH_SIZE:           1024
[   84.072301] ... MAX_LOCKDEP_ENTRIES:     16384
[   84.076712] ... MAX_LOCKDEP_CHAINS:      32768
[   84.081125] ... CHAINHASH_SIZE:          16384
[   84.085537]  memory used by lock dependency info: 1568 kB
[   84.090901]  per task-struct memory footprint: 1200 bytes
[   84.096263] ------------------------
[   84.099811] | Locking API testsuite:
[   84.103358] ----------------------------------------------------------------------------
[   84.111403]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[   84.119449]
--------------------------------------------------------------------------
[   84.127498]                      A-A deadlock:  ok  |  ok  |  ok  |
 ok  |  ok  |  ok  |
[   84.135539]                  A-B-B-A deadlock:  ok  |  ok
|WARNING: at kernel/rtmutex.c:1311 try_to_take_rw_read()
[   84.145922] Pid: 0, comm: swapper Not tainted 2.6.24.7-rt27 #11
[   84.151803]  [<c010655a>] show_trace_log_lvl+0x1a/0x30
[   84.156908]  [<c0106ff2>] show_trace+0x12/0x20
[   84.161319]  [<c010780c>] dump_stack+0x6c/0x80
[   84.165731]  [<c0156256>] try_to_take_rw_read+0x546/0x590
[   84.171408]  [<c0157330>] rt_read_slowlock+0x30/0x2e0
[   84.176426]  [<c0156f7a>] rt_rwlock_read_lock+0xa/0x10
[   84.181531]  [<c04c0c32>] rt_read_lock+0x32/0x40
[   84.186115]  [<c02cefa7>] ABBA_rlock+0x17/0x60
[   84.190527]  [<c02cda47>] dotest+0x27/0x400
[   84.194680]  [<c02cf93a>] locking_selftest+0x15a/0x8a0
[   84.199785]  [<c0658b0d>] start_kernel+0x25d/0x3b0
[   84.204542]  [<00000000>] 0x0
[   84.207483]  =======================
[   84.211032] WARNING: at kernel/rtmutex.c:1704 rt_read_slowunlock()
[   84.217172] Pid: 0, comm: swapper Not tainted 2.6.24.7-rt27 #11
[   84.223055]  [<c010655a>] show_trace_log_lvl+0x1a/0x30
[   84.228159]  [<c0106ff2>] show_trace+0x12/0x20
[   84.232570]  [<c010780c>] dump_stack+0x6c/0x80
[   84.236983]  [<c04bf855>] rt_read_slowunlock+0x2e5/0x4a0
[   84.242259]  [<c0156fb6>] rt_rwlock_read_unlock+0x26/0xb0
[   84.247623]  [<c04c0bdd>] rt_read_unlock+0x1d/0x20
[   84.252381]  [<c02cefb1>] ABBA_rlock+0x21/0x60
[   84.256794]  [<c02cda47>] dotest+0x27/0x400
[   84.260946]  [<c02cf93a>] locking_selftest+0x15a/0x8a0
[   84.266051]  [<c0658b0d>] start_kernel+0x25d/0x3b0
[   84.270808]  [<00000000>] 0x0
[   84.273750]  =======================
[   84.277302]   ok  |  ok  |  ok  |  ok  |
[   84.281190]              A-B-B-C-C-A deadlock:  ok  |  ok
|<0>------------[ cut here ]------------
[   84.290187] kernel BUG at kernel/sched.c:4443!
[   84.294598] invalid opcode: 0000 [#1] PREEMPT SMP
[   84.299357] Modules linked in:
[   84.302385]
[   84.303856] Pid: 0, comm: swapper Not tainted (2.6.24.7-rt27 #11)
[   84.309911] EIP: 0060:[<c012b900>] EFLAGS: 00010092 CPU: 0
[   84.315361] EIP is at task_setprio+0x190/0x1c0
[   84.319773] EAX: c04cbba0 EBX: c05fe500 ECX: efd2e7d2 EDX: efd2e7d2
[   84.326002] ESI: c05fe500 EDI: c05fea38 EBP: c0653ef8 ESP: c0653ec0
[   84.332230]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 preempt:00000003
[   84.339065] Process swapper (pid: 0, ti=c0652000 task=c05fe500
task.ti=c0652000)
[   84.346244] Stack: c05fea4c c05fea38 c0653ee8 00000046 efd2e7d2
00000002 00000001 c05fea38
[   84.354549]        c04cbba0 c05fea38 c0653f04 c05fe500 00000286
c05fea38 c0653f04 c0155d09
[   84.362854]        c05fe500 c0653f18 c01565b9 00000000 c0649d80
c0649dac c0653f54 c04bf693
[   84.371159] Call Trace:
[   84.373754]  [<c010655a>] show_trace_log_lvl+0x1a/0x30
[   84.378858]  [<c010661e>] show_stack_log_lvl+0xae/0xe0
[   84.383962]  [<c0106714>] show_registers+0xc4/0x1f0
[   84.388807]  [<c010695b>] die+0x11b/0x230
[   84.392787]  [<c0106b03>] do_trap+0x93/0xe0
[   84.396940]  [<c0106e38>] do_invalid_op+0x88/0xa0
[   84.401611]  [<c04c1ef2>] error_code+0x72/0x78
[   84.406023]  [<c0155d09>] __rt_mutex_adjust_prio+0x19/0x20
[   84.411472]  [<c01565b9>] rt_mutex_adjust_prio+0x29/0x50
[   84.416750]  [<c04bf693>] rt_read_slowunlock+0x123/0x4a0
[   84.422027]  [<c0156fb6>] rt_rwlock_read_unlock+0x26/0xb0
[   84.427390]  [<c04c0bdd>] rt_read_unlock+0x1d/0x20
[   84.432423]  [<c02cef81>] ABBCCA_rlock+0x71/0x80
[   84.437008]  [<c02cda47>] dotest+0x27/0x400
[   84.441160]  [<c02cf9c3>] locking_selftest+0x1e3/0x8a0
[   84.446265]  [<c0658b0d>] start_kernel+0x25d/0x3b0
[   84.451023]  [<00000000>] 0x0
[   84.453964]  =======================
[   84.457511] INFO: lockdep is turned off.
[   84.461403] Code: c0 c7 44 24 08 6d 11 00 00 c7 44 24 04 aa 95 58
c0 c7 04 24 d0 1b 58 c0 e8 1e 3c 00 00 e8 a9 be fd f
f e9 1f ff ff ff 8d 74 26 00 <0f> 0b eb fe c7 44 24 0c 08 be 4c c0 c7
44 24 08 6c 11 00 00 c7
[   84.480176] EIP: [<c012b900>] task_setprio+0x190/0x1c0 SS:ESP 0068:c0653ec0
[   84.487105] ---[ end trace ca143223eefdc828 ]---
[   84.491683] Kernel panic - not syncing: Attempted to kill the idle task!
[   84.498344] Pid: 0, comm: swapper Tainted: G      D 2.6.24.7-rt27 #11
[   84.504745]  [<c010655a>] show_trace_log_lvl+0x1a/0x30
[   84.509849]  [<c0106ff2>] show_trace+0x12/0x20
[   84.514261]  [<c010780c>] dump_stack+0x6c/0x80
[   84.518673]  [<c012e831>] panic+0x51/0x110
[   84.522739]  [<c01324c0>] do_exit+0x650/0x820
[   84.527065]  [<c0106a6d>] die+0x22d/0x230
[   84.531043]  [<c0106b03>] do_trap+0x93/0xe0
[   84.535196]  [<c0106e38>] do_invalid_op+0x88/0xa0
[   84.539867]  [<c04c1ef2>] error_code+0x72/0x78
[   84.544280]  [<c0155d09>] __rt_mutex_adjust_prio+0x19/0x20
[   84.549730]  [<c01565b9>] rt_mutex_adjust_prio+0x29/0x50
[   84.555006]  [<c04bf693>] rt_read_slowunlock+0x123/0x4a0
[   84.560283]  [<c0156fb6>] rt_rwlock_read_unlock+0x26/0xb0
[   84.565648]  [<c04c0bdd>] rt_read_unlock+0x1d/0x20
[   84.570406]  [<c02cef81>] ABBCCA_rlock+0x71/0x80
[   84.574991]  [<c02cda47>] dotest+0x27/0x400
[   84.579144]  [<c02cf9c3>] locking_selftest+0x1e3/0x8a0
[   84.584247]  [<c0658b0d>] start_kernel+0x25d/0x3b0
[   84.589005]  [<00000000>] 0x0
[   84.591946]  =======================
