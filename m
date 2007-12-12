Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbXLLJMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbXLLJMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXLLJMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:12:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54310 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXLLJM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:12:27 -0500
Date: Wed, 12 Dec 2007 10:11:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [crash] kernel BUG at drivers/cpufreq/cpufreq.c:1060!
Message-ID: <20071212091144.GA11986@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


2.6.24-rc4-git5, got this cpufreq crash on x86 64-bit, during 'make 
randconfig' random bootup testing:

powernow-k8: BIOS error - no PSB or ACPI _PSS objects
------------[ cut here ]------------
kernel BUG at drivers/cpufreq/cpufreq.c:1060!
invalid opcode: 0000 [1] SMP
[...]
RIP: 0010:[<ffffffff8056021a>]  [<ffffffff8056021a>] cpufreq_remove_dev+0x160/0x2ad
[...]
Call Trace:
 [<ffffffff80455c03>] sysdev_driver_unregister+0x53/0x8a
 [<ffffffff8055f635>] cpufreq_register_driver+0x148/0x188
 [<ffffffff808436cb>] kernel_init+0x14b/0x318
 [<ffffffff8020ce78>] child_rip+0xa/0x12
 [<ffffffff80843580>] kernel_init+0x0/0x318
 [<ffffffff8020ce6e>] child_rip+0x0/0x12

kernel is 2.6.24-rc4-git5-ish + x86.git. (but no cpufreq changes to the 
upstream code) crashlog and config attached. Will try with vanilla 
-latest as well.

	Ingo

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="crash.log"
Content-Transfer-Encoding: quoted-printable

looking for log: #1926 SMP Wed Dec 12 09:43:58 CET 2007
mercury login: Linux version 2.6.24-rc4-cfs-v24 (mingo@dione) (gcc version =
4.2.2) #1926 SMP Wed Dec 12 09:43:58 CET 2007
Command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,ttyS0,115=
200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dverbose sy=
srq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=3D0 nmi_=
watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
end_pfn_map =3D 1048576
kernel direct mapping tables up to 100000000 @ 8000-d000
DMI 2.3 present.
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Bootmem setup node 0 0000000000000000-000000003fff0000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC a=
t: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 33920 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256337
Policy zone: DMA32
Kernel command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,tt=
yS0,115200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dver=
bose sysrq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=
=3D0 nmi_watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PIT
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2160.234 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Linux version 2.6.24-rc4-cfs-v24 (mingo@dione) (gcc version 4.2.2) #1926 SM=
P Wed Dec 12 09:43:58 CET 2007
Command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,ttyS0,115=
200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dverbose sy=
srq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=3D0 nmi_=
watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
end_pfn_map =3D 1048576
DMI 2.3 present.
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003fff0000
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
On node 0 totalpages: 262031
  DMA zone: 56 pages used for memmap
  DMA zone: 2111 pages reserved
  DMA zone: 1832 pages, LIFO batch:0
  DMA32 zone: 3527 pages used for memmap
  DMA32 zone: 254505 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC a=
t: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 33920 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256337
Policy zone: DMA32
Kernel command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,tt=
yS0,115200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dver=
bose sysrq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=
=3D0 nmi_watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PIT
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2160.234 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1008764k/1048512k available (4130k kernel code, 39360k reserved, 21=
09k data, 344k init)
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=3D4, CPUs=3D2, N=
odes=3D1
Calibrating delay using timer specific routine.. 4321.73 BogoMIPS (lpj=3D21=
60868)
Security Framework initialized
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 37k freed
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not co=
nnected.
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
=2E.MP-BIOS bug: 8254 timer not connected to IO-APIC
=2E..trying to set up timer (IRQ0) through the 8259A ...=20
=2E.... (found apic 0 pin 0) ... works.
activating NMI Watchdog ... done.
number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
=2E... register #00: 00000000
=2E......    : physical APIC id: 00
=2E... register #01: 00170011
=2E......     : max redirection entries: 0017
=2E......     : PRQ implemented: 0
=2E......     : IO APIC version: 0011
=2E... register #02: 00000000
=2E......     : arbitration: 00
=2E... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:  =20
 00 001 0    0    0   0   0    1    1    30
 01 001 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 001 1    1    0   1   0    1    1    33
 04 001 0    0    0   0   0    1    1    34
 05 001 1    1    0   1   0    1    1    35
 06 001 0    0    0   0   0    1    1    36
 07 001 1    0    0   0   0    1    1    37
 08 001 0    0    0   0   0    1    1    38
 09 001 0    0    0   0   0    1    1    39
 0a 001 0    0    0   0   0    1    1    3A
 0b 001 1    1    0   1   0    1    1    3B
 0c 001 0    0    0   0   0    1    1    3C
 0d 001 0    0    0   0   0    1    1    3D
 0e 001 0    0    0   0   0    1    1    3E
 0f 001 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
=2E................................... done.
Using local APIC timer interrupts.
APIC timer calibration result 13501458
Detected 13.501 MHz APIC timer.
APIC timer registered as dummy, due to nmi_watchdog=3D1!
Brought up 1 CPUs
Testing NMI watchdog ... <4>WARNING: CPU#0: NMI appears to be stuck (0->0)!
Calling initcall 0xffffffff80864d7b: init_cpufreq_transition_notifier_list+=
0x0/0x17()
initcall 0xffffffff80864d7b: init_cpufreq_transition_notifier_list+0x0/0x17=
() returned 0.
initcall 0xffffffff80864d7b ran for 0 msecs: init_cpufreq_transition_notifi=
er_list+0x0/0x17()
Calling initcall 0xffffffff80866f03: net_ns_init+0x0/0x15d()
net_namespace: 120 bytes
initcall 0xffffffff80866f03: net_ns_init+0x0/0x15d() returned 0.
initcall 0xffffffff80866f03 ran for 0 msecs: net_ns_init+0x0/0x15d()
Calling initcall 0xffffffff8084ad90: cpufreq_tsc+0x0/0x19()
initcall 0xffffffff8084ad90: cpufreq_tsc+0x0/0x19() returned 0.
initcall 0xffffffff8084ad90 ran for 0 msecs: cpufreq_tsc+0x0/0x19()
Calling initcall 0xffffffff8084d0c4: init_smp_flush+0x0/0x4c()
initcall 0xffffffff8084d0c4: init_smp_flush+0x0/0x4c() returned 0.
initcall 0xffffffff8084d0c4 ran for 0 msecs: init_smp_flush+0x0/0x4c()
Calling initcall 0xffffffff80854d13: sysctl_init+0x0/0x25()
initcall 0xffffffff80854d13: sysctl_init+0x0/0x25() returned 0.
initcall 0xffffffff80854d13 ran for 0 msecs: sysctl_init+0x0/0x25()
Calling initcall 0xffffffff808559c3: init_jiffies_clocksource+0x0/0xc()
initcall 0xffffffff808559c3: init_jiffies_clocksource+0x0/0xc() returned 0.
initcall 0xffffffff808559c3 ran for 0 msecs: init_jiffies_clocksource+0x0/0=
xc()
Calling initcall 0xffffffff808566fb: ksysfs_init+0x0/0x69()
initcall 0xffffffff808566fb: ksysfs_init+0x0/0x69() returned 0.
initcall 0xffffffff808566fb ran for 0 msecs: ksysfs_init+0x0/0x69()
Calling initcall 0xffffffff80859c52: filelock_init+0x0/0x31()
initcall 0xffffffff80859c52: filelock_init+0x0/0x31() returned 0.
initcall 0xffffffff80859c52 ran for 0 msecs: filelock_init+0x0/0x31()
Calling initcall 0xffffffff8085a6b2: init_script_binfmt+0x0/0xc()
initcall 0xffffffff8085a6b2: init_script_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8085a6b2 ran for 0 msecs: init_script_binfmt+0x0/0xc()
Calling initcall 0xffffffff8085a6be: init_elf_binfmt+0x0/0xc()
initcall 0xffffffff8085a6be: init_elf_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8085a6be ran for 0 msecs: init_elf_binfmt+0x0/0xc()
Calling initcall 0xffffffff8085b7ca: debugfs_init+0x0/0x46()
initcall 0xffffffff8085b7ca: debugfs_init+0x0/0x46() returned 0.
initcall 0xffffffff8085b7ca ran for 0 msecs: debugfs_init+0x0/0x46()
Calling initcall 0xffffffff8085c198: securityfs_init+0x0/0x44()
initcall 0xffffffff8085c198: securityfs_init+0x0/0x44() returned 0.
initcall 0xffffffff8085c198 ran for 0 msecs: securityfs_init+0x0/0x44()
Calling initcall 0xffffffff8085c426: calibrate_xor_blocks+0x0/0xb4()
xor: automatically using best checksumming function: generic_sse
   generic_sse:  6616.000 MB/sec
