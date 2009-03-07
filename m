Return-Path: <linux-kernel-owner+w=401wt.eu-S1756200AbZCGUWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbZCGUWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbZCGUW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:22:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:24150 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZCGUWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=wiaKfps1suZJfv3y0vw+rMViVzpi9rjfE948PwzM0c4QOHr2rqyTtwqw/jLOPDSlZr
         a9lpJnrJc5fdAgkT+Vo8XzdF92qzPCWt3/5eRyMkE2vGMilxIUfywc99ZX24pwlch6Os
         idLUQuM6PLo+dq98+Z9/MBh9e73XNRrO2GCCg=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090307195225.GA2585@kroah.com>
References: <1236453644.6077.68.camel@maxim-laptop>
	 <20090307195225.GA2585@kroah.com>
Content-Type: multipart/mixed; boundary="=-KzQ5JkeMwhTFZpcPDEyc"
Date: Sat, 07 Mar 2009 22:22:07 +0200
Message-Id: <1236457327.6077.83.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KzQ5JkeMwhTFZpcPDEyc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2009-03-07 at 11:52 -0800, Greg KH wrote:
> On Sat, Mar 07, 2009 at 09:20:44PM +0200, Maxim Levitsky wrote:
> > Hi,
> > 
> > Short summary:
> > 
> > I have HP1018 printer, and it works well in windows.
> > When I use in in linux, I often see messages like:
> > 
> > usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
> > 
> > This is using hp backend that talks to printer using usbfs.
> > I also tried usblp, but it just doesn't say anything in kernel log. I
> > think it silently ignores similar errors, because the end result is the
> > same, the printer sometimes works, but sometimes doesn't.
> > (printer needs firmware to be uploaded to it, and I do upload it).
> > 
> > On the other hand, IF I remove _ether_ ehci-hcd or uhci-hcd from kernel,
> > then everything works fine, I already rebooted the printer many times,
> > used it to print, upload firmware, and everything just work, but as soon
> > as I load the second driver it fails in same way again.
> > 
> > USB issues with this class of printers are nothing but new, for example
> > see:
> > 
> > http://foo2zjs.rkkda.com/forum/read.php?9,374
> > https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/54419
> 
> What kernel version are you using?
> 
> > I compiled without CONFIG_USB_EHCI_ROOT_HUB_TT
> > and it did help (didn't that much testing, but at least firmware loads
> > ok, and no error messages)
> 
> Can you provide the full kernel log messages from when you plug in your
> printer?  Are there any other messages saying that you need to be sure
> to load one driver before the other?
I am familiar with these messages, maybe instead uhci should depend on
ehci or something like that?

Tommorow I try to load them manually in correct order.
Btw, if I unload both and then load first ehci then uhci, this is ok
(if they were loaded incorrectly)


Confirm again that without CONFIG_USB_EHCI_ROOT_HUB_TT both drivers
work.

dmesg (from /var/log/kern.log.0) attached
It shows how I rebooted the printer often.
It also have this error message about the order.

But this isn't related.
I currently blacklisted uhci-hcd, so only ehci-hcd gets loaded.
Then I loaded the uhci, and got same bug
(This is why I attached an older dmesg, if you need I reproduce that bug
again)


To be clear, usually after these error messages (... -110), printer
stops working, it is so confused, all attempts to access it hang.
Only reboot helps.



> 
> thanks,
> 
> greg k-h

