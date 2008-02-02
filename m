Return-Path: <linux-kernel-owner+w=401wt.eu-S933199AbYBBK43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbYBBK43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 05:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763553AbYBBK4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 05:56:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60837 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763545AbYBBKz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 05:55:56 -0500
Date: Sat, 2 Feb 2008 11:55:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: gregkh@suse.de
Cc: shaohua.li@intel.com, auke-jan.h.kok@intel.com, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       matthew@wil.cx, venkatesh.pallipadi@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [bootup crash, -git] Re: patch pci-pcie-aspm-support.patch added
	to gregkh-2.6 tree
Message-ID: <20080202105506.GA25160@elte.hu>
References: <1201141317.26118.2.camel@sli10-desk.sh.intel.com> <12013009171835@kroah.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <12013009171835@kroah.org>
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


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* gregkh@suse.de <gregkh@suse.de> wrote:

> This is a note to let you know that I've just added the patch titled
> 
>      Subject: PCI: PCIE ASPM support
> 
> to my gregkh-2.6 tree.  Its filename is
> 
>      pci-pcie-aspm-support.patch

uhm. One week ago this patch was added to your PCI tree. It never 
touched -mm AFAICS and today it was merged upstream (commit 
6c723d5bd89f03fc3ef627d50f89ade054d2ee3b):

Which is not necessarily a problem in itself, as long as you test it 
through and are reasonably sure that it wont break systems en masse. But 
this patch very evidently was not tested in any sufficient manner on its 
primary platform (x86) because my randconfig testsystems (bog standard 
x86 hw) started crashing during bootup almost immediately:

[   22.716747] initcall 0xc0a7b517 ran for 0 msecs: random32_reseed+0x0/0x24()
[   22.722413] Calling initcall 0xc0a7bac1: pci_sysfs_init+0x0/0x44()
[   22.730099] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[   22.737093] IP: [<c034226b>] pcie_aspm_create_sysfs_dev_files+0x1e/0x58
[   22.740003] *pde = 00000000 
[   22.742848] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[   22.747699] 
[   22.749174] Pid: 1, comm: swapper Not tainted (2.6.24 #5)
[   22.750000] EIP: 0060:[<c034226b>] EFLAGS: 00010246 CPU: 0
[   22.750000] EIP is at pcie_aspm_create_sysfs_dev_files+0x1e/0x58
[   22.750000] EAX: c32cf504 EBX: c32cf5d0 ECX: 00000000 EDX: 00000000
[   22.750000] ESI: 00000000 EDI: c32cf5d0 EBP: c327df50 ESP: c327df48
[   22.750000]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   22.750000] Process swapper (pid: 1, ti=c327d000 task=c327c000 task.ti=c327d000)
[   22.750000] Stack: 00000000 00000000 c327df84 c0340c38 c327df74 c0340188 ffffffff c32cf708 
[   22.750000]        00000000 00000000 00000006 c32cf6a8 00000000 c32cf5d0 00000000 c327df94 
[   22.750000]        c0a7badb 00000000 00000000 c327dfe0 c0a6c673 dbc866c8 00000008 00000000 
[   22.750000] Call Trace:
[   22.750000]  [<c0340c38>] ? pci_create_sysfs_dev_files+0x24f/0x2f2
[   22.750000]  [<c0340188>] ? pci_get_subsys+0xc2/0xcb
[   22.750000]  [<c0a7badb>] ? pci_sysfs_init+0x1a/0x44
[   22.750000]  [<c0a6c673>] ? kernel_init+0xb2/0x20b
[   22.750000]  [<c0a6c5c1>] ? kernel_init+0x0/0x20b
[   22.750000]  [<c01057a7>] ? kernel_thread_helper+0x7/0x10
[   22.750000]  =======================
[   22.750000] Code: 84 16 9b c0 e8 2d 6b e4 ff 5b 5e 5d c3 55 89 e5 56 53 89 c3 8b 70 48 f6 80 dd 03 00 00 04 74 41 8a 40 32 3c 04 74 04 3c 06 75 36 <83> 7e 0c 00 74 15 8d 83 38 01 00 00 b9 7c 16 9b c0 ba 68 16 9b 
[   22.750000] EIP: [<c034226b>] pcie_aspm_create_sysfs_dev_files+0x1e/0x58 SS:ESP 0068:c327df48
[   22.750003] ---[ end trace 204172de9b5128e1 ]---

config attached. The crash is fully repeatable on multiple systems. (can 
try any test-patch)

To add insult to injury, the new option is also default-enabled _AND_ 
experimental:

   config PCIEASPM
           bool "PCI Express ASPM support(Experimental)"
           depends on PCI && EXPERIMENTAL
           default y

and it only depends on PCI, so this will crash just about every system 
out there that tracks -git.

please ...

i've punched it out of the randconfig space via the hack below, to keep 
the tests going.

	Ingo

Index: linux/drivers/pci/pcie/Kconfig
===================================================================
--- linux.orig/drivers/pci/pcie/Kconfig
+++ linux/drivers/pci/pcie/Kconfig
@@ -33,6 +33,10 @@ source "drivers/pci/pcie/aer/Kconfig"
 config PCIEASPM
 	bool "PCI Express ASPM support(Experimental)"
 	depends on PCI && EXPERIMENTAL
+
+	# bootup crashes, Sat Feb  2 11:37:58 CET 2008
+	depends on 0
+
 	default y
 	help
 	  This enables PCI Express ASPM (Active State Power Management) and

--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"

[    0.000000] Linux version 2.6.24 (mingo@dione) (gcc version 4.2.2) #6 PREEMPT Sat Feb 2 11:32:42 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 262128) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262128
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262128
[    0.000000] On node 0 totalpages: 262128
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32497 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F76F0, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 3FFF3180, 6264 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 3FFF0000, 0040
[    0.000000] ACPI: SRAT 3FFF9500, 00A0 (r1 AMD    HAMMER          1 AMD         1)
[    0.000000] ACPI: MCFG 3FFF9600, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 3FFF9440, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260081
[    0.000000] Kernel command line: root=/dev/sda1 earlyprintk=serial,ttyS0,115200,keep 3 profile=0 debug initcall_debug enforcing=0 apic=verbose sysrq_always_enabled ignore_loglevel selinux=0
[    0.000000] kernel profiling enabled (shift: 0)
[    0.000000] debug: sysrq always enabled.
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0ad4000 soft=c0ad3000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2160.194 MHz processor.
[    0.010000] spurious 8259A interrupt: IRQ7.
[    0.010000] Console: colour VGA+ 80x25
[    0.010000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.010000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.010000] ... MAX_LOCK_DEPTH:          30
[    0.010000] ... MAX_LOCKDEP_KEYS:        2048
[    0.010000] ... CLASSHASH_SIZE:           1024
[    0.010000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.010000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.010000] ... CHAINHASH_SIZE:          8192
[    0.010000]  memory used by lock dependency info: 1024 kB
[    0.010000]  per task-struct memory footprint: 1680 bytes
[    0.010000] ------------------------
[    0.010000] | Locking API testsuite:
[    0.010000] ----------------------------------------------------------------------------
[    0.010000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[    0.010000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]               recursive read-lock:             |  ok  |             |failed|
[    0.010000]            recursive read-lock #2:             |  ok  |             |failed|
[    0.010000]             mixed read-write-lock:             |failed|             |failed|
[    0.010000]             mixed write-read-lock:             |failed|             |failed|
[    0.010000]   --------------------------------------------------------------------------
[    0.010000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.010000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.010000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[    0.010000]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[    0.010000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.010000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.010000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.010000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.010000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.010000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.010000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.010000]       soft-irq lock-inversion/321:failed|failed|  ok  |
[    0.010000]       hard-irq read-recursion/123:  ok  |
[    0.010000]       soft-irq read-recursion/123:  ok  |
[    0.010000]       hard-irq read-recursion/132:  ok  |
[    0.010000]       soft-irq read-recursion/132:  ok  |
[    0.010000]       hard-irq read-recursion/213:  ok  |
[    0.010000]       soft-irq read-recursion/213:  ok  |
[    0.010000]       hard-irq read-recursion/231:  ok  |
[    0.010000]       soft-irq read-recursion/231:  ok  |
[    0.010000]       hard-irq read-recursion/312:  ok  |
[    0.010000]       soft-irq read-recursion/312:  ok  |
[    0.010000]       hard-irq read-recursion/321:  ok  |
[    0.010000]       soft-irq read-recursion/321:  ok  |
[    0.010000] --------------------------------------------------------
[    0.010000] 133 out of 218 testcases failed, as expected. |
[    0.010000] ----------------------------------------------------
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 997996k/1048512k available (6351k kernel code, 49048k reserved, 3280k data, 412k init, 131008k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffd9000 - 0xfffff000   ( 152 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.010000]       .init : 0xc0a69000 - 0xc0ad0000   ( 412 kB)
[    0.010000]       .data : 0xc0733d0c - 0xc0a67e1c   (3280 kB)
[    0.010000]       .text : 0xc0100000 - 0xc0733d0c   (6351 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.160003] Calibrating delay using timer specific routine.. 4323.81 BogoMIPS (lpj=21619077)
[    0.168291] Security Framework initialized
[    0.170007] Capability LSM initialized
[    0.173728] Mount-cache hash table entries: 512
[    0.180275] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.187231] CPU: L2 Cache: 512K (64 bytes/line)
[    0.190004] Intel machine check architecture supported.
[    0.195195] Intel machine check reporting enabled on CPU#0.
[    0.200007] Compat vDSO mapped to ffffe000.
[    0.204157] CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
[    0.211209] Checking 'hlt' instruction... OK.
[    0.251541] debug: unmapping init memory c0a69000..c0a69000
[    0.256934] ACPI: Core revision 20070126
[    0.276804] ACPI: setting ELCR to 0200 (from 0828)
[    0.281622] PM: Adding info for No Bus:platform
[    0.286075] khelper used greatest stack depth: 3148 bytes left
[    0.291247] Calling initcall 0xc0a908c7: net_ns_init+0x0/0xdc()
[    0.300168] net_namespace: 320 bytes
[    0.303731] initcall 0xc0a908c7: net_ns_init+0x0/0xdc() returned 0.
[    0.309960] initcall 0xc0a908c7 ran for 0 msecs: net_ns_init+0x0/0xdc()
[    0.312075] Calling initcall 0xc0a6f913: reboot_init+0x0/0x11()
[    0.322251] initcall 0xc0a6f913: reboot_init+0x0/0x11() returned 0.
[    0.328488] initcall 0xc0a6f913 ran for 0 msecs: reboot_init+0x0/0x11()
[    0.332074] Calling initcall 0xc0a71608: print_banner+0x0/0xd()
[    0.340169] Booting paravirtualized kernel on bare hardware
[    0.345714] initcall 0xc0a71608: print_banner+0x0/0xd() returned 0.
[    0.351210] initcall 0xc0a71608 ran for 0 msecs: print_banner+0x0/0xd()
[    0.357795] Calling initcall 0xc0a73320: sysctl_init+0x0/0x28()
[    0.362393] initcall 0xc0a73320: sysctl_init+0x0/0x28() returned 0.
[    0.371208] initcall 0xc0a73320 ran for 0 msecs: sysctl_init+0x0/0x28()
[    0.377795] Calling initcall 0xc0a73c39: init_jiffies_clocksource+0x0/0xf()
[    0.383290] initcall 0xc0a73c39: init_jiffies_clocksource+0x0/0xf() returned 0.
[    0.391209] initcall 0xc0a73c39 ran for 0 msecs: init_jiffies_clocksource+0x0/0xf()
[    0.400002] Calling initcall 0xc0a73e4f: pm_init+0x0/0x2d()
[    0.405553] initcall 0xc0a73e4f: pm_init+0x0/0x2d() returned 0.
[    0.411208] initcall 0xc0a73e4f ran for 0 msecs: pm_init+0x0/0x2d()
[    0.417448] Calling initcall 0xc0a73e7c: ksysfs_init+0x0/0x96()
[    0.422261] initcall 0xc0a73e7c: ksysfs_init+0x0/0x96() returned 0.
[    0.428488] initcall 0xc0a73e7c ran for 0 msecs: ksysfs_init+0x0/0x96()
[    0.432075] Calling initcall 0xc0a754be: filelock_init+0x0/0x27()
[    0.442422] initcall 0xc0a754be: filelock_init+0x0/0x27() returned 0.
[    0.448834] initcall 0xc0a754be ran for 0 msecs: filelock_init+0x0/0x27()
[    0.452248] Calling initcall 0xc0a75c1f: init_aout_binfmt+0x0/0xf()
[    0.460174] initcall 0xc0a75c1f: init_aout_binfmt+0x0/0xf() returned 0.
[    0.466756] initcall 0xc0a75c1f ran for 0 msecs: init_aout_binfmt+0x0/0xf()
[    0.472422] Calling initcall 0xc0a75c2e: init_script_binfmt+0x0/0xf()
[    0.480170] initcall 0xc0a75c2e: init_script_binfmt+0x0/0xf() returned 0.
[    0.486928] initcall 0xc0a75c2e ran for 0 msecs: init_script_binfmt+0x0/0xf()
[    0.492595] Calling initcall 0xc0a75c3d: init_elf_binfmt+0x0/0xf()
[    0.500170] initcall 0xc0a75c3d: init_elf_binfmt+0x0/0xf() returned 0.
[    0.506669] initcall 0xc0a75c3d ran for 0 msecs: init_elf_binfmt+0x0/0xf()
[    0.512336] Calling initcall 0xc0a7737f: debugfs_init+0x0/0x41()
[    0.520178] initcall 0xc0a7737f: debugfs_init+0x0/0x41() returned 0.
[    0.526496] initcall 0xc0a7737f ran for 0 msecs: debugfs_init+0x0/0x41()
[    0.532161] Calling initcall 0xc0a77b86: securityfs_init+0x0/0x41()
[    0.540173] initcall 0xc0a77b86: securityfs_init+0x0/0x41() returned 0.
[    0.546754] initcall 0xc0a77b86 ran for 0 msecs: securityfs_init+0x0/0x41()
[    0.552421] Calling initcall 0xc0a783e6: random32_init+0x0/0x17()
[    0.560003] initcall 0xc0a783e6: random32_init+0x0/0x17() returned 0.
[    0.566408] initcall 0xc0a783e6 ran for 0 msecs: random32_init+0x0/0x17()
[    0.572248] Calling initcall 0xc03edb9b: early_resume_init+0x0/0x18c()
[    0.578795] Time: 11:40:41  Date: 02/02/08
[    0.580003] initcall 0xc03edb9b: early_resume_init+0x0/0x18c() returned 0.
[    0.590003] initcall 0xc03edb9b ran for 9 msecs: early_resume_init+0x0/0x18c()
[    0.597188] Calling initcall 0xc0611927: virtio_init+0x0/0x1f()
[    0.602320] initcall 0xc0611927: virtio_init+0x0/0x1f() returned 0.
[    0.610003] initcall 0xc0611927 ran for 0 msecs: virtio_init+0x0/0x1f()
[    0.616581] Calling initcall 0xc0a907bc: sock_init+0x0/0x4c()
[    0.622093] initcall 0xc0a907bc: sock_init+0x0/0x4c() returned 0.
[    0.628142] initcall 0xc0a907bc ran for 0 msecs: sock_init+0x0/0x4c()
[    0.631902] Calling initcall 0xc0a911b2: netpoll_init+0x0/0x39()
[    0.640170] initcall 0xc0a911b2: netpoll_init+0x0/0x39() returned 0.
[    0.646496] initcall 0xc0a911b2 ran for 0 msecs: netpoll_init+0x0/0x39()
[    0.652161] Calling initcall 0xc0a91685: netlink_proto_init+0x0/0x10d()
[    0.660189] NET: Registered protocol family 16
[    0.664610] initcall 0xc0a91685: netlink_proto_init+0x0/0x10d() returned 0.
[    0.671208] initcall 0xc0a91685 ran for 0 msecs: netlink_proto_init+0x0/0x10d()
[    0.678488] Calling initcall 0xc0a7832e: kobject_uevent_init+0x0/0x3f()
[    0.682947] initcall 0xc0a7832e: kobject_uevent_init+0x0/0x3f() returned 0.
[    0.691208] initcall 0xc0a7832e ran for 0 msecs: kobject_uevent_init+0x0/0x3f()
[    0.698487] Calling initcall 0xc0a784e1: pcibus_class_init+0x0/0xf()
[    0.702742] initcall 0xc0a784e1: pcibus_class_init+0x0/0xf() returned 0.
[    0.711208] initcall 0xc0a784e1 ran for 0 msecs: pcibus_class_init+0x0/0xf()
[    0.718228] Calling initcall 0xc0a78998: pci_driver_init+0x0/0xf()
[    0.722580] initcall 0xc0a78998: pci_driver_init+0x0/0xf() returned 0.
[    0.731208] initcall 0xc0a78998 ran for 0 msecs: pci_driver_init+0x0/0xf()
[    0.738054] Calling initcall 0xc0a78cac: lcd_class_init+0x0/0x3d()
[    0.742569] initcall 0xc0a78cac: lcd_class_init+0x0/0x3d() returned 0.
[    0.751208] initcall 0xc0a78cac ran for 0 msecs: lcd_class_init+0x0/0x3d()
[    0.758055] Calling initcall 0xc0a78ce9: backlight_class_init+0x0/0x3d()
[    0.763089] initcall 0xc0a78ce9: backlight_class_init+0x0/0x3d() returned 0.
[    0.771207] initcall 0xc0a78ce9 ran for 0 msecs: backlight_class_init+0x0/0x3d()
[    0.778573] Calling initcall 0xc0a78da2: video_output_class_init+0x0/0xf()
[    0.783262] initcall 0xc0a78da2: video_output_class_init+0x0/0xf() returned 0.
[    0.791208] initcall 0xc0a78da2 ran for 0 msecs: video_output_class_init+0x0/0xf()
[    0.800007] Calling initcall 0xc0a7acbb: tty_class_init+0x0/0x27()
[    0.806208] initcall 0xc0a7acbb: tty_class_init+0x0/0x27() returned 0.
[    0.813549] initcall 0xc0a7acbb ran for 0 msecs: tty_class_init+0x0/0x27()
[    0.820007] Calling initcall 0xc0a7b68e: vtconsole_class_init+0x0/0x9a()
[    0.826750] PM: Adding info for No Bus:vtcon0
[    0.830065] initcall 0xc0a7b68e: vtconsole_class_init+0x0/0x9a() returned 0.
[    0.837014] initcall 0xc0a7b68e ran for 9 msecs: vtconsole_class_init+0x0/0x9a()
[    0.842855] Calling initcall 0xc0a8dabc: lguest_devices_init+0x0/0x100()
[    0.853029] initcall 0xc0a8dabc: lguest_devices_init+0x0/0x100() returned 0.
[    0.860003] initcall 0xc0a8dabc ran for 0 msecs: lguest_devices_init+0x0/0x100()
[    0.867361] Calling initcall 0xc0a6dfb6: arch_kdebugfs_init+0x0/0x7()
[    0.872768] initcall 0xc0a6dfb6: arch_kdebugfs_init+0x0/0x7() returned 0.
[    0.880004] initcall 0xc0a6dfb6 ran for 0 msecs: arch_kdebugfs_init+0x0/0x7()
[    0.887101] Calling initcall 0xc0a6e068: init_pit_clocksource+0x0/0x64()
[    0.893040] initcall 0xc0a6e068: init_pit_clocksource+0x0/0x64() returned 0.
[    0.901209] initcall 0xc0a6e068 ran for 0 msecs: init_pit_clocksource+0x0/0x64()
[    0.908575] Calling initcall 0xc0a6eda0: mtrr_if_init+0x0/0x57()
[    0.912337] initcall 0xc0a6eda0: mtrr_if_init+0x0/0x57() returned 0.
[    0.920003] initcall 0xc0a6eda0 ran for 0 msecs: mtrr_if_init+0x0/0x57()
[    0.926667] Calling initcall 0xc0a6f889: ffh_cstate_init+0x0/0x2a()
[    0.932594] initcall 0xc0a6f889: ffh_cstate_init+0x0/0x2a() returned -1.
[    0.940003] initcall 0xc0a6f889 ran for 0 msecs: ffh_cstate_init+0x0/0x2a()
[    0.946929] initcall at 0xc0a6f889: ffh_cstate_init+0x0/0x2a(): returned with error code -1
[    0.955107] Calling initcall 0xc0a78c57: acpi_pci_init+0x0/0x3d()
[    0.960174] ACPI: bus type pci registered
[    0.964155] initcall 0xc0a78c57: acpi_pci_init+0x0/0x3d() returned 0.
[    0.971208] initcall 0xc0a78c57 ran for 0 msecs: acpi_pci_init+0x0/0x3d()
[    0.977968] Calling initcall 0xc0a79c66: init_acpi_device_notify+0x0/0x43()
[    0.983288] initcall 0xc0a79c66: init_acpi_device_notify+0x0/0x43() returned 0.
[    0.991208] initcall 0xc0a79c66 ran for 0 msecs: init_acpi_device_notify+0x0/0x43()
[    1.000002] Calling initcall 0xc0a8ee16: dmi_id_init+0x0/0x269()
[    1.006090] PM: Adding info for No Bus:id
[    1.010074] initcall 0xc0a8ee16: dmi_id_init+0x0/0x269() returned 0.
[    1.016320] initcall 0xc0a8ee16 ran for 9 msecs: dmi_id_init+0x0/0x269()
[    1.022161] Calling initcall 0xc0a8f438: pci_access_init+0x0/0x40()
[    1.030187] PCI: Using MMCONFIG
[    1.033318] PCI: No mmconfig possible on device 00:18
[    1.038767] initcall 0xc0a8f438: pci_access_init+0x0/0x40() returned 0.
[    1.043635] initcall 0xc0a8f438 ran for 0 msecs: pci_access_init+0x0/0x40()
[    1.050002] Calling initcall 0xc0a6cb42: request_standard_resources+0x0/0x61()
[    1.057189] Setting up standard PCI resources
[    1.063336] initcall 0xc0a6cb42: request_standard_resources+0x0/0x61() returned 0.
[    1.071209] initcall 0xc0a6cb42 ran for 9 msecs: request_standard_resources+0x0/0x61()
[    1.080002] Calling initcall 0xc0a6dfa3: topology_init+0x0/0x13()
[    1.086124] initcall 0xc0a6dfa3: topology_init+0x0/0x13() returned 0.
[    1.093461] initcall 0xc0a6dfa3 ran for 0 msecs: topology_init+0x0/0x13()
[    1.100012] Calling initcall 0xc0a6e9d2: mtrr_init_finialize+0x0/0x2c()
[    1.106582] initcall 0xc0a6e9d2: mtrr_init_finialize+0x0/0x2c() returned 0.
[    1.113981] initcall 0xc0a6e9d2 ran for 0 msecs: mtrr_init_finialize+0x0/0x2c()
[    1.120002] Calling initcall 0xc0a6f94d: mca_init+0x0/0x2bb()
[    1.125789] initcall 0xc0a6f94d: mca_init+0x0/0x2bb() returned -19.
[    1.133287] initcall 0xc0a6f94d ran for 0 msecs: mca_init+0x0/0x2bb()
[    1.140007] Calling initcall 0xc0a736f4: param_sysfs_init+0x0/0x154()
[    1.159607] initcall 0xc0a736f4: param_sysfs_init+0x0/0x154() returned 0.
[    1.163804] initcall 0xc0a736f4 ran for 9 msecs: param_sysfs_init+0x0/0x154()
[    1.172595] Calling initcall 0xc0137800: pm_sysrq_init+0x0/0x16()
[    1.178676] initcall 0xc0137800: pm_sysrq_init+0x0/0x16() returned 0.
[    1.183462] initcall 0xc0137800 ran for 0 msecs: pm_sysrq_init+0x0/0x16()
[    1.192960] Calling initcall 0xc0a7500a: readahead_init+0x0/0xf()
[    1.199026] initcall 0xc0a7500a: readahead_init+0x0/0xf() returned 0.
[    1.203461] initcall 0xc0a7500a ran for 0 msecs: readahead_init+0x0/0xf()
[    1.212249] Calling initcall 0xc0a75a25: init_bio+0x0/0xa6()
[    1.217901] initcall 0xc0a75a25: init_bio+0x0/0xa6() returned 0.
[    1.223028] initcall 0xc0a75a25 ran for 0 msecs: init_bio+0x0/0xa6()
[    1.230002] Calling initcall 0xc0a77fcf: blk_settings_init+0x0/0x1d()
[    1.236408] initcall 0xc0a77fcf: blk_settings_init+0x0/0x1d() returned 0.
[    1.241209] initcall 0xc0a77fcf ran for 0 msecs: blk_settings_init+0x0/0x1d()
[    1.250002] Calling initcall 0xc0a77fec: blk_ioc_init+0x0/0x24()
[    1.255975] initcall 0xc0a77fec: blk_ioc_init+0x0/0x24() returned 0.
[    1.261210] initcall 0xc0a77fec ran for 0 msecs: blk_ioc_init+0x0/0x24()
[    1.267882] Calling initcall 0xc0a78010: genhd_device_init+0x0/0x2a()
[    1.272811] initcall 0xc0a78010: genhd_device_init+0x0/0x2a() returned 0.
[    1.281208] initcall 0xc0a78010 ran for 0 msecs: genhd_device_init+0x0/0x2a()
[    1.288314] Calling initcall 0xc0a79a4f: acpi_init+0x0/0x217()
[    1.293342] ACPI: EC: Look up EC in DSDT
[    1.317129] ACPI: Interpreter enabled
[    1.320004] ACPI: (supports S0 S1 S3 S5)
[    1.323894] ACPI: Using PIC for interrupt routing
[    1.328629] initcall 0xc0a79a4f: acpi_init+0x0/0x217() returned 0.
[    1.333201] initcall 0xc0a79a4f ran for 28 msecs: acpi_init+0x0/0x217()
[    1.340002] Calling initcall 0xc0a79ca9: acpi_scan_init+0x0/0xed()
[    1.346278] PM: Adding info for acpi:LNXSYSTM:00
[    1.350103] PM: Adding info for acpi:LNXPWRBN:00
[    1.354685] PM: Adding info for acpi:ACPI0007:00
[    1.360100] PM: Adding info for acpi:ACPI0007:01
[    1.364710] PM: Adding info for acpi:device:00
[    1.370153] PM: Adding info for acpi:PNP0C0C:00
[    1.374766] PM: Adding info for acpi:PNP0A08:00
[    1.380122] PM: Adding info for acpi:PNP0C02:00
[    1.384715] PM: Adding info for acpi:device:01
[    1.389050] PM: Adding info for acpi:device:02
[    1.390095] PM: Adding info for acpi:device:03
[    1.394474] PM: Adding info for acpi:device:04
[    1.400065] PM: Adding info for acpi:device:05
[    1.404472] PM: Adding info for acpi:device:06
[    1.410064] PM: Adding info for acpi:device:07
[    1.414472] PM: Adding info for acpi:device:08
[    1.420003] PM: Adding info for acpi:device:09
[    1.424418] PM: Adding info for acpi:device:0a
[    1.428841] PM: Adding info for acpi:device:0b
[    1.430064] PM: Adding info for acpi:device:0c
[    1.434476] PM: Adding info for acpi:device:0d
[    1.440062] PM: Adding info for acpi:device:0e
[    1.444476] PM: Adding info for acpi:device:0f
[    1.450068] PM: Adding info for acpi:device:10
[    1.454473] PM: Adding info for acpi:device:11
[    1.458895] PM: Adding info for acpi:device:12
[    1.460080] PM: Adding info for acpi:device:13
[    1.464484] PM: Adding info for acpi:device:14
[    1.470072] PM: Adding info for acpi:device:15
[    1.474488] PM: Adding info for acpi:device:16
[    1.480064] PM: Adding info for acpi:device:17
[    1.484477] PM: Adding info for acpi:device:18
[    1.490187] PM: Adding info for acpi:device:19
[    1.494616] PM: Adding info for acpi:device:1a
[    1.498948] PM: Adding info for acpi:device:1b
[    1.500143] PM: Adding info for acpi:device:1c
[    1.504542] PM: Adding info for acpi:device:1d
[    1.510160] PM: Adding info for acpi:ATK0110:00
[    1.514762] PM: Adding info for acpi:PNP0C0F:00
[    1.520233] PM: Adding info for acpi:PNP0C0F:01
[    1.524818] PM: Adding info for acpi:PNP0C0F:02
[    1.530254] PM: Adding info for acpi:PNP0C0F:03
[    1.534841] PM: Adding info for acpi:PNP0C0F:04
[    1.540240] PM: Adding info for acpi:PNP0C0F:05
[    1.544829] PM: Adding info for acpi:PNP0C0F:06
[    1.549413] PM: Adding info for acpi:PNP0C0F:07
[    1.550249] PM: Adding info for acpi:PNP0C0F:08
[    1.554841] PM: Adding info for acpi:PNP0C0F:09
[    1.560246] PM: Adding info for acpi:PNP0C0F:0a
[    1.564831] PM: Adding info for acpi:PNP0C0F:0b
[    1.570267] PM: Adding info for acpi:PNP0C0F:0c
[    1.574862] PM: Adding info for acpi:PNP0C0F:0d
[    1.580243] PM: Adding info for acpi:PNP0C0F:0e
[    1.584831] PM: Adding info for acpi:PNP0C0F:0f
[    1.590284] PM: Adding info for acpi:PNP0C0F:10
[    1.594904] PM: Adding info for acpi:PNP0C0F:11
[    1.600263] PM: Adding info for acpi:PNP0C0F:12
[    1.604881] PM: Adding info for acpi:PNP0C0F:13
[    1.609500] PM: Adding info for acpi:PNP0C0F:14
[    1.610290] PM: Adding info for acpi:PNP0C0F:15
[    1.614904] PM: Adding info for acpi:PNP0C0F:16
[    1.620272] PM: Adding info for acpi:PNP0C0F:17
[    1.624900] PM: Adding info for acpi:PNP0C0F:18
[    1.630305] PM: Adding info for acpi:PNP0C0F:19
[    1.634920] PM: Adding info for acpi:PNP0C0F:1a
[    1.640270] PM: Adding info for acpi:PNP0C0F:1b
[    1.644885] PM: Adding info for acpi:PNP0C0F:1c
[    1.650287] PM: Adding info for acpi:PNP0C0F:1d
[    1.654902] PM: Adding info for acpi:PNP0C0F:1e
[    1.660268] PM: Adding info for acpi:PNP0C0F:1f
[    1.664745] PM: Adding info for acpi:PNP0C02:01
[    1.669250] PM: Adding info for acpi:PNP0000:00
[    1.670140] PM: Adding info for acpi:PNP0200:00
[    1.674618] PM: Adding info for acpi:PNP0100:00
[    1.680126] PM: Adding info for acpi:PNP0B00:00
[    1.684620] PM: Adding info for acpi:PNP0800:00
[    1.690146] PM: Adding info for acpi:PNP0C04:00
[    1.695099] PM: Adding info for acpi:PNP0700:00
[    1.700662] PM: Adding info for acpi:PNP0501:00
[    1.706277] PM: Adding info for acpi:PNP0401:00
[    1.710275] PM: Adding info for acpi:PNP0F13:00
[    1.714884] PM: Adding info for acpi:PNP0303:00
[    1.720692] PM: Adding info for acpi:PNPB006:00
[    1.725642] PM: Adding info for acpi:PNPB02F:00
[    1.730145] PM: Adding info for acpi:PNP0C02:02
[    1.734627] PM: Adding info for acpi:PNP0C01:00
[    1.740106] PM: Adding info for acpi:LNXTHERM:00
[    1.744706] PM: Adding info for acpi:PNP0C0B:00
[    1.749195] PM: Adding info for acpi:LNXTHERM:01
[    1.750123] initcall 0xc0a79ca9: acpi_scan_init+0x0/0xed() returned 0.
[    1.760007] initcall 0xc0a79ca9 ran for 391 msecs: acpi_scan_init+0x0/0xed()
[    1.767014] Calling initcall 0xc0a79d96: acpi_ec_init+0x0/0x55()
[    1.772456] initcall 0xc0a79d96: acpi_ec_init+0x0/0x55() returned 0.
[    1.778661] initcall 0xc0a79d96 ran for 0 msecs: acpi_ec_init+0x0/0x55()
[    1.782161] Calling initcall 0xc0a7a023: acpi_pci_root_init+0x0/0x25()
[    1.792884] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.797656] PM: Adding info for No Bus:pci0000:00
[    1.800025] PM: Adding info for No Bus:0000:00
[    1.805268] PCI: Transparent bridge - 0000:00:09.0
[    1.810542] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.816988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    1.832672] PM: Adding info for pci:0000:00:00.0
[    1.843023] PM: Adding info for pci:0000:00:01.0
[    1.853372] PM: Adding info for pci:0000:00:01.1
[    1.863720] PM: Adding info for pci:0000:00:02.0
[    1.874053] PM: Adding info for pci:0000:00:02.1
[    1.884472] PM: Adding info for pci:0000:00:04.0
[    1.894840] PM: Adding info for pci:0000:00:06.0
[    1.905362] PM: Adding info for pci:0000:00:09.0
[    1.915928] PM: Adding info for pci:0000:00:0a.0
[    1.925718] PM: Adding info for pci:0000:00:0b.0
[    1.935826] PM: Adding info for pci:0000:00:0c.0
[    1.945752] PM: Adding info for pci:0000:00:0d.0
[    1.955896] PM: Adding info for pci:0000:00:0e.0
[    1.965898] PM: Adding info for pci:0000:00:18.0
[    1.975907] PM: Adding info for pci:0000:00:18.1
[    1.986224] PM: Adding info for pci:0000:00:18.2
[    1.996094] PM: Adding info for pci:0000:00:18.3
[    2.000123] PM: Adding info for pci:0000:05:07.0
[    2.004709] PM: Adding info for No Bus:0000:05
[    2.010083] PM: Adding info for No Bus:0000:04
[    2.014495] PM: Adding info for No Bus:0000:03
[    2.020096] PM: Adding info for No Bus:0000:02
[    2.024486] PM: Adding info for pci:0000:01:00.0
[    2.030113] PM: Adding info for pci:0000:01:00.1
[    2.034705] PM: Adding info for No Bus:0000:01
[    2.039188] initcall 0xc0a7a023: acpi_pci_root_init+0x0/0x25() returned 0.
[    2.043895] initcall 0xc0a7a023 ran for 228 msecs: acpi_pci_root_init+0x0/0x25()
[    2.052681] Calling initcall 0xc0a7a121: acpi_pci_link_init+0x0/0x43()
[    2.060100] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.068322] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    2.072740] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    2.082387] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.090394] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.098609] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.103863] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.113868] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    2.122388] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    2.129468] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.133857] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.143862] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.153861] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.162229] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.170400] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.178635] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    2.183916] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    2.192009] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    2.198380] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    2.202010] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    2.211880] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    2.218100] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    2.222816] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    2.232806] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[    2.240279] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
[    2.247451] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
[    2.252813] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    2.261774] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    2.268949] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    2.272825] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[    2.282832] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[    2.290493] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    2.297493] initcall 0xc0a7a121: acpi_pci_link_init+0x0/0x43() returned 0.
[    2.303895] initcall 0xc0a7a121 ran for 228 msecs: acpi_pci_link_init+0x0/0x43()
[    2.310003] Calling initcall 0xc0a7a1e3: acpi_power_init+0x0/0x69()
[    2.316349] initcall 0xc0a7a1e3: acpi_power_init+0x0/0x69() returned 0.
[    2.323634] initcall 0xc0a7a1e3 ran for 0 msecs: acpi_power_init+0x0/0x69()
[    2.330008] Calling initcall 0xc0a7a32c: acpi_system_init+0x0/0x16a()
[    2.336471] initcall 0xc0a7a32c: acpi_system_init+0x0/0x16a() returned 0.
[    2.343808] initcall 0xc0a7a32c ran for 0 msecs: acpi_system_init+0x0/0x16a()
[    2.350002] Calling initcall 0xc0a7a6a4: acpi_cm_sbs_init+0x0/0x7()
[    2.356236] initcall 0xc0a7a6a4: acpi_cm_sbs_init+0x0/0x7() returned 0.
[    2.363636] initcall 0xc0a7a6a4 ran for 0 msecs: acpi_cm_sbs_init+0x0/0x7()
[    2.370002] Calling initcall 0xc0a7a6ab: pnp_init+0x0/0x19()
[    2.375629] Linux Plug and Play Support v0.97 (c) Adam Belay
[    2.380079] initcall 0xc0a7a6ab: pnp_init+0x0/0x19() returned 0.
[    2.385975] initcall 0xc0a7a6ab ran for 9 msecs: pnp_init+0x0/0x19()
[    2.391814] Calling initcall 0xc0a7a874: pnpacpi_init+0x0/0x7b()
[    2.400169] pnp: PnP ACPI init
[    2.403224] PM: Adding info for No Bus:pnp0
[    2.407363] ACPI: bus type pnp registered
[    2.410311] PM: Adding info for pnp:00:00
[    2.414315] PM: Adding info for pnp:00:01
[    2.422415] PM: Adding info for pnp:00:02
[    2.426388] PM: Adding info for pnp:00:03
[    2.430146] PM: Adding info for pnp:00:04
[    2.434117] PM: Adding info for pnp:00:05
[    2.438103] PM: Adding info for pnp:00:06
[    2.440689] PM: Adding info for pnp:00:07
[    2.445338] PM: Adding info for pnp:00:08
[    2.451733] PM: Adding info for pnp:00:09
[    2.455865] PM: Adding info for pnp:00:0a
[    2.460222] PM: Adding info for pnp:00:0b
[    2.464936] PM: Adding info for pnp:00:0c
[    2.470823] PM: Adding info for pnp:00:0d
[    2.474860] PM: Adding info for pnp:00:0e
[    2.479111] pnpacpi: exceeded the max number of mem resources: 12
[    2.480062] PM: Adding info for pnp:00:0f
[    2.484079] pnp: PnP ACPI: found 16 devices
[    2.490025] ACPI: ACPI bus type pnp unregistered
[    2.494587] initcall 0xc0a7a874: pnpacpi_init+0x0/0x7b() returned 0.
[    2.503375] initcall 0xc0a7a874 ran for 85 msecs: pnpacpi_init+0x0/0x7b()
[    2.510003] Calling initcall 0xc0a7b22f: misc_init+0x0/0x71()
[    2.515803] initcall 0xc0a7b22f: misc_init+0x0/0x71() returned 0.
[    2.521208] initcall 0xc0a7b22f ran for 0 msecs: misc_init+0x0/0x71()
[    2.527620] Calling initcall 0xc070dbbf: cn_init+0x0/0xaf()
[    2.531961] initcall 0xc070dbbf: cn_init+0x0/0xaf() returned 0.
[    2.540003] initcall 0xc070dbbf ran for 0 msecs: cn_init+0x0/0xaf()
[    2.546234] Calling initcall 0xc0a83354: init_scsi+0x0/0x79()
[    2.552420] SCSI subsystem initialized
[    2.555993] initcall 0xc0a83354: init_scsi+0x0/0x79() returned 0.
[    2.561208] initcall 0xc0a83354 ran for 0 msecs: init_scsi+0x0/0x79()
[    2.567620] Calling initcall 0xc0a88584: ata_init+0x0/0x7f()
[    2.572056] libata version 3.00 loaded.
[    2.575802] initcall 0xc0a88584: ata_init+0x0/0x7f() returned 0.
[    2.583027] initcall 0xc0a88584 ran for 0 msecs: ata_init+0x0/0x7f()
[    2.590002] Calling initcall 0xc0a88914: init_pcmcia_cs+0x0/0x31()
[    2.596214] initcall 0xc0a88914: init_pcmcia_cs+0x0/0x31() returned 0.
[    2.601208] initcall 0xc0a88914 ran for 0 msecs: init_pcmcia_cs+0x0/0x31()
[    2.610003] Calling initcall 0xc0a88a27: usb_init+0x0/0x10a()
[    2.615965] usbcore: registered new interface driver usbfs
[    2.620158] usbcore: registered new interface driver hub
[    2.625420] usbcore: registered new device driver usb
[    2.630008] initcall 0xc0a88a27: usb_init+0x0/0x10a() returned 0.
[    2.636061] initcall 0xc0a88a27 ran for 19 msecs: usb_init+0x0/0x10a()
[    2.641902] Calling initcall 0xc0a8adb1: serio_init+0x0/0x82()
[    2.650300] initcall 0xc0a8adb1: serio_init+0x0/0x82() returned 0.
[    2.656321] initcall 0xc0a8adb1 ran for 0 msecs: serio_init+0x0/0x82()
[    2.661988] Calling initcall 0xc0a8b2e7: gameport_init+0x0/0x82()
[    2.668185] initcall 0xc0a8b2e7: gameport_init+0x0/0x82() returned 0.
[    2.673461] initcall 0xc0a8b2e7 ran for 0 msecs: gameport_init+0x0/0x82()
[    2.680010] Calling initcall 0xc0a8b5ae: input_init+0x0/0xf3()
[    2.685874] initcall 0xc0a8b5ae: input_init+0x0/0xf3() returned 0.
[    2.693202] initcall 0xc0a8b5ae ran for 0 msecs: input_init+0x0/0xf3()
[    2.700007] Calling initcall 0xc0a8bc4d: rtc_init+0x0/0x55()
[    2.705695] initcall 0xc0a8bc4d: rtc_init+0x0/0x55() returned 0.
[    2.711208] initcall 0xc0a8bc4d ran for 0 msecs: rtc_init+0x0/0x55()
[    2.717534] Calling initcall 0xc0a8bfb9: power_supply_class_init+0x0/0x29()
[    2.723353] initcall 0xc0a8bfb9: power_supply_class_init+0x0/0x29() returned 0.
[    2.731208] initcall 0xc0a8bfb9 ran for 0 msecs: power_supply_class_init+0x0/0x29()
[    2.740008] Calling initcall 0xc0a8c000: hwmon_init+0x0/0x32()
[    2.745866] initcall 0xc0a8c000: hwmon_init+0x0/0x32() returned 0.
[    2.751208] initcall 0xc0a8c000 ran for 0 msecs: hwmon_init+0x0/0x32()
[    2.757707] Calling initcall 0xc0a8f095: dma_bus_init+0x0/0x23()
[    2.762399] initcall 0xc0a8f095: dma_bus_init+0x0/0x23() returned 0.
[    2.770003] initcall 0xc0a8f095 ran for 0 msecs: dma_bus_init+0x0/0x23()
[    2.776668] Calling initcall 0xc0a8f17c: ac97_bus_init+0x0/0xf()
[    2.782414] initcall 0xc0a8f17c: ac97_bus_init+0x0/0xf() returned 0.
[    2.790003] initcall 0xc0a8f17c ran for 0 msecs: ac97_bus_init+0x0/0xf()
[    2.796667] Calling initcall 0xc0a8fec0: pci_acpi_init+0x0/0x86()
[    2.802422] PCI: Using ACPI for IRQ routing
[    2.806585] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    2.810003] initcall 0xc0a8fec0: pci_acpi_init+0x0/0x86() returned 0.
[    2.821208] initcall 0xc0a8fec0 ran for 9 msecs: pci_acpi_init+0x0/0x86()
[    2.827968] Calling initcall 0xc0a8ff46: pci_legacy_init+0x0/0xd3()
[    2.832596] initcall 0xc0a8ff46: pci_legacy_init+0x0/0xd3() returned 0.
[    2.841208] initcall 0xc0a8ff46 ran for 0 msecs: pci_legacy_init+0x0/0xd3()
[    2.848140] Calling initcall 0xc0a90402: pcibios_irq_init+0x0/0x340()
[    2.852769] initcall 0xc0a90402: pcibios_irq_init+0x0/0x340() returned 0.
[    2.861208] initcall 0xc0a90402 ran for 0 msecs: pcibios_irq_init+0x0/0x340()
[    2.868314] Calling initcall 0xc0a90742: pcibios_init+0x0/0x7a()
[    2.872412] initcall 0xc0a90742: pcibios_init+0x0/0x7a() returned 0.
[    2.880003] initcall 0xc0a90742 ran for 0 msecs: pcibios_init+0x0/0x7a()
[    2.886668] Calling initcall 0xc0a9085e: proto_init+0x0/0x27()
[    2.892164] initcall 0xc0a9085e: proto_init+0x0/0x27() returned 0.
[    2.898315] initcall 0xc0a9085e ran for 0 msecs: proto_init+0x0/0x27()
[    2.901988] Calling initcall 0xc0a90bdc: net_dev_init+0x0/0x120()
[    2.910251] initcall 0xc0a90bdc: net_dev_init+0x0/0x120() returned 0.
[    2.916582] initcall 0xc0a90bdc ran for 0 msecs: net_dev_init+0x0/0x120()
[    2.922247] Calling initcall 0xc0a90d39: neigh_init+0x0/0x66()
[    2.930169] initcall 0xc0a90d39: neigh_init+0x0/0x66() returned 0.
[    2.936321] initcall 0xc0a90d39 ran for 0 msecs: neigh_init+0x0/0x66()
[    2.941988] Calling initcall 0xc0a911eb: fib_rules_init+0x0/0x99()
[    2.948143] initcall 0xc0a911eb: fib_rules_init+0x0/0x99() returned 0.
[    2.953548] initcall 0xc0a911eb ran for 0 msecs: fib_rules_init+0x0/0x99()
[    2.962335] Calling initcall 0xc0a91792: genl_init+0x0/0xad()
[    2.968105] initcall 0xc0a91792: genl_init+0x0/0xad() returned 0.
[    2.973115] initcall 0xc0a91792 ran for 0 msecs: genl_init+0x0/0xad()
[    2.980002] Calling initcall 0xc0a941d6: cipso_v4_init+0x0/0x70()
[    2.986073] initcall 0xc0a941d6: cipso_v4_init+0x0/0x70() returned 0.
[    2.993462] initcall 0xc0a941d6 ran for 0 msecs: cipso_v4_init+0x0/0x70()
[    3.000002] Calling initcall 0xc0a9587a: bt_init+0x0/0x50()
[    3.005542] Bluetooth: Core ver 2.11
[    3.009167] PM: Adding info for platform:bluetooth
[    3.010238] NET: Registered protocol family 31
[    3.014501] Bluetooth: HCI device and connection manager initialized
[    3.020018] Bluetooth: HCI socket layer initialized
[    3.030007] initcall 0xc0a9587a: bt_init+0x0/0x50() returned 0.
[    3.035888] initcall 0xc0a9587a ran for 28 msecs: bt_init+0x0/0x50()
[    3.041729] Calling initcall 0xc0a95c72: atm_init+0x0/0x9c()
[    3.047363] NET: Registered protocol family 8
[    3.050003] NET: Registered protocol family 20
[    3.054493] initcall 0xc0a95c72: atm_init+0x0/0x9c() returned 0.
[    3.061208] initcall 0xc0a95c72 ran for 9 msecs: atm_init+0x0/0x9c()
[    3.067535] Calling initcall 0xc0a96a3d: wireless_nlevent_init+0x0/0x39()
[    3.073116] initcall 0xc0a96a3d: wireless_nlevent_init+0x0/0x39() returned 0.
[    3.081208] initcall 0xc0a96a3d ran for 0 msecs: wireless_nlevent_init+0x0/0x39()
[    3.090002] Calling initcall 0xc0a96aaf: netlbl_init+0x0/0x6d()
[    3.095887] NetLabel: Initializing
[    3.099267] NetLabel:  domain hash size = 128
[    3.100002] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.104984] NetLabel:  unlabeled traffic allowed by default
[    3.110003] initcall 0xc0a96aaf: netlbl_init+0x0/0x6d() returned 0.
[    3.120003] initcall 0xc0a96aaf ran for 19 msecs: netlbl_init+0x0/0x6d()
[    3.126668] Calling initcall 0xc0a96b1c: rfkill_init+0x0/0x4e()
[    3.132322] initcall 0xc0a96b1c: rfkill_init+0x0/0x4e() returned 0.
[    3.138489] initcall 0xc0a96b1c ran for 0 msecs: rfkill_init+0x0/0x4e()
[    3.142074] Calling initcall 0xc0a96b79: sysctl_init+0x0/0x23()
[    3.150170] initcall 0xc0a96b79: sysctl_init+0x0/0x23() returned 0.
[    3.156408] initcall 0xc0a96b79 ran for 0 msecs: sysctl_init+0x0/0x23()
[    3.162075] Calling initcall 0xc0a70303: hpet_late_init+0x0/0x43()
[    3.170168] initcall 0xc0a70303: hpet_late_init+0x0/0x43() returned -19.
[    3.176842] initcall 0xc0a70303 ran for 0 msecs: hpet_late_init+0x0/0x43()
[    3.182335] Calling initcall 0xc0a73b6c: clocksource_done_booting+0x0/0x11()
[    3.190168] initcall 0xc0a73b6c: clocksource_done_booting+0x0/0x11() returned 0.
[    3.197534] initcall 0xc0a73b6c ran for 0 msecs: <6>Time: tsc clocksource has been installed.
[    3.200004] clocksource_done_booting+0x0/0x11()
[    3.210002] Calling initcall 0xc0a75459: init_pipe_fs+0x0/0x41()
[    3.215999] initcall 0xc0a75459: init_pipe_fs+0x0/0x41() returned 0.
[    3.223375] initcall 0xc0a75459 ran for 0 msecs: init_pipe_fs+0x0/0x41()
[    3.230002] Calling initcall 0xc0a75b42: anon_inode_init+0x0/0xdd()
[    3.236253] initcall 0xc0a75b42: anon_inode_init+0x0/0xdd() returned 0.
[    3.243634] initcall 0xc0a75b42 ran for 0 msecs: anon_inode_init+0x0/0xdd()
[    3.250002] Calling initcall 0xc0a78a5e: pcie_aspm_init+0x0/0x1f()
[    3.256279] initcall 0xc0a78a5e: pcie_aspm_init+0x0/0x1f() returned 0.
[    3.261209] initcall 0xc0a78a5e ran for 0 msecs: pcie_aspm_init+0x0/0x1f()
[    3.270003] Calling initcall 0xc0a7a496: acpi_event_init+0x0/0x46()
[    3.276274] initcall 0xc0a7a496: acpi_event_init+0x0/0x46() returned 0.
[    3.281208] initcall 0xc0a7a496 ran for 0 msecs: acpi_event_init+0x0/0x46()
[    3.288141] Calling initcall 0xc0a7a79c: pnp_system_init+0x0/0xf()
[    3.292528] system 00:01: ioport range 0x4000-0x407f has been reserved
[    3.300004] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    3.306497] system 00:01: ioport range 0x4400-0x447f has been reserved
[    3.310004] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    3.320004] system 00:01: ioport range 0x4800-0x487f has been reserved
[    3.326496] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    3.330014] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    3.340004] system 00:02: ioport range 0x800-0x805 has been reserved
[    3.346324] system 00:02: ioport range 0x290-0x297 has been reserved
[    3.350024] system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
[    3.360015] system 00:0f: iomem range 0xf0000-0xf3fff could not be reserved
[    3.366932] system 00:0f: iomem range 0xf4000-0xf7fff could not be reserved
[    3.370005] system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
[    3.380005] system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
[    3.386931] system 00:0f: iomem range 0x3fff0000-0x3fffffff could not be reserved
[    3.390016] system 00:0f: iomem range 0xffff0000-0xffffffff could not be reserved
[    3.400005] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    3.410005] system 00:0f: iomem range 0x100000-0x3ffeffff could not be reserved
[    3.417277] system 00:0f: iomem range 0xfec00000-0xfec00fff could not be reserved
[    3.420005] system 00:0f: iomem range 0xfee00000-0xfeefffff could not be reserved
[    3.430005] system 00:0f: iomem range 0xfefff000-0xfeffffff could not be reserved
[    3.440005] system 00:0f: iomem range 0xfff80000-0xfff80fff could not be reserved
[    3.447524] initcall 0xc0a7a79c: pnp_system_init+0x0/0xf() returned 0.
[    3.453547] initcall 0xc0a7a79c ran for 144 msecs: pnp_system_init+0x0/0xf()
[    3.460003] Calling initcall 0xc0a7ac02: chr_dev_init+0x0/0x86()
[    3.466067] PM: Adding info for No Bus:mem
[    3.470084] PM: Adding info for No Bus:kmem
[    3.474239] PM: Adding info for No Bus:null
[    3.478397] PM: Adding info for No Bus:port
[    3.480088] PM: Adding info for No Bus:zero
[    3.484236] PM: Adding info for No Bus:full
[    3.490088] PM: Adding info for No Bus:random
[    3.494416] PM: Adding info for No Bus:urandom
[    3.500105] PM: Adding info for No Bus:kmsg
[    3.504218] initcall 0xc0a7ac02: chr_dev_init+0x0/0x86() returned 0.
[    3.511208] initcall 0xc0a7ac02 ran for 36 msecs: chr_dev_init+0x0/0x86()
[    3.517968] Calling initcall 0xc0a7f707: firmware_class_init+0x0/0x5c()
[    3.523013] initcall 0xc0a7f707: firmware_class_init+0x0/0x5c() returned 0.
[    3.531208] initcall 0xc0a7f707 ran for 0 msecs: firmware_class_init+0x0/0x5c()
[    3.538488] Calling initcall 0xc0a8214e: loopback_init+0x0/0xf()
[    3.542436] PM: Adding info for No Bus:lo
[    3.546416] initcall 0xc0a8214e: loopback_init+0x0/0xf() returned 0.
[    3.553375] initcall 0xc0a8214e ran for 3 msecs: loopback_init+0x0/0xf()
[    3.560009] Calling initcall 0xc0a88945: init_pcmcia_bus+0x0/0x6c()
[    3.566327] initcall 0xc0a88945: init_pcmcia_bus+0x0/0x6c() returned 0.
[    3.573634] initcall 0xc0a88945 ran for 0 msecs: init_pcmcia_bus+0x0/0x6c()
[    3.580008] Calling initcall 0xc0a8f127: ssb_modinit+0x0/0x46()
[    3.586084] initcall 0xc0a8f127: ssb_modinit+0x0/0x46() returned 0.
[    3.593287] initcall 0xc0a8f127 ran for 0 msecs: ssb_modinit+0x0/0x46()
[    3.600012] Calling initcall 0xc0a8f18b: pcibios_assign_resources+0x0/0x91()
[    3.607039] PCI: Bridge: 0000:00:09.0
[    3.610005]   IO window: c000-cfff
[    3.613378]   MEM window: 0xda000000-0xda0fffff
[    3.617883]   PREFETCH window: disabled.
[    3.620017] PCI: Bridge: 0000:00:0b.0
[    3.623635]   IO window: disabled.
[    3.627017]   MEM window: disabled.
[    3.630004]   PREFETCH window: disabled.
[    3.633898] PCI: Bridge: 0000:00:0c.0
[    3.640002]   IO window: disabled.
[    3.643378]   MEM window: disabled.
[    3.646842]   PREFETCH window: disabled.
[    3.650005] PCI: Bridge: 0000:00:0d.0
[    3.653635]   IO window: disabled.
[    3.657017]   MEM window: disabled.
[    3.660004]   PREFETCH window: disabled.
[    3.663899] PCI: Bridge: 0000:00:0e.0
[    3.667537]   IO window: b000-bfff
[    3.670005]   MEM window: 0xd8000000-0xd9ffffff
[    3.674503]   PREFETCH window: 0x00000000d0000000-0x00000000d7ffffff
[    3.680011] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    3.690015] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    3.696245] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    3.700013] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    3.706244] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    3.710004] initcall 0xc0a8f18b: pcibios_assign_resources+0x0/0x91() returned 0.
[    3.721209] initcall 0xc0a8f18b ran for 102 msecs: pcibios_assign_resources+0x0/0x91()
[    3.730002] Calling initcall 0xc0a9225e: inet_init+0x0/0x333()
[    3.735808] NET: Registered protocol family 2
[    3.740153] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    3.747566] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    3.751096] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    3.762723] TCP: Hash tables configured (established 131072 bind 65536)
[    3.770026] TCP reno registered
[    3.773212] initcall 0xc0a9225e: inet_init+0x0/0x333() returned 0.
[    3.781209] initcall 0xc0a9225e ran for 37 msecs: inet_init+0x0/0x333()
[    3.787794] Calling initcall 0xc0a6bf63: populate_rootfs+0x0/0x8c()
[    3.792886] initcall 0xc0a6bf63: populate_rootfs+0x0/0x8c() returned 0.
[    3.800004] initcall 0xc0a6bf63 ran for 0 msecs: populate_rootfs+0x0/0x8c()
[    3.806928] Calling initcall 0xc0a6d0fc: i8259A_init_sysfs+0x0/0x1d()
[    3.812959] initcall 0xc0a6d0fc: i8259A_init_sysfs+0x0/0x1d() returned 0.
[    3.820007] initcall 0xc0a6d0fc ran for 0 msecs: i8259A_init_sysfs+0x0/0x1d()
[    3.827101] Calling initcall 0xc0a6d20b: sbf_init+0x0/0xbd()
[    3.831988] initcall 0xc0a6d20b: sbf_init+0x0/0xbd() returned 0.
[    3.837968] initcall 0xc0a6d20b ran for 0 msecs: sbf_init+0x0/0xbd()
[    3.841816] Calling initcall 0xc0a6df86: i8237A_init_sysfs+0x0/0x1d()
[    3.850317] initcall 0xc0a6df86: i8237A_init_sysfs+0x0/0x1d() returned 0.
[    3.856928] initcall 0xc0a6df86 ran for 0 msecs: i8237A_init_sysfs+0x0/0x1d()
[    3.862595] Calling initcall 0xc0a96f5c: cache_sysfs_init+0x0/0x1f6()
[    3.870503] initcall 0xc0a96f5c: cache_sysfs_init+0x0/0x1f6() returned 0.
[    3.877111] initcall 0xc0a96f5c ran for 0 msecs: cache_sysfs_init+0x0/0x1f6()
[    3.882595] Calling initcall 0xc0a6e936: thermal_throttle_init_device+0x0/0x3b()
[    3.893723] initcall 0xc0a6e936: thermal_throttle_init_device+0x0/0x3b() returned 0.
[    3.901208] initcall 0xc0a6e936 ran for 0 msecs: thermal_throttle_init_device+0x0/0x3b()
[    3.909267] Calling initcall 0xc0a6e971: init_nonfatal_mce_checker+0x0/0x50()
[    3.913462] Machine check exception polling timer started.
[    3.920003] initcall 0xc0a6e971: init_nonfatal_mce_checker+0x0/0x50() returned 0.
[    3.927447] initcall 0xc0a6e971 ran for 5 msecs: init_nonfatal_mce_checker+0x0/0x50()
[    3.933289] Calling initcall 0xc0a6fc08: microcode_init+0x0/0x8e()
[    3.942545] PM: Adding info for No Bus:microcode
[    3.947188] PM: Adding info for platform:microcode
[    3.950100] microcode: CPU0 not a capable Intel processor
[    3.955368] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[    3.960004] initcall 0xc0a6fc08: microcode_init+0x0/0x8e() returned 0.
[    3.971208] initcall 0xc0a6fc08 ran for 21 msecs: microcode_init+0x0/0x8e()
[    3.978141] Calling initcall 0xc0a71425: init_vmi_clocksource+0x0/0xcf()
[    3.983028] initcall 0xc0a71425: init_vmi_clocksource+0x0/0xcf() returned 0.
[    3.991209] initcall 0xc0a71425 ran for 0 msecs: init_vmi_clocksource+0x0/0xcf()
[    4.000003] Calling initcall 0xc0a7228a: exercise_pageattr+0x0/0x379()
[    4.006495] CPA exercising pageattr
[    4.014757] CPA mapping 4k 219136 large 10 gb 0 x 219146[c0000000-f7fff000] miss 0
[    4.054563] CPA mapping 4k 229376 large 0 gb 0 x 229376[c0000000-f7fff000] miss 0
[    4.060004] CPA reverting everything
[    4.091554] CPA mapping 4k 229376 large 0 gb 0 x 229376[c0000000-f7fff000] miss 0
[    4.098852] CPA selftests PASSED
[    4.100004] initcall 0xc0a7228a: exercise_pageattr+0x0/0x379() returned 0.
[    4.106841] initcall 0xc0a7228a ran for 90 msecs: exercise_pageattr+0x0/0x379()
[    4.112682] Calling initcall 0xc0a72a7d: init_sched_debug_procfs+0x0/0x2a()
[    4.120176] initcall 0xc0a72a7d: init_sched_debug_procfs+0x0/0x2a() returned 0.
[    4.130003] initcall 0xc0a72a7d ran for 0 msecs: init_sched_debug_procfs+0x0/0x2a()
[    4.137620] Calling initcall 0xc0a73139: create_proc_profile+0x0/0x41()
[    4.142944] initcall 0xc0a73139: create_proc_profile+0x0/0x41() returned 0.
[    4.151208] initcall 0xc0a73139 ran for 0 msecs: create_proc_profile+0x0/0x41()
[    4.158488] Calling initcall 0xc0a73220: ioresources_init+0x0/0x39()
[    4.162686] initcall 0xc0a73220: ioresources_init+0x0/0x39() returned 0.
[    4.171209] initcall 0xc0a73220 ran for 0 msecs: ioresources_init+0x0/0x39()
[    4.178229] Calling initcall 0xc0a7337f: uid_cache_init+0x0/0x5e()
[    4.182510] initcall 0xc0a7337f: uid_cache_init+0x0/0x5e() returned 0.
[    4.191209] initcall 0xc0a7337f ran for 0 msecs: uid_cache_init+0x0/0x5e()
[    4.198055] Calling initcall 0xc0a73848: init_posix_timers+0x0/0x7c()
[    4.202769] initcall 0xc0a73848: init_posix_timers+0x0/0x7c() returned 0.
[    4.211208] initcall 0xc0a73848 ran for 0 msecs: init_posix_timers+0x0/0x7c()
[    4.218314] Calling initcall 0xc0a738c4: init_posix_cpu_timers+0x0/0x90()
[    4.223115] initcall 0xc0a738c4: init_posix_cpu_timers+0x0/0x90() returned 0.
[    4.231208] initcall 0xc0a738c4 ran for 0 msecs: init_posix_cpu_timers+0x0/0x90()
[    4.238661] Calling initcall 0xc0a739c8: latency_init+0x0/0x20()
[    4.242355] initcall 0xc0a739c8: latency_init+0x0/0x20() returned 0.
[    4.251208] initcall 0xc0a739c8 ran for 0 msecs: latency_init+0x0/0x20()
[    4.257881] Calling initcall 0xc0a739e8: nsproxy_cache_init+0x0/0x27()
[    4.262856] initcall 0xc0a739e8: nsproxy_cache_init+0x0/0x27() returned 0.
[    4.271209] initcall 0xc0a739e8 ran for 0 msecs: nsproxy_cache_init+0x0/0x27()
[    4.278401] Calling initcall 0xc0a73a0f: timekeeping_init_device+0x0/0x1d()
[    4.283491] initcall 0xc0a73a0f: timekeeping_init_device+0x0/0x1d() returned 0.
[    4.291208] initcall 0xc0a73a0f ran for 0 msecs: timekeeping_init_device+0x0/0x1d()
[    4.300010] Calling initcall 0xc0a73b7d: init_clocksource_sysfs+0x0/0x43()
[    4.306997] initcall 0xc0a73b7d: init_clocksource_sysfs+0x0/0x43() returned 0.
[    4.314241] initcall 0xc0a73b7d ran for 0 msecs: init_clocksource_sysfs+0x0/0x43()
[    4.320019] Calling initcall 0xc0a73c48: init_timer_list_procfs+0x0/0x2a()
[    4.326844] initcall 0xc0a73c48: init_timer_list_procfs+0x0/0x2a() returned 0.
[    4.334241] initcall 0xc0a73c48 ran for 0 msecs: init_timer_list_procfs+0x0/0x2a()
[    4.343028] Calling initcall 0xc0a73d19: lockdep_proc_init+0x0/0x5b()
[    4.350175] initcall 0xc0a73d19: lockdep_proc_init+0x0/0x5b() returned 0.
[    4.356928] initcall 0xc0a73d19 ran for 0 msecs: lockdep_proc_init+0x0/0x5b()
[    4.362596] Calling initcall 0xc0a73d74: init+0x0/0x98()
[    4.370042] initcall 0xc0a73d74: init+0x0/0x98() returned 0.
[    4.375628] initcall 0xc0a73d74 ran for 0 msecs: init+0x0/0x98()
[    4.381468] Calling initcall 0xc01360c3: init_rttest+0x0/0x105()
[    4.388412] Initializing RT-Tester: OK
[    4.390015] initcall 0xc01360c3: init_rttest+0x0/0x105() returned 0.
[    4.396322] initcall 0xc01360c3 ran for 4 msecs: init_rttest+0x0/0x105()
[    4.402161] Calling initcall 0xc0a73e0c: proc_dma_init+0x0/0x20()
[    4.410171] initcall 0xc0a73e0c: proc_dma_init+0x0/0x20() returned 0.
[    4.416581] initcall 0xc0a73e0c ran for 0 msecs: proc_dma_init+0x0/0x20()
[    4.422249] Calling initcall 0xc0a73e2c: kallsyms_init+0x0/0x23()
[    4.430171] initcall 0xc0a73e2c: kallsyms_init+0x0/0x23() returned 0.
[    4.436581] initcall 0xc0a73e2c ran for 0 msecs: kallsyms_init+0x0/0x23()
[    4.442248] Calling initcall 0xc01381f9: backtrace_regression_test+0x0/0x67()
[    4.450168] ====[ backtrace testing ]===========
[    4.454761] Testing a backtrace from process context.
[    4.460002] The following trace is a kernel self test and not a bug!
[    4.466323] Pid: 1, comm: swapper Not tainted 2.6.24 #6
[    4.470003]  [<c013821f>] backtrace_regression_test+0x26/0x67
[    4.475715]  [<c0a69673>] kernel_init+0xb2/0x20b
[    4.482075]  [<c0a695c1>] ? kernel_init+0x0/0x20b
[    4.486754]  [<c01057a7>] kernel_thread_helper+0x7/0x10
[    4.490003]  =======================
[    4.520002] ====[ end of backtrace testing ]====
[    4.520002] initcall 0xc01381f9: backtrace_regression_test+0x0/0x67() returned 0.
[    4.521210] initcall 0xc01381f9 ran for 60 msecs: backtrace_regression_test+0x0/0x67()
[    4.529097] Calling initcall 0xc0a73f7d: relay_init+0x0/0x7()
[    4.532077] initcall 0xc0a73f7d: relay_init+0x0/0x7() returned 0.
[    4.541211] initcall 0xc0a73f7d ran for 0 msecs: relay_init+0x0/0x7()
[    4.547624] Calling initcall 0xc0a73f84: utsname_sysctl_init+0x0/0x11()
[    4.552972] initcall 0xc0a73f84: utsname_sysctl_init+0x0/0x11() returned 0.
[    4.561210] initcall 0xc0a73f84 ran for 0 msecs: utsname_sysctl_init+0x0/0x11()
[    4.568490] Calling initcall 0xc0a7496b: init_per_zone_pages_min+0x0/0x48()
[    4.573345] initcall 0xc0a7496b: init_per_zone_pages_min+0x0/0x48() returned 0.
[    4.581210] initcall 0xc0a7496b ran for 0 msecs: init_per_zone_pages_min+0x0/0x48()
[    4.590004] Testing a backtrace from irq context.
[    4.594677] The following trace is a kernel self test and not a bug!
[    4.600004] Pid: 1, comm: swapper Not tainted 2.6.24 #6
[    4.605197]  [<c01381f5>] backtrace_test_timer+0x1c/0x20
[    4.610004]  [<c0120c8f>] run_timer_softirq+0x108/0x156
[    4.615198]  [<c01381d9>] ? backtrace_test_timer+0x0/0x20
[    4.622684]  [<c011dbba>] __do_softirq+0x4c/0x9c
[    4.627277]  [<c0106e8a>] do_softirq+0x66/0xaa
[    4.630004]  [<c0139675>] ? handle_level_irq+0x0/0xc3
[    4.635023]  [<c011db1f>] irq_exit+0x30/0x3c
[    4.640004]  [<c0106f69>] do_IRQ+0x9b/0xb0
[    4.644070]  [<c0105643>] common_interrupt+0x23/0x30
[    4.649010]  [<c011a45a>] ? vprintk+0x2d8/0x328
[    4.651991]  [<c011a4bf>] printk+0x15/0x17
[    4.656064]  [<c0136b52>] __print_symbol+0x21/0x2a
[    4.662251]  [<c0732e37>] ? _spin_unlock_irqrestore+0x36/0x4c
[    4.667970]  [<c0119fa9>] ? release_console_sem+0x19c/0x1a4
[    4.673030]  [<c011a46c>] ? vprintk+0x2ea/0x328
[    4.677537]  [<c012da20>] ? getnstimeofday+0x2f/0xb4
[    4.682425]  [<c011a4bf>] ? printk+0x15/0x17
[    4.686670]  [<c0a696ce>] ? kernel_init+0x10d/0x20b
[    4.692337]  [<c0a7496b>] ? init_per_zone_pages_min+0x0/0x48
[    4.697970]  [<c0a696e0>] kernel_init+0x11f/0x20b
[    4.702164]  [<c0a695c1>] ? kernel_init+0x0/0x20b
[    4.706844]  [<c01057a7>] kernel_thread_helper+0x7/0x10
[    4.712684]  =======================
[    4.716239] Calling initcall 0xc0a74ff4: pdflush_init+0x0/0x16()
[    4.722417] initcall 0xc0a74ff4: pdflush_init+0x0/0x16() returned 0.
[    4.728664] initcall 0xc0a74ff4 ran for 0 msecs: pdflush_init+0x0/0x16()
[    4.732164] Calling initcall 0xc0a75040: kswapd_init+0x0/0x13()
[    4.740203] initcall 0xc0a75040: kswapd_init+0x0/0x13() returned 0.
[    4.746410] initcall 0xc0a75040 ran for 0 msecs: kswapd_init+0x0/0x13()
[    4.752077] Calling initcall 0xc0a75134: init_emergency_pool+0x0/0x57()
[    4.760244] highmem bounce pool size: 64 pages
[    4.764591] initcall 0xc0a75134: init_emergency_pool+0x0/0x57() returned 0.
[    4.771210] initcall 0xc0a75134 ran for 4 msecs: init_emergency_pool+0x0/0x57()
[    4.778489] Calling initcall 0xc0a7518b: procswaps_init+0x0/0x20()
[    4.782513] initcall 0xc0a7518b: procswaps_init+0x0/0x20() returned 0.
[    4.791210] initcall 0xc0a7518b ran for 0 msecs: procswaps_init+0x0/0x20()
[    4.798057] Calling initcall 0xc0a7531d: init_tmpfs+0x0/0xb9()
[    4.802185] initcall 0xc0a7531d: init_tmpfs+0x0/0xb9() returned 0.
[    4.811211] initcall 0xc0a7531d ran for 0 msecs: init_tmpfs+0x0/0xb9()
[    4.817711] Calling initcall 0xc0a7549a: fasync_init+0x0/0x24()
[    4.822251] initcall 0xc0a7549a: fasync_init+0x0/0x24() returned 0.
[    4.828491] initcall 0xc0a7549a ran for 0 msecs: fasync_init+0x0/0x24()
[    4.832077] Calling initcall 0xc0a7597f: aio_setup+0x0/0x64()
[    4.842119] initcall 0xc0a7597f: aio_setup+0x0/0x64() returned 0.
[    4.848143] initcall 0xc0a7597f ran for 0 msecs: aio_setup+0x0/0x64()
[    4.851904] Calling initcall 0xc0a75b31: inotify_setup+0x0/0x11()
[    4.860172] initcall 0xc0a75b31: inotify_setup+0x0/0x11() returned 0.
[    4.866584] initcall 0xc0a75b31 ran for 0 msecs: inotify_setup+0x0/0x11()
[    4.872250] Calling initcall 0xc0a75c4c: init_mbcache+0x0/0x11()
[    4.878231] initcall 0xc0a75c4c: init_mbcache+0x0/0x11() returned 0.
[    4.883377] initcall 0xc0a75c4c ran for 0 msecs: init_mbcache+0x0/0x11()
[    4.892164] Calling initcall 0xc0a75c5d: dquot_init+0x0/0xdd()
[    4.897970] VFS: Disk quotas dquot_6.5.1
[    4.900055] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.906509] initcall 0xc0a75c5d: dquot_init+0x0/0xdd() returned 0.
[    4.913203] initcall 0xc0a75c5d ran for 9 msecs: dquot_init+0x0/0xdd()
[    4.920005] Calling initcall 0xc0a75d3a: init_v1_quota_format+0x0/0xf()
[    4.926584] initcall 0xc0a75d3a: init_v1_quota_format+0x0/0xf() returned 0.
[    4.933984] initcall 0xc0a75d3a ran for 0 msecs: init_v1_quota_format+0x0/0xf()
[    4.940005] Calling initcall 0xc0a75d49: dnotify_init+0x0/0x24()
[    4.945979] initcall 0xc0a75d49: dnotify_init+0x0/0x24() returned 0.
[    4.953377] initcall 0xc0a75d49 ran for 0 msecs: dnotify_init+0x0/0x24()
[    4.960004] Calling initcall 0xc0a7614f: configfs_init+0x0/0xbb()
[    4.966071] initcall 0xc0a7614f: configfs_init+0x0/0xbb() returned 0.
[    4.973463] initcall 0xc0a7614f ran for 0 msecs: configfs_init+0x0/0xbb()
[    4.980004] Calling initcall 0xc0a7620a: init_devpts_fs+0x0/0x33()
[    4.986183] initcall 0xc0a7620a: init_devpts_fs+0x0/0x33() returned 0.
[    4.991210] initcall 0xc0a7620a ran for 0 msecs: init_devpts_fs+0x0/0x33()
[    5.000005] Calling initcall 0xc0a7623d: init_dlm+0x0/0x6f()
[    5.005704] PM: Adding info for No Bus:dlm-control
[    5.010088] DLM (built Feb  2 2008 11:31:51) installed
[    5.015110] initcall 0xc0a7623d: init_dlm+0x0/0x6f() returned 0.
[    5.021210] initcall 0xc0a7623d ran for 9 msecs: init_dlm+0x0/0x6f()
[    5.027537] Calling initcall 0xc0a762ac: init_reiserfs_fs+0x0/0x84()
[    5.032701] initcall 0xc0a762ac: init_reiserfs_fs+0x0/0x84() returned 0.
[    5.040005] initcall 0xc0a762ac ran for 0 msecs: init_reiserfs_fs+0x0/0x84()
[    5.047016] Calling initcall 0xc0a7641f: init_ext3_fs+0x0/0x5f()
[    5.052352] initcall 0xc0a7641f: init_ext3_fs+0x0/0x5f() returned 0.
[    5.060005] initcall 0xc0a7641f ran for 0 msecs: init_ext3_fs+0x0/0x5f()
[    5.066670] Calling initcall 0xc0a76514: journal_init+0x0/0x85()
[    5.072339] initcall 0xc0a76514: journal_init+0x0/0x85() returned 0.
[    5.078663] initcall 0xc0a76514 ran for 0 msecs: journal_init+0x0/0x85()
[    5.082164] Calling initcall 0xc0a76599: init_cramfs_fs+0x0/0x29()
[    5.090180] initcall 0xc0a76599: init_cramfs_fs+0x0/0x29() returned 0.
[    5.096671] initcall 0xc0a76599 ran for 0 msecs: init_cramfs_fs+0x0/0x29()
[    5.102337] Calling initcall 0xc0a765c2: init_ramfs_fs+0x0/0xf()
[    5.110171] initcall 0xc0a765c2: init_ramfs_fs+0x0/0xf() returned 0.
[    5.116497] initcall 0xc0a765c2 ran for 0 msecs: init_ramfs_fs+0x0/0xf()
[    5.122164] Calling initcall 0xc0a76604: init_minix_fs+0x0/0x4f()
[    5.130172] initcall 0xc0a76604: init_minix_fs+0x0/0x4f() returned 0.
[    5.136584] initcall 0xc0a76604 ran for 0 msecs: init_minix_fs+0x0/0x4f()
[    5.142250] Calling initcall 0xc0a76682: init_fat_fs+0x0/0x46()
[    5.148144] initcall 0xc0a76682: init_fat_fs+0x0/0x46() returned 0.
[    5.153290] initcall 0xc0a76682 ran for 0 msecs: init_fat_fs+0x0/0x46()
[    5.162077] Calling initcall 0xc0a766c8: init_msdos_fs+0x0/0xf()
[    5.168058] initcall 0xc0a766c8: init_msdos_fs+0x0/0xf() returned 0.
[    5.173377] initcall 0xc0a766c8 ran for 0 msecs: init_msdos_fs+0x0/0xf()
[    5.180013] Calling initcall 0xc0a766d7: init_bfs_fs+0x0/0x4f()
[    5.185892] initcall 0xc0a766d7: init_bfs_fs+0x0/0x4f() returned 0.
[    5.193291] initcall 0xc0a766d7 ran for 0 msecs: init_bfs_fs+0x0/0x4f()
[    5.200010] Calling initcall 0xc0a76726: init_hfsplus_fs+0x0/0x50()
[    5.206239] initcall 0xc0a76726: init_hfsplus_fs+0x0/0x50() returned 0.
[    5.211211] initcall 0xc0a76726 ran for 0 msecs: init_hfsplus_fs+0x0/0x50()
[    5.218143] Calling initcall 0xc0a76776: ecryptfs_init+0x0/0x160()
[    5.222588] initcall 0xc0a76776: ecryptfs_init+0x0/0x160() returned 0.
[    5.231210] initcall 0xc0a76776 ran for 0 msecs: ecryptfs_init+0x0/0x160()
[    5.238057] Calling initcall 0xc0a768d6: vxfs_init+0x0/0x4d()
[    5.242079] initcall 0xc0a768d6: vxfs_init+0x0/0x4d() returned 0.
[    5.251211] initcall 0xc0a768d6 ran for 0 msecs: vxfs_init+0x0/0x4d()
[    5.257623] Calling initcall 0xc0a769c0: init_nfs_fs+0x0/0xb4()
[    5.262358] initcall 0xc0a769c0: init_nfs_fs+0x0/0xb4() returned 0.
[    5.268490] initcall 0xc0a769c0 ran for 0 msecs: init_nfs_fs+0x0/0xb4()
[    5.272077] Calling initcall 0xc0a76c06: init_nfsd+0x0/0xa4()
[    5.282077] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.288970] initcall 0xc0a76c06: init_nfsd+0x0/0xa4() returned 0.
[    5.293118] initcall 0xc0a76c06 ran for 6 msecs: init_nfsd+0x0/0xa4()
[    5.300005] Calling initcall 0xc0a76caa: init_nlm+0x0/0x1c()
[    5.305665] initcall 0xc0a76caa: init_nlm+0x0/0x1c() returned 0.
[    5.311210] initcall 0xc0a76caa ran for 0 msecs: init_nlm+0x0/0x1c()
[    5.317536] Calling initcall 0xc0a76cc6: init_nls_cp437+0x0/0xf()
[    5.322432] initcall 0xc0a76cc6: init_nls_cp437+0x0/0xf() returned 0.
[    5.331211] initcall 0xc0a76cc6 ran for 0 msecs: init_nls_cp437+0x0/0xf()
[    5.337971] Calling initcall 0xc0a76cd5: init_nls_cp775+0x0/0xf()
[    5.342424] initcall 0xc0a76cd5: init_nls_cp775+0x0/0xf() returned 0.
[    5.350005] initcall 0xc0a76cd5 ran for 0 msecs: init_nls_cp775+0x0/0xf()
[    5.356757] Calling initcall 0xc0a76ce4: init_nls_cp857+0x0/0xf()
[    5.362425] initcall 0xc0a76ce4: init_nls_cp857+0x0/0xf() returned 0.
[    5.370005] initcall 0xc0a76ce4 ran for 0 msecs: init_nls_cp857+0x0/0xf()
[    5.376757] Calling initcall 0xc0a76cf3: init_nls_cp861+0x0/0xf()
[    5.382425] initcall 0xc0a76cf3: init_nls_cp861+0x0/0xf() returned 0.
[    5.388837] initcall 0xc0a76cf3 ran for 0 msecs: init_nls_cp861+0x0/0xf()
[    5.392250] Calling initcall 0xc0a76d02: init_nls_cp864+0x0/0xf()
[    5.400172] initcall 0xc0a76d02: init_nls_cp864+0x0/0xf() returned 0.
[    5.406585] initcall 0xc0a76d02 ran for 0 msecs: init_nls_cp864+0x0/0xf()
[    5.412251] Calling initcall 0xc0a76d11: init_nls_cp874+0x0/0xf()
[    5.420172] initcall 0xc0a76d11: init_nls_cp874+0x0/0xf() returned 0.
[    5.426584] initcall 0xc0a76d11 ran for 0 msecs: init_nls_cp874+0x0/0xf()
[    5.432251] Calling initcall 0xc0a76d20: init_nls_cp949+0x0/0xf()
[    5.440171] initcall 0xc0a76d20: init_nls_cp949+0x0/0xf() returned 0.
[    5.446583] initcall 0xc0a76d20 ran for 0 msecs: init_nls_cp949+0x0/0xf()
[    5.452251] Calling initcall 0xc0a76d2f: init_nls_cp950+0x0/0xf()
[    5.460005] initcall 0xc0a76d2f: init_nls_cp950+0x0/0xf() returned 0.
[    5.466410] initcall 0xc0a76d2f ran for 0 msecs: init_nls_cp950+0x0/0xf()
[    5.472251] Calling initcall 0xc0a76d3e: init_nls_cp1251+0x0/0xf()
[    5.478404] initcall 0xc0a76d3e: init_nls_cp1251+0x0/0xf() returned 0.
[    5.483551] initcall 0xc0a76d3e ran for 0 msecs: init_nls_cp1251+0x0/0xf()
[    5.492337] Calling initcall 0xc0a76d4d: init_nls_ascii+0x0/0xf()
[    5.498404] initcall 0xc0a76d4d: init_nls_ascii+0x0/0xf() returned 0.
[    5.503463] initcall 0xc0a76d4d ran for 0 msecs: init_nls_ascii+0x0/0xf()
[    5.510005] Calling initcall 0xc0a76d5c: init_nls_iso8859_1+0x0/0xf()
[    5.516410] initcall 0xc0a76d5c: init_nls_iso8859_1+0x0/0xf() returned 0.
[    5.523810] initcall 0xc0a76d5c ran for 0 msecs: init_nls_iso8859_1+0x0/0xf()
[    5.530004] Calling initcall 0xc0a76d6b: init_nls_iso8859_3+0x0/0xf()
[    5.536410] initcall 0xc0a76d6b: init_nls_iso8859_3+0x0/0xf() returned 0.
[    5.543811] initcall 0xc0a76d6b ran for 0 msecs: init_nls_iso8859_3+0x0/0xf()
[    5.550004] Calling initcall 0xc0a76d7a: init_nls_iso8859_4+0x0/0xf()
[    5.556411] initcall 0xc0a76d7a: init_nls_iso8859_4+0x0/0xf() returned 0.
[    5.563811] initcall 0xc0a76d7a ran for 0 msecs: init_nls_iso8859_4+0x0/0xf()
[    5.572597] Calling initcall 0xc0a76d89: init_nls_iso8859_5+0x0/0xf()
[    5.579010] initcall 0xc0a76d89: init_nls_iso8859_5+0x0/0xf() returned 0.
[    5.583810] initcall 0xc0a76d89 ran for 0 msecs: init_nls_iso8859_5+0x0/0xf()
[    5.592597] Calling initcall 0xc0a76d98: init_nls_iso8859_6+0x0/0xf()
[    5.599010] initcall 0xc0a76d98: init_nls_iso8859_6+0x0/0xf() returned 0.
[    5.603810] initcall 0xc0a76d98 ran for 0 msecs: init_nls_iso8859_6+0x0/0xf()
[    5.612597] Calling initcall 0xc0a76da7: init_nls_iso8859_7+0x0/0xf()
[    5.619010] initcall 0xc0a76da7: init_nls_iso8859_7+0x0/0xf() returned 0.
[    5.623810] initcall 0xc0a76da7 ran for 0 msecs: init_nls_iso8859_7+0x0/0xf()
[    5.632597] Calling initcall 0xc0a76db6: init_nls_iso8859_9+0x0/0xf()
[    5.640005] initcall 0xc0a76db6: init_nls_iso8859_9+0x0/0xf() returned 0.
[    5.646758] initcall 0xc0a76db6 ran for 0 msecs: init_nls_iso8859_9+0x0/0xf()
[    5.652597] Calling initcall 0xc0a76dc5: init_nls_iso8859_14+0x0/0xf()
[    5.660172] initcall 0xc0a76dc5: init_nls_iso8859_14+0x0/0xf() returned 0.
[    5.667017] initcall 0xc0a76dc5 ran for 0 msecs: init_nls_iso8859_14+0x0/0xf()
[    5.672684] Calling initcall 0xc0a76dd4: init_nls_iso8859_15+0x0/0xf()
[    5.680172] initcall 0xc0a76dd4: init_nls_iso8859_15+0x0/0xf() returned 0.
[    5.687017] initcall 0xc0a76dd4 ran for 0 msecs: init_nls_iso8859_15+0x0/0xf()
[    5.692683] Calling initcall 0xc0a76de3: init_nls_koi8_r+0x0/0xf()
[    5.700171] initcall 0xc0a76de3: init_nls_koi8_r+0x0/0xf() returned 0.
[    5.706670] initcall 0xc0a76de3 ran for 0 msecs: init_nls_koi8_r+0x0/0xf()
[    5.712337] Calling initcall 0xc0a76df2: init_nls_utf8+0x0/0x1f()
[    5.720172] initcall 0xc0a76df2: init_nls_utf8+0x0/0x1f() returned 0.
[    5.726584] initcall 0xc0a76df2 ran for 0 msecs: init_nls_utf8+0x0/0x1f()
[    5.732250] Calling initcall 0xc0a76e11: init_smb_fs+0x0/0x61()
[    5.738146] initcall 0xc0a76e11: init_smb_fs+0x0/0x61() returned 0.
[    5.743290] initcall 0xc0a76e11 ran for 0 msecs: init_smb_fs+0x0/0x61()
[    5.752077] Calling initcall 0xc0a76e72: init_ntfs_fs+0x0/0x199()
[    5.758144] NTFS driver 2.1.29 [Flags: R/W].
[    5.760009] initcall 0xc0a76e72: init_ntfs_fs+0x0/0x199() returned 0.
[    5.766410] initcall 0xc0a76e72 ran for 4 msecs: init_ntfs_fs+0x0/0x199()
[    5.772251] Calling initcall 0xc0a7700b: init_affs_fs+0x0/0x4f()
[    5.780172] initcall 0xc0a7700b: init_affs_fs+0x0/0x4f() returned 0.
[    5.786497] initcall 0xc0a7700b ran for 0 msecs: init_affs_fs+0x0/0x4f()
[    5.792164] Calling initcall 0xc0a7705a: init_romfs_fs+0x0/0x4f()
[    5.800173] initcall 0xc0a7705a: init_romfs_fs+0x0/0x4f() returned 0.
[    5.806584] initcall 0xc0a7705a ran for 0 msecs: init_romfs_fs+0x0/0x4f()
[    5.812251] Calling initcall 0xc0a770a9: init_autofs4_fs+0x0/0xf()
[    5.820172] initcall 0xc0a770a9: init_autofs4_fs+0x0/0xf() returned 0.
[    5.826670] initcall 0xc0a770a9 ran for 0 msecs: init_autofs4_fs+0x0/0xf()
[    5.832337] Calling initcall 0xc0a770b8: init_jfs_fs+0x0/0x1fe()
[    5.838338] JFS: nTxBlock = 7805, nTxLock = 62442
[    5.843570] initcall 0xc0a770b8: init_jfs_fs+0x0/0x1fe() returned 0.
[    5.853374] initcall 0xc0a770b8 ran for 7 msecs: init_jfs_fs+0x0/0x1fe()
[    5.860008] Calling initcall 0xc0a77315: init_befs_fs+0x0/0x6a()
[    5.865977] BeFS version: 0.9.3
[    5.869099] initcall 0xc0a77315: init_befs_fs+0x0/0x6a() returned 0.
[    5.873377] initcall 0xc0a77315 ran for 2 msecs: init_befs_fs+0x0/0x6a()
[    5.882163] Calling initcall 0xc0a773c0: ocfs2_init+0x0/0x377()
[    5.888057] OCFS2 1.5.0
[    5.890125] initcall 0xc0a773c0: ocfs2_init+0x0/0x377() returned 0.
[    5.896237] initcall 0xc0a773c0 ran for 2 msecs: ocfs2_init+0x0/0x377()
[    5.902077] Calling initcall 0xc0a777d4: init_o2nm+0x0/0xb0()
[    5.907796] OCFS2 Node Manager 1.5.0
[    5.910370] initcall 0xc0a777d4: init_o2nm+0x0/0xb0() returned 0.
[    5.916280] initcall 0xc0a777d4 ran for 3 msecs: init_o2nm+0x0/0xb0()
[    5.921903] Calling initcall 0xc0a77884: dlm_init+0x0/0xaa()
[    5.930171] OCFS2 DLM 1.5.0
[    5.932962] initcall 0xc0a77884: dlm_init+0x0/0xaa() returned 0.
[    5.940005] initcall 0xc0a77884 ran for 2 msecs: dlm_init+0x0/0xaa()
[    5.946324] Calling initcall 0xc0a7792e: init_dlmfs_fs+0x0/0xc0()
[    5.952424] OCFS2 DLMFS 1.5.0
[    5.955418] OCFS2 User DLM kernel interface loaded
[    5.960006] initcall 0xc0a7792e: init_dlmfs_fs+0x0/0xc0() returned 0.
[    5.966409] initcall 0xc0a7792e ran for 7 msecs: init_dlmfs_fs+0x0/0xc0()
[    5.972250] Calling initcall 0xc0a77b1e: key_proc_init+0x0/0x2a()
[    5.978319] initcall 0xc0a77b1e: key_proc_init+0x0/0x2a() returned 0.
[    5.983464] initcall 0xc0a77b1e ran for 0 msecs: key_proc_init+0x0/0x2a()
[    5.992251] Calling initcall 0xc0a77c42: crypto_algapi_init+0x0/0xc()
[    5.998666] initcall 0xc0a77c42: crypto_algapi_init+0x0/0xc() returned 0.
[    6.003811] initcall 0xc0a77c42 ran for 0 msecs: crypto_algapi_init+0x0/0xc()
[    6.012596] Calling initcall 0xc0a77c6c: chainiv_module_init+0x0/0xf()
[    6.019108] initcall 0xc0a77c6c: chainiv_module_init+0x0/0xf() returned 0.
[    6.023897] initcall 0xc0a77c6c ran for 0 msecs: chainiv_module_init+0x0/0xf()
[    6.032684] Calling initcall 0xc0a77c7b: eseqiv_module_init+0x0/0xf()
[    6.040005] initcall 0xc0a77c7b: eseqiv_module_init+0x0/0xf() returned 0.
[    6.046757] initcall 0xc0a77c7b ran for 0 msecs: eseqiv_module_init+0x0/0xf()
[    6.052598] Calling initcall 0xc0a77c8a: seqiv_module_init+0x0/0xf()
[    6.060171] initcall 0xc0a77c8a: seqiv_module_init+0x0/0xf() returned 0.
[    6.066844] initcall 0xc0a77c8a ran for 0 msecs: seqiv_module_init+0x0/0xf()
[    6.072510] Calling initcall 0xc0a77c99: cryptomgr_init+0x0/0xf()
[    6.080005] initcall 0xc0a77c99: cryptomgr_init+0x0/0xf() returned 0.
[    6.086410] initcall 0xc0a77c99 ran for 0 msecs: cryptomgr_init+0x0/0xf()
[    6.092251] Calling initcall 0xc0a77ca8: hmac_module_init+0x0/0xf()
[    6.098499] initcall 0xc0a77ca8: hmac_module_init+0x0/0xf() returned 0.
[    6.103637] initcall 0xc0a77ca8 ran for 0 msecs: hmac_module_init+0x0/0xf()
[    6.112424] Calling initcall 0xc0a77cb7: crypto_xcbc_module_init+0x0/0xf()
[    6.119272] initcall 0xc0a77cb7: crypto_xcbc_module_init+0x0/0xf() returned 0.
[    6.124244] initcall 0xc0a77cb7 ran for 0 msecs: crypto_xcbc_module_init+0x0/0xf()
[    6.133030] Calling initcall 0xc0a77cc6: init+0x0/0xf()
[    6.138231] initcall 0xc0a77cc6: init+0x0/0xf() returned 0.
[    6.142598] initcall 0xc0a77cc6 ran for 0 msecs: init+0x0/0xf()
[    6.150005] Calling initcall 0xc0a77cd5: init+0x0/0xf()
[    6.155198] initcall 0xc0a77cd5: init+0x0/0xf() returned 0.
[    6.161211] initcall 0xc0a77cd5 ran for 0 msecs: init+0x0/0xf()
[    6.167104] Calling initcall 0xc0a77ce4: init+0x0/0xf()
[    6.171558] initcall 0xc0a77ce4: init+0x0/0xf() returned 0.
[    6.177104] initcall 0xc0a77ce4 ran for 0 msecs: init+0x0/0xf()
[    6.181384] Calling initcall 0xc0a77cf3: init+0x0/0x33()
[    6.186672] initcall 0xc0a77cf3: init+0x0/0x33() returned 0.
[    6.192684] initcall 0xc0a77cf3 ran for 0 msecs: init+0x0/0x33()
[    6.200005] Calling initcall 0xc0a77d26: crypto_ecb_module_init+0x0/0xf()
[    6.206759] initcall 0xc0a77d26: crypto_ecb_module_init+0x0/0xf() returned 0.
[    6.214157] initcall 0xc0a77d26 ran for 0 msecs: crypto_ecb_module_init+0x0/0xf()
[    6.220005] Calling initcall 0xc0a77d35: crypto_cbc_module_init+0x0/0xf()
[    6.226758] initcall 0xc0a77d35: crypto_cbc_module_init+0x0/0xf() returned 0.
[    6.234158] initcall 0xc0a77d35 ran for 0 msecs: crypto_cbc_module_init+0x0/0xf()
[    6.242944] Calling initcall 0xc0a77d44: crypto_module_init+0x0/0xf()
[    6.250171] initcall 0xc0a77d44: crypto_module_init+0x0/0xf() returned 0.
[    6.256930] initcall 0xc0a77d44 ran for 0 msecs: crypto_module_init+0x0/0xf()
[    6.262598] Calling initcall 0xc0a77d53: crypto_ctr_module_init+0x0/0x33()
[    6.270173] initcall 0xc0a77d53: crypto_ctr_module_init+0x0/0x33() returned 0.
[    6.277364] initcall 0xc0a77d53 ran for 0 msecs: crypto_ctr_module_init+0x0/0x33()
[    6.283030] Calling initcall 0xc0a77d86: crypto_gcm_module_init+0x0/0x4d()
[    6.290172] initcall 0xc0a77d86: crypto_gcm_module_init+0x0/0x4d() returned 0.
[    6.297364] initcall 0xc0a77d86 ran for 0 msecs: crypto_gcm_module_init+0x0/0x4d()
[    6.303031] Calling initcall 0xc0a77dd3: crypto_ccm_module_init+0x0/0x4d()
[    6.313206] initcall 0xc0a77dd3: crypto_ccm_module_init+0x0/0x4d() returned 0.
[    6.321211] initcall 0xc0a77dd3 ran for 0 msecs: crypto_ccm_module_init+0x0/0x4d()
[    6.328751] Calling initcall 0xc0a77e20: init+0x0/0x33()
[    6.331646] initcall 0xc0a77e20: init+0x0/0x33() returned 0.
[    6.337277] initcall 0xc0a77e20 ran for 0 msecs: init+0x0/0x33()
[    6.341470] Calling initcall 0xc0a77e53: init+0x0/0x33()
[    6.350173] initcall 0xc0a77e53: init+0x0/0x33() returned 0.
[    6.355804] initcall 0xc0a77e53 ran for 0 msecs: init+0x0/0x33()
[    6.361470] Calling initcall 0xc0a77e86: camellia_init+0x0/0xf()
[    6.367451] initcall 0xc0a77e86: camellia_init+0x0/0xf() returned 0.
[    6.373378] initcall 0xc0a77e86 ran for 0 msecs: camellia_init+0x0/0xf()
[    6.380005] Calling initcall 0xc0a77e95: arc4_init+0x0/0xf()
[    6.385632] initcall 0xc0a77e95: arc4_init+0x0/0xf() returned 0.
[    6.393031] initcall 0xc0a77e95 ran for 0 msecs: arc4_init+0x0/0xf()
[    6.399357] Calling initcall 0xc0a77ea4: init+0x0/0xf()
[    6.401558] initcall 0xc0a77ea4: init+0x0/0xf() returned 0.
[    6.410005] initcall 0xc0a77ea4 ran for 0 msecs: init+0x0/0xf()
[    6.415891] Calling initcall 0xc0a77eb3: init+0x0/0xf()
[    6.421558] initcall 0xc0a77eb3: init+0x0/0xf() returned 0.
[    6.427104] initcall 0xc0a77eb3 ran for 0 msecs: init+0x0/0xf()
[    6.431384] Calling initcall 0xc0a77ec2: seed_init+0x0/0xf()
[    6.437018] initcall 0xc0a77ec2: seed_init+0x0/0xf() returned 0.
[    6.443031] initcall 0xc0a77ec2 ran for 0 msecs: seed_init+0x0/0xf()
[    6.450005] Calling initcall 0xc0a77ed1: init+0x0/0xf()
[    6.455199] initcall 0xc0a77ed1: init+0x0/0xf() returned 0.
[    6.461210] initcall 0xc0a77ed1 ran for 0 msecs: init+0x0/0xf()
[    6.467103] Calling initcall 0xc0a77ee0: init+0x0/0xf()
[    6.471557] initcall 0xc0a77ee0: init+0x0/0xf() returned 0.
[    6.477103] initcall 0xc0a77ee0 ran for 0 msecs: init+0x0/0xf()
[    6.481384] Calling initcall 0xc0a77eef: init+0x0/0xf()
[    6.486585] initcall 0xc0a77eef: init+0x0/0xf() returned 0.
[    6.492598] initcall 0xc0a77eef ran for 0 msecs: init+0x0/0xf()
[    6.500005] Calling initcall 0xc0a7817f: bsg_init+0x0/0x101()
[    6.505809] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    6.510006] initcall 0xc0a7817f: bsg_init+0x0/0x101() returned 0.
[    6.520005] initcall 0xc0a7817f ran for 7 msecs: bsg_init+0x0/0x101()
[    6.526410] Calling initcall 0xc0a78280: noop_init+0x0/0x11()
[    6.532090] io scheduler noop registered (default)
[    6.536844] initcall 0xc0a78280: noop_init+0x0/0x11() returned 0.
[    6.541210] initcall 0xc0a78280 ran for 4 msecs: noop_init+0x0/0x11()
[    6.547624] Calling initcall 0xc0a78291: deadline_init+0x0/0x11()
[    6.552424] io scheduler deadline registered
[    6.556670] initcall 0xc0a78291: deadline_init+0x0/0x11() returned 0.
[    6.563463] initcall 0xc0a78291 ran for 4 msecs: deadline_init+0x0/0x11()
[    6.572251] Calling initcall 0xc0a782a2: cfq_init+0x0/0x8c()
[    6.577886] io scheduler cfq registered
[    6.580005] initcall 0xc0a782a2: cfq_init+0x0/0x8c() returned 0.
[    6.585977] initcall 0xc0a782a2 ran for 3 msecs: cfq_init+0x0/0x8c()
[    6.591817] Calling initcall 0xc0709a54: pci_init+0x0/0x2c()
[    6.627154] pci 0000:00:0b.0: Linking AER extended capability
[    6.630002] pci 0000:00:0c.0: Linking AER extended capability
[    6.630008] pci 0000:00:0d.0: Linking AER extended capability
[    6.635719] pci 0000:00:0e.0: Linking AER extended capability
[    6.640012] pci 0000:01:00.0: Boot video device
[    6.644505] initcall 0xc0709a54: pci_init+0x0/0x2c() returned 0.
[    6.653030] initcall 0xc0709a54 ran for 44 msecs: pci_init+0x0/0x2c()
[    6.659442] Calling initcall 0xc0a789eb: pci_proc_init+0x0/0x5f()
[    6.662478] initcall 0xc0a789eb: pci_proc_init+0x0/0x5f() returned 0.
[    6.671211] initcall 0xc0a789eb ran for 0 msecs: pci_proc_init+0x0/0x5f()
[    6.677970] Calling initcall 0xc0a78a7d: pcie_portdrv_init+0x0/0x41()
[    6.682925] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    6.690042] assign_interrupt_mode Found MSI capability
[    6.695110] Allocate Port Service[0000:00:0b.0:pcie00]
[    6.700019] PM: Adding info for pci_express:0000:00:0b.0:pcie00
[    6.705990] Allocate Port Service[0000:00:0b.0:pcie03]
[    6.710017] PM: Adding info for pci_express:0000:00:0b.0:pcie03
[    6.716040] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    6.720049] assign_interrupt_mode Found MSI capability
[    6.730006] Allocate Port Service[0000:00:0c.0:pcie00]
[    6.735122] PM: Adding info for pci_express:0000:00:0c.0:pcie00
[    6.740086] Allocate Port Service[0000:00:0c.0:pcie03]
[    6.745122] PM: Adding info for pci_express:0000:00:0c.0:pcie03
[    6.750147] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    6.756272] assign_interrupt_mode Found MSI capability
[    6.760019] Allocate Port Service[0000:00:0d.0:pcie00]
[    6.765122] PM: Adding info for pci_express:0000:00:0d.0:pcie00
[    6.770085] Allocate Port Service[0000:00:0d.0:pcie03]
[    6.775123] PM: Adding info for pci_express:0000:00:0d.0:pcie03
[    6.780145] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    6.790054] assign_interrupt_mode Found MSI capability
[    6.795111] Allocate Port Service[0000:00:0e.0:pcie00]
[    6.800017] PM: Adding info for pci_express:0000:00:0e.0:pcie00
[    6.805972] Allocate Port Service[0000:00:0e.0:pcie03]
[    6.810018] PM: Adding info for pci_express:0000:00:0e.0:pcie03
[    6.816096] initcall 0xc0a78a7d: pcie_portdrv_init+0x0/0x41() returned 0.
[    6.823811] initcall 0xc0a78a7d ran for 127 msecs: pcie_portdrv_init+0x0/0x41()
[    6.832597] Calling initcall 0xc0a78abe: aer_service_init+0x0/0x1d()
[    6.839007] initcall 0xc0a78abe: aer_service_init+0x0/0x1d() returned 0.
[    6.843724] initcall 0xc0a78abe ran for 0 msecs: aer_service_init+0x0/0x1d()
[    6.852511] Calling initcall 0xc0a78adb: pci_hotplug_init+0x0/0x50()
[    6.858842] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.860005] initcall 0xc0a78adb: pci_hotplug_init+0x0/0x50() returned 0.
[    6.871212] initcall 0xc0a78adb ran for 5 msecs: pci_hotplug_init+0x0/0x50()
[    6.878230] Calling initcall 0xc0a78b2b: pcied_init+0x0/0x68()
[    6.882244] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.890016] initcall 0xc0a78b2b: pcied_init+0x0/0x68() returned 0.
[    6.896150] initcall 0xc0a78b2b ran for 6 msecs: pcied_init+0x0/0x68()
[    6.901991] Calling initcall 0xc0a78b93: dummyphp_init+0x0/0x78()
[    6.908058] fakephp: Fake PCI Hot Plug Controller Driver
[    6.911588] initcall 0xc0a78b93: dummyphp_init+0x0/0x78() returned 0.
[    6.921210] initcall 0xc0a78b93 ran for 6 msecs: dummyphp_init+0x0/0x78()
[    6.927970] Calling initcall 0xc0a78d26: corgibl_init+0x0/0xf()
[    6.932329] initcall 0xc0a78d26: corgibl_init+0x0/0xf() returned 0.
[    6.941210] initcall 0xc0a78d26 ran for 0 msecs: corgibl_init+0x0/0xf()
[    6.947796] Calling initcall 0xc0a78d35: display_class_init+0x0/0x6d()
[    6.952929] initcall 0xc0a78d35: display_class_init+0x0/0x6d() returned 0.
[    6.961210] initcall 0xc0a78d35 ran for 0 msecs: display_class_init+0x0/0x6d()
[    6.968403] Calling initcall 0xc0a7919f: acpi_reserve_resources+0x0/0xc8()
[    6.973211] initcall 0xc0a7919f: acpi_reserve_resources+0x0/0xc8() returned 0.
[    6.981212] initcall 0xc0a7919f ran for 0 msecs: acpi_reserve_resources+0x0/0xc8()
[    6.990005] Calling initcall 0xc0a79f07: acpi_ac_init+0x0/0x3d()
[    6.996120] initcall 0xc0a79f07: acpi_ac_init+0x0/0x3d() returned 0.
[    7.001210] initcall 0xc0a79f07 ran for 0 msecs: acpi_ac_init+0x0/0x3d()
[    7.007883] Calling initcall 0xc0a79f44: acpi_battery_init+0x0/0x3d()
[    7.012879] initcall 0xc0a79f44: acpi_battery_init+0x0/0x3d() returned 0.
[    7.021210] initcall 0xc0a79f44 ran for 0 msecs: acpi_battery_init+0x0/0x3d()
[    7.028315] Calling initcall 0xc0a79f81: acpi_button_init+0x0/0x51()
[    7.032777] PM: Adding info for No Bus:input0
[    7.040086] input: Power Button (FF) as /class/input/input0
[    7.045565] ACPI: Power Button (FF) [PWRF]
[    7.049687] PM: Adding info for No Bus:input1
[    7.050083] input: Power Button (CM) as /class/input/input1
[    7.055544] ACPI: Power Button (CM) [PWRB]
[    7.060124] initcall 0xc0a79f81: acpi_button_init+0x0/0x51() returned 0.
[    7.070006] initcall 0xc0a79f81 ran for 26 msecs: acpi_button_init+0x0/0x51()
[    7.077103] Calling initcall 0xc0a79fd2: acpi_fan_init+0x0/0x51()
[    7.082480] ACPI: Fan [FAN] (on)
[    7.085698] initcall 0xc0a79fd2: acpi_fan_init+0x0/0x51() returned 0.
[    7.091209] initcall 0xc0a79fd2 ran for 3 msecs: acpi_fan_init+0x0/0x51()
[    7.100010] Calling initcall 0xc0a7a0ee: irqrouter_init_sysfs+0x0/0x33()
[    7.106791] initcall 0xc0a7a0ee: irqrouter_init_sysfs+0x0/0x33() returned 0.
[    7.111210] initcall 0xc0a7a0ee ran for 0 msecs: irqrouter_init_sysfs+0x0/0x33()
[    7.120014] Calling initcall 0xc0a7a24c: acpi_processor_init+0x0/0x6a()
[    7.126751] initcall 0xc0a7a24c: acpi_processor_init+0x0/0x6a() returned 0.
[    7.133983] initcall 0xc0a7a24c ran for 0 msecs: acpi_processor_init+0x0/0x6a()
[    7.140015] Calling initcall 0xc0a7a2b6: acpi_thermal_init+0x0/0x76()
[    7.147549] ACPI: Thermal Zone [THRM] (40 C)
[    7.150076] initcall 0xc0a7a2b6: acpi_thermal_init+0x0/0x76() returned 0.
[    7.160006] initcall 0xc0a7a2b6 ran for 5 msecs: acpi_thermal_init+0x0/0x76()
[    7.167103] Calling initcall 0xc0a7a4dc: toshiba_acpi_init+0x0/0x159()
[    7.172862] initcall 0xc0a7a4dc: toshiba_acpi_init+0x0/0x159() returned -19.
[    7.180005] initcall 0xc0a7a4dc ran for 0 msecs: toshiba_acpi_init+0x0/0x159()
[    7.187190] Calling initcall 0xc0a7a635: acpi_memory_device_init+0x0/0x6f()
[    7.201577] initcall 0xc0a7a635: acpi_memory_device_init+0x0/0x6f() returned 0.
[    7.208706] initcall 0xc0a7a635 ran for 6 msecs: acpi_memory_device_init+0x0/0x6f()
[    7.213117] Calling initcall 0xc0a7ac88: rand_initialize+0x0/0x25()
[    7.220197] initcall 0xc0a7ac88: rand_initialize+0x0/0x25() returned 0.
[    7.226757] initcall 0xc0a7ac88 ran for 0 msecs: rand_initialize+0x0/0x25()
[    7.232423] Calling initcall 0xc0a7ace2: tty_init+0x0/0x18f()
[    7.240193] PM: Adding info for No Bus:tty
[    7.244336] PM: Adding info for No Bus:console
[    7.250083] PM: Adding info for No Bus:ptmx
[    7.254241] PM: Adding info for No Bus:tty0
[    7.258477] PM: Adding info for No Bus:vcs
[    7.260085] PM: Adding info for No Bus:vcsa
[    7.264263] PM: Adding info for No Bus:tty1
[    7.270092] PM: Adding info for No Bus:tty2
[    7.274236] PM: Adding info for No Bus:tty3
[    7.278395] PM: Adding info for No Bus:tty4
[    7.280113] PM: Adding info for No Bus:tty5
[    7.284239] PM: Adding info for No Bus:tty6
[    7.290094] PM: Adding info for No Bus:tty7
[    7.294236] PM: Adding info for No Bus:tty8
[    7.300106] PM: Adding info for No Bus:tty9
[    7.304241] PM: Adding info for No Bus:tty10
[    7.308484] PM: Adding info for No Bus:tty11
[    7.310090] PM: Adding info for No Bus:tty12
[    7.314320] PM: Adding info for No Bus:tty13
[    7.320116] PM: Adding info for No Bus:tty14
[    7.324330] PM: Adding info for No Bus:tty15
[    7.328575] PM: Adding info for No Bus:tty16
[    7.330090] PM: Adding info for No Bus:tty17
[    7.334332] PM: Adding info for No Bus:tty18
[    7.340109] PM: Adding info for No Bus:tty19
[    7.344327] PM: Adding info for No Bus:tty20
[    7.350089] PM: Adding info for No Bus:tty21
[    7.354325] PM: Adding info for No Bus:tty22
[    7.358575] PM: Adding info for No Bus:tty23
[    7.360114] PM: Adding info for No Bus:tty24
[    7.364323] PM: Adding info for No Bus:tty25
[    7.370095] PM: Adding info for No Bus:tty26
[    7.374324] PM: Adding info for No Bus:tty27
[    7.380113] PM: Adding info for No Bus:tty28
[    7.384322] PM: Adding info for No Bus:tty29
[    7.388573] PM: Adding info for No Bus:tty30
[    7.390098] PM: Adding info for No Bus:tty31
[    7.394342] PM: Adding info for No Bus:tty32
[    7.400121] PM: Adding info for No Bus:tty33
[    7.404334] PM: Adding info for No Bus:tty34
[    7.410087] PM: Adding info for No Bus:tty35
[    7.414326] PM: Adding info for No Bus:tty36
[    7.418582] PM: Adding info for No Bus:tty37
[    7.420109] PM: Adding info for No Bus:tty38
[    7.424329] PM: Adding info for No Bus:tty39
[    7.430097] PM: Adding info for No Bus:tty40
[    7.434328] PM: Adding info for No Bus:tty41
[    7.440118] PM: Adding info for No Bus:tty42
[    7.444326] PM: Adding info for No Bus:tty43
[    7.448575] PM: Adding info for No Bus:tty44
[    7.450093] PM: Adding info for No Bus:tty45
[    7.454324] PM: Adding info for No Bus:tty46
[    7.460109] PM: Adding info for No Bus:tty47
[    7.464320] PM: Adding info for No Bus:tty48
[    7.470023] PM: Adding info for No Bus:tty49
[    7.474255] PM: Adding info for No Bus:tty50
[    7.478506] PM: Adding info for No Bus:tty51
[    7.480105] PM: Adding info for No Bus:tty52
[    7.484321] PM: Adding info for No Bus:tty53
[    7.490095] PM: Adding info for No Bus:tty54
[    7.494336] PM: Adding info for No Bus:tty55
[    7.498581] PM: Adding info for No Bus:tty56
[    7.500114] PM: Adding info for No Bus:tty57
[    7.504333] PM: Adding info for No Bus:tty58
[    7.510103] PM: Adding info for No Bus:tty59
[    7.514332] PM: Adding info for No Bus:tty60
[    7.520116] PM: Adding info for No Bus:tty61
[    7.524326] PM: Adding info for No Bus:tty62
[    7.528576] PM: Adding info for No Bus:tty63
[    7.530249] initcall 0xc0a7ace2: tty_init+0x0/0x18f() returned 0.
[    7.536158] initcall 0xc0a7ace2 ran for 278 msecs: tty_init+0x0/0x18f()
[    7.541904] Calling initcall 0xc0a7ae98: pty_init+0x0/0x397()
[    7.552112] PM: Adding info for No Bus:ptyp0
[    7.556433] PM: Adding info for No Bus:ptyp1
[    7.560100] PM: Adding info for No Bus:ptyp2
[    7.564333] PM: Adding info for No Bus:ptyp3
[    7.568579] PM: Adding info for No Bus:ptyp4
[    7.570095] PM: Adding info for No Bus:ptyp5
[    7.574332] PM: Adding info for No Bus:ptyp6
[    7.580112] PM: Adding info for No Bus:ptyp7
[    7.584336] PM: Adding info for No Bus:ptyp8
[    7.590094] PM: Adding info for No Bus:ptyp9
[    7.594339] PM: Adding info for No Bus:ptypa
[    7.598578] PM: Adding info for No Bus:ptypb
[    7.600120] PM: Adding info for No Bus:ptypc
[    7.604334] PM: Adding info for No Bus:ptypd
[    7.610104] PM: Adding info for No Bus:ptype
[    7.614334] PM: Adding info for No Bus:ptypf
[    7.620118] PM: Adding info for No Bus:ptyq0
[    7.624345] PM: Adding info for No Bus:ptyq1
[    7.628583] PM: Adding info for No Bus:ptyq2
[    7.630097] PM: Adding info for No Bus:ptyq3
[    7.634332] PM: Adding info for No Bus:ptyq4
[    7.640112] PM: Adding info for No Bus:ptyq5
[    7.644326] PM: Adding info for No Bus:ptyq6
[    7.648577] PM: Adding info for No Bus:ptyq7
[    7.650096] PM: Adding info for No Bus:ptyq8
[    7.654339] PM: Adding info for No Bus:ptyq9
[    7.660126] PM: Adding info for No Bus:ptyqa
[    7.664333] PM: Adding info for No Bus:ptyqb
[    7.670108] PM: Adding info for No Bus:ptyqc
[    7.674339] PM: Adding info for No Bus:ptyqd
[    7.678581] PM: Adding info for No Bus:ptyqe
[    7.680118] PM: Adding info for No Bus:ptyqf
[    7.684337] PM: Adding info for No Bus:ptyr0
[    7.690102] PM: Adding info for No Bus:ptyr1
[    7.694335] PM: Adding info for No Bus:ptyr2
[    7.700120] PM: Adding info for No Bus:ptyr3
[    7.704335] PM: Adding info for No Bus:ptyr4
[    7.708592] PM: Adding info for No Bus:ptyr5
[    7.710105] PM: Adding info for No Bus:ptyr6
[    7.714334] PM: Adding info for No Bus:ptyr7
[    7.720134] PM: Adding info for No Bus:ptyr8
[    7.724342] PM: Adding info for No Bus:ptyr9
[    7.730099] PM: Adding info for No Bus:ptyra
[    7.734335] PM: Adding info for No Bus:ptyrb
[    7.738581] PM: Adding info for No Bus:ptyrc
[    7.740126] PM: Adding info for No Bus:ptyrd
[    7.744332] PM: Adding info for No Bus:ptyre
[    7.750111] PM: Adding info for No Bus:ptyrf
[    7.754342] PM: Adding info for No Bus:ptys0
[    7.760125] PM: Adding info for No Bus:ptys1
[    7.764343] PM: Adding info for No Bus:ptys2
[    7.768583] PM: Adding info for No Bus:ptys3
[    7.770097] PM: Adding info for No Bus:ptys4
[    7.774333] PM: Adding info for No Bus:ptys5
[    7.780122] PM: Adding info for No Bus:ptys6
[    7.784332] PM: Adding info for No Bus:ptys7
[    7.788582] PM: Adding info for No Bus:ptys8
[    7.790107] PM: Adding info for No Bus:ptys9
[    7.794338] PM: Adding info for No Bus:ptysa
[    7.800129] PM: Adding info for No Bus:ptysb
[    7.804348] PM: Adding info for No Bus:ptysc
[    7.810109] PM: Adding info for No Bus:ptysd
[    7.814336] PM: Adding info for No Bus:ptyse
[    7.818582] PM: Adding info for No Bus:ptysf
[    7.820118] PM: Adding info for No Bus:ptyt0
[    7.824333] PM: Adding info for No Bus:ptyt1
[    7.830110] PM: Adding info for No Bus:ptyt2
[    7.834335] PM: Adding info for No Bus:ptyt3
[    7.840113] PM: Adding info for No Bus:ptyt4
[    7.844327] PM: Adding info for No Bus:ptyt5
[    7.848577] PM: Adding info for No Bus:ptyt6
[    7.850093] PM: Adding info for No Bus:ptyt7
[    7.854345] PM: Adding info for No Bus:ptyt8
[    7.860126] PM: Adding info for No Bus:ptyt9
[    7.864337] PM: Adding info for No Bus:ptyta
[    7.870099] PM: Adding info for No Bus:ptytb
[    7.874336] PM: Adding info for No Bus:ptytc
[    7.878585] PM: Adding info for No Bus:ptytd
[    7.880120] PM: Adding info for No Bus:ptyte
[    7.884331] PM: Adding info for No Bus:ptytf
[    7.890123] PM: Adding info for No Bus:ptyu0
[    7.894338] PM: Adding info for No Bus:ptyu1
[    7.900118] PM: Adding info for No Bus:ptyu2
[    7.904332] PM: Adding info for No Bus:ptyu3
[    7.908579] PM: Adding info for No Bus:ptyu4
[    7.910101] PM: Adding info for No Bus:ptyu5
[    7.914338] PM: Adding info for No Bus:ptyu6
[    7.920121] PM: Adding info for No Bus:ptyu7
[    7.924348] PM: Adding info for No Bus:ptyu8
[    7.930105] PM: Adding info for No Bus:ptyu9
[    7.934336] PM: Adding info for No Bus:ptyua
[    7.938583] PM: Adding info for No Bus:ptyub
[    7.940126] PM: Adding info for No Bus:ptyuc
[    7.944334] PM: Adding info for No Bus:ptyud
[    7.950103] PM: Adding info for No Bus:ptyue
[    7.954339] PM: Adding info for No Bus:ptyuf
[    7.958584] PM: Adding info for No Bus:ptyv0
[    7.960121] PM: Adding info for No Bus:ptyv1
[    7.964332] PM: Adding info for No Bus:ptyv2
[    7.970119] PM: Adding info for No Bus:ptyv3
[    7.974338] PM: Adding info for No Bus:ptyv4
[    7.980117] PM: Adding info for No Bus:ptyv5
[    7.984335] PM: Adding info for No Bus:ptyv6
[    7.988600] PM: Adding info for No Bus:ptyv7
[    7.990109] PM: Adding info for No Bus:ptyv8
[    7.994337] PM: Adding info for No Bus:ptyv9
[    8.000122] PM: Adding info for No Bus:ptyva
[    8.004339] PM: Adding info for No Bus:ptyvb
[    8.010113] PM: Adding info for No Bus:ptyvc
[    8.014340] PM: Adding info for No Bus:ptyvd
[    8.018586] PM: Adding info for No Bus:ptyve
[    8.020115] PM: Adding info for No Bus:ptyvf
[    8.024320] PM: Adding info for No Bus:ptyw0
[    8.030102] PM: Adding info for No Bus:ptyw1
[    8.034354] PM: Adding info for No Bus:ptyw2
[    8.040117] PM: Adding info for No Bus:ptyw3
[    8.044335] PM: Adding info for No Bus:ptyw4
[    8.048581] PM: Adding info for No Bus:ptyw5
[    8.050106] PM: Adding info for No Bus:ptyw6
[    8.054337] PM: Adding info for No Bus:ptyw7
[    8.060114] PM: Adding info for No Bus:ptyw8
[    8.064335] PM: Adding info for No Bus:ptyw9
[    8.070094] PM: Adding info for No Bus:ptywa
[    8.074333] PM: Adding info for No Bus:ptywb
[    8.078600] PM: Adding info for No Bus:ptywc
[    8.080116] PM: Adding info for No Bus:ptywd
[    8.084331] PM: Adding info for No Bus:ptywe
[    8.090100] PM: Adding info for No Bus:ptywf
[    8.094338] PM: Adding info for No Bus:ptyx0
[    8.100050] PM: Adding info for No Bus:ptyx1
[    8.104232] PM: Adding info for No Bus:ptyx2
[    8.108489] PM: Adding info for No Bus:ptyx3
[    8.110095] PM: Adding info for No Bus:ptyx4
[    8.114334] PM: Adding info for No Bus:ptyx5
[    8.120141] PM: Adding info for No Bus:ptyx6
[    8.124338] PM: Adding info for No Bus:ptyx7
[    8.128580] PM: Adding info for No Bus:ptyx8
[    8.130098] PM: Adding info for No Bus:ptyx9
[    8.134346] PM: Adding info for No Bus:ptyxa
[    8.140116] PM: Adding info for No Bus:ptyxb
[    8.144336] PM: Adding info for No Bus:ptyxc
[    8.150120] PM: Adding info for No Bus:ptyxd
[    8.154339] PM: Adding info for No Bus:ptyxe
[    8.158587] PM: Adding info for No Bus:ptyxf
[    8.160110] PM: Adding info for No Bus:ptyy0
[    8.164329] PM: Adding info for No Bus:ptyy1
[    8.170097] PM: Adding info for No Bus:ptyy2
[    8.174332] PM: Adding info for No Bus:ptyy3
[    8.180119] PM: Adding info for No Bus:ptyy4
[    8.184335] PM: Adding info for No Bus:ptyy5
[    8.188582] PM: Adding info for No Bus:ptyy6
[    8.190094] PM: Adding info for No Bus:ptyy7
[    8.194335] PM: Adding info for No Bus:ptyy8
[    8.200114] PM: Adding info for No Bus:ptyy9
[    8.204332] PM: Adding info for No Bus:ptyya
[    8.210099] PM: Adding info for No Bus:ptyyb
[    8.214336] PM: Adding info for No Bus:ptyyc
[    8.218595] PM: Adding info for No Bus:ptyyd
[    8.220115] PM: Adding info for No Bus:ptyye
[    8.224323] PM: Adding info for No Bus:ptyyf
[    8.230105] PM: Adding info for No Bus:ptyz0
[    8.234342] PM: Adding info for No Bus:ptyz1
[    8.240117] PM: Adding info for No Bus:ptyz2
[    8.244335] PM: Adding info for No Bus:ptyz3
[    8.248585] PM: Adding info for No Bus:ptyz4
[    8.250107] PM: Adding info for No Bus:ptyz5
[    8.254332] PM: Adding info for No Bus:ptyz6
[    8.260124] PM: Adding info for No Bus:ptyz7
[    8.264341] PM: Adding info for No Bus:ptyz8
[    8.268581] PM: Adding info for No Bus:ptyz9
[    8.270106] PM: Adding info for No Bus:ptyza
[    8.274340] PM: Adding info for No Bus:ptyzb
[    8.280124] PM: Adding info for No Bus:ptyzc
[    8.284325] PM: Adding info for No Bus:ptyzd
[    8.290100] PM: Adding info for No Bus:ptyze
[    8.294344] PM: Adding info for No Bus:ptyzf
[    8.298589] PM: Adding info for No Bus:ptya0
[    8.300115] PM: Adding info for No Bus:ptya1
[    8.304338] PM: Adding info for No Bus:ptya2
[    8.310103] PM: Adding info for No Bus:ptya3
[    8.314344] PM: Adding info for No Bus:ptya4
[    8.320113] PM: Adding info for No Bus:ptya5
[    8.324333] PM: Adding info for No Bus:ptya6
[    8.328581] PM: Adding info for No Bus:ptya7
[    8.330099] PM: Adding info for No Bus:ptya8
[    8.334334] PM: Adding info for No Bus:ptya9
[    8.340129] PM: Adding info for No Bus:ptyaa
[    8.344334] PM: Adding info for No Bus:ptyab
[    8.350099] PM: Adding info for No Bus:ptyac
[    8.354336] PM: Adding info for No Bus:ptyad
[    8.358595] PM: Adding info for No Bus:ptyae
[    8.360111] PM: Adding info for No Bus:ptyaf
[    8.364333] PM: Adding info for No Bus:ptyb0
[    8.370104] PM: Adding info for No Bus:ptyb1
[    8.374336] PM: Adding info for No Bus:ptyb2
[    8.380125] PM: Adding info for No Bus:ptyb3
[    8.384337] PM: Adding info for No Bus:ptyb4
[    8.388586] PM: Adding info for No Bus:ptyb5
[    8.390111] PM: Adding info for No Bus:ptyb6
[    8.394342] PM: Adding info for No Bus:ptyb7
[    8.400123] PM: Adding info for No Bus:ptyb8
[    8.404337] PM: Adding info for No Bus:ptyb9
[    8.410010] PM: Adding info for No Bus:ptyba
[    8.414259] PM: Adding info for No Bus:ptybb
[    8.418493] PM: Adding info for No Bus:ptybc
[    8.420128] PM: Adding info for No Bus:ptybd
[    8.424337] PM: Adding info for No Bus:ptybe
[    8.430104] PM: Adding info for No Bus:ptybf
[    8.434340] PM: Adding info for No Bus:ptyc0
[    8.438612] PM: Adding info for No Bus:ptyc1
[    8.440122] PM: Adding info for No Bus:ptyc2
[    8.444327] PM: Adding info for No Bus:ptyc3
[    8.450105] PM: Adding info for No Bus:ptyc4
[    8.454346] PM: Adding info for No Bus:ptyc5
[    8.460118] PM: Adding info for No Bus:ptyc6
[    8.464337] PM: Adding info for No Bus:ptyc7
[    8.468581] PM: Adding info for No Bus:ptyc8
[    8.470099] PM: Adding info for No Bus:ptyc9
[    8.474339] PM: Adding info for No Bus:ptyca
[    8.480117] PM: Adding info for No Bus:ptycb
[    8.484336] PM: Adding info for No Bus:ptycc
[    8.490098] PM: Adding info for No Bus:ptycd
[    8.494340] PM: Adding info for No Bus:ptyce
[    8.498608] PM: Adding info for No Bus:ptycf
[    8.500126] PM: Adding info for No Bus:ptyd0
[    8.504335] PM: Adding info for No Bus:ptyd1
[    8.510106] PM: Adding info for No Bus:ptyd2
[    8.514340] PM: Adding info for No Bus:ptyd3
[    8.520113] PM: Adding info for No Bus:ptyd4
[    8.524338] PM: Adding info for No Bus:ptyd5
[    8.528588] PM: Adding info for No Bus:ptyd6
[    8.530101] PM: Adding info for No Bus:ptyd7
[    8.534357] PM: Adding info for No Bus:ptyd8
[    8.540125] PM: Adding info for No Bus:ptyd9
[    8.544346] PM: Adding info for No Bus:ptyda
[    8.550099] PM: Adding info for No Bus:ptydb
[    8.554338] PM: Adding info for No Bus:ptydc
[    8.558592] PM: Adding info for No Bus:ptydd
[    8.560114] PM: Adding info for No Bus:ptyde
[    8.564332] PM: Adding info for No Bus:ptydf
[    8.570106] PM: Adding info for No Bus:ptye0
[    8.574338] PM: Adding info for No Bus:ptye1
[    8.578589] PM: Adding info for No Bus:ptye2
[    8.580127] PM: Adding info for No Bus:ptye3
[    8.584334] PM: Adding info for No Bus:ptye4
[    8.590105] PM: Adding info for No Bus:ptye5
[    8.594351] PM: Adding info for No Bus:ptye6
[    8.600121] PM: Adding info for No Bus:ptye7
[    8.604342] PM: Adding info for No Bus:ptye8
[    8.608585] PM: Adding info for No Bus:ptye9
[    8.610103] PM: Adding info for No Bus:ptyea
[    8.614338] PM: Adding info for No Bus:ptyeb
[    8.620129] PM: Adding info for No Bus:ptyec
[    8.624337] PM: Adding info for No Bus:ptyed
[    8.630104] PM: Adding info for No Bus:ptyee
[    8.634350] PM: Adding info for No Bus:ptyef
[    8.638604] PM: Adding info for No Bus:ttyp0
[    8.640146] PM: Adding info for No Bus:ttyp1
[    8.644330] PM: Adding info for No Bus:ttyp2
[    8.650105] PM: Adding info for No Bus:ttyp3
[    8.654337] PM: Adding info for No Bus:ttyp4
[    8.660128] PM: Adding info for No Bus:ttyp5
[    8.664339] PM: Adding info for No Bus:ttyp6
[    8.668583] PM: Adding info for No Bus:ttyp7
[    8.670103] PM: Adding info for No Bus:ttyp8
[    8.674335] PM: Adding info for No Bus:ttyp9
[    8.680122] PM: Adding info for No Bus:ttypa
[    8.684362] PM: Adding info for No Bus:ttypb
[    8.690102] PM: Adding info for No Bus:ttypc
[    8.694351] PM: Adding info for No Bus:ttypd
[    8.698583] PM: Adding info for No Bus:ttype
[    8.700120] PM: Adding info for No Bus:ttypf
[    8.704335] PM: Adding info for No Bus:ttyq0
[    8.710103] PM: Adding info for No Bus:ttyq1
[    8.714339] PM: Adding info for No Bus:ttyq2
[    8.720045] PM: Adding info for No Bus:ttyq3
[    8.724247] PM: Adding info for No Bus:ttyq4
[    8.728493] PM: Adding info for No Bus:ttyq5
[    8.730105] PM: Adding info for No Bus:ttyq6
[    8.734336] PM: Adding info for No Bus:ttyq7
[    8.740128] PM: Adding info for No Bus:ttyq8
[    8.744336] PM: Adding info for No Bus:ttyq9
[    8.748594] PM: Adding info for No Bus:ttyqa
[    8.750105] PM: Adding info for No Bus:ttyqb
[    8.754340] PM: Adding info for No Bus:ttyqc
[    8.760116] PM: Adding info for No Bus:ttyqd
[    8.764333] PM: Adding info for No Bus:ttyqe
[    8.770100] PM: Adding info for No Bus:ttyqf
[    8.774343] PM: Adding info for No Bus:ttyr0
[    8.778594] PM: Adding info for No Bus:ttyr1
[    8.780122] PM: Adding info for No Bus:ttyr2
[    8.784333] PM: Adding info for No Bus:ttyr3
[    8.790115] PM: Adding info for No Bus:ttyr4
[    8.794340] PM: Adding info for No Bus:ttyr5
[    8.800125] PM: Adding info for No Bus:ttyr6
[    8.804339] PM: Adding info for No Bus:ttyr7
[    8.808584] PM: Adding info for No Bus:ttyr8
[    8.810103] PM: Adding info for No Bus:ttyr9
[    8.814343] PM: Adding info for No Bus:ttyra
[    8.820140] PM: Adding info for No Bus:ttyrb
[    8.824341] PM: Adding info for No Bus:ttyrc
[    8.830129] PM: Adding info for No Bus:ttyrd
[    8.834348] PM: Adding info for No Bus:ttyre
[    8.838599] PM: Adding info for No Bus:ttyrf
[    8.840119] PM: Adding info for No Bus:ttys0
[    8.844336] PM: Adding info for No Bus:ttys1
[    8.850101] PM: Adding info for No Bus:ttys2
[    8.854342] PM: Adding info for No Bus:ttys3
[    8.860123] PM: Adding info for No Bus:ttys4
[    8.864367] PM: Adding info for No Bus:ttys5
[    8.868585] PM: Adding info for No Bus:ttys6
[    8.870114] PM: Adding info for No Bus:ttys7
[    8.874337] PM: Adding info for No Bus:ttys8
[    8.880123] PM: Adding info for No Bus:ttys9
[    8.884335] PM: Adding info for No Bus:ttysa
[    8.888584] PM: Adding info for No Bus:ttysb
[    8.890137] PM: Adding info for No Bus:ttysc
[    8.894341] PM: Adding info for No Bus:ttysd
[    8.900126] PM: Adding info for No Bus:ttyse
[    8.904341] PM: Adding info for No Bus:ttysf
[    8.910103] PM: Adding info for No Bus:ttyt0
[    8.914344] PM: Adding info for No Bus:ttyt1
[    8.918596] PM: Adding info for No Bus:ttyt2
[    8.920116] PM: Adding info for No Bus:ttyt3
[    8.924336] PM: Adding info for No Bus:ttyt4
[    8.930104] PM: Adding info for No Bus:ttyt5
[    8.934341] PM: Adding info for No Bus:ttyt6
[    8.940130] PM: Adding info for No Bus:ttyt7
[    8.944340] PM: Adding info for No Bus:ttyt8
[    8.948592] PM: Adding info for No Bus:ttyt9
[    8.950108] PM: Adding info for No Bus:ttyta
[    8.954346] PM: Adding info for No Bus:ttytb
[    8.960131] PM: Adding info for No Bus:ttytc
[    8.964340] PM: Adding info for No Bus:ttytd
[    8.970102] PM: Adding info for No Bus:ttyte
[    8.974339] PM: Adding info for No Bus:ttytf
[    8.978600] PM: Adding info for No Bus:ttyu0
[    8.980124] PM: Adding info for No Bus:ttyu1
[    8.984344] PM: Adding info for No Bus:ttyu2
[    8.990115] PM: Adding info for No Bus:ttyu3
[    8.994349] PM: Adding info for No Bus:ttyu4
[    9.000171] PM: Adding info for No Bus:ttyu5
[    9.004348] PM: Adding info for No Bus:ttyu6
[    9.008609] PM: Adding info for No Bus:ttyu7
[    9.010105] PM: Adding info for No Bus:ttyu8
[    9.014352] PM: Adding info for No Bus:ttyu9
[    9.020123] PM: Adding info for No Bus:ttyua
[    9.024342] PM: Adding info for No Bus:ttyub
[    9.030034] PM: Adding info for No Bus:ttyuc
[    9.034276] PM: Adding info for No Bus:ttyud
[    9.038531] PM: Adding info for No Bus:ttyue
[    9.040124] PM: Adding info for No Bus:ttyuf
[    9.044338] PM: Adding info for No Bus:ttyv0
[    9.050104] PM: Adding info for No Bus:ttyv1
[    9.054344] PM: Adding info for No Bus:ttyv2
[    9.058629] PM: Adding info for No Bus:ttyv3
[    9.060123] PM: Adding info for No Bus:ttyv4
[    9.064342] PM: Adding info for No Bus:ttyv5
[    9.070111] PM: Adding info for No Bus:ttyv6
[    9.074353] PM: Adding info for No Bus:ttyv7
[    9.080129] PM: Adding info for No Bus:ttyv8
[    9.084340] PM: Adding info for No Bus:ttyv9
[    9.088635] PM: Adding info for No Bus:ttyva
[    9.090110] PM: Adding info for No Bus:ttyvb
[    9.094344] PM: Adding info for No Bus:ttyvc
[    9.100127] PM: Adding info for No Bus:ttyvd
[    9.104345] PM: Adding info for No Bus:ttyve
[    9.110118] PM: Adding info for No Bus:ttyvf
[    9.114348] PM: Adding info for No Bus:ttyw0
[    9.118594] PM: Adding info for No Bus:ttyw1
[    9.120129] PM: Adding info for No Bus:ttyw2
[    9.124339] PM: Adding info for No Bus:ttyw3
[    9.130114] PM: Adding info for No Bus:ttyw4
[    9.134349] PM: Adding info for No Bus:ttyw5
[    9.140129] PM: Adding info for No Bus:ttyw6
[    9.144380] PM: Adding info for No Bus:ttyw7
[    9.148597] PM: Adding info for No Bus:ttyw8
[    9.150111] PM: Adding info for No Bus:ttyw9
[    9.154355] PM: Adding info for No Bus:ttywa
[    9.160129] PM: Adding info for No Bus:ttywb
[    9.164341] PM: Adding info for No Bus:ttywc
[    9.170145] PM: Adding info for No Bus:ttywd
[    9.174347] PM: Adding info for No Bus:ttywe
[    9.178591] PM: Adding info for No Bus:ttywf
[    9.180134] PM: Adding info for No Bus:ttyx0
[    9.184345] PM: Adding info for No Bus:ttyx1
[    9.190112] PM: Adding info for No Bus:ttyx2
[    9.194344] PM: Adding info for No Bus:ttyx3
[    9.198631] PM: Adding info for No Bus:ttyx4
[    9.200130] PM: Adding info for No Bus:ttyx5
[    9.204341] PM: Adding info for No Bus:ttyx6
[    9.210106] PM: Adding info for No Bus:ttyx7
[    9.214347] PM: Adding info for No Bus:ttyx8
[    9.220125] PM: Adding info for No Bus:ttyx9
[    9.224337] PM: Adding info for No Bus:ttyxa
[    9.228589] PM: Adding info for No Bus:ttyxb
[    9.230108] PM: Adding info for No Bus:ttyxc
[    9.234348] PM: Adding info for No Bus:ttyxd
[    9.240133] PM: Adding info for No Bus:ttyxe
[    9.244343] PM: Adding info for No Bus:ttyxf
[    9.250109] PM: Adding info for No Bus:ttyy0
[    9.254389] PM: Adding info for No Bus:ttyy1
[    9.258597] PM: Adding info for No Bus:ttyy2
[    9.260120] PM: Adding info for No Bus:ttyy3
[    9.264336] PM: Adding info for No Bus:ttyy4
[    9.270108] PM: Adding info for No Bus:ttyy5
[    9.274348] PM: Adding info for No Bus:ttyy6
[    9.280136] PM: Adding info for No Bus:ttyy7
[    9.284350] PM: Adding info for No Bus:ttyy8
[    9.288601] PM: Adding info for No Bus:ttyy9
[    9.290109] PM: Adding info for No Bus:ttyya
[    9.294350] PM: Adding info for No Bus:ttyyb
[    9.300124] PM: Adding info for No Bus:ttyyc
[    9.304345] PM: Adding info for No Bus:ttyyd
[    9.310105] PM: Adding info for No Bus:ttyye
[    9.314344] PM: Adding info for No Bus:ttyyf
[    9.318602] PM: Adding info for No Bus:ttyz0
[    9.320132] PM: Adding info for No Bus:ttyz1
[    9.324342] PM: Adding info for No Bus:ttyz2
[    9.330121] PM: Adding info for No Bus:ttyz3
[    9.334394] PM: Adding info for No Bus:ttyz4
[    9.340067] PM: Adding info for No Bus:ttyz5
[    9.344270] PM: Adding info for No Bus:ttyz6
[    9.348518] PM: Adding info for No Bus:ttyz7
[    9.350103] PM: Adding info for No Bus:ttyz8
[    9.354342] PM: Adding info for No Bus:ttyz9
[    9.360137] PM: Adding info for No Bus:ttyza
[    9.364349] PM: Adding info for No Bus:ttyzb
[    9.368600] PM: Adding info for No Bus:ttyzc
[    9.370116] PM: Adding info for No Bus:ttyzd
[    9.374349] PM: Adding info for No Bus:ttyze
[    9.380123] PM: Adding info for No Bus:ttyzf
[    9.384339] PM: Adding info for No Bus:ttya0
[    9.390115] PM: Adding info for No Bus:ttya1
[    9.394349] PM: Adding info for No Bus:ttya2
[    9.398596] PM: Adding info for No Bus:ttya3
[    9.400131] PM: Adding info for No Bus:ttya4
[    9.404354] PM: Adding info for No Bus:ttya5
[    9.410121] PM: Adding info for No Bus:ttya6
[    9.414349] PM: Adding info for No Bus:ttya7
[    9.420133] PM: Adding info for No Bus:ttya8
[    9.424342] PM: Adding info for No Bus:ttya9
[    9.428600] PM: Adding info for No Bus:ttyaa
[    9.430113] PM: Adding info for No Bus:ttyab
[    9.434350] PM: Adding info for No Bus:ttyac
[    9.440126] PM: Adding info for No Bus:ttyad
[    9.444336] PM: Adding info for No Bus:ttyae
[    9.450117] PM: Adding info for No Bus:ttyaf
[    9.454345] PM: Adding info for No Bus:ttyb0
[    9.458600] PM: Adding info for No Bus:ttyb1
[    9.460130] PM: Adding info for No Bus:ttyb2
[    9.464345] PM: Adding info for No Bus:ttyb3
[    9.470116] PM: Adding info for No Bus:ttyb4
[    9.474352] PM: Adding info for No Bus:ttyb5
[    9.480132] PM: Adding info for No Bus:ttyb6
[    9.484345] PM: Adding info for No Bus:ttyb7
[    9.488593] PM: Adding info for No Bus:ttyb8
[    9.490177] PM: Adding info for No Bus:ttyb9
[    9.494381] PM: Adding info for No Bus:ttyba
[    9.500192] PM: Adding info for No Bus:ttybb
[    9.504392] PM: Adding info for No Bus:ttybc
[    9.508643] PM: Adding info for No Bus:ttybd
[    9.510119] PM: Adding info for No Bus:ttybe
[    9.514355] PM: Adding info for No Bus:ttybf
[    9.520153] PM: Adding info for No Bus:ttyc0
[    9.524355] PM: Adding info for No Bus:ttyc1
[    9.530117] PM: Adding info for No Bus:ttyc2
[    9.534407] PM: Adding info for No Bus:ttyc3
[    9.538613] PM: Adding info for No Bus:ttyc4
[    9.540192] PM: Adding info for No Bus:ttyc5
[    9.544390] PM: Adding info for No Bus:ttyc6
[    9.550110] PM: Adding info for No Bus:ttyc7
[    9.554346] PM: Adding info for No Bus:ttyc8
[    9.560136] PM: Adding info for No Bus:ttyc9
[    9.564350] PM: Adding info for No Bus:ttyca
[    9.568595] PM: Adding info for No Bus:ttycb
[    9.570113] PM: Adding info for No Bus:ttycc
[    9.574410] PM: Adding info for No Bus:ttycd
[    9.580130] PM: Adding info for No Bus:ttyce
[    9.584410] PM: Adding info for No Bus:ttycf
[    9.590115] PM: Adding info for No Bus:ttyd0
[    9.594355] PM: Adding info for No Bus:ttyd1
[    9.598604] PM: Adding info for No Bus:ttyd2
[    9.600131] PM: Adding info for No Bus:ttyd3
[    9.604344] PM: Adding info for No Bus:ttyd4
[    9.610173] PM: Adding info for No Bus:ttyd5
[    9.614376] PM: Adding info for No Bus:ttyd6
[    9.620139] PM: Adding info for No Bus:ttyd7
[    9.624413] PM: Adding info for No Bus:ttyd8
[    9.628613] PM: Adding info for No Bus:ttyd9
[    9.630119] PM: Adding info for No Bus:ttyda
[    9.634344] PM: Adding info for No Bus:ttydb
[    9.640141] PM: Adding info for No Bus:ttydc
[    9.644349] PM: Adding info for No Bus:ttydd
[    9.650113] PM: Adding info for No Bus:ttyde
[    9.654410] PM: Adding info for No Bus:ttydf
[    9.658623] PM: Adding info for No Bus:ttye0
[    9.660134] PM: Adding info for No Bus:ttye1
[    9.664350] PM: Adding info for No Bus:ttye2
[    9.670121] PM: Adding info for No Bus:ttye3
[    9.674353] PM: Adding info for No Bus:ttye4
[    9.680074] PM: Adding info for No Bus:ttye5
[    9.684265] PM: Adding info for No Bus:ttye6
[    9.688517] PM: Adding info for No Bus:ttye7
[    9.690112] PM: Adding info for No Bus:ttye8
[    9.694350] PM: Adding info for No Bus:ttye9
[    9.700138] PM: Adding info for No Bus:ttyea
[    9.704350] PM: Adding info for No Bus:ttyeb
[    9.708600] PM: Adding info for No Bus:ttyec
[    9.710117] PM: Adding info for No Bus:ttyed
[    9.714414] PM: Adding info for No Bus:ttyee
[    9.720138] PM: Adding info for No Bus:ttyef
[    9.724349] initcall 0xc0a7ae98: pty_init+0x0/0x397() returned 0.
[    9.731211] initcall 0xc0a7ae98 ran for 2073 msecs: pty_init+0x0/0x397()
[    9.737884] Calling initcall 0xc0a7b746: cy_init+0x0/0xea()
[    9.741905] Cyclades driver 2.5 (built Feb  2 2008 11:31:55)
[    9.750118] initcall 0xc0a7b746: cy_init+0x0/0xea() returned 0.
[    9.755890] initcall 0xc0a7b746 ran for 5 msecs: cy_init+0x0/0xea()
[    9.761731] Calling initcall 0xc0a7b830: nozomi_init+0x0/0xfb()
[    9.767624] Initializing Nozomi driver 2.1d (build date: Feb  2 2008 11:31:55)
[    9.770117] initcall 0xc0a7b830: nozomi_init+0x0/0xfb() returned 0.
[    9.781210] initcall 0xc0a7b830 ran for 6 msecs: nozomi_init+0x0/0xfb()
[    9.787796] Calling initcall 0xc0a7b92b: epca_module_init+0x0/0x410()
[    9.792773] DIGI epca driver version 1.3.0.1-LK2.6 loaded.
[    9.800157] PM: Adding info for No Bus:ttyD0
[    9.804362] PM: Adding info for No Bus:ttyD1
[    9.808611] PM: Adding info for No Bus:ttyD2
[    9.810118] PM: Adding info for No Bus:ttyD3
[    9.814351] PM: Adding info for No Bus:ttyD4
[    9.820128] PM: Adding info for No Bus:ttyD5
[    9.824363] PM: Adding info for No Bus:ttyD6
[    9.830191] PM: Adding info for No Bus:ttyD7
[    9.834407] PM: Adding info for No Bus:ttyD8
[    9.838648] PM: Adding info for No Bus:ttyD9
[    9.840139] PM: Adding info for No Bus:ttyD10
[    9.844438] PM: Adding info for No Bus:ttyD11
[    9.850121] PM: Adding info for No Bus:ttyD12
[    9.854444] PM: Adding info for No Bus:ttyD13
[    9.860144] PM: Adding info for No Bus:ttyD14
[    9.864439] PM: Adding info for No Bus:ttyD15
[    9.868779] PM: Adding info for No Bus:ttyD16
[    9.870124] PM: Adding info for No Bus:ttyD17
[    9.874443] PM: Adding info for No Bus:ttyD18
[    9.880139] PM: Adding info for No Bus:ttyD19
[    9.884444] PM: Adding info for No Bus:ttyD20
[    9.890128] PM: Adding info for No Bus:ttyD21
[    9.894446] PM: Adding info for No Bus:ttyD22
[    9.898779] PM: Adding info for No Bus:ttyD23
[    9.900141] PM: Adding info for No Bus:ttyD24
[    9.904438] PM: Adding info for No Bus:ttyD25
[    9.910129] PM: Adding info for No Bus:ttyD26
[    9.914449] PM: Adding info for No Bus:ttyD27
[    9.920145] PM: Adding info for No Bus:ttyD28
[    9.924443] PM: Adding info for No Bus:ttyD29
[    9.928780] PM: Adding info for No Bus:ttyD30
[    9.930121] PM: Adding info for No Bus:ttyD31
[    9.934444] PM: Adding info for No Bus:ttyD32
[    9.940146] PM: Adding info for No Bus:ttyD33
[    9.944441] PM: Adding info for No Bus:ttyD34
[    9.950134] PM: Adding info for No Bus:ttyD35
[    9.954449] PM: Adding info for No Bus:ttyD36
[    9.960144] PM: Adding info for No Bus:ttyD37
[    9.964449] PM: Adding info for No Bus:ttyD38
[    9.968778] PM: Adding info for No Bus:ttyD39
[    9.970122] PM: Adding info for No Bus:ttyD40
[    9.974439] PM: Adding info for No Bus:ttyD41
[    9.980148] PM: Adding info for No Bus:ttyD42
[    9.984443] PM: Adding info for No Bus:ttyD43
[    9.990197] PM: Adding info for No Bus:ttyD44
[    9.994494] PM: Adding info for No Bus:ttyD45
[    9.998820] PM: Adding info for No Bus:ttyD46
[   10.000138] PM: Adding info for No Bus:ttyD47
[   10.004444] PM: Adding info for No Bus:ttyD48
[   10.010134] PM: Adding info for No Bus:ttyD49
[   10.014448] PM: Adding info for No Bus:ttyD50
[   10.020143] PM: Adding info for No Bus:ttyD51
[   10.024445] PM: Adding info for No Bus:ttyD52
[   10.028849] PM: Adding info for No Bus:ttyD53
[   10.030126] PM: Adding info for No Bus:ttyD54
[   10.034446] PM: Adding info for No Bus:ttyD55
[   10.040152] PM: Adding info for No Bus:ttyD56
[   10.044449] PM: Adding info for No Bus:ttyD57
[   10.050124] PM: Adding info for No Bus:ttyD58
[   10.054446] PM: Adding info for No Bus:ttyD59
[   10.058779] PM: Adding info for No Bus:ttyD60
[   10.060149] PM: Adding info for No Bus:ttyD61
[   10.064448] PM: Adding info for No Bus:ttyD62
[   10.070131] PM: Adding info for No Bus:ttyD63
[   10.074448] PM: Adding info for No Bus:ttyD64
[   10.080142] PM: Adding info for No Bus:ttyD65
[   10.084448] PM: Adding info for No Bus:ttyD66
[   10.090129] PM: Adding info for No Bus:ttyD67
[   10.094448] PM: Adding info for No Bus:ttyD68
[   10.098779] PM: Adding info for No Bus:ttyD69
[   10.100143] PM: Adding info for No Bus:ttyD70
[   10.104444] PM: Adding info for No Bus:ttyD71
[   10.110133] PM: Adding info for No Bus:ttyD72
[   10.114451] PM: Adding info for No Bus:ttyD73
[   10.120141] PM: Adding info for No Bus:ttyD74
[   10.124440] PM: Adding info for No Bus:ttyD75
[   10.128863] PM: Adding info for No Bus:ttyD76
[   10.130127] PM: Adding info for No Bus:ttyD77
[   10.134441] PM: Adding info for No Bus:ttyD78
[   10.140147] PM: Adding info for No Bus:ttyD79
[   10.144451] PM: Adding info for No Bus:ttyD80
[   10.150126] PM: Adding info for No Bus:ttyD81
[   10.154447] PM: Adding info for No Bus:ttyD82
[   10.158781] PM: Adding info for No Bus:ttyD83
[   10.160142] PM: Adding info for No Bus:ttyD84
[   10.164444] PM: Adding info for No Bus:ttyD85
[   10.170124] PM: Adding info for No Bus:ttyD86
[   10.174447] PM: Adding info for No Bus:ttyD87
[   10.180161] PM: Adding info for No Bus:ttyD88
[   10.184455] PM: Adding info for No Bus:ttyD89
[   10.188789] PM: Adding info for No Bus:ttyD90
[   10.190129] PM: Adding info for No Bus:ttyD91
[   10.194449] PM: Adding info for No Bus:ttyD92
[   10.200137] PM: Adding info for No Bus:ttyD93
[   10.204441] PM: Adding info for No Bus:ttyD94
[   10.210122] PM: Adding info for No Bus:ttyD95
[   10.214449] PM: Adding info for No Bus:ttyD96
[   10.220146] PM: Adding info for No Bus:ttyD97
[   10.224444] PM: Adding info for No Bus:ttyD98
[   10.228781] PM: Adding info for No Bus:ttyD99
[   10.230218] PM: Adding info for No Bus:ttyD100
[   10.234610] PM: Adding info for No Bus:ttyD101
[   10.240136] PM: Adding info for No Bus:ttyD102
[   10.244528] PM: Adding info for No Bus:ttyD103
[   10.250122] PM: Adding info for No Bus:ttyD104
[   10.254534] PM: Adding info for No Bus:ttyD105
[   10.258953] PM: Adding info for No Bus:ttyD106
[   10.260146] PM: Adding info for No Bus:ttyD107
[   10.264534] PM: Adding info for No Bus:ttyD108
[   10.270128] PM: Adding info for No Bus:ttyD109
[   10.274543] PM: Adding info for No Bus:ttyD110
[   10.280137] PM: Adding info for No Bus:ttyD111
[   10.284535] PM: Adding info for No Bus:ttyD112
[   10.290121] PM: Adding info for No Bus:ttyD113
[   10.294534] PM: Adding info for No Bus:ttyD114
[   10.298974] PM: Adding info for No Bus:ttyD115
[   10.300142] PM: Adding info for No Bus:ttyD116
[   10.304534] PM: Adding info for No Bus:ttyD117
[   10.310128] PM: Adding info for No Bus:ttyD118
[   10.314545] PM: Adding info for No Bus:ttyD119
[   10.320138] PM: Adding info for No Bus:ttyD120
[   10.324536] PM: Adding info for No Bus:ttyD121
[   10.330125] PM: Adding info for No Bus:ttyD122
[   10.334535] PM: Adding info for No Bus:ttyD123
[   10.338957] PM: Adding info for No Bus:ttyD124
[   10.340142] PM: Adding info for No Bus:ttyD125
[   10.344536] PM: Adding info for No Bus:ttyD126
[   10.350131] PM: Adding info for No Bus:ttyD127
[   10.354537] PM: Adding info for No Bus:ttyD128
[   10.360152] PM: Adding info for No Bus:ttyD129
[   10.364536] PM: Adding info for No Bus:ttyD130
[   10.370127] PM: Adding info for No Bus:ttyD131
[   10.374539] PM: Adding info for No Bus:ttyD132
[   10.378966] PM: Adding info for No Bus:ttyD133
[   10.380132] PM: Adding info for No Bus:ttyD134
[   10.384534] PM: Adding info for No Bus:ttyD135
[   10.390134] PM: Adding info for No Bus:ttyD136
[   10.394533] PM: Adding info for No Bus:ttyD137
[   10.400156] PM: Adding info for No Bus:ttyD138
[   10.404545] PM: Adding info for No Bus:ttyD139
[   10.410125] PM: Adding info for No Bus:ttyD140
[   10.414538] PM: Adding info for No Bus:ttyD141
[   10.418961] PM: Adding info for No Bus:ttyD142
[   10.420144] PM: Adding info for No Bus:ttyD143
[   10.424536] PM: Adding info for No Bus:ttyD144
[   10.430131] PM: Adding info for No Bus:ttyD145
[   10.434542] PM: Adding info for No Bus:ttyD146
[   10.440149] PM: Adding info for No Bus:ttyD147
[   10.444538] PM: Adding info for No Bus:ttyD148
[   10.448957] PM: Adding info for No Bus:ttyD149
[   10.450128] PM: Adding info for No Bus:ttyD150
[   10.454538] PM: Adding info for No Bus:ttyD151
[   10.460153] PM: Adding info for No Bus:ttyD152
[   10.464537] PM: Adding info for No Bus:ttyD153
[   10.470132] PM: Adding info for No Bus:ttyD154
[   10.474547] PM: Adding info for No Bus:ttyD155
[   10.480142] PM: Adding info for No Bus:ttyD156
[   10.484538] PM: Adding info for No Bus:ttyD157
[   10.488956] PM: Adding info for No Bus:ttyD158
[   10.490127] PM: Adding info for No Bus:ttyD159
[   10.494541] PM: Adding info for No Bus:ttyD160
[   10.500153] PM: Adding info for No Bus:ttyD161
[   10.504539] PM: Adding info for No Bus:ttyD162
[   10.510136] PM: Adding info for No Bus:ttyD163
[   10.514547] PM: Adding info for No Bus:ttyD164
[   10.520145] PM: Adding info for No Bus:ttyD165
[   10.524535] PM: Adding info for No Bus:ttyD166
[   10.528962] PM: Adding info for No Bus:ttyD167
[   10.530130] PM: Adding info for No Bus:ttyD168
[   10.534541] PM: Adding info for No Bus:ttyD169
[   10.540154] PM: Adding info for No Bus:ttyD170
[   10.544539] PM: Adding info for No Bus:ttyD171
[   10.550131] PM: Adding info for No Bus:ttyD172
[   10.554545] PM: Adding info for No Bus:ttyD173
[   10.560143] PM: Adding info for No Bus:ttyD174
[   10.564531] PM: Adding info for No Bus:ttyD175
[   10.568962] PM: Adding info for No Bus:ttyD176
[   10.570127] PM: Adding info for No Bus:ttyD177
[   10.574547] PM: Adding info for No Bus:ttyD178
[   10.580146] PM: Adding info for No Bus:ttyD179
[   10.584542] PM: Adding info for No Bus:ttyD180
[   10.590132] PM: Adding info for No Bus:ttyD181
[   10.594547] PM: Adding info for No Bus:ttyD182
[   10.600143] PM: Adding info for No Bus:ttyD183
[   10.604656] PM: Adding info for No Bus:ttyD184
[   10.609049] PM: Adding info for No Bus:ttyD185
[   10.610130] PM: Adding info for No Bus:ttyD186
[   10.614539] PM: Adding info for No Bus:ttyD187
[   10.620160] PM: Adding info for No Bus:ttyD188
[   10.624550] PM: Adding info for No Bus:ttyD189
[   10.630139] PM: Adding info for No Bus:ttyD190
[   10.634550] PM: Adding info for No Bus:ttyD191
[   10.640116] PM: Adding info for No Bus:ttyD192
[   10.644498] PM: Adding info for No Bus:ttyD193
[   10.648924] PM: Adding info for No Bus:ttyD194
[   10.650129] PM: Adding info for No Bus:ttyD195
[   10.654654] PM: Adding info for No Bus:ttyD196
[   10.660152] PM: Adding info for No Bus:ttyD197
[   10.664551] PM: Adding info for No Bus:ttyD198
[   10.670133] PM: Adding info for No Bus:ttyD199
[   10.674548] PM: Adding info for No Bus:ttyD200
[   10.678971] PM: Adding info for No Bus:ttyD201
[   10.680154] PM: Adding info for No Bus:ttyD202
[   10.684541] PM: Adding info for No Bus:ttyD203
[   10.690136] PM: Adding info for No Bus:ttyD204
[   10.694654] PM: Adding info for No Bus:ttyD205
[   10.700165] PM: Adding info for No Bus:ttyD206
[   10.704562] PM: Adding info for No Bus:ttyD207
[   10.710142] PM: Adding info for No Bus:ttyD208
[   10.714540] PM: Adding info for No Bus:ttyD209
[   10.718970] PM: Adding info for No Bus:ttyD210
[   10.720146] PM: Adding info for No Bus:ttyD211
[   10.724540] PM: Adding info for No Bus:ttyD212
[   10.730136] PM: Adding info for No Bus:ttyD213
[   10.734656] PM: Adding info for No Bus:ttyD214
[   10.740156] PM: Adding info for No Bus:ttyD215
[   10.744561] PM: Adding info for No Bus:ttyD216
[   10.750134] PM: Adding info for No Bus:ttyD217
[   10.754550] PM: Adding info for No Bus:ttyD218
[   10.758974] PM: Adding info for No Bus:ttyD219
[   10.760154] PM: Adding info for No Bus:ttyD220
[   10.764551] PM: Adding info for No Bus:ttyD221
[   10.770250] PM: Adding info for No Bus:ttyD222
[   10.774661] PM: Adding info for No Bus:ttyD223
[   10.780166] PM: Adding info for No Bus:ttyD224
[   10.784555] PM: Adding info for No Bus:ttyD225
[   10.790142] PM: Adding info for No Bus:ttyD226
[   10.794553] PM: Adding info for No Bus:ttyD227
[   10.798976] PM: Adding info for No Bus:ttyD228
[   10.800156] PM: Adding info for No Bus:ttyD229
[   10.804552] PM: Adding info for No Bus:ttyD230
[   10.810256] PM: Adding info for No Bus:ttyD231
[   10.814659] PM: Adding info for No Bus:ttyD232
[   10.820167] PM: Adding info for No Bus:ttyD233
[   10.824566] PM: Adding info for No Bus:ttyD234
[   10.830144] PM: Adding info for No Bus:ttyD235
[   10.834553] PM: Adding info for No Bus:ttyD236
[   10.838976] PM: Adding info for No Bus:ttyD237
[   10.840159] PM: Adding info for No Bus:ttyD238
[   10.844662] PM: Adding info for No Bus:ttyD239
[   10.850155] PM: Adding info for No Bus:ttyD240
[   10.854566] PM: Adding info for No Bus:ttyD241
[   10.860168] PM: Adding info for No Bus:ttyD242
[   10.864566] PM: Adding info for No Bus:ttyD243
[   10.870143] PM: Adding info for No Bus:ttyD244
[   10.874557] PM: Adding info for No Bus:ttyD245
[   10.878976] PM: Adding info for No Bus:ttyD246
[   10.880157] PM: Adding info for No Bus:ttyD247
[   10.884554] PM: Adding info for No Bus:ttyD248
[   10.890256] PM: Adding info for No Bus:ttyD249
[   10.894649] PM: Adding info for No Bus:ttyD250
[   10.900165] PM: Adding info for No Bus:ttyD251
[   10.904563] PM: Adding info for No Bus:ttyD252
[   10.910151] PM: Adding info for No Bus:ttyD253
[   10.914559] PM: Adding info for No Bus:ttyD254
[   10.918980] PM: Adding info for No Bus:ttyD255
[   10.920164] PM: Adding info for No Bus:digi_ctl0
[   10.924730] PM: Adding info for No Bus:digi_ctl1
[   10.930253] PM: Adding info for No Bus:digi_ctl2
[   10.934831] PM: Adding info for No Bus:digi_ctl3
[   10.940159] PM: Adding info for No Bus:digi_ctl4
[   10.944722] PM: Adding info for No Bus:digi_ctl5
[   10.950135] PM: Adding info for No Bus:digi_ctl6
[   10.954731] PM: Adding info for No Bus:digi_ctl7
[   10.960142] PM: Adding info for No Bus:digi_ctl8
[   10.964722] PM: Adding info for No Bus:digi_ctl9
[   10.969417] PM: Adding info for No Bus:digi_ctl10
[   10.970144] PM: Adding info for No Bus:digi_ctl11
[   10.974814] PM: Adding info for No Bus:digi_ctl12
[   10.980159] PM: Adding info for No Bus:digi_ctl13
[   10.984810] PM: Adding info for No Bus:digi_ctl14
[   10.990239] PM: Adding info for No Bus:digi_ctl15
[   10.994905] PM: Adding info for No Bus:digi_ctl16
[   11.000153] PM: Adding info for No Bus:digi_ctl17
[   11.004808] PM: Adding info for No Bus:digi_ctl18
[   11.010235] PM: Adding info for No Bus:digi_ctl19
[   11.014896] PM: Adding info for No Bus:digi_ctl20
[   11.020156] PM: Adding info for No Bus:digi_ctl21
[   11.024810] PM: Adding info for No Bus:digi_ctl22
[   11.030136] PM: Adding info for No Bus:digi_ctl23
[   11.034822] PM: Adding info for No Bus:digi_ctl24
[   11.040156] PM: Adding info for No Bus:digi_ctl25
[   11.044821] PM: Adding info for No Bus:digi_ctl26
[   11.049492] PM: Adding info for No Bus:digi_ctl27
[   11.050140] PM: Adding info for No Bus:digi_ctl28
[   11.054919] PM: Adding info for No Bus:digi_ctl29
[   11.060157] PM: Adding info for No Bus:digi_ctl30
[   11.064915] PM: Adding info for No Bus:digi_ctl31
[   11.070138] PM: Adding info for No Bus:digi_ctl32
[   11.074816] PM: Adding info for No Bus:digi_ctl33
[   11.080155] PM: Adding info for No Bus:digi_ctl34
[   11.084817] PM: Adding info for No Bus:digi_ctl35
[   11.090248] PM: Adding info for No Bus:digi_ctl36
[   11.094916] PM: Adding info for No Bus:digi_ctl37
[   11.100158] PM: Adding info for No Bus:digi_ctl38
[   11.104815] PM: Adding info for No Bus:digi_ctl39
[   11.110138] PM: Adding info for No Bus:digi_ctl40
[   11.114810] PM: Adding info for No Bus:digi_ctl41
[   11.120161] PM: Adding info for No Bus:digi_ctl42
[   11.124821] PM: Adding info for No Bus:digi_ctl43
[   11.129504] PM: Adding info for No Bus:digi_ctl44
[   11.130148] PM: Adding info for No Bus:digi_ctl45
[   11.134820] PM: Adding info for No Bus:digi_ctl46
[   11.140171] PM: Adding info for No Bus:digi_ctl47
[   11.144839] PM: Adding info for No Bus:digi_ctl48
[   11.150151] PM: Adding info for No Bus:digi_ctl49
[   11.154819] PM: Adding info for No Bus:digi_ctl50
[   11.160284] PM: Adding info for No Bus:digi_ctl51
[   11.164964] PM: Adding info for No Bus:digi_ctl52
[   11.170153] PM: Adding info for No Bus:digi_ctl53
[   11.174816] PM: Adding info for No Bus:digi_ctl54
[   11.180270] PM: Adding info for No Bus:digi_ctl55
[   11.184948] PM: Adding info for No Bus:digi_ctl56
[   11.190150] PM: Adding info for No Bus:digi_ctl57
[   11.194818] PM: Adding info for No Bus:digi_ctl58
[   11.200038] PM: Adding info for No Bus:digi_ctl59
[   11.204700] PM: Adding info for No Bus:digi_ctl60
[   11.209484] PM: Adding info for No Bus:digi_ctl61
[   11.210153] PM: Adding info for No Bus:digi_ctl62
[   11.214822] PM: Adding info for No Bus:digi_ctl63
[   11.220284] PM: Adding info for No Bus:digi_ctl64
[   11.224953] PM: Adding info for No Bus:digi_ctl65
[   11.230151] PM: Adding info for No Bus:digi_ctl66
[   11.234820] PM: Adding info for No Bus:digi_ctl67
[   11.240168] PM: Adding info for No Bus:digi_ctl68
[   11.244941] PM: Adding info for No Bus:digi_ctl69
[   11.250157] PM: Adding info for No Bus:digi_ctl70
[   11.254830] PM: Adding info for No Bus:digi_ctl71
[   11.260274] PM: Adding info for No Bus:digi_ctl72
[   11.264946] PM: Adding info for No Bus:digi_ctl73
[   11.270151] PM: Adding info for No Bus:digi_ctl74
[   11.274819] PM: Adding info for No Bus:digi_ctl75
[   11.280076] PM: Adding info for No Bus:digi_ctl76
[   11.284740] PM: Adding info for No Bus:digi_ctl77
[   11.289419] PM: Adding info for No Bus:digi_ctl78
[   11.290147] PM: Adding info for No Bus:digi_ctl79
[   11.294935] PM: Adding info for No Bus:digi_ctl80
[   11.300172] PM: Adding info for No Bus:digi_ctl81
[   11.304842] PM: Adding info for No Bus:digi_ctl82
[   11.310263] PM: Adding info for No Bus:digi_ctl83
[   11.314939] PM: Adding info for No Bus:digi_ctl84
[   11.320169] PM: Adding info for No Bus:digi_ctl85
[   11.324831] PM: Adding info for No Bus:digi_ctl86
[   11.330147] PM: Adding info for No Bus:digi_ctl87
[   11.334815] PM: Adding info for No Bus:digi_ctl88
[   11.340167] PM: Adding info for No Bus:digi_ctl89
[   11.344835] PM: Adding info for No Bus:digi_ctl90
[   11.350149] PM: Adding info for No Bus:digi_ctl91
[   11.354830] PM: Adding info for No Bus:digi_ctl92
[   11.359505] PM: Adding info for No Bus:digi_ctl93
[   11.360163] PM: Adding info for No Bus:digi_ctl94
[   11.364833] PM: Adding info for No Bus:digi_ctl95
[   11.370154] PM: Adding info for No Bus:digi_ctl96
[   11.374821] PM: Adding info for No Bus:digi_ctl97
[   11.380171] PM: Adding info for No Bus:digi_ctl98
[   11.384843] PM: Adding info for No Bus:digi_ctl99
[   11.390277] PM: Adding info for No Bus:digi_ctl100
[   11.395038] PM: Adding info for No Bus:digi_ctl101
[   11.400170] PM: Adding info for No Bus:digi_ctl102
[   11.404924] PM: Adding info for No Bus:digi_ctl103
[   11.410149] PM: Adding info for No Bus:digi_ctl104
[   11.414906] PM: Adding info for No Bus:digi_ctl105
[   11.420169] PM: Adding info for No Bus:digi_ctl106
[   11.424924] PM: Adding info for No Bus:digi_ctl107
[   11.430160] PM: Adding info for No Bus:digi_ctl108
[   11.434919] PM: Adding info for No Bus:digi_ctl109
[   11.440163] PM: Adding info for No Bus:digi_ctl110
[   11.444919] PM: Adding info for No Bus:digi_ctl111
[   11.450105] PM: Adding info for No Bus:digi_ctl112
[   11.454866] PM: Adding info for No Bus:digi_ctl113
[   11.459632] PM: Adding info for No Bus:digi_ctl114
[   11.460171] PM: Adding info for No Bus:digi_ctl115
[   11.464922] PM: Adding info for No Bus:digi_ctl116
[   11.470168] PM: Adding info for No Bus:digi_ctl117
[   11.474934] PM: Adding info for No Bus:digi_ctl118
[   11.480179] PM: Adding info for No Bus:digi_ctl119
[   11.484935] PM: Adding info for No Bus:digi_ctl120
[   11.490152] PM: Adding info for No Bus:digi_ctl121
[   11.494919] PM: Adding info for No Bus:digi_ctl122
[   11.500174] PM: Adding info for No Bus:digi_ctl123
[   11.504938] PM: Adding info for No Bus:digi_ctl124
[   11.510165] PM: Adding info for No Bus:digi_ctl125
[   11.514933] PM: Adding info for No Bus:digi_ctl126
[   11.520174] PM: Adding info for No Bus:digi_ctl127
[   11.524935] PM: Adding info for No Bus:digi_ctl128
[   11.530163] PM: Adding info for No Bus:digi_ctl129
[   11.534928] PM: Adding info for No Bus:digi_ctl130
[   11.540170] PM: Adding info for No Bus:digi_ctl131
[   11.544926] PM: Adding info for No Bus:digi_ctl132
[   11.550159] PM: Adding info for No Bus:digi_ctl133
[   11.554930] PM: Adding info for No Bus:digi_ctl134
[   11.559703] PM: Adding info for No Bus:digi_ctl135
[   11.560173] PM: Adding info for No Bus:digi_ctl136
[   11.564939] PM: Adding info for No Bus:digi_ctl137
[   11.570168] PM: Adding info for No Bus:digi_ctl138
[   11.574934] PM: Adding info for No Bus:digi_ctl139
[   11.580177] PM: Adding info for No Bus:digi_ctl140
[   11.584934] PM: Adding info for No Bus:digi_ctl141
[   11.590160] PM: Adding info for No Bus:digi_ctl142
[   11.594932] PM: Adding info for No Bus:digi_ctl143
[   11.600177] PM: Adding info for No Bus:digi_ctl144
[   11.604946] PM: Adding info for No Bus:digi_ctl145
[   11.610163] PM: Adding info for No Bus:digi_ctl146
[   11.614939] PM: Adding info for No Bus:digi_ctl147
[   11.620172] PM: Adding info for No Bus:digi_ctl148
[   11.624937] PM: Adding info for No Bus:digi_ctl149
[   11.630157] PM: Adding info for No Bus:digi_ctl150
[   11.635067] PM: Adding info for No Bus:digi_ctl151
[   11.640175] PM: Adding info for No Bus:digi_ctl152
[   11.644939] PM: Adding info for No Bus:digi_ctl153
[   11.650170] PM: Adding info for No Bus:digi_ctl154
[   11.654939] PM: Adding info for No Bus:digi_ctl155
[   11.660175] PM: Adding info for No Bus:digi_ctl156
[   11.664938] PM: Adding info for No Bus:digi_ctl157
[   11.669711] PM: Adding info for No Bus:digi_ctl158
[   11.670170] PM: Adding info for No Bus:digi_ctl159
[   11.674939] PM: Adding info for No Bus:digi_ctl160
[   11.680327] PM: Adding info for No Bus:digi_ctl161
[   11.685102] PM: Adding info for No Bus:digi_ctl162
[   11.690168] PM: Adding info for No Bus:digi_ctl163
[   11.694940] PM: Adding info for No Bus:digi_ctl164
[   11.700190] PM: Adding info for No Bus:digi_ctl165
[   11.704958] PM: Adding info for No Bus:digi_ctl166
[   11.710298] PM: Adding info for No Bus:digi_ctl167
[   11.715075] PM: Adding info for No Bus:digi_ctl168
[   11.720186] PM: Adding info for No Bus:digi_ctl169
[   11.724951] PM: Adding info for No Bus:digi_ctl170
[   11.730294] PM: Adding info for No Bus:digi_ctl171
[   11.735074] PM: Adding info for No Bus:digi_ctl172
[   11.740183] PM: Adding info for No Bus:digi_ctl173
[   11.744953] PM: Adding info for No Bus:digi_ctl174
[   11.750171] PM: Adding info for No Bus:digi_ctl175
[   11.754942] PM: Adding info for No Bus:digi_ctl176
[   11.760175] PM: Adding info for No Bus:digi_ctl177
[   11.764929] PM: Adding info for No Bus:digi_ctl178
[   11.770164] PM: Adding info for No Bus:digi_ctl179
[   11.775077] PM: Adding info for No Bus:digi_ctl180
[   11.780178] PM: Adding info for No Bus:digi_ctl181
[   11.784943] PM: Adding info for No Bus:digi_ctl182
[   11.790031] PM: Adding info for No Bus:digi_ctl183
[   11.794811] PM: Adding info for No Bus:digi_ctl184
[   11.799588] PM: Adding info for No Bus:digi_ctl185
[   11.800184] PM: Adding info for No Bus:digi_ctl186
[   11.804957] PM: Adding info for No Bus:digi_ctl187
[   11.810312] PM: Adding info for No Bus:digi_ctl188
[   11.815096] PM: Adding info for No Bus:digi_ctl189
[   11.820199] PM: Adding info for No Bus:digi_ctl190
[   11.824978] PM: Adding info for No Bus:digi_ctl191
[   11.830311] PM: Adding info for No Bus:digi_ctl192
[   11.835090] PM: Adding info for No Bus:digi_ctl193
[   11.840191] PM: Adding info for No Bus:digi_ctl194
[   11.844965] PM: Adding info for No Bus:digi_ctl195
[   11.850298] PM: Adding info for No Bus:digi_ctl196
[   11.855070] PM: Adding info for No Bus:digi_ctl197
[   11.860327] PM: Adding info for No Bus:digi_ctl198
[   11.865106] PM: Adding info for No Bus:digi_ctl199
[   11.870175] PM: Adding info for No Bus:digi_ctl200
[   11.874947] PM: Adding info for No Bus:digi_ctl201
[   11.880184] PM: Adding info for No Bus:digi_ctl202
[   11.884958] PM: Adding info for No Bus:digi_ctl203
[   11.890167] PM: Adding info for No Bus:digi_ctl204
[   11.895068] PM: Adding info for No Bus:digi_ctl205
[   11.900197] PM: Adding info for No Bus:digi_ctl206
[   11.905111] PM: Adding info for No Bus:digi_ctl207
[   11.910183] PM: Adding info for No Bus:digi_ctl208
[   11.914964] PM: Adding info for No Bus:digi_ctl209
[   11.920138] PM: Adding info for No Bus:digi_ctl210
[   11.924908] PM: Adding info for No Bus:digi_ctl211
[   11.929685] PM: Adding info for No Bus:digi_ctl212
[   11.930171] PM: Adding info for No Bus:digi_ctl213
[   11.934944] PM: Adding info for No Bus:digi_ctl214
[   11.940200] PM: Adding info for No Bus:digi_ctl215
[   11.944981] PM: Adding info for No Bus:digi_ctl216
[   11.950181] PM: Adding info for No Bus:digi_ctl217
[   11.954969] PM: Adding info for No Bus:digi_ctl218
[   11.960204] PM: Adding info for No Bus:digi_ctl219
[   11.964981] PM: Adding info for No Bus:digi_ctl220
[   11.970171] PM: Adding info for No Bus:digi_ctl221
[   11.974949] PM: Adding info for No Bus:digi_ctl222
[   11.980199] PM: Adding info for No Bus:digi_ctl223
[   11.984991] PM: Adding info for No Bus:digi_ctl224
[   11.990180] PM: Adding info for No Bus:digi_ctl225
[   11.994953] PM: Adding info for No Bus:digi_ctl226
[   12.000198] PM: Adding info for No Bus:digi_ctl227
[   12.004981] PM: Adding info for No Bus:digi_ctl228
[   12.010185] PM: Adding info for No Bus:digi_ctl229
[   12.014971] PM: Adding info for No Bus:digi_ctl230
[   12.020202] PM: Adding info for No Bus:digi_ctl231
[   12.024992] PM: Adding info for No Bus:digi_ctl232
[   12.030182] PM: Adding info for No Bus:digi_ctl233
[   12.034971] PM: Adding info for No Bus:digi_ctl234
[   12.039757] PM: Adding info for No Bus:digi_ctl235
[   12.040185] PM: Adding info for No Bus:digi_ctl236
[   12.044947] PM: Adding info for No Bus:digi_ctl237
[   12.050177] PM: Adding info for No Bus:digi_ctl238
[   12.055123] PM: Adding info for No Bus:digi_ctl239
[   12.060343] PM: Adding info for No Bus:digi_ctl240
[   12.065122] PM: Adding info for No Bus:digi_ctl241
[   12.070177] PM: Adding info for No Bus:digi_ctl242
[   12.074967] PM: Adding info for No Bus:digi_ctl243
[   12.080182] PM: Adding info for No Bus:digi_ctl244
[   12.084965] PM: Adding info for No Bus:digi_ctl245
[   12.090174] PM: Adding info for No Bus:digi_ctl246
[   12.094955] PM: Adding info for No Bus:digi_ctl247
[   12.100198] PM: Adding info for No Bus:digi_ctl248
[   12.104993] PM: Adding info for No Bus:digi_ctl249
[   12.110184] PM: Adding info for No Bus:digi_ctl250
[   12.114972] PM: Adding info for No Bus:digi_ctl251
[   12.120192] PM: Adding info for No Bus:digi_ctl252
[   12.124970] PM: Adding info for No Bus:digi_ctl253
[   12.130176] PM: Adding info for No Bus:digi_ctl254
[   12.134964] PM: Adding info for No Bus:digi_ctl255
[   12.140094] initcall 0xc0a7b92b: epca_module_init+0x0/0x410() returned 0.
[   12.146756] initcall 0xc0a7b92b ran for 2237 msecs: epca_module_init+0x0/0x410()
[   12.152597] Calling initcall 0xc0a7bd3b: moxa_init+0x0/0x20c()
[   12.160170] MOXA Intellio family driver version 5.1k
[   12.165236] PM: Adding info for No Bus:ttyMX0
[   12.170105] PM: Adding info for No Bus:ttyMX1
[   12.174454] PM: Adding info for No Bus:ttyMX2
[   12.178815] PM: Adding info for No Bus:ttyMX3
[   12.180189] PM: Adding info for No Bus:ttyMX4
[   12.184546] PM: Adding info for No Bus:ttyMX5
[   12.190186] PM: Adding info for No Bus:ttyMX6
[   12.194538] PM: Adding info for No Bus:ttyMX7
[   12.200193] PM: Adding info for No Bus:ttyMX8
[   12.204542] PM: Adding info for No Bus:ttyMX9
[   12.208903] PM: Adding info for No Bus:ttyMX10
[   12.210186] PM: Adding info for No Bus:ttyMX11
[   12.214626] PM: Adding info for No Bus:ttyMX12
[   12.220209] PM: Adding info for No Bus:ttyMX13
[   12.224658] PM: Adding info for No Bus:ttyMX14
[   12.230185] PM: Adding info for No Bus:ttyMX15
[   12.234630] PM: Adding info for No Bus:ttyMX16
[   12.240208] PM: Adding info for No Bus:ttyMX17
[   12.244647] PM: Adding info for No Bus:ttyMX18
[   12.249266] PM: Adding info for No Bus:ttyMX19
[   12.250193] PM: Adding info for No Bus:ttyMX20
[   12.254635] PM: Adding info for No Bus:ttyMX21
[   12.260192] PM: Adding info for No Bus:ttyMX22
[   12.264642] PM: Adding info for No Bus:ttyMX23
[   12.270186] PM: Adding info for No Bus:ttyMX24
[   12.274629] PM: Adding info for No Bus:ttyMX25
[   12.280198] PM: Adding info for No Bus:ttyMX26
[   12.284636] PM: Adding info for No Bus:ttyMX27
[   12.289079] PM: Adding info for No Bus:ttyMX28
[   12.290181] PM: Adding info for No Bus:ttyMX29
[   12.294791] PM: Adding info for No Bus:ttyMX30
[   12.300216] PM: Adding info for No Bus:ttyMX31
[   12.304673] PM: Adding info for No Bus:ttyMX32
[   12.310190] PM: Adding info for No Bus:ttyMX33
[   12.314641] PM: Adding info for No Bus:ttyMX34
[   12.320203] PM: Adding info for No Bus:ttyMX35
[   12.324642] PM: Adding info for No Bus:ttyMX36
[   12.329080] PM: Adding info for No Bus:ttyMX37
[   12.330340] PM: Adding info for No Bus:ttyMX38
[   12.334795] PM: Adding info for No Bus:ttyMX39
[   12.340210] PM: Adding info for No Bus:ttyMX40
[   12.344663] PM: Adding info for No Bus:ttyMX41
[   12.350188] PM: Adding info for No Bus:ttyMX42
[   12.354631] PM: Adding info for No Bus:ttyMX43
[   12.360202] PM: Adding info for No Bus:ttyMX44
[   12.364638] PM: Adding info for No Bus:ttyMX45
[   12.370183] PM: Adding info for No Bus:ttyMX46
[   12.374637] PM: Adding info for No Bus:ttyMX47
[   12.379088] PM: Adding info for No Bus:ttyMX48
[   12.380198] PM: Adding info for No Bus:ttyMX49
[   12.384638] PM: Adding info for No Bus:ttyMX50
[   12.390198] PM: Adding info for No Bus:ttyMX51
[   12.394641] PM: Adding info for No Bus:ttyMX52
[   12.400207] PM: Adding info for No Bus:ttyMX53
[   12.404650] PM: Adding info for No Bus:ttyMX54
[   12.410193] PM: Adding info for No Bus:ttyMX55
[   12.414642] PM: Adding info for No Bus:ttyMX56
[   12.419093] PM: Adding info for No Bus:ttyMX57
[   12.420210] PM: Adding info for No Bus:ttyMX58
[   12.424654] PM: Adding info for No Bus:ttyMX59
[   12.430190] PM: Adding info for No Bus:ttyMX60
[   12.434652] PM: Adding info for No Bus:ttyMX61
[   12.440197] PM: Adding info for No Bus:ttyMX62
[   12.444644] PM: Adding info for No Bus:ttyMX63
[   12.450181] PM: Adding info for No Bus:ttyMX64
[   12.454628] PM: Adding info for No Bus:ttyMX65
[   12.459075] PM: Adding info for No Bus:ttyMX66
[   12.460213] PM: Adding info for No Bus:ttyMX67
[   12.464654] PM: Adding info for No Bus:ttyMX68
[   12.470192] PM: Adding info for No Bus:ttyMX69
[   12.474654] PM: Adding info for No Bus:ttyMX70
[   12.480200] PM: Adding info for No Bus:ttyMX71
[   12.484647] PM: Adding info for No Bus:ttyMX72
[   12.490186] PM: Adding info for No Bus:ttyMX73
[   12.494634] PM: Adding info for No Bus:ttyMX74
[   12.499087] PM: Adding info for No Bus:ttyMX75
[   12.500209] PM: Adding info for No Bus:ttyMX76
[   12.504838] PM: Adding info for No Bus:ttyMX77
[   12.510212] PM: Adding info for No Bus:ttyMX78
[   12.514665] PM: Adding info for No Bus:ttyMX79
[   12.520203] PM: Adding info for No Bus:ttyMX80
[   12.524648] PM: Adding info for No Bus:ttyMX81
[   12.530190] PM: Adding info for No Bus:ttyMX82
[   12.534641] PM: Adding info for No Bus:ttyMX83
[   12.539260] PM: Adding info for No Bus:ttyMX84
[   12.540208] PM: Adding info for No Bus:ttyMX85
[   12.544813] PM: Adding info for No Bus:ttyMX86
[   12.550206] PM: Adding info for No Bus:ttyMX87
[   12.554664] PM: Adding info for No Bus:ttyMX88
[   12.560366] PM: Adding info for No Bus:ttyMX89
[   12.564817] PM: Adding info for No Bus:ttyMX90
[   12.570191] PM: Adding info for No Bus:ttyMX91
[   12.574805] PM: Adding info for No Bus:ttyMX92
[   12.580209] PM: Adding info for No Bus:ttyMX93
[   12.584669] PM: Adding info for No Bus:ttyMX94
[   12.589126] PM: Adding info for No Bus:ttyMX95
[   12.590198] PM: Adding info for No Bus:ttyMX96
[   12.594646] PM: Adding info for No Bus:ttyMX97
[   12.600212] PM: Adding info for No Bus:ttyMX98
[   12.604677] PM: Adding info for No Bus:ttyMX99
[   12.610210] PM: Adding info for No Bus:ttyMX100
[   12.614760] PM: Adding info for No Bus:ttyMX101
[   12.620217] PM: Adding info for No Bus:ttyMX102
[   12.624761] PM: Adding info for No Bus:ttyMX103
[   12.630103] PM: Adding info for No Bus:ttyMX104
[   12.634646] PM: Adding info for No Bus:ttyMX105
[   12.639195] PM: Adding info for No Bus:ttyMX106
[   12.640216] PM: Adding info for No Bus:ttyMX107
[   12.644754] PM: Adding info for No Bus:ttyMX108
[   12.650197] PM: Adding info for No Bus:ttyMX109
[   12.654743] PM: Adding info for No Bus:ttyMX110
[   12.660211] PM: Adding info for No Bus:ttyMX111
[   12.664750] PM: Adding info for No Bus:ttyMX112
[   12.670194] PM: Adding info for No Bus:ttyMX113
[   12.674744] PM: Adding info for No Bus:ttyMX114
[   12.680185] PM: Adding info for No Bus:ttyMX115
[   12.684720] PM: Adding info for No Bus:ttyMX116
[   12.689271] PM: Adding info for No Bus:ttyMX117
[   12.690199] PM: Adding info for No Bus:ttyMX118
[   12.694746] PM: Adding info for No Bus:ttyMX119
[   12.700222] PM: Adding info for No Bus:ttyMX120
[   12.704774] PM: Adding info for No Bus:ttyMX121
[   12.710204] PM: Adding info for No Bus:ttyMX122
[   12.714751] PM: Adding info for No Bus:ttyMX123
[   12.720224] PM: Adding info for No Bus:ttyMX124
[   12.724783] PM: Adding info for No Bus:ttyMX125
[   12.730203] PM: Adding info for No Bus:ttyMX126
[   12.734751] PM: Adding info for No Bus:ttyMX127
[   12.739301] PM: Adding info for No Bus:ttyMX128
[   12.740198] initcall 0xc0a7bd3b: moxa_init+0x0/0x20c() returned 0.
[   12.746201] initcall 0xc0a7bd3b ran for 556 msecs: moxa_init+0x0/0x20c()
[   12.751990] Calling initcall 0xc0a7bf47: mxser_module_init+0x0/0x782()
[   12.762859] MOXA Smartio/Industio family driver version 1.8
[   12.768559] PM: Adding info for No Bus:ttyMI0
[   12.770201] PM: Adding info for No Bus:ttyMI1
[   12.774777] PM: Adding info for No Bus:ttyMI2
[   12.780217] PM: Adding info for No Bus:ttyMI3
[   12.784591] PM: Adding info for No Bus:ttyMI4
[   12.790193] PM: Adding info for No Bus:ttyMI5
[   12.794562] PM: Adding info for No Bus:ttyMI6
[   12.798940] PM: Adding info for No Bus:ttyMI7
[   12.800207] PM: Adding info for No Bus:ttyMI8
[   12.804586] PM: Adding info for No Bus:ttyMI9
[   12.810216] PM: Adding info for No Bus:ttyMI10
[   12.814671] PM: Adding info for No Bus:ttyMI11
[   12.820200] PM: Adding info for No Bus:ttyMI12
[   12.824660] PM: Adding info for No Bus:ttyMI13
[   12.830229] PM: Adding info for No Bus:ttyMI14
[   12.834686] PM: Adding info for No Bus:ttyMI15
[   12.839152] PM: Adding info for No Bus:ttyMI16
[   12.840209] PM: Adding info for No Bus:ttyMI17
[   12.844671] PM: Adding info for No Bus:ttyMI18
[   12.850216] PM: Adding info for No Bus:ttyMI19
[   12.854671] PM: Adding info for No Bus:ttyMI20
[   12.860394] PM: Adding info for No Bus:ttyMI21
[   12.864856] PM: Adding info for No Bus:ttyMI22
[   12.870233] PM: Adding info for No Bus:ttyMI23
[   12.874691] PM: Adding info for No Bus:ttyMI24
[   12.880136] PM: Adding info for No Bus:ttyMI25
[   12.884609] PM: Adding info for No Bus:ttyMI26
[   12.889074] PM: Adding info for No Bus:ttyMI27
[   12.890209] PM: Adding info for No Bus:ttyMI28
[   12.894653] PM: Adding info for No Bus:ttyMI29
[   12.900187] PM: Adding info for No Bus:ttyMI30
[   12.904629] PM: Adding info for No Bus:ttyMI31
[   12.910221] PM: Adding info for No Bus:ttyMI32
[   12.914558] initcall 0xc0a7bf47: mxser_module_init+0x0/0x782() returned 0.
[   12.921209] initcall 0xc0a7bf47 ran for 145 msecs: mxser_module_init+0x0/0x782()
[   12.928576] Calling initcall 0xc0a7c6c9: ip2_init+0x0/0x4f()
[   12.931991] Computone IntelliPort Plus multiport driver version 1.2.14
[   12.940106] initcall 0xc0a7c6c9: ip2_init+0x0/0x4f() returned 0.
[   12.945977] initcall 0xc0a7c6c9 ran for 6 msecs: ip2_init+0x0/0x4f()
[   12.951817] Calling initcall 0xc0a7c899: riscom8_init_module+0x0/0x455()
[   12.960171] rc: SDL RISCom/8 card driver v1.1, (c) D.Gorodchanin 1994-1996.
[   12.967238] PM: Adding info for No Bus:ttyL0
[   12.970204] PM: Adding info for No Bus:ttyL1
[   12.974487] PM: Adding info for No Bus:ttyL2
[   12.980203] PM: Adding info for No Bus:ttyL3
[   12.984504] PM: Adding info for No Bus:ttyL4
[   12.988793] PM: Adding info for No Bus:ttyL5
[   12.990201] PM: Adding info for No Bus:ttyL6
[   12.994499] PM: Adding info for No Bus:ttyL7
[   13.000213] PM: Adding info for No Bus:ttyL8
[   13.004498] PM: Adding info for No Bus:ttyL9
[   13.010233] PM: Adding info for No Bus:ttyL10
[   13.014612] PM: Adding info for No Bus:ttyL11
[   13.018998] PM: Adding info for No Bus:ttyL12
[   13.020214] PM: Adding info for No Bus:ttyL13
[   13.024590] PM: Adding info for No Bus:ttyL14
[   13.030235] PM: Adding info for No Bus:ttyL15
[   13.034613] PM: Adding info for No Bus:ttyL16
[   13.040216] PM: Adding info for No Bus:ttyL17
[   13.044603] PM: Adding info for No Bus:ttyL18
[   13.050225] PM: Adding info for No Bus:ttyL19
[   13.054600] PM: Adding info for No Bus:ttyL20
[   13.059184] PM: Adding info for No Bus:ttyL21
[   13.060224] PM: Adding info for No Bus:ttyL22
[   13.064609] PM: Adding info for No Bus:ttyL23
[   13.070224] PM: Adding info for No Bus:ttyL24
[   13.074598] PM: Adding info for No Bus:ttyL25
[   13.080394] PM: Adding info for No Bus:ttyL26
[   13.084793] PM: Adding info for No Bus:ttyL27
[   13.090226] PM: Adding info for No Bus:ttyL28
[   13.094603] PM: Adding info for No Bus:ttyL29
[   13.098992] PM: Adding info for No Bus:ttyL30
[   13.100204] PM: Adding info for No Bus:ttyL31
[   13.104484] rc0: RISCom/8 Board at 0x220 not found.
[   13.110053] rc1: RISCom/8 Board at 0x240 not found.
[   13.114869] rc2: RISCom/8 Board at 0x250 not found.
[   13.120026] rc3: RISCom/8 Board at 0x260 not found.
[   13.124924] PM: Removing info for No Bus:ttyL0
[   13.130194] PM: Removing info for No Bus:ttyL1
[   13.134659] PM: Removing info for No Bus:ttyL2
[   13.140207] PM: Removing info for No Bus:ttyL3
[   13.144680] PM: Removing info for No Bus:ttyL4
[   13.149149] PM: Removing info for No Bus:ttyL5
[   13.150206] PM: Removing info for No Bus:ttyL6
[   13.154677] PM: Removing info for No Bus:ttyL7
[   13.160206] PM: Removing info for No Bus:ttyL8
[   13.164670] PM: Removing info for No Bus:ttyL9
[   13.170217] PM: Removing info for No Bus:ttyL10
[   13.174771] PM: Removing info for No Bus:ttyL11
[   13.180235] PM: Removing info for No Bus:ttyL12
[   13.184790] PM: Removing info for No Bus:ttyL13
[   13.190205] PM: Removing info for No Bus:ttyL14
[   13.194757] PM: Removing info for No Bus:ttyL15
[   13.199324] PM: Removing info for No Bus:ttyL16
[   13.200213] PM: Removing info for No Bus:ttyL17
[   13.204772] PM: Removing info for No Bus:ttyL18
[   13.210207] PM: Removing info for No Bus:ttyL19
[   13.214761] PM: Removing info for No Bus:ttyL20
[   13.220240] PM: Removing info for No Bus:ttyL21
[   13.224787] PM: Removing info for No Bus:ttyL22
[   13.230208] PM: Removing info for No Bus:ttyL23
[   13.234766] PM: Removing info for No Bus:ttyL24
[   13.240237] PM: Removing info for No Bus:ttyL25
[   13.244792] PM: Removing info for No Bus:ttyL26
[   13.249350] PM: Removing info for No Bus:ttyL27
[   13.250213] PM: Removing info for No Bus:ttyL28
[   13.254777] PM: Removing info for No Bus:ttyL29
[   13.260234] PM: Removing info for No Bus:ttyL30
[   13.264795] PM: Removing info for No Bus:ttyL31
[   13.270161] rc: No RISCom/8 boards detected.
[   13.274252] initcall 0xc0a7c899: riscom8_init_module+0x0/0x455() returned -5.
[   13.281297] initcall 0xc0a7c899 ran for 301 msecs: riscom8_init_module+0x0/0x455()
[   13.290005] initcall at 0xc0a7c899: riscom8_init_module+0x0/0x455(): returned with error code -5
[   13.300006] Calling initcall 0xc0a7ccee: synclink_init+0x0/0x216()
[   13.306150] SyncLink serial driver $Revision: 4.38 $
[   13.310285] PM: Adding info for No Bus:ttySL0
[   13.314670] PM: Adding info for No Bus:ttySL1
[   13.320205] PM: Adding info for No Bus:ttySL2
[   13.324577] PM: Adding info for No Bus:ttySL3
[   13.328952] PM: Adding info for No Bus:ttySL4
[   13.330222] PM: Adding info for No Bus:ttySL5
[   13.334590] PM: Adding info for No Bus:ttySL6
[   13.340212] PM: Adding info for No Bus:ttySL7
[   13.344599] PM: Adding info for No Bus:ttySL8
[   13.350206] PM: Adding info for No Bus:ttySL9
[   13.354577] PM: Adding info for No Bus:ttySL10
[   13.359031] PM: Adding info for No Bus:ttySL11
[   13.360203] PM: Adding info for No Bus:ttySL12
[   13.364661] PM: Adding info for No Bus:ttySL13
[   13.370236] PM: Adding info for No Bus:ttySL14
[   13.374701] PM: Adding info for No Bus:ttySL15
[   13.380223] PM: Adding info for No Bus:ttySL16
[   13.384690] PM: Adding info for No Bus:ttySL17
[   13.390218] PM: Adding info for No Bus:ttySL18
[   13.394649] PM: Adding info for No Bus:ttySL19
[   13.399109] PM: Adding info for No Bus:ttySL20
[   13.400207] PM: Adding info for No Bus:ttySL21
[   13.404672] PM: Adding info for No Bus:ttySL22
[   13.410241] PM: Adding info for No Bus:ttySL23
[   13.414705] PM: Adding info for No Bus:ttySL24
[   13.420224] PM: Adding info for No Bus:ttySL25
[   13.424704] PM: Adding info for No Bus:ttySL26
[   13.430232] PM: Adding info for No Bus:ttySL27
[   13.434689] PM: Adding info for No Bus:ttySL28
[   13.440221] PM: Adding info for No Bus:ttySL29
[   13.444696] PM: Adding info for No Bus:ttySL30
[   13.449177] PM: Adding info for No Bus:ttySL31
[   13.450231] PM: Adding info for No Bus:ttySL32
[   13.454695] PM: Adding info for No Bus:ttySL33
[   13.460230] PM: Adding info for No Bus:ttySL34
[   13.464704] PM: Adding info for No Bus:ttySL35
[   13.470241] PM: Adding info for No Bus:ttySL36
[   13.474711] PM: Adding info for No Bus:ttySL37
[   13.480210] PM: Adding info for No Bus:ttySL38
[   13.484679] PM: Adding info for No Bus:ttySL39
[   13.489167] PM: Adding info for No Bus:ttySL40
[   13.490209] PM: Adding info for No Bus:ttySL41
[   13.494657] PM: Adding info for No Bus:ttySL42
[   13.500218] PM: Adding info for No Bus:ttySL43
[   13.504691] PM: Adding info for No Bus:ttySL44
[   13.510243] PM: Adding info for No Bus:ttySL45
[   13.514727] PM: Adding info for No Bus:ttySL46
[   13.520210] PM: Adding info for No Bus:ttySL47
[   13.524690] PM: Adding info for No Bus:ttySL48
[   13.529157] PM: Adding info for No Bus:ttySL49
[   13.530215] PM: Adding info for No Bus:ttySL50
[   13.534681] PM: Adding info for No Bus:ttySL51
[   13.540218] PM: Adding info for No Bus:ttySL52
[   13.544692] PM: Adding info for No Bus:ttySL53
[   13.550221] PM: Adding info for No Bus:ttySL54
[   13.554687] PM: Adding info for No Bus:ttySL55
[   13.560437] PM: Adding info for No Bus:ttySL56
[   13.564912] PM: Adding info for No Bus:ttySL57
[   13.570245] PM: Adding info for No Bus:ttySL58
[   13.574718] PM: Adding info for No Bus:ttySL59
[   13.579201] PM: Adding info for No Bus:ttySL60
[   13.580218] PM: Adding info for No Bus:ttySL61
[   13.584702] PM: Adding info for No Bus:ttySL62
[   13.590238] PM: Adding info for No Bus:ttySL63
[   13.594708] PM: Adding info for No Bus:ttySL64
[   13.600407] PM: Adding info for No Bus:ttySL65
[   13.604890] PM: Adding info for No Bus:ttySL66
[   13.610240] PM: Adding info for No Bus:ttySL67
[   13.614715] PM: Adding info for No Bus:ttySL68
[   13.620070] PM: Adding info for No Bus:ttySL69
[   13.624546] PM: Adding info for No Bus:ttySL70
[   13.629041] PM: Adding info for No Bus:ttySL71
[   13.630412] PM: Adding info for No Bus:ttySL72
[   13.634905] PM: Adding info for No Bus:ttySL73
[   13.640235] PM: Adding info for No Bus:ttySL74
[   13.644725] PM: Adding info for No Bus:ttySL75
[   13.650243] PM: Adding info for No Bus:ttySL76
[   13.654719] PM: Adding info for No Bus:ttySL77
[   13.660222] PM: Adding info for No Bus:ttySL78
[   13.664704] PM: Adding info for No Bus:ttySL79
[   13.669199] PM: Adding info for No Bus:ttySL80
[   13.670442] PM: Adding info for No Bus:ttySL81
[   13.674935] PM: Adding info for No Bus:ttySL82
[   13.680237] PM: Adding info for No Bus:ttySL83
[   13.684721] PM: Adding info for No Bus:ttySL84
[   13.690244] PM: Adding info for No Bus:ttySL85
[   13.694717] PM: Adding info for No Bus:ttySL86
[   13.700218] PM: Adding info for No Bus:ttySL87
[   13.704697] PM: Adding info for No Bus:ttySL88
[   13.710254] PM: Adding info for No Bus:ttySL89
[   13.714745] PM: Adding info for No Bus:ttySL90
[   13.719231] PM: Adding info for No Bus:ttySL91
[   13.720231] PM: Adding info for No Bus:ttySL92
[   13.724715] PM: Adding info for No Bus:ttySL93
[   13.730244] PM: Adding info for No Bus:ttySL94
[   13.734722] PM: Adding info for No Bus:ttySL95
[   13.740219] PM: Adding info for No Bus:ttySL96
[   13.744701] PM: Adding info for No Bus:ttySL97
[   13.750250] PM: Adding info for No Bus:ttySL98
[   13.754739] PM: Adding info for No Bus:ttySL99
[   13.759226] PM: Adding info for No Bus:ttySL100
[   13.760257] PM: Adding info for No Bus:ttySL101
[   13.764841] PM: Adding info for No Bus:ttySL102
[   13.770239] PM: Adding info for No Bus:ttySL103
[   13.774807] PM: Adding info for No Bus:ttySL104
[   13.780226] PM: Adding info for No Bus:ttySL105
[   13.784796] PM: Adding info for No Bus:ttySL106
[   13.790258] PM: Adding info for No Bus:ttySL107
[   13.794836] PM: Adding info for No Bus:ttySL108
[   13.800230] PM: Adding info for No Bus:ttySL109
[   13.804816] PM: Adding info for No Bus:ttySL110
[   13.810231] PM: Adding info for No Bus:ttySL111
[   13.814800] PM: Adding info for No Bus:ttySL112
[   13.819371] PM: Adding info for No Bus:ttySL113
[   13.820229] PM: Adding info for No Bus:ttySL114
[   13.824800] PM: Adding info for No Bus:ttySL115
[   13.830261] PM: Adding info for No Bus:ttySL116
[   13.834838] PM: Adding info for No Bus:ttySL117
[   13.840233] PM: Adding info for No Bus:ttySL118
[   13.844824] PM: Adding info for No Bus:ttySL119
[   13.850261] PM: Adding info for No Bus:ttySL120
[   13.854831] PM: Adding info for No Bus:ttySL121
[   13.860234] PM: Adding info for No Bus:ttySL122
[   13.864811] PM: Adding info for No Bus:ttySL123
[   13.869388] PM: Adding info for No Bus:ttySL124
[   13.870256] PM: Adding info for No Bus:ttySL125
[   13.874828] PM: Adding info for No Bus:ttySL126
[   13.880236] PM: Adding info for No Bus:ttySL127
[   13.884684] SyncLink serial driver $Revision: 4.38 $, tty major#250
[   13.890044] initcall 0xc0a7ccee: synclink_init+0x0/0x216() returned 0.
[   13.900007] initcall 0xc0a7ccee ran for 560 msecs: synclink_init+0x0/0x216()
[   13.907017] Calling initcall 0xc0a7cf04: slgt_init+0x0/0x178()
[   13.912164] SyncLink GT $Revision: 4.50 $
[   13.916159] SyncLink GT $Revision: 4.50 $, tty major#249
[   13.920118] SyncLink GT no devices found
[   13.923898] initcall 0xc0a7cf04: slgt_init+0x0/0x178() returned 0.
[   13.931210] initcall 0xc0a7cf04 ran for 12 msecs: slgt_init+0x0/0x178()
[   13.937795] Calling initcall 0xc0a7d07c: n_hdlc_init+0x0/0x81()
[   13.942251] HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
[   13.950005] N_HDLC line discipline registered.
[   13.954417] initcall 0xc0a7d07c: n_hdlc_init+0x0/0x81() returned 0.
[   13.961211] initcall 0xc0a7d07c ran for 10 msecs: n_hdlc_init+0x0/0x81()
[   13.967884] Calling initcall 0xc0a7d0fd: sx_init+0x0/0xc8()
[   13.971923] PM: Adding info for No Bus:sxctl
[   13.976320] initcall 0xc0a7d0fd: sx_init+0x0/0xc8() returned 0.
[   13.982943] initcall 0xc0a7d0fd ran for 4 msecs: sx_init+0x0/0xc8()
[   13.990014] Calling initcall 0xc0a7d1c5: rio_init+0x0/0xab0()
[   13.995737] PM: Adding info for No Bus:rioctl
[   14.008265] PM: Removing info for No Bus:rioctl
[   14.010133] initcall 0xc0a7d1c5: rio_init+0x0/0xab0() returned -5.
[   14.020008] initcall 0xc0a7d1c5 ran for 16 msecs: rio_init+0x0/0xab0()
[   14.026496] initcall at 0xc0a7d1c5: rio_init+0x0/0xab0(): returned with error code -5
[   14.032684] Calling initcall 0xc0a7dca9: init+0x0/0xf()
[   14.038127] initcall 0xc0a7dca9: init+0x0/0xf() returned 0.
[   14.042596] initcall 0xc0a7dca9 ran for 0 msecs: init+0x0/0xf()
[   14.050011] Calling initcall 0xc0a7dcd0: raw_init+0x0/0xb9()
[   14.055734] PM: Adding info for No Bus:rawctl
[   14.060085] initcall 0xc0a7dcd0: raw_init+0x0/0xb9() returned 0.
[   14.065976] initcall 0xc0a7dcd0 ran for 4 msecs: raw_init+0x0/0xb9()
[   14.071817] Calling initcall 0xc0a7dd89: applicom_init+0x0/0x411()
[   14.077970] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[   14.080008] ac.o: No PCI boards found.
[   14.090005] ac.o: For an ISA board you must supply memory and irq parameters.
[   14.097103] initcall 0xc0a7dd89: applicom_init+0x0/0x411() returned -6.
[   14.103638] initcall 0xc0a7dd89 ran for 17 msecs: applicom_init+0x0/0x411()
[   14.110005] initcall at 0xc0a7dd89: applicom_init+0x0/0x411(): returned with error code -6
[   14.118229] Calling initcall 0xc0a7e19a: rtc_generic_init+0x0/0x57()
[   14.122683] Generic RTC Driver v1.07
[   14.126254] PM: Adding info for No Bus:rtc
[   14.130234] initcall 0xc0a7e19a: rtc_generic_init+0x0/0x57() returned 0.
[   14.140008] initcall 0xc0a7e19a ran for 7 msecs: rtc_generic_init+0x0/0x57()
[   14.147015] Calling initcall 0xc0a7e1f1: nvram_init+0x0/0x75()
[   14.152183] PM: Adding info for No Bus:nvram
[   14.156487] Non-volatile memory driver v1.2
[   14.160007] initcall 0xc0a7e1f1: nvram_init+0x0/0x75() returned 0.
[   14.166149] initcall 0xc0a7e1f1 ran for 8 msecs: nvram_init+0x0/0x75()
[   14.171991] Calling initcall 0xc0a7e266: toshiba_init+0x0/0x313()
[   14.180007] toshiba: not a supported Toshiba laptop
[   14.184850] initcall 0xc0a7e266: toshiba_init+0x0/0x313() returned -19.
[   14.191385] initcall 0xc0a7e266 ran for 4 msecs: toshiba_init+0x0/0x313()
[   14.198144] Calling initcall 0xc0a7e579: i8k_init+0x0/0x1b5()
[   14.202079] initcall 0xc0a7e579: i8k_init+0x0/0x1b5() returned -19.
[   14.210005] initcall 0xc0a7e579 ran for 0 msecs: i8k_init+0x0/0x1b5()
[   14.216410] Calling initcall 0xc0a7e72e: mod_init+0x0/0x91()
[   14.222001] initcall 0xc0a7e72e: mod_init+0x0/0x91() returned -19.
[   14.228144] initcall 0xc0a7e72e ran for 0 msecs: mod_init+0x0/0x91()
[   14.231817] Calling initcall 0xc0a7e7bf: tlclk_init+0x0/0x17e()
[   14.240179] telclk_interrup = 0xf non-mcpbl0010 hw.
[   14.245029] initcall 0xc0a7e7bf: tlclk_init+0x0/0x17e() returned -6.
[   14.251297] initcall 0xc0a7e7bf ran for 4 msecs: tlclk_init+0x0/0x17e()
[   14.257883] initcall at 0xc0a7e7bf: tlclk_init+0x0/0x17e(): returned with error code -6
[   14.264763] Calling initcall 0xc0a7e97d: agp_init+0x0/0x21()
[   14.270172] Linux agpgart interface v0.102
[   14.274244] initcall 0xc0a7e97d: agp_init+0x0/0x21() returned 0.
[   14.281211] initcall 0xc0a7e97d ran for 3 msecs: agp_init+0x0/0x21()
[   14.287538] Calling initcall 0xc0a7e99e: agp_amdk7_init+0x0/0x24()
[   14.292772] initcall 0xc0a7e99e: agp_amdk7_init+0x0/0x24() returned 0.
[   14.300008] initcall 0xc0a7e99e ran for 0 msecs: agp_amdk7_init+0x0/0x24()
[   14.306842] Calling initcall 0xc0a7e9c2: agp_amd64_init+0x0/0xb1()
[   14.312615] initcall 0xc0a7e9c2: agp_amd64_init+0x0/0xb1() returned 0.
[   14.320007] initcall 0xc0a7e9c2 ran for 0 msecs: agp_amd64_init+0x0/0xb1()
[   14.326843] Calling initcall 0xc0a7ea73: agp_intel_init+0x0/0x24()
[   14.332760] initcall 0xc0a7ea73: agp_intel_init+0x0/0x24() returned 0.
[   14.340008] initcall 0xc0a7ea73 ran for 0 msecs: agp_intel_init+0x0/0x24()
[   14.346842] Calling initcall 0xc0a7ea97: agp_sis_init+0x0/0x24()
[   14.352442] initcall 0xc0a7ea97: agp_sis_init+0x0/0x24() returned 0.
[   14.358664] initcall 0xc0a7ea97 ran for 0 msecs: agp_sis_init+0x0/0x24()
[   14.362163] Calling initcall 0xc0a7eabb: agp_via_init+0x0/0x24()
[   14.370418] initcall 0xc0a7eabb: agp_via_init+0x0/0x24() returned 0.
[   14.376592] initcall 0xc0a7eabb ran for 0 msecs: agp_via_init+0x0/0x24()
[   14.382163] Calling initcall 0xc0a7eadf: drm_core_init+0x0/0x110()
[   14.390260] [drm] Initialized drm 1.1.0 20060810
[   14.394764] initcall 0xc0a7eadf: drm_core_init+0x0/0x110() returned 0.
[   14.401211] initcall 0xc0a7eadf ran for 4 msecs: drm_core_init+0x0/0x110()
[   14.408057] Calling initcall 0xc0a7ebef: tdfx_init+0x0/0xf()
[   14.411996] initcall 0xc0a7ebef: tdfx_init+0x0/0xf() returned 0.
[   14.420006] initcall 0xc0a7ebef ran for 0 msecs: tdfx_init+0x0/0xf()
[   14.426324] Calling initcall 0xc0a7ebfe: radeon_init+0x0/0x19()
[   14.432679] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 5
[   14.438162] PCI: setting IRQ 5 as level-triggered
[   14.440007] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNK3] -> GSI 5 (level, low) -> IRQ 5
[   14.450167] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   14.455917] initcall 0xc0a7ebfe: radeon_init+0x0/0x19() returned 0.
[   14.463289] initcall 0xc0a7ebfe ran for 23 msecs: radeon_init+0x0/0x19()
[   14.470011] Calling initcall 0xc0a7ec17: mga_init+0x0/0x19()
[   14.475633] initcall 0xc0a7ec17: mga_init+0x0/0x19() returned 0.
[   14.481210] initcall 0xc0a7ec17 ran for 0 msecs: mga_init+0x0/0x19()
[   14.487537] Calling initcall 0xc0a7ec30: i915_init+0x0/0x19()
[   14.492085] initcall 0xc0a7ec30: i915_init+0x0/0x19() returned 0.
[   14.500006] initcall 0xc0a7ec30 ran for 0 msecs: i915_init+0x0/0x19()
[   14.506410] Calling initcall 0xc0a7ec49: sis_init+0x0/0x19()
[   14.511994] initcall 0xc0a7ec49: sis_init+0x0/0x19() returned 0.
[   14.517970] initcall 0xc0a7ec49 ran for 0 msecs: sis_init+0x0/0x19()
[   14.521818] Calling initcall 0xc0a7ec62: via_init+0x0/0x1e()
[   14.530177] initcall 0xc0a7ec62: via_init+0x0/0x1e() returned 0.
[   14.536151] initcall 0xc0a7ec62 ran for 0 msecs: via_init+0x0/0x1e()
[   14.541818] Calling initcall 0xc0a7f01c: serial8250_init+0x0/0x10c()
[   14.548144] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   14.550039] PM: Adding info for platform:serial8250
[   14.560213] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   14.566275] PM: Adding info for No Bus:ttyS0
[   14.570276] PM: Adding info for No Bus:ttyS1
[   14.574635] PM: Adding info for No Bus:ttyS2
[   14.580271] PM: Adding info for No Bus:ttyS3
[   14.584552] initcall 0xc0a7f01c: serial8250_init+0x0/0x10c() returned 0.
[   14.591209] initcall 0xc0a7f01c ran for 34 msecs: serial8250_init+0x0/0x10c()
[   14.598315] Calling initcall 0xc0a7f128: serial8250_pci_init+0x0/0x16()
[   14.603056] initcall 0xc0a7f128: serial8250_pci_init+0x0/0x16() returned 0.
[   14.611210] initcall 0xc0a7f128 ran for 0 msecs: serial8250_pci_init+0x0/0x16()
[   14.620026] Calling initcall 0xc0a7f13e: init_serial_cs+0x0/0xf()
[   14.626184] initcall 0xc0a7f13e: init_serial_cs+0x0/0xf() returned 0.
[   14.631209] initcall 0xc0a7f13e ran for 0 msecs: init_serial_cs+0x0/0xf()
[   14.637969] Calling initcall 0xc0a7f537: mca_init+0x0/0x1d()
[   14.641991] initcall 0xc0a7f537: mca_init+0x0/0x1d() returned -19.
[   14.650005] initcall 0xc0a7f537 ran for 0 msecs: mca_init+0x0/0x1d()
[   14.656323] Calling initcall 0xc0a7f7e7: ibmasm_init+0x0/0x56()
[   14.662372] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[   14.668837] initcall 0xc0a7f7e7: ibmasm_init+0x0/0x56() returned 0.
[   14.673291] initcall 0xc0a7f7e7 ran for 6 msecs: ibmasm_init+0x0/0x56()
[   14.682077] Calling initcall 0xc0a7f83d: msi_init+0x0/0x10d()
[   14.687799] initcall 0xc0a7f83d: msi_init+0x0/0x10d() returned -19.
[   14.693291] initcall 0xc0a7f83d ran for 0 msecs: msi_init+0x0/0x10d()
[   14.700006] Calling initcall 0xc0a7f94a: phantom_init+0x0/0xd4()
[   14.706179] Phantom Linux Driver, version n0.9.7, init OK
[   14.710006] initcall 0xc0a7f94a: phantom_init+0x0/0xd4() returned 0.
[   14.716323] initcall 0xc0a7f94a ran for 5 msecs: phantom_init+0x0/0xd4()
[   14.722164] Calling initcall 0xc0a7fa1e: sony_laptop_init+0x0/0x6d()
[   14.730305] initcall 0xc0a7fa1e: sony_laptop_init+0x0/0x6d() returned 0.
[   14.736844] initcall 0xc0a7fa1e ran for 0 msecs: sony_laptop_init+0x0/0x6d()
[   14.742510] Calling initcall 0xc0a80cfb: thinkpad_acpi_module_init+0x0/0x74c()
[   14.750195] initcall 0xc0a80cfb: thinkpad_acpi_module_init+0x0/0x74c() returned -19.
[   14.760006] initcall 0xc0a80cfb ran for 0 msecs: thinkpad_acpi_module_init+0x0/0x74c()
[   14.767883] Calling initcall 0xc0a81447: sm501_base_init+0x0/0x20()
[   14.772800] initcall 0xc0a81447: sm501_base_init+0x0/0x20() returned 0.
[   14.780011] initcall 0xc0a81447 ran for 0 msecs: sm501_base_init+0x0/0x20()
[   14.786930] Calling initcall 0xc0a81467: e1000_init_module+0x0/0x6d()
[   14.792771] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   14.800006] Copyright (c) 1999-2006 Intel Corporation.
[   14.805206] initcall 0xc0a81467: e1000_init_module+0x0/0x6d() returned 0.
[   14.811210] initcall 0xc0a81467 ran for 10 msecs: e1000_init_module+0x0/0x6d()
[   14.818403] Calling initcall 0xc0a814d4: ipg_init_module+0x0/0x16()
[   14.822706] initcall 0xc0a814d4: ipg_init_module+0x0/0x16() returned 0.
[   14.831210] initcall 0xc0a814d4 ran for 0 msecs: ipg_init_module+0x0/0x16()
[   14.838142] Calling initcall 0xc0a814ea: vcan_init_module+0x0/0x2e()
[   14.842684] vcan: Virtual CAN interface driver
[   14.850007] initcall 0xc0a814ea: vcan_init_module+0x0/0x2e() returned 0.
[   14.856670] initcall 0xc0a814ea ran for 4 msecs: vcan_init_module+0x0/0x2e()
[   14.862510] Calling initcall 0xc0a81518: bonding_init+0x0/0x757()
[   14.868577] Ethernet Channel Bonding Driver: v3.2.3 (December 6, 2007)
[   14.870006] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[   14.880180] PM: Adding info for No Bus:bond0
[   14.884731] initcall 0xc0a81518: bonding_init+0x0/0x757() returned 0.
[   14.893463] initcall 0xc0a81518 ran for 26 msecs: bonding_init+0x0/0x757()
[   14.900012] Calling initcall 0xc0a81c6f: rr_init_module+0x0/0x16()
[   14.906269] initcall 0xc0a81c6f: rr_init_module+0x0/0x16() returned 0.
[   14.913550] initcall 0xc0a81c6f ran for 0 msecs: rr_init_module+0x0/0x16()
[   14.920011] Calling initcall 0xc0a81c85: happy_meal_probe+0x0/0x16()
[   14.926429] initcall 0xc0a81c85: happy_meal_probe+0x0/0x16() returned 0.
[   14.931210] initcall 0xc0a81c85 ran for 0 msecs: happy_meal_probe+0x0/0x16()
[   14.940013] Calling initcall 0xc0a81c9b: gem_init+0x0/0x16()
[   14.945731] initcall 0xc0a81c9b: gem_init+0x0/0x16() returned 0.
[   14.951209] initcall 0xc0a81c9b ran for 0 msecs: gem_init+0x0/0x16()
[   14.957536] Calling initcall 0xc0a81cb1: cas_init+0x0/0x33()
[   14.962101] initcall 0xc0a81cb1: cas_init+0x0/0x33() returned 0.
[   14.970006] initcall 0xc0a81cb1 ran for 0 msecs: cas_init+0x0/0x33()
[   14.976322] Calling initcall 0xc0a81ce4: ne2k_pci_init+0x0/0x16()
[   14.982532] initcall 0xc0a81ce4: ne2k_pci_init+0x0/0x16() returned 0.
[   14.988836] initcall 0xc0a81ce4 ran for 0 msecs: ne2k_pci_init+0x0/0x16()
[   14.992250] Calling initcall 0xc0a81cfa: pcnet32_init_module+0x0/0x118()
[   15.000172] pcnet32.c:v1.34-NAPI 14.Aug.2007 tsbogend@alpha.franken.de
[   15.006781] initcall 0xc0a81cfa: pcnet32_init_module+0x0/0x118() returned 0.
[   15.014069] initcall 0xc0a81cfa ran for 6 msecs: pcnet32_init_module+0x0/0x118()
[   15.022857] Calling initcall 0xc0a81e12: eepro100_init_module+0x0/0x16()
[   15.030114] initcall 0xc0a81e12: eepro100_init_module+0x0/0x16() returned 0.
[   15.037016] initcall 0xc0a81e12 ran for 0 msecs: eepro100_init_module+0x0/0x16()
[   15.042857] Calling initcall 0xc0a81e28: e100_init_module+0x0/0x4d()
[   15.050171] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   15.056236] e100: Copyright(c) 1999-2006 Intel Corporation
[   15.060120] initcall 0xc0a81e28: e100_init_module+0x0/0x4d() returned 0.
[   15.066671] initcall 0xc0a81e28 ran for 11 msecs: e100_init_module+0x0/0x4d()
[   15.072510] Calling initcall 0xc0a81e75: tlan_probe+0x0/0x111()
[   15.080171] ThunderLAN driver v1.15
[   15.083751] TLAN: 0 devices installed, PCI: 0  EISA: 0
[   15.090105] initcall 0xc0a81e75: tlan_probe+0x0/0x111() returned -19.
[   15.096409] initcall 0xc0a81e75 ran for 8 msecs: tlan_probe+0x0/0x111()
[   15.102076] Calling initcall 0xc0a81f86: epic_init+0x0/0x16()
[   15.107908] initcall 0xc0a81f86: epic_init+0x0/0x16() returned 0.
[   15.113117] initcall 0xc0a81f86 ran for 0 msecs: epic_init+0x0/0x16()
[   15.120017] Calling initcall 0xc0a81f9c: sis900_init_module+0x0/0x16()
[   15.126593] initcall 0xc0a81f9c: sis900_init_module+0x0/0x16() returned 0.
[   15.133897] initcall 0xc0a81f9c ran for 0 msecs: sis900_init_module+0x0/0x16()
[   15.140013] Calling initcall 0xc0a81fb2: tg3_init+0x0/0x16()
[   15.145748] initcall 0xc0a81fb2: tg3_init+0x0/0x16() returned 0.
[   15.153030] initcall 0xc0a81fb2 ran for 0 msecs: tg3_init+0x0/0x16()
[   15.160012] Calling initcall 0xc0a81fc8: bnx2_init+0x0/0x16()
[   15.165814] initcall 0xc0a81fc8: bnx2_init+0x0/0x16() returned 0.
[   15.171210] initcall 0xc0a81fc8 ran for 0 msecs: bnx2_init+0x0/0x16()
[   15.177623] Calling initcall 0xc0a81fde: sky2_init_module+0x0/0x16()
[   15.182799] initcall 0xc0a81fde: sky2_init_module+0x0/0x16() returned 0.
[   15.191210] initcall 0xc0a81fde ran for 0 msecs: sky2_init_module+0x0/0x16()
[   15.198229] Calling initcall 0xc0a81ff4: rhine_init+0x0/0x54()
[   15.202263] initcall 0xc0a81ff4: rhine_init+0x0/0x54() returned 0.
[   15.210005] initcall 0xc0a81ff4 ran for 0 msecs: rhine_init+0x0/0x54()
[   15.216496] Calling initcall 0xc0a82048: starfire_init+0x0/0x16()
[   15.222540] initcall 0xc0a82048: starfire_init+0x0/0x16() returned 0.
[   15.228837] initcall 0xc0a82048 ran for 0 msecs: starfire_init+0x0/0x16()
[   15.232251] Calling initcall 0xc0a8205e: sundance_init+0x0/0x16()
[   15.240269] initcall 0xc0a8205e: sundance_init+0x0/0x16() returned 0.
[   15.246584] initcall 0xc0a8205e ran for 0 msecs: sundance_init+0x0/0x16()
[   15.252250] Calling initcall 0xc0a82074: hamachi_init+0x0/0x16()
[   15.260286] initcall 0xc0a82074: hamachi_init+0x0/0x16() returned 0.
[   15.266497] initcall 0xc0a82074 ran for 0 msecs: hamachi_init+0x0/0x16()
[   15.272164] Calling initcall 0xc0a820cd: net_olddevs_init+0x0/0x81()
[   15.280246] initcall 0xc0a820cd: net_olddevs_init+0x0/0x81() returned 0.
[   15.286844] initcall 0xc0a820cd ran for 0 msecs: net_olddevs_init+0x0/0x81()
[   15.292511] Calling initcall 0xc0a821c0: hp100_module_init+0x0/0x16()
[   15.300267] initcall 0xc0a821c0: hp100_module_init+0x0/0x16() returned 0.
[   15.306930] initcall 0xc0a821c0 ran for 0 msecs: hp100_module_init+0x0/0x16()
[   15.312597] Calling initcall 0xc0a826b9: b44_init+0x0/0x49()
[   15.320375] initcall 0xc0a826b9: b44_init+0x0/0x49() returned 0.
[   15.326202] initcall 0xc0a826b9 ran for 0 msecs: b44_init+0x0/0x49()
[   15.331817] Calling initcall 0xc0a82702: init_nic+0x0/0x16()
[   15.337473] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   15.340384] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 11
[   15.350006] PCI: setting IRQ 11 as level-triggered
[   15.354764] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LMAC] -> GSI 11 (level, low) -> IRQ 11
[   15.363986] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   15.910035] PM: Adding info for No Bus:eth0
[   15.910035] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
[   15.910040] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[   15.917070] initcall 0xc0a82702: init_nic+0x0/0x16() returned 0.
[   15.923063] initcall 0xc0a82702 ran for 554 msecs: init_nic+0x0/0x16()
[   15.931850] Calling initcall 0xc0a82718: ppp_init+0x0/0x83()
[   15.937483] PPP generic driver version 2.4.2
[   15.940143] PM: Adding info for No Bus:ppp
[   15.944187] initcall 0xc0a82718: ppp_init+0x0/0x83() returned 0.
[   15.951243] initcall 0xc0a82718 ran for 8 msecs: ppp_init+0x0/0x83()
[   15.957569] Calling initcall 0xc0a8279b: ppp_async_init+0x0/0x2d()
[   15.962545] initcall 0xc0a8279b: ppp_async_init+0x0/0x2d() returned 0.
[   15.970038] initcall 0xc0a8279b ran for 0 msecs: ppp_async_init+0x0/0x2d()
[   15.976877] Calling initcall 0xc0a827c8: deflate_init+0x0/0x30()
[   15.982384] PPP Deflate Compression module registered
[   15.987398] initcall 0xc0a827c8: deflate_init+0x0/0x30() returned 0.
[   15.993410] initcall 0xc0a827c8 ran for 4 msecs: deflate_init+0x0/0x30()
[   16.000038] Calling initcall 0xc0a827f8: bsdcomp_init+0x0/0x26()
[   16.006011] PPP BSD Compression module registered
[   16.010038] initcall 0xc0a827f8: bsdcomp_init+0x0/0x26() returned 0.
[   16.016357] initcall 0xc0a827f8 ran for 4 msecs: bsdcomp_init+0x0/0x26()
[   16.022197] Calling initcall 0xc0a8281e: slip_init+0x0/0xa5()
[   16.030204] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[   16.037223] CSLIP: code copyright 1989 Regents of the University of California.
[   16.040038] SLIP linefill/keepalive option.
[   16.044191] initcall 0xc0a8281e: slip_init+0x0/0xa5() returned 0.
[   16.053150] initcall 0xc0a8281e ran for 17 msecs: slip_init+0x0/0xa5()
[   16.061937] Calling initcall 0xc0a828c3: dummy_init_module+0x0/0x95()
[   16.068482] PM: Adding info for No Bus:dummy0
[   16.070528] initcall 0xc0a828c3: dummy_init_module+0x0/0x95() returned 0.
[   16.080040] initcall 0xc0a828c3 ran for 4 msecs: dummy_init_module+0x0/0x95()
[   16.087136] Calling initcall 0xc0a82fa3: rtl8139_init_module+0x0/0x16()
[   16.093006] 8139too Fast Ethernet driver 0.9.28
[   16.097839] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 11
[   16.100041] ACPI: PCI Interrupt 0000:05:07.0[A] -> Link [LNK2] -> GSI 11 (level, low) -> IRQ 11
[   16.113111] PM: Adding info for No Bus:eth1
[   16.117620] eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 11
[   16.120040] eth1:  Identified 8139 chip type 'RTL-8139B'
[   16.125412] initcall 0xc0a82fa3: rtl8139_init_module+0x0/0x16() returned 0.
[   16.134016] initcall 0xc0a82fa3 ran for 34 msecs: rtl8139_init_module+0x0/0x16()
[   16.142804] Calling initcall 0xc0a82fb9: tun_init+0x0/0x52()
[   16.148437] tun: Universal TUN/TAP device driver, 1.6
[   16.150038] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   16.160057] PM: Adding info for No Bus:tun
[   16.164189] initcall 0xc0a82fb9: tun_init+0x0/0x52() returned 0.
[   16.170038] initcall 0xc0a82fb9 ran for 14 msecs: tun_init+0x0/0x52()
[   16.176443] Calling initcall 0xc0a8300b: rtl8169_init_module+0x0/0x16()
[   16.183080] initcall 0xc0a8300b: rtl8169_init_module+0x0/0x16() returned 0.
[   16.190038] initcall 0xc0a8300b ran for 0 msecs: rtl8169_init_module+0x0/0x16()
[   16.197310] Calling initcall 0xc0a8308f: mlx4_init+0x0/0x2e()
[   16.202271] initcall 0xc0a8308f: mlx4_init+0x0/0x2e() returned 0.
[   16.208185] initcall 0xc0a8308f ran for 0 msecs: mlx4_init+0x0/0x2e()
[   16.211936] Calling initcall 0xc0a830bd: catc_init+0x0/0x33()
[   16.220291] usbcore: registered new interface driver catc
[   16.225579] drivers/net/usb/catc.c: v2.8 CATC EL1210A NetMate USB Ethernet driver
[   16.230039] initcall 0xc0a830bd: catc_init+0x0/0x33() returned 0.
[   16.240045] initcall 0xc0a830bd ran for 12 msecs: catc_init+0x0/0x33()
[   16.246530] Calling initcall 0xc0a830f0: usb_rtl8150_init+0x0/0x25()
[   16.252717] drivers/net/usb/rtl8150.c: rtl8150 based usb-ethernet driver v0.6.2 (2004/08/27)
[   16.260136] usbcore: registered new interface driver rtl8150
[   16.265666] initcall 0xc0a830f0: usb_rtl8150_init+0x0/0x25() returned 0.
[   16.273756] initcall 0xc0a830f0 ran for 13 msecs: usb_rtl8150_init+0x0/0x25()
[   16.280046] Calling initcall 0xc0a83115: asix_init+0x0/0x16()
[   16.285835] usbcore: registered new interface driver asix
[   16.290041] initcall 0xc0a83115: asix_init+0x0/0x16() returned 0.
[   16.296095] initcall 0xc0a83115 ran for 5 msecs: asix_init+0x0/0x16()
[   16.301936] Calling initcall 0xc0a8312b: cdc_init+0x0/0x16()
[   16.310286] usbcore: registered new interface driver cdc_ether
[   16.316012] initcall 0xc0a8312b: cdc_init+0x0/0x16() returned 0.
[   16.321243] initcall 0xc0a8312b ran for 5 msecs: cdc_init+0x0/0x16()
[   16.327570] Calling initcall 0xc0a83141: net1080_init+0x0/0x16()
[   16.332455] usbcore: registered new interface driver net1080
[   16.340042] initcall 0xc0a83141: net1080_init+0x0/0x16() returned 0.
[   16.346356] initcall 0xc0a83141 ran for 5 msecs: net1080_init+0x0/0x16()
[   16.352196] Calling initcall 0xc0a83157: plusb_init+0x0/0x16()
[   16.358086] usbcore: registered new interface driver plusb
[   16.360042] initcall 0xc0a83157: plusb_init+0x0/0x16() returned 0.
[   16.370046] initcall 0xc0a83157 ran for 5 msecs: plusb_init+0x0/0x16()
[   16.376529] Calling initcall 0xc0a8316d: rndis_init+0x0/0x16()
[   16.382281] usbcore: registered new interface driver rndis_host
[   16.388092] initcall 0xc0a8316d: rndis_init+0x0/0x16() returned 0.
[   16.393237] initcall 0xc0a8316d ran for 5 msecs: rndis_init+0x0/0x16()
[   16.400045] Calling initcall 0xc0a83183: zaurus_init+0x0/0x16()
[   16.406006] usbcore: registered new interface driver zaurus
[   16.410041] initcall 0xc0a83183: zaurus_init+0x0/0x16() returned 0.
[   16.416270] initcall 0xc0a83183 ran for 5 msecs: zaurus_init+0x0/0x16()
[   16.422110] Calling initcall 0xc0a83199: usbnet_init+0x0/0x26()
[   16.430210] initcall 0xc0a83199: usbnet_init+0x0/0x26() returned 0.
[   16.436444] initcall 0xc0a83199 ran for 0 msecs: usbnet_init+0x0/0x26()
[   16.442111] Calling initcall 0xc0a831da: init_netconsole+0x0/0x17a()
[   16.450206] console [netcon0] enabled
[   16.460040] netconsole: network logging started
[   16.464509] initcall 0xc0a831da: init_netconsole+0x0/0x17a() returned 0.
[   16.473756] initcall 0xc0a831da ran for 15609 msecs: init_netconsole+0x0/0x17a()
[   16.480038] Calling initcall 0xc0a83601: raid_init+0x0/0xf()
[   16.485750] initcall 0xc0a83601: raid_init+0x0/0xf() returned 0.
[   16.493064] initcall 0xc0a83601 ran for 0 msecs: raid_init+0x0/0xf()
[   16.500046] Calling initcall 0xc0a83610: spi_transport_init+0x0/0x27()
[   16.506730] initcall 0xc0a83610: spi_transport_init+0x0/0x27() returned 0.
[   16.511242] initcall 0xc0a83610 ran for 0 msecs: spi_transport_init+0x0/0x27()
[   16.520049] Calling initcall 0xc0a83637: fc_transport_init+0x0/0x43()
[   16.526773] initcall 0xc0a83637: fc_transport_init+0x0/0x43() returned 0.
[   16.533843] initcall 0xc0a83637 ran for 0 msecs: fc_transport_init+0x0/0x43()
[   16.540055] Calling initcall 0xc0a8367a: iscsi_transport_init+0x0/0xfa()
[   16.546702] Loading iSCSI transport class v2.0-867.
[   16.550430] initcall 0xc0a8367a: iscsi_transport_init+0x0/0xfa() returned 0.
[   16.557293] initcall 0xc0a8367a ran for 5 msecs: iscsi_transport_init+0x0/0xfa()
[   16.562889] Calling initcall 0xc0a83774: sas_transport_init+0x0/0x9f()
[   16.573345] initcall 0xc0a83774: sas_transport_init+0x0/0x9f() returned 0.
[   16.580062] initcall 0xc0a83774 ran for 0 msecs: sas_transport_init+0x0/0x9f()
[   16.587223] Calling initcall 0xc0a83813: sas_class_init+0x0/0x2c()
[   16.592544] initcall 0xc0a83813: sas_class_init+0x0/0x2c() returned 0.
[   16.600075] initcall 0xc0a83813 ran for 0 msecs: sas_class_init+0x0/0x2c()
[   16.606876] Calling initcall 0xc0a8383f: srp_transport_init+0x0/0x33()
[   16.613023] initcall 0xc0a8383f: srp_transport_init+0x0/0x33() returned 0.
[   16.620044] initcall 0xc0a8383f ran for 0 msecs: srp_transport_init+0x0/0x33()
[   16.627223] Calling initcall 0xc0a83872: iscsi_tcp_init+0x0/0x3a()
[   16.632660] iscsi: registered transport (tcp)
[   16.636877] initcall 0xc0a83872: iscsi_tcp_init+0x0/0x3a() returned 0.
[   16.643583] initcall 0xc0a83872 ran for 4 msecs: iscsi_tcp_init+0x0/0x3a()
[   16.650038] Calling initcall 0xc0a838ac: NCR_700_init+0x0/0x1c()
[   16.656012] initcall 0xc0a838ac: NCR_700_init+0x0/0x1c() returned 0.
[   16.663411] initcall 0xc0a838ac ran for 0 msecs: NCR_700_init+0x0/0x1c()
[   16.670038] Calling initcall 0xc0a83977: sim710_init+0x0/0x11()
[   16.675924] initcall 0xc0a83977: sim710_init+0x0/0x11() returned 0.
[   16.681243] initcall 0xc0a83977 ran for 0 msecs: sim710_init+0x0/0x11()
[   16.687829] Calling initcall 0xc0a83bd0: advansys_init+0x0/0x16()
[   16.692550] initcall 0xc0a83bd0: advansys_init+0x0/0x16() returned 0.
[   16.701243] initcall 0xc0a83bd0 ran for 0 msecs: advansys_init+0x0/0x16()
[   16.708002] Calling initcall 0xc0a84dd3: BusLogic_init+0x0/0x1158()
[   16.712675] initcall 0xc0a84dd3: BusLogic_init+0x0/0x1158() returned 0.
[   16.721244] initcall 0xc0a84dd3 ran for 0 msecs: BusLogic_init+0x0/0x1158()
[   16.728176] Calling initcall 0xc0a85f2b: init_this_scsi_driver+0x0/0xcb()
[   16.733151] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   16.740039] Detecting Adaptec I2O RAID controllers...
[   16.745058] initcall 0xc0a85f2b: init_this_scsi_driver+0x0/0xcb() returned -19.
[   16.751417] initcall 0xc0a85f2b ran for 10 msecs: init_this_scsi_driver+0x0/0xcb()
[   16.760039] Calling initcall 0xc0a85ff6: ahd_linux_init+0x0/0x6e()
[   16.766294] initcall 0xc0a85ff6: ahd_linux_init+0x0/0x6e() returned 0.
[   16.771243] initcall 0xc0a85ff6 ran for 0 msecs: ahd_linux_init+0x0/0x6e()
[   16.780044] Calling initcall 0xc0a86064: aac_init+0x0/0x5e()
[   16.785663] Adaptec aacraid driver 1.1-5[2455]-ms
[   16.790140] initcall 0xc0a86064: aac_init+0x0/0x5e() returned 0.
[   16.796010] initcall 0xc0a86064 ran for 4 msecs: aac_init+0x0/0x5e()
[   16.801850] Calling initcall 0xc0a86125: init_this_scsi_driver+0x0/0xcb()
[   16.808610] initcall 0xc0a86125: init_this_scsi_driver+0x0/0xcb() returned -19.
[   16.814364] initcall 0xc0a86125 ran for 0 msecs: init_this_scsi_driver+0x0/0xcb()
[   16.822976] Calling initcall 0xc0a861f0: NCR_D700_init+0x0/0xf()
[   16.830203] initcall 0xc0a861f0: NCR_D700_init+0x0/0xf() returned 0.
[   16.836530] initcall 0xc0a861f0 ran for 0 msecs: NCR_D700_init+0x0/0xf()
[   16.842197] Calling initcall 0xc0a862f1: NCR_Q720_init+0x0/0x29()
[   16.848265] initcall 0xc0a862f1: NCR_Q720_init+0x0/0x29() returned 0.
[   16.853496] initcall 0xc0a862f1 ran for 0 msecs: NCR_Q720_init+0x0/0x29()
[   16.862283] Calling initcall 0xc0a87b17: qla2x00_module_init+0x0/0xf7()
[   16.868879] QLogic Fibre Channel HBA Driver
[   16.870141] initcall 0xc0a87b17: qla2x00_module_init+0x0/0xf7() returned 0.
[   16.880039] initcall 0xc0a87b17 ran for 4 msecs: qla2x00_module_init+0x0/0xf7()
[   16.887309] Calling initcall 0xc0a87c0e<4>Clocksource tsc unstable (delta = 16350313422 ns)
[   16.894719] : qla4xxx_module_init+0x0/0xbd()<6>Time: pit clocksource has been installed.
[   16.900039] 
[   16.901617] iscsi: registered transport (qla4xxx)
[   16.910147] QLogic iSCSI HBA Driver
[   16.913497] initcall 0xc0a87c0e: qla4xxx_module_init+0x0/0xbd() returned 0.
[   16.920045] initcall 0xc0a87c0e ran for 7 msecs: qla4xxx_module_init+0x0/0xbd()
[   16.927301] Calling initcall 0xc0a87ccb: dmx3191d_init+0x0/0x16()
[   16.932578] initcall 0xc0a87ccb: dmx3191d_init+0x0/0x16() returned 0.
[   16.940040] initcall 0xc0a87ccb ran for 0 msecs: dmx3191d_init+0x0/0x16()
[   16.946780] Calling initcall 0xc0a87ce1: sym2_init+0x0/0xdf()
[   16.952228] initcall 0xc0a87ce1: sym2_init+0x0/0xdf() returned 0.
[   16.958168] initcall 0xc0a87ce1 ran for 0 msecs: sym2_init+0x0/0xdf()
[   16.961927] Calling initcall 0xc0a87dc0: init_this_scsi_driver+0x0/0xcb()
[   16.970215] initcall 0xc0a87dc0: init_this_scsi_driver+0x0/0xcb() returned -19.
[   16.977475] initcall 0xc0a87dc0 ran for 0 msecs: init_this_scsi_driver+0x0/0xcb()
[   16.982968] Calling initcall 0xc0a87e8b: dc390_module_init+0x0/0x80()
[   16.992805] DC390: clustering now enabled by default. If you get problems load
[   16.992807] 	with "disable_clustering=1" and report to maintainers
[   17.000159] initcall 0xc0a87e8b: dc390_module_init+0x0/0x80() returned 0.
[   17.011234] initcall 0xc0a87e8b ran for 12 msecs: dc390_module_init+0x0/0x80()
[   17.020045] Calling initcall 0xc0a87f56: megaraid_init+0x0/0xa3()
[   17.026227] initcall 0xc0a87f56: megaraid_init+0x0/0xa3() returned 0.
[   17.031234] initcall 0xc0a87f56 ran for 0 msecs: megaraid_init+0x0/0xa3()
[   17.037993] Calling initcall 0xc0a87ff9: megasas_init+0x0/0x11b()
[   17.042457] megasas: 00.00.03.16-rc1 Thu. Nov. 07 10:09:32 PDT 2007
[   17.050173] initcall 0xc0a87ff9: megasas_init+0x0/0x11b() returned 0.
[   17.056433] initcall 0xc0a87ff9 ran for 6 msecs: megasas_init+0x0/0x11b()
[   17.062274] Calling initcall 0xc0a88114: tw_init+0x0/0x25()
[   17.070203] 3ware Storage Controller device driver for Linux v1.26.02.002.
[   17.077164] initcall 0xc0a88114: tw_init+0x0/0x25() returned 0.
[   17.082967] initcall 0xc0a88114 ran for 6 msecs: tw_init+0x0/0x25()
[   17.089207] Calling initcall 0xc0a88139: twa_init+0x0/0x25()
[   17.092024] 3ware 9000 Storage Controller device driver for Linux v2.26.02.010.
[   17.100161] initcall 0xc0a88139: twa_init+0x0/0x25() returned 0.
[   17.106001] initcall 0xc0a88139 ran for 7 msecs: twa_init+0x0/0x25()
[   17.111841] Calling initcall 0xc0a8815e: init_nsp32+0x0/0x2c()
[   17.120204] nsp32: loading...
[   17.123265] initcall 0xc0a8815e: init_nsp32+0x0/0x2c() returned 0.
[   17.129295] initcall 0xc0a8815e ran for 2 msecs: init_nsp32+0x0/0x2c()
[   17.132014] Calling initcall 0xc0a8818a: ipr_init+0x0/0x2a()
[   17.140204] ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
[   17.147858] initcall 0xc0a8818a: ipr_init+0x0/0x2a() returned 0.
[   17.153054] initcall 0xc0a8818a ran for 7 msecs: ipr_init+0x0/0x2a()
[   17.160045] Calling initcall 0xc0a8827e: init_osst+0x0/0x106()
[   17.165837] osst :I: Tape driver with OnStream support version 0.99.4
[   17.165839] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   17.170133] Driver 'osst' needs updating - please use bus_type methods
[   17.176626] initcall 0xc0a8827e: init_osst+0x0/0x106() returned 0.
[   17.183228] initcall 0xc0a8827e ran for 9 msecs: init_osst+0x0/0x106()
[   17.189727] Calling initcall 0xc0a88384: init_sd+0x0/0xcf()
[   17.192060] Driver 'sd' needs updating - please use bus_type methods
[   17.200140] initcall 0xc0a88384: init_sd+0x0/0xcf() returned 0.
[   17.205914] initcall 0xc0a88384 ran for 6 msecs: init_sd+0x0/0xcf()
[   17.211753] Calling initcall 0xc0a88453: init_sg+0x0/0xaa()
[   17.217411] initcall 0xc0a88453: init_sg+0x0/0xaa() returned 0.
[   17.222968] initcall 0xc0a88453 ran for 0 msecs: init_sg+0x0/0xaa()
[   17.230049] Calling initcall 0xc0a884fd: init_ch_module+0x0/0x87()
[   17.236183] SCSI Media Changer driver v0.25 
[   17.240134] Driver 'ch' needs updating - please use bus_type methods
[   17.246449] initcall 0xc0a884fd: init_ch_module+0x0/0x87() returned 0.
[   17.253573] initcall 0xc0a884fd ran for 10 msecs: init_ch_module+0x0/0x87()
[   17.260046] Calling initcall 0xc0a88603: ahci_init+0x0/0x16()
[   17.265879] initcall 0xc0a88603: ahci_init+0x0/0x16() returned 0.
[   17.273140] initcall 0xc0a88603 ran for 0 msecs: ahci_init+0x0/0x16()
[   17.279553] Calling initcall 0xc0a88619: k2_sata_init+0x0/0x16()
[   17.282494] initcall 0xc0a88619: k2_sata_init+0x0/0x16() returned 0.
[   17.291234] initcall 0xc0a88619 ran for 0 msecs: k2_sata_init+0x0/0x16()
[   17.297907] Calling initcall 0xc0a8862f: piix_init+0x0/0x24()
[   17.302234] initcall 0xc0a8862f: piix_init+0x0/0x24() returned 0.
[   17.310039] initcall 0xc0a8862f ran for 0 msecs: piix_init+0x0/0x24()
[   17.316434] Calling initcall 0xc0a88653: pdc_ata_init+0x0/0x16()
[   17.322495] initcall 0xc0a88653: pdc_ata_init+0x0/0x16() returned 0.
[   17.328688] initcall 0xc0a88653 ran for 0 msecs: pdc_ata_init+0x0/0x16()
[   17.332188] Calling initcall 0xc0a88669: svia_init+0x0/0x16()
[   17.340328] initcall 0xc0a88669: svia_init+0x0/0x16() returned 0.
[   17.346262] initcall 0xc0a88669 ran for 0 msecs: svia_init+0x0/0x16()
[   17.351928] Calling initcall 0xc0a8867f: pdc_sata_init+0x0/0x16()
[   17.360328] initcall 0xc0a8867f: pdc_sata_init+0x0/0x16() returned 0.
[   17.366608] initcall 0xc0a8867f ran for 0 msecs: pdc_sata_init+0x0/0x16()
[   17.372274] Calling initcall 0xc0a88695: nv_init+0x0/0x16()
[   17.377951] initcall 0xc0a88695: nv_init+0x0/0x16() returned 0.
[   17.382968] initcall 0xc0a88695 ran for 0 msecs: nv_init+0x0/0x16()
[   17.390038] Calling initcall 0xc0a886ab: mv_init+0x0/0x16()
[   17.395702] initcall 0xc0a886ab: mv_init+0x0/0x16() returned 0.
[   17.401233] initcall 0xc0a886ab ran for 0 msecs: mv_init+0x0/0x16()
[   17.407473] Calling initcall 0xc0a886c1: inic_init+0x0/0x16()
[   17.412236] initcall 0xc0a886c1: inic_init+0x0/0x16() returned 0.
[   17.420040] initcall 0xc0a886c1 ran for 0 msecs: inic_init+0x0/0x16()
[   17.426434] Calling initcall 0xc0a886d7: amd_init+0x0/0x16()
[   17.432045] pata_amd 0000:00:06.0: version 0.3.10
[   17.436773] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   17.440157] scsi0 : pata_amd
[   17.442895] PM: Adding info for No Bus:host0
[   17.450225] scsi1 : pata_amd
[   17.452945] PM: Adding info for No Bus:host1
[   17.459053] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   17.460048] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   17.680569] ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
[   17.680569] ata1.00: 488397168 sectors, multi 1: LBA48 
[   17.680584] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
[   17.761097] ata1.00: configured for UDMA/100
[   18.121097] ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
[   18.121097] ata2: nv_mode_filter: 0x1f39f&0x701f->0x701f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
[   18.331097] ata2.01: configured for UDMA/33
[   18.331097] PM: Adding info for No Bus:target0:0:0
[   18.331097] scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
[   18.331148] PM: Adding info for scsi:0:0:0:0
[   18.341440] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   18.348414] sd 0:0:0:0: [sda] Write Protect is off
[   18.351102] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.356149] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.361139] PM: Adding info for No Bus:sda
[   18.371206] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   18.378210] sd 0:0:0:0: [sda] Write Protect is off
[   18.381103] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.386149] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.391103]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[   18.517640] PM: Adding info for No Bus:sda1
[   18.521802] PM: Adding info for No Bus:sda2
[   18.525982] PM: Adding info for No Bus:sda3
[   18.527575] PM: Adding info for No Bus:sda5
[   18.531614] PM: Adding info for No Bus:sda6
[   18.537449] PM: Adding info for No Bus:sda7
[   18.541481] PM: Adding info for No Bus:sda8
[   18.545641] PM: Adding info for No Bus:sda9
[   18.547315] PM: Adding info for No Bus:sda10
[   18.552487] sd 0:0:0:0: [sda] Attached SCSI disk
[   18.557567] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.562894] PM: Adding info for No Bus:target1:0:1
[   18.567721] scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
[   18.577330] PM: Adding info for scsi:1:0:1:0
[   18.581829] scsi 1:0:1:0: Attached scsi generic sg1 type 5
[   18.587550] initcall 0xc0a886d7: amd_init+0x0/0x16() returned 0.
[   18.593378] initcall 0xc0a886d7 ran for 1067 msecs: amd_init+0x0/0x16()
[   18.599088] Calling initcall 0xc0a886ed: artop_init+0x0/0x16()
[   18.607562] initcall 0xc0a886ed: artop_init+0x0/0x16() returned 0.
[   18.613595] initcall 0xc0a886ed ran for 0 msecs: artop_init+0x0/0x16()
[   18.619261] Calling initcall 0xc0a88703: cmd640_init+0x0/0x16()
[   18.625279] initcall 0xc0a88703: cmd640_init+0x0/0x16() returned 0.
[   18.630562] initcall 0xc0a88703 ran for 0 msecs: cmd640_init+0x0/0x16()
[   18.637286] Calling initcall 0xc0a88719: efar_init+0x0/0x16()
[   18.643121] initcall 0xc0a88719: efar_init+0x0/0x16() returned 0.
[   18.650388] initcall 0xc0a88719 ran for 0 msecs: efar_init+0x0/0x16()
[   18.657297] Calling initcall 0xc0a8872f: hpt36x_init+0x0/0x16()
[   18.663285] initcall 0xc0a8872f: hpt36x_init+0x0/0x16() returned 0.
[   18.668481] initcall 0xc0a8872f ran for 0 msecs: hpt36x_init+0x0/0x16()
[   18.675067] Calling initcall 0xc0a88745: hpt37x_init+0x0/0x16()
[   18.679648] initcall 0xc0a88745: hpt37x_init+0x0/0x16() returned 0.
[   18.687286] initcall 0xc0a88745 ran for 0 msecs: hpt37x_init+0x0/0x16()
[   18.693853] Calling initcall 0xc0a8875b: jmicron_init+0x0/0x16()
[   18.699732] initcall 0xc0a8875b: jmicron_init+0x0/0x16() returned 0.
[   18.705936] initcall 0xc0a8875b ran for 0 msecs: jmicron_init+0x0/0x16()
[   18.709435] Calling initcall 0xc0a88771: netcell_init+0x0/0x16()
[   18.719734] initcall 0xc0a88771: netcell_init+0x0/0x16() returned 0.
[   18.725935] initcall 0xc0a88771 ran for 0 msecs: netcell_init+0x0/0x16()
[   18.729435] Calling initcall 0xc0a88787: marvell_init+0x0/0x16()
[   18.737565] initcall 0xc0a88787: marvell_init+0x0/0x16() returned 0.
[   18.743769] initcall 0xc0a88787 ran for 0 msecs: marvell_init+0x0/0x16()
[   18.749435] Calling initcall 0xc0a8879d: oldpiix_init+0x0/0x16()
[   18.757568] initcall 0xc0a8879d: oldpiix_init+0x0/0x16() returned 0.
[   18.763768] initcall 0xc0a8879d ran for 0 msecs: oldpiix_init+0x0/0x16()
[   18.769436] Calling initcall 0xc0a887b3: pdc2027x_init+0x0/0x16()
[   18.775633] initcall 0xc0a887b3: pdc2027x_init+0x0/0x16() returned 0.
[   18.780734] initcall 0xc0a887b3 ran for 0 msecs: pdc2027x_init+0x0/0x16()
[   18.789522] Calling initcall 0xc0a887c9: pdc202xx_init+0x0/0x16()
[   18.795710] initcall 0xc0a887c9: pdc202xx_init+0x0/0x16() returned 0.
[   18.800735] initcall 0xc0a887c9 ran for 0 msecs: pdc202xx_init+0x0/0x16()
[   18.807297] Calling initcall 0xc0a887df: radisys_init+0x0/0x16()
[   18.813378] initcall 0xc0a887df: radisys_init+0x0/0x16() returned 0.
[   18.820649] initcall 0xc0a887df ran for 0 msecs: radisys_init+0x0/0x16()
[   18.827290] Calling initcall 0xc0a887f5: rz1000_init+0x0/0x16()
[   18.833284] initcall 0xc0a887f5: rz1000_init+0x0/0x16() returned 0.
[   18.838482] initcall 0xc0a887f5 ran for 0 msecs: rz1000_init+0x0/0x16()
[   18.845068] Calling initcall 0xc0a8880b: serverworks_init+0x0/0x16()
[   18.850090] initcall 0xc0a8880b: serverworks_init+0x0/0x16() returned 0.
[   18.858481] initcall 0xc0a8880b ran for 0 msecs: serverworks_init+0x0/0x16()
[   18.865502] Calling initcall 0xc0a88821: sl82c105_init+0x0/0x16()
[   18.869817] initcall 0xc0a88821: sl82c105_init+0x0/0x16() returned 0.
[   18.878482] initcall 0xc0a88821 ran for 0 msecs: sl82c105_init+0x0/0x16()
[   18.885241] Calling initcall 0xc0a88837: sis_init+0x0/0x16()
[   18.889396] initcall 0xc0a88837: sis_init+0x0/0x16() returned 0.
[   18.897288] initcall 0xc0a88837 ran for 0 msecs: sis_init+0x0/0x16()
[   18.903594] Calling initcall 0xc0a8884d: triflex_init+0x0/0x16()
[   18.909732] initcall 0xc0a8884d: triflex_init+0x0/0x16() returned 0.
[   18.915935] initcall 0xc0a8884d ran for 0 msecs: triflex_init+0x0/0x16()
[   18.919435] Calling initcall 0xc0a88863: ata_generic_init+0x0/0x16()
[   18.927577] initcall 0xc0a88863: ata_generic_init+0x0/0x16() returned 0.
[   18.934116] initcall 0xc0a88863 ran for 0 msecs: ata_generic_init+0x0/0x16()
[   18.939782] Calling initcall 0xc0a88879: fw_core_init+0x0/0x9b()
[   18.947591] initcall 0xc0a88879: fw_core_init+0x0/0x9b() returned 0.
[   18.953768] initcall 0xc0a88879 ran for 0 msecs: fw_core_init+0x0/0x9b()
[   18.959435] Calling initcall 0xc0a88a18: nonstatic_sysfs_init+0x0/0xf()
[   18.967461] initcall 0xc0a88a18: nonstatic_sysfs_init+0x0/0xf() returned 0.
[   18.974375] initcall 0xc0a88a18 ran for 0 msecs: nonstatic_sysfs_init+0x0/0xf()
[   18.980041] Calling initcall 0xc054561c: pd6729_module_init+0x0/0x16()
[   18.987580] initcall 0xc054561c: pd6729_module_init+0x0/0x16() returned 0.
[   18.994288] initcall 0xc054561c ran for 0 msecs: pd6729_module_init+0x0/0x16()
[   18.999955] Calling initcall 0xc0a88c42: mon_init+0x0/0xee()
[   19.007930] PM: Adding info for No Bus:usbmon0
[   19.012328] initcall 0xc0a88c42: mon_init+0x0/0xee() returned 0.
[   19.018480] initcall 0xc0a88c42 ran for 4 msecs: mon_init+0x0/0xee()
[   19.024807] Calling initcall 0xc0a88dff: ehci_hcd_init+0x0/0x70()
[   19.029705] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[   19.037706] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 9
[   19.043189] PCI: setting IRQ 9 as level-triggered
[   19.047286] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 9 (level, low) -> IRQ 9
[   19.057296] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   19.063511] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   19.067333] PM: Adding info for No Bus:usb_host1
[   19.072172] drivers/usb/core/inode.c: creating file 'devices'
[   19.077329] drivers/usb/core/inode.c: creating file '001'
[   19.082707] PM: Adding info for No Bus:usbmon1
[   19.087394] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   19.094668] ehci_hcd 0000:00:02.1: reset hcs_params 0x10148a dbg=1 cc=1 pcc=4 !ppc ports=10
[   19.097294] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 0 0 0 0 0 
[   19.107294] ehci_hcd 0000:00:02.1: reset hcc_params a086 caching frame 256/512/1024 park
[   19.117329] ehci_hcd 0000:00:02.1: park 0
[   19.121256] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   19.127286] ehci_hcd 0000:00:02.1: bogus port configuration: cc=1 x pcc=4 < ports=10
[   19.137295] ehci_hcd 0000:00:02.1: debug port 1
[   19.141779] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   19.147285] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[   19.152995] ehci_hcd 0000:00:02.1: irq 9, io mem 0xfeb00000
[   19.157288] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   19.167288] ehci_hcd 0000:00:02.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   19.207281] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.207282] usb usb1: default language 0x0409
[   19.207319] PM: Adding info for usb:usb1
[   19.211181] usb usb1: uevent
[   19.214125] usb usb1: usb_probe_device
[   19.217528] PM: Adding info for No Bus:usbdev1.1_ep00
[   19.222512] usb usb1: configuration #1 chosen from 1 choice
[   19.227313] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   19.233000] PM: Adding info for usb:1-0:1.0
[   19.237318] usb 1-0:1.0: uevent
[   19.240493] hub 1-0:1.0: usb_probe_interface
[   19.247286] hub 1-0:1.0: usb_probe_interface - got id
[   19.252296] hub 1-0:1.0: USB hub found
[   19.256053] hub 1-0:1.0: 10 ports detected
[   19.257300] hub 1-0:1.0: standalone hub
[   19.261082] hub 1-0:1.0: no power switching (usb 1.0)
[   19.267285] hub 1-0:1.0: individual port over-current protection
[   19.273248] hub 1-0:1.0: Single TT
[   19.277286] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[   19.283595] hub 1-0:1.0: power on to power good time: 20ms
[   19.287313] hub 1-0:1.0: local power source is good
[   19.292124] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   19.417282] hub 1-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   19.417282] PM: Adding info for No Bus:usbdev1.1_ep81
[   19.417598] PM: Adding info for No Bus:usbdev1.1
[   19.422136] drivers/usb/core/inode.c: creating file '001'
[   19.427364] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   19.434026] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.437287] usb usb1: Product: EHCI Host Controller
[   19.442121] usb usb1: Manufacturer: Linux 2.6.24 ehci_hcd
[   19.447296] usb usb1: SerialNumber: 0000:00:02.1
[   19.451984] initcall 0xc0a88dff: ehci_hcd_init+0x0/0x70() returned 0.
[   19.460735] initcall 0xc0a88dff ran for 404 msecs: ehci_hcd_init+0x0/0x70()
[   19.469522] Calling initcall 0xc0a88e6f: ohci_hcd_mod_init+0x0/0xba()
[   19.475944] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   19.477286] ohci_hcd: block sizes: ed 64 td 64
[   19.487959] ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 11
[   19.493527] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 11 (level, low) -> IRQ 11
[   19.501262] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   19.507295] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   19.512504] PM: Adding info for No Bus:usb_host2
[   19.517394] drivers/usb/core/inode.c: creating file '002'
[   19.522864] PM: Adding info for No Bus:usbmon2
[   19.527397] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   19.534798] ohci_hcd 0000:00:02.0: created debug files
[   19.537301] ohci_hcd 0000:00:02.0: irq 11, io mem 0xda102000
[   19.617282] ohci_hcd 0000:00:02.0: OHCI controller state
[   19.617282] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[   19.617288] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[   19.627285] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[   19.632730] ohci_hcd 0000:00:02.0: intrstatus 0x00000004 SF
[   19.637287] ohci_hcd 0000:00:02.0: intrenable 0x8000004a MIE RHSC RD WDH
[   19.643943] ohci_hcd 0000:00:02.0: hcca frame #0027
[   19.647287] ohci_hcd 0000:00:02.0: roothub.a 0100020a POTPGT=1 NPS NDP=10(10)
[   19.657287] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[   19.663857] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[   19.667286] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[   19.677287] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[   19.683944] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[   19.687286] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[   19.697287] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00000100 PPS
[   19.703943] ohci_hcd 0000:00:02.0: roothub.portstatus [5] 0x00000100 PPS
[   19.707286] ohci_hcd 0000:00:02.0: roothub.portstatus [6] 0x00000100 PPS
[   19.717287] ohci_hcd 0000:00:02.0: roothub.portstatus [7] 0x00000100 PPS
[   19.723943] ohci_hcd 0000:00:02.0: roothub.portstatus [8] 0x00000100 PPS
[   19.727286] ohci_hcd 0000:00:02.0: roothub.portstatus [9] 0x00000100 PPS
[   19.737316] usb usb2: default language 0x0409
[   19.741636] PM: Adding info for usb:usb2
[   19.745516] usb usb2: uevent
[   19.747380] usb usb2: usb_probe_device
[   19.751089] PM: Adding info for No Bus:usbdev2.1_ep00
[   19.757332] usb usb2: configuration #1 chosen from 1 choice
[   19.762754] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   19.767296] PM: Adding info for usb:2-0:1.0
[   19.771439] usb 2-0:1.0: uevent
[   19.774649] hub 2-0:1.0: usb_probe_interface
[   19.777293] hub 2-0:1.0: usb_probe_interface - got id
[   19.782295] hub 2-0:1.0: USB hub found
[   19.787298] hub 2-0:1.0: 10 ports detected
[   19.791342] hub 2-0:1.0: standalone hub
[   19.795155] hub 2-0:1.0: no power switching (usb 1.0)
[   19.797286] hub 2-0:1.0: global over-current protection
[   19.802470] hub 2-0:1.0: power on to power good time: 2ms
[   19.807296] hub 2-0:1.0: local power source is good
[   19.812122] hub 2-0:1.0: no over-current condition exists
[   19.817287] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   19.947282] hub 2-0:1.0: state 7 ports 10 chg 0000 evt 0000
[   19.947282] PM: Adding info for No Bus:usbdev2.1_ep81
[   19.947433] PM: Adding info for No Bus:usbdev2.1
[   19.951955] drivers/usb/core/inode.c: creating file '001'
[   19.957509] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   19.964115] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   19.967286] usb usb2: Product: OHCI Host Controller
[   19.972121] usb usb2: Manufacturer: Linux 2.6.24 ohci_hcd
[   19.977297] usb usb2: SerialNumber: 0000:00:02.0
[   19.982097] initcall 0xc0a88e6f: ohci_hcd_mod_init+0x0/0xba() returned 0.
[   19.991082] initcall 0xc0a88e6f ran for 486 msecs: ohci_hcd_mod_init+0x0/0xba()
[   19.999869] Calling initcall 0xc0a88f29: uhci_hcd_init+0x0/0xc3()
[   20.005945] USB Universal Host Controller Interface driver v3.0
[   20.007434] initcall 0xc0a88f29: uhci_hcd_init+0x0/0xc3() returned 0.
[   20.018482] initcall 0xc0a88f29 ran for 5 msecs: uhci_hcd_init+0x0/0xc3()
[   20.025241] Calling initcall 0xc0a88fec: sl811h_init+0x0/0x38()
[   20.029532] sl811: driver sl811-hcd, 19 May 2005
[   20.034232] initcall 0xc0a88fec: sl811h_init+0x0/0x38() returned 0.
[   20.040561] initcall 0xc0a88fec ran for 4 msecs: sl811h_init+0x0/0x38()
[   20.047290] Calling initcall 0xc0a89024: acm_init+0x0/0xd8()
[   20.053014] usbcore: registered new interface driver cdc_acm
[   20.057291] drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
[   20.067300] initcall 0xc0a89024: acm_init+0x0/0xd8() returned 0.
[   20.073247] initcall 0xc0a89024 ran for 15 msecs: acm_init+0x0/0xd8()
[   20.079089] Calling initcall 0xc0a890fc: usblp_init+0x0/0x16()
[   20.087545] usbcore: registered new interface driver usblp
[   20.092912] initcall 0xc0a890fc: usblp_init+0x0/0x16() returned 0.
[   20.098482] initcall 0xc0a890fc ran for 5 msecs: usblp_init+0x0/0x16()
[   20.104981] Calling initcall 0xc0a89112: usb_usual_init+0x0/0x4b()
[   20.109887] usbcore: registered new interface driver libusual
[   20.117298] initcall 0xc0a89112: usb_usual_init+0x0/0x4b() returned 0.
[   20.123767] initcall 0xc0a89112 ran for 5 msecs: usb_usual_init+0x0/0x4b()
[   20.129608] Calling initcall 0xc0a8915d: usb_mdc800_init+0x0/0x214()
[   20.137546] usbcore: registered new interface driver mdc800
[   20.142992] drivers/usb/image/mdc800.c: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[   20.147295] initcall 0xc0a8915d: usb_mdc800_init+0x0/0x214() returned 0.
[   20.158482] initcall 0xc0a8915d ran for 14 msecs: usb_mdc800_init+0x0/0x214()
[   20.165588] Calling initcall 0xc0a89371: microtek_drv_init+0x0/0x16()
[   20.170150] usbcore: registered new interface driver microtekX6
[   20.177300] initcall 0xc0a89371: microtek_drv_init+0x0/0x16() returned 0.
[   20.184027] initcall 0xc0a89371 ran for 5 msecs: microtek_drv_init+0x0/0x16()
[   20.189868] Calling initcall 0xc0a89387: usb_serial_init+0x0/0x1ce()
[   20.197661] usbcore: registered new interface driver usbserial
[   20.203425] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   20.207389] usbcore: registered new interface driver usbserial_generic
[   20.217305] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   20.223517] initcall 0xc0a89387: usb_serial_init+0x0/0x1ce() returned 0.
[   20.230995] initcall 0xc0a89387 ran for 25 msecs: usb_serial_init+0x0/0x1ce()
[   20.239782] Calling initcall 0xc0a89555: belkin_sa_init+0x0/0x4f()
[   20.246042] drivers/usb/serial/usb-serial.c: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[   20.257327] usbcore: registered new interface driver belkin
[   20.262742] drivers/usb/serial/belkin_sa.c: USB Belkin Serial converter driver v1.2
[   20.267304] initcall 0xc0a89555: belkin_sa_init+0x0/0x4f() returned 0.
[   20.273768] initcall 0xc0a89555 ran for 23 msecs: belkin_sa_init+0x0/0x4f()
[   20.279608] Calling initcall 0xc0a895a4: ch341_init+0x0/0x3a()
[   20.289543] drivers/usb/serial/usb-serial.c: USB Serial support registered for ch341-uart
[   20.297383] usbcore: registered new interface driver ch341
[   20.302738] initcall 0xc0a895a4: ch341_init+0x0/0x3a() returned 0.
[   20.308482] initcall 0xc0a895a4 ran for 12 msecs: ch341_init+0x0/0x3a()
[   20.315067] Calling initcall 0xc0a895de: cyberjack_init+0x0/0x5f()
[   20.319890] drivers/usb/serial/usb-serial.c: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[   20.327387] usbcore: registered new interface driver cyberjack
[   20.337294] drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle
[   20.343508] drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
[   20.347294] initcall 0xc0a895de: cyberjack_init+0x0/0x5f() returned 0.
[   20.358483] initcall 0xc0a895de ran for 30 msecs: cyberjack_init+0x0/0x5f()
[   20.367285] Calling initcall 0xc0a8963d: debug_init+0x0/0x3a()
[   20.373183] drivers/usb/serial/usb-serial.c: USB Serial support registered for debug
[   20.377385] usbcore: registered new interface driver debug
[   20.382737] initcall 0xc0a8963d: debug_init+0x0/0x3a() returned 0.
[   20.390474] initcall 0xc0a8963d ran for 12 msecs: debug_init+0x0/0x3a()
[   20.397286] Calling initcall 0xc0a89677: digi_init+0x0/0x69()
[   20.403096] drivers/usb/serial/usb-serial.c: USB Serial support registered for Digi 2 port USB adapter
[   20.407381] drivers/usb/serial/usb-serial.c: USB Serial support registered for Digi 4 port USB adapter
[   20.417398] usbcore: registered new interface driver digi_acceleport
[   20.427286] drivers/usb/serial/digi_acceleport.c: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
[   20.437307] initcall 0xc0a89677: digi_init+0x0/0x69() returned 0.
[   20.443335] initcall 0xc0a89677 ran for 33 msecs: digi_init+0x0/0x69()
[   20.449174] Calling initcall 0xc0a896e0: edgeport_init+0x0/0xab()
[   20.457551] drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 2 port adapter
[   20.467381] drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 4 port adapter
[   20.476635] drivers/usb/serial/usb-serial.c: USB Serial support registered for Edgeport 8 port adapter
[   20.477391] drivers/usb/serial/usb-serial.c: USB Serial support registered for EPiC device
[   20.487400] usbcore: registered new interface driver io_edgeport
[   20.497306] drivers/usb/serial/io_edgeport.c: Edgeport USB Serial Driver v2.7
[   20.507294] initcall 0xc0a896e0: edgeport_init+0x0/0xab() returned 0.
[   20.513681] initcall 0xc0a896e0 ran for 46 msecs: edgeport_init+0x0/0xab()
[   20.519521] Calling initcall 0xc0a8978b: empeg_init+0x0/0xf1()
[   20.525462] drivers/usb/serial/usb-serial.c: USB Serial support registered for empeg
[   20.527383] usbcore: registered new interface driver empeg
[   20.537305] drivers/usb/serial/empeg.c: v1.2:USB Empeg Mark I/II Driver
[   20.543864] initcall 0xc0a8978b: empeg_init+0x0/0xf1() returned 0.
[   20.550475] initcall 0xc0a8978b ran for 18 msecs: empeg_init+0x0/0xf1()
[   20.557297] Calling initcall 0xc0a8987c: ftdi_init+0x0/0xb0()
[   20.563096] drivers/usb/serial/usb-serial.c: USB Serial support registered for FTDI USB Serial Device
[   20.567382] usbcore: registered new interface driver ftdi_sio
[   20.577295] drivers/usb/serial/ftdi_sio.c: v1.4.3:USB FTDI Serial Converters Driver
[   20.587300] initcall 0xc0a8987c: ftdi_init+0x0/0xb0() returned 0.
[   20.593335] initcall 0xc0a8987c ran for 21 msecs: ftdi_init+0x0/0xb0()
[   20.599175] Calling initcall 0xc0a8992c: iuu_init+0x0/0x4f()
[   20.604916] drivers/usb/serial/usb-serial.c: USB Serial support registered for iuu_phoenix
[   20.607391] usbcore: registered new interface driver iuu_phoenix
[   20.617297] drivers/usb/serial/iuu_phoenix.c: Infinity USB Unlimited Phoenix driver v0.5
[   20.627294] initcall 0xc0a8992c: iuu_init+0x0/0x4f() returned 0.
[   20.633249] initcall 0xc0a8992c ran for 21 msecs: iuu_init+0x0/0x4f()
[   20.639088] Calling initcall 0xc0a8997b: keyspan_init+0x0/0xa1()
[   20.645170] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan - (without firmware)
[   20.647381] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 1 port adapter
[   20.657400] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 2 port adapter
[   20.667381] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan 4 port adapter
[   20.677396] usbcore: registered new interface driver keyspan
[   20.687297] drivers/usb/serial/keyspan.c: v1.1.5:Keyspan USB to Serial Converter Driver
[   20.695250] initcall 0xc0a8997b: keyspan_init+0x0/0xa1() returned 0.
[   20.700649] initcall 0xc0a8997b ran for 48 msecs: keyspan_init+0x0/0xa1()
[   20.709435] Calling initcall 0xc0a89a1c: keyspan_pda_init+0x0/0x83()
[   20.715861] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA
[   20.717377] drivers/usb/serial/usb-serial.c: USB Serial support registered for Keyspan PDA - (prerenumeration)
[   20.727398] drivers/usb/serial/usb-serial.c: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[   20.737383] usbcore: registered new interface driver keyspan_pda
[   20.747298] drivers/usb/serial/keyspan_pda.c: USB Keyspan PDA Converter driver v1.1
[   20.757295] initcall 0xc0a89a1c: keyspan_pda_init+0x0/0x83() returned 0.
[   20.763942] initcall 0xc0a89a1c ran for 40 msecs: keyspan_pda_init+0x0/0x83()
[   20.769782] Calling initcall 0xc0a89a9f: kobil_init+0x0/0x5f()
[   20.777543] drivers/usb/serial/usb-serial.c: USB Serial support registered for KOBIL USB smart card terminal
[   20.787381] usbcore: registered new interface driver kobil
[   20.792729] drivers/usb/serial/kobil_sct.c: 21/05/2004 KOBIL Systems GmbH - http://www.kobil.com
[   20.797298] drivers/usb/serial/kobil_sct.c: KOBIL USB Smart Card Terminal Driver (experimental)
[   20.807294] initcall 0xc0a89a9f: kobil_init+0x0/0x5f() returned 0.
[   20.817287] initcall 0xc0a89a9f ran for 31 msecs: kobil_init+0x0/0x5f()
[   20.823855] Calling initcall 0xc0a89afe: mct_u232_init+0x0/0x4f()
[   20.829811] drivers/usb/serial/usb-serial.c: USB Serial support registered for MCT U232
[   20.837389] usbcore: registered new interface driver mct_u232
[   20.842988] drivers/usb/serial/mct_u232.c: Magic Control Technology USB-RS232 converter driver z2.1
[   20.847304] initcall 0xc0a89afe: mct_u232_init+0x0/0x4f() returned 0.
[   20.858481] initcall 0xc0a89afe ran for 21 msecs: mct_u232_init+0x0/0x4f()
[   20.865327] Calling initcall 0xc0a89b4d: moschip7720_init+0x0/0x6d()
[   20.870058] drivers/usb/serial/usb-serial.c: USB Serial support registered for Moschip 2 port adapter
[   20.877287] drivers/usb/serial/mos7720.c: Moschip USB Serial Driver 1.0.0.4F
[   20.887388] usbcore: registered new interface driver moschip7720
[   20.893257] initcall 0xc0a89b4d: moschip7720_init+0x0/0x6d() returned 0.
[   20.900994] initcall 0xc0a89b4d ran for 21 msecs: moschip7720_init+0x0/0x6d()
[   20.907291] Calling initcall 0xc0a89bba: safe_init+0x0/0xfe()
[   20.912998] drivers/usb/serial/safe_serial.c: v0.0b sl@lineo.com, tbr@lineo.com
[   20.917286] drivers/usb/serial/safe_serial.c: USB Safe Encapsulated Serial
[   20.927286] drivers/usb/serial/safe_serial.c: vendor: 0 product: 0 safe: 1 padded: 0
[   20.927287] 
[   20.937388] drivers/usb/serial/usb-serial.c: USB Serial support registered for safe_serial
[   20.945612] usbcore: registered new interface driver safe_serial
[   20.947296] initcall 0xc0a89bba: safe_init+0x0/0xfe() returned 0.
[   20.957292] initcall 0xc0a89bba ran for 35 msecs: safe_init+0x0/0xfe()
[   20.963768] Calling initcall 0xc0a89cb8: ti_init+0x0/0xf5()
[   20.969278] drivers/usb/serial/usb-serial.c: USB Serial support registered for TI USB 3410 1 port adapter
[   20.977397] drivers/usb/serial/usb-serial.c: USB Serial support registered for TI USB 5052 2 port adapter
[   20.987390] usbcore: registered new interface driver ti_usb_3410_5052
[   20.993682] drivers/usb/serial/ti_usb_3410_5052.c: TI USB 3410/5052 Serial Driver v0.9
[   20.997296] initcall 0xc0a89cb8: ti_init+0x0/0xf5() returned 0.
[   21.008482] initcall 0xc0a89cb8 ran for 31 msecs: ti_init+0x0/0xf5()
[   21.014809] Calling initcall 0xc0a89dad: visor_init+0x0/0x17e()
[   21.019631] drivers/usb/serial/usb-serial.c: USB Serial support registered for Handspring Visor / Palm OS
[   21.027395] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 3.5
[   21.037385] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 5.0
[   21.047396] usbcore: registered new interface driver visor
[   21.052729] drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS driver
[   21.057308] initcall 0xc0a89dad: visor_init+0x0/0x17e() returned 0.
[   21.063507] initcall 0xc0a89dad ran for 37 msecs: visor_init+0x0/0x17e()
[   21.069349] Calling initcall 0xc0a89f2b: whiteheat_init+0x0/0x69()<7>ohci_hcd 0000:00:02.0: auto-stop root hub
[   21.081259] 
[   21.082833] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[   21.087396] drivers/usb/serial/usb-serial.c: USB Serial support registered for Connect Tech - WhiteHEAT
[   21.097391] usbcore: registered new interface driver whiteheat
[   21.107286] drivers/usb/serial/whiteheat.c: USB ConnectTech WhiteHEAT driver v2.0
[   21.117307] initcall 0xc0a89f2b: whiteheat_init+0x0/0x69() returned 0.
[   21.123769] initcall 0xc0a89f2b ran for 32 msecs: whiteheat_init+0x0/0x69()
[   21.129608] Calling initcall 0xc0a89f94: adu_init+0x0/0x8e()
[   21.137296] drivers/usb/misc/adutux.c :  adu_init : enter 
[   21.142828] usbcore: registered new interface driver adutux
[   21.147289] drivers/usb/misc/adutux.c: adutux adutux (see www.ontrak.net) v0.0.13
[   21.154721] drivers/usb/misc/adutux.c: adutux is an experimental driver. Use at your own risk
[   21.157293] drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
[   21.167294] initcall 0xc0a89f94: adu_init+0x0/0x8e() returned 0.
[   21.173248] initcall 0xc0a89f94 ran for 32 msecs: adu_init+0x0/0x8e()
[   21.179089] Calling initcall 0xc0a8a022: appledisplay_init+0x0/0x54()
[   21.187611] usbcore: registered new interface driver appledisplay
[   21.193538] initcall 0xc0a8a022: appledisplay_init+0x0/0x54() returned 0.
[   21.201082] initcall 0xc0a8a022 ran for 5 msecs: appledisplay_init+0x0/0x54()
[   21.209869] Calling initcall 0xc0a8a076: auerswald_init+0x0/0x43()
[   21.216031] drivers/usb/misc/auerswald.c: init
[   21.217381] usbcore: registered new interface driver auerswald
[   21.223087] initcall 0xc0a8a076: auerswald_init+0x0/0x43() returned 0.
[   21.230821] initcall 0xc0a8a076 ran for 9 msecs: auerswald_init+0x0/0x43()
[   21.239609] Calling initcall 0xc0a8a0b9: berry_init+0x0/0x16()
[   21.245537] usbcore: registered new interface driver berry_charge
[   21.247297] initcall 0xc0a8a0b9: berry_init+0x0/0x16() returned 0.
[   21.257293] initcall 0xc0a8a0b9 ran for 5 msecs: berry_init+0x0/0x16()
[   21.263769] Calling initcall 0xc0a8a0cf: cypress_init+0x0/0x35()
[   21.269712] usbcore: registered new interface driver cypress_cy7c63
[   21.275860] initcall 0xc0a8a0cf: cypress_init+0x0/0x35() returned 0.
[   21.280649] initcall 0xc0a8a0cf ran for 5 msecs: cypress_init+0x0/0x35()
[   21.287291] Calling initcall 0xc0a8a104: usb_cytherm_init+0x0/0x48()
[   21.293715] usbcore: registered new interface driver cytherm
[   21.297291] drivers/usb/misc/cytherm.c: v1.0:Cypress USB Thermometer driver
[   21.307301] initcall 0xc0a8a104: usb_cytherm_init+0x0/0x48() returned 0.
[   21.313942] initcall 0xc0a8a104 ran for 12 msecs: usb_cytherm_init+0x0/0x48()
[   21.319782] Calling initcall 0xc0a8a14c: emi62_init+0x0/0x2d()
[   21.327545] usbcore: registered new interface driver emi62 - firmware loader
[   21.334473] initcall 0xc0a8a14c: emi62_init+0x0/0x2d() returned 0.
[   21.340474] initcall 0xc0a8a14c ran for 6 msecs: emi62_init+0x0/0x2d()
[   21.347291] Calling initcall 0xc0a8a179: ftdi_elan_init+0x0/0x131()
[   21.353518] driver ftdi-elan built at 11:32:22 on Feb  2 2008
[   21.357543] usbcore: registered new interface driver ftdi-elan
[   21.363208] initcall 0xc0a8a179: ftdi_elan_init+0x0/0x131() returned 0.
[   21.370908] initcall 0xc0a8a179 ran for 11 msecs: ftdi_elan_init+0x0/0x131()
[   21.377297] Calling initcall 0xc0a8a2aa: iowarrior_init+0x0/0x16()
[   21.383529] usbcore: registered new interface driver iowarrior
[   21.387297] initcall 0xc0a8a2aa: iowarrior_init+0x0/0x16() returned 0.
[   21.397294] initcall 0xc0a8a2aa ran for 5 msecs: iowarrior_init+0x0/0x16()
[   21.404114] Calling initcall 0xc0a8a2c0: init_phidget+0x0/0x27()
[   21.409724] initcall 0xc0a8a2c0: init_phidget+0x0/0x27() returned 0.
[   21.415934] initcall 0xc0a8a2c0 ran for 0 msecs: init_phidget+0x0/0x27()
[   21.419435] Calling initcall 0xc0a8a2e7: usbtest_init+0x0/0x40()
[   21.427567] usbcore: registered new interface driver usbtest
[   21.433086] initcall 0xc0a8a2e7: usbtest_init+0x0/0x40() returned 0.
[   21.440647] initcall 0xc0a8a2e7 ran for 5 msecs: usbtest_init+0x0/0x40()
[   21.447292] Calling initcall 0xc0a8a327: tv_init+0x0/0x48()
[   21.452926] usbcore: registered new interface driver trancevibrator
[   21.457291] drivers/usb/misc/trancevibrator.c: v1.1:PlayStation 2 Trance Vibrator driver
[   21.467299] initcall 0xc0a8a327: tv_init+0x0/0x48() returned 0.
[   21.473162] initcall 0xc0a8a327 ran for 13 msecs: tv_init+0x0/0x48()
[   21.479001] Calling initcall 0xc0a8a36f: init+0x0/0x16()
[   21.484428] initcall 0xc0a8a36f: init+0x0/0x16() returned 0.
[   21.489954] initcall 0xc0a8a36f ran for 0 msecs: init+0x0/0x16()
[   21.495933] Calling initcall 0xc0a8a385: fsg_init+0x0/0x8c()
[   21.499281] initcall 0xc0a8a385: fsg_init+0x0/0x8c() returned -19.
[   21.508655] initcall 0xc0a8a385 ran for 0 msecs: fsg_init+0x0/0x8c()
[   21.514982] Calling initcall 0xc0a8ae33: i8042_init+0x0/0x306()
[   21.519768] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[   21.527447] PM: Adding info for platform:i8042
[   21.534414] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.537305] PM: Adding info for serio:serio0
[   21.541610] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.547328] PM: Adding info for serio:serio1
[   21.551628] initcall 0xc0a8ae33: i8042_init+0x0/0x306() returned 0.
[   21.558482] initcall 0xc0a8ae33 ran for 31 msecs: i8042_init+0x0/0x306()
[   21.565155] Calling initcall 0xc0a8b139: serport_init+0x0/0x2b()
[   21.569627] initcall 0xc0a8b139: serport_init+0x0/0x2b() returned 0.
[   21.578482] initcall 0xc0a8b139 ran for 0 msecs: serport_init+0x0/0x2b()
[   21.585154] Calling initcall 0xc0a8b164: ct82c710_init+0x0/0x16d()
[   21.589816] initcall 0xc0a8b164: ct82c710_init+0x0/0x16d() returned -19.
[   21.597286] initcall 0xc0a8b164 ran for 0 msecs: ct82c710_init+0x0/0x16d()
[   21.604116] Calling initcall 0xc0a8b2d1: serio_raw_init+0x0/0x16()
[   21.609897] initcall 0xc0a8b2d1: serio_raw_init+0x0/0x16() returned 0.
[   21.617287] initcall 0xc0a8b2d1 ran for 0 msecs: serio_raw_init+0x0/0x16()
[   21.624115] Calling initcall 0xc0a8b369: emu_init+0x0/0x16()
[   21.629404] initcall 0xc0a8b369: emu_init+0x0/0x16() returned 0.
[   21.635241] initcall 0xc0a8b369 ran for 0 msecs: emu_init+0x0/0x16()
[   21.639088] Calling initcall 0xc0a8b37f: l4_init+0x0/0x22f()
[   21.647473] initcall 0xc0a8b37f: l4_init+0x0/0x22f() returned -19.
[   21.653595] initcall 0xc0a8b37f ran for 0 msecs: l4_init+0x0/0x22f()
[   21.659089] Calling initcall 0xc0a8b6a1: mousedev_init+0x0/0x51()
[   21.665200] PM: Adding info for No Bus:mice
[   21.667373] mice: PS/2 mouse device common for all mice
[   21.672477] initcall 0xc0a8b6a1: mousedev_init+0x0/0x51() returned 0.
[   21.680734] initcall 0xc0a8b6a1 ran for 8 msecs: mousedev_init+0x0/0x51()
[   21.689521] Calling initcall 0xc0a8b6f2: evdev_init+0x0/0xf()
[   21.695308] PM: Adding info for No Bus:event0
[   21.697432] PM: Adding info for No Bus:event1
[   21.701697] initcall 0xc0a8b6f2: evdev_init+0x0/0xf() returned 0.
[   21.708482] initcall 0xc0a8b6f2 ran for 8 msecs: evdev_init+0x0/0xf()
[   21.714894] Calling initcall 0xc0a8b701: atkbd_init+0x0/0x16()
[   21.719636] initcall 0xc0a8b701: atkbd_init+0x0/0x16() returned 0.
[   21.728482] initcall 0xc0a8b701 ran for 0 msecs: atkbd_init+0x0/0x16()
[   21.734981] Calling initcall 0xc0a8b717: lkkbd_init+0x0/0x16()
[   21.759509] PM: Adding info for No Bus:input2
[   21.759509] input: AT Translated Set 2 keyboard as /class/input/input2
[   21.759591] PM: Adding info for No Bus:event2
[   21.780094] initcall 0xc0a8b717: lkkbd_init+0x0/0x16() returned 0.
[   21.781294] initcall 0xc0a8b717 ran for 30 msecs: lkkbd_init+0x0/0x16()
[   21.787880] Calling initcall 0xc0a8b72d: nkbd_init+0x0/0x16()
[   21.792307] initcall 0xc0a8b72d: nkbd_init+0x0/0x16() returned 0.
[   21.798228] initcall 0xc0a8b72d ran for 0 msecs: nkbd_init+0x0/0x16()
[   21.801988] Calling initcall 0xc0a8b743: gtco_init+0x0/0x48()
[   21.812277] usbcore: registered new interface driver gtco
[   21.817538] GTCO usb driver version: 2.00.0006initcall 0xc0a8b743: gtco_init+0x0/0x48() returned 0.
[   21.824848] initcall 0xc0a8b743 ran for 9 msecs: gtco_init+0x0/0x48()
[   21.831987] Calling initcall 0xc0a8b78b: wacom_init+0x0/0x3d()
[   21.837916] usbcore: registered new interface driver wacom
[   21.840103] drivers/input/tablet/wacom_sys.c: v1.47:USB Wacom Graphire and Wacom Intuos tablet driver
[   21.850113] initcall 0xc0a8b78b: wacom_init+0x0/0x3d() returned 0.
[   21.856235] initcall 0xc0a8b78b ran for 13 msecs: wacom_init+0x0/0x3d()
[   21.862074] Calling initcall 0xc0a8b7c8: elo_init+0x0/0x16()
[   21.870387] initcall 0xc0a8b7c8: elo_init+0x0/0x16() returned 0.
[   21.876234] initcall 0xc0a8b7c8 ran for 0 msecs: elo_init+0x0/0x16()
[   21.881900] Calling initcall 0xc0a8b7de: mk712_init+0x0/0x1b4()
[   21.887805] mk712: device not present
[   21.890114] initcall 0xc0a8b7de: mk712_init+0x0/0x1b4() returned -19.
[   21.896495] initcall 0xc0a8b7de ran for 3 msecs: mk712_init+0x0/0x1b4()
[   21.902161] Calling initcall 0xc0a8b992: pm_init+0x0/0x16()
[   21.912121] initcall 0xc0a8b992: pm_init+0x0/0x16() returned 0.
[   21.917882] initcall 0xc0a8b992 ran for 0 msecs: pm_init+0x0/0x16()
[   21.921815] Calling initcall 0xc0a8b9a8: tw_init+0x0/0x16()
[   21.927492] initcall 0xc0a8b9a8: tw_init+0x0/0x16() returned 0.
[   21.933027] initcall 0xc0a8b9a8 ran for 0 msecs: tw_init+0x0/0x16()
[   21.941814] Calling initcall 0xc0a8b9be: ucb1400_ts_init+0x0/0xf()
[   21.948086] initcall 0xc0a8b9be: ucb1400_ts_init+0x0/0xf() returned 0.
[   21.953634] initcall 0xc0a8b9be ran for 0 msecs: ucb1400_ts_init+0x0/0xf()
[   21.960108] Calling initcall 0xc0a8b9cd: atlas_acpi_init+0x0/0x35()
[   21.966482] initcall 0xc0a8b9cd: atlas_acpi_init+0x0/0x35() returned 0.
[   21.973721] initcall 0xc0a8b9cd ran for 0 msecs: atlas_acpi_init+0x0/0x35()
[   21.980105] Calling initcall 0xc0a8ba02: ati_remote_init+0x0/0x3b()
[   21.986441] usbcore: registered new interface driver ati_remote
[   21.990102] drivers/input/misc/ati_remote.c: Registered USB driver ATI/X10 RF USB Remote Control v. 2.2.1
[   22.000113] initcall 0xc0a8ba02: ati_remote_init+0x0/0x3b() returned 0.
[   22.006667] initcall 0xc0a8ba02 ran for 14 msecs: ati_remote_init+0x0/0x3b()
[   22.012508] Calling initcall 0xc0a8ba3d: ati_remote2_init+0x0/0x3c()
[   22.022870] usbcore: registered new interface driver ati_remote2
[   22.028750] ati_remote2: ATI/Philips USB RF remote driver 0.2
[   22.030107] initcall 0xc0a8ba3d: ati_remote2_init+0x0/0x3c() returned 0.
[   22.040105] initcall 0xc0a8ba3d ran for 11 msecs: ati_remote2_init+0x0/0x3c()
[   22.047187] Calling initcall 0xc0a8ba79: usb_keyspan_init+0x0/0x35()
[   22.052876] usbcore: registered new interface driver keyspan_remote
[   22.060112] initcall 0xc0a8ba79: usb_keyspan_init+0x0/0x35() returned 0.
[   22.066754] initcall 0xc0a8ba79 ran for 5 msecs: usb_keyspan_init+0x0/0x35()
[   22.072594] Calling initcall 0xc0a8baae: powermate_init+0x0/0x16()<7>hub 2-0:1.0: hub_suspend
[   22.082627] usb usb2: bus auto-suspend
[   22.086323] ohci_hcd 0000:00:02.0: suspend root hub
[   22.090103] hub 1-0:1.0: hub_suspend
[   22.093651] usb usb1: bus auto-suspend
[   22.097360] ehci_hcd 0000:00:02.1: suspend root hub
[   22.100123] 
[   22.101667] usbcore: registered new interface driver powermate
[   22.110110] initcall 0xc0a8baae: powermate_init+0x0/0x16() returned 0.
[   22.116581] initcall 0xc0a8baae ran for 5 msecs: powermate_init+0x0/0x16()
[   22.122420] Calling initcall 0xc0a8bac4: yealink_dev_init+0x0/0x33()
[   22.130375] usbcore: registered new interface driver yealink
[   22.135892] drivers/input/misc/yealink.c: Yealink phone driver:yld-20051230
[   22.140109] initcall 0xc0a8bac4: yealink_dev_init+0x0/0x33() returned 0.
[   22.146754] initcall 0xc0a8bac4 ran for 12 msecs: yealink_dev_init+0x0/0x33()
[   22.152594] Calling initcall 0xc0a8baf7: i2o_iop_init+0x0/0x41()
[   22.162430] I2O subsystem v1.325
[   22.165627] i2o: max drivers = 8
[   22.169257] initcall 0xc0a8baf7: i2o_iop_init+0x0/0x41() returned 0.
[   22.173460] initcall 0xc0a8baf7 ran for 6 msecs: i2o_iop_init+0x0/0x41()
[   22.182248] Calling initcall 0xc0a8bc16: i2o_bus_init+0x0/0x37()
[   22.188237] I2O Bus Adapter OSM v1.317
[   22.190212] initcall 0xc0a8bc16: i2o_bus_init+0x0/0x37() returned 0.
[   22.196407] initcall 0xc0a8bc16 ran for 3 msecs: i2o_bus_init+0x0/0x37()
[   22.202248] Calling initcall 0xc0a8bcd3: ds1742_init+0x0/0xf()
[   22.210352] initcall 0xc0a8bcd3: ds1742_init+0x0/0xf() returned 0.
[   22.216407] initcall 0xc0a8bcd3 ran for 0 msecs: ds1742_init+0x0/0xf()
[   22.222073] Calling initcall 0xc0a8bce2: stk17ta8_init+0x0/0xf()
[   22.228170] initcall 0xc0a8bce2: stk17ta8_init+0x0/0xf() returned 0.
[   22.233461] initcall 0xc0a8bce2 ran for 0 msecs: stk17ta8_init+0x0/0xf()
[   22.242247] Calling initcall 0xc0a8bef4: test_init+0x0/0x93()
[   22.248103] PM: Adding info for platform:rtc-test.0
[   22.250280] PM: Adding info for No Bus:rtc0
[   22.254384] test: dev (254:0)
[   22.260110] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   22.266250] PM: Adding info for platform:rtc-test.1
[   22.270220] PM: Adding info for No Bus:rtc1
[   22.274329] test: dev (254:1)
[   22.277187] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   22.280114] initcall 0xc0a8bef4: test_init+0x0/0x93() returned 0.
[   22.290115] initcall 0xc0a8bef4 ran for 34 msecs: test_init+0x0/0x93()
[   22.296581] Calling initcall 0xc0a8bf87: v3020_init+0x0/0xf()
[   22.302276] initcall 0xc0a8bf87: v3020_init+0x0/0xf() returned 0.
[   22.308227] initcall 0xc0a8bf87 ran for 0 msecs: v3020_init+0x0/0xf()
[   22.311987] Calling initcall 0xc05b49ea: w1_init+0x0/0xe3()
[   22.320263] Driver for 1-wire Dallas network protocol.
[   22.325707] initcall 0xc05b49ea: w1_init+0x0/0xe3() returned 0.
[   22.331295] initcall 0xc05b49ea ran for 5 msecs: w1_init+0x0/0xe3()
[   22.337534] Calling initcall 0xc05b5ff3: ds_init+0x0/0x2f()
[   22.342096] usbcore: registered new interface driver DS9490R
[   22.347633] initcall 0xc05b5ff3: ds_init+0x0/0x2f() returned 0.
[   22.353027] initcall 0xc05b5ff3 ran for 5 msecs: ds_init+0x0/0x2f()
[   22.361815] Calling initcall 0xc0a8bf96: w1_ds2760_init+0x0/0x23()
[   22.367977] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   22.370137] initcall 0xc0a8bf96: w1_ds2760_init+0x0/0x23() returned 0.
[   22.381293] initcall 0xc0a8bf96 ran for 8 msecs: w1_ds2760_init+0x0/0x23()
[   22.390097] Calling initcall 0xc0a8bfe2: pda_power_init+0x0/0xf()
[   22.396271] initcall 0xc0a8bfe2: pda_power_init+0x0/0xf() returned 0.
[   22.401295] initcall 0xc0a8bfe2 ran for 0 msecs: pda_power_init+0x0/0xf()
[   22.408055] Calling initcall 0xc0a8bff1: ds2760_battery_init+0x0/0xf()
[   22.413056] initcall 0xc0a8bff1: ds2760_battery_init+0x0/0xf() returned 0.
[   22.421294] initcall 0xc0a8bff1 ran for 0 msecs: ds2760_battery_init+0x0/0xf()
[   22.428487] Calling initcall 0xc0a8c032: abituguru_init+0x0/0x166()
[   22.432699] initcall 0xc0a8c032: abituguru_init+0x0/0x166() returned -19.
[   22.441466] initcall 0xc0a8c032 ran for 0 msecs: abituguru_init+0x0/0x166()
[   22.448400] Calling initcall 0xc0a8c198: abituguru3_init+0x0/0x13b()
[   22.452784] abituguru3: no Abit uGuru3 found, data = 0xFF, cmd = 0xFF
[   22.460108] initcall 0xc0a8c198: abituguru3_init+0x0/0x13b() returned -19.
[   22.466927] initcall 0xc0a8c198 ran for 6 msecs: abituguru3_init+0x0/0x13b()
[   22.472594] Calling initcall 0xc0a8c2d3: coretemp_init+0x0/0x1b9()
[   22.482613] initcall 0xc0a8c2d3: coretemp_init+0x0/0x1b9() returned -19.
[   22.489267] initcall 0xc0a8c2d3 ran for 0 msecs: coretemp_init+0x0/0x1b9()
[   22.492422] Calling initcall 0xc0a8c48c: sm_it87_init+0x0/0x226()
[   22.500293] it87: Found IT8712F chip at 0x290, revision 7
[   22.505633] it87: in3 is VCC (+5V)
[   22.510097] it87: in7 is VCCH (+5V Stand-By)
[   22.514443] PM: Adding info for platform:it87.656
[   22.520103] it87 it87.656: Detected broken BIOS defaults, disabling PWM interface
[   22.527683] PM: Adding info for No Bus:hwmon0
[   22.530208] initcall 0xc0a8c48c: sm_it87_init+0x0/0x226() returned 0.
[   22.536493] initcall 0xc0a8c48c ran for 28 msecs: sm_it87_init+0x0/0x226()
[   22.542334] Calling initcall 0xc0a8c6b2: sm_smsc47m1_init+0x0/0x1ac()
[   22.550279] initcall 0xc0a8c6b2: sm_smsc47m1_init+0x0/0x1ac() returned -19.
[   22.557188] initcall 0xc0a8c6b2 ran for 0 msecs: sm_smsc47m1_init+0x0/0x1ac()
[   22.562681] Calling initcall 0xc0a8c8ff: vt1211_init+0x0/0x13a()
[   22.570290] initcall 0xc0a8c8ff: vt1211_init+0x0/0x13a() returned -19.
[   22.576754] initcall 0xc0a8c8ff ran for 0 msecs: vt1211_init+0x0/0x13a()
[   22.582249] Calling initcall 0xc0a8ca39: sm_vt8231_init+0x0/0x16()
[   22.590386] initcall 0xc0a8ca39: sm_vt8231_init+0x0/0x16() returned 0.
[   22.596753] initcall 0xc0a8ca39 ran for 0 msecs: sm_vt8231_init+0x0/0x16()
[   22.602421] Calling initcall 0xc0a8ca4f: acq_init+0x0/0x55()
[   22.608063] WDT driver for Acquire single board computer initialising.
[   22.610217] PM: Adding info for platform:acquirewdt
[   22.620220] acquirewdt: I/O address 0x0043 already in use
[   22.625461] acquirewdt: probe of acquirewdt failed with error -5
[   22.630116] initcall 0xc0a8ca4f: acq_init+0x0/0x55() returned 0.
[   22.636060] initcall 0xc0a8ca4f ran for 21 msecs: acq_init+0x0/0x55()
[   22.641901] Calling initcall 0xc0a8caa4: advwdt_init+0x0/0x55()
[   22.650265] WDT driver for Advantech single board computer initialising.
[   22.657035] PM: Adding info for platform:advantechwdt
[   22.660240] PM: Adding info for No Bus:watchdog
[   22.664691] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   22.670122] initcall 0xc0a8caa4: advwdt_init+0x0/0x55() returned 0.
[   22.676321] initcall 0xc0a8caa4 ran for 21 msecs: advwdt_init+0x0/0x55()
[   22.682161] Calling initcall 0xc0a8caf9: ibwdt_init+0x0/0x55()
[   22.690264] ib700wdt: WDT driver for IB700 single board computer initialising.
[   22.697552] PM: Adding info for platform:ib700wdt
[   22.700208] ib700wdt: START method I/O 443 is not available.
[   22.705721] ib700wdt: probe of ib700wdt failed with error -5
[   22.710130] initcall 0xc0a8caf9: ibwdt_init+0x0/0x55() returned 0.
[   22.720099] initcall 0xc0a8caf9 ran for 22 msecs: ibwdt_init+0x0/0x55()
[   22.726667] Calling initcall 0xc0a8cb4e: ibmasr_init+0x0/0x22f()
[   22.732440] initcall 0xc0a8cb4e: ibmasr_init+0x0/0x22f() returned -19.
[   22.740099] initcall 0xc0a8cb4e ran for 0 msecs: ibmasr_init+0x0/0x22f()
[   22.746753] Calling initcall 0xc0a8cd7d: wafwdt_init+0x0/0x141()
[   22.752430] WDT driver for Wafer 5823 single board computer initialising.
[   22.759183] Wafer 5823 WDT: I/O address 0x0443 already in use
[   22.760108] initcall 0xc0a8cd7d: wafwdt_init+0x0/0x141() returned -5.
[   22.771382] initcall 0xc0a8cd7d ran for 11 msecs: wafwdt_init+0x0/0x141()
[   22.778142] initcall at 0xc0a8cd7d: wafwdt_init+0x0/0x141(): returned with error code -5
[   22.784934] Calling initcall 0xc0a8cebe: watchdog_init+0x0/0x27d()
[   22.792622] initcall 0xc0a8cebe: watchdog_init+0x0/0x27d() returned -19.
[   22.799267] initcall 0xc0a8cebe ran for 0 msecs: watchdog_init+0x0/0x27d()
[   22.802422] Calling initcall 0xc0a8d13b: pc87413_init+0x0/0x7e()
[   22.810263] pc87413 WDT: Version 1.1 at io 0x2E
[   22.814762] pc87413 WDT: cannot register miscdev on minor=130 (err=-16)
[   22.820108] initcall 0xc0a8d13b: pc87413_init+0x0/0x7e() returned -16.
[   22.826581] initcall 0xc0a8d13b ran for 10 msecs: pc87413_init+0x0/0x7e()
[   22.832249] initcall at 0xc0a8d13b: pc87413_init+0x0/0x7e(): returned with error code -16
[   22.842855] Calling initcall 0xc0a8d1b9: sbc60xxwdt_init+0x0/0x168()
[   22.850266] sbc60xxwdt: I/O address 0x0443 already in use
[   22.855636] initcall 0xc0a8d1b9: sbc60xxwdt_init+0x0/0x168() returned -5.
[   22.861381] initcall 0xc0a8d1b9 ran for 5 msecs: sbc60xxwdt_init+0x0/0x168()
[   22.870098] initcall at 0xc0a8d1b9: sbc60xxwdt_init+0x0/0x168(): returned with error code -5
[   22.878488] Calling initcall 0xc0a8d321: sbc8360_init+0x0/0x17f()
[   22.882519] sbc8360: failed to register misc device
[   22.887372] initcall 0xc0a8d321: sbc8360_init+0x0/0x17f() returned -16.
[   22.893720] initcall 0xc0a8d321 ran for 4 msecs: sbc8360_init+0x0/0x17f()
[   22.902335] initcall at 0xc0a8d321: sbc8360_init+0x0/0x17f(): returned with error code -16
[   22.910097] Calling initcall 0xc072cbc1: cpu5wdt_init_module+0x0/0x10e()
[   22.916766] cpu5wdt: misc_register failed
[   22.920108] initcall 0xc072cbc1: cpu5wdt_init_module+0x0/0x10e() returned -16.
[   22.927274] initcall 0xc072cbc1 ran for 3 msecs: cpu5wdt_init_module+0x0/0x10e()
[   22.932942] initcall at 0xc072cbc1: cpu5wdt_init_module+0x0/0x10e(): returned with error code -16
[   22.942854] Calling initcall 0xc0a8d4a0: zf_init+0x0/0x13f()
[   22.950263] machzwd: MachZ ZF-Logic Watchdog driver initializing.
[   22.956322] machzwd: no ZF-Logic found
[   22.960107] initcall 0xc0a8d4a0: zf_init+0x0/0x13f() returned -19.
[   22.966234] initcall 0xc0a8d4a0 ran for 9 msecs: zf_init+0x0/0x13f()
[   22.971902] Calling initcall 0xc0a8d5df: watchdog_init+0x0/0xa3()
[   22.977979] epx_c3: cannot register miscdev on minor=130 (err=-16)
[   22.980109] initcall 0xc0a8d5df: watchdog_init+0x0/0xa3() returned -16.
[   22.991468] initcall 0xc0a8d5df ran for 5 msecs: watchdog_init+0x0/0xa3()
[   22.998227] initcall at 0xc0a8d5df: watchdog_init+0x0/0xa3(): returned with error code -16
[   23.005107] Calling initcall 0xc0a8d682: telephony_init+0x0/0x3f()
[   23.012604] Linux telephony interface: v1.00
[   23.016855] initcall 0xc0a8d682: telephony_init+0x0/0x3f() returned 0.
[   23.023634] initcall 0xc0a8d682 ran for 4 msecs: telephony_init+0x0/0x3f()
[   23.030097] Calling initcall 0xc0a8d6c1: ixj_init+0x0/0x19d()
[   23.035811] ixj driver initialized.
[   23.039279] initcall 0xc0a8d6c1: ixj_init+0x0/0x19d() returned 0.
[   23.043201] initcall 0xc0a8d6c1 ran for 3 msecs: ixj_init+0x0/0x19d()
[   23.051988] Calling initcall 0xc0a8d85e: hci_usb_init+0x0/0x44()
[   23.057977] Bluetooth: HCI USB driver ver 2.9
[   23.060203] usbcore: registered new interface driver hci_usb
[   23.065726] initcall 0xc0a8d85e: hci_usb_init+0x0/0x44() returned 0.
[   23.073461] initcall 0xc0a8d85e ran for 9 msecs: hci_usb_init+0x0/0x44()
[   23.080098] Calling initcall 0xc0a8d8a2: vhci_init+0x0/0x4f()
[   23.085810] Bluetooth: Virtual HCI driver ver 1.2
[   23.090116] PM: Adding info for No Bus:vhci
[   23.094328] initcall 0xc0a8d8a2: vhci_init+0x0/0x4f() returned 0.
[   23.101295] initcall 0xc0a8d8a2 ran for 8 msecs: vhci_init+0x0/0x4f()
[   23.107707] Calling initcall 0xc0a8d8f1: init_dtl1_cs+0x0/0xf()
[   23.112456] initcall 0xc0a8d8f1: init_dtl1_cs+0x0/0xf() returned 0.
[   23.120099] initcall 0xc0a8d8f1 ran for 0 msecs: init_dtl1_cs+0x0/0xf()
[   23.126667] Calling initcall 0xc0a8dbbc: ib_core_init+0x0/0x3a()
[   23.132546] initcall 0xc0a8dbbc: ib_core_init+0x0/0x3a() returned 0.
[   23.138748] initcall 0xc0a8dbbc ran for 0 msecs: ib_core_init+0x0/0x3a()
[   23.142247] Calling initcall 0xc0a8dc05: ib_mad_init_module+0x0/0x8e()
[   23.150275] initcall 0xc0a8dc05: ib_mad_init_module+0x0/0x8e() returned 0.
[   23.157101] initcall 0xc0a8dc05 ran for 0 msecs: ib_mad_init_module+0x0/0x8e()
[   23.162769] Calling initcall 0xc0a8dc93: ib_sa_init+0x0/0x7f()
[   23.172327] initcall 0xc0a8dc93: ib_sa_init+0x0/0x7f() returned 0.
[   23.178400] initcall 0xc0a8dc93 ran for 0 msecs: ib_sa_init+0x0/0x7f()
[   23.182074] Calling initcall 0xc0a8dd12: ib_cm_init+0x0/0x127()
[   23.190431] initcall 0xc0a8dd12: ib_cm_init+0x0/0x127() returned 0.
[   23.196520] initcall 0xc0a8dd12 ran for 0 msecs: ib_cm_init+0x0/0x127()
[   23.202161] Calling initcall 0xc0a8de39: iw_cm_init+0x0/0x2f()
[   23.208029] initcall 0xc0a8de39: iw_cm_init+0x0/0x2f() returned 0.
[   23.213286] initcall 0xc0a8de39 ran for 0 msecs: iw_cm_init+0x0/0x2f()
[   23.222074] Calling initcall 0xc05de177: addr_init+0x0/0x3e()
[   23.227890] initcall 0xc05de177: addr_init+0x0/0x3e() returned 0.
[   23.233201] initcall 0xc05de177 ran for 0 msecs: addr_init+0x0/0x3e()
[   23.240098] Calling initcall 0xc05de958: cma_init+0x0/0xb1()
[   23.245790] initcall 0xc05de958: cma_init+0x0/0xb1() returned 0.
[   23.251294] initcall 0xc05de958 ran for 0 msecs: cma_init+0x0/0xb1()
[   23.257620] Calling initcall 0xc0a8de68: ib_umad_init+0x0/0xa4()
[   23.262541] initcall 0xc0a8de68: ib_umad_init+0x0/0xa4() returned 0.
[   23.270098] initcall 0xc0a8de68 ran for 0 msecs: ib_umad_init+0x0/0xa4()
[   23.276753] Calling initcall 0xc0a8df0c: ib_uverbs_init+0x0/0x121()
[   23.282836] initcall 0xc0a8df0c: ib_uverbs_init+0x0/0x121() returned 0.
[   23.290098] initcall 0xc0a8df0c ran for 0 msecs: ib_uverbs_init+0x0/0x121()
[   23.297014] Calling initcall 0xc0a8e02d: ib_ucm_init+0x0/0x8d()
[   23.302356] initcall 0xc0a8e02d: ib_ucm_init+0x0/0x8d() returned 0.
[   23.308573] initcall 0xc0a8e02d ran for 0 msecs: ib_ucm_init+0x0/0x8d()
[   23.312162] Calling initcall 0xc0a8e0ba: ucma_init+0x0/0x45()
[   23.320281] PM: Adding info for No Bus:rdma_cm
[   23.324776] initcall 0xc0a8e0ba: ucma_init+0x0/0x45() returned 0.
[   23.331295] initcall 0xc0a8e0ba ran for 4 msecs: ucma_init+0x0/0x45()
[   23.337707] Calling initcall 0xc0a8e150: mthca_init+0x0/0x121()
[   23.342541] initcall 0xc0a8e150: mthca_init+0x0/0x121() returned 0.
[   23.350102] initcall 0xc0a8e150 ran for 0 msecs: mthca_init+0x0/0x121()
[   23.356667] Calling initcall 0xc0a8e2df: mlx4_ib_init+0x0/0xf()
[   23.362371] initcall 0xc0a8e2df: mlx4_ib_init+0x0/0xf() returned 0.
[   23.368575] initcall 0xc0a8e2df ran for 0 msecs: mlx4_ib_init+0x0/0xf()
[   23.372160] Calling initcall 0xc0a8e2ee: ipoib_init_module+0x0/0xe7()
[   23.380352] initcall 0xc0a8e2ee: ipoib_init_module+0x0/0xe7() returned 0.
[   23.387015] initcall 0xc0a8e2ee ran for 0 msecs: ipoib_init_module+0x0/0xe7()
[   23.392681] Calling initcall 0xc0a8e3d5: srp_init_module+0x0/0xa2()
[   23.400370] initcall 0xc0a8e3d5: srp_init_module+0x0/0xa2() returned 0.
[   23.406841] initcall 0xc0a8e3d5 ran for 0 msecs: srp_init_module+0x0/0xa2()
[   23.412507] Calling initcall 0xc0a8edc3: dcdbas_init+0x0/0x53()
[   23.420378] PM: Adding info for platform:dcdbas
[   23.424898] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   23.430110] initcall 0xc0a8edc3: dcdbas_init+0x0/0x53() returned 0.
[   23.440106] initcall 0xc0a8edc3 ran for 11 msecs: dcdbas_init+0x0/0x53()
[   23.446755] Calling initcall 0xc0a8f07f: geode_aes_init+0x0/0x16()
[   23.452727] initcall 0xc0a8f07f: geode_aes_init+0x0/0x16() returned 0.
[   23.459093] initcall 0xc0a8f07f ran for 0 msecs: geode_aes_init+0x0/0x16()
[   23.462421] Calling initcall 0xc072cfc1: hifn_init+0x0/0x98()
[   23.470377] Driver for HIFN 795x crypto accelerator chip has been successfully registered.
[   23.480108] initcall 0xc072cfc1: hifn_init+0x0/0x98() returned 0.
[   23.486147] initcall 0xc072cfc1 ran for 7 msecs: hifn_init+0x0/0x98()
[   23.491988] Calling initcall 0xc0a8f0b8: ioat_init_module+0x0/0x16()
[   23.498447] initcall 0xc0a8f0b8: ioat_init_module+0x0/0x16() returned 0.
[   23.503806] initcall 0xc0a8f0b8 ran for 0 msecs: ioat_init_module+0x0/0x16()
[   23.512594] Calling initcall 0xc0a8f0ce: dca_init+0x0/0xa()
[   23.518263] initcall 0xc0a8f0ce: dca_init+0x0/0xa() returned 0.
[   23.523027] initcall 0xc0a8f0ce ran for 0 msecs: dca_init+0x0/0xa()
[   23.530105] Calling initcall 0xc0a909a3: sysctl_core_init+0x0/0xf()
[   23.536491] initcall 0xc0a909a3: sysctl_core_init+0x0/0xf() returned 0.
[   23.541293] initcall 0xc0a909a3 ran for 0 msecs: sysctl_core_init+0x0/0xf()
[   23.550097] Calling initcall 0xc0a90e86: flow_cache_init+0x0/0xf2()
[   23.556342] initcall 0xc0a90e86: flow_cache_init+0x0/0xf2() returned 0.
[   23.561293] initcall 0xc0a90e86 ran for 0 msecs: flow_cache_init+0x0/0xf2()
[   23.568227] Calling initcall 0xc0a90f78: pg_init+0x0/0x23a()
[   23.572084] pktgen v2.69: Packet Generator for packet performance testing.
[   23.580183] initcall 0xc0a90f78: pg_init+0x0/0x23a() returned 0.
[   23.586062] initcall 0xc0a90f78 ran for 6 msecs: pg_init+0x0/0x23a()
[   23.591901] Calling initcall 0xc0a91284: llc_init+0x0/0x6d()
[   23.600274] initcall 0xc0a91284: llc_init+0x0/0x6d() returned 0.
[   23.606234] initcall 0xc0a91284 ran for 0 msecs: llc_init+0x0/0x6d()
[   23.611900] Calling initcall 0xc0a91356: llc2_init+0x0/0xb3()
[   23.617729] NET: Registered protocol family 26
[   23.620108] initcall 0xc0a91356: llc2_init+0x0/0xb3() returned 0.
[   23.626148] initcall 0xc0a91356 ran for 4 msecs: llc2_init+0x0/0xb3()
[   23.631989] Calling initcall 0xc0a915c2: snap_init+0x0/0x2a()
[   23.640289] initcall 0xc0a915c2: snap_init+0x0/0x2a() returned 0.
[   23.646320] initcall 0xc0a915c2 ran for 0 msecs: snap_init+0x0/0x2a()
[   23.651988] Calling initcall 0xc0a915ec: rif_init+0x0/0x7a()
[   23.657663] initcall 0xc0a915ec: rif_init+0x0/0x7a() returned 0.
[   23.663114] initcall 0xc0a915ec ran for 0 msecs: rif_init+0x0/0x7a()
[   23.670097] Calling initcall 0xc0a926dd: sysctl_ipv4_init+0x0/0x1c()
[   23.677403] initcall 0xc0a926dd: sysctl_ipv4_init+0x0/0x1c() returned 0.
[   23.683807] initcall 0xc0a926dd ran for 0 msecs: sysctl_ipv4_init+0x0/0x1c()
[   23.690097] Calling initcall 0xc0a928ed: ah4_init+0x0/0x5a()
[   23.695734] initcall 0xc0a928ed: ah4_init+0x0/0x5a() returned 0.
[   23.703114] initcall 0xc0a928ed ran for 0 msecs: ah4_init+0x0/0x5a()
[   23.710097] Calling initcall 0xc0a92947: ipcomp4_init+0x0/0x5a()
[   23.716080] initcall 0xc0a92947: ipcomp4_init+0x0/0x5a() returned 0.
[   23.721295] initcall 0xc0a92947 ran for 0 msecs: ipcomp4_init+0x0/0x5a()
[   23.727968] Calling initcall 0xc0a929a1: ipip_init+0x0/0x88()
[   23.732195] initcall 0xc0a929a1: ipip_init+0x0/0x88() returned 0.
[   23.740099] initcall 0xc0a929a1 ran for 0 msecs: ipip_init+0x0/0x88()
[   23.746494] Calling initcall 0xc0a92a29: tunnel4_init+0x0/0x5a()
[   23.752439] initcall 0xc0a92a29: tunnel4_init+0x0/0x5a() returned 0.
[   23.758747] initcall 0xc0a92a29 ran for 0 msecs: tunnel4_init+0x0/0x5a()
[   23.762248] Calling initcall 0xc0a941a9: bictcp_register+0x0/0xf()
[   23.772605] TCP bic registered
[   23.775638] initcall 0xc0a941a9: bictcp_register+0x0/0xf() returned 0.
[   23.781294] initcall 0xc0a941a9 ran for 2 msecs: bictcp_register+0x0/0xf()
[   23.788140] Calling initcall 0xc0a941b8: tcp_westwood_register+0x0/0xf()
[   23.793125] TCP westwood registered
[   23.796591] initcall 0xc0a941b8: tcp_westwood_register+0x0/0xf() returned 0.
[   23.804154] initcall 0xc0a941b8 ran for 3 msecs: tcp_westwood_register+0x0/0xf()
[   23.812942] Calling initcall 0xc0a941c7: hstcp_register+0x0/0xf()
[   23.819018] TCP highspeed registered
[   23.820108] initcall 0xc0a941c7: hstcp_register+0x0/0xf() returned 0.
[   23.826495] initcall 0xc0a941c7 ran for 3 msecs: hstcp_register+0x0/0xf()
[   23.832335] Calling initcall 0xc0a94404: xfrm_user_init+0x0/0x4b()
[   23.840263] Initializing XFRM netlink socket
[   23.844534] initcall 0xc0a94404: xfrm_user_init+0x0/0x4b() returned 0.
[   23.851295] initcall 0xc0a94404 ran for 4 msecs: xfrm_user_init+0x0/0x4b()
[   23.860099] Calling initcall 0xc0a9444f: af_unix_init+0x0/0x47()
[   23.866071] NET: Registered protocol family 1
[   23.870131] initcall 0xc0a9444f: af_unix_init+0x0/0x47() returned 0.
[   23.876408] initcall 0xc0a9444f ran for 4 msecs: af_unix_init+0x0/0x47()
[   23.882248] Calling initcall 0xc0a94496: inet6_init+0x0/0x316()
[   23.888172] NET: Registered protocol family 10
[   23.894597] initcall 0xc0a94496: inet6_init+0x0/0x316() returned 0.
[   23.903373] initcall 0xc0a94496 ran for 8 msecs: inet6_init+0x0/0x316()
[   23.910097] Calling initcall 0xc0a951fc: esp6_init+0x0/0x5a()
[   23.915821] initcall 0xc0a951fc: esp6_init+0x0/0x5a() returned 0.
[   23.921294] initcall 0xc0a951fc ran for 0 msecs: esp6_init+0x0/0x5a()
[   23.927707] Calling initcall 0xc0a95256: ipcomp6_init+0x0/0x5a()
[   23.932440] initcall 0xc0a95256: ipcomp6_init+0x0/0x5a() returned 0.
[   23.941295] initcall 0xc0a95256 ran for 0 msecs: ipcomp6_init+0x0/0x5a()
[   23.947968] Calling initcall 0xc0a952b0: xfrm6_tunnel_init+0x0/0xdb()
[   23.952895] initcall 0xc0a952b0: xfrm6_tunnel_init+0x0/0xdb() returned 0.
[   23.960098] initcall 0xc0a952b0 ran for 0 msecs: xfrm6_tunnel_init+0x0/0xdb()
[   23.967188] Calling initcall 0xc0a9538b: tunnel6_init+0x0/0x5a()
[   23.972439] initcall 0xc0a9538b: tunnel6_init+0x0/0x5a() returned 0.
[   23.980106] initcall 0xc0a9538b ran for 0 msecs: tunnel6_init+0x0/0x5a()
[   23.986754] Calling initcall 0xc0a953e5: xfrm6_transport_init+0x0/0x14()
[   23.993133] initcall 0xc0a953e5: xfrm6_transport_init+0x0/0x14() returned 0.
[   24.000098] initcall 0xc0a953e5 ran for 0 msecs: xfrm6_transport_init+0x0/0x14()
[   24.007447] Calling initcall 0xc0a953f9: xfrm6_ro_init+0x0/0x14()
[   24.012526] initcall 0xc0a953f9: xfrm6_ro_init+0x0/0x14() returned 0.
[   24.020099] initcall 0xc0a953f9 ran for 0 msecs: xfrm6_ro_init+0x0/0x14()
[   24.026840] Calling initcall 0xc0a9540d: xfrm6_beet_init+0x0/0x14()
[   24.032699] initcall 0xc0a9540d: xfrm6_beet_init+0x0/0x14() returned 0.
[   24.040098] initcall 0xc0a9540d ran for 0 msecs: xfrm6_beet_init+0x0/0x14()
[   24.047014] Calling initcall 0xc0a95421: packet_init+0x0/0x39()
[   24.052345] NET: Registered protocol family 17
[   24.056786] initcall 0xc0a95421: packet_init+0x0/0x39() returned 0.
[   24.063374] initcall 0xc0a95421 ran for 4 msecs: packet_init+0x0/0x39()
[   24.070097] Calling initcall 0xc0a9545a: ipsec_pfkey_init+0x0/0x84()
[   24.076418] NET: Registered protocol family 15
[   24.080114] initcall 0xc0a9545a: ipsec_pfkey_init+0x0/0x84() returned 0.
[   24.086754] initcall 0xc0a9545a ran for 4 msecs: ipsec_pfkey_init+0x0/0x84()
[   24.092594] Calling initcall 0xc0a954de: ipx_init+0x0/0xd2()
[   24.100265] NET: Registered protocol family 4
[   24.104677] initcall 0xc0a954de: ipx_init+0x0/0xd2() returned 0.
[   24.110098] initcall 0xc0a954de ran for 4 msecs: ipx_init+0x0/0xd2()
[   24.116407] Calling initcall 0xc0a9566c: x25_init+0x0/0x50()
[   24.122085] NET: Registered protocol family 9
[   24.126410] X.25 for Linux Version 0.2
[   24.130222] initcall 0xc0a9566c: x25_init+0x0/0x50() returned 0.
[   24.136061] initcall 0xc0a9566c ran for 7 msecs: x25_init+0x0/0x50()
[   24.141901] Calling initcall 0xc0a95791: can_init+0x0/0xe9()
[   24.147543] can: controller area network core (rev 20071116 abi 8)
[   24.150132] NET: Registered protocol family 29
[   24.154512] initcall 0xc0a95791: can_init+0x0/0xe9() returned 0.
[   24.163114] initcall 0xc0a95791 ran for 10 msecs: can_init+0x0/0xe9()
[   24.170097] Calling initcall 0xc0a95a07: l2cap_init+0x0/0xbc()
[   24.175918] Bluetooth: L2CAP ver 2.9
[   24.180104] Bluetooth: L2CAP socket layer initialized
[   24.185117] initcall 0xc0a95a07: l2cap_init+0x0/0xbc() returned 0.
[   24.191296] initcall 0xc0a95a07 ran for 8 msecs: l2cap_init+0x0/0xbc()
[   24.197795] Calling initcall 0xc0a95ac3: bnep_init+0x0/0x6c()
[   24.202170] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
[   24.207447] Bluetooth: BNEP filters: protocol multicast
[   24.210107] initcall 0xc0a95ac3: bnep_init+0x0/0x6c() returned 0.
[   24.220099] initcall 0xc0a95ac3 ran for 10 msecs: bnep_init+0x0/0x6c()
[   24.226582] Calling initcall 0xc0a95bad: init_sunrpc+0x0/0x53()
[   24.232687] RPC: Registered udp transport module.
[   24.237214] RPC: Registered tcp transport module.
[   24.240109] initcall 0xc0a95bad: init_sunrpc+0x0/0x53() returned 0.
[   24.246319] initcall 0xc0a95bad ran for 9 msecs: init_sunrpc+0x0/0x53()
[   24.252161] Calling initcall 0xc0a95c00: init_rpcsec_gss+0x0/0x2e()
[   24.260314] initcall 0xc0a95c00: init_rpcsec_gss+0x0/0x2e() returned 0.
[   24.266841] initcall 0xc0a95c00 ran for 0 msecs: init_rpcsec_gss+0x0/0x2e()
[   24.272506] Calling initcall 0xc0a95c2e: init_kerberos_module+0x0/0x26()
[   24.280313] initcall 0xc0a95c2e: init_kerberos_module+0x0/0x26() returned 0.
[   24.287275] initcall 0xc0a95c2e ran for 0 msecs: init_kerberos_module+0x0/0x26()
[   24.292941] Calling initcall 0xc0a95d9f: br2684_init+0x0/0x35()
[   24.302371] initcall 0xc0a95d9f: br2684_init+0x0/0x35() returned 0.
[   24.308574] initcall 0xc0a95d9f ran for 0 msecs: br2684_init+0x0/0x35()
[   24.312160] Calling initcall 0xc0a95dd4: lane_module_init+0x0/0x3b()
[   24.320266] lec.c: Feb  2 2008 11:32:05 initialized
[   24.325117] initcall 0xc0a95dd4: lane_module_init+0x0/0x3b() returned 0.
[   24.331294] initcall 0xc0a95dd4 ran for 4 msecs: lane_module_init+0x0/0x3b()
[   24.340099] Calling initcall 0xc0a95e0f: atm_mpoa_init+0x0/0x2f()
[   24.346159] mpc.c: Feb  2 2008 11:32:04 initialized
[   24.350112] initcall 0xc0a95e0f: atm_mpoa_init+0x0/0x2f() returned 0.
[   24.356495] initcall 0xc0a95e0f ran for 4 msecs: atm_mpoa_init+0x0/0x2f()
[   24.362336] Calling initcall 0xc0a95e3e: dccp_init+0x0/0x2f5()
[   24.374068] initcall 0xc0a95e3e: dccp_init+0x0/0x2f5() returned 0.
[   24.380111] initcall 0xc0a95e3e ran for 3 msecs: dccp_init+0x0/0x2f5()
[   24.386578] Calling initcall 0xc0a961ed: dccp_v4_init+0x0/0x7f()
[   24.392550] initcall 0xc0a961ed: dccp_v4_init+0x0/0x7f() returned 0.
[   24.398747] initcall 0xc0a961ed ran for 0 msecs: dccp_v4_init+0x0/0x7f()
[   24.402247] Calling initcall 0xc0a9626c: dccp_v6_init+0x0/0x7f()
[   24.410282] initcall 0xc0a9626c: dccp_v6_init+0x0/0x7f() returned 0.
[   24.416581] initcall 0xc0a9626c ran for 0 msecs: dccp_v6_init+0x0/0x7f()
[   24.422247] Calling initcall 0xc0a962eb: ccid2_module_init+0x0/0xf()
[   24.430304] CCID: Registered CCID 2 (TCP-like)
[   24.434683] initcall 0xc0a962eb: ccid2_module_init+0x0/0xf() returned 0.
[   24.441294] initcall 0xc0a962eb ran for 4 msecs: ccid2_module_init+0x0/0xf()
[   24.448314] Calling initcall 0xc0a962fa: sctp_init+0x0/0x6b9()
[   24.454869] SCTP: Hash tables configured (established 32768 bind 29127)
[   24.460613] sctp_init_sock(sk: f7de2000)
[   24.464435] initcall 0xc0a962fa: sctp_init+0x0/0x6b9() returned 0.
[   24.473288] initcall 0xc0a962fa ran for 12 msecs: sctp_init+0x0/0x6b9()
[   24.480105] Calling initcall 0xc0a96a76: ieee80211_init+0x0/0x1b()
[   24.486243] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   24.490098] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   24.500108] initcall 0xc0a96a76: ieee80211_init+0x0/0x1b() returned 0.
[   24.506582] initcall 0xc0a96a76 ran for 14 msecs: ieee80211_init+0x0/0x1b()
[   24.512421] Calling initcall 0xc0a96a91: ieee80211_crypto_init+0x0/0xf()
[   24.520283] ieee80211_crypt: registered algorithm 'NULL'
[   24.525549] initcall 0xc0a96a91: ieee80211_crypto_init+0x0/0xf() returned 0.
[   24.534155] initcall 0xc0a96a91 ran for 5 msecs: ieee80211_crypto_init+0x0/0xf()
[   24.540099] Calling initcall 0xc0a96aa0: ieee80211_crypto_wep_init+0x0/0xf()
[   24.547111] ieee80211_crypt: registered algorithm 'WEP'
[   24.550106] initcall 0xc0a96aa0: ieee80211_crypto_wep_init+0x0/0xf() returned 0.
[   24.561294] initcall 0xc0a96aa0 ran for 4 msecs: ieee80211_crypto_wep_init+0x0/0xf()
[   24.569007] Calling initcall 0xc0a96b6a: rfkill_handler_init+0x0/0xf()
[   24.572965] initcall 0xc0a96b6a: rfkill_handler_init+0x0/0xf() returned 0.
[   24.581294] initcall 0xc0a96b6a ran for 0 msecs: rfkill_handler_init+0x0/0xf()
[   24.588487] Calling initcall 0xc0a6f111: hpet_insert_resource+0x0/0x1e()
[   24.593131] initcall 0xc0a6f111: hpet_insert_resource+0x0/0x1e() returned 1.
[   24.601294] initcall 0xc0a6f111 ran for 0 msecs: hpet_insert_resource+0x0/0x1e()
[   24.610098] initcall at 0xc0a6f111: hpet_insert_resource+0x0/0x1e(): returned with error code 1
[   24.618748] Calling initcall 0xc0a71d5e: check_early_ioremap_leak+0x0/0x3d()
[   24.623479] initcall 0xc0a71d5e: check_early_ioremap_leak+0x0/0x3d() returned 0.
[   24.631296] initcall 0xc0a71d5e ran for 0 msecs: check_early_ioremap_leak+0x0/0x3d()
[   24.640098] Calling initcall 0xc0a7260d: print_ipi_mode+0x0/0x25()
[   24.646244] Using IPI Shortcut mode
[   24.650106] initcall 0xc0a7260d: print_ipi_mode+0x0/0x25() returned 0.
[   24.656580] initcall 0xc0a7260d ran for 3 msecs: print_ipi_mode+0x0/0x25()
[   24.662421] Calling initcall 0xc01197f1: init_oops_id+0x0/0x23()
[   24.670278] initcall 0xc01197f1: init_oops_id+0x0/0x23() returned 0.
[   24.676580] initcall 0xc01197f1 ran for 0 msecs: init_oops_id+0x0/0x23()
[   24.682249] Calling initcall 0xc0a72e64: disable_boot_consoles+0x0/0x36()
[   24.690116] initcall 0xc0a72e64: disable_boot_consoles+0x0/0x36() returned 0.
[   24.697186] initcall 0xc0a72e64 ran for 0 msecs: disable_boot_consoles+0x0/0x36()
[   24.703028] Calling initcall 0xc0a783fd: random32_reseed+0x0/0x24()
[   24.710278] initcall 0xc0a783fd: random32_reseed+0x0/0x24() returned 0.
[   24.716841] initcall 0xc0a783fd ran for 0 msecs: random32_reseed+0x0/0x24()
[   24.722508] Calling initcall 0xc0a789a7: pci_sysfs_init+0x0/0x44()
[   24.730354] BUG: unable to handle kernel NULL pointer dereference at 0000000c
[   24.737362] IP: [<c034226f>] pcie_aspm_create_sysfs_dev_files+0x1e/0x58
[   24.740099] *pde = 00000000 
[   24.742941] Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
[   24.747794] 
[   24.749268] Pid: 1, comm: swapper Not tainted (2.6.24 #6)
[   24.750095] EIP: 0060:[<c034226f>] EFLAGS: 00010246 CPU: 0
[   24.750095] EIP is at pcie_aspm_create_sysfs_dev_files+0x1e/0x58
[   24.750095] EAX: f7c1b504 EBX: f7c1b5d8 ECX: 00000000 EDX: 00000000
[   24.750095] ESI: 00000000 EDI: f7c1b5d8 EBP: c3394f50 ESP: c3394f48
[   24.750095]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   24.750095] Process swapper (pid: 1, ti=c3394000 task=c3393000 task.ti=c3394000)
[   24.750095] Stack: 00000000 00000000 c3394f84 c0340c3d c3394f74 c0340188 ffffffff f7c1b710 
[   24.750095]        00000000 00000000 00000006 f7c1b6b0 00000000 f7c1b5d8 00000000 c3394f94 
[   24.750095]        c0a789c1 00000000 00000000 c3394fe0 c0a69673 8ea6c516 00000009 00000000 
[   24.750095] Call Trace:
[   24.750095]  [<c0340c3d>] ? pci_create_sysfs_dev_files+0x254/0x2f7
[   24.750095]  [<c0340188>] ? pci_get_subsys+0xc2/0xcb
[   24.750095]  [<c0a789c1>] ? pci_sysfs_init+0x1a/0x44
[   24.750095]  [<c0a69673>] ? kernel_init+0xb2/0x20b
[   24.750095]  [<c0a695c1>] ? kernel_init+0x0/0x20b
[   24.750095]  [<c01057a7>] ? kernel_thread_helper+0x7/0x10
[   24.750095]  =======================
[   24.750095] Code: 84 e6 9a c0 e8 41 6b e4 ff 5b 5e 5d c3 55 89 e5 56 53 89 c3 8b 70 48 f6 80 dd 03 00 00 04 74 41 8a 40 32 3c 04 74 04 3c 06 75 36 <83> 7e 0c 00 74 15 8d 83 38 01 00 00 b9 7c e6 9a c0 ba 68 e6 9a 
[   24.750095] EIP: [<c034226f>] pcie_aspm_create_sysfs_dev_files+0x1e/0x58 SS:ESP 0068:c3394f48
[   24.750097] ---[ end trace 3c3abae1b726b0b1 ]---
[   24.754676] Kernel panic - not syncing: Attempted to kill init!

--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24
# Sat Feb  2 11:31:33 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_SUPPORTS_OPROFILE=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=20
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_LSF is not set
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_CLASSIC_RCU=y
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
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
# CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_VMI=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_M386 is not set
CONFIG_M486=y
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
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_F00F_BUG=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_HPET_TIMER=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_RCU_TRACE is not set
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NR_QUICK=1
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=y
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_HOTPLUG_MEMORY=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_ARCH_SUPPORTS_MSI is not set
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
CONFIG_MCA_PROC_FS=y
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_PCMCIA_IOCTL=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set

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
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_ASK_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE=y
# CONFIG_IP_FIB_HASH is not set
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=y
CONFIG_IP_DCCP_CCID2_DEBUG=y
# CONFIG_IP_DCCP_CCID3 is not set
# CONFIG_IP_DCCP_TFRC_LIB is not set

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
# CONFIG_BT_SCO is not set
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=y
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIDTL1=y
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
CONFIG_WIRELESS_EXT=y
# CONFIG_MAC80211 is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
# CONFIG_IEEE80211_CRYPT_CCMP is not set
# CONFIG_IEEE80211_CRYPT_TKIP is not set
CONFIG_IEEE80211_SOFTMAC=y
CONFIG_IEEE80211_SOFTMAC_DEBUG=y
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_MSI_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_DOCK=y
CONFIG_THINKPAD_ACPI_BAY=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_OMIT_FLASHPOINT=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_FD_MCS=y
# CONFIG_SCSI_IBMMCA is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR_D700=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_NCR_Q720=y
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
# CONFIG_SCSI_MCA_53C9X is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=y
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INIC162X=y
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RZ1000=y
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_PDC2027X=y
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=y
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y
# CONFIG_PATA_PLATFORM is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
# CONFIG_I2O_PROC is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=y
CONFIG_BONDING=y
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_TULIP is not set
CONFIG_AT1700=y
# CONFIG_DEPCA is not set
CONFIG_HP100=y
CONFIG_NE2_MCA=y
# CONFIG_IBMLANA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_PCNET32_NAPI=y
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_ADAPTEC_STARFIRE_NAPI=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_EEPRO100=y
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R6040 is not set
CONFIG_SIS900=y
CONFIG_EPIC100=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_RHINE_NAPI is not set
# CONFIG_SC92031 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
# CONFIG_E1000_NAPI is not set
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
CONFIG_IP1000=y
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_R8169_NAPI=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
CONFIG_MLX4_CORE=y
CONFIG_TR=y
# CONFIG_IBMTR is not set
# CONFIG_IBMOL is not set
# CONFIG_IBMLS is not set
# CONFIG_3C359 is not set
# CONFIG_TMS380TR is not set
# CONFIG_SMCTR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_ATM_DRIVERS is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOATM is not set
# CONFIG_PPPOL2TP is not set
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
CONFIG_PHONE=y
CONFIG_PHONE_IXJ=y
# CONFIG_PHONE_IXJ_PCMCIA is not set

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_UCB1400=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
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
CONFIG_COMPUTONE=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
# CONFIG_MOXA_SMARTIO_NEW is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_N_HDLC=y
CONFIG_RISCOM8=y
# CONFIG_SPECIALIX is not set
CONFIG_SX=y
CONFIG_RIO=y
# CONFIG_RIO_OLDPCI is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=y

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
CONFIG_DAB=y
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
CONFIG_DRM_TDFX=y
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
CONFIG_USB_PERSIST=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
# CONFIG_USB_STORAGE is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
CONFIG_USB_SERIAL_KEYSPAN=y
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA19 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_AUERSWALD=y
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
CONFIG_USB_BERRY_CHARGE=y
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_PHIDGET=y
# CONFIG_USB_PHIDGETKIT is not set
# CONFIG_USB_PHIDGETMOTORCONTROL is not set
# CONFIG_USB_PHIDGETSERVO is not set
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
# CONFIG_USB_ATM is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_AMD5536UDC is not set
# CONFIG_USB_GADGET_ATMEL_USBA is not set
# CONFIG_USB_GADGET_FSL_USB2 is not set
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_PXA2XX is not set
# CONFIG_USB_GADGET_M66592 is not set
CONFIG_USB_GADGET_GOKU=y
CONFIG_USB_GOKU=y
# CONFIG_USB_GADGET_LH7A40X is not set
# CONFIG_USB_GADGET_OMAP is not set
# CONFIG_USB_GADGET_S3C2410 is not set
# CONFIG_USB_GADGET_AT91 is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
# CONFIG_USB_GADGET_DUALSPEED is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_GADGETFS is not set
CONFIG_USB_FILE_STORAGE=y
CONFIG_USB_FILE_STORAGE_TEST=y
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_MMC is not set
CONFIG_NEW_LEDS=y
# CONFIG_LEDS_CLASS is not set

#
# LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_MLX4_INFINIBAND=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_V3020=y

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_DCA=y

#
# Userspace I/O
#
# CONFIG_UIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_MINIX_FS=y
CONFIG_ROMFS_FS=y
CONFIG_INOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=y
CONFIG_VXFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=y
# CONFIG_NFSD_V3 is not set
CONFIG_NFSD_TCP=y
# CONFIG_ROOT_NFS is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_XPRT_RDMA is not set
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp437"
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_FRAME_POINTER=y
CONFIG_FORCED_INLINING=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_BACKTRACE_SELF_TEST=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_KOBJECT=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
# CONFIG_CRC16 is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--yNb1oOkm5a9FJOVX--