xor: using function: generic_sse (6616.000 MB/sec)
initcall 0xffffffff8085c426: calibrate_xor_blocks+0x0/0xb4() returned 0.
initcall 0xffffffff8085c426 ran for 7 msecs: calibrate_xor_blocks+0x0/0xb4()
Calling initcall 0xffffffff8085cb71: random32_init+0x0/0x5f()
initcall 0xffffffff8085cb71: random32_init+0x0/0x5f() returned 0.
initcall 0xffffffff8085cb71 ran for 0 msecs: random32_init+0x0/0x5f()
Calling initcall 0xffffffff80864d92: cpufreq_core_init+0x0/0x7a()
initcall 0xffffffff80864d92: cpufreq_core_init+0x0/0x7a() returned 0.
initcall 0xffffffff80864d92 ran for 0 msecs: cpufreq_core_init+0x0/0x7a()
Calling initcall 0xffffffff80866dc0: sock_init+0x0/0x70()
initcall 0xffffffff80866dc0: sock_init+0x0/0x70() returned 0.
initcall 0xffffffff80866dc0 ran for 0 msecs: sock_init+0x0/0x70()
Calling initcall 0xffffffff80867726: netpoll_init+0x0/0x2c()
initcall 0xffffffff80867726: netpoll_init+0x0/0x2c() returned 0.
initcall 0xffffffff80867726 ran for 0 msecs: netpoll_init+0x0/0x2c()
Calling initcall 0xffffffff80867cf6: netlink_proto_init+0x0/0x16f()
NET: Registered protocol family 16
initcall 0xffffffff80867cf6: netlink_proto_init+0x0/0x16f() returned 0.
initcall 0xffffffff80867cf6 ran for 0 msecs: netlink_proto_init+0x0/0x16f()
Calling initcall 0xffffffff8085ca63: kobject_uevent_init+0x0/0x4a()
initcall 0xffffffff8085ca63: kobject_uevent_init+0x0/0x4a() returned 0.
initcall 0xffffffff8085ca63 ran for 0 msecs: kobject_uevent_init+0x0/0x4a()
Calling initcall 0xffffffff8085ce82: pcibus_class_init+0x0/0xc()
initcall 0xffffffff8085ce82: pcibus_class_init+0x0/0xc() returned 0.
initcall 0xffffffff8085ce82 ran for 0 msecs: pcibus_class_init+0x0/0xc()
Calling initcall 0xffffffff8085d4df: pci_driver_init+0x0/0xc()
initcall 0xffffffff8085d4df: pci_driver_init+0x0/0xc() returned 0.
initcall 0xffffffff8085d4df ran for 0 msecs: pci_driver_init+0x0/0xc()
Calling initcall 0xffffffff8085d60d: backlight_class_init+0x0/0x4c()
initcall 0xffffffff8085d60d: backlight_class_init+0x0/0x4c() returned 0.
initcall 0xffffffff8085d60d ran for 0 msecs: backlight_class_init+0x0/0x4c()
Calling initcall 0xffffffff8085d665: video_output_class_init+0x0/0x1b()
initcall 0xffffffff8085d665: video_output_class_init+0x0/0x1b() returned 0.
initcall 0xffffffff8085d665 ran for 0 msecs: video_output_class_init+0x0/0x=
1b()
Calling initcall 0xffffffff8085d790: tty_class_init+0x0/0x2d()
initcall 0xffffffff8085d790: tty_class_init+0x0/0x2d() returned 0.
initcall 0xffffffff8085d790 ran for 0 msecs: tty_class_init+0x0/0x2d()
Calling initcall 0xffffffff8085e515: vtconsole_class_init+0x0/0xc7()
initcall 0xffffffff8085e515: vtconsole_class_init+0x0/0xc7() returned 0.
initcall 0xffffffff8085e515 ran for 0 msecs: vtconsole_class_init+0x0/0xc7()
Calling initcall 0xffffffff80860d25: register_node_type+0x0/0x6d()
initcall 0xffffffff80860d25: register_node_type+0x0/0x6d() returned 0.
initcall 0xffffffff80860d25 ran for 0 msecs: register_node_type+0x0/0x6d()
Calling initcall 0xffffffff808660d8: pci_access_init+0x0/0x48()
PCI: Using configuration type 1
initcall 0xffffffff808660d8: pci_access_init+0x0/0x48() returned 0.
initcall 0xffffffff808660d8 ran for 0 msecs: pci_access_init+0x0/0x48()
Calling initcall 0xffffffff808520f0: topology_init+0x0/0x84()
initcall 0xffffffff808520f0: topology_init+0x0/0x84() returned 0.
initcall 0xffffffff808520f0 ran for 0 msecs: topology_init+0x0/0x84()
Calling initcall 0xffffffff808553ae: param_sysfs_init+0x0/0x202()
initcall 0xffffffff808553ae: param_sysfs_init+0x0/0x202() returned 0.
initcall 0xffffffff808553ae ran for 6 msecs: param_sysfs_init+0x0/0x202()
Calling initcall 0xffffffff80858b21: readahead_init+0x0/0xc()
initcall 0xffffffff80858b21: readahead_init+0x0/0xc() returned 0.
initcall 0xffffffff80858b21 ran for 0 msecs: readahead_init+0x0/0xc()
Calling initcall 0xffffffff8085a38d: init_bio+0x0/0xee()
initcall 0xffffffff8085a38d: init_bio+0x0/0xee() returned 0.
initcall 0xffffffff8085a38d ran for 0 msecs: init_bio+0x0/0xee()
Calling initcall 0xffffffff8085c677: genhd_device_init+0x0/0x51()
initcall 0xffffffff8085c677: genhd_device_init+0x0/0x51() returned 0.
initcall 0xffffffff8085c677 ran for 0 msecs: genhd_device_init+0x0/0x51()
Calling initcall 0xffffffff8085df39: misc_init+0x0/0x85()
initcall 0xffffffff8085df39: misc_init+0x0/0x85() returned 0.
initcall 0xffffffff8085df39 ran for 0 msecs: misc_init+0x0/0x85()
Calling initcall 0xffffffff80862e60: init_scsi+0x0/0x92()
SCSI subsystem initialized
initcall 0xffffffff80862e60: init_scsi+0x0/0x92() returned 0.
initcall 0xffffffff80862e60 ran for 0 msecs: init_scsi+0x0/0x92()
Calling initcall 0xffffffff80863355: ata_init+0x0/0x8a()
libata version 3.00 loaded.
initcall 0xffffffff80863355: ata_init+0x0/0x8a() returned 0.
initcall 0xffffffff80863355 ran for 0 msecs: ata_init+0x0/0x8a()
Calling initcall 0xffffffff808635e0: usb_init+0x0/0xdb()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xffffffff808635e0: usb_init+0x0/0xdb() returned 0.
initcall 0xffffffff808635e0 ran for 3 msecs: usb_init+0x0/0xdb()
Calling initcall 0xffffffff80863ac6: serio_init+0x0/0x97()
initcall 0xffffffff80863ac6: serio_init+0x0/0x97() returned 0.
initcall 0xffffffff80863ac6 ran for 0 msecs: serio_init+0x0/0x97()
Calling initcall 0xffffffff80863c25: gameport_init+0x0/0x97()
initcall 0xffffffff80863c25: gameport_init+0x0/0x97() returned 0.
initcall 0xffffffff80863c25 ran for 0 msecs: gameport_init+0x0/0x97()
Calling initcall 0xffffffff80863ce0: input_init+0x0/0x11b()
initcall 0xffffffff80863ce0: input_init+0x0/0x11b() returned 0.
initcall 0xffffffff80863ce0 ran for 0 msecs: input_init+0x0/0x11b()
Calling initcall 0xffffffff80864c97: md_init+0x0/0xe4()
initcall 0xffffffff80864c97: md_init+0x0/0xe4() returned 0.
initcall 0xffffffff80864c97 ran for 0 msecs: md_init+0x0/0xe4()
Calling initcall 0xffffffff80864e30: leds_init+0x0/0x30()
initcall 0xffffffff80864e30: leds_init+0x0/0x30() returned 0.
initcall 0xffffffff80864e30 ran for 0 msecs: leds_init+0x0/0x30()
Calling initcall 0xffffffff80865b05: ac97_bus_init+0x0/0x1b()
initcall 0xffffffff80865b05: ac97_bus_init+0x0/0x1b() returned 0.
initcall 0xffffffff80865b05 ran for 0 msecs: ac97_bus_init+0x0/0x1b()
Calling initcall 0xffffffff80866120: pci_legacy_init+0x0/0x100()
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
initcall 0xffffffff80866120: pci_legacy_init+0x0/0x100() returned 0.
initcall 0xffffffff80866120 ran for 6 msecs: pci_legacy_init+0x0/0x100()
Calling initcall 0xffffffff808666eb: pcibios_irq_init+0x0/0x53c()
PCI: Using IRQ router default [10de/005e] at 0000:00:00.0
PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 3
PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:05:07.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 5
initcall 0xffffffff808666eb: pcibios_irq_init+0x0/0x53c() returned 0.
initcall 0xffffffff808666eb ran for 4 msecs: pcibios_irq_init+0x0/0x53c()
Calling initcall 0xffffffff80866c27: pcibios_init+0x0/0x89()
initcall 0xffffffff80866c27: pcibios_init+0x0/0x89() returned 0.
initcall 0xffffffff80866c27 ran for 0 msecs: pcibios_init+0x0/0x89()
Calling initcall 0xffffffff80866e85: proto_init+0x0/0x31()
initcall 0xffffffff80866e85: proto_init+0x0/0x31() returned 0.
initcall 0xffffffff80866e85 ran for 0 msecs: proto_init+0x0/0x31()
Calling initcall 0xffffffff80867248: net_dev_init+0x0/0x144()
initcall 0xffffffff80867248: net_dev_init+0x0/0x144() returned 0.
initcall 0xffffffff80867248 ran for 0 msecs: net_dev_init+0x0/0x144()
Calling initcall 0xffffffff808673cb: neigh_init+0x0/0x74()
initcall 0xffffffff808673cb: neigh_init+0x0/0x74() returned 0.
initcall 0xffffffff808673cb ran for 0 msecs: neigh_init+0x0/0x74()
Calling initcall 0xffffffff80867752: fib_rules_init+0x0/0x53()
initcall 0xffffffff80867752: fib_rules_init+0x0/0x53() returned 0.
initcall 0xffffffff80867752 ran for 0 msecs: fib_rules_init+0x0/0x53()
Calling initcall 0xffffffff808678d5: pktsched_init+0x0/0xc7()
initcall 0xffffffff808678d5: pktsched_init+0x0/0xc7() returned 0.
initcall 0xffffffff808678d5 ran for 0 msecs: pktsched_init+0x0/0xc7()
Calling initcall 0xffffffff808679a8: tc_filter_init+0x0/0x4f()
initcall 0xffffffff808679a8: tc_filter_init+0x0/0x4f() returned 0.
initcall 0xffffffff808679a8 ran for 0 msecs: tc_filter_init+0x0/0x4f()
Calling initcall 0xffffffff808679f7: tc_action_init+0x0/0x4f()
initcall 0xffffffff808679f7: tc_action_init+0x0/0x4f() returned 0.
initcall 0xffffffff808679f7 ran for 0 msecs: tc_action_init+0x0/0x4f()
Calling initcall 0xffffffff80867e65: genl_init+0x0/0xcb()
initcall 0xffffffff80867e65: genl_init+0x0/0xcb() returned 0.
initcall 0xffffffff80867e65 ran for 3 msecs: genl_init+0x0/0xcb()
Calling initcall 0xffffffff8086c0ca: wanrouter_init+0x0/0x4b()
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall 0xffffffff8086c0ca: wanrouter_init+0x0/0x4b() returned 0.
initcall 0xffffffff8086c0ca ran for 0 msecs: wanrouter_init+0x0/0x4b()
Calling initcall 0xffffffff8086c140: atm_init+0x0/0xaa()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xffffffff8086c140: atm_init+0x0/0xaa() returned 0.
initcall 0xffffffff8086c140 ran for 1 msecs: atm_init+0x0/0xaa()
Calling initcall 0xffffffff8086c97a: wireless_nlevent_init+0x0/0x2c()
initcall 0xffffffff8086c97a: wireless_nlevent_init+0x0/0x2c() returned 0.
initcall 0xffffffff8086c97a ran for 0 msecs: wireless_nlevent_init+0x0/0x2c=
()
Calling initcall 0xffffffff8084a9c3: pci_iommu_init+0x0/0x15()
initcall 0xffffffff8084a9c3: pci_iommu_init+0x0/0x15() returned 0.
initcall 0xffffffff8084a9c3 ran for 0 msecs: pci_iommu_init+0x0/0x15()
Calling initcall 0xffffffff8084ad28: hpet_late_init+0x0/0x58()
initcall 0xffffffff8084ad28: hpet_late_init+0x0/0x58() returned -19.
initcall 0xffffffff8084ad28 ran for 0 msecs: hpet_late_init+0x0/0x58()
Calling initcall 0xffffffff808558cc: clocksource_done_booting+0x0/0xd()
initcall 0xffffffff808558cc: clocksource_done_booting+0x0/0xd() returned 0.
initcall 0xffffffff808558cc ran for 0 msecs: clocksource_done_booting+0x0/0=
xd()
Calling initcall 0xffffffff80859be1: init_pipe_fs+0x0/0x44()
initcall 0xffffffff80859be1: init_pipe_fs+0x0/0x44() returned 0.
initcall 0xffffffff80859be1 ran for 0 msecs: init_pipe_fs+0x0/0x44()
Calling initcall 0xffffffff8085a50b: eventpoll_init+0x0/0x88()
initcall 0xffffffff8085a50b: eventpoll_init+0x0/0x88() returned 0.
initcall 0xffffffff8085a50b ran for 0 msecs: eventpoll_init+0x0/0x88()
Calling initcall 0xffffffff8085a593: anon_inode_init+0x0/0x11f()
initcall 0xffffffff8085a593: anon_inode_init+0x0/0x11f() returned 0.
initcall 0xffffffff8085a593 ran for 0 msecs: anon_inode_init+0x0/0x11f()
Calling initcall 0xffffffff8085d680: chr_dev_init+0x0/0xc7()
initcall 0xffffffff8085d680: chr_dev_init+0x0/0xc7() returned 0.
initcall 0xffffffff8085d680 ran for 0 msecs: chr_dev_init+0x0/0xc7()
Calling initcall 0xffffffff80860cbb: firmware_class_init+0x0/0x6a()
initcall 0xffffffff80860cbb: firmware_class_init+0x0/0x6a() returned 0.
initcall 0xffffffff80860cbb ran for 0 msecs: firmware_class_init+0x0/0x6a()
Calling initcall 0xffffffff808617a3: loopback_init+0x0/0xc()
initcall 0xffffffff808617a3: loopback_init+0x0/0xc() returned 0.
initcall 0xffffffff808617a3 ran for 0 msecs: loopback_init+0x0/0xc()
Calling initcall 0xffffffff80864e0c: cpufreq_gov_performance_init+0x0/0xc()
initcall 0xffffffff80864e0c: cpufreq_gov_performance_init+0x0/0xc() returne=
d 0.
initcall 0xffffffff80864e0c ran for 0 msecs: cpufreq_gov_performance_init+0=
x0/0xc()
Calling initcall 0xffffffff80865b20: pcibios_assign_resources+0x0/0x8b()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: da000000-da0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: b000-bfff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
initcall 0xffffffff80865b20: pcibios_assign_resources+0x0/0x8b() returned 0.
initcall 0xffffffff80865b20 ran for 23 msecs: pcibios_assign_resources+0x0/=
0x8b()
Calling initcall 0xffffffff80866cb0: fill_mp_bus_to_cpumask+0x0/0x110()
initcall 0xffffffff80866cb0: fill_mp_bus_to_cpumask+0x0/0x110() returned 0.
initcall 0xffffffff80866cb0 ran for 0 msecs: fill_mp_bus_to_cpumask+0x0/0x1=
10()
Calling initcall 0xffffffff80869510: inet_init+0x0/0x380()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xffffffff80869510: inet_init+0x0/0x380() returned 0.
initcall 0xffffffff80869510 ran for 20 msecs: inet_init+0x0/0x380()
Calling initcall 0xffffffff80847286: default_rootfs+0x0/0x63()
initcall 0xffffffff80847286: default_rootfs+0x0/0x63() returned 0.
initcall 0xffffffff80847286 ran for 0 msecs: default_rootfs+0x0/0x63()
Calling initcall 0xffffffff80848c78: i8259A_init_sysfs+0x0/0x29()
initcall 0xffffffff80848c78: i8259A_init_sysfs+0x0/0x29() returned 0.
initcall 0xffffffff80848c78 ran for 0 msecs: i8259A_init_sysfs+0x0/0x29()
Calling initcall 0xffffffff808491e3: vsyscall_init+0x0/0x8d()
initcall 0xffffffff808491e3: vsyscall_init+0x0/0x8d() returned 0.
initcall 0xffffffff808491e3 ran for 0 msecs: vsyscall_init+0x0/0x8d()
Calling initcall 0xffffffff80849832: sbf_init+0x0/0xde()
initcall 0xffffffff80849832: sbf_init+0x0/0xde() returned 0.
initcall 0xffffffff80849832 ran for 0 msecs: sbf_init+0x0/0xde()
Calling initcall 0xffffffff8084a748: i8237A_init_sysfs+0x0/0x29()
initcall 0xffffffff8084a748: i8237A_init_sysfs+0x0/0x29() returned 0.
initcall 0xffffffff8084a748 ran for 0 msecs: i8237A_init_sysfs+0x0/0x29()
Calling initcall 0xffffffff8084b618: cache_sysfs_init+0x0/0x40b()
initcall 0xffffffff8084b618: cache_sysfs_init+0x0/0x40b() returned 0.
initcall 0xffffffff8084b618 ran for 0 msecs: cache_sysfs_init+0x0/0x40b()
Calling initcall 0xffffffff8084c1d7: mce_init_device+0x0/0x1cb()
initcall 0xffffffff8084c1d7: mce_init_device+0x0/0x1cb() returned 0.
initcall 0xffffffff8084c1d7 ran for 0 msecs: mce_init_device+0x0/0x1cb()
Calling initcall 0xffffffff8084c0e9: periodic_mcheck_init+0x0/0x4a()
initcall 0xffffffff8084c0e9: periodic_mcheck_init+0x0/0x4a() returned 0.
initcall 0xffffffff8084c0e9 ran for 0 msecs: periodic_mcheck_init+0x0/0x4a()
Calling initcall 0xffffffff8084c403: thermal_throttle_init_device+0x0/0x7d()
initcall 0xffffffff8084c403: thermal_throttle_init_device+0x0/0x7d() return=
ed 0.
initcall 0xffffffff8084c403 ran for 0 msecs: thermal_throttle_init_device+0=
x0/0x7d()
Calling initcall 0xffffffff8084cf13: msr_init+0x0/0x116()
initcall 0xffffffff8084cf13: msr_init+0x0/0x116() returned 0.
initcall 0xffffffff8084cf13 ran for 0 msecs: msr_init+0x0/0x116()
Calling initcall 0xffffffff8084d029: microcode_init+0x0/0x9b()
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
initcall 0xffffffff8084d029: microcode_init+0x0/0x9b() returned 0.
initcall 0xffffffff8084d029 ran for 1 msecs: microcode_init+0x0/0x9b()
Calling initcall 0xffffffff8084f773: ioapic_init_sysfs+0x0/0xca()
initcall 0xffffffff8084f773: ioapic_init_sysfs+0x0/0xca() returned 0.
initcall 0xffffffff8084f773 ran for 0 msecs: ioapic_init_sysfs+0x0/0xca()
Calling initcall 0xffffffff80851f49: audit_classes_init+0x0/0x67()
initcall 0xffffffff80851f49: audit_classes_init+0x0/0x67() returned 0.
initcall 0xffffffff80851f49 ran for 0 msecs: audit_classes_init+0x0/0x67()
Calling initcall 0xffffffff80852174: add_pcspkr+0x0/0x4c()
initcall 0xffffffff80852174: add_pcspkr+0x0/0x4c() returned 0.
initcall 0xffffffff80852174 ran for 0 msecs: add_pcspkr+0x0/0x4c()
Calling initcall 0xffffffff808536e6: init_vdso_vars+0x0/0x20a()
initcall 0xffffffff808536e6: init_vdso_vars+0x0/0x20a() returned 0.
initcall 0xffffffff808536e6 ran for 0 msecs: init_vdso_vars+0x0/0x20a()
Calling initcall 0xffffffff80854763: create_proc_profile+0x0/0x2d7()
initcall 0xffffffff80854763: create_proc_profile+0x0/0x2d7() returned 0.
initcall 0xffffffff80854763 ran for 0 msecs: create_proc_profile+0x0/0x2d7()
Calling initcall 0xffffffff80854bd6: ioresources_init+0x0/0x45()
initcall 0xffffffff80854bd6: ioresources_init+0x0/0x45() returned 0.
initcall 0xffffffff80854bd6 ran for 0 msecs: ioresources_init+0x0/0x45()
Calling initcall 0xffffffff80854f2f: uid_cache_init+0x0/0x7f()
initcall 0xffffffff80854f2f: uid_cache_init+0x0/0x7f() returned 0.
initcall 0xffffffff80854f2f ran for 0 msecs: uid_cache_init+0x0/0x7f()
Calling initcall 0xffffffff808555b0: init_posix_timers+0x0/0xa6()
initcall 0xffffffff808555b0: init_posix_timers+0x0/0xa6() returned 0.
initcall 0xffffffff808555b0 ran for 0 msecs: init_posix_timers+0x0/0xa6()
Calling initcall 0xffffffff80855656: init_posix_cpu_timers+0x0/0xc6()
initcall 0xffffffff80855656: init_posix_cpu_timers+0x0/0xc6() returned 0.
initcall 0xffffffff80855656 ran for 0 msecs: init_posix_cpu_timers+0x0/0xc6=
()
Calling initcall 0xffffffff80855788: latency_init+0x0/0x26()
initcall 0xffffffff80855788: latency_init+0x0/0x26() returned 0.
initcall 0xffffffff80855788 ran for 0 msecs: latency_init+0x0/0x26()
Calling initcall 0xffffffff808557ae: nsproxy_cache_init+0x0/0x30()
initcall 0xffffffff808557ae: nsproxy_cache_init+0x0/0x30() returned 0.
initcall 0xffffffff808557ae ran for 0 msecs: nsproxy_cache_init+0x0/0x30()
Calling initcall 0xffffffff808557de: timekeeping_init_device+0x0/0x29()
initcall 0xffffffff808557de: timekeeping_init_device+0x0/0x29() returned 0.
initcall 0xffffffff808557de ran for 0 msecs: timekeeping_init_device+0x0/0x=
29()
Calling initcall 0xffffffff808558d9: init_clocksource_sysfs+0x0/0x57()
initcall 0xffffffff808558d9: init_clocksource_sysfs+0x0/0x57() returned 0.
initcall 0xffffffff808558d9 ran for 0 msecs: init_clocksource_sysfs+0x0/0x5=
7()
Calling initcall 0xffffffff808559cf: init_timer_list_procfs+0x0/0x32()
initcall 0xffffffff808559cf: init_timer_list_procfs+0x0/0x32() returned 0.
initcall 0xffffffff808559cf ran for 0 msecs: init_timer_list_procfs+0x0/0x3=
2()
Calling initcall 0xffffffff80855a5b: init+0x0/0xe0()
initcall 0xffffffff80855a5b: init+0x0/0xe0() returned 0.
initcall 0xffffffff80855a5b ran for 0 msecs: init+0x0/0xe0()
Calling initcall 0xffffffff80855b3b: proc_dma_init+0x0/0x28()
initcall 0xffffffff80855b3b: proc_dma_init+0x0/0x28() returned 0.
initcall 0xffffffff80855b3b ran for 0 msecs: proc_dma_init+0x0/0x28()
Calling initcall 0xffffffff80247593: percpu_modinit+0x0/0x79()
initcall 0xffffffff80247593: percpu_modinit+0x0/0x79() returned 0.
initcall 0xffffffff80247593 ran for 0 msecs: percpu_modinit+0x0/0x79()
Calling initcall 0xffffffff80855dca: kallsyms_init+0x0/0x36()
initcall 0xffffffff80855dca: kallsyms_init+0x0/0x36() returned 0.
initcall 0xffffffff80855dca ran for 0 msecs: kallsyms_init+0x0/0x36()
Calling initcall 0xffffffff80855e42: crash_save_vmcoreinfo_init+0x0/0x3c6()
initcall 0xffffffff80855e42: crash_save_vmcoreinfo_init+0x0/0x3c6() returne=
d 0.
initcall 0xffffffff80855e42 ran for 0 msecs: crash_save_vmcoreinfo_init+0x0=
/0x3c6()
Calling initcall 0xffffffff80855e00: crash_notes_memory_init+0x0/0x42()
initcall 0xffffffff80855e00: crash_notes_memory_init+0x0/0x42() returned 0.
initcall 0xffffffff80855e00 ran for 0 msecs: crash_notes_memory_init+0x0/0x=
42()
Calling initcall 0xffffffff8085655e: audit_init+0x0/0x102()
audit: initializing netlink socket (disabled)
audit(1197457090.053:1): initialized
initcall 0xffffffff8085655e: audit_init+0x0/0x102() returned 0.
initcall 0xffffffff8085655e ran for 1 msecs: audit_init+0x0/0x102()
Calling initcall 0xffffffff808567cc: relay_init+0x0/0x3()
initcall 0xffffffff808567cc: relay_init+0x0/0x3() returned 0.
initcall 0xffffffff808567cc ran for 0 msecs: relay_init+0x0/0x3()
Calling initcall 0xffffffff808567cf: utsname_sysctl_init+0x0/0x21()
initcall 0xffffffff808567cf: utsname_sysctl_init+0x0/0x21() returned 0.
initcall 0xffffffff808567cf ran for 0 msecs: utsname_sysctl_init+0x0/0x21()
Calling initcall 0xffffffff80857871: init_per_zone_pages_min+0x0/0x56()
initcall 0xffffffff80857871: init_per_zone_pages_min+0x0/0x56() returned 0.
initcall 0xffffffff80857871 ran for 0 msecs: init_per_zone_pages_min+0x0/0x=
56()
Calling initcall 0xffffffff80858b0c: pdflush_init+0x0/0x15()
initcall 0xffffffff80858b0c: pdflush_init+0x0/0x15() returned 0.
initcall 0xffffffff80858b0c ran for 0 msecs: pdflush_init+0x0/0x15()
Calling initcall 0xffffffff80858b48: kswapd_init+0x0/0x5a()
initcall 0xffffffff80858b48: kswapd_init+0x0/0x5a() returned 0.
initcall 0xffffffff80858b48 ran for 0 msecs: kswapd_init+0x0/0x5a()
Calling initcall 0xffffffff80858c03: setup_vmstat+0x0/0x45()
initcall 0xffffffff80858c03: setup_vmstat+0x0/0x45() returned 0.
initcall 0xffffffff80858c03 ran for 0 msecs: setup_vmstat+0x0/0x45()
Calling initcall 0xffffffff80858cfd: hugetlb_init+0x0/0xa0()
Total HugeTLB memory allocated, 0
initcall 0xffffffff80858cfd: hugetlb_init+0x0/0xa0() returned 0.
initcall 0xffffffff80858cfd ran for 0 msecs: hugetlb_init+0x0/0xa0()
Calling initcall 0xffffffff80859556: init_tmpfs+0x0/0xda()
initcall 0xffffffff80859556: init_tmpfs+0x0/0xda() returned 0.
initcall 0xffffffff80859556 ran for 0 msecs: init_tmpfs+0x0/0xda()
Calling initcall 0xffffffff808598cd: slab_sysfs_init+0x0/0xcd()
initcall 0xffffffff808598cd: slab_sysfs_init+0x0/0xcd() returned 0.
initcall 0xffffffff808598cd ran for 7 msecs: slab_sysfs_init+0x0/0xcd()
Calling initcall 0xffffffff80859c25: fasync_init+0x0/0x2d()
initcall 0xffffffff80859c25: fasync_init+0x0/0x2d() returned 0.
initcall 0xffffffff80859c25 ran for 0 msecs: fasync_init+0x0/0x2d()
Calling initcall 0xffffffff8085a2a8: aio_setup+0x0/0x6e()
initcall 0xffffffff8085a2a8: aio_setup+0x0/0x6e() returned 0.
initcall 0xffffffff8085a2a8 ran for 0 msecs: aio_setup+0x0/0x6e()
Calling initcall 0xffffffff8085a4fe: inotify_setup+0x0/0xd()
initcall 0xffffffff8085a4fe: inotify_setup+0x0/0xd() returned 0.
initcall 0xffffffff8085a4fe ran for 0 msecs: inotify_setup+0x0/0xd()
Calling initcall 0xffffffff8085a6ca: init_mbcache+0x0/0x17()
initcall 0xffffffff8085a6ca: init_mbcache+0x0/0x17() returned 0.
initcall 0xffffffff8085a6ca ran for 0 msecs: init_mbcache+0x0/0x17()
Calling initcall 0xffffffff8085a6e1: dnotify_init+0x0/0x2d()
initcall 0xffffffff8085a6e1: dnotify_init+0x0/0x2d() returned 0.
initcall 0xffffffff8085a6e1 ran for 0 msecs: dnotify_init+0x0/0x2d()
Calling initcall 0xffffffff8085abca: configfs_init+0x0/0xce()
initcall 0xffffffff8085abca: configfs_init+0x0/0xce() returned 0.
initcall 0xffffffff8085abca ran for 0 msecs: configfs_init+0x0/0xce()
Calling initcall 0xffffffff8085ac98: init_devpts_fs+0x0/0x38()
initcall 0xffffffff8085ac98: init_devpts_fs+0x0/0x38() returned 0.
initcall 0xffffffff8085ac98 ran for 0 msecs: init_devpts_fs+0x0/0x38()
Calling initcall 0xffffffff8085acd0: init_reiserfs_fs+0x0/0x80()
initcall 0xffffffff8085acd0: init_reiserfs_fs+0x0/0x80() returned 0.
initcall 0xffffffff8085acd0 ran for 0 msecs: init_reiserfs_fs+0x0/0x80()
Calling initcall 0xffffffff8085ad50: init_ext3_fs+0x0/0x61()
initcall 0xffffffff8085ad50: init_ext3_fs+0x0/0x61() returned 0.
initcall 0xffffffff8085ad50 ran for 0 msecs: init_ext3_fs+0x0/0x61()
Calling initcall 0xffffffff8085ae70: journal_init+0x0/0x9a()
initcall 0xffffffff8085ae70: journal_init+0x0/0x9a() returned 0.
initcall 0xffffffff8085ae70 ran for 0 msecs: journal_init+0x0/0x9a()
Calling initcall 0xffffffff8085af0a: init_ramfs_fs+0x0/0xc()
initcall 0xffffffff8085af0a: init_ramfs_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085af0a ran for 0 msecs: init_ramfs_fs+0x0/0xc()
Calling initcall 0xffffffff8085af4f: init_hugetlbfs_fs+0x0/0x94()
initcall 0xffffffff8085af4f: init_hugetlbfs_fs+0x0/0x94() returned 0.
initcall 0xffffffff8085af4f ran for 0 msecs: init_hugetlbfs_fs+0x0/0x94()
Calling initcall 0xffffffff8085afe3: init_coda+0x0/0x17d()
initcall 0xffffffff8085afe3: init_coda+0x0/0x17d() returned 0.
initcall 0xffffffff8085afe3 ran for 0 msecs: init_coda+0x0/0x17d()
Calling initcall 0xffffffff8085b160: init_minix_fs+0x0/0x51()
initcall 0xffffffff8085b160: init_minix_fs+0x0/0x51() returned 0.
initcall 0xffffffff8085b160 ran for 0 msecs: init_minix_fs+0x0/0x51()
Calling initcall 0xffffffff8085b1e9: init_fat_fs+0x0/0x47()
initcall 0xffffffff8085b1e9: init_fat_fs+0x0/0x47() returned 0.
initcall 0xffffffff8085b1e9 ran for 0 msecs: init_fat_fs+0x0/0x47()
Calling initcall 0xffffffff8085b230: init_msdos_fs+0x0/0xc()
initcall 0xffffffff8085b230: init_msdos_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085b230 ran for 0 msecs: init_msdos_fs+0x0/0xc()
Calling initcall 0xffffffff8085b23c: init_vfat_fs+0x0/0x14()
initcall 0xffffffff8085b23c: init_vfat_fs+0x0/0x14() returned 0.
initcall 0xffffffff8085b23c ran for 0 msecs: init_vfat_fs+0x0/0x14()
Calling initcall 0xffffffff8085b250: init_iso9660_fs+0x0/0x63()
initcall 0xffffffff8085b250: init_iso9660_fs+0x0/0x63() returned 0.
initcall 0xffffffff8085b250 ran for 0 msecs: init_iso9660_fs+0x0/0x63()
Clocksource tsc unstable (delta =3D 715947801 ns)
Calling initcall 0xffffffff8085b2d9: init_hfsplus_fs+0x0/0x57()
initcall 0xffffffff8085b2d9: init_hfsplus_fs+0x0/0x57() returned 0.
initcall 0xffffffff8085b2d9 ran for 0 msecs: init_hfsplus_fs+0x0/0x57()
Calling initcall 0xffffffff8085b330: ecryptfs_init+0x0/0x1dd()
initcall 0xffffffff8085b330: ecryptfs_init+0x0/0x1dd() returned 0.
initcall 0xffffffff8085b330 ran for 1 msecs: ecryptfs_init+0x0/0x1dd()
Calling initcall 0xffffffff8085b50d: init_nls_cp737+0x0/0xc()
initcall 0xffffffff8085b50d: init_nls_cp737+0x0/0xc() returned 0.
initcall 0xffffffff8085b50d ran for 0 msecs: init_nls_cp737+0x0/0xc()
Calling initcall 0xffffffff8085b519: init_nls_cp852+0x0/0xc()
initcall 0xffffffff8085b519: init_nls_cp852+0x0/0xc() returned 0.
initcall 0xffffffff8085b519 ran for 0 msecs: init_nls_cp852+0x0/0xc()
Calling initcall 0xffffffff8085b525: init_nls_cp860+0x0/0xc()
initcall 0xffffffff8085b525: init_nls_cp860+0x0/0xc() returned 0.
initcall 0xffffffff8085b525 ran for 0 msecs: init_nls_cp860+0x0/0xc()
Calling initcall 0xffffffff8085b531: init_nls_cp861+0x0/0xc()
initcall 0xffffffff8085b531: init_nls_cp861+0x0/0xc() returned 0.
initcall 0xffffffff8085b531 ran for 0 msecs: init_nls_cp861+0x0/0xc()
Calling initcall 0xffffffff8085b53d: init_nls_cp932+0x0/0xc()
initcall 0xffffffff8085b53d: init_nls_cp932+0x0/0xc() returned 0.
initcall 0xffffffff8085b53d ran for 0 msecs: init_nls_cp932+0x0/0xc()
Calling initcall 0xffffffff8085b549: init_nls_euc_jp+0x0/0x4f()
initcall 0xffffffff8085b549: init_nls_euc_jp+0x0/0x4f() returned 0.
initcall 0xffffffff8085b549 ran for 0 msecs: init_nls_euc_jp+0x0/0x4f()
Calling initcall 0xffffffff8085b598: init_nls_cp949+0x0/0xc()
initcall 0xffffffff8085b598: init_nls_cp949+0x0/0xc() returned 0.
initcall 0xffffffff8085b598 ran for 0 msecs: init_nls_cp949+0x0/0xc()
Calling initcall 0xffffffff8085b5a4: init_nls_cp950+0x0/0xc()
initcall 0xffffffff8085b5a4: init_nls_cp950+0x0/0xc() returned 0.
initcall 0xffffffff8085b5a4 ran for 0 msecs: init_nls_cp950+0x0/0xc()
Calling initcall 0xffffffff8085b5b0: init_nls_cp1250+0x0/0xc()
initcall 0xffffffff8085b5b0: init_nls_cp1250+0x0/0xc() returned 0.
initcall 0xffffffff8085b5b0 ran for 0 msecs: init_nls_cp1250+0x0/0xc()
Calling initcall 0xffffffff8085b5bc: init_nls_ascii+0x0/0xc()
initcall 0xffffffff8085b5bc: init_nls_ascii+0x0/0xc() returned 0.
initcall 0xffffffff8085b5bc ran for 0 msecs: init_nls_ascii+0x0/0xc()
Calling initcall 0xffffffff8085b5c8: init_nls_iso8859_4+0x0/0xc()
initcall 0xffffffff8085b5c8: init_nls_iso8859_4+0x0/0xc() returned 0.
initcall 0xffffffff8085b5c8 ran for 0 msecs: init_nls_iso8859_4+0x0/0xc()
Calling initcall 0xffffffff8085b5d4: init_nls_iso8859_6+0x0/0xc()
initcall 0xffffffff8085b5d4: init_nls_iso8859_6+0x0/0xc() returned 0.
initcall 0xffffffff8085b5d4 ran for 0 msecs: init_nls_iso8859_6+0x0/0xc()
Calling initcall 0xffffffff8085b5e0: init_nls_cp1255+0x0/0xc()
initcall 0xffffffff8085b5e0: init_nls_cp1255+0x0/0xc() returned 0.
initcall 0xffffffff8085b5e0 ran for 0 msecs: init_nls_cp1255+0x0/0xc()
Calling initcall 0xffffffff8085b5ec: init_nls_iso8859_15+0x0/0xc()
initcall 0xffffffff8085b5ec: init_nls_iso8859_15+0x0/0xc() returned 0.
initcall 0xffffffff8085b5ec ran for 0 msecs: init_nls_iso8859_15+0x0/0xc()
Calling initcall 0xffffffff8085b5f8: init_nls_utf8+0x0/0x38()
initcall 0xffffffff8085b5f8: init_nls_utf8+0x0/0x38() returned 0.
initcall 0xffffffff8085b5f8 ran for 0 msecs: init_nls_utf8+0x0/0x38()
Calling initcall 0xffffffff8085b630: init_smb_fs+0x0/0x70()
initcall 0xffffffff8085b630: init_smb_fs+0x0/0x70() returned 0.
initcall 0xffffffff8085b630 ran for 0 msecs: init_smb_fs+0x0/0x70()
Calling initcall 0xffffffff8085b6a0: init_affs_fs+0x0/0x60()
initcall 0xffffffff8085b6a0: init_affs_fs+0x0/0x60() returned 0.
initcall 0xffffffff8085b6a0 ran for 0 msecs: init_affs_fs+0x0/0x60()
Calling initcall 0xffffffff8085b700: init_romfs_fs+0x0/0x60()
initcall 0xffffffff8085b700: init_romfs_fs+0x0/0x60() returned 0.
initcall 0xffffffff8085b700 ran for 0 msecs: init_romfs_fs+0x0/0x60()
Calling initcall 0xffffffff8085b760: init_qnx4_fs+0x0/0x5e()
QNX4 filesystem 0.2.3 registered.
initcall 0xffffffff8085b760: init_qnx4_fs+0x0/0x5e() returned 0.
initcall 0xffffffff8085b760 ran for 1 msecs: init_qnx4_fs+0x0/0x5e()
Calling initcall 0xffffffff8085b7be: init_autofs_fs+0x0/0xc()
initcall 0xffffffff8085b7be: init_autofs_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085b7be ran for 0 msecs: init_autofs_fs+0x0/0xc()
Calling initcall 0xffffffff8085b810: ocfs2_init+0x0/0x298()
OCFS2 1.3.3
initcall 0xffffffff8085b810: ocfs2_init+0x0/0x298() returned 0.
initcall 0xffffffff8085b810 ran for 0 msecs: ocfs2_init+0x0/0x298()
Calling initcall 0xffffffff8085bb40: init_o2nm+0x0/0xd0()
OCFS2 Node Manager 1.3.3
initcall 0xffffffff8085bb40: init_o2nm+0x0/0xd0() returned 0.
initcall 0xffffffff8085bb40 ran for 1 msecs: init_o2nm+0x0/0xd0()
Calling initcall 0xffffffff8085bc10: dlm_init+0x0/0xd2()
OCFS2 DLM 1.3.3
initcall 0xffffffff8085bc10: dlm_init+0x0/0xd2() returned 0.
initcall 0xffffffff8085bc10 ran for 0 msecs: dlm_init+0x0/0xd2()
Calling initcall 0xffffffff8085bce2: init_dlmfs_fs+0x0/0xce()
OCFS2 DLMFS 1.3.3
OCFS2 User DLM kernel interface loaded
initcall 0xffffffff8085bce2: init_dlmfs_fs+0x0/0xce() returned 0.
initcall 0xffffffff8085bce2 ran for 1 msecs: init_dlmfs_fs+0x0/0xce()
Calling initcall 0xffffffff8085be80: init_gfs2_fs+0x0/0x140()
GFS2 (built Dec 12 2007 09:43:29) installed
initcall 0xffffffff8085be80: init_gfs2_fs+0x0/0x140() returned 0.
initcall 0xffffffff8085be80 ran for 2 msecs: init_gfs2_fs+0x0/0x140()
Calling initcall 0xffffffff8085c119: key_proc_init+0x0/0x34()
initcall 0xffffffff8085c119: key_proc_init+0x0/0x34() returned 0.
initcall 0xffffffff8085c119 ran for 0 msecs: key_proc_init+0x0/0x34()
Calling initcall 0xffffffff8085c287: crypto_algapi_init+0x0/0x10()
initcall 0xffffffff8085c287: crypto_algapi_init+0x0/0x10() returned 0.
initcall 0xffffffff8085c287 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
Calling initcall 0xffffffff8085c2bd: cryptomgr_init+0x0/0xc()
initcall 0xffffffff8085c2bd: cryptomgr_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2bd ran for 0 msecs: cryptomgr_init+0x0/0xc()
Calling initcall 0xffffffff8085c2c9: hmac_module_init+0x0/0xc()
initcall 0xffffffff8085c2c9: hmac_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2c9 ran for 0 msecs: hmac_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c2d5: init+0x0/0xc()
initcall 0xffffffff8085c2d5: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2d5 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c2e1: init+0x0/0xc()
initcall 0xffffffff8085c2e1: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2e1 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c2ed: init+0x0/0x67()
initcall 0xffffffff8085c2ed: init+0x0/0x67() returned 0.
initcall 0xffffffff8085c2ed ran for 0 msecs: init+0x0/0x67()
Calling initcall 0xffffffff8085c354: crypto_cbc_module_init+0x0/0xc()
initcall 0xffffffff8085c354: crypto_cbc_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c354 ran for 0 msecs: crypto_cbc_module_init+0x0/0xc=
()
Calling initcall 0xffffffff8085c360: crypto_module_init+0x0/0xc()
initcall 0xffffffff8085c360: crypto_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c360 ran for 0 msecs: crypto_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c36c: crypto_module_init+0x0/0xc()
initcall 0xffffffff8085c36c: crypto_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c36c ran for 0 msecs: crypto_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c378: init+0x0/0x39()
initcall 0xffffffff8085c378: init+0x0/0x39() returned 0.
initcall 0xffffffff8085c378 ran for 0 msecs: init+0x0/0x39()
Calling initcall 0xffffffff8085c3b1: init+0x0/0xc()
initcall 0xffffffff8085c3b1: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c3b1 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c3bd: init+0x0/0x39()
initcall 0xffffffff8085c3bd: init+0x0/0x39() returned 0.
initcall 0xffffffff8085c3bd ran for 0 msecs: init+0x0/0x39()
Calling initcall 0xffffffff8085c3f6: init+0x0/0xc()
initcall 0xffffffff8085c3f6: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c3f6 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c402: init+0x0/0xc()
initcall 0xffffffff8085c402: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c402 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c40e: init+0x0/0xc()
initcall 0xffffffff8085c40e: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c40e ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c41a: init+0x0/0xc()
initcall 0xffffffff8085c41a: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c41a ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c4da: async_tx_init+0x0/0x19()
async_tx: api initialized (sync-only)
initcall 0xffffffff8085c4da: async_tx_init+0x0/0x19() returned 0.
initcall 0xffffffff8085c4da ran for 0 msecs: async_tx_init+0x0/0x19()
Calling initcall 0xffffffff8085c4f3: async_memcpy_init+0x0/0x3()
initcall 0xffffffff8085c4f3: async_memcpy_init+0x0/0x3() returned 0.
initcall 0xffffffff8085c4f3 ran for 0 msecs: async_memcpy_init+0x0/0x3()
Calling initcall 0xffffffff8085c4f6: async_xor_init+0x0/0x3()
initcall 0xffffffff8085c4f6: async_xor_init+0x0/0x3() returned 0.
initcall 0xffffffff8085c4f6 ran for 0 msecs: async_xor_init+0x0/0x3()
Calling initcall 0xffffffff8085c824: bsg_init+0x0/0x143()
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall 0xffffffff8085c824: bsg_init+0x0/0x143() returned 0.
initcall 0xffffffff8085c824 ran for 0 msecs: bsg_init+0x0/0x143()
Calling initcall 0xffffffff8085c967: noop_init+0x0/0xc()
io scheduler noop registered
initcall 0xffffffff8085c967: noop_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c967 ran for 0 msecs: noop_init+0x0/0xc()
Calling initcall 0xffffffff8085c973: deadline_init+0x0/0xc()
io scheduler deadline registered (default)
initcall 0xffffffff8085c973: deadline_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c973 ran for 0 msecs: deadline_init+0x0/0xc()
Calling initcall 0xffffffff8085c97f: blk_trace_init+0x0/0xe4()
initcall 0xffffffff8085c97f: blk_trace_init+0x0/0xe4() returned 0.
initcall 0xffffffff8085c97f ran for 0 msecs: blk_trace_init+0x0/0xe4()
Calling initcall 0xffffffff8085cc47: init_kmp+0x0/0xc()
initcall 0xffffffff8085cc47: init_kmp+0x0/0xc() returned 0.
initcall 0xffffffff8085cc47 ran for 0 msecs: init_kmp+0x0/0xc()
Calling initcall 0xffffffff803fb2c9: pci_init+0x0/0x2d()
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
Boot video device is 0000:01:00.0
initcall 0xffffffff803fb2c9: pci_init+0x0/0x2d() returned 0.
initcall 0xffffffff803fb2c9 ran for 19 msecs: pci_init+0x0/0x2d()
Calling initcall 0xffffffff8085d53e: pci_proc_init+0x0/0x6a()
initcall 0xffffffff8085d53e: pci_proc_init+0x0/0x6a() returned 0.
initcall 0xffffffff8085d53e ran for 0 msecs: pci_proc_init+0x0/0x6a()
Calling initcall 0xffffffff8085d659: corgibl_init+0x0/0xc()
initcall 0xffffffff8085d659: corgibl_init+0x0/0xc() returned 0.
initcall 0xffffffff8085d659 ran for 0 msecs: corgibl_init+0x0/0xc()
Calling initcall 0xffffffff8085d747: rand_initialize+0x0/0x2f()
initcall 0xffffffff8085d747: rand_initialize+0x0/0x2f() returned 0.
initcall 0xffffffff8085d747 ran for 0 msecs: rand_initialize+0x0/0x2f()
Calling initcall 0xffffffff8085d7bd: tty_init+0x0/0x1ec()
initcall 0xffffffff8085d7bd: tty_init+0x0/0x1ec() returned 0.
initcall 0xffffffff8085d7bd ran for 5 msecs: tty_init+0x0/0x1ec()
Calling initcall 0xffffffff8085d9db: pty_init+0x0/0x55e()
initcall 0xffffffff8085d9db: pty_init+0x0/0x55e() returned 0.
initcall 0xffffffff8085d9db ran for 47 msecs: pty_init+0x0/0x55e()
Calling initcall 0xffffffff8085e610: mxser_module_init+0x0/0x890()
MOXA Smartio/Industio family driver version 1.8
initcall 0xffffffff8085e610: mxser_module_init+0x0/0x890() returned 0.
initcall 0xffffffff8085e610 ran for 4 msecs: mxser_module_init+0x0/0x890()
Calling initcall 0xffffffff8085eea0: mxser_module_init+0x0/0x790()
MOXA Smartio/Industio family driver version 2.0.2
Couldn't install MOXA Smartio/Industio family tty driver !
initcall 0xffffffff8085eea0: mxser_module_init+0x0/0x790() returned -16.
initcall 0xffffffff8085eea0 ran for 1 msecs: mxser_module_init+0x0/0x790()
initcall at 0xffffffff8085eea0: mxser_module_init+0x0/0x790(): returned wit=
h error code -16
Calling initcall 0xffffffff8085f630: synclink_init+0x0/0x2a8()
SyncLink serial driver $Revision: 4.38 $
SyncLink serial driver $Revision: 4.38 $, tty major#253
initcall 0xffffffff8085f630: synclink_init+0x0/0x2a8() returned 0.
initcall 0xffffffff8085f630 ran for 15 msecs: synclink_init+0x0/0x2a8()
Calling initcall 0xffffffff8085f8d8: slgt_init+0x0/0x208()
SyncLink GT $Revision: 4.50 $
SyncLink GT $Revision: 4.50 $, tty major#252
SyncLink GT no devices found
initcall 0xffffffff8085f8d8: slgt_init+0x0/0x208() returned 0.
initcall 0xffffffff8085f8d8 ran for 3 msecs: slgt_init+0x0/0x208()
Calling initcall 0xffffffff8085fae0: sx_init+0x0/0x10c()
initcall 0xffffffff8085fae0: sx_init+0x0/0x10c() returned 0.
initcall 0xffffffff8085fae0 ran for 0 msecs: sx_init+0x0/0x10c()
Calling initcall 0xffffffff8085fbec: nvram_init+0x0/0x82()
Non-volatile memory driver v1.2
initcall 0xffffffff8085fbec: nvram_init+0x0/0x82() returned 0.
initcall 0xffffffff8085fbec ran for 0 msecs: nvram_init+0x0/0x82()
Calling initcall 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2()
telclk_interrup =3D 0xf non-mcpbl0010 hw.
initcall 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2() returned -6.
initcall 0xffffffff8085fc6e ran for 0 msecs: tlclk_init+0x0/0x1c2()
initcall at 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2(): returned with error=
 code -6