--=-KzQ5JkeMwhTFZpcPDEyc
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Initializing cgroup subsys cpuset
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Linux version 2.6.28 (maxim@maxim-laptop) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #7 SMP PREEMPT Mon Feb 23 12:42:13 IST 2009
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Command line: root=UUID=ee43f3dd-ddf2-440c-82d0-3f5d32610f42 ro usbcore.autosuspend=1 vga=791 splash quiet 
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] KERNEL supported cpus:
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   Intel GenuineIntel
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] BIOS-provided physical RAM map:
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fcfd000 (usable)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fcfd000 - 000000007fd08000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fd08000 - 000000007fd52000 (usable)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fd52000 - 000000007fd55000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fd55000 - 000000007fdbb000 (usable)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fdbb000 - 000000007fdbf000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fdbf000 - 000000007fe70000 (usable)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007fe70000 - 000000007febf000 (ACPI NVS)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007febf000 - 000000007ff00000 (ACPI data)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] DMI 2.4 present.
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] last_pfn = 0x7fe70 max_arch_pfn = 0x3ffffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000007fe70000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  0000000000 - 007fe00000 page 2M
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  007fe00000 - 007fe70000 page 4k
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] kernel direct mapping tables up to 7fe70000 @ 8000-c000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] last_map_addr: 7fe70000 end: 7fe70000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] RAMDISK: 36a3c000 - 37fefe38
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: RSDP 000FE020, 0024 (r2 ACRSYS)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: XSDT 7FEFE120, 0064 (r1 ACRSYS ACRPRDCT        1       1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: FACP 7FEFD000, 00F4 (r4 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: DSDT 7FEF4000, 8968 (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: FACS 7FE75000, 0040
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: APIC 7FEF3000, 0068 (r2 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: MCFG 7FEF2000, 003C (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: SLIC 7FEF1000, 0176 (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: HPET 7FEF0000, 0038 (r1 ACRSYS ACRPRDCT        1 MSFT  1000013)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: SSDT 7FEEF000, 04C4 (r1  PmRef    CpuPm     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: SSDT 7FEEE000, 0232 (r1  PmRef  Cpu0Tst     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: SSDT 7FEED000, 00A0 (r1  PmRef  Cpu1Tst     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fe70000]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #2 [0000200000 - 0000805e18]    TEXT DATA BSS ==> [0000200000 - 0000805e18]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #3 [0036a3c000 - 0037fefe38]          RAMDISK ==> [0036a3c000 - 0037fefe38]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] found SMP MP-table at [ffff8800000fe1b0] 000fe1b0
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Zone PFN ranges:
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   Normal   0x00100000 -> 0x00100000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Movable zone start PFN for each node
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] early_node_map[5] active PFN ranges
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]     0: 0x00000100 -> 0x0007fcfd
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]     0: 0x0007fd08 -> 0x0007fd52
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]     0: 0x0007fd55 -> 0x0007fdbb
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]     0: 0x0007fdbf -> 0x0007fe70
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] On node 0 totalpages: 523773
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA zone: 56 pages used for memmap
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA zone: 1644 pages reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA zone: 2299 pages, LIFO batch:0
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA32 zone: 7107 pages used for memmap
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   DMA32 zone: 512667 pages, LIFO batch:31
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   Normal zone: 0 pages used for memmap
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000]   Movable zone: 0 pages used for memmap
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x408
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: Local APIC address 0xfee00000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: IRQ0 used by override.
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: IRQ2 used by override.
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: IRQ9 used by override.
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 000000007fcfd000 - 000000007fd08000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 000000007fd52000 - 000000007fd55000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PM: Registered nosave memory: 000000007fdbb000 - 000000007fdbf000
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514966
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Kernel command line: root=UUID=ee43f3dd-ddf2-440c-82d0-3f5d32610f42 ro usbcore.autosuspend=1 vga=791 splash quiet 
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Unknown boot option `usbcore.autosuspend=1': ignoring
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Initializing CPU#0
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Preemptible RCU implementation.
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Fast TSC calibration using PIT
Mar  6 16:33:38 maxim-laptop kernel: [    0.000000] Detected 1662.406 MHz processor.
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Console: colour dummy device 80x25
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] console [tty0] enabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Memory: 2034076k/2095552k available (3165k kernel code, 460k absent, 60388k reserved, 1733k data, 364k init)
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] hpet clockevent registered
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 3324.81 BogoMIPS (lpj=6649624)
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Security Framework initialized
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] SELinux:  Disabled at boot.
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Mount-cache hash table entries: 256
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Initializing cgroup subsys ns
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Initializing cgroup subsys cpuacct
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: L2 cache: 2048K
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: Physical Processor ID: 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: Processor Core ID: 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] using mwait in idle threads.
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] ACPI: Core revision 20080926
Mar  6 16:33:38 maxim-laptop kernel: [    0.016053] Setting APIC routing to flat
Mar  6 16:33:38 maxim-laptop kernel: [    0.016455] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Mar  6 16:33:38 maxim-laptop kernel: [    0.059814] CPU0: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
Mar  6 16:33:38 maxim-laptop kernel: [    0.060001] Booting processor 1 APIC 0x1 ip 0x6000
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Initializing CPU#1
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] Calibrating delay using timer specific routine.. 3324.94 BogoMIPS (lpj=6649898)
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: L2 cache: 2048K
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: Physical Processor ID: 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] CPU: Processor Core ID: 1
Mar  6 16:33:38 maxim-laptop kernel: [    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
Mar  6 16:33:38 maxim-laptop kernel: [    0.145321] CPU1: Intel(R) Core(TM)2 Duo CPU     T5450  @ 1.66GHz stepping 0d
Mar  6 16:33:38 maxim-laptop kernel: [    0.145350] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Mar  6 16:33:38 maxim-laptop kernel: [    0.148023] Brought up 2 CPUs
Mar  6 16:33:38 maxim-laptop kernel: [    0.148026] Total of 2 processors activated (6649.76 BogoMIPS).
Mar  6 16:33:38 maxim-laptop kernel: [    0.148078] CPU0 attaching sched-domain:
Mar  6 16:33:38 maxim-laptop kernel: [    0.148081]  domain 0: span 0-1 level MC
Mar  6 16:33:38 maxim-laptop kernel: [    0.148084]   groups: 0 1
Mar  6 16:33:38 maxim-laptop kernel: [    0.148089] CPU1 attaching sched-domain:
Mar  6 16:33:38 maxim-laptop kernel: [    0.148091]  domain 0: span 0-1 level MC
Mar  6 16:33:38 maxim-laptop kernel: [    0.148094]   groups: 1 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.148159] net_namespace: 1352 bytes
Mar  6 16:33:38 maxim-laptop kernel: [    0.148214] NET: Registered protocol family 16
Mar  6 16:33:38 maxim-laptop kernel: [    0.148214] ACPI: bus type pci registered
Mar  6 16:33:38 maxim-laptop kernel: [    0.148214] PCI: Using configuration type 1 for base access
Mar  6 16:33:38 maxim-laptop kernel: [    0.153205] ACPI: EC: Look up EC in DSDT
Mar  6 16:33:38 maxim-laptop kernel: [    0.158615] ACPI: BIOS _OSI(Linux) query ignored
Mar  6 16:33:38 maxim-laptop kernel: [    0.160816] ACPI: EC: non-query interrupt received, switching to interrupt mode
Mar  6 16:33:38 maxim-laptop kernel: [    0.168026] ACPI: EC: GPE storm detected, transactions will use polling mode
Mar  6 16:33:38 maxim-laptop kernel: [    0.668005] ACPI: EC: missing confirmations, switch off interrupt mode.
Mar  6 16:33:38 maxim-laptop kernel: [    0.672235] ACPI: Interpreter enabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.672238] ACPI: (supports S0 S3 S4 S5)
Mar  6 16:33:38 maxim-laptop kernel: [    0.672261] ACPI: Using IOAPIC for interrupt routing
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] ACPI: EC: driver started in poll mode
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:01.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1a.0: reg 20 io port: [0x60c0-0x60df]
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1a.1: reg 20 io port: [0x60a0-0x60bf]
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1a.7: reg 10 32bit mmio: [0x9b304c00-0x9b304fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1a.7: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1b.0: reg 10 64bit mmio: [0x9b300000-0x9b303fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1b.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.1: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.2: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.728846] pci 0000:00:1c.3: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.728886] pci 0000:00:1d.0: reg 20 io port: [0x6080-0x609f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.728954] pci 0000:00:1d.1: reg 20 io port: [0x6060-0x607f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729023] pci 0000:00:1d.2: reg 20 io port: [0x6040-0x605f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729097] pci 0000:00:1d.7: reg 10 32bit mmio: [0x9b304800-0x9b304bff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729149] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.729155] pci 0000:00:1d.7: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.729328] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
Mar  6 16:33:38 maxim-laptop kernel: [    0.729332] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
Mar  6 16:33:38 maxim-laptop kernel: [    0.729372] pci 0000:00:1f.1: reg 10 io port: [0x6108-0x610f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729380] pci 0000:00:1f.1: reg 14 io port: [0x611c-0x611f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729389] pci 0000:00:1f.1: reg 18 io port: [0x6100-0x6107]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729397] pci 0000:00:1f.1: reg 1c io port: [0x6118-0x611b]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729406] pci 0000:00:1f.1: reg 20 io port: [0x60e0-0x60ef]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729485] pci 0000:00:1f.2: reg 10 io port: [0x60f8-0x60ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729494] pci 0000:00:1f.2: reg 14 io port: [0x6114-0x6117]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729502] pci 0000:00:1f.2: reg 18 io port: [0x60f0-0x60f7]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729511] pci 0000:00:1f.2: reg 1c io port: [0x6110-0x6113]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729519] pci 0000:00:1f.2: reg 20 io port: [0x6020-0x603f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729527] pci 0000:00:1f.2: reg 24 32bit mmio: [0x9b304000-0x9b3047ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729550] pci 0000:00:1f.2: PME# supported from D3hot
Mar  6 16:33:38 maxim-laptop kernel: [    0.729555] pci 0000:00:1f.2: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.729591] pci 0000:00:1f.3: reg 10 32bit mmio: [0x9b305000-0x9b3050ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729618] pci 0000:00:1f.3: reg 20 io port: [0x6000-0x601f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729699] pci 0000:01:00.0: reg 10 32bit mmio: [0x92000000-0x92ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729716] pci 0000:01:00.0: reg 14 64bit mmio: [0x80000000-0x8fffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729733] pci 0000:01:00.0: reg 1c 64bit mmio: [0x90000000-0x91ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729743] pci 0000:01:00.0: reg 24 io port: [0x5000-0x507f]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729752] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729834] pci 0000:00:01.0: bridge io port: [0x5000-0x5fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729837] pci 0000:00:01.0: bridge 32bit mmio: [0x90000000-0x92ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.729843] pci 0000:00:01.0: bridge 64bit mmio pref: [0x80000000-0x8fffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.0: bridge io port: [0x4000-0x4fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.0: bridge 32bit mmio: [0x9a300000-0x9b2fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x93000000-0x93ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.1: bridge 32bit mmio: [0x99300000-0x9a2fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.1: bridge 64bit mmio pref: [0x94000000-0x94ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:05:00.0: reg 10 64bit mmio: [0x98200000-0x9820ffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:05:00.0: PME# supported from D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:05:00.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.2: bridge io port: [0x2000-0x2fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.2: bridge 32bit mmio: [0x98200000-0x992fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x95000000-0x95ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:06:00.0: reg 10 32bit mmio: [0x97100000-0x97100fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:06:00.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.3: bridge io port: [0x1000-0x1fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.3: bridge 32bit mmio: [0x97100000-0x981fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:00:1c.3: bridge 64bit mmio pref: [0x96000000-0x96ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.0: reg 10 32bit mmio: [0x97000000-0x970007ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.0: supports D1 D2
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.0: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.1: reg 10 32bit mmio: [0x97000b00-0x97000bff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.1: supports D1 D2
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.1: PME# supported from D0 D1 D2 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.1: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.2: reg 10 32bit mmio: [0x97000a00-0x97000aff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.2: supports D1 D2
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.2: PME# supported from D0 D1 D2 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732002] pci 0000:07:00.2: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732034] pci 0000:07:00.3: reg 10 32bit mmio: [0x97000900-0x970009ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732088] pci 0000:07:00.3: supports D1 D2
Mar  6 16:33:38 maxim-laptop kernel: [    0.732090] pci 0000:07:00.3: PME# supported from D0 D1 D2 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732095] pci 0000:07:00.3: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732141] pci 0000:07:00.4: reg 10 32bit mmio: [0x97000800-0x970008ff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732194] pci 0000:07:00.4: supports D1 D2
Mar  6 16:33:38 maxim-laptop kernel: [    0.732196] pci 0000:07:00.4: PME# supported from D0 D1 D2 D3hot D3cold
Mar  6 16:33:38 maxim-laptop kernel: [    0.732202] pci 0000:07:00.4: PME# disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.732278] pci 0000:00:1e.0: transparent bridge
Mar  6 16:33:38 maxim-laptop kernel: [    0.732287] pci 0000:00:1e.0: bridge 32bit mmio: [0x97000000-0x970fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732333] bus 00 -> node 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.732341] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732774] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.732969] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.733163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.733358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.733563] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
Mar  6 16:33:38 maxim-laptop kernel: [    0.744473] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.744473] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.744473] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.744571] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.744752] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Mar  6 16:33:38 maxim-laptop kernel: [    0.744934] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.745114] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.745294] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
Mar  6 16:33:38 maxim-laptop kernel: [    0.745392] ACPI: WMI: Mapper loaded
Mar  6 16:33:38 maxim-laptop kernel: [    0.745392] SCSI subsystem initialized
Mar  6 16:33:38 maxim-laptop kernel: [    0.745392] PCI: Using ACPI for IRQ routing
Mar  6 16:33:38 maxim-laptop kernel: [    0.776062] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.776067] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Mar  6 16:33:38 maxim-laptop kernel: [    0.784009] Switched to high resolution mode on CPU 0
Mar  6 16:33:38 maxim-laptop kernel: [    0.785376] Switched to high resolution mode on CPU 1
Mar  6 16:33:38 maxim-laptop kernel: [    0.829008] pnp: PnP ACPI init
Mar  6 16:33:38 maxim-laptop kernel: [    0.829021] ACPI: bus type pnp registered
Mar  6 16:33:38 maxim-laptop kernel: [    0.830351] pnp 00:01: io resource (0x164e-0x164f) overlaps 0000:00:1c.3 BAR 7 (0x1000-0x1fff), disabling
Mar  6 16:33:38 maxim-laptop kernel: [    0.853543] pnp: PnP ACPI: found 10 devices
Mar  6 16:33:38 maxim-laptop kernel: [    0.853546] ACPI: ACPI bus type pnp unregistered
Mar  6 16:33:38 maxim-laptop kernel: [    0.853556] system 00:01: ioport range 0x600-0x60f has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853559] system 00:01: ioport range 0x610-0x610 has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853562] system 00:01: ioport range 0x800-0x80f has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853565] system 00:01: ioport range 0x810-0x817 has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853567] system 00:01: ioport range 0x400-0x47f has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853570] system 00:01: ioport range 0x500-0x53f has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853573] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853576] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853579] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853582] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853585] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853587] system 00:01: iomem range 0xfec00000-0xfec00fff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853590] system 00:01: iomem range 0xfee00000-0xfee00fff has been reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.853593] system 00:01: iomem range 0x32000000-0x320000ff could not be reserved
Mar  6 16:33:38 maxim-laptop kernel: [    0.858721] pci 0000:01:00.0: BAR 6: can't allocate mem resource [0x90000000-0x8fffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858736] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Mar  6 16:33:38 maxim-laptop kernel: [    0.858739] pci 0000:00:01.0:   IO window: 0x5000-0x5fff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858744] pci 0000:00:01.0:   MEM window: 0x90000000-0x92ffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858748] pci 0000:00:01.0:   PREFETCH window: 0x00000080000000-0x0000008fffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858753] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
Mar  6 16:33:38 maxim-laptop kernel: [    0.858757] pci 0000:00:1c.0:   IO window: 0x4000-0x4fff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858763] pci 0000:00:1c.0:   MEM window: 0x9a300000-0x9b2fffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858769] pci 0000:00:1c.0:   PREFETCH window: 0x00000093000000-0x00000093ffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858777] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:04
Mar  6 16:33:38 maxim-laptop kernel: [    0.858781] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858788] pci 0000:00:1c.1:   MEM window: 0x99300000-0x9a2fffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858793] pci 0000:00:1c.1:   PREFETCH window: 0x00000094000000-0x00000094ffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858802] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
Mar  6 16:33:38 maxim-laptop kernel: [    0.858805] pci 0000:00:1c.2:   IO window: 0x2000-0x2fff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858812] pci 0000:00:1c.2:   MEM window: 0x98200000-0x992fffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858817] pci 0000:00:1c.2:   PREFETCH window: 0x00000095000000-0x00000095ffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858826] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:06
Mar  6 16:33:38 maxim-laptop kernel: [    0.858829] pci 0000:00:1c.3:   IO window: 0x1000-0x1fff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858836] pci 0000:00:1c.3:   MEM window: 0x97100000-0x981fffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858841] pci 0000:00:1c.3:   PREFETCH window: 0x00000096000000-0x00000096ffffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858850] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
Mar  6 16:33:38 maxim-laptop kernel: [    0.858852] pci 0000:00:1e.0:   IO window: disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.858859] pci 0000:00:1e.0:   MEM window: 0x97000000-0x970fffff
Mar  6 16:33:38 maxim-laptop kernel: [    0.858864] pci 0000:00:1e.0:   PREFETCH window: disabled
Mar  6 16:33:38 maxim-laptop kernel: [    0.858880] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar  6 16:33:38 maxim-laptop kernel: [    0.858885] pci 0000:00:01.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858894] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar  6 16:33:38 maxim-laptop kernel: [    0.858899] pci 0000:00:1c.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858909] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Mar  6 16:33:38 maxim-laptop kernel: [    0.858914] pci 0000:00:1c.1: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858924] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  6 16:33:38 maxim-laptop kernel: [    0.858929] pci 0000:00:1c.2: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858940] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Mar  6 16:33:38 maxim-laptop kernel: [    0.858945] pci 0000:00:1c.3: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858953] pci 0000:00:1e.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    0.858958] bus: 00 index 0 io port: [0x00-0xffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858960] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858962] bus: 01 index 0 io port: [0x5000-0x5fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858965] bus: 01 index 1 mmio: [0x90000000-0x92ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858967] bus: 01 index 2 mmio: [0x80000000-0x8fffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858968] bus: 01 index 3 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858970] bus: 02 index 0 io port: [0x4000-0x4fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858972] bus: 02 index 1 mmio: [0x9a300000-0x9b2fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858974] bus: 02 index 2 mmio: [0x93000000-0x93ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858976] bus: 02 index 3 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858978] bus: 04 index 0 io port: [0x3000-0x3fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858980] bus: 04 index 1 mmio: [0x99300000-0x9a2fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858982] bus: 04 index 2 mmio: [0x94000000-0x94ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858984] bus: 04 index 3 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858986] bus: 05 index 0 io port: [0x2000-0x2fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858988] bus: 05 index 1 mmio: [0x98200000-0x992fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858990] bus: 05 index 2 mmio: [0x95000000-0x95ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858991] bus: 05 index 3 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858993] bus: 06 index 0 io port: [0x1000-0x1fff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858995] bus: 06 index 1 mmio: [0x97100000-0x981fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858997] bus: 06 index 2 mmio: [0x96000000-0x96ffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.858999] bus: 06 index 3 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859001] bus: 07 index 0 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859003] bus: 07 index 1 mmio: [0x97000000-0x970fffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859005] bus: 07 index 2 mmio: [0x0-0x0]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859007] bus: 07 index 3 io port: [0x00-0xffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859009] bus: 07 index 4 mmio: [0x000000-0xffffffffffffffff]
Mar  6 16:33:38 maxim-laptop kernel: [    0.859019] NET: Registered protocol family 2
Mar  6 16:33:38 maxim-laptop kernel: [    0.981055] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.981438] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.983423] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    0.983983] TCP: Hash tables configured (established 262144 bind 65536)
Mar  6 16:33:38 maxim-laptop kernel: [    0.983986] TCP reno registered
Mar  6 16:33:38 maxim-laptop kernel: [    1.029111] NET: Registered protocol family 1
Mar  6 16:33:38 maxim-laptop kernel: [    1.029244] checking if image is initramfs... it is
Mar  6 16:33:38 maxim-laptop kernel: [    3.653982] Freeing initrd memory: 22223k freed
Mar  6 16:33:38 maxim-laptop kernel: [    3.667789] audit: initializing netlink socket (disabled)
Mar  6 16:33:38 maxim-laptop kernel: [    3.667805] type=2000 audit(1236350000.665:1): initialized
Mar  6 16:33:38 maxim-laptop kernel: [    3.672851] VFS: Disk quotas dquot_6.5.1
Mar  6 16:33:38 maxim-laptop kernel: [    3.672937] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Mar  6 16:33:38 maxim-laptop kernel: [    3.672990] msgmni has been set to 4017
Mar  6 16:33:38 maxim-laptop kernel: [    3.673293] alg: No test for stdrng (krng)
Mar  6 16:33:38 maxim-laptop kernel: [    3.673303] io scheduler noop registered
Mar  6 16:33:38 maxim-laptop kernel: [    3.673305] io scheduler anticipatory registered
Mar  6 16:33:38 maxim-laptop kernel: [    3.673307] io scheduler deadline registered
Mar  6 16:33:38 maxim-laptop kernel: [    3.673370] io scheduler cfq registered (default)
Mar  6 16:33:38 maxim-laptop kernel: [    3.674207] pci 0000:01:00.0: Boot video device
Mar  6 16:33:38 maxim-laptop kernel: [    3.674250] ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs 5, found 4 [20080926]
Mar  6 16:33:38 maxim-laptop kernel: [    3.674407] ACPI Warning (nspredef-0252): \_SB_.PCI0._OSC: Parameter count mismatch - ASL declared 5, expected 4 [20080926]
Mar  6 16:33:38 maxim-laptop kernel: [    3.697433] ACPI Warning (nseval-0168): Insufficient arguments - method [_OSC] needs 5, found 4 [20080926]
Mar  6 16:33:38 maxim-laptop kernel: [    3.720525] pcieport-driver 0000:00:01.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    3.720563] pcieport-driver 0000:00:01.0: found MSI capability
Mar  6 16:33:38 maxim-laptop kernel: [    3.720589] pcieport-driver 0000:00:01.0: irq 511 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    3.720599] pci_express 0000:00:01.0:pcie00: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.720642] pci_express 0000:00:01.0:pcie02: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.720724] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    3.720773] pcieport-driver 0000:00:1c.0: found MSI capability
Mar  6 16:33:38 maxim-laptop kernel: [    3.720809] pcieport-driver 0000:00:1c.0: irq 510 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    3.720827] pci_express 0000:00:1c.0:pcie00: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.720865] pci_express 0000:00:1c.0:pcie02: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.720972] pcieport-driver 0000:00:1c.1: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    3.721026] pcieport-driver 0000:00:1c.1: found MSI capability
Mar  6 16:33:38 maxim-laptop kernel: [    3.721062] pcieport-driver 0000:00:1c.1: irq 509 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    3.721079] pci_express 0000:00:1c.1:pcie00: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721115] pci_express 0000:00:1c.1:pcie02: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721216] pcieport-driver 0000:00:1c.2: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    3.721265] pcieport-driver 0000:00:1c.2: found MSI capability
Mar  6 16:33:38 maxim-laptop kernel: [    3.721301] pcieport-driver 0000:00:1c.2: irq 508 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    3.721318] pci_express 0000:00:1c.2:pcie00: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721352] pci_express 0000:00:1c.2:pcie02: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721452] pcieport-driver 0000:00:1c.3: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    3.721501] pcieport-driver 0000:00:1c.3: found MSI capability
Mar  6 16:33:38 maxim-laptop kernel: [    3.721536] pcieport-driver 0000:00:1c.3: irq 507 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    3.721554] pci_express 0000:00:1c.3:pcie00: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721588] pci_express 0000:00:1c.3:pcie02: allocate port service
Mar  6 16:33:38 maxim-laptop kernel: [    3.721742] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Mar  6 16:33:38 maxim-laptop kernel: [    3.722033] vesafb: framebuffer at 0x91000000, mapped to 0xffffc20000080000, using 3072k, total 14336k
Mar  6 16:33:38 maxim-laptop kernel: [    3.722036] vesafb: mode is 1024x768x16, linelength=2048, pages=1
Mar  6 16:33:38 maxim-laptop kernel: [    3.722038] vesafb: scrolling: redraw
Mar  6 16:33:38 maxim-laptop kernel: [    3.722041] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Mar  6 16:33:38 maxim-laptop kernel: [    3.750792] Console: switching to colour frame buffer device 128x48
Mar  6 16:33:38 maxim-laptop kernel: [    3.779408] fb0: VESA VGA frame buffer device
Mar  6 16:33:38 maxim-laptop kernel: [    3.784793] ACPI: AC Adapter [AC] (off-line)
Mar  6 16:33:38 maxim-laptop kernel: [    4.108119] ACPI: Battery Slot [BAT0] (battery present)
Mar  6 16:33:38 maxim-laptop kernel: [    4.108257] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Mar  6 16:33:38 maxim-laptop kernel: [    4.108260] ACPI: Power Button (FF) [PWRF]
Mar  6 16:33:38 maxim-laptop kernel: [    4.108339] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0C:00/input/input1
Mar  6 16:33:38 maxim-laptop kernel: [    4.108342] ACPI: Power Button (CM) [PWRB]
Mar  6 16:33:38 maxim-laptop kernel: [    4.108416] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0D:00/input/input2
Mar  6 16:33:38 maxim-laptop kernel: [    4.108484] ACPI: Lid Switch [LID0]
Mar  6 16:33:38 maxim-laptop kernel: [    4.108556] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/PNP0C0E:00/input/input3
Mar  6 16:33:38 maxim-laptop kernel: [    4.108559] ACPI: Sleep Button (CM) [SLPB]
Mar  6 16:33:38 maxim-laptop kernel: [    4.216509] acpi device:37: registered as cooling_device0
Mar  6 16:33:38 maxim-laptop kernel: [    4.216788] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:34/device:35/input/input4
Mar  6 16:33:38 maxim-laptop kernel: [    4.216791] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
Mar  6 16:33:38 maxim-laptop kernel: [    4.217349] ACPI: SSDT 7FE74C90, 01EA (r1  PmRef  Cpu0Ist     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    4.217935] ACPI: SSDT 7FE73610, 05D7 (r1  PmRef  Cpu0Cst     3001 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    4.220604] Monitor-Mwait will be used to enter C-1 state
Mar  6 16:33:38 maxim-laptop kernel: [    4.220608] Monitor-Mwait will be used to enter C-2 state
Mar  6 16:33:38 maxim-laptop kernel: [    4.220610] Monitor-Mwait will be used to enter C-3 state
Mar  6 16:33:38 maxim-laptop kernel: [    4.220649] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Mar  6 16:33:38 maxim-laptop kernel: [    4.220691] processor ACPI_CPU:00: registered as cooling_device1
Mar  6 16:33:38 maxim-laptop kernel: [    4.220695] ACPI: Processor [CPU0] (supports 8 throttling states)
Mar  6 16:33:38 maxim-laptop kernel: [    4.221100] ACPI: SSDT 7FE74F10, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    4.221548] ACPI: SSDT 7FE76D10, 0083 (r1  PmRef  Cpu1Cst     3000 INTL 20051117)
Mar  6 16:33:38 maxim-laptop kernel: [    4.222601] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
Mar  6 16:33:38 maxim-laptop kernel: [    4.222648] processor ACPI_CPU:01: registered as cooling_device2
Mar  6 16:33:38 maxim-laptop kernel: [    4.222652] ACPI: Processor [CPU1] (supports 8 throttling states)
Mar  6 16:33:38 maxim-laptop kernel: [    4.254501] thermal LNXTHERM:01: registered as thermal_zone0
Mar  6 16:33:38 maxim-laptop kernel: [    4.266905] ACPI: Thermal Zone [TZ01] (0 C)
Mar  6 16:33:38 maxim-laptop kernel: [    4.449741] Non-volatile memory driver v1.2
Mar  6 16:33:38 maxim-laptop kernel: [    4.451170] brd: module loaded
Mar  6 16:33:38 maxim-laptop kernel: [    4.451876] loop: module loaded
Mar  6 16:33:38 maxim-laptop kernel: [    4.451994] nbd: registered device at major 43
Mar  6 16:33:38 maxim-laptop kernel: [    4.453830] Driver 'sd' needs updating - please use bus_type methods
Mar  6 16:33:38 maxim-laptop kernel: [    4.453863] Driver 'sr' needs updating - please use bus_type methods
Mar  6 16:33:38 maxim-laptop kernel: [    4.454223] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
Mar  6 16:33:38 maxim-laptop kernel: [    4.490077] serio: i8042 KBD port at 0x60,0x64 irq 1
Mar  6 16:33:38 maxim-laptop kernel: [    4.490082] serio: i8042 AUX port at 0x60,0x64 irq 12
Mar  6 16:33:38 maxim-laptop kernel: [    4.490247] mice: PS/2 mouse device common for all mice
Mar  6 16:33:38 maxim-laptop kernel: [    4.490280] i2c /dev entries driver
Mar  6 16:33:38 maxim-laptop kernel: [    4.490361] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  6 16:33:38 maxim-laptop kernel: [    4.514870] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
Mar  6 16:33:38 maxim-laptop kernel: [    4.568240] cpuidle: using governor ladder
Mar  6 16:33:38 maxim-laptop kernel: [    4.568664] cpuidle: using governor menu
Mar  6 16:33:38 maxim-laptop kernel: [    4.568697] sdhci: Secure Digital Host Controller Interface driver
Mar  6 16:33:38 maxim-laptop kernel: [    4.568699] sdhci: Copyright(c) Pierre Ossman
Mar  6 16:33:38 maxim-laptop kernel: [    4.568716] sdhci-pci 0000:07:00.1: SDHCI controller found [1180:0822] (rev 22)
Mar  6 16:33:38 maxim-laptop kernel: [    4.568733] sdhci-pci 0000:07:00.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
Mar  6 16:33:38 maxim-laptop kernel: [    4.568757] Marking TSC unstable due to TSC halts in idle
Mar  6 16:33:38 maxim-laptop kernel: [    4.569835] Registered led device: mmc0
Mar  6 16:33:38 maxim-laptop kernel: [    4.570894] mmc0: SDHCI controller on PCI [0000:07:00.1] using PIO
Mar  6 16:33:38 maxim-laptop kernel: [    4.570977] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
Mar  6 16:33:38 maxim-laptop kernel: [    4.570979] ALSA device list:
Mar  6 16:33:38 maxim-laptop kernel: [    4.570980]   No soundcards found.
Mar  6 16:33:38 maxim-laptop kernel: [    4.571053] Netfilter messages via NETLINK v0.30.
Mar  6 16:33:38 maxim-laptop kernel: [    4.571486] registered taskstats version 1
Mar  6 16:33:38 maxim-laptop kernel: [    4.571629] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Mar  6 16:33:38 maxim-laptop kernel: [    4.571631] EDD information not available.
Mar  6 16:33:38 maxim-laptop kernel: [    4.571699] Freeing unused kernel memory: 364k freed
Mar  6 16:33:38 maxim-laptop kernel: [    4.715436] fuse init (API version 7.10)
Mar  6 16:33:38 maxim-laptop kernel: [    4.824965] usbcore: registered new interface driver usbfs
Mar  6 16:33:38 maxim-laptop kernel: [    4.824993] usbcore: registered new interface driver hub
Mar  6 16:33:38 maxim-laptop kernel: [    4.829565] usbcore: registered new device driver usb
Mar  6 16:33:38 maxim-laptop kernel: [    4.832046] uhci_hcd: USB Universal Host Controller Interface driver
Mar  6 16:33:38 maxim-laptop kernel: [    4.832095] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar  6 16:33:38 maxim-laptop kernel: [    4.832105] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.832110] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Mar  6 16:33:38 maxim-laptop kernel: [    4.832159] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
Mar  6 16:33:38 maxim-laptop kernel: [    4.832205] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
Mar  6 16:33:38 maxim-laptop kernel: [    4.832310] usb usb1: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    4.832340] hub 1-0:1.0: USB hub found
Mar  6 16:33:38 maxim-laptop kernel: [    4.832347] hub 1-0:1.0: 2 ports detected
Mar  6 16:33:38 maxim-laptop kernel: [    4.832459] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Mar  6 16:33:38 maxim-laptop kernel: [    4.832467] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.832471] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Mar  6 16:33:38 maxim-laptop kernel: [    4.832493] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
Mar  6 16:33:38 maxim-laptop kernel: [    4.832535] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
Mar  6 16:33:38 maxim-laptop kernel: [    4.832612] usb usb2: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    4.832641] hub 2-0:1.0: USB hub found
Mar  6 16:33:38 maxim-laptop kernel: [    4.832646] hub 2-0:1.0: 2 ports detected
Mar  6 16:33:38 maxim-laptop kernel: [    4.832740] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar  6 16:33:38 maxim-laptop kernel: [    4.832747] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.832751] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Mar  6 16:33:38 maxim-laptop kernel: [    4.832772] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
Mar  6 16:33:38 maxim-laptop kernel: [    4.832809] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
Mar  6 16:33:38 maxim-laptop kernel: [    4.832888] usb usb3: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    4.832914] hub 3-0:1.0: USB hub found
Mar  6 16:33:38 maxim-laptop kernel: [    4.832920] hub 3-0:1.0: 2 ports detected
Mar  6 16:33:38 maxim-laptop kernel: [    4.833016] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  6 16:33:38 maxim-laptop kernel: [    4.833023] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.833026] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Mar  6 16:33:38 maxim-laptop kernel: [    4.833048] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
Mar  6 16:33:38 maxim-laptop kernel: [    4.833087] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
Mar  6 16:33:38 maxim-laptop kernel: [    4.833163] usb usb4: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    4.833188] hub 4-0:1.0: USB hub found
Mar  6 16:33:38 maxim-laptop kernel: [    4.833194] hub 4-0:1.0: 2 ports detected
Mar  6 16:33:38 maxim-laptop kernel: [    4.833288] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  6 16:33:38 maxim-laptop kernel: [    4.833295] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.833298] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Mar  6 16:33:38 maxim-laptop kernel: [    4.833320] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
Mar  6 16:33:38 maxim-laptop kernel: [    4.833355] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
Mar  6 16:33:38 maxim-laptop kernel: [    4.833433] usb usb5: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    4.833458] hub 5-0:1.0: USB hub found
Mar  6 16:33:38 maxim-laptop kernel: [    4.833464] hub 5-0:1.0: 2 ports detected
Mar  6 16:33:38 maxim-laptop kernel: [    4.971115] ohci1394 0000:07:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Mar  6 16:33:38 maxim-laptop kernel: [    4.971123] ohci1394 0000:07:00.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.984218] tg3.c:v3.94 (August 14, 2008)
Mar  6 16:33:38 maxim-laptop kernel: [    4.984279] tg3 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Mar  6 16:33:38 maxim-laptop kernel: [    4.984294] tg3 0000:05:00.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    4.995912] libata version 3.00 loaded.
Mar  6 16:33:38 maxim-laptop kernel: [    4.998672] ata_piix 0000:00:1f.1: version 2.12
Mar  6 16:33:38 maxim-laptop kernel: [    4.998683] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Mar  6 16:33:38 maxim-laptop kernel: [    4.998725] ata_piix 0000:00:1f.1: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    5.023914] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[97000000-970007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
Mar  6 16:33:38 maxim-laptop kernel: [    5.031356] eth0: Tigon3 [partno(BCM95787m) rev b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:1b:38:c8:50:f3
Mar  6 16:33:38 maxim-laptop kernel: [    5.031360] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
Mar  6 16:33:38 maxim-laptop kernel: [    5.031363] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Mar  6 16:33:38 maxim-laptop kernel: [    5.031560] scsi0 : ata_piix
Mar  6 16:33:38 maxim-laptop kernel: [    5.031998] scsi1 : ata_piix
Mar  6 16:33:38 maxim-laptop kernel: [    5.032039] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60e0 irq 14
Mar  6 16:33:38 maxim-laptop kernel: [    5.032042] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60e8 irq 15
Mar  6 16:33:38 maxim-laptop kernel: [    5.144170] usb 4-2: new full speed USB device using uhci_hcd and address 2
Mar  6 16:33:38 maxim-laptop kernel: [    5.196554] ata1.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WP03, max UDMA/33
Mar  6 16:33:38 maxim-laptop kernel: [    5.212484] ata1.00: configured for UDMA/33
Mar  6 16:33:38 maxim-laptop kernel: [    5.339279] usb 4-2: configuration #1 chosen from 1 choice
Mar  6 16:33:38 maxim-laptop kernel: [    5.405151] isa bounce pool size: 16 pages
Mar  6 16:33:38 maxim-laptop kernel: [    5.408875] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-T20N  WP03 PQ: 0 ANSI: 5
Mar  6 16:33:38 maxim-laptop kernel: [    5.420801] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Mar  6 16:33:38 maxim-laptop kernel: [    5.420807] Uniform CD-ROM driver Revision: 3.20
Mar  6 16:33:38 maxim-laptop kernel: [    5.420962] sr 0:0:0:0: Attached scsi CD-ROM sr0
Mar  6 16:33:38 maxim-laptop kernel: [    5.421054] sr 0:0:0:0: Attached scsi generic sg0 type 5
Mar  6 16:33:38 maxim-laptop kernel: [    5.421207] ahci 0000:00:1f.2: version 3.0
Mar  6 16:33:38 maxim-laptop kernel: [    5.421223] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  6 16:33:38 maxim-laptop kernel: [    5.421290] ahci 0000:00:1f.2: irq 506 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [    5.421369] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
Mar  6 16:33:38 maxim-laptop kernel: [    5.421373] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
Mar  6 16:33:38 maxim-laptop kernel: [    5.421379] ahci 0000:00:1f.2: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [    5.422589] scsi2 : ahci
Mar  6 16:33:38 maxim-laptop kernel: [    5.422678] scsi3 : ahci
Mar  6 16:33:38 maxim-laptop kernel: [    5.423635] scsi4 : ahci
Mar  6 16:33:38 maxim-laptop kernel: [    5.423690] ata3: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304100 irq 506
Mar  6 16:33:38 maxim-laptop kernel: [    5.423694] ata4: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304180 irq 506
Mar  6 16:33:38 maxim-laptop kernel: [    5.423697] ata5: SATA max UDMA/133 abar m2048@0x9b304000 port 0x9b304200 irq 506
Mar  6 16:33:38 maxim-laptop kernel: [    5.504099] Clocksource tsc unstable (delta = -230857709 ns)
Mar  6 16:33:38 maxim-laptop kernel: [    6.080154] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Mar  6 16:33:38 maxim-laptop kernel: [    6.305633] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[b64057b700023f7c]
Mar  6 16:33:38 maxim-laptop kernel: [    6.464933] ata3.00: ATA-8: TOSHIBA MK1646GSX, LB113J, max UDMA/100
Mar  6 16:33:38 maxim-laptop kernel: [    6.464939] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
Mar  6 16:33:38 maxim-laptop kernel: [    6.465896] ata3.00: configured for UDMA/100
Mar  6 16:33:38 maxim-laptop kernel: [    6.801120] ata4: SATA link down (SStatus 0 SControl 300)
Mar  6 16:33:38 maxim-laptop kernel: [    7.152126] ata5: SATA link down (SStatus 0 SControl 300)
Mar  6 16:33:38 maxim-laptop kernel: [    7.185234] scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MK1646GS LB11 PQ: 0 ANSI: 5
Mar  6 16:33:38 maxim-laptop kernel: [    7.185829] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
Mar  6 16:33:38 maxim-laptop kernel: [    7.185845] sd 2:0:0:0: [sda] Write Protect is off
Mar  6 16:33:38 maxim-laptop kernel: [    7.185848] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Mar  6 16:33:38 maxim-laptop kernel: [    7.185872] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  6 16:33:38 maxim-laptop kernel: [    7.185946] sd 2:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
Mar  6 16:33:38 maxim-laptop kernel: [    7.185961] sd 2:0:0:0: [sda] Write Protect is off
Mar  6 16:33:38 maxim-laptop kernel: [    7.185963] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
Mar  6 16:33:38 maxim-laptop kernel: [    7.185987] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  6 16:33:38 maxim-laptop kernel: [    7.185990]  sda: sda1 sda3 sda4
Mar  6 16:33:38 maxim-laptop kernel: [    7.275930] sd 2:0:0:0: [sda] Attached SCSI disk
Mar  6 16:33:38 maxim-laptop kernel: [    7.275991] sd 2:0:0:0: Attached scsi generic sg1 type 0
Mar  6 16:33:38 maxim-laptop kernel: [    7.491870] PM: Starting manual resume from disk
Mar  6 16:33:38 maxim-laptop kernel: [    7.541160] EXT3-fs: mounted filesystem with ordered data mode.
Mar  6 16:33:38 maxim-laptop kernel: [    7.541242] kjournald starting.  Commit interval 5 seconds
Mar  6 16:33:38 maxim-laptop kernel: [   13.960909] udevd version 124 started
Mar  6 16:33:38 maxim-laptop kernel: [   14.467309] iTCO_vendor_support: vendor-support=0
Mar  6 16:33:38 maxim-laptop kernel: [   15.016021] nvidia: module license 'NVIDIA' taints kernel.
Mar  6 16:33:38 maxim-laptop kernel: [   15.111888] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
Mar  6 16:33:38 maxim-laptop kernel: [   15.112167] iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
Mar  6 16:33:38 maxim-laptop kernel: [   15.112246] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Mar  6 16:33:38 maxim-laptop kernel: [   15.288918] nvidia 0000:01:00.0: power state changed by ACPI to D0
Mar  6 16:33:38 maxim-laptop kernel: [   15.288931] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar  6 16:33:38 maxim-laptop kernel: [   15.288940] nvidia 0000:01:00.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [   15.289158] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  177.82  Tue Nov  4 16:50:05 PST 2008
Mar  6 16:33:38 maxim-laptop kernel: [   15.576187] cfg80211: Using static regulatory domain info
Mar  6 16:33:38 maxim-laptop kernel: [   15.576192] cfg80211: Regulatory domain: US
Mar  6 16:33:38 maxim-laptop kernel: [   15.576195] ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576199] ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576204] ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576207] ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576211] ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576215] ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576219] ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.576230] cfg80211: Calling CRDA for country: IL
Mar  6 16:33:38 maxim-laptop kernel: [   15.860178] cfg80211: Regulatory domain changed to country: IL
Mar  6 16:33:38 maxim-laptop kernel: [   15.860182] ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Mar  6 16:33:38 maxim-laptop kernel: [   15.860185] ^I(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Mar  6 16:33:38 maxim-laptop kernel: [   15.912667] lib80211: common routines for IEEE802.11 drivers
Mar  6 16:33:38 maxim-laptop kernel: [   15.912671] lib80211_crypt: registered algorithm 'NULL'
Mar  6 16:33:38 maxim-laptop kernel: [   15.997653] Linux video capture interface: v2.00
Mar  6 16:33:38 maxim-laptop kernel: [   16.413708] uvcvideo: Found UVC 1.00 device Acer CrystalEye webcam (064e:a101)
Mar  6 16:33:38 maxim-laptop kernel: [   16.417304] usbcore: registered new interface driver uvcvideo
Mar  6 16:33:38 maxim-laptop kernel: [   16.417308] USB Video Class driver (v0.1.0)
Mar  6 16:33:38 maxim-laptop kernel: [   16.489551] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
Mar  6 16:33:38 maxim-laptop kernel: [   16.533255] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Mar  6 16:33:38 maxim-laptop kernel: [   16.533485] HDA Intel 0000:00:1b.0: irq 505 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [   16.533533] HDA Intel 0000:00:1b.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [   16.581456] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input7
Mar  6 16:33:38 maxim-laptop kernel: [   17.040031] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Mar  6 16:33:38 maxim-laptop kernel: [   17.040036] iwl3945: Copyright(c) 2003-2009 Intel Corporation
Mar  6 16:33:38 maxim-laptop kernel: [   17.040144] iwl3945 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Mar  6 16:33:38 maxim-laptop kernel: [   17.040161] iwl3945 0000:06:00.0: setting latency timer to 64
Mar  6 16:33:38 maxim-laptop kernel: [   17.093063] iwl3945 0000:06:00.0: Tunable channels: 13 802.11bg, 0 802.11a channels
Mar  6 16:33:38 maxim-laptop kernel: [   17.093066] iwl3945 0000:06:00.0: Detected Intel Wireless WiFi Link 3945BG
Mar  6 16:33:38 maxim-laptop kernel: [   17.093197] iwl3945 0000:06:00.0: irq 504 for MSI/MSI-X
Mar  6 16:33:38 maxim-laptop kernel: [   17.093829] phy0: Selected rate control algorithm 'iwl-3945-rs'
Mar  6 16:33:38 maxim-laptop kernel: [   17.528850] rtc_cmos 00:03: RTC can wake from S4
Mar  6 16:33:38 maxim-laptop kernel: [   17.528913] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Mar  6 16:33:38 maxim-laptop kernel: [   17.528950] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
Mar  6 16:33:38 maxim-laptop kernel: [   17.688397] Adding 3068404k swap on /dev/sda3.  Priority:-1 extents:1 across:3068404k
Mar  6 16:33:38 maxim-laptop kernel: [   17.720510] EXT3 FS on sda4, internal journal
Mar  6 16:33:38 maxim-laptop kernel: [   18.630194] ip_tables: (C) 2000-2006 Netfilter Core Team
Mar  6 16:33:38 maxim-laptop kernel: [   19.332081] RPC: Registered udp transport module.
Mar  6 16:33:38 maxim-laptop kernel: [   19.332085] RPC: Registered tcp transport module.
Mar  6 16:33:38 maxim-laptop kernel: [   21.928938] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Mar  6 16:33:39 maxim-laptop kernel: [   22.503557] NET: Registered protocol family 10
Mar  6 16:33:39 maxim-laptop kernel: [   22.504500] lo: Disabled Privacy Extensions
Mar  6 16:33:44 maxim-laptop kernel: [   27.681023] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Mar  6 16:33:44 maxim-laptop kernel: [   27.767775] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Mar  6 16:33:44 maxim-laptop kernel: [   27.781174] NFSD: starting 90-second grace period
Mar  6 16:33:45 maxim-laptop kernel: [   28.780330] vboxdrv: Trying to deactivate the NMI watchdog permanently...
Mar  6 16:33:45 maxim-laptop kernel: [   28.780335] vboxdrv: Successfully done.
Mar  6 16:33:45 maxim-laptop kernel: [   28.780338] vboxdrv: Found 2 processor cores.
Mar  6 16:33:45 maxim-laptop kernel: [   28.780873] VBoxDrv: dbg - g_abExecMemory=ffffffffa0bb2a60
Mar  6 16:33:45 maxim-laptop kernel: [   28.780906] vboxdrv: fAsync=0 offMin=0x2bc offMax=0x184c
Mar  6 16:33:45 maxim-laptop kernel: [   28.782378] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
Mar  6 16:33:45 maxim-laptop kernel: [   28.782382] vboxdrv: Successfully loaded version 2.1.4 (interface 0x000a0009).
Mar  6 16:33:45 maxim-laptop kernel: [   28.996118] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa0d4f940
Mar  6 16:33:46 maxim-laptop kernel: [   29.776085] PPP generic driver version 2.4.2
Mar  6 16:33:46 maxim-laptop kernel: [   29.789326] NET: Registered protocol family 24
Mar  6 16:33:53 maxim-laptop kernel: [   36.002376] tg3 0000:05:00.0: irq 503 for MSI/MSI-X
Mar  6 16:33:53 maxim-laptop kernel: [   36.207713] ADDRCONF(NETDEV_UP): eth0: link is not ready
Mar  6 16:33:53 maxim-laptop kernel: [   36.240987] iwl3945 0000:06:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar  6 16:33:53 maxim-laptop kernel: [   36.352725] iwl3945 0000:06:00.0: loaded firmware version 15.28.2.8
Mar  6 16:33:53 maxim-laptop kernel: [   36.400240] Registered led device: iwl-phy0::radio
Mar  6 16:33:53 maxim-laptop kernel: [   36.400260] Registered led device: iwl-phy0::assoc
Mar  6 16:33:53 maxim-laptop kernel: [   36.400277] Registered led device: iwl-phy0::RX
Mar  6 16:33:53 maxim-laptop kernel: [   36.400293] Registered led device: iwl-phy0::TX
Mar  6 16:33:53 maxim-laptop kernel: [   36.433905] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar  6 16:33:53 maxim-laptop kernel: [   36.513802] NET: Registered protocol family 17
Mar  6 16:33:54 maxim-laptop kernel: [   37.809511] wlan0: direct probe to AP ffff88007e5279e0 try 1
Mar  6 16:33:55 maxim-laptop kernel: [   38.009144] wlan0: direct probe to AP ffff88007e5279e0 try 2
Mar  6 16:33:55 maxim-laptop kernel: [   38.209058] wlan0: direct probe to AP ffff88007e5279e0 try 3
Mar  6 16:33:55 maxim-laptop kernel: [   38.409055] wlan0: direct probe to AP ffff88007e5279e0 timed out
Mar  6 16:33:59 maxim-laptop kernel: [   42.732223] wlan0: authenticate with AP ffff88007e5279e0
Mar  6 16:33:59 maxim-laptop kernel: [   42.734140] wlan0: authenticated
Mar  6 16:33:59 maxim-laptop kernel: [   42.734143] wlan0: associate with AP ffff88007e5279e0
Mar  6 16:33:59 maxim-laptop kernel: [   42.736717] wlan0: RX AssocResp from ffff88007d796026 (capab=0x411 status=0 aid=1)
Mar  6 16:33:59 maxim-laptop kernel: [   42.736721] wlan0: associated
Mar  6 16:33:59 maxim-laptop kernel: [   42.740743] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Mar  6 16:34:09 maxim-laptop kernel: [   52.929122] wlan0: no IPv6 routers present
Mar  6 16:36:27 maxim-laptop kernel: [  190.649425] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Mar  6 16:36:27 maxim-laptop kernel: [  190.649430] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
Mar  6 16:36:27 maxim-laptop kernel: [  190.649474] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  6 16:36:27 maxim-laptop kernel: [  190.649549] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Mar  6 16:36:27 maxim-laptop kernel: [  190.649555] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Mar  6 16:36:27 maxim-laptop kernel: [  190.649617] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
Mar  6 16:36:27 maxim-laptop kernel: [  190.653540] ehci_hcd 0000:00:1a.7: debug port 1
Mar  6 16:36:27 maxim-laptop kernel: [  190.653550] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Mar  6 16:36:27 maxim-laptop kernel: [  190.653563] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x9b304c00
Mar  6 16:36:27 maxim-laptop kernel: [  190.668139] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Mar  6 16:36:27 maxim-laptop kernel: [  190.668307] usb usb6: configuration #1 chosen from 1 choice
Mar  6 16:36:27 maxim-laptop kernel: [  190.668366] hub 6-0:1.0: USB hub found
Mar  6 16:36:27 maxim-laptop kernel: [  190.668379] hub 6-0:1.0: 4 ports detected
Mar  6 16:36:27 maxim-laptop kernel: [  190.668610] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar  6 16:36:27 maxim-laptop kernel: [  190.668660] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Mar  6 16:36:27 maxim-laptop kernel: [  190.668666] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Mar  6 16:36:27 maxim-laptop kernel: [  190.668723] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
Mar  6 16:36:27 maxim-laptop kernel: [  190.672657] ehci_hcd 0000:00:1d.7: debug port 1
Mar  6 16:36:27 maxim-laptop kernel: [  190.672668] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Mar  6 16:36:27 maxim-laptop kernel: [  190.672681] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x9b304800
Mar  6 16:36:27 maxim-laptop kernel: [  190.688094] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Mar  6 16:36:27 maxim-laptop kernel: [  190.688260] usb usb7: configuration #1 chosen from 1 choice
Mar  6 16:36:27 maxim-laptop kernel: [  190.688317] hub 7-0:1.0: USB hub found
Mar  6 16:36:27 maxim-laptop kernel: [  190.688332] hub 7-0:1.0: 6 ports detected
Mar  6 16:36:27 maxim-laptop kernel: [  190.853198] usb 4-2: USB disconnect, address 2
Mar  6 16:36:28 maxim-laptop kernel: [  191.000139] usb 7-4: new high speed USB device using ehci_hcd and address 2
Mar  6 16:36:28 maxim-laptop kernel: [  191.142098] usb 7-4: configuration #1 chosen from 1 choice
Mar  6 16:36:28 maxim-laptop kernel: [  191.142481] uvcvideo: Found UVC 1.00 device Acer CrystalEye webcam (064e:a101)
Mar  6 16:37:03 maxim-laptop kernel: [  226.743967] wlan0 direct probe responded
Mar  6 16:37:03 maxim-laptop kernel: [  226.743974] wlan0: authenticate with AP ffff88007e5279e0
Mar  6 16:37:03 maxim-laptop kernel: [  226.746028] wlan0: authenticated
Mar  6 16:37:03 maxim-laptop kernel: [  226.746034] wlan0: associate with AP ffff88007e5279e0
Mar  6 16:37:03 maxim-laptop kernel: [  226.748845] wlan0: RX ReassocResp from ffff88007a40d026 (capab=0x411 status=0 aid=1)
Mar  6 16:37:03 maxim-laptop kernel: [  226.748850] wlan0: associated
Mar  6 16:37:11 maxim-laptop kernel: [  234.713048] wlan0: deauthenticated (Reason: 15)
Mar  6 16:37:12 maxim-laptop kernel: [  235.712175] wlan0: direct probe to AP ffff88007e5279e0 try 1
Mar  6 16:37:12 maxim-laptop kernel: [  235.715773] wlan0 direct probe responded
Mar  6 16:37:12 maxim-laptop kernel: [  235.715780] wlan0: authenticate with AP ffff88007e5279e0
Mar  6 16:37:12 maxim-laptop kernel: [  235.717766] wlan0: authenticated
Mar  6 16:37:12 maxim-laptop kernel: [  235.717771] wlan0: associate with AP ffff88007e5279e0
Mar  6 16:37:12 maxim-laptop kernel: [  235.720505] wlan0: RX ReassocResp from ffff880079c1f026 (capab=0x411 status=0 aid=1)
Mar  6 16:37:12 maxim-laptop kernel: [  235.720511] wlan0: associated
Mar  6 16:41:16 maxim-laptop kernel: [  479.937151] CE: hpet increasing min_delta_ns to 15000 nsec
Mar  6 16:42:11 maxim-laptop kernel: [  534.690940] rtc_cmos 00:03: RTC can wake from S4
Mar  6 16:42:11 maxim-laptop kernel: [  534.691033] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Mar  6 16:42:11 maxim-laptop kernel: [  534.691081] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
Mar  6 16:46:52 maxim-laptop kernel: [  815.904148] usb 7-1: new high speed USB device using ehci_hcd and address 3
Mar  6 16:46:53 maxim-laptop kernel: [  816.057348] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:50:55 maxim-laptop kernel: [ 1058.786475] usb 7-1: USB disconnect, address 3
Mar  6 16:50:56 maxim-laptop kernel: [ 1059.376175] usb 7-1: new high speed USB device using ehci_hcd and address 4
Mar  6 16:50:56 maxim-laptop kernel: [ 1059.529573] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:51:06 maxim-laptop kernel: [ 1069.232848] usb 7-1: usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
Mar  6 16:51:11 maxim-laptop kernel: [ 1074.232244] usb 7-1: usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
Mar  6 16:51:38 maxim-laptop kernel: [ 1101.032089] CE: hpet increasing min_delta_ns to 22500 nsec
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325061] uhci_hcd 0000:00:1d.2: remove, state 4
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325076] usb usb5: USB disconnect, address 1
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325605] uhci_hcd 0000:00:1d.2: USB bus 5 deregistered
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325680] uhci_hcd 0000:00:1d.2: PCI INT C disabled
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325698] uhci_hcd 0000:00:1d.1: remove, state 4
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.325709] usb usb4: USB disconnect, address 1
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326163] uhci_hcd 0000:00:1d.1: USB bus 4 deregistered
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326226] uhci_hcd 0000:00:1d.1: PCI INT B disabled
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326242] uhci_hcd 0000:00:1d.0: remove, state 4
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326252] usb usb3: USB disconnect, address 1
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326700] uhci_hcd 0000:00:1d.0: USB bus 3 deregistered
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326764] uhci_hcd 0000:00:1d.0: PCI INT A disabled
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326781] uhci_hcd 0000:00:1a.1: remove, state 4
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.326791] usb usb2: USB disconnect, address 1
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327238] uhci_hcd 0000:00:1a.1: USB bus 2 deregistered
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327300] uhci_hcd 0000:00:1a.1: PCI INT B disabled
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327316] uhci_hcd 0000:00:1a.0: remove, state 4
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327327] usb usb1: USB disconnect, address 1
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327768] uhci_hcd 0000:00:1a.0: USB bus 1 deregistered
Mar  6 16:51:56 maxim-laptop kernel: [ 1119.327832] uhci_hcd 0000:00:1a.0: PCI INT A disabled
Mar  6 16:52:03 maxim-laptop kernel: [ 1126.619487] usb 7-1: USB disconnect, address 4
Mar  6 16:52:04 maxim-laptop kernel: [ 1127.616172] usb 7-1: new high speed USB device using ehci_hcd and address 5
Mar  6 16:52:04 maxim-laptop kernel: [ 1127.771058] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:52:29 maxim-laptop kernel: [ 1152.198365] usb 7-1: USB disconnect, address 5
Mar  6 16:52:29 maxim-laptop kernel: [ 1152.596149] usb 7-1: new high speed USB device using ehci_hcd and address 6
Mar  6 16:52:29 maxim-laptop kernel: [ 1152.748970] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:52:44 maxim-laptop kernel: [ 1167.996484] usb 7-1: USB disconnect, address 6
Mar  6 16:52:45 maxim-laptop kernel: [ 1168.548155] usb 7-1: new high speed USB device using ehci_hcd and address 7
Mar  6 16:52:45 maxim-laptop kernel: [ 1168.700543] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:54:16 maxim-laptop kernel: [ 1259.420501] usb 7-1: USB disconnect, address 7
Mar  6 16:54:16 maxim-laptop kernel: [ 1259.700124] usb 7-1: new high speed USB device using ehci_hcd and address 8
Mar  6 16:54:16 maxim-laptop kernel: [ 1259.756487] hub 7-0:1.0: unable to enumerate USB device on port 1
Mar  6 16:54:19 maxim-laptop kernel: [ 1262.892156] usb 7-3: new high speed USB device using ehci_hcd and address 9
Mar  6 16:54:20 maxim-laptop kernel: [ 1263.026579] usb 7-3: configuration #1 chosen from 1 choice
Mar  6 16:55:07 maxim-laptop kernel: [ 1310.474257] usb 7-3: USB disconnect, address 9
Mar  6 16:55:08 maxim-laptop kernel: [ 1311.121146] usb 7-3: new high speed USB device using ehci_hcd and address 10
Mar  6 16:55:08 maxim-laptop kernel: [ 1311.280236] usb 7-3: configuration #1 chosen from 1 choice
Mar  6 16:55:19 maxim-laptop kernel: [ 1322.552349] usb 7-3: usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -110
Mar  6 16:55:42 maxim-laptop kernel: [ 1345.814010] usb 7-3: USB disconnect, address 10
Mar  6 16:55:43 maxim-laptop kernel: [ 1346.512173] usb 7-3: new high speed USB device using ehci_hcd and address 11
Mar  6 16:55:43 maxim-laptop kernel: [ 1346.665365] usb 7-3: configuration #1 chosen from 1 choice
Mar  6 16:55:58 maxim-laptop kernel: [ 1361.029946] usb 7-3: USB disconnect, address 11
Mar  6 16:56:00 maxim-laptop kernel: [ 1363.456146] usb 7-1: new high speed USB device using ehci_hcd and address 12
Mar  6 16:56:00 maxim-laptop kernel: [ 1363.590716] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:56:16 maxim-laptop kernel: [ 1379.130534] usb 7-1: USB disconnect, address 12
Mar  6 16:56:23 maxim-laptop kernel: [ 1386.464154] usb 7-5: new high speed USB device using ehci_hcd and address 13
Mar  6 16:56:23 maxim-laptop kernel: [ 1386.598718] usb 7-5: configuration #1 chosen from 1 choice
Mar  6 16:56:37 maxim-laptop kernel: [ 1400.435025] usb 7-5: USB disconnect, address 13
Mar  6 16:56:39 maxim-laptop kernel: [ 1402.448152] usb 6-1: new high speed USB device using ehci_hcd and address 2
Mar  6 16:56:39 maxim-laptop kernel: [ 1402.583548] usb 6-1: configuration #1 chosen from 1 choice
Mar  6 16:56:41 maxim-laptop kernel: [ 1404.056340] usb 6-1: usbfs: USBDEVFS_CONTROL failed cmd python rqt 128 rq 6 len 255 ret -71
Mar  6 16:57:26 maxim-laptop kernel: [ 1449.953092] usb 6-1: USB disconnect, address 2
Mar  6 16:57:28 maxim-laptop kernel: [ 1451.460154] usb 6-1: new high speed USB device using ehci_hcd and address 3
Mar  6 16:57:28 maxim-laptop kernel: [ 1451.594646] usb 6-1: configuration #1 chosen from 1 choice
Mar  6 16:57:44 maxim-laptop kernel: [ 1467.267565] usb 6-1: USB disconnect, address 3
Mar  6 16:57:50 maxim-laptop kernel: [ 1473.932155] usb 7-1: new high speed USB device using ehci_hcd and address 14
Mar  6 16:57:51 maxim-laptop kernel: [ 1474.066621] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:58:05 maxim-laptop kernel: [ 1488.840655] usb 7-1: USB disconnect, address 14
Mar  6 16:58:06 maxim-laptop kernel: [ 1489.249038] usb 7-1: new high speed USB device using ehci_hcd and address 15
Mar  6 16:58:06 maxim-laptop kernel: [ 1489.400881] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 16:59:41 maxim-laptop kernel: [ 1584.673540] usb 7-1: USB disconnect, address 15
Mar  6 16:59:42 maxim-laptop kernel: [ 1585.668162] usb 7-1: new high speed USB device using ehci_hcd and address 16
Mar  6 16:59:42 maxim-laptop kernel: [ 1585.821943] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:00:07 maxim-laptop kernel: [ 1610.726543] usb 7-1: USB disconnect, address 16
Mar  6 17:00:10 maxim-laptop kernel: [ 1613.264068] usb 7-3: new high speed USB device using ehci_hcd and address 17
Mar  6 17:00:10 maxim-laptop kernel: [ 1613.398995] usb 7-3: configuration #1 chosen from 1 choice
Mar  6 17:00:27 maxim-laptop kernel: [ 1630.239794] usb 7-3: USB disconnect, address 17
Mar  6 17:00:27 maxim-laptop kernel: [ 1630.804066] usb 7-3: new high speed USB device using ehci_hcd and address 18
Mar  6 17:00:27 maxim-laptop kernel: [ 1630.957783] usb 7-3: configuration #1 chosen from 1 choice
Mar  6 17:01:23 maxim-laptop kernel: [ 1686.602599] usb 7-3: USB disconnect, address 18
Mar  6 17:01:28 maxim-laptop kernel: [ 1691.276159] usb 6-1: new high speed USB device using ehci_hcd and address 4
Mar  6 17:01:28 maxim-laptop kernel: [ 1691.413080] usb 6-1: configuration #1 chosen from 1 choice
Mar  6 17:01:51 maxim-laptop kernel: [ 1714.267598] usb 6-1: USB disconnect, address 4
Mar  6 17:01:56 maxim-laptop kernel: [ 1719.070083] usb 7-1: new high speed USB device using ehci_hcd and address 19
Mar  6 17:01:56 maxim-laptop kernel: [ 1719.202797] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:02:46 maxim-laptop kernel: [ 1769.996433] usb 7-1: USB disconnect, address 19
Mar  6 17:02:47 maxim-laptop kernel: [ 1770.680184] usb 7-1: new high speed USB device using ehci_hcd and address 20
Mar  6 17:02:47 maxim-laptop kernel: [ 1770.833470] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:03:41 maxim-laptop kernel: [ 1824.788197] usb 7-1: USB disconnect, address 20
Mar  6 17:03:44 maxim-laptop kernel: [ 1827.752144] usb 7-1: new high speed USB device using ehci_hcd and address 21
Mar  6 17:03:44 maxim-laptop kernel: [ 1827.886664] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:04:54 maxim-laptop kernel: [ 1897.700139] iwl3945 0000:06:00.0: Error sending REPLY_RXON: time out after 500ms.
Mar  6 17:04:54 maxim-laptop kernel: [ 1897.700147] iwl3945 0000:06:00.0: Error clearing ASSOC_MSK on current configuration (-110).
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.349512] wlan0: direct probe to AP ffff88007e5279e0 try 1
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.354292] wlan0 direct probe responded
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.354298] wlan0: authenticate with AP ffff88007e5279e0
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.369028] wlan0: authenticated
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.369035] wlan0: associate with AP ffff88007e5279e0
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.371321] wlan0: RX AssocResp from ffff88007c0c5026 (capab=0x411 status=0 aid=1)
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.371327] wlan0: associated
Mar  6 17:05:19 maxim-laptop kernel: [ 1922.385523] wlan0: disassociating by local choice (reason=3)
Mar  6 17:05:30 maxim-laptop kernel: [ 1933.584714] wlan0: authenticate with AP ffff88007e5279e0
Mar  6 17:05:30 maxim-laptop kernel: [ 1933.586701] wlan0: authenticated
Mar  6 17:05:30 maxim-laptop kernel: [ 1933.586706] wlan0: associate with AP ffff88007e5279e0
Mar  6 17:05:30 maxim-laptop kernel: [ 1933.589328] wlan0: RX AssocResp from ffff88007ab1c026 (capab=0x411 status=0 aid=1)
Mar  6 17:05:30 maxim-laptop kernel: [ 1933.589333] wlan0: associated
Mar  6 17:07:59 maxim-laptop kernel: [ 2082.373149] CE: hpet increasing min_delta_ns to 33750 nsec
Mar  6 17:10:09 maxim-laptop kernel: [ 2212.381827] usb 7-1: USB disconnect, address 21
Mar  6 17:10:09 maxim-laptop kernel: [ 2212.780057] usb 7-1: new high speed USB device using ehci_hcd and address 22
Mar  6 17:10:09 maxim-laptop kernel: [ 2212.932578] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:11:30 maxim-laptop kernel: [ 2293.697868] usb 7-1: USB disconnect, address 22
Mar  6 17:11:32 maxim-laptop kernel: [ 2295.364092] usb 7-1: new high speed USB device using ehci_hcd and address 23
Mar  6 17:11:32 maxim-laptop kernel: [ 2295.502710] usb 7-1: configuration #1 chosen from 1 choice
Mar  6 17:13:03 maxim-laptop kernel: [ 2386.032222] nfsd: last server has exited, flushing export cache

--=-KzQ5JkeMwhTFZpcPDEyc--

