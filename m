Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZKKJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZKKJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZKKJSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:18:20 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41947 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZKKJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:18:17 -0500
MIME-Version: 1.0
Date: Wed, 11 Nov 2009 04:18:22 -0500
Message-ID: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
Subject: Crash during SATA reads
From: Glenn Maynard <glenn@zewt.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hitting a frequent crash during a simple 'dd if=/dev/sdb | gzip >
/dev/null'.  It's reading off of a 500G drive, and tends to reproduce
something on the order of once per 50-100 gigs of data.  I havn't yet
reproduced it without gzip in the middle.  No partitions of /dev/sdb
are mounted.  It's reproduced several times with the same trace.

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<(null)>] (null)
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file:
Modules linked in: netconsole rtc atl1c

Pid: 1311, comm: gzip Not tainted (2.6.31.6 #1) G31M-ES2L
EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
EIP is at 0x0
EAX: c1ae78c0 EBX: c107cca9 ECX: c1ae78c0 EDX: 00000000
ESI: c1ae78c0 EDI: dfa3b2c0 EBP: df29bed0 ESP: df29be94
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process gzip (pid: 1311, ti=df29a000 task=df916800 task.ti=df29a000)
Stack:
 c107ccb1 c107e549 00000200 c11587bc 00000000 00000001 df430a94 00000000
<0> 00000000 00005000 0000b000 00000000 dfa3b2c0 00000000 dfa3b2c0 dfa0f168
<0> c1158936 dfa20980 00000000 c11589ed 00000000 dfa20980 00000000 dfa3b2c0
Call Trace:
 [<c107ccb1>] ? end_bio_bh_io_sync+0x28/0x30
 [<c107e549>] ? bio_endio+0x24/0x26
 [<c11587bc>] ? blk_update_request+0xdf/0x24e
 [<c1158936>] ? blk_update_bidi_request+0xb/0x41
 [<c11589ed>] ? blk_end_bidi_request+0x10/0x4f
 [<c1158a5c>] ? blk_end_request+0x7/0xc
 [<c11abcb2>] ? scsi_end_request+0x17/0x69
 [<c11abfc3>] ? scsi_io_completion+0x173/0x335
 [<c11a8330>] ? scsi_finish_command+0x70/0x86
 [<c11ac6a6>] ? scsi_softirq_done+0xd7/0xdc
 [<c115b3f1>] ? blk_done_softirq+0x51/0x5d
 [<c101bde0>] ? __do_softirq+0x5f/0xc8
 [<c101be6b>] ? do_softirq+0x22/0x26
 [<c101becd>] ? irq_exit+0x29/0x34
 [<c1004097>] ? do_IRQ+0x53/0x63
 [<c1002ea9>] ? common_interrupt+0x29/0x30
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:df29be94
CR2: 0000000000000000
---[ end trace 79f49d6371afc159 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 1311, comm: gzip Tainted: G      D    2.6.31.6 #1
Call Trace:
 [<c101824c>] ? panic+0x41/0xde
 [<c1004dcf>] ? oops_end+0x5c/0x66
 [<c107cca9>] ? end_bio_bh_io_sync+0x20/0x30
 [<c100eca7>] ? bad_area_nosemaphore+0xa/0xc
 [<c126564e>] ? error_code+0x5e/0x64
 [<c107cca9>] ? end_bio_bh_io_sync+0x20/0x30
 [<c107007b>] ? file_update_time+0x8c/0xd8
 [<c100ee87>] ? do_page_fault+0x0/0x1f9
 [<c107ccb1>] ? end_bio_bh_io_sync+0x28/0x30
 [<c107e549>] ? bio_endio+0x24/0x26
 [<c11587bc>] ? blk_update_request+0xdf/0x24e
 [<c1158936>] ? blk_update_bidi_request+0xb/0x41
 [<c11589ed>] ? blk_end_bidi_request+0x10/0x4f
 [<c1158a5c>] ? blk_end_request+0x7/0xc
 [<c11abcb2>] ? scsi_end_request+0x17/0x69
 [<c11abfc3>] ? scsi_io_completion+0x173/0x335
 [<c11a8330>] ? scsi_finish_command+0x70/0x86
 [<c11ac6a6>] ? scsi_softirq_done+0xd7/0xdc
 [<c115b3f1>] ? blk_done_softirq+0x51/0x5d
 [<c101bde0>] ? __do_softirq+0x5f/0xc8
 [<c101be6b>] ? do_softirq+0x22/0x26
 [<c101becd>] ? irq_exit+0x29/0x34
 [<c1004097>] ? do_IRQ+0x53/0x63
 [<c1002ea9>] ? common_interrupt+0x29/0x30

0000:00:00.0 Host bridge: Intel Corporation: Unknown device 29c0 (rev 10)
        Subsystem: Giga-byte Technology: Unknown device 5000
        Flags: bus master, fast devsel, latency 0
        Capabilities: [e0] #09 [b10b]

0000:00:01.0 PCI bridge: Intel Corporation: Unknown device 29c1 (rev
10) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: f0000000-f3ffffff
        Prefetchable memory behind bridge: 00000000e0000000-00000000eff00000
        Capabilities: [88] #0d [0000]
        Capabilities: [80] Power Management version 3
        Capabilities: [90] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
        Capabilities: [a0] #10 [0141]

0000:00:1b.0 0403: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Giga-byte Technology: Unknown device a002
        Flags: bus master, fast devsel, latency 0, IRQ 12
        Memory at f4100000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
        Capabilities: [60] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
        Capabilities: [70] #10 [0091]

0000:00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 1 (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Capabilities: [40] #10 [0141]
        Capabilities: [80] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2

0000:00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 2 (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: f4000000-f40fffff
        Capabilities: [40] #10 [0141]
        Capabilities: [80] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
        Capabilities: [90] #0d [0000]
        Capabilities: [a0] Power Management version 2

0000:00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family)
USB UHCI #1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Flags: bus master, medium devsel, latency 0, IRQ 5
        I/O ports at e000 [size=32]

0000:00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family)
USB UHCI #2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Flags: bus master, medium devsel, latency 0, IRQ 11
        I/O ports at e100 [size=32]

0000:00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family)
USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Flags: bus master, medium devsel, latency 0, IRQ 3
        I/O ports at e200 [size=32]

0000:00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family)
USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Giga-byte Technology: Unknown device 5004
        Flags: bus master, medium devsel, latency 0, IRQ 12
        I/O ports at e300 [size=32]