Calling initcall 0xffffffff8085fe8c: agp_init+0x0/0x34()
Linux agpgart interface v0.102
initcall 0xffffffff8085fe8c: agp_init+0x0/0x34() returned 0.
initcall 0xffffffff8085fe8c ran for 0 msecs: agp_init+0x0/0x34()
Calling initcall 0xffffffff8085ff8b: agp_intel_init+0x0/0x25()
initcall 0xffffffff8085ff8b: agp_intel_init+0x0/0x25() returned 0.
initcall 0xffffffff8085ff8b ran for 0 msecs: agp_intel_init+0x0/0x25()
Calling initcall 0xffffffff8085ffb0: drm_core_init+0x0/0x148()
[drm] Initialized drm 1.1.0 20060810
initcall 0xffffffff8085ffb0: drm_core_init+0x0/0x148() returned 0.
initcall 0xffffffff8085ffb0 ran for 0 msecs: drm_core_init+0x0/0x148()
Calling initcall 0xffffffff808600f8: tdfx_init+0x0/0xc()
initcall 0xffffffff808600f8: tdfx_init+0x0/0xc() returned 0.
initcall 0xffffffff808600f8 ran for 0 msecs: tdfx_init+0x0/0xc()
Calling initcall 0xffffffff80860104: i915_init+0x0/0x1c()
initcall 0xffffffff80860104: i915_init+0x0/0x1c() returned 0.
initcall 0xffffffff80860104 ran for 0 msecs: i915_init+0x0/0x1c()
Calling initcall 0xffffffff808605b3: serial8250_init+0x0/0x143()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
=A1=AE=96W+=8B=92=AA=82=D2=02=A2=D1=E5M=C1=81=85=D1=81%=BD=3D=81=C1=E1=CD=
=99=E1=81=A1=A5=C9=C5=81=F5=81=D1=A5=81=A5=CD=81=85=81=C5=D9=D5=D5=C15)=FFi=
nitcall 0xffffffff808605b3: serial8250_init+0x0/0x143() returned 0.
initcall 0xffffffff808605b3 ran for 2 msecs: serial8250_init+0x0/0x143()
Calling initcall 0xffffffff808606f6: serial8250_pci_init+0x0/0x15()
initcall 0xffffffff808606f6: serial8250_pci_init+0x0/0x15() returned 0.
initcall 0xffffffff808606f6 ran for 0 msecs: serial8250_pci_init+0x0/0x15()
Calling initcall 0xffffffff80860b68: parport_default_proc_register+0x0/0x28=
()
initcall 0xffffffff80860b68: parport_default_proc_register+0x0/0x28() retur=
ned 0.
initcall 0xffffffff80860b68 ran for 0 msecs: parport_default_proc_register+=
0x0/0x28()
Calling initcall 0xffffffff80860d92: topology_sysfs_init+0x0/0x5e()
initcall 0xffffffff80860d92: topology_sysfs_init+0x0/0x5e() returned 0.
initcall 0xffffffff80860d92 ran for 0 msecs: topology_sysfs_init+0x0/0x5e()
Calling initcall 0xffffffff80860df0: rd_init+0x0/0x1f0()
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
initcall 0xffffffff80860df0: rd_init+0x0/0x1f0() returned 0.
initcall 0xffffffff80860df0 ran for 1 msecs: rd_init+0x0/0x1f0()
Calling initcall 0xffffffff80861020: loop_init+0x0/0x192()
loop: module loaded
initcall 0xffffffff80861020: loop_init+0x0/0x192() returned 0.
initcall 0xffffffff80861020 ran for 1 msecs: loop_init+0x0/0x192()
Calling initcall 0xffffffff808611cf: cciss_init+0x0/0x2b()
HP CISS Driver (v 3.6.14)
initcall 0xffffffff808611cf: cciss_init+0x0/0x2b() returned 0.
initcall 0xffffffff808611cf ran for 0 msecs: cciss_init+0x0/0x2b()
Calling initcall 0xffffffff8046bcc6: DAC960_init_module+0x0/0x47()
initcall 0xffffffff8046bcc6: DAC960_init_module+0x0/0x47() returned 0.
initcall 0xffffffff8046bcc6 ran for 0 msecs: DAC960_init_module+0x0/0x47()
Calling initcall 0xffffffff808611fa: mm_init+0x0/0x1a6()
MM: desc_per_page =3D 128
initcall 0xffffffff808611fa: mm_init+0x0/0x1a6() returned 0.
initcall 0xffffffff808611fa ran for 0 msecs: mm_init+0x0/0x1a6()
Calling initcall 0xffffffff808613a0: e1000_init_module+0x0/0x7f()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xffffffff808613a0: e1000_init_module+0x0/0x7f() returned 0.
initcall 0xffffffff808613a0 ran for 1 msecs: e1000_init_module+0x0/0x7f()
Calling initcall 0xffffffff80861500: plip_init+0x0/0x77()
initcall 0xffffffff80861500: plip_init+0x0/0x77() returned 0.
initcall 0xffffffff80861500 ran for 0 msecs: plip_init+0x0/0x77()
Calling initcall 0xffffffff80861577: happy_meal_probe+0x0/0x15()
initcall 0xffffffff80861577: happy_meal_probe+0x0/0x15() returned 0.
initcall 0xffffffff80861577 ran for 0 msecs: happy_meal_probe+0x0/0x15()
Calling initcall 0xffffffff8086158c: gem_init+0x0/0x15()
initcall 0xffffffff8086158c: gem_init+0x0/0x15() returned 0.
initcall 0xffffffff8086158c ran for 0 msecs: gem_init+0x0/0x15()
Calling initcall 0xffffffff808615a1: e100_init_module+0x0/0x5f()
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xffffffff808615a1: e100_init_module+0x0/0x5f() returned 0.
initcall 0xffffffff808615a1 ran for 1 msecs: e100_init_module+0x0/0x5f()
Calling initcall 0xffffffff80861600: natsemi_init_mod+0x0/0x15()
initcall 0xffffffff80861600: natsemi_init_mod+0x0/0x15() returned 0.
initcall 0xffffffff80861600 ran for 0 msecs: natsemi_init_mod+0x0/0x15()
Calling initcall 0xffffffff80861615: fealnx_init+0x0/0x15()
initcall 0xffffffff80861615: fealnx_init+0x0/0x15() returned 0.
initcall 0xffffffff80861615 ran for 0 msecs: fealnx_init+0x0/0x15()
Calling initcall 0xffffffff8086162a: rhine_init+0x0/0x71()
initcall 0xffffffff8086162a: rhine_init+0x0/0x71() returned 0.
initcall 0xffffffff8086162a ran for 0 msecs: rhine_init+0x0/0x71()
Calling initcall 0xffffffff8086169b: sundance_init+0x0/0x15()
initcall 0xffffffff8086169b: sundance_init+0x0/0x15() returned 0.
initcall 0xffffffff8086169b ran for 0 msecs: sundance_init+0x0/0x15()
Calling initcall 0xffffffff80861702: net_olddevs_init+0x0/0xa1()
D-Link DE-620 pocket adapter not identified in the printer port
initcall 0xffffffff80861702: net_olddevs_init+0x0/0xa1() returned 0.
initcall 0xffffffff80861702 ran for 1 msecs: net_olddevs_init+0x0/0xa1()
Calling initcall 0xffffffff8086182a: init_nic+0x0/0x15()
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:4=
1:12
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
initcall 0xffffffff8086182a: init_nic+0x0/0x15() returned 0.
initcall 0xffffffff8086182a ran for 492 msecs: init_nic+0x0/0x15()
Calling initcall 0xffffffff8086183f: ifb_init_module+0x0/0xe1()
initcall 0xffffffff8086183f: ifb_init_module+0x0/0xe1() returned 0.
initcall 0xffffffff8086183f ran for 0 msecs: ifb_init_module+0x0/0xe1()
Calling initcall 0xffffffff80862a62: rtl8139_init_module+0x0/0x15()
8139too Fast Ethernet driver 0.9.28
eth1: RealTek RTL8139 at 0xffffc200004d6000, 00:c0:df:03:68:5d, IRQ 11
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xffffffff80862a62: rtl8139_init_module+0x0/0x15() returned 0.
initcall 0xffffffff80862a62 ran for 3 msecs: rtl8139_init_module+0x0/0x15()
Calling initcall 0xffffffff80862a77: catc_init+0x0/0x35()
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
initcall 0xffffffff80862a77: catc_init+0x0/0x35() returned 0.
initcall 0xffffffff80862a77 ran for 1 msecs: catc_init+0x0/0x35()
Calling initcall 0xffffffff80862aac: usb_rtl8150_init+0x0/0x32()
drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/0=
8/27)
usbcore: registered new interface driver rtl8150
initcall 0xffffffff80862aac: usb_rtl8150_init+0x0/0x32() returned 0.
initcall 0xffffffff80862aac ran for 1 msecs: usb_rtl8150_init+0x0/0x32()
Calling initcall 0xffffffff80862ade: cdc_init+0x0/0x15()
usbcore: registered new interface driver cdc_ether
initcall 0xffffffff80862ade: cdc_init+0x0/0x15() returned 0.
initcall 0xffffffff80862ade ran for 0 msecs: cdc_init+0x0/0x15()
Calling initcall 0xffffffff80862af3: dm9601_init+0x0/0x15()
usbcore: registered new interface driver dm9601
initcall 0xffffffff80862af3: dm9601_init+0x0/0x15() returned 0.
initcall 0xffffffff80862af3 ran for 0 msecs: dm9601_init+0x0/0x15()
Calling initcall 0xffffffff80862b08: cdc_subset_init+0x0/0x15()
usbcore: registered new interface driver cdc_subset
initcall 0xffffffff80862b08: cdc_subset_init+0x0/0x15() returned 0.
initcall 0xffffffff80862b08 ran for 0 msecs: cdc_subset_init+0x0/0x15()
Calling initcall 0xffffffff80862b1d: mcs7830_init+0x0/0x15()
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall 0xffffffff80862b1d: mcs7830_init+0x0/0x15() returned 0.
initcall 0xffffffff80862b1d ran for 0 msecs: mcs7830_init+0x0/0x15()
Calling initcall 0xffffffff80862b32: usbnet_init+0x0/0x2d()
initcall 0xffffffff80862b32: usbnet_init+0x0/0x2d() returned 0.
initcall 0xffffffff80862b32 ran for 0 msecs: usbnet_init+0x0/0x2d()
Calling initcall 0xffffffff80862b5f: strip_init_driver+0x0/0x60()
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
initcall 0xffffffff80862b5f: strip_init_driver+0x0/0x60() returned 0.
initcall 0xffffffff80862b5f ran for 0 msecs: strip_init_driver+0x0/0x60()
Calling initcall 0xffffffff80862bbf: xircom_init+0x0/0x15()
initcall 0xffffffff80862bbf: xircom_init+0x0/0x15() returned 0.
initcall 0xffffffff80862bbf ran for 0 msecs: xircom_init+0x0/0x15()
Calling initcall 0xffffffff80862bd4: de4x5_module_init+0x0/0x1c()
initcall 0xffffffff80862bd4: de4x5_module_init+0x0/0x1c() returned 0.
initcall 0xffffffff80862bd4 ran for 0 msecs: de4x5_module_init+0x0/0x1c()
Calling initcall 0xffffffff80862c12: init_netconsole+0x0/0x24e()
console [netcon0] enabled
Linux version 2.6.24-rc4-cfs-v24 (mingo@dione) (gcc version 4.2.2) #1926 SM=
P Wed Dec 12 09:43:58 CET 2007
Command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,ttyS0,115=
200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dverbose sy=
srq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=3D0 nmi_=
watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
console [earlyser0] enabled
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
end_pfn_map =3D 1048576
DMI 2.3 present.
No NUMA configuration found
Faking a node at 0000000000000000-000000003fff0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003fff0000
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262128
On node 0 totalpages: 262031
  DMA zone: 56 pages used for memmap
  DMA zone: 2111 pages reserved
  DMA zone: 1832 pages, LIFO batch:0
  DMA32 zone: 3527 pages used for memmap
  DMA32 zone: 254505 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000 MPTABLE: APIC a=
t: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
Setting APIC routing to flat
Processors: 2
mapped APIC to ffffffffff5fb000 (        fee00000)
mapped IOAPIC to ffffffffff5fa000 (00000000fec00000)
Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
PERCPU: Allocating 33920 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 256337
Policy zone: DMA32
Kernel command line: root=3D/dev/sda6 console=3Dtty earlyprintk=3Dserial,tt=
yS0,115200,keep 3 profile=3D0 debug initcall_debug enforcing=3D0 apic=3Dver=
bose sysrq_always_enabled ignore_loglevel selinux=3D0 maxcpus=3D1 highres=
=3D0 nmi_watchdog=3D1 nolapic hpet=3Ddisable idle=3Dmwait
kernel profiling enabled (shift: 0)
debug: sysrq always enabled.
debug: ignoring loglevel setting.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PIT
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2160.234 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
CPU 0: aperture @ 8000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1008764k/1048512k available (4130k kernel code, 39360k reserved, 21=
09k data, 344k init)
SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=3D4, CPUs=3D2, N=
odes=3D1
Calibrating delay using timer specific routine.. 4321.73 BogoMIPS (lpj=3D21=
60868)
Security Framework initialized
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Freeing SMP alternatives: 37k freed
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 2-0 not connected.
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not co=
nnected.
=2E.TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
=2E.MP-BIOS bug: 8254 timer not connected to IO-APIC
=2E..trying to set up timer (IRQ0) through the 8259A ...=20
=2E.... (found apic 0 pin 0) ... works.
activating NMI Watchdog ... done.
number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
=2E... register #00: 00000000
=2E......    : physical APIC id: 00
=2E... register #01: 00170011
=2E......     : max redirection entries: 0017
=2E......     : PRQ implemented: 0
=2E......     : IO APIC version: 0011
=2E... register #02: 00000000
=2E......     : arbitration: 00
=2E... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:  =20
 00 001 0    0    0   0   0    1    1    30
 01 001 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 001 1    1    0   1   0    1    1    33
 04 001 0    0    0   0   0    1    1    34
 05 001 1    1    0   1   0    1    1    35
 06 001 0    0    0   0   0    1    1    36
 07 001 1    0    0   0   0    1    1    37
 08 001 0    0    0   0   0    1    1    38
 09 001 0    0    0   0   0    1    1    39
 0a 001 0    0    0   0   0    1    1    3A
 0b 001 1    1    0   1   0    1    1    3B
 0c 001 0    0    0   0   0    1    1    3C
 0d 001 0    0    0   0   0    1    1    3D
 0e 001 0    0    0   0   0    1    1    3E
 0f 001 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
=2E................................... done.
Using local APIC timer interrupts.
APIC timer calibration result 13501458
Detected 13.501 MHz APIC timer.
APIC timer registered as dummy, due to nmi_watchdog=3D1!
Brought up 1 CPUs
Testing NMI watchdog ... <4>WARNING: CPU#0: NMI appears to be stuck (0->0)!
Calling initcall 0xffffffff80864d7b: init_cpufreq_transition_notifier_list+=
0x0/0x17()
initcall 0xffffffff80864d7b: init_cpufreq_transition_notifier_list+0x0/0x17=
() returned 0.
initcall 0xffffffff80864d7b ran for 0 msecs: init_cpufreq_transition_notifi=
er_list+0x0/0x17()
Calling initcall 0xffffffff80866f03: net_ns_init+0x0/0x15d()
net_namespace: 120 bytes
initcall 0xffffffff80866f03: net_ns_init+0x0/0x15d() returned 0.
initcall 0xffffffff80866f03 ran for 0 msecs: net_ns_init+0x0/0x15d()
Calling initcall 0xffffffff8084ad90: cpufreq_tsc+0x0/0x19()
initcall 0xffffffff8084ad90: cpufreq_tsc+0x0/0x19() returned 0.
initcall 0xffffffff8084ad90 ran for 0 msecs: cpufreq_tsc+0x0/0x19()
Calling initcall 0xffffffff8084d0c4: init_smp_flush+0x0/0x4c()
initcall 0xffffffff8084d0c4: init_smp_flush+0x0/0x4c() returned 0.
initcall 0xffffffff8084d0c4 ran for 0 msecs: init_smp_flush+0x0/0x4c()
Calling initcall 0xffffffff80854d13: sysctl_init+0x0/0x25()
initcall 0xffffffff80854d13: sysctl_init+0x0/0x25() returned 0.
initcall 0xffffffff80854d13 ran for 0 msecs: sysctl_init+0x0/0x25()
Calling initcall 0xffffffff808559c3: init_jiffies_clocksource+0x0/0xc()
initcall 0xffffffff808559c3: init_jiffies_clocksource+0x0/0xc() returned 0.
initcall 0xffffffff808559c3 ran for 0 msecs: init_jiffies_clocksource+0x0/0=
xc()
Calling initcall 0xffffffff808566fb: ksysfs_init+0x0/0x69()
initcall 0xffffffff808566fb: ksysfs_init+0x0/0x69() returned 0.
initcall 0xffffffff808566fb ran for 0 msecs: ksysfs_init+0x0/0x69()
Calling initcall 0xffffffff80859c52: filelock_init+0x0/0x31()
initcall 0xffffffff80859c52: filelock_init+0x0/0x31() returned 0.
initcall 0xffffffff80859c52 ran for 0 msecs: filelock_init+0x0/0x31()
Calling initcall 0xffffffff8085a6b2: init_script_binfmt+0x0/0xc()
initcall 0xffffffff8085a6b2: init_script_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8085a6b2 ran for 0 msecs: init_script_binfmt+0x0/0xc()
Calling initcall 0xffffffff8085a6be: init_elf_binfmt+0x0/0xc()
initcall 0xffffffff8085a6be: init_elf_binfmt+0x0/0xc() returned 0.
initcall 0xffffffff8085a6be ran for 0 msecs: init_elf_binfmt+0x0/0xc()
Calling initcall 0xffffffff8085b7ca: debugfs_init+0x0/0x46()
initcall 0xffffffff8085b7ca: debugfs_init+0x0/0x46() returned 0.
initcall 0xffffffff8085b7ca ran for 0 msecs: debugfs_init+0x0/0x46()
Calling initcall 0xffffffff8085c198: securityfs_init+0x0/0x44()
initcall 0xffffffff8085c198: securityfs_init+0x0/0x44() returned 0.
initcall 0xffffffff8085c198 ran for 0 msecs: securityfs_init+0x0/0x44()
Calling initcall 0xffffffff8085c426: calibrate_xor_blocks+0x0/0xb4()
xor: automatically using best checksumming function: generic_sse
   generic_sse:  6616.000 MB/sec