0000:00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family)
USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Giga-byte Technology: Unknown device 5006
        Flags: bus master, medium devsel, latency 0, IRQ 5
        Memory at f4104000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2

0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
(prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 0000a000-0000afff
        Capabilities: [50] #0d [0000]

0000:00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family)
LPC Interface Bridge (rev 01)
        Subsystem: Giga-byte Technology: Unknown device 5001
        Flags: bus master, medium devsel, latency 0
        Capabilities: [e0] #09 [100c]

0000:00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7
Family) Serial ATA Storage Controllers cc=IDE (rev 01) (prog-if 8a
[Master SecP PriP])
        Subsystem: Giga-byte Technology: Unknown device b002
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 11
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at f000 [size=16]
        Capabilities: [70] Power Management version 2

0000:00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus
Controller (rev 01)
        Subsystem: Giga-byte Technology: Unknown device 5001
        Flags: medium devsel, IRQ 11
        I/O ports at 0500 [size=32]

0000:01:00.0 VGA compatible controller: nVidia Corporation: Unknown
device 06e4 (rev a1) (prog-if 00 [VGA])
        Flags: bus master, fast devsel, latency 0, IRQ 12
        Memory at f2000000 (32-bit, non-prefetchable) [size=16M]
        Memory at e0000000 (64-bit, prefetchable) [size=256M]
        Memory at f0000000 (64-bit, non-prefetchable) [size=32M]
        I/O ports at c000 [size=128]
        Expansion ROM at f3000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 3
        Capabilities: [68] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
        Capabilities: [78] #10 [0001]

0000:03:00.0 Ethernet controller: Unknown device 1969:1063 (rev c0)
        Subsystem: Giga-byte Technology: Unknown device e000
        Flags: bus master, fast devsel, latency 0, IRQ 10
        Memory at f4000000 (64-bit, non-prefetchable) [size=256K]
        I/O ports at d000 [size=128]
        Capabilities: [40] Power Management version 3
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
        Capabilities: [58] #10 [0001]
        Capabilities: [6c] Vital Product Data

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 23
model name      : Intel(R) Celeron(R) CPU        E3200  @ 2.40GHz
stepping        : 10
cpu MHz         : 2400.036
cache size      : 1024 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
lm constant_tsc arch_perfmon pebs bts pni dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm xsave lahf_lm tpr_shadow vnmi
flexpriority
bogomips        : 4800.07
clflush size    : 64
power management:

-- 
Glenn Maynard