xor: using function: generic_sse (6616.000 MB/sec)
initcall 0xffffffff8085c426: calibrate_xor_blocks+0x0/0xb4() returned 0.
initcall 0xffffffff8085c426 ran for 7 msecs: calibrate_xor_blocks+0x0/0xb4()
Calling initcall 0xffffffff8085cb71: random32_init+0x0/0x5f()
initcall 0xffffffff8085cb71: random32_init+0x0/0x5f() returned 0.
initcall 0xffffffff8085cb71 ran for 0 msecs: random32_init+0x0/0x5f()
Calling initcall 0xffffffff80864d92: cpufreq_core_init+0x0/0x7a()
initcall 0xffffffff80864d92: cpufreq_core_init+0x0/0x7a() returned 0.
initcall 0xffffffff80864d92 ran for 0 msecs: cpufreq_core_init+0x0/0x7a()
Calling initcall 0xffffffff80866dc0: sock_init+0x0/0x70()
initcall 0xffffffff80866dc0: sock_init+0x0/0x70() returned 0.
initcall 0xffffffff80866dc0 ran for 0 msecs: sock_init+0x0/0x70()
Calling initcall 0xffffffff80867726: netpoll_init+0x0/0x2c()
initcall 0xffffffff80867726: netpoll_init+0x0/0x2c() returned 0.
initcall 0xffffffff80867726 ran for 0 msecs: netpoll_init+0x0/0x2c()
Calling initcall 0xffffffff80867cf6: netlink_proto_init+0x0/0x16f()
NET: Registered protocol family 16
initcall 0xffffffff80867cf6: netlink_proto_init+0x0/0x16f() returned 0.
initcall 0xffffffff80867cf6 ran for 0 msecs: netlink_proto_init+0x0/0x16f()
Calling initcall 0xffffffff8085ca63: kobject_uevent_init+0x0/0x4a()
initcall 0xffffffff8085ca63: kobject_uevent_init+0x0/0x4a() returned 0.
initcall 0xffffffff8085ca63 ran for 0 msecs: kobject_uevent_init+0x0/0x4a()
Calling initcall 0xffffffff8085ce82: pcibus_class_init+0x0/0xc()
initcall 0xffffffff8085ce82: pcibus_class_init+0x0/0xc() returned 0.
initcall 0xffffffff8085ce82 ran for 0 msecs: pcibus_class_init+0x0/0xc()
Calling initcall 0xffffffff8085d4df: pci_driver_init+0x0/0xc()
initcall 0xffffffff8085d4df: pci_driver_init+0x0/0xc() returned 0.
initcall 0xffffffff8085d4df ran for 0 msecs: pci_driver_init+0x0/0xc()
Calling initcall 0xffffffff8085d60d: backlight_class_init+0x0/0x4c()
initcall 0xffffffff8085d60d: backlight_class_init+0x0/0x4c() returned 0.
initcall 0xffffffff8085d60d ran for 0 msecs: backlight_class_init+0x0/0x4c()
Calling initcall 0xffffffff8085d665: video_output_class_init+0x0/0x1b()
initcall 0xffffffff8085d665: video_output_class_init+0x0/0x1b() returned 0.
initcall 0xffffffff8085d665 ran for 0 msecs: video_output_class_init+0x0/0x=
1b()
Calling initcall 0xffffffff8085d790: tty_class_init+0x0/0x2d()
initcall 0xffffffff8085d790: tty_class_init+0x0/0x2d() returned 0.
initcall 0xffffffff8085d790 ran for 0 msecs: tty_class_init+0x0/0x2d()
Calling initcall 0xffffffff8085e515: vtconsole_class_init+0x0/0xc7()
initcall 0xffffffff8085e515: vtconsole_class_init+0x0/0xc7() returned 0.
initcall 0xffffffff8085e515 ran for 0 msecs: vtconsole_class_init+0x0/0xc7()
Calling initcall 0xffffffff80860d25: register_node_type+0x0/0x6d()
initcall 0xffffffff80860d25: register_node_type+0x0/0x6d() returned 0.
initcall 0xffffffff80860d25 ran for 0 msecs: register_node_type+0x0/0x6d()
Calling initcall 0xffffffff808660d8: pci_access_init+0x0/0x48()
PCI: Using configuration type 1
initcall 0xffffffff808660d8: pci_access_init+0x0/0x48() returned 0.
initcall 0xffffffff808660d8 ran for 0 msecs: pci_access_init+0x0/0x48()
Calling initcall 0xffffffff808520f0: topology_init+0x0/0x84()
initcall 0xffffffff808520f0: topology_init+0x0/0x84() returned 0.
initcall 0xffffffff808520f0 ran for 0 msecs: topology_init+0x0/0x84()
Calling initcall 0xffffffff808553ae: param_sysfs_init+0x0/0x202()
initcall 0xffffffff808553ae: param_sysfs_init+0x0/0x202() returned 0.
initcall 0xffffffff808553ae ran for 6 msecs: param_sysfs_init+0x0/0x202()
Calling initcall 0xffffffff80858b21: readahead_init+0x0/0xc()
initcall 0xffffffff80858b21: readahead_init+0x0/0xc() returned 0.
initcall 0xffffffff80858b21 ran for 0 msecs: readahead_init+0x0/0xc()
Calling initcall 0xffffffff8085a38d: init_bio+0x0/0xee()
initcall 0xffffffff8085a38d: init_bio+0x0/0xee() returned 0.
initcall 0xffffffff8085a38d ran for 0 msecs: init_bio+0x0/0xee()
Calling initcall 0xffffffff8085c677: genhd_device_init+0x0/0x51()
initcall 0xffffffff8085c677: genhd_device_init+0x0/0x51() returned 0.
initcall 0xffffffff8085c677 ran for 0 msecs: genhd_device_init+0x0/0x51()
Calling initcall 0xffffffff8085df39: misc_init+0x0/0x85()
initcall 0xffffffff8085df39: misc_init+0x0/0x85() returned 0.
initcall 0xffffffff8085df39 ran for 0 msecs: misc_init+0x0/0x85()
Calling initcall 0xffffffff80862e60: init_scsi+0x0/0x92()
SCSI subsystem initialized
initcall 0xffffffff80862e60: init_scsi+0x0/0x92() returned 0.
initcall 0xffffffff80862e60 ran for 0 msecs: init_scsi+0x0/0x92()
Calling initcall 0xffffffff80863355: ata_init+0x0/0x8a()
libata version 3.00 loaded.
initcall 0xffffffff80863355: ata_init+0x0/0x8a() returned 0.
initcall 0xffffffff80863355 ran for 0 msecs: ata_init+0x0/0x8a()
Calling initcall 0xffffffff808635e0: usb_init+0x0/0xdb()
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall 0xffffffff808635e0: usb_init+0x0/0xdb() returned 0.
initcall 0xffffffff808635e0 ran for 3 msecs: usb_init+0x0/0xdb()
Calling initcall 0xffffffff80863ac6: serio_init+0x0/0x97()
initcall 0xffffffff80863ac6: serio_init+0x0/0x97() returned 0.
initcall 0xffffffff80863ac6 ran for 0 msecs: serio_init+0x0/0x97()
Calling initcall 0xffffffff80863c25: gameport_init+0x0/0x97()
initcall 0xffffffff80863c25: gameport_init+0x0/0x97() returned 0.
initcall 0xffffffff80863c25 ran for 0 msecs: gameport_init+0x0/0x97()
Calling initcall 0xffffffff80863ce0: input_init+0x0/0x11b()
initcall 0xffffffff80863ce0: input_init+0x0/0x11b() returned 0.
initcall 0xffffffff80863ce0 ran for 0 msecs: input_init+0x0/0x11b()
Calling initcall 0xffffffff80864c97: md_init+0x0/0xe4()
initcall 0xffffffff80864c97: md_init+0x0/0xe4() returned 0.
initcall 0xffffffff80864c97 ran for 0 msecs: md_init+0x0/0xe4()
Calling initcall 0xffffffff80864e30: leds_init+0x0/0x30()
initcall 0xffffffff80864e30: leds_init+0x0/0x30() returned 0.
initcall 0xffffffff80864e30 ran for 0 msecs: leds_init+0x0/0x30()
Calling initcall 0xffffffff80865b05: ac97_bus_init+0x0/0x1b()
initcall 0xffffffff80865b05: ac97_bus_init+0x0/0x1b() returned 0.
initcall 0xffffffff80865b05 ran for 0 msecs: ac97_bus_init+0x0/0x1b()
Calling initcall 0xffffffff80866120: pci_legacy_init+0x0/0x100()
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:09.0
initcall 0xffffffff80866120: pci_legacy_init+0x0/0x100() returned 0.
initcall 0xffffffff80866120 ran for 6 msecs: pci_legacy_init+0x0/0x100()
Calling initcall 0xffffffff808666eb: pcibios_irq_init+0x0/0x53c()
PCI: Using IRQ router default [10de/005e] at 0000:00:00.0
PCI->APIC IRQ transform: 0000:00:04.0[A] -> IRQ 3
PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:05:07.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:01:00.0[A] -> IRQ 5
initcall 0xffffffff808666eb: pcibios_irq_init+0x0/0x53c() returned 0.
initcall 0xffffffff808666eb ran for 4 msecs: pcibios_irq_init+0x0/0x53c()
Calling initcall 0xffffffff80866c27: pcibios_init+0x0/0x89()
initcall 0xffffffff80866c27: pcibios_init+0x0/0x89() returned 0.
initcall 0xffffffff80866c27 ran for 0 msecs: pcibios_init+0x0/0x89()
Calling initcall 0xffffffff80866e85: proto_init+0x0/0x31()
initcall 0xffffffff80866e85: proto_init+0x0/0x31() returned 0.
initcall 0xffffffff80866e85 ran for 0 msecs: proto_init+0x0/0x31()
Calling initcall 0xffffffff80867248: net_dev_init+0x0/0x144()
initcall 0xffffffff80867248: net_dev_init+0x0/0x144() returned 0.
initcall 0xffffffff80867248 ran for 0 msecs: net_dev_init+0x0/0x144()
Calling initcall 0xffffffff808673cb: neigh_init+0x0/0x74()
initcall 0xffffffff808673cb: neigh_init+0x0/0x74() returned 0.
initcall 0xffffffff808673cb ran for 0 msecs: neigh_init+0x0/0x74()
Calling initcall 0xffffffff80867752: fib_rules_init+0x0/0x53()
initcall 0xffffffff80867752: fib_rules_init+0x0/0x53() returned 0.
initcall 0xffffffff80867752 ran for 0 msecs: fib_rules_init+0x0/0x53()
Calling initcall 0xffffffff808678d5: pktsched_init+0x0/0xc7()
initcall 0xffffffff808678d5: pktsched_init+0x0/0xc7() returned 0.
initcall 0xffffffff808678d5 ran for 0 msecs: pktsched_init+0x0/0xc7()
Calling initcall 0xffffffff808679a8: tc_filter_init+0x0/0x4f()
initcall 0xffffffff808679a8: tc_filter_init+0x0/0x4f() returned 0.
initcall 0xffffffff808679a8 ran for 0 msecs: tc_filter_init+0x0/0x4f()
Calling initcall 0xffffffff808679f7: tc_action_init+0x0/0x4f()
initcall 0xffffffff808679f7: tc_action_init+0x0/0x4f() returned 0.
initcall 0xffffffff808679f7 ran for 0 msecs: tc_action_init+0x0/0x4f()
Calling initcall 0xffffffff80867e65: genl_init+0x0/0xcb()
initcall 0xffffffff80867e65: genl_init+0x0/0xcb() returned 0.
initcall 0xffffffff80867e65 ran for 3 msecs: genl_init+0x0/0xcb()
Calling initcall 0xffffffff8086c0ca: wanrouter_init+0x0/0x4b()
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall 0xffffffff8086c0ca: wanrouter_init+0x0/0x4b() returned 0.
initcall 0xffffffff8086c0ca ran for 0 msecs: wanrouter_init+0x0/0x4b()
Calling initcall 0xffffffff8086c140: atm_init+0x0/0xaa()
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall 0xffffffff8086c140: atm_init+0x0/0xaa() returned 0.
initcall 0xffffffff8086c140 ran for 1 msecs: atm_init+0x0/0xaa()
Calling initcall 0xffffffff8086c97a: wireless_nlevent_init+0x0/0x2c()
initcall 0xffffffff8086c97a: wireless_nlevent_init+0x0/0x2c() returned 0.
initcall 0xffffffff8086c97a ran for 0 msecs: wireless_nlevent_init+0x0/0x2c=
()
Calling initcall 0xffffffff8084a9c3: pci_iommu_init+0x0/0x15()
initcall 0xffffffff8084a9c3: pci_iommu_init+0x0/0x15() returned 0.
initcall 0xffffffff8084a9c3 ran for 0 msecs: pci_iommu_init+0x0/0x15()
Calling initcall 0xffffffff8084ad28: hpet_late_init+0x0/0x58()
initcall 0xffffffff8084ad28: hpet_late_init+0x0/0x58() returned -19.
initcall 0xffffffff8084ad28 ran for 0 msecs: hpet_late_init+0x0/0x58()
Calling initcall 0xffffffff808558cc: clocksource_done_booting+0x0/0xd()
initcall 0xffffffff808558cc: clocksource_done_booting+0x0/0xd() returned 0.
initcall 0xffffffff808558cc ran for 0 msecs: clocksource_done_booting+0x0/0=
xd()
Calling initcall 0xffffffff80859be1: init_pipe_fs+0x0/0x44()
initcall 0xffffffff80859be1: init_pipe_fs+0x0/0x44() returned 0.
initcall 0xffffffff80859be1 ran for 0 msecs: init_pipe_fs+0x0/0x44()
Calling initcall 0xffffffff8085a50b: eventpoll_init+0x0/0x88()
initcall 0xffffffff8085a50b: eventpoll_init+0x0/0x88() returned 0.
initcall 0xffffffff8085a50b ran for 0 msecs: eventpoll_init+0x0/0x88()
Calling initcall 0xffffffff8085a593: anon_inode_init+0x0/0x11f()
initcall 0xffffffff8085a593: anon_inode_init+0x0/0x11f() returned 0.
initcall 0xffffffff8085a593 ran for 0 msecs: anon_inode_init+0x0/0x11f()
Calling initcall 0xffffffff8085d680: chr_dev_init+0x0/0xc7()
initcall 0xffffffff8085d680: chr_dev_init+0x0/0xc7() returned 0.
initcall 0xffffffff8085d680 ran for 0 msecs: chr_dev_init+0x0/0xc7()
Calling initcall 0xffffffff80860cbb: firmware_class_init+0x0/0x6a()
initcall 0xffffffff80860cbb: firmware_class_init+0x0/0x6a() returned 0.
initcall 0xffffffff80860cbb ran for 0 msecs: firmware_class_init+0x0/0x6a()
Calling initcall 0xffffffff808617a3: loopback_init+0x0/0xc()
initcall 0xffffffff808617a3: loopback_init+0x0/0xc() returned 0.
initcall 0xffffffff808617a3 ran for 0 msecs: loopback_init+0x0/0xc()
Calling initcall 0xffffffff80864e0c: cpufreq_gov_performance_init+0x0/0xc()
initcall 0xffffffff80864e0c: cpufreq_gov_performance_init+0x0/0xc() returne=
d 0.
initcall 0xffffffff80864e0c ran for 0 msecs: cpufreq_gov_performance_init+0=
x0/0xc()
Calling initcall 0xffffffff80865b20: pcibios_assign_resources+0x0/0x8b()
PCI: Bridge: 0000:00:09.0
  IO window: c000-cfff
  MEM window: da000000-da0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
  IO window: b000-bfff
  MEM window: d8000000-d9ffffff
  PREFETCH window: d0000000-d7ffffff
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
initcall 0xffffffff80865b20: pcibios_assign_resources+0x0/0x8b() returned 0.
initcall 0xffffffff80865b20 ran for 23 msecs: pcibios_assign_resources+0x0/=
0x8b()
Calling initcall 0xffffffff80866cb0: fill_mp_bus_to_cpumask+0x0/0x110()
initcall 0xffffffff80866cb0: fill_mp_bus_to_cpumask+0x0/0x110() returned 0.
initcall 0xffffffff80866cb0 ran for 0 msecs: fill_mp_bus_to_cpumask+0x0/0x1=
10()
Calling initcall 0xffffffff80869510: inet_init+0x0/0x380()
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
initcall 0xffffffff80869510: inet_init+0x0/0x380() returned 0.
initcall 0xffffffff80869510 ran for 20 msecs: inet_init+0x0/0x380()
Calling initcall 0xffffffff80847286: default_rootfs+0x0/0x63()
initcall 0xffffffff80847286: default_rootfs+0x0/0x63() returned 0.
initcall 0xffffffff80847286 ran for 0 msecs: default_rootfs+0x0/0x63()
Calling initcall 0xffffffff80848c78: i8259A_init_sysfs+0x0/0x29()
initcall 0xffffffff80848c78: i8259A_init_sysfs+0x0/0x29() returned 0.
initcall 0xffffffff80848c78 ran for 0 msecs: i8259A_init_sysfs+0x0/0x29()
Calling initcall 0xffffffff808491e3: vsyscall_init+0x0/0x8d()
initcall 0xffffffff808491e3: vsyscall_init+0x0/0x8d() returned 0.
initcall 0xffffffff808491e3 ran for 0 msecs: vsyscall_init+0x0/0x8d()
Calling initcall 0xffffffff80849832: sbf_init+0x0/0xde()
initcall 0xffffffff80849832: sbf_init+0x0/0xde() returned 0.
initcall 0xffffffff80849832 ran for 0 msecs: sbf_init+0x0/0xde()
Calling initcall 0xffffffff8084a748: i8237A_init_sysfs+0x0/0x29()
initcall 0xffffffff8084a748: i8237A_init_sysfs+0x0/0x29() returned 0.
initcall 0xffffffff8084a748 ran for 0 msecs: i8237A_init_sysfs+0x0/0x29()
Calling initcall 0xffffffff8084b618: cache_sysfs_init+0x0/0x40b()
initcall 0xffffffff8084b618: cache_sysfs_init+0x0/0x40b() returned 0.
initcall 0xffffffff8084b618 ran for 0 msecs: cache_sysfs_init+0x0/0x40b()
Calling initcall 0xffffffff8084c1d7: mce_init_device+0x0/0x1cb()
initcall 0xffffffff8084c1d7: mce_init_device+0x0/0x1cb() returned 0.
initcall 0xffffffff8084c1d7 ran for 0 msecs: mce_init_device+0x0/0x1cb()
Calling initcall 0xffffffff8084c0e9: periodic_mcheck_init+0x0/0x4a()
initcall 0xffffffff8084c0e9: periodic_mcheck_init+0x0/0x4a() returned 0.
initcall 0xffffffff8084c0e9 ran for 0 msecs: periodic_mcheck_init+0x0/0x4a()
Calling initcall 0xffffffff8084c403: thermal_throttle_init_device+0x0/0x7d()
initcall 0xffffffff8084c403: thermal_throttle_init_device+0x0/0x7d() return=
ed 0.
initcall 0xffffffff8084c403 ran for 0 msecs: thermal_throttle_init_device+0=
x0/0x7d()
Calling initcall 0xffffffff8084cf13: msr_init+0x0/0x116()
initcall 0xffffffff8084cf13: msr_init+0x0/0x116() returned 0.
initcall 0xffffffff8084cf13 ran for 0 msecs: msr_init+0x0/0x116()
Calling initcall 0xffffffff8084d029: microcode_init+0x0/0x9b()
microcode: CPU0 not a capable Intel processor
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
initcall 0xffffffff8084d029: microcode_init+0x0/0x9b() returned 0.
initcall 0xffffffff8084d029 ran for 1 msecs: microcode_init+0x0/0x9b()
Calling initcall 0xffffffff8084f773: ioapic_init_sysfs+0x0/0xca()
initcall 0xffffffff8084f773: ioapic_init_sysfs+0x0/0xca() returned 0.
initcall 0xffffffff8084f773 ran for 0 msecs: ioapic_init_sysfs+0x0/0xca()
Calling initcall 0xffffffff80851f49: audit_classes_init+0x0/0x67()
initcall 0xffffffff80851f49: audit_classes_init+0x0/0x67() returned 0.
initcall 0xffffffff80851f49 ran for 0 msecs: audit_classes_init+0x0/0x67()
Calling initcall 0xffffffff80852174: add_pcspkr+0x0/0x4c()
initcall 0xffffffff80852174: add_pcspkr+0x0/0x4c() returned 0.
initcall 0xffffffff80852174 ran for 0 msecs: add_pcspkr+0x0/0x4c()
Calling initcall 0xffffffff808536e6: init_vdso_vars+0x0/0x20a()
initcall 0xffffffff808536e6: init_vdso_vars+0x0/0x20a() returned 0.
initcall 0xffffffff808536e6 ran for 0 msecs: init_vdso_vars+0x0/0x20a()
Calling initcall 0xffffffff80854763: create_proc_profile+0x0/0x2d7()
initcall 0xffffffff80854763: create_proc_profile+0x0/0x2d7() returned 0.
initcall 0xffffffff80854763 ran for 0 msecs: create_proc_profile+0x0/0x2d7()
Calling initcall 0xffffffff80854bd6: ioresources_init+0x0/0x45()
initcall 0xffffffff80854bd6: ioresources_init+0x0/0x45() returned 0.
initcall 0xffffffff80854bd6 ran for 0 msecs: ioresources_init+0x0/0x45()
Calling initcall 0xffffffff80854f2f: uid_cache_init+0x0/0x7f()
initcall 0xffffffff80854f2f: uid_cache_init+0x0/0x7f() returned 0.
initcall 0xffffffff80854f2f ran for 0 msecs: uid_cache_init+0x0/0x7f()
Calling initcall 0xffffffff808555b0: init_posix_timers+0x0/0xa6()
initcall 0xffffffff808555b0: init_posix_timers+0x0/0xa6() returned 0.
initcall 0xffffffff808555b0 ran for 0 msecs: init_posix_timers+0x0/0xa6()
Calling initcall 0xffffffff80855656: init_posix_cpu_timers+0x0/0xc6()
initcall 0xffffffff80855656: init_posix_cpu_timers+0x0/0xc6() returned 0.
initcall 0xffffffff80855656 ran for 0 msecs: init_posix_cpu_timers+0x0/0xc6=
()
Calling initcall 0xffffffff80855788: latency_init+0x0/0x26()
initcall 0xffffffff80855788: latency_init+0x0/0x26() returned 0.
initcall 0xffffffff80855788 ran for 0 msecs: latency_init+0x0/0x26()
Calling initcall 0xffffffff808557ae: nsproxy_cache_init+0x0/0x30()
initcall 0xffffffff808557ae: nsproxy_cache_init+0x0/0x30() returned 0.
initcall 0xffffffff808557ae ran for 0 msecs: nsproxy_cache_init+0x0/0x30()
Calling initcall 0xffffffff808557de: timekeeping_init_device+0x0/0x29()
initcall 0xffffffff808557de: timekeeping_init_device+0x0/0x29() returned 0.
initcall 0xffffffff808557de ran for 0 msecs: timekeeping_init_device+0x0/0x=
29()
Calling initcall 0xffffffff808558d9: init_clocksource_sysfs+0x0/0x57()
initcall 0xffffffff808558d9: init_clocksource_sysfs+0x0/0x57() returned 0.
initcall 0xffffffff808558d9 ran for 0 msecs: init_clocksource_sysfs+0x0/0x5=
7()
Calling initcall 0xffffffff808559cf: init_timer_list_procfs+0x0/0x32()
initcall 0xffffffff808559cf: init_timer_list_procfs+0x0/0x32() returned 0.
initcall 0xffffffff808559cf ran for 0 msecs: init_timer_list_procfs+0x0/0x3=
2()
Calling initcall 0xffffffff80855a5b: init+0x0/0xe0()
initcall 0xffffffff80855a5b: init+0x0/0xe0() returned 0.
initcall 0xffffffff80855a5b ran for 0 msecs: init+0x0/0xe0()
Calling initcall 0xffffffff80855b3b: proc_dma_init+0x0/0x28()
initcall 0xffffffff80855b3b: proc_dma_init+0x0/0x28() returned 0.
initcall 0xffffffff80855b3b ran for 0 msecs: proc_dma_init+0x0/0x28()
Calling initcall 0xffffffff80247593: percpu_modinit+0x0/0x79()
initcall 0xffffffff80247593: percpu_modinit+0x0/0x79() returned 0.
initcall 0xffffffff80247593 ran for 0 msecs: percpu_modinit+0x0/0x79()
Calling initcall 0xffffffff80855dca: kallsyms_init+0x0/0x36()
initcall 0xffffffff80855dca: kallsyms_init+0x0/0x36() returned 0.
initcall 0xffffffff80855dca ran for 0 msecs: kallsyms_init+0x0/0x36()
Calling initcall 0xffffffff80855e42: crash_save_vmcoreinfo_init+0x0/0x3c6()
initcall 0xffffffff80855e42: crash_save_vmcoreinfo_init+0x0/0x3c6() returne=
d 0.
initcall 0xffffffff80855e42 ran for 0 msecs: crash_save_vmcoreinfo_init+0x0=
/0x3c6()
Calling initcall 0xffffffff80855e00: crash_notes_memory_init+0x0/0x42()
initcall 0xffffffff80855e00: crash_notes_memory_init+0x0/0x42() returned 0.
initcall 0xffffffff80855e00 ran for 0 msecs: crash_notes_memory_init+0x0/0x=
42()
Calling initcall 0xffffffff8085655e: audit_init+0x0/0x102()
audit: initializing netlink socket (disabled)
audit(1197457090.053:1): initialized
initcall 0xffffffff8085655e: audit_init+0x0/0x102() returned 0.
initcall 0xffffffff8085655e ran for 1 msecs: audit_init+0x0/0x102()
Calling initcall 0xffffffff808567cc: relay_init+0x0/0x3()
initcall 0xffffffff808567cc: relay_init+0x0/0x3() returned 0.
initcall 0xffffffff808567cc ran for 0 msecs: relay_init+0x0/0x3()
Calling initcall 0xffffffff808567cf: utsname_sysctl_init+0x0/0x21()
initcall 0xffffffff808567cf: utsname_sysctl_init+0x0/0x21() returned 0.
initcall 0xffffffff808567cf ran for 0 msecs: utsname_sysctl_init+0x0/0x21()
Calling initcall 0xffffffff80857871: init_per_zone_pages_min+0x0/0x56()
initcall 0xffffffff80857871: init_per_zone_pages_min+0x0/0x56() returned 0.
initcall 0xffffffff80857871 ran for 0 msecs: init_per_zone_pages_min+0x0/0x=
56()
Calling initcall 0xffffffff80858b0c: pdflush_init+0x0/0x15()
initcall 0xffffffff80858b0c: pdflush_init+0x0/0x15() returned 0.
initcall 0xffffffff80858b0c ran for 0 msecs: pdflush_init+0x0/0x15()
Calling initcall 0xffffffff80858b48: kswapd_init+0x0/0x5a()
initcall 0xffffffff80858b48: kswapd_init+0x0/0x5a() returned 0.
initcall 0xffffffff80858b48 ran for 0 msecs: kswapd_init+0x0/0x5a()
Calling initcall 0xffffffff80858c03: setup_vmstat+0x0/0x45()
initcall 0xffffffff80858c03: setup_vmstat+0x0/0x45() returned 0.
initcall 0xffffffff80858c03 ran for 0 msecs: setup_vmstat+0x0/0x45()
Calling initcall 0xffffffff80858cfd: hugetlb_init+0x0/0xa0()
Total HugeTLB memory allocated, 0
initcall 0xffffffff80858cfd: hugetlb_init+0x0/0xa0() returned 0.
initcall 0xffffffff80858cfd ran for 0 msecs: hugetlb_init+0x0/0xa0()
Calling initcall 0xffffffff80859556: init_tmpfs+0x0/0xda()
initcall 0xffffffff80859556: init_tmpfs+0x0/0xda() returned 0.
initcall 0xffffffff80859556 ran for 0 msecs: init_tmpfs+0x0/0xda()
Calling initcall 0xffffffff808598cd: slab_sysfs_init+0x0/0xcd()
initcall 0xffffffff808598cd: slab_sysfs_init+0x0/0xcd() returned 0.
initcall 0xffffffff808598cd ran for 7 msecs: slab_sysfs_init+0x0/0xcd()
Calling initcall 0xffffffff80859c25: fasync_init+0x0/0x2d()
initcall 0xffffffff80859c25: fasync_init+0x0/0x2d() returned 0.
initcall 0xffffffff80859c25 ran for 0 msecs: fasync_init+0x0/0x2d()
Calling initcall 0xffffffff8085a2a8: aio_setup+0x0/0x6e()
initcall 0xffffffff8085a2a8: aio_setup+0x0/0x6e() returned 0.
initcall 0xffffffff8085a2a8 ran for 0 msecs: aio_setup+0x0/0x6e()
Calling initcall 0xffffffff8085a4fe: inotify_setup+0x0/0xd()
initcall 0xffffffff8085a4fe: inotify_setup+0x0/0xd() returned 0.
initcall 0xffffffff8085a4fe ran for 0 msecs: inotify_setup+0x0/0xd()
Calling initcall 0xffffffff8085a6ca: init_mbcache+0x0/0x17()
initcall 0xffffffff8085a6ca: init_mbcache+0x0/0x17() returned 0.
initcall 0xffffffff8085a6ca ran for 0 msecs: init_mbcache+0x0/0x17()
Calling initcall 0xffffffff8085a6e1: dnotify_init+0x0/0x2d()
initcall 0xffffffff8085a6e1: dnotify_init+0x0/0x2d() returned 0.
initcall 0xffffffff8085a6e1 ran for 0 msecs: dnotify_init+0x0/0x2d()
Calling initcall 0xffffffff8085abca: configfs_init+0x0/0xce()
initcall 0xffffffff8085abca: configfs_init+0x0/0xce() returned 0.
initcall 0xffffffff8085abca ran for 0 msecs: configfs_init+0x0/0xce()
Calling initcall 0xffffffff8085ac98: init_devpts_fs+0x0/0x38()
initcall 0xffffffff8085ac98: init_devpts_fs+0x0/0x38() returned 0.
initcall 0xffffffff8085ac98 ran for 0 msecs: init_devpts_fs+0x0/0x38()
Calling initcall 0xffffffff8085acd0: init_reiserfs_fs+0x0/0x80()
initcall 0xffffffff8085acd0: init_reiserfs_fs+0x0/0x80() returned 0.
initcall 0xffffffff8085acd0 ran for 0 msecs: init_reiserfs_fs+0x0/0x80()
Calling initcall 0xffffffff8085ad50: init_ext3_fs+0x0/0x61()
initcall 0xffffffff8085ad50: init_ext3_fs+0x0/0x61() returned 0.
initcall 0xffffffff8085ad50 ran for 0 msecs: init_ext3_fs+0x0/0x61()
Calling initcall 0xffffffff8085ae70: journal_init+0x0/0x9a()
initcall 0xffffffff8085ae70: journal_init+0x0/0x9a() returned 0.
initcall 0xffffffff8085ae70 ran for 0 msecs: journal_init+0x0/0x9a()
Calling initcall 0xffffffff8085af0a: init_ramfs_fs+0x0/0xc()
initcall 0xffffffff8085af0a: init_ramfs_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085af0a ran for 0 msecs: init_ramfs_fs+0x0/0xc()
Calling initcall 0xffffffff8085af4f: init_hugetlbfs_fs+0x0/0x94()
initcall 0xffffffff8085af4f: init_hugetlbfs_fs+0x0/0x94() returned 0.
initcall 0xffffffff8085af4f ran for 0 msecs: init_hugetlbfs_fs+0x0/0x94()
Calling initcall 0xffffffff8085afe3: init_coda+0x0/0x17d()
initcall 0xffffffff8085afe3: init_coda+0x0/0x17d() returned 0.
initcall 0xffffffff8085afe3 ran for 0 msecs: init_coda+0x0/0x17d()
Calling initcall 0xffffffff8085b160: init_minix_fs+0x0/0x51()
initcall 0xffffffff8085b160: init_minix_fs+0x0/0x51() returned 0.
initcall 0xffffffff8085b160 ran for 0 msecs: init_minix_fs+0x0/0x51()
Calling initcall 0xffffffff8085b1e9: init_fat_fs+0x0/0x47()
initcall 0xffffffff8085b1e9: init_fat_fs+0x0/0x47() returned 0.
initcall 0xffffffff8085b1e9 ran for 0 msecs: init_fat_fs+0x0/0x47()
Calling initcall 0xffffffff8085b230: init_msdos_fs+0x0/0xc()
initcall 0xffffffff8085b230: init_msdos_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085b230 ran for 0 msecs: init_msdos_fs+0x0/0xc()
Calling initcall 0xffffffff8085b23c: init_vfat_fs+0x0/0x14()
initcall 0xffffffff8085b23c: init_vfat_fs+0x0/0x14() returned 0.
initcall 0xffffffff8085b23c ran for 0 msecs: init_vfat_fs+0x0/0x14()
Calling initcall 0xffffffff8085b250: init_iso9660_fs+0x0/0x63()
initcall 0xffffffff8085b250: init_iso9660_fs+0x0/0x63() returned 0.
initcall 0xffffffff8085b250 ran for 0 msecs: init_iso9660_fs+0x0/0x63()
Clocksource tsc unstable (delta =3D 715947801 ns)
Calling initcall 0xffffffff8085b2d9: init_hfsplus_fs+0x0/0x57()
initcall 0xffffffff8085b2d9: init_hfsplus_fs+0x0/0x57() returned 0.
initcall 0xffffffff8085b2d9 ran for 0 msecs: init_hfsplus_fs+0x0/0x57()
Calling initcall 0xffffffff8085b330: ecryptfs_init+0x0/0x1dd()
initcall 0xffffffff8085b330: ecryptfs_init+0x0/0x1dd() returned 0.
initcall 0xffffffff8085b330 ran for 1 msecs: ecryptfs_init+0x0/0x1dd()
Calling initcall 0xffffffff8085b50d: init_nls_cp737+0x0/0xc()
initcall 0xffffffff8085b50d: init_nls_cp737+0x0/0xc() returned 0.
initcall 0xffffffff8085b50d ran for 0 msecs: init_nls_cp737+0x0/0xc()
Calling initcall 0xffffffff8085b519: init_nls_cp852+0x0/0xc()
initcall 0xffffffff8085b519: init_nls_cp852+0x0/0xc() returned 0.
initcall 0xffffffff8085b519 ran for 0 msecs: init_nls_cp852+0x0/0xc()
Calling initcall 0xffffffff8085b525: init_nls_cp860+0x0/0xc()
initcall 0xffffffff8085b525: init_nls_cp860+0x0/0xc() returned 0.
initcall 0xffffffff8085b525 ran for 0 msecs: init_nls_cp860+0x0/0xc()
Calling initcall 0xffffffff8085b531: init_nls_cp861+0x0/0xc()
initcall 0xffffffff8085b531: init_nls_cp861+0x0/0xc() returned 0.
initcall 0xffffffff8085b531 ran for 0 msecs: init_nls_cp861+0x0/0xc()
Calling initcall 0xffffffff8085b53d: init_nls_cp932+0x0/0xc()
initcall 0xffffffff8085b53d: init_nls_cp932+0x0/0xc() returned 0.
initcall 0xffffffff8085b53d ran for 0 msecs: init_nls_cp932+0x0/0xc()
Calling initcall 0xffffffff8085b549: init_nls_euc_jp+0x0/0x4f()
initcall 0xffffffff8085b549: init_nls_euc_jp+0x0/0x4f() returned 0.
initcall 0xffffffff8085b549 ran for 0 msecs: init_nls_euc_jp+0x0/0x4f()
Calling initcall 0xffffffff8085b598: init_nls_cp949+0x0/0xc()
initcall 0xffffffff8085b598: init_nls_cp949+0x0/0xc() returned 0.
initcall 0xffffffff8085b598 ran for 0 msecs: init_nls_cp949+0x0/0xc()
Calling initcall 0xffffffff8085b5a4: init_nls_cp950+0x0/0xc()
initcall 0xffffffff8085b5a4: init_nls_cp950+0x0/0xc() returned 0.
initcall 0xffffffff8085b5a4 ran for 0 msecs: init_nls_cp950+0x0/0xc()
Calling initcall 0xffffffff8085b5b0: init_nls_cp1250+0x0/0xc()
initcall 0xffffffff8085b5b0: init_nls_cp1250+0x0/0xc() returned 0.
initcall 0xffffffff8085b5b0 ran for 0 msecs: init_nls_cp1250+0x0/0xc()
Calling initcall 0xffffffff8085b5bc: init_nls_ascii+0x0/0xc()
initcall 0xffffffff8085b5bc: init_nls_ascii+0x0/0xc() returned 0.
initcall 0xffffffff8085b5bc ran for 0 msecs: init_nls_ascii+0x0/0xc()
Calling initcall 0xffffffff8085b5c8: init_nls_iso8859_4+0x0/0xc()
initcall 0xffffffff8085b5c8: init_nls_iso8859_4+0x0/0xc() returned 0.
initcall 0xffffffff8085b5c8 ran for 0 msecs: init_nls_iso8859_4+0x0/0xc()
Calling initcall 0xffffffff8085b5d4: init_nls_iso8859_6+0x0/0xc()
initcall 0xffffffff8085b5d4: init_nls_iso8859_6+0x0/0xc() returned 0.
initcall 0xffffffff8085b5d4 ran for 0 msecs: init_nls_iso8859_6+0x0/0xc()
Calling initcall 0xffffffff8085b5e0: init_nls_cp1255+0x0/0xc()
initcall 0xffffffff8085b5e0: init_nls_cp1255+0x0/0xc() returned 0.
initcall 0xffffffff8085b5e0 ran for 0 msecs: init_nls_cp1255+0x0/0xc()
Calling initcall 0xffffffff8085b5ec: init_nls_iso8859_15+0x0/0xc()
initcall 0xffffffff8085b5ec: init_nls_iso8859_15+0x0/0xc() returned 0.
initcall 0xffffffff8085b5ec ran for 0 msecs: init_nls_iso8859_15+0x0/0xc()
Calling initcall 0xffffffff8085b5f8: init_nls_utf8+0x0/0x38()
initcall 0xffffffff8085b5f8: init_nls_utf8+0x0/0x38() returned 0.
initcall 0xffffffff8085b5f8 ran for 0 msecs: init_nls_utf8+0x0/0x38()
Calling initcall 0xffffffff8085b630: init_smb_fs+0x0/0x70()
initcall 0xffffffff8085b630: init_smb_fs+0x0/0x70() returned 0.
initcall 0xffffffff8085b630 ran for 0 msecs: init_smb_fs+0x0/0x70()
Calling initcall 0xffffffff8085b6a0: init_affs_fs+0x0/0x60()
initcall 0xffffffff8085b6a0: init_affs_fs+0x0/0x60() returned 0.
initcall 0xffffffff8085b6a0 ran for 0 msecs: init_affs_fs+0x0/0x60()
Calling initcall 0xffffffff8085b700: init_romfs_fs+0x0/0x60()
initcall 0xffffffff8085b700: init_romfs_fs+0x0/0x60() returned 0.
initcall 0xffffffff8085b700 ran for 0 msecs: init_romfs_fs+0x0/0x60()
Calling initcall 0xffffffff8085b760: init_qnx4_fs+0x0/0x5e()
QNX4 filesystem 0.2.3 registered.
initcall 0xffffffff8085b760: init_qnx4_fs+0x0/0x5e() returned 0.
initcall 0xffffffff8085b760 ran for 1 msecs: init_qnx4_fs+0x0/0x5e()
Calling initcall 0xffffffff8085b7be: init_autofs_fs+0x0/0xc()
initcall 0xffffffff8085b7be: init_autofs_fs+0x0/0xc() returned 0.
initcall 0xffffffff8085b7be ran for 0 msecs: init_autofs_fs+0x0/0xc()
Calling initcall 0xffffffff8085b810: ocfs2_init+0x0/0x298()
OCFS2 1.3.3
initcall 0xffffffff8085b810: ocfs2_init+0x0/0x298() returned 0.
initcall 0xffffffff8085b810 ran for 0 msecs: ocfs2_init+0x0/0x298()
Calling initcall 0xffffffff8085bb40: init_o2nm+0x0/0xd0()
OCFS2 Node Manager 1.3.3
initcall 0xffffffff8085bb40: init_o2nm+0x0/0xd0() returned 0.
initcall 0xffffffff8085bb40 ran for 1 msecs: init_o2nm+0x0/0xd0()
Calling initcall 0xffffffff8085bc10: dlm_init+0x0/0xd2()
OCFS2 DLM 1.3.3
initcall 0xffffffff8085bc10: dlm_init+0x0/0xd2() returned 0.
initcall 0xffffffff8085bc10 ran for 0 msecs: dlm_init+0x0/0xd2()
Calling initcall 0xffffffff8085bce2: init_dlmfs_fs+0x0/0xce()
OCFS2 DLMFS 1.3.3
OCFS2 User DLM kernel interface loaded
initcall 0xffffffff8085bce2: init_dlmfs_fs+0x0/0xce() returned 0.
initcall 0xffffffff8085bce2 ran for 1 msecs: init_dlmfs_fs+0x0/0xce()
Calling initcall 0xffffffff8085be80: init_gfs2_fs+0x0/0x140()
GFS2 (built Dec 12 2007 09:43:29) installed
initcall 0xffffffff8085be80: init_gfs2_fs+0x0/0x140() returned 0.
initcall 0xffffffff8085be80 ran for 2 msecs: init_gfs2_fs+0x0/0x140()
Calling initcall 0xffffffff8085c119: key_proc_init+0x0/0x34()
initcall 0xffffffff8085c119: key_proc_init+0x0/0x34() returned 0.
initcall 0xffffffff8085c119 ran for 0 msecs: key_proc_init+0x0/0x34()
Calling initcall 0xffffffff8085c287: crypto_algapi_init+0x0/0x10()
initcall 0xffffffff8085c287: crypto_algapi_init+0x0/0x10() returned 0.
initcall 0xffffffff8085c287 ran for 0 msecs: crypto_algapi_init+0x0/0x10()
Calling initcall 0xffffffff8085c2bd: cryptomgr_init+0x0/0xc()
initcall 0xffffffff8085c2bd: cryptomgr_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2bd ran for 0 msecs: cryptomgr_init+0x0/0xc()
Calling initcall 0xffffffff8085c2c9: hmac_module_init+0x0/0xc()
initcall 0xffffffff8085c2c9: hmac_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2c9 ran for 0 msecs: hmac_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c2d5: init+0x0/0xc()
initcall 0xffffffff8085c2d5: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2d5 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c2e1: init+0x0/0xc()
initcall 0xffffffff8085c2e1: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c2e1 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c2ed: init+0x0/0x67()
initcall 0xffffffff8085c2ed: init+0x0/0x67() returned 0.
initcall 0xffffffff8085c2ed ran for 0 msecs: init+0x0/0x67()
Calling initcall 0xffffffff8085c354: crypto_cbc_module_init+0x0/0xc()
initcall 0xffffffff8085c354: crypto_cbc_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c354 ran for 0 msecs: crypto_cbc_module_init+0x0/0xc=
()
Calling initcall 0xffffffff8085c360: crypto_module_init+0x0/0xc()
initcall 0xffffffff8085c360: crypto_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c360 ran for 0 msecs: crypto_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c36c: crypto_module_init+0x0/0xc()
initcall 0xffffffff8085c36c: crypto_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c36c ran for 0 msecs: crypto_module_init+0x0/0xc()
Calling initcall 0xffffffff8085c378: init+0x0/0x39()
initcall 0xffffffff8085c378: init+0x0/0x39() returned 0.
initcall 0xffffffff8085c378 ran for 0 msecs: init+0x0/0x39()
Calling initcall 0xffffffff8085c3b1: init+0x0/0xc()
initcall 0xffffffff8085c3b1: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c3b1 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c3bd: init+0x0/0x39()
initcall 0xffffffff8085c3bd: init+0x0/0x39() returned 0.
initcall 0xffffffff8085c3bd ran for 0 msecs: init+0x0/0x39()
Calling initcall 0xffffffff8085c3f6: init+0x0/0xc()
initcall 0xffffffff8085c3f6: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c3f6 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c402: init+0x0/0xc()
initcall 0xffffffff8085c402: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c402 ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c40e: init+0x0/0xc()
initcall 0xffffffff8085c40e: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c40e ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c41a: init+0x0/0xc()
initcall 0xffffffff8085c41a: init+0x0/0xc() returned 0.
initcall 0xffffffff8085c41a ran for 0 msecs: init+0x0/0xc()
Calling initcall 0xffffffff8085c4da: async_tx_init+0x0/0x19()
async_tx: api initialized (sync-only)
initcall 0xffffffff8085c4da: async_tx_init+0x0/0x19() returned 0.
initcall 0xffffffff8085c4da ran for 0 msecs: async_tx_init+0x0/0x19()
Calling initcall 0xffffffff8085c4f3: async_memcpy_init+0x0/0x3()
initcall 0xffffffff8085c4f3: async_memcpy_init+0x0/0x3() returned 0.
initcall 0xffffffff8085c4f3 ran for 0 msecs: async_memcpy_init+0x0/0x3()
Calling initcall 0xffffffff8085c4f6: async_xor_init+0x0/0x3()
initcall 0xffffffff8085c4f6: async_xor_init+0x0/0x3() returned 0.
initcall 0xffffffff8085c4f6 ran for 0 msecs: async_xor_init+0x0/0x3()
Calling initcall 0xffffffff8085c824: bsg_init+0x0/0x143()
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall 0xffffffff8085c824: bsg_init+0x0/0x143() returned 0.
initcall 0xffffffff8085c824 ran for 0 msecs: bsg_init+0x0/0x143()
Calling initcall 0xffffffff8085c967: noop_init+0x0/0xc()
io scheduler noop registered
initcall 0xffffffff8085c967: noop_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c967 ran for 0 msecs: noop_init+0x0/0xc()
Calling initcall 0xffffffff8085c973: deadline_init+0x0/0xc()
io scheduler deadline registered (default)
initcall 0xffffffff8085c973: deadline_init+0x0/0xc() returned 0.
initcall 0xffffffff8085c973 ran for 0 msecs: deadline_init+0x0/0xc()
Calling initcall 0xffffffff8085c97f: blk_trace_init+0x0/0xe4()
initcall 0xffffffff8085c97f: blk_trace_init+0x0/0xe4() returned 0.
initcall 0xffffffff8085c97f ran for 0 msecs: blk_trace_init+0x0/0xe4()
Calling initcall 0xffffffff8085cc47: init_kmp+0x0/0xc()
initcall 0xffffffff8085cc47: init_kmp+0x0/0xc() returned 0.
initcall 0xffffffff8085cc47 ran for 0 msecs: init_kmp+0x0/0xc()
Calling initcall 0xffffffff803fb2c9: pci_init+0x0/0x2d()
PCI: Found disabled HT MSI Mapping on 0000:00:0b.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
Boot video device is 0000:01:00.0
initcall 0xffffffff803fb2c9: pci_init+0x0/0x2d() returned 0.
initcall 0xffffffff803fb2c9 ran for 19 msecs: pci_init+0x0/0x2d()
Calling initcall 0xffffffff8085d53e: pci_proc_init+0x0/0x6a()
initcall 0xffffffff8085d53e: pci_proc_init+0x0/0x6a() returned 0.
initcall 0xffffffff8085d53e ran for 0 msecs: pci_proc_init+0x0/0x6a()
Calling initcall 0xffffffff8085d659: corgibl_init+0x0/0xc()
initcall 0xffffffff8085d659: corgibl_init+0x0/0xc() returned 0.
initcall 0xffffffff8085d659 ran for 0 msecs: corgibl_init+0x0/0xc()
Calling initcall 0xffffffff8085d747: rand_initialize+0x0/0x2f()
initcall 0xffffffff8085d747: rand_initialize+0x0/0x2f() returned 0.
initcall 0xffffffff8085d747 ran for 0 msecs: rand_initialize+0x0/0x2f()
Calling initcall 0xffffffff8085d7bd: tty_init+0x0/0x1ec()
initcall 0xffffffff8085d7bd: tty_init+0x0/0x1ec() returned 0.
initcall 0xffffffff8085d7bd ran for 5 msecs: tty_init+0x0/0x1ec()
Calling initcall 0xffffffff8085d9db: pty_init+0x0/0x55e()
initcall 0xffffffff8085d9db: pty_init+0x0/0x55e() returned 0.
initcall 0xffffffff8085d9db ran for 47 msecs: pty_init+0x0/0x55e()
Calling initcall 0xffffffff8085e610: mxser_module_init+0x0/0x890()
MOXA Smartio/Industio family driver version 1.8
initcall 0xffffffff8085e610: mxser_module_init+0x0/0x890() returned 0.
initcall 0xffffffff8085e610 ran for 4 msecs: mxser_module_init+0x0/0x890()
Calling initcall 0xffffffff8085eea0: mxser_module_init+0x0/0x790()
MOXA Smartio/Industio family driver version 2.0.2
Couldn't install MOXA Smartio/Industio family tty driver !
initcall 0xffffffff8085eea0: mxser_module_init+0x0/0x790() returned -16.
initcall 0xffffffff8085eea0 ran for 1 msecs: mxser_module_init+0x0/0x790()
initcall at 0xffffffff8085eea0: mxser_module_init+0x0/0x790(): returned wit=
h error code -16
Calling initcall 0xffffffff8085f630: synclink_init+0x0/0x2a8()
SyncLink serial driver $Revision: 4.38 $
SyncLink serial driver $Revision: 4.38 $, tty major#253
initcall 0xffffffff8085f630: synclink_init+0x0/0x2a8() returned 0.
initcall 0xffffffff8085f630 ran for 15 msecs: synclink_init+0x0/0x2a8()
Calling initcall 0xffffffff8085f8d8: slgt_init+0x0/0x208()
SyncLink GT $Revision: 4.50 $
SyncLink GT $Revision: 4.50 $, tty major#252
SyncLink GT no devices found
initcall 0xffffffff8085f8d8: slgt_init+0x0/0x208() returned 0.
initcall 0xffffffff8085f8d8 ran for 3 msecs: slgt_init+0x0/0x208()
Calling initcall 0xffffffff8085fae0: sx_init+0x0/0x10c()
initcall 0xffffffff8085fae0: sx_init+0x0/0x10c() returned 0.
initcall 0xffffffff8085fae0 ran for 0 msecs: sx_init+0x0/0x10c()
Calling initcall 0xffffffff8085fbec: nvram_init+0x0/0x82()
Non-volatile memory driver v1.2
initcall 0xffffffff8085fbec: nvram_init+0x0/0x82() returned 0.
initcall 0xffffffff8085fbec ran for 0 msecs: nvram_init+0x0/0x82()
Calling initcall 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2()
telclk_interrup =3D 0xf non-mcpbl0010 hw.
initcall 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2() returned -6.
initcall 0xffffffff8085fc6e ran for 0 msecs: tlclk_init+0x0/0x1c2()
initcall at 0xffffffff8085fc6e: tlclk_init+0x0/0x1c2(): returned with error=
 code -6
Calling initcall 0xffffffff8085fe8c: agp_init+0x0/0x34()
Linux agpgart interface v0.102
initcall 0xffffffff8085fe8c: agp_init+0x0/0x34() returned 0.
initcall 0xffffffff8085fe8c ran for 0 msecs: agp_init+0x0/0x34()
Calling initcall 0xffffffff8085ff8b: agp_intel_init+0x0/0x25()
initcall 0xffffffff8085ff8b: agp_intel_init+0x0/0x25() returned 0.
initcall 0xffffffff8085ff8b ran for 0 msecs: agp_intel_init+0x0/0x25()
Calling initcall 0xffffffff8085ffb0: drm_core_init+0x0/0x148()
[drm] Initialized drm 1.1.0 20060810
initcall 0xffffffff8085ffb0: drm_core_init+0x0/0x148() returned 0.
initcall 0xffffffff8085ffb0 ran for 0 msecs: drm_core_init+0x0/0x148()
Calling initcall 0xffffffff808600f8: tdfx_init+0x0/0xc()
initcall 0xffffffff808600f8: tdfx_init+0x0/0xc() returned 0.
initcall 0xffffffff808600f8 ran for 0 msecs: tdfx_init+0x0/0xc()
Calling initcall 0xffffffff80860104: i915_init+0x0/0x1c()
initcall 0xffffffff80860104: i915_init+0x0/0x1c() returned 0.
initcall 0xffffffff80860104 ran for 0 msecs: i915_init+0x0/0x1c()
Calling initcall 0xffffffff808605b3: serial8250_init+0x0/0x143()
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
initcall 0xffffffff808605b3: serial8250_init+0x0/0x143() returned 0.
initcall 0xffffffff808605b3 ran for 2 msecs: serial8250_init+0x0/0x143()
Calling initcall 0xffffffff808606f6: serial8250_pci_init+0x0/0x15()
initcall 0xffffffff808606f6: serial8250_pci_init+0x0/0x15() returned 0.
initcall 0xffffffff808606f6 ran for 0 msecs: serial8250_pci_init+0x0/0x15()
Calling initcall 0xffffffff80860b68: parport_default_proc_register+0x0/0x28=
()
initcall 0xffffffff80860b68: parport_default_proc_register+0x0/0x28() retur=
ned 0.
initcall 0xffffffff80860b68 ran for 0 msecs: parport_default_proc_register+=
0x0/0x28()
Calling initcall 0xffffffff80860d92: topology_sysfs_init+0x0/0x5e()
initcall 0xffffffff80860d92: topology_sysfs_init+0x0/0x5e() returned 0.
initcall 0xffffffff80860d92 ran for 0 msecs: topology_sysfs_init+0x0/0x5e()
Calling initcall 0xffffffff80860df0: rd_init+0x0/0x1f0()
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
initcall 0xffffffff80860df0: rd_init+0x0/0x1f0() returned 0.
initcall 0xffffffff80860df0 ran for 1 msecs: rd_init+0x0/0x1f0()
Calling initcall 0xffffffff80861020: loop_init+0x0/0x192()
loop: module loaded
initcall 0xffffffff80861020: loop_init+0x0/0x192() returned 0.
initcall 0xffffffff80861020 ran for 1 msecs: loop_init+0x0/0x192()
Calling initcall 0xffffffff808611cf: cciss_init+0x0/0x2b()
HP CISS Driver (v 3.6.14)
initcall 0xffffffff808611cf: cciss_init+0x0/0x2b() returned 0.
initcall 0xffffffff808611cf ran for 0 msecs: cciss_init+0x0/0x2b()
Calling initcall 0xffffffff8046bcc6: DAC960_init_module+0x0/0x47()
initcall 0xffffffff8046bcc6: DAC960_init_module+0x0/0x47() returned 0.
initcall 0xffffffff8046bcc6 ran for 0 msecs: DAC960_init_module+0x0/0x47()
Calling initcall 0xffffffff808611fa: mm_init+0x0/0x1a6()
MM: desc_per_page =3D 128
initcall 0xffffffff808611fa: mm_init+0x0/0x1a6() returned 0.
initcall 0xffffffff808611fa ran for 0 msecs: mm_init+0x0/0x1a6()
Calling initcall 0xffffffff808613a0: e1000_init_module+0x0/0x7f()
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
initcall 0xffffffff808613a0: e1000_init_module+0x0/0x7f() returned 0.
initcall 0xffffffff808613a0 ran for 1 msecs: e1000_init_module+0x0/0x7f()
Calling initcall 0xffffffff80861500: plip_init+0x0/0x77()
initcall 0xffffffff80861500: plip_init+0x0/0x77() returned 0.
initcall 0xffffffff80861500 ran for 0 msecs: plip_init+0x0/0x77()
Calling initcall 0xffffffff80861577: happy_meal_probe+0x0/0x15()
initcall 0xffffffff80861577: happy_meal_probe+0x0/0x15() returned 0.
initcall 0xffffffff80861577 ran for 0 msecs: happy_meal_probe+0x0/0x15()
Calling initcall 0xffffffff8086158c: gem_init+0x0/0x15()
initcall 0xffffffff8086158c: gem_init+0x0/0x15() returned 0.
initcall 0xffffffff8086158c ran for 0 msecs: gem_init+0x0/0x15()
Calling initcall 0xffffffff808615a1: e100_init_module+0x0/0x5f()
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall 0xffffffff808615a1: e100_init_module+0x0/0x5f() returned 0.
initcall 0xffffffff808615a1 ran for 1 msecs: e100_init_module+0x0/0x5f()
Calling initcall 0xffffffff80861600: natsemi_init_mod+0x0/0x15()
initcall 0xffffffff80861600: natsemi_init_mod+0x0/0x15() returned 0.
initcall 0xffffffff80861600 ran for 0 msecs: natsemi_init_mod+0x0/0x15()
Calling initcall 0xffffffff80861615: fealnx_init+0x0/0x15()
initcall 0xffffffff80861615: fealnx_init+0x0/0x15() returned 0.
initcall 0xffffffff80861615 ran for 0 msecs: fealnx_init+0x0/0x15()
Calling initcall 0xffffffff8086162a: rhine_init+0x0/0x71()
initcall 0xffffffff8086162a: rhine_init+0x0/0x71() returned 0.
initcall 0xffffffff8086162a ran for 0 msecs: rhine_init+0x0/0x71()
Calling initcall 0xffffffff8086169b: sundance_init+0x0/0x15()
initcall 0xffffffff8086169b: sundance_init+0x0/0x15() returned 0.
initcall 0xffffffff8086169b ran for 0 msecs: sundance_init+0x0/0x15()
Calling initcall 0xffffffff80861702: net_olddevs_init+0x0/0xa1()
D-Link DE-620 pocket adapter not identified in the printer port
initcall 0xffffffff80861702: net_olddevs_init+0x0/0xa1() returned 0.
initcall 0xffffffff80861702 ran for 1 msecs: net_olddevs_init+0x0/0xa1()
Calling initcall 0xffffffff8086182a: init_nic+0x0/0x15()
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
PCI: Setting latency timer of device 0000:00:0a.0 to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:4=
1:12
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
initcall 0xffffffff8086182a: init_nic+0x0/0x15() returned 0.
initcall 0xffffffff8086182a ran for 492 msecs: init_nic+0x0/0x15()
Calling initcall 0xffffffff8086183f: ifb_init_module+0x0/0xe1()
initcall 0xffffffff8086183f: ifb_init_module+0x0/0xe1() returned 0.
initcall 0xffffffff8086183f ran for 0 msecs: ifb_init_module+0x0/0xe1()
Calling initcall 0xffffffff80862a62: rtl8139_init_module+0x0/0x15()
8139too Fast Ethernet driver 0.9.28
eth1: RealTek RTL8139 at 0xffffc200004d6000, 00:c0:df:03:68:5d, IRQ 11
eth1:  Identified 8139 chip type 'RTL-8139B'
initcall 0xffffffff80862a62: rtl8139_init_module+0x0/0x15() returned 0.
initcall 0xffffffff80862a62 ran for 3 msecs: rtl8139_init_module+0x0/0x15()
Calling initcall 0xffffffff80862a77: catc_init+0x0/0x35()
usbcore: registered new interface driver catc
drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
initcall 0xffffffff80862a77: catc_init+0x0/0x35() returned 0.
initcall 0xffffffff80862a77 ran for 1 msecs: catc_init+0x0/0x35()
Calling initcall 0xffffffff80862aac: usb_rtl8150_init+0x0/0x32()
drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/0=
8/27)
usbcore: registered new interface driver rtl8150
initcall 0xffffffff80862aac: usb_rtl8150_init+0x0/0x32() returned 0.
initcall 0xffffffff80862aac ran for 1 msecs: usb_rtl8150_init+0x0/0x32()
Calling initcall 0xffffffff80862ade: cdc_init+0x0/0x15()
usbcore: registered new interface driver cdc_ether
initcall 0xffffffff80862ade: cdc_init+0x0/0x15() returned 0.
initcall 0xffffffff80862ade ran for 0 msecs: cdc_init+0x0/0x15()
Calling initcall 0xffffffff80862af3: dm9601_init+0x0/0x15()
usbcore: registered new interface driver dm9601
initcall 0xffffffff80862af3: dm9601_init+0x0/0x15() returned 0.
initcall 0xffffffff80862af3 ran for 0 msecs: dm9601_init+0x0/0x15()
Calling initcall 0xffffffff80862b08: cdc_subset_init+0x0/0x15()
usbcore: registered new interface driver cdc_subset
initcall 0xffffffff80862b08: cdc_subset_init+0x0/0x15() returned 0.
initcall 0xffffffff80862b08 ran for 0 msecs: cdc_subset_init+0x0/0x15()
Calling initcall 0xffffffff80862b1d: mcs7830_init+0x0/0x15()
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall 0xffffffff80862b1d: mcs7830_init+0x0/0x15() returned 0.
initcall 0xffffffff80862b1d ran for 0 msecs: mcs7830_init+0x0/0x15()
Calling initcall 0xffffffff80862b32: usbnet_init+0x0/0x2d()
initcall 0xffffffff80862b32: usbnet_init+0x0/0x2d() returned 0.
initcall 0xffffffff80862b32 ran for 0 msecs: usbnet_init+0x0/0x2d()
Calling initcall 0xffffffff80862b5f: strip_init_driver+0x0/0x60()
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
initcall 0xffffffff80862b5f: strip_init_driver+0x0/0x60() returned 0.
initcall 0xffffffff80862b5f ran for 0 msecs: strip_init_driver+0x0/0x60()
Calling initcall 0xffffffff80862bbf: xircom_init+0x0/0x15()
initcall 0xffffffff80862bbf: xircom_init+0x0/0x15() returned 0.
initcall 0xffffffff80862bbf ran for 0 msecs: xircom_init+0x0/0x15()
Calling initcall 0xffffffff80862bd4: de4x5_module_init+0x0/0x1c()
initcall 0xffffffff80862bd4: de4x5_module_init+0x0/0x1c() returned 0.
initcall 0xffffffff80862bd4 ran for 0 msecs: de4x5_module_init+0x0/0x1c()
Calling initcall 0xffffffff80862c12: init_netconsole+0x0/0x24e()
console [netcon0] enabled
netconsole: network logging started
initcall 0xffffffff80862c12: init_netconsole+0x0/0x24e() returned 0.
initcall 0xffffffff80862c12 ran for 2 msecs: init_netconsole+0x0/0x24e()
Calling initcall 0xffffffff808630e7: spi_transport_init+0x0/0x35()
initcall 0xffffffff808630e7: spi_transport_init+0x0/0x35() returned 0.
initcall 0xffffffff808630e7 ran for 0 msecs: spi_transport_init+0x0/0x35()
Calling initcall 0xffffffff8086311c: sas_transport_init+0x0/0xb1()
initcall 0xffffffff8086311c: sas_transport_init+0x0/0xb1() returned 0.
initcall 0xffffffff8086311c ran for 0 msecs: sas_transport_init+0x0/0xb1()
Calling initcall 0xffffffff808631cd: sas_class_init+0x0/0x34()
initcall 0xffffffff808631cd: sas_class_init+0x0/0x34() returned 0.
initcall 0xffffffff808631cd ran for 0 msecs: sas_class_init+0x0/0x34()
Calling initcall 0xffffffff80863201: srp_transport_init+0x0/0x39()
initcall 0xffffffff80863201: srp_transport_init+0x0/0x39() returned 0.
initcall 0xffffffff80863201 ran for 0 msecs: srp_transport_init+0x0/0x39()
Calling initcall 0xffffffff8086323a: init_sd+0x0/0xd8()
initcall 0xffffffff8086323a: init_sd+0x0/0xd8() returned 0.
initcall 0xffffffff8086323a ran for 0 msecs: init_sd+0x0/0xd8()
Calling initcall 0xffffffff80863312: init_sr+0x0/0x43()
initcall 0xffffffff80863312: init_sr+0x0/0x43() returned 0.
initcall 0xffffffff80863312 ran for 0 msecs: init_sr+0x0/0x43()
Calling initcall 0xffffffff808633df: ahci_init+0x0/0x15()
initcall 0xffffffff808633df: ahci_init+0x0/0x15() returned 0.
initcall 0xffffffff808633df ran for 0 msecs: ahci_init+0x0/0x15()
Calling initcall 0xffffffff808633f4: piix_init+0x0/0x2f()
initcall 0xffffffff808633f4: piix_init+0x0/0x2f() returned 0.
initcall 0xffffffff808633f4 ran for 0 msecs: piix_init+0x0/0x2f()
Calling initcall 0xffffffff80863423: pdc_ata_init+0x0/0x15()
initcall 0xffffffff80863423: pdc_ata_init+0x0/0x15() returned 0.
initcall 0xffffffff80863423 ran for 0 msecs: pdc_ata_init+0x0/0x15()
Calling initcall 0xffffffff80863438: qs_ata_init+0x0/0x15()
initcall 0xffffffff80863438: qs_ata_init+0x0/0x15() returned 0.
initcall 0xffffffff80863438 ran for 0 msecs: qs_ata_init+0x0/0x15()
Calling initcall 0xffffffff8086344d: sil24_init+0x0/0x15()
initcall 0xffffffff8086344d: sil24_init+0x0/0x15() returned 0.
initcall 0xffffffff8086344d ran for 0 msecs: sil24_init+0x0/0x15()
Calling initcall 0xffffffff80863462: svia_init+0x0/0x15()
initcall 0xffffffff80863462: svia_init+0x0/0x15() returned 0.
initcall 0xffffffff80863462 ran for 0 msecs: svia_init+0x0/0x15()
Calling initcall 0xffffffff80863477: sis_init+0x0/0x15()
initcall 0xffffffff80863477: sis_init+0x0/0x15() returned 0.
initcall 0xffffffff80863477 ran for 0 msecs: sis_init+0x0/0x15()
Calling initcall 0xffffffff8086348c: mv_init+0x0/0x15()
initcall 0xffffffff8086348c: mv_init+0x0/0x15() returned 0.
initcall 0xffffffff8086348c ran for 0 msecs: mv_init+0x0/0x15()
Calling initcall 0xffffffff808634a1: amd_init+0x0/0x15()
pata_amd 0000:00:06.0: version 0.3.10
PCI: Setting latency timer of device 0000:00:06.0 to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48=20
ata1.00: configured for UDMA/100
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2.01: limited to UDMA/33 due to 40-wire cable
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
initcall 0xffffffff808634a1: amd_init+0x0/0x15() returned 0.
initcall 0xffffffff808634a1 ran for 724 msecs: amd_init+0x0/0x15()
Calling initcall 0xffffffff808634b6: cmd64x_init+0x0/0x15()
initcall 0xffffffff808634b6: cmd64x_init+0x0/0x15() returned 0.
initcall 0xffffffff808634b6 ran for 0 msecs: cmd64x_init+0x0/0x15()
Calling initcall 0xffffffff808634cb: cs5520_init+0x0/0x15()
initcall 0xffffffff808634cb: cs5520_init+0x0/0x15() returned 0.
initcall 0xffffffff808634cb ran for 0 msecs: cs5520_init+0x0/0x15()
Calling initcall 0xffffffff808634e0: cs5530_init+0x0/0x15()
initcall 0xffffffff808634e0: cs5530_init+0x0/0x15() returned 0.
initcall 0xffffffff808634e0 ran for 0 msecs: cs5530_init+0x0/0x15()
Calling initcall 0xffffffff808634f5: cy82c693_init+0x0/0x15()
initcall 0xffffffff808634f5: cy82c693_init+0x0/0x15() returned 0.
initcall 0xffffffff808634f5 ran for 0 msecs: cy82c693_init+0x0/0x15()
Calling initcall 0xffffffff8086350a: it821x_init+0x0/0x15()
initcall 0xffffffff8086350a: it821x_init+0x0/0x15() returned 0.
initcall 0xffffffff8086350a ran for 0 msecs: it821x_init+0x0/0x15()
Calling initcall 0xffffffff8086351f: ns87410_init+0x0/0x15()
initcall 0xffffffff8086351f: ns87410_init+0x0/0x15() returned 0.
initcall 0xffffffff8086351f ran for 0 msecs: ns87410_init+0x0/0x15()
Calling initcall 0xffffffff80863534: marvell_init+0x0/0x15()
initcall 0xffffffff80863534: marvell_init+0x0/0x15() returned 0.
initcall 0xffffffff80863534 ran for 0 msecs: marvell_init+0x0/0x15()
Calling initcall 0xffffffff80863549: mpiix_init+0x0/0x15()
initcall 0xffffffff80863549: mpiix_init+0x0/0x15() returned 0.
initcall 0xffffffff80863549 ran for 0 msecs: mpiix_init+0x0/0x15()
Calling initcall 0xffffffff8086355e: oldpiix_init+0x0/0x15()
initcall 0xffffffff8086355e: oldpiix_init+0x0/0x15() returned 0.
initcall 0xffffffff8086355e ran for 0 msecs: oldpiix_init+0x0/0x15()
Calling initcall 0xffffffff80863573: pdc202xx_init+0x0/0x15()
initcall 0xffffffff80863573: pdc202xx_init+0x0/0x15() returned 0.
initcall 0xffffffff80863573 ran for 0 msecs: pdc202xx_init+0x0/0x15()
Calling initcall 0xffffffff80863588: serverworks_init+0x0/0x15()
initcall 0xffffffff80863588: serverworks_init+0x0/0x15() returned 0.
initcall 0xffffffff80863588 ran for 0 msecs: serverworks_init+0x0/0x15()
Calling initcall 0xffffffff8086359d: via_init+0x0/0x15()
initcall 0xffffffff8086359d: via_init+0x0/0x15() returned 0.
initcall 0xffffffff8086359d ran for 0 msecs: via_init+0x0/0x15()
Calling initcall 0xffffffff808635b2: sis_init+0x0/0x15()
initcall 0xffffffff808635b2: sis_init+0x0/0x15() returned 0.
initcall 0xffffffff808635b2 ran for 0 msecs: sis_init+0x0/0x15()
Calling initcall 0xffffffff808635c7: cdrom_init+0x0/0x19()
initcall 0xffffffff808635c7: cdrom_init+0x0/0x19() returned 0.
initcall 0xffffffff808635c7 ran for 0 msecs: cdrom_init+0x0/0x19()
Calling initcall 0xffffffff808637ee: ehci_hcd_init+0x0/0x48()
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
PCI: No IRQ known for interrupt pin B of device 0000:00:02.1. Probably bugg=
y MP table.
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 s=
etup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall 0xffffffff808637ee: ehci_hcd_init+0x0/0x48() returned 0.
initcall 0xffffffff808637ee ran for 3 msecs: ehci_hcd_init+0x0/0x48()
Calling initcall 0xffffffff80863836: ohci_hcd_mod_init+0x0/0x62()
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
PCI: No IRQ known for interrupt pin A of device 0000:00:02.0. Probably bugg=
y MP table.
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 s=
etup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
initcall 0xffffffff80863836: ohci_hcd_mod_init+0x0/0x62() returned 0.
initcall 0xffffffff80863836 ran for 4 msecs: ohci_hcd_mod_init+0x0/0x62()
Calling initcall 0xffffffff80863898: uhci_hcd_init+0x0/0xdc()
USB Universal Host Controller Interface driver v3.0
initcall 0xffffffff80863898: uhci_hcd_init+0x0/0xdc() returned 0.
initcall 0xffffffff80863898 ran for 0 msecs: uhci_hcd_init+0x0/0xdc()
Calling initcall 0xffffffff80863974: sl811h_init+0x0/0x41()
sl811: driver sl811-hcd, 19 May 2005
initcall 0xffffffff80863974: sl811h_init+0x0/0x41() returned 0.
initcall 0xffffffff80863974 ran for 0 msecs: sl811h_init+0x0/0x41()
Calling initcall 0xffffffff808639b5: usblp_init+0x0/0x15()
usbcore: registered new interface driver usblp
initcall 0xffffffff808639b5: usblp_init+0x0/0x15() returned 0.
initcall 0xffffffff808639b5 ran for 1 msecs: usblp_init+0x0/0x15()
Calling initcall 0xffffffff808639ca: usb_stor_init+0x0/0x3c()
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall 0xffffffff808639ca: usb_stor_init+0x0/0x3c() returned 0.
initcall 0xffffffff808639ca ran for 2 msecs: usb_stor_init+0x0/0x3c()
Calling initcall 0xffffffff80863a06: berry_init+0x0/0x15()
usbcore: registered new interface driver berry_charge
initcall 0xffffffff80863a06: berry_init+0x0/0x15() returned 0.
initcall 0xffffffff80863a06 ran for 0 msecs: berry_init+0x0/0x15()
Calling initcall 0xffffffff80863a1b: ld_usb_init+0x0/0x37()
usbcore: registered new interface driver ldusb
initcall 0xffffffff80863a1b: ld_usb_init+0x0/0x37() returned 0.
initcall 0xffffffff80863a1b ran for 0 msecs: ld_usb_init+0x0/0x37()
Calling initcall 0xffffffff80863a52: uss720_init+0x0/0x74()
usbcore: registered new interface driver uss720
drivers/usb/misc/uss720.c: v0.6:USB Parport Cable driver for Cables using t=
he Lucent Technologies USS720 Chip
drivers/usb/misc/uss720.c: NOTE: this is a special purpose driver to allow =
nonstandard
drivers/usb/misc/uss720.c: protocols (eg. bitbang) over USS720 usb to paral=
lel cables
drivers/usb/misc/uss720.c: If you just want to connect to a printer, use us=
blp instead
initcall 0xffffffff80863a52: uss720_init+0x0/0x74() returned 0.
initcall 0xffffffff80863a52 ran for 4 msecs: uss720_init+0x0/0x74()
Calling initcall 0xffffffff80863b5d: i8042_init+0x0/0xb3()
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall 0xffffffff80863b5d: i8042_init+0x0/0xb3() returned 0.
initcall 0xffffffff80863b5d ran for 4 msecs: i8042_init+0x0/0xb3()
Calling initcall 0xffffffff80863c10: pcips2_init+0x0/0x15()
initcall 0xffffffff80863c10: pcips2_init+0x0/0x15() returned 0.
initcall 0xffffffff80863c10 ran for 0 msecs: pcips2_init+0x0/0x15()
Calling initcall 0xffffffff80863cbc: emu_init+0x0/0x24()
initcall 0xffffffff80863cbc: emu_init+0x0/0x24() returned 0.
initcall 0xffffffff80863cbc ran for 0 msecs: emu_init+0x0/0x24()
Calling initcall 0xffffffff80863dfb: mousedev_init+0x0/0x87()
mice: PS/2 mouse device common for all mice
initcall 0xffffffff80863dfb: mousedev_init+0x0/0x87() returned 0.
initcall 0xffffffff80863dfb ran for 0 msecs: mousedev_init+0x0/0x87()
Calling initcall 0xffffffff80863e82: joydev_init+0x0/0xc()
initcall 0xffffffff80863e82: joydev_init+0x0/0xc() returned 0.
initcall 0xffffffff80863e82 ran for 0 msecs: joydev_init+0x0/0xc()
Calling initcall 0xffffffff80863e8e: atkbd_init+0x0/0x15()
initcall 0xffffffff80863e8e: atkbd_init+0x0/0x15() returned 0.
initcall 0xffffffff80863e8e ran for 0 msecs: atkbd_init+0x0/0x15()
Calling initcall 0xffffffff80863ea3: sunkbd_init+0x0/0x15()
input: AT Translated Set 2 keyboard as /class/input/input0
initcall 0xffffffff80863ea3: sunkbd_init+0x0/0x15() returned 0.
initcall 0xffffffff80863ea3 ran for 29 msecs: sunkbd_init+0x0/0x15()
Calling initcall 0xffffffff80863eb8: lkkbd_init+0x0/0x15()
initcall 0xffffffff80863eb8: lkkbd_init+0x0/0x15() returned 0.
initcall 0xffffffff80863eb8 ran for 0 msecs: lkkbd_init+0x0/0x15()
Calling initcall 0xffffffff80863ecd: xtkbd_init+0x0/0x15()
initcall 0xffffffff80863ecd: xtkbd_init+0x0/0x15() returned 0.
initcall 0xffffffff80863ecd ran for 0 msecs: xtkbd_init+0x0/0x15()
Calling initcall 0xffffffff80863ee2: nkbd_init+0x0/0x15()
initcall 0xffffffff80863ee2: nkbd_init+0x0/0x15() returned 0.
initcall 0xffffffff80863ee2 ran for 0 msecs: nkbd_init+0x0/0x15()
Calling initcall 0xffffffff80863ef7: atp_init+0x0/0x19()
usbcore: registered new interface driver appletouch
initcall 0xffffffff80863ef7: atp_init+0x0/0x19() returned 0.
initcall 0xffffffff80863ef7 ran for 0 msecs: atp_init+0x0/0x19()
Calling initcall 0xffffffff80863f10: gc_init+0x0/0x76d()
initcall 0xffffffff80863f10: gc_init+0x0/0x76d() returned -19.
initcall 0xffffffff80863f10 ran for 0 msecs: gc_init+0x0/0x76d()
Calling initcall 0xffffffff8086467d: grip_init+0x0/0x19()
initcall 0xffffffff8086467d: grip_init+0x0/0x19() returned 0.
initcall 0xffffffff8086467d ran for 0 msecs: grip_init+0x0/0x19()
Calling initcall 0xffffffff80864696: sw_init+0x0/0x19()
initcall 0xffffffff80864696: sw_init+0x0/0x19() returned 0.
initcall 0xffffffff80864696 ran for 0 msecs: sw_init+0x0/0x19()
Calling initcall 0xffffffff808646af: spaceball_init+0x0/0x15()
initcall 0xffffffff808646af: spaceball_init+0x0/0x15() returned 0.
initcall 0xffffffff808646af ran for 0 msecs: spaceball_init+0x0/0x15()
Calling initcall 0xffffffff808646c4: warrior_init+0x0/0x15()
initcall 0xffffffff808646c4: warrior_init+0x0/0x15() returned 0.
initcall 0xffffffff808646c4 ran for 0 msecs: warrior_init+0x0/0x15()
Calling initcall 0xffffffff808646d9: mk712_init+0x0/0x1df()
mk712: device not present
initcall 0xffffffff808646d9: mk712_init+0x0/0x1df() returned -19.
initcall 0xffffffff808646d9 ran for 0 msecs: mk712_init+0x0/0x1df()
Calling initcall 0xffffffff808648b8: usbtouch_init+0x0/0x15()
usbcore: registered new interface driver usbtouchscreen
initcall 0xffffffff808648b8: usbtouch_init+0x0/0x15() returned 0.
initcall 0xffffffff808648b8 ran for 0 msecs: usbtouch_init+0x0/0x15()
Calling initcall 0xffffffff808648cd: pm_init+0x0/0x15()
initcall 0xffffffff808648cd: pm_init+0x0/0x15() returned 0.
initcall 0xffffffff808648cd ran for 0 msecs: pm_init+0x0/0x15()
Calling initcall 0xffffffff808648e2: ucb1400_ts_init+0x0/0xc()
initcall 0xffffffff808648e2: ucb1400_ts_init+0x0/0xc() returned 0.
initcall 0xffffffff808648e2 ran for 0 msecs: ucb1400_ts_init+0x0/0xc()
Calling initcall 0xffffffff805492a7: w1_init+0x0/0x119()
Driver for 1-wire Dallas network protocol.
initcall 0xffffffff805492a7: w1_init+0x0/0x119() returned 0.
initcall 0xffffffff805492a7 ran for 0 msecs: w1_init+0x0/0x119()
Calling initcall 0xffffffff808649c6: matrox_w1_init+0x0/0x15()
initcall 0xffffffff808649c6: matrox_w1_init+0x0/0x15() returned 0.
initcall 0xffffffff808649c6 ran for 0 msecs: matrox_w1_init+0x0/0x15()
Calling initcall 0xffffffff808649db: w1_therm_init+0x0/0x28()
initcall 0xffffffff808649db: w1_therm_init+0x0/0x28() returned 0.
initcall 0xffffffff808649db ran for 0 msecs: w1_therm_init+0x0/0x28()
Calling initcall 0xffffffff80864a03: w1_f23_init+0x0/0xc()
initcall 0xffffffff80864a03: w1_f23_init+0x0/0xc() returned 0.
initcall 0xffffffff80864a03 ran for 0 msecs: w1_f23_init+0x0/0xc()
Calling initcall 0xffffffff80864a0f: raid5_init+0x0/0x34()
raid6: int64x1   2140 MB/s
raid6: int64x2   2656 MB/s
raid6: int64x4   2683 MB/s
raid6: int64x8   2121 MB/s
raid6: sse2x1    2792 MB/s
raid6: sse2x2    3414 MB/s
raid6: sse2x4    3925 MB/s
raid6: using algorithm sse2x4 (3925 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
initcall 0xffffffff80864a0f: raid5_init+0x0/0x34() returned 0.
initcall 0xffffffff80864a0f ran for 123 msecs: raid5_init+0x0/0x34()
Calling initcall 0xffffffff80864c8b: raid_init+0x0/0xc()
md: faulty personality registered for level -5
initcall 0xffffffff80864c8b: raid_init+0x0/0xc() returned 0.
initcall 0xffffffff80864c8b ran for 0 msecs: raid_init+0x0/0xc()
Calling initcall 0xffffffff80864e18: cpufreq_gov_powersave_init+0x0/0xc()
initcall 0xffffffff80864e18: cpufreq_gov_powersave_init+0x0/0xc() returned =
0.
initcall 0xffffffff80864e18 ran for 0 msecs: cpufreq_gov_powersave_init+0x0=
/0xc()
Calling initcall 0xffffffff80864e24: cpufreq_gov_dbs_init+0x0/0xc()
initcall 0xffffffff80864e24: cpufreq_gov_dbs_init+0x0/0xc() returned 0.
initcall 0xffffffff80864e24 ran for 0 msecs: cpufreq_gov_dbs_init+0x0/0xc()
Calling initcall 0xffffffff80865900: dcdrbu_init+0x0/0x145()
initcall 0xffffffff80865900: dcdrbu_init+0x0/0x145() returned 0.
initcall 0xffffffff80865900 ran for 0 msecs: dcdrbu_init+0x0/0x145()
Calling initcall 0xffffffff80865a45: dcdbas_init+0x0/0x63()
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
initcall 0xffffffff80865a45: dcdbas_init+0x0/0x63() returned 0.
initcall 0xffffffff80865a45 ran for 1 msecs: dcdbas_init+0x0/0x63()
Calling initcall 0xffffffff80865aa8: init_soundcore+0x0/0x5d()
initcall 0xffffffff80865aa8: init_soundcore+0x0/0x5d() returned 0.
initcall 0xffffffff80865aa8 ran for 0 msecs: init_soundcore+0x0/0x5d()
Calling initcall 0xffffffff8086756f: flow_cache_init+0x0/0x1b7()
initcall 0xffffffff8086756f: flow_cache_init+0x0/0x1b7() returned 0.
initcall 0xffffffff8086756f ran for 0 msecs: flow_cache_init+0x0/0x1b7()
Calling initcall 0xffffffff808677a5: llc_init+0x0/0x81()
initcall 0xffffffff808677a5: llc_init+0x0/0x81() returned 0.
initcall 0xffffffff808677a5 ran for 0 msecs: llc_init+0x0/0x81()
Calling initcall 0xffffffff80867826: snap_init+0x0/0x3b()
initcall 0xffffffff80867826: snap_init+0x0/0x3b() returned 0.
initcall 0xffffffff80867826 ran for 0 msecs: snap_init+0x0/0x3b()
Calling initcall 0xffffffff80867861: rif_init+0x0/0x74()
initcall 0xffffffff80867861: rif_init+0x0/0x74() returned 0.
initcall 0xffffffff80867861 ran for 0 msecs: rif_init+0x0/0x74()
Calling initcall 0xffffffff8086799c: blackhole_module_init+0x0/0xc()
initcall 0xffffffff8086799c: blackhole_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8086799c ran for 0 msecs: blackhole_module_init+0x0/0xc()
Calling initcall 0xffffffff80867a46: police_init_module+0x0/0xc()
initcall 0xffffffff80867a46: police_init_module+0x0/0xc() returned 0.
initcall 0xffffffff80867a46 ran for 0 msecs: police_init_module+0x0/0xc()
Calling initcall 0xffffffff80867a52: mirred_init_module+0x0/0x22()
Mirror/redirect action on
initcall 0xffffffff80867a52: mirred_init_module+0x0/0x22() returned 0.
initcall 0xffffffff80867a52 ran for 0 msecs: mirred_init_module+0x0/0x22()
Calling initcall 0xffffffff80867a74: nat_init_module+0x0/0xc()
initcall 0xffffffff80867a74: nat_init_module+0x0/0xc() returned 0.
initcall 0xffffffff80867a74 ran for 0 msecs: nat_init_module+0x0/0xc()
Calling initcall 0xffffffff80867a80: simp_init_module+0x0/0x25()
Simple TC action Loaded
initcall 0xffffffff80867a80: simp_init_module+0x0/0x25() returned 0.
initcall 0xffffffff80867a80 ran for 0 msecs: simp_init_module+0x0/0x25()
Calling initcall 0xffffffff80867aa5: red_module_init+0x0/0xc()
initcall 0xffffffff80867aa5: red_module_init+0x0/0xc() returned 0.
initcall 0xffffffff80867aa5 ran for 0 msecs: red_module_init+0x0/0xc()
Calling initcall 0xffffffff80867ab1: ingress_module_init+0x0/0x29()
initcall 0xffffffff80867ab1: ingress_module_init+0x0/0x29() returned 0.
initcall 0xffffffff80867ab1 ran for 0 msecs: ingress_module_init+0x0/0x29()
Calling initcall 0xffffffff80867ada: teql_init+0x0/0xf3()
initcall 0xffffffff80867ada: teql_init+0x0/0xf3() returned 0.
initcall 0xffffffff80867ada ran for 0 msecs: teql_init+0x0/0xf3()
Calling initcall 0xffffffff80867c83: init_u32+0x0/0x4c()
u32 classifier
    Performance counters on
    input device check on=20
    Actions configured=20
initcall 0xffffffff80867c83: init_u32+0x0/0x4c() returned 0.
initcall 0xffffffff80867c83 ran for 3 msecs: init_u32+0x0/0x4c()
Calling initcall 0xffffffff808681b8: nf_conntrack_standalone_init+0x0/0xbd()
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
initcall 0xffffffff808681b8: nf_conntrack_standalone_init+0x0/0xbd() return=
ed 0.
initcall 0xffffffff808681b8 ran for 0 msecs: nf_conntrack_standalone_init+0=
x0/0xbd()
Calling initcall 0xffffffff8086834e: nf_conntrack_amanda_init+0x0/0xba()
initcall 0xffffffff8086834e: nf_conntrack_amanda_init+0x0/0xba() returned 0.
initcall 0xffffffff8086834e ran for 0 msecs: nf_conntrack_amanda_init+0x0/0=
xba()
Calling initcall 0xffffffff80868408: nf_conntrack_irc_init+0x0/0x16c()
initcall 0xffffffff80868408: nf_conntrack_irc_init+0x0/0x16c() returned 0.
initcall 0xffffffff80868408 ran for 0 msecs: nf_conntrack_irc_init+0x0/0x16=
c()
Calling initcall 0xffffffff80868574: nf_conntrack_sane_init+0x0/0x1af()
initcall 0xffffffff80868574: nf_conntrack_sane_init+0x0/0x1af() returned 0.
initcall 0xffffffff80868574 ran for 0 msecs: nf_conntrack_sane_init+0x0/0x1=
af()
Calling initcall 0xffffffff80868723: nf_conntrack_sip_init+0x0/0x1b3()
initcall 0xffffffff80868723: nf_conntrack_sip_init+0x0/0x1b3() returned 0.
initcall 0xffffffff80868723 ran for 0 msecs: nf_conntrack_sip_init+0x0/0x1b=
3()
Calling initcall 0xffffffff808688d6: xt_init+0x0/0x7e()
initcall 0xffffffff808688d6: xt_init+0x0/0x7e() returned 0.
initcall 0xffffffff808688d6 ran for 0 msecs: xt_init+0x0/0x7e()
Calling initcall 0xffffffff80868954: xt_tcpudp_init+0x0/0x11()
initcall 0xffffffff80868954: xt_tcpudp_init+0x0/0x11() returned 0.
initcall 0xffffffff80868954 ran for 0 msecs: xt_tcpudp_init+0x0/0x11()
Calling initcall 0xffffffff80868965: xt_secmark_init+0x0/0x11()
initcall 0xffffffff80868965: xt_secmark_init+0x0/0x11() returned 0.
initcall 0xffffffff80868965 ran for 0 msecs: xt_secmark_init+0x0/0x11()
Calling initcall 0xffffffff80868976: xt_comment_init+0x0/0x11()
initcall 0xffffffff80868976: xt_comment_init+0x0/0x11() returned 0.
initcall 0xffffffff80868976 ran for 0 msecs: xt_comment_init+0x0/0x11()
Calling initcall 0xffffffff80868987: xt_connlimit_init+0x0/0x11()
initcall 0xffffffff80868987: xt_connlimit_init+0x0/0x11() returned 0.
initcall 0xffffffff80868987 ran for 0 msecs: xt_connlimit_init+0x0/0x11()
Calling initcall 0xffffffff80868998: xt_connmark_init+0x0/0x11()
initcall 0xffffffff80868998: xt_connmark_init+0x0/0x11() returned 0.
initcall 0xffffffff80868998 ran for 0 msecs: xt_connmark_init+0x0/0x11()
Calling initcall 0xffffffff808689a9: xt_mac_init+0x0/0x11()
initcall 0xffffffff808689a9: xt_mac_init+0x0/0x11() returned 0.
initcall 0xffffffff808689a9 ran for 0 msecs: xt_mac_init+0x0/0x11()
Calling initcall 0xffffffff808689ba: xt_pkttype_init+0x0/0x11()
initcall 0xffffffff808689ba: xt_pkttype_init+0x0/0x11() returned 0.
initcall 0xffffffff808689ba ran for 0 msecs: xt_pkttype_init+0x0/0x11()
Calling initcall 0xffffffff808689cb: xt_quota_init+0x0/0x11()
initcall 0xffffffff808689cb: xt_quota_init+0x0/0x11() returned 0.
initcall 0xffffffff808689cb ran for 0 msecs: xt_quota_init+0x0/0x11()
Calling initcall 0xffffffff808689dc: xt_realm_init+0x0/0xc()
initcall 0xffffffff808689dc: xt_realm_init+0x0/0xc() returned 0.
initcall 0xffffffff808689dc ran for 0 msecs: xt_realm_init+0x0/0xc()
Calling initcall 0xffffffff808689e8: xt_state_init+0x0/0x11()
initcall 0xffffffff808689e8: xt_state_init+0x0/0x11() returned 0.
initcall 0xffffffff808689e8 ran for 0 msecs: xt_state_init+0x0/0x11()
Calling initcall 0xffffffff808689f9: xt_tcpmss_init+0x0/0x17()
initcall 0xffffffff808689f9: xt_tcpmss_init+0x0/0x17() returned 0.
initcall 0xffffffff808689f9 ran for 0 msecs: xt_tcpmss_init+0x0/0x17()
Calling initcall 0xffffffff80869ba2: init_syncookies+0x0/0x1c()
initcall 0xffffffff80869ba2: init_syncookies+0x0/0x1c() returned 0.
initcall 0xffffffff80869ba2 ran for 0 msecs: init_syncookies+0x0/0x1c()
Calling initcall 0xffffffff80869bbe: esp4_init+0x0/0x70()
initcall 0xffffffff80869bbe: esp4_init+0x0/0x70() returned 0.
initcall 0xffffffff80869bbe ran for 0 msecs: esp4_init+0x0/0x70()
Calling initcall 0xffffffff80869c2e: ipcomp4_init+0x0/0x70()
initcall 0xffffffff80869c2e: ipcomp4_init+0x0/0x70() returned 0.
initcall 0xffffffff80869c2e ran for 0 msecs: ipcomp4_init+0x0/0x70()
Calling initcall 0xffffffff80869c9e: ipip_init+0x0/0xbe()
initcall 0xffffffff80869c9e: ipip_init+0x0/0xbe() returned 0.
initcall 0xffffffff80869c9e ran for 0 msecs: ipip_init+0x0/0xbe()
Calling initcall 0xffffffff80869d5c: tunnel4_init+0x0/0x74()
initcall 0xffffffff80869d5c: tunnel4_init+0x0/0x74() returned 0.
initcall 0xffffffff80869d5c ran for 0 msecs: tunnel4_init+0x0/0x74()
Calling initcall 0xffffffff805d4820: ipv4_netfilter_init+0x0/0xc()
initcall 0xffffffff805d4820: ipv4_netfilter_init+0x0/0xc() returned 0.
initcall 0xffffffff805d4820 ran for 0 msecs: ipv4_netfilter_init+0x0/0xc()
Calling initcall 0xffffffff8086b8bf: ip_tables_init+0x0/0x9f()
ip_tables: (C) 2000-2006 Netfilter Core Team
initcall 0xffffffff8086b8bf: ip_tables_init+0x0/0x9f() returned 0.
initcall 0xffffffff8086b8bf ran for 0 msecs: ip_tables_init+0x0/0x9f()
Calling initcall 0xffffffff8086b95e: iptable_filter_init+0x0/0x6d()
initcall 0xffffffff8086b95e: iptable_filter_init+0x0/0x6d() returned 0.
initcall 0xffffffff8086b95e ran for 0 msecs: iptable_filter_init+0x0/0x6d()
Calling initcall 0xffffffff8086b9cb: ipt_addrtype_init+0x0/0xc()
initcall 0xffffffff8086b9cb: ipt_addrtype_init+0x0/0xc() returned 0.
initcall 0xffffffff8086b9cb ran for 0 msecs: ipt_addrtype_init+0x0/0xc()
Calling initcall 0xffffffff8086b9d7: ipt_ecn_init+0x0/0xc()
initcall 0xffffffff8086b9d7: ipt_ecn_init+0x0/0xc() returned 0.
initcall 0xffffffff8086b9d7 ran for 0 msecs: ipt_ecn_init+0x0/0xc()
Calling initcall 0xffffffff8086b9e3: ipt_recent_init+0x0/0x84()
initcall 0xffffffff8086b9e3: ipt_recent_init+0x0/0x84() returned 0.
initcall 0xffffffff8086b9e3 ran for 0 msecs: ipt_recent_init+0x0/0x84()
Calling initcall 0xffffffff8086ba67: ipt_reject_init+0x0/0xc()
initcall 0xffffffff8086ba67: ipt_reject_init+0x0/0xc() returned 0.
initcall 0xffffffff8086ba67 ran for 0 msecs: ipt_reject_init+0x0/0xc()
Calling initcall 0xffffffff8086ba73: cubictcp_register+0x0/0x88()
TCP cubic registered
initcall 0xffffffff8086ba73: cubictcp_register+0x0/0x88() returned 0.
initcall 0xffffffff8086ba73 ran for 0 msecs: cubictcp_register+0x0/0x88()
Calling initcall 0xffffffff8086bcbf: xfrm_user_init+0x0/0x5b()
Initializing XFRM netlink socket
initcall 0xffffffff8086bcbf: xfrm_user_init+0x0/0x5b() returned 0.
initcall 0xffffffff8086bcbf ran for 0 msecs: xfrm_user_init+0x0/0x5b()
Calling initcall 0xffffffff8086bd1a: af_unix_init+0x0/0x62()
NET: Registered protocol family 1
initcall 0xffffffff8086bd1a: af_unix_init+0x0/0x62() returned 0.
initcall 0xffffffff8086bd1a ran for 0 msecs: af_unix_init+0x0/0x62()
Calling initcall 0xffffffff8086bd7c: packet_init+0x0/0x54()
NET: Registered protocol family 17
initcall 0xffffffff8086bd7c: packet_init+0x0/0x54() returned 0.
initcall 0xffffffff8086bd7c ran for 0 msecs: packet_init+0x0/0x54()
Calling initcall 0xffffffff8086be70: atalk_init+0x0/0x89()
NET: Registered protocol family 5
initcall 0xffffffff8086be70: atalk_init+0x0/0x89() returned 0.
initcall 0xffffffff8086be70 ran for 7 msecs: atalk_init+0x0/0x89()
Calling initcall 0xffffffff8086c115: lapb_init+0x0/0xb()
initcall 0xffffffff8086c115: lapb_init+0x0/0xb() returned 0.
initcall 0xffffffff8086c115 ran for 0 msecs: lapb_init+0x0/0xb()
Calling initcall 0xffffffff8086c299: econet_proto_init+0x0/0x3d()
NET: Registered protocol family 19
initcall 0xffffffff8086c299: econet_proto_init+0x0/0x3d() returned 0.
initcall 0xffffffff8086c299 ran for 0 msecs: econet_proto_init+0x0/0x3d()
Calling initcall 0xffffffff8086c2d6: vlan_proto_init+0x0/0xc0()
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
initcall 0xffffffff8086c2d6: vlan_proto_init+0x0/0xc0() returned 0.
initcall 0xffffffff8086c2d6 ran for 1 msecs: vlan_proto_init+0x0/0xc0()
Calling initcall 0xffffffff8086c410: dccp_init+0x0/0x3fc()
initcall 0xffffffff8086c410: dccp_init+0x0/0x3fc() returned 0.
initcall 0xffffffff8086c410 ran for 1 msecs: dccp_init+0x0/0x3fc()
Calling initcall 0xffffffff8086c8e1: dccp_v4_init+0x0/0x8d()
initcall 0xffffffff8086c8e1: dccp_v4_init+0x0/0x8d() returned 0.
initcall 0xffffffff8086c8e1 ran for 3 msecs: dccp_v4_init+0x0/0x8d()
Calling initcall 0xffffffff8086c96e: ccid2_module_init+0x0/0xc()
CCID: Registered CCID 2 (ccid2)
initcall 0xffffffff8086c96e: ccid2_module_init+0x0/0xc() returned 0.
initcall 0xffffffff8086c96e ran for 0 msecs: ccid2_module_init+0x0/0xc()
Calling initcall 0xffffffff8084c480: powernowk8_init+0x0/0x98()
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ process=
ors (1 cpu cores) (version 2.20.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects
------------[ cut here ]------------
kernel BUG at drivers/cpufreq/cpufreq.c:1060!
invalid opcode: 0000 [1] SMP=20
CPU 0=20
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc4-cfs-v24 #1926
RIP: 0010:[<ffffffff8056021a>]  [<ffffffff8056021a>] cpufreq_remove_dev+0x1=
60/0x2ad
RSP: 0000:ffff81003f9c3e60  EFLAGS: 00010286
RAX: 00000000ffffffff RBX: ffffffff808b30e0 RCX: ffff810001010718
RDX: ffffffff80818080 RSI: 0000000000000286 RDI: ffff810001010714
RBP: ffffffff8080bb80 R08: 0000000000000000 R09: ffff81003f320b40
R10: 0000000000000000 R11: ffffffff80404285 R12: ffffffff808b30e0
R13: ffffffff807f00a0 R14: ffffffff80723038 R15: 00000001100dbe5d
FS:  0000000000000000(0000) GS:ffffffff80818000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000f06f53 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f9c2000, task ffff81003f9c0000)
Stack:  ffffffff808b30e0 ffffffff8080bb80 ffffffff807f00d0 ffffffff807f00a0
 ffffffff80723038 ffffffff80455c03 00000001100dbe5d 0000000000000000
 00000000ffffffed ffffffff807c8c48 0000000000000000 ffffffff8055f635
Call Trace:
 [<ffffffff80455c03>] sysdev_driver_unregister+0x53/0x8a
 [<ffffffff8055f635>] cpufreq_register_driver+0x148/0x188
 [<ffffffff808436cb>] kernel_init+0x14b/0x318
 [<ffffffff8020ce78>] child_rip+0xa/0x12
 [<ffffffff80843580>] kernel_init+0x0/0x318
 [<ffffffff8020ce6e>] child_rip+0x0/0x12


Code: 0f 0b eb fe 48 89 df e8 da 73 e8 ff 89 c5 83 f8 07 0f 87 49=20
RIP  [<ffffffff8056021a>] cpufreq_remove_dev+0x160/0x2ad
 RSP <ffff81003f9c3e60>
Kernel panic - not syncing: Attempted to kill init!

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc4-cfs-v24
# Wed Dec 12 09:43:15 2007
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_QUICKLIST is not set
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_HT=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_BOOTPARAM_SUPPORT=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
CONFIG_BOOTPARAM_MAXCPUS_1=y
# CONFIG_BOOTPARAM_NOSMP is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=m
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
# CONFIG_BOOTPARAM_NO_HZ_OFF is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_BOOTPARAM_HIGHRES_OFF=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
CONFIG_MPSC=y
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_NUMA=y
# CONFIG_K8_NUMA is not set
CONFIG_THREAD_ORDER=1
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_MIGRATION is not set
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_MTRR is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_ALL is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_BOOTPARAM_NMI_WATCHDOG_BIT_1=y
# CONFIG_BOOTPARAM_NOAPIC is not set
CONFIG_BOOTPARAM_NOLAPIC=y
# CONFIG_BOOTPARAM_LAPIC is not set
CONFIG_BOOTPARAM_HPET_DISABLE=y
CONFIG_BOOTPARAM_IDLE_MWAIT=y
# CONFIG_BOOTPARAM_IDLE_POLL is not set
# CONFIG_BOOTPARAM_HIGHMEM_512M is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
# CONFIG_PM is not set
CONFIG_SUSPEND_SMP_POSSIBLE=y
CONFIG_HIBERNATION_SMP_POSSIBLE=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IP_VS is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK_ENABLED=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
CONFIG_NF_CT_PROTO_GRE=m
# CONFIG_NF_CT_PROTO_SCTP is not set
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=y
# CONFIG_NF_CONNTRACK_FTP is not set
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
# CONFIG_NF_CONNTRACK_TFTP is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_IPRANGE=m
CONFIG_IP_NF_MATCH_TOS=m
CONFIG_IP_NF_MATCH_RECENT=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_AH is not set
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_OWNER=m
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_TOS=m
# CONFIG_IP_NF_TARGET_ECN is not set
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration (EXPERIMENTAL)
#
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_RT is not set
# CONFIG_IP6_NF_MATCH_OPTS is not set
CONFIG_IP6_NF_MATCH_FRAG=m
# CONFIG_IP6_NF_MATCH_HL is not set
CONFIG_IP6_NF_MATCH_OWNER=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
# CONFIG_IP6_NF_MATCH_AH is not set
# CONFIG_IP6_NF_MATCH_MH is not set
# CONFIG_IP6_NF_MATCH_EUI64 is not set
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_LOG is not set
CONFIG_IP6_NF_TARGET_REJECT=m
# CONFIG_IP6_NF_MANGLE is not set
# CONFIG_IP6_NF_RAW is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m

#
# Bridge: Netfilter Configuration
#
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=y
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
# CONFIG_ATM_BR2684 is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=y
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RR=m
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
# CONFIG_NET_ACT_GACT is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_CLS_POLICE=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=m
CONFIG_IEEE80211_DEBUG=y
CONFIG_IEEE80211_CRYPT_WEP=m
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
CONFIG_IEEE80211_SOFTMAC=m
# CONFIG_IEEE80211_SOFTMAC_DEBUG is not set
# CONFIG_RFKILL is not set
CONFIG_NET_9P=m
# CONFIG_NET_9P_FD is not set
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=m
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_EEPROM_93CX6=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_LIBSAS_DEBUG=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=m
CONFIG_SATA_SIL24=y
CONFIG_SATA_SIS=y
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT821X=y
CONFIG_PATA_IT8213=m
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NS87410=y
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RZ1000=m
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=m
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
# CONFIG_MD_RAID5_RESHAPE is not set
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=y
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_IFB=y
# CONFIG_DUMMY is not set
CONFIG_BONDING=m
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
CONFIG_IP1000=m
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=m
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=m
# CONFIG_ULI526X is not set
CONFIG_PCMCIA_XIRCOM=y
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
# CONFIG_PCNET32_NAPI is not set
CONFIG_AMD8111_ETH=m
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=m
# CONFIG_ADAPTEC_STARFIRE_NAPI is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=y
CONFIG_FEALNX=y
CONFIG_NATSEMI=y
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=m
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
CONFIG_SIS900=m
# CONFIG_EPIC100 is not set
CONFIG_SUNDANCE=y
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_RHINE_NAPI=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
# CONFIG_DE600 is not set
CONFIG_DE620=y
# CONFIG_NETDEV_1000 is not set
CONFIG_E1000=y
# CONFIG_NETDEV_10000 is not set
CONFIG_TR=y
# CONFIG_IBMOL is not set
# CONFIG_3C359 is not set
CONFIG_TMS380TR=y
# CONFIG_TMSPCI is not set
# CONFIG_ABYSS is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=y
# CONFIG_PCMCIA_WAVELAN is not set
# CONFIG_PCMCIA_NETWAVE is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_GL620A=m
# CONFIG_USB_NET_NET1080 is not set
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PLIP=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=m
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
CONFIG_DIGIEPCA=m
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
CONFIG_MOXA_SMARTIO_NEW=y
CONFIG_ISI=m
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=m
# CONFIG_SPECIALIX is not set
CONFIG_SX=y
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
# CONFIG_PPDEV is not set
# CONFIG_TIPAR is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_PROSAVAGE=m
# CONFIG_I2C_SAVAGE4 is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_STUB=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m

#
# Miscellaneous I2C Chip support
#
CONFIG_SENSORS_DS1337=m
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=m

#
# Multimedia devices
#
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=m
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_HECUBA=m
CONFIG_FB_HGA=m
CONFIG_FB_HGA_ACCEL=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
# CONFIG_FB_INTEL_I2C is not set
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
# CONFIG_FB_MATROX_I2C is not set
# CONFIG_FB_MATROX_MULTIHEAD is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=m
CONFIG_FB_GEODE_GX=m
CONFIG_FB_GEODE_GX_SET_FBSIZE=y
CONFIG_FB_GEODE_GX_FBSIZE=0x1600000
CONFIG_FB_GEODE_GX1=m
# CONFIG_FB_SM501 is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=m
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=m
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AZT3328=m
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
# CONFIG_SND_CS5530 is not set
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
# CONFIG_SND_MONA is not set
CONFIG_SND_MIA=m
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
CONFIG_SND_ICE1712=m
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=m
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=m
CONFIG_SND_KORG1212_FIRMWARE_IN_KERNEL=y
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_SPLIT_ISO=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_CS=m
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
# CONFIG_USB_PHIDGETSERVO is not set
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=m
CONFIG_EXT4DEV_FS_XATTR=y
# CONFIG_EXT4DEV_FS_POSIX_ACL is not set
# CONFIG_EXT4DEV_FS_SECURITY is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_GFS2_FS_LOCKING_NOLOCK is not set
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_MINIX_FS=y
CONFIG_ROMFS_FS=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
CONFIG_NFSD=m
# CONFIG_NFSD_V3 is not set
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_EXPORTFS=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BIND34=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=y
CONFIG_CODA_FS_OLD_API=y
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_INSTRUMENTATION is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_AES is not set
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_HW=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_FORCE_MINIMAL_CONFIG=y

--wRRV7LY7NUeQGEoC--
