Return-Path: <linux-kernel-owner+w=401wt.eu-S2992756AbXCGXpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992756AbXCGXpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992776AbXCGXpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:45:25 -0500
Received: from hermes1.dur.ac.uk ([129.234.8.20]:52031 "EHLO hermes1.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992756AbXCGXpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:45:15 -0500
Date: Wed, 7 Mar 2007 23:49:14 +0000
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.torokhov@gmail.com
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with
 pci=noacpi
Message-Id: <20070307234914.430caffa.thatistosayiseenem@gawab.com>
In-Reply-To: <20070307212534.325f2f32.thatistosayiseenem@gawab.com>
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
	<20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
	<20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
	<20070307212534.325f2f32.thatistosayiseenem@gawab.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007 21:25:34 +0000
Ash Milsted <thatistosayiseenem@gawab.com> wrote:

> On Wed, 7 Mar 2007 12:00:04 +0000
> Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> 
> > On Sun, 4 Mar 2007 14:23:50 +0000
> > Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> > 
> > > On Sat, 3 Mar 2007 15:14:24 +0000
> > > Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> > > 
> > > > Hi,
> > > > With 2.6.21-rc2-git1 I have a problem with my ps/2 port keyboard - it only works
> > > > with one of the following on the command-line:
> > > >  - nolapic
> > > >  - irqfixup
> > > >  - pci=noacpi
> > > > Otherwise it gets stuck with the numlock on.
> > > > The following options have no effect:
> > > >  - nohz=off (who knows eh?)
> > > >  - pci=nomsi
> > > > 
> > snip
> > > > 
> > > > Ash
> > > 
> > > Just checked 2.6.21-rc2-mm1, still has the problem.
> > > Also, acpi=noirq fixes it too.
> > > To clarify, the problem is that my ps/2 port keyboard is completely frozen
> > > on boot - usually it gets activated when udev probes for hardware (my kernel
> > > config is highly modular). It worked fine with 2.6.20 and earlier with acpi 
> > > taking care of interrupt routing.
> > > 
> > > Ash
> > 
> > Any thoughts on this? It still occurs with 2.6.21-rc3. Here's my config
> > in case that helps. You'll see that I have swap-prefetch patched in (I
> > also have RDSL and some VM changes in there), but I have confirmed that
> > the problem occurs with no extra patches. By the way, I tested mm1 with
> > a rather different config (I used my distro package) and still saw the
> > problem.
> > 
> > Also, you should probably ignore that bit above where I suggest the
> > keyboard driver is being loaded as a module, because of course it
> > isn't.. Yet it does start responding (with pci=noacpi) at about that
> > time that udev does its thing.
> > 
> schnip
> 
> So, I tracked this down to 2.6.21-git7, the first snapshot that gives me
> this problem. Tellingly it does contain an input tree merge. I would git bisect
> but I don't have a local copy of the tree - I tried to get one, but it stopped
> halfway through the clone, probably because I had to use http... So, I hope that
> helps.
> 
> Ash
> 
> PS: I should have said I'm not subscribed, so please CC me on reply.
> PPS: That almost rhymes. Almost.

Apologies for only replying to my own mails, but I need to be CC'd if
any alternative is to be convenient :)

Linus, thanks for your detailed messages. I will try to get a bisect done, but 
the university firewall is likely to put up a fight against rsync as much as it
does with the git protocol. We will see. And yeah, that 2.6.21-git7 business was
a typo, should've been 2.6.20-git7, natch.

Anyway, here's the bootlog for Dmitry from a boot with broken keyboard (2.6.21-rc3):
Mar  7 23:16:41 joker syslog-ng[4349]: syslog-ng starting up; version='2.0.0' 
Mar  7 23:16:41 joker Linux version 2.6.21-beyondash (root@joker) (gcc version 4.1.2) #1 Wed Mar 7 11:39:45 GMT 2007
Mar  7 23:16:41 joker BIOS-provided physical RAM map:
Mar  7 23:16:41 joker sanitize start
Mar  7 23:16:41 joker sanitize end
Mar  7 23:16:41 joker copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
Mar  7 23:16:41 joker copy_e820_map() type is E820_RAM
Mar  7 23:16:41 joker copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
Mar  7 23:16:41 joker copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
Mar  7 23:16:41 joker copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 000000001fff0000 type: 1
Mar  7 23:16:41 joker copy_e820_map() type is E820_RAM
Mar  7 23:16:41 joker copy_e820_map() start: 000000001fff0000 size: 0000000000008000 end: 000000001fff8000 type: 3
Mar  7 23:16:41 joker copy_e820_map() start: 000000001fff8000 size: 0000000000008000 end: 0000000020000000 type: 4
Mar  7 23:16:41 joker copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
Mar  7 23:16:41 joker copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
Mar  7 23:16:41 joker copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 0000000100000000 type: 2
Mar  7 23:16:41 joker BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:16:41 joker BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:16:41 joker BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:16:41 joker BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:16:41 joker BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
Mar  7 23:16:41 joker BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
Mar  7 23:16:41 joker BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Mar  7 23:16:41 joker BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Mar  7 23:16:41 joker BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Mar  7 23:16:41 joker limit_regions start: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:16:41 joker limit_regions start: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:16:41 joker limit_regions start: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:16:41 joker limit_regions start: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:16:41 joker limit_regions start: 000000001fff0000 - 000000001fff8000 (ACPI data)
Mar  7 23:16:41 joker limit_regions start: 000000001fff8000 - 0000000020000000 (ACPI NVS)
Mar  7 23:16:41 joker limit_regions start: 00000000fec00000 - 00000000fec01000 (reserved)
Mar  7 23:16:41 joker limit_regions start: 00000000fee00000 - 00000000fee01000 (reserved)
Mar  7 23:16:41 joker limit_regions start: 00000000fff80000 - 0000000100000000 (reserved)
Mar  7 23:16:41 joker limit_regions endfor: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:16:41 joker limit_regions endfor: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:16:41 joker limit_regions endfor: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:16:41 joker limit_regions endfor: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:16:41 joker user-defined physical RAM map:
Mar  7 23:16:41 joker user: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:16:41 joker user: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:16:41 joker user: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:16:41 joker user: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:16:41 joker 511MB LOWMEM available.
Mar  7 23:16:41 joker Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Mar  7 23:16:41 joker Zone PFN ranges:
Mar  7 23:16:41 joker DMA             0 ->     4096
Mar  7 23:16:41 joker Normal       4096 ->   131056
Mar  7 23:16:41 joker early_node_map[1] active PFN ranges
Mar  7 23:16:41 joker 0:        0 ->   131056
Mar  7 23:16:41 joker On node 0 totalpages: 131056
Mar  7 23:16:41 joker DMA zone: 32 pages used for memmap
Mar  7 23:16:41 joker DMA zone: 0 pages reserved
Mar  7 23:16:41 joker DMA zone: 4064 pages, LIFO batch:0
Mar  7 23:16:41 joker Normal zone: 991 pages used for memmap
Mar  7 23:16:41 joker Normal zone: 125969 pages, LIFO batch:31
Mar  7 23:16:41 joker DMI 2.3 present.
Mar  7 23:16:41 joker ACPI: RSDP 000FA8C0, 0014 (r0 AMI   )
Mar  7 23:16:41 joker ACPI: RSDT 1FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT       97)
Mar  7 23:16:41 joker ACPI: FACP 1FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT       97)
Mar  7 23:16:41 joker ACPI: DSDT 1FFF0120, 3502 (r1    VIA    K7VT4     1000 MSFT  100000D)
Mar  7 23:16:41 joker ACPI: FACS 1FFF8000, 0040
Mar  7 23:16:41 joker ACPI: APIC 1FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT       97)
Mar  7 23:16:41 joker ACPI: PM-Timer IO Port: 0x808
Mar  7 23:16:41 joker ACPI: Local APIC address 0xfee00000
Mar  7 23:16:41 joker ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Mar  7 23:16:41 joker Processor #0 6:10 APIC version 16
Mar  7 23:16:41 joker ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Mar  7 23:16:41 joker IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
Mar  7 23:16:41 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Mar  7 23:16:41 joker ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Mar  7 23:16:41 joker ACPI: IRQ0 used by override.
Mar  7 23:16:41 joker ACPI: IRQ2 used by override.
Mar  7 23:16:41 joker ACPI: IRQ9 used by override.
Mar  7 23:16:41 joker Enabling APIC mode:  Flat.  Using 1 I/O APICs
Mar  7 23:16:41 joker Using ACPI (MADT) for SMP configuration information
Mar  7 23:16:41 joker Allocating PCI resources starting at 20000000 (gap: 1fff0000:e0010000)
Mar  7 23:16:41 joker Built 1 zonelists.  Total pages: 130033
Mar  7 23:16:41 joker Kernel command line: root=/dev/disk/by-label/root vga=ext ro agp=off i8042.debug log_buf_len=131072 mem=524224K
Mar  7 23:16:41 joker log_buf_len: 131072
Mar  7 23:16:41 joker mapped APIC to ffffd000 (fee00000)
Mar  7 23:16:41 joker mapped IOAPIC to ffffc000 (fec00000)
Mar  7 23:16:41 joker Enabling fast FPU save and restore... done.
Mar  7 23:16:41 joker Enabling unmasked SIMD FPU exception support... done.
Mar  7 23:16:41 joker Initializing CPU#0
Mar  7 23:16:41 joker CPU 0 irqstacks, hard=c0305000 soft=c0304000
Mar  7 23:16:41 joker PID hash table entries: 2048 (order: 11, 8192 bytes)
Mar  7 23:16:41 joker Detected 2198.078 MHz processor.
Mar  7 23:16:41 joker Console: colour VGA+ 80x50
Mar  7 23:16:41 joker Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Mar  7 23:16:41 joker Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Mar  7 23:16:41 joker Memory: 515908k/524224k available (1320k kernel code, 7740k reserved, 529k data, 188k init, 0k highmem)
Mar  7 23:16:41 joker virtual kernel memory layout:
Mar  7 23:16:41 joker fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
Mar  7 23:16:41 joker vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
Mar  7 23:16:41 joker lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Mar  7 23:16:41 joker .init : 0xc02d0000 - 0xc02ff000   ( 188 kB)
Mar  7 23:16:41 joker .data : 0xc024a19d - 0xc02ce994   ( 529 kB)
Mar  7 23:16:41 joker .text : 0xc0100000 - 0xc024a19d   (1320 kB)
Mar  7 23:16:41 joker Checking if this processor honours the WP bit even in supervisor mode... Ok.
Mar  7 23:16:41 joker Calibrating delay using timer specific routine.. 4398.73 BogoMIPS (lpj=2199367)
Mar  7 23:16:41 joker Mount-cache hash table entries: 512
Mar  7 23:16:41 joker CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
Mar  7 23:16:41 joker CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Mar  7 23:16:41 joker CPU: L2 Cache: 512K (64 bytes/line)
Mar  7 23:16:41 joker CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
Mar  7 23:16:41 joker Intel machine check architecture supported.
Mar  7 23:16:41 joker Intel machine check reporting enabled on CPU#0.
Mar  7 23:16:41 joker CPU: AMD Athlon(tm) XP 3200+ stepping 00
Mar  7 23:16:41 joker Checking 'hlt' instruction... OK.
Mar  7 23:16:41 joker ACPI: Core revision 20070126
Mar  7 23:16:41 joker ENABLING IO-APIC IRQs
Mar  7 23:16:41 joker ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Mar  7 23:16:41 joker NET: Registered protocol family 16
Mar  7 23:16:41 joker ACPI: bus type pci registered
Mar  7 23:16:41 joker PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
Mar  7 23:16:41 joker PCI: Using configuration type 1
Mar  7 23:16:41 joker Setting up standard PCI resources
Mar  7 23:16:41 joker ACPI: Interpreter enabled
Mar  7 23:16:41 joker ACPI: (supports S0 S1 S3 S4 S5)
Mar  7 23:16:41 joker ACPI: Using IOAPIC for interrupt routing
Mar  7 23:16:41 joker ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar  7 23:16:41 joker PCI: Probing PCI hardware (bus 00)
Mar  7 23:16:41 joker 0000:00:0f.1: cannot adjust BAR0 (not I/O)
Mar  7 23:16:41 joker 0000:00:0f.1: cannot adjust BAR1 (not I/O)
Mar  7 23:16:41 joker 0000:00:0f.1: cannot adjust BAR2 (not I/O)
Mar  7 23:16:41 joker 0000:00:0f.1: cannot adjust BAR3 (not I/O)
Mar  7 23:16:41 joker Boot video device is 0000:01:00.0
Mar  7 23:16:41 joker ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 12 14 15)
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 *12 14 15)
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 10 11 12 14 15)
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
Mar  7 23:16:41 joker ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
Mar  7 23:16:41 joker ACPI: Power Resource [URP1] (off)
Mar  7 23:16:41 joker ACPI: Power Resource [URP2] (off)
Mar  7 23:16:41 joker ACPI: Power Resource [FDDP] (off)
Mar  7 23:16:41 joker ACPI: Power Resource [LPTP] (off)
Mar  7 23:16:41 joker Linux Plug and Play Support v0.97 (c) Adam Belay
Mar  7 23:16:41 joker pnp: PnP ACPI init
Mar  7 23:16:41 joker pnp: PnP ACPI: found 11 devices
Mar  7 23:16:41 joker PCI: Using ACPI for IRQ routing
Mar  7 23:16:41 joker PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Mar  7 23:16:41 joker pnp: 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
Mar  7 23:16:41 joker pnp: 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
Mar  7 23:16:41 joker Time: tsc clocksource has been installed.
Mar  7 23:16:41 joker PCI: Bridge: 0000:00:01.0
Mar  7 23:16:41 joker IO window: disabled.
Mar  7 23:16:41 joker MEM window: dde00000-dfefffff
Mar  7 23:16:41 joker PREFETCH window: cdd00000-ddcfffff
Mar  7 23:16:41 joker PCI: Setting latency timer of device 0000:00:01.0 to 64
Mar  7 23:16:41 joker NET: Registered protocol family 2
Mar  7 23:16:41 joker IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Mar  7 23:16:41 joker TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Mar  7 23:16:41 joker TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
Mar  7 23:16:41 joker TCP: Hash tables configured (established 16384 bind 16384)
Mar  7 23:16:41 joker TCP reno registered
Mar  7 23:16:41 joker checking if image is initramfs... it is
Mar  7 23:16:41 joker Freeing initrd memory: 866k freed
Mar  7 23:16:41 joker Machine check exception polling timer started.
Mar  7 23:16:41 joker VFS: Disk quotas dquot_6.5.1
Mar  7 23:16:41 joker Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Mar  7 23:16:41 joker io scheduler noop registered
Mar  7 23:16:41 joker io scheduler anticipatory registered
Mar  7 23:16:41 joker io scheduler deadline registered
Mar  7 23:16:41 joker io scheduler cfq registered (default)
Mar  7 23:16:41 joker PCI: Bypassing VIA 8237 APIC De-Assert Message
Mar  7 23:16:41 joker input: Power Button (FF) as /class/input/input0
Mar  7 23:16:41 joker ACPI: Power Button (FF) [PWRF]
Mar  7 23:16:41 joker input: Power Button (CM) as /class/input/input1
Mar  7 23:16:41 joker ACPI: Power Button (CM) [PWRB]
Mar  7 23:16:41 joker input: Sleep Button (CM) as /class/input/input2
Mar  7 23:16:41 joker ACPI: Sleep Button (CM) [SLPB]
Mar  7 23:16:41 joker isapnp: Scanning for PnP cards...
Mar  7 23:16:41 joker isapnp: No Plug & Play device found
Mar  7 23:16:41 joker Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Mar  7 23:16:41 joker serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  7 23:16:41 joker 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  7 23:16:41 joker RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Mar  7 23:16:41 joker loop: loaded (max 8 devices)
Mar  7 23:16:41 joker PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Mar  7 23:16:41 joker PNP: PS/2 controller doesn't have AUX irq; using default 12
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 65 <- i8042 (return) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c:      -- i8042 (auxerr) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: a9 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 00 <- i8042 (return) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: a7 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 74 <- i8042 (return) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: a8 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 54 <- i8042 (return) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: d3 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c:      -- i8042 (auxerr) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [1]
Mar  7 23:16:41 joker serio: i8042 KBD port at 0x60,0x64 irq 1
Mar  7 23:16:41 joker serio: i8042 AUX port at 0x60,0x64 irq 12
Mar  7 23:16:41 joker mice: PS/2 mouse device common for all mice
Mar  7 23:16:41 joker TCP cubic registered
Mar  7 23:16:41 joker NET: Registered protocol family 1
Mar  7 23:16:41 joker NET: Registered protocol family 17
Mar  7 23:16:41 joker Using IPI Shortcut mode
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [1]
Mar  7 23:16:41 joker Freeing unused kernel memory: 188k freed
Mar  7 23:16:41 joker Switched to high resolution mode on CPU 0
Mar  7 23:16:41 joker SCSI subsystem initialized
Mar  7 23:16:41 joker libata version 2.20 loaded.
Mar  7 23:16:41 joker pata_via 0000:00:0f.1: version 0.2.1
Mar  7 23:16:41 joker ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 16
Mar  7 23:16:41 joker ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
Mar  7 23:16:41 joker ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
Mar  7 23:16:41 joker scsi0 : pata_via
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [201]
Mar  7 23:16:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c149489c), AE_AML_OPERAND_VALUE
Mar  7 23:16:41 joker ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
Mar  7 23:16:41 joker ata1.00: 160086528 sectors, multi 16: LBA 
Mar  7 23:16:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c149489c), AE_AML_OPERAND_VALUE
Mar  7 23:16:41 joker ata1.00: configured for UDMA/133
Mar  7 23:16:41 joker scsi1 : pata_via
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [401]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [401]
Mar  7 23:16:41 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [601]
Mar  7 23:16:42 joker drivers/input/serio/i8042.c: ed -> i8042 (parameter) [601]
Mar  7 23:16:42 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ata2.00: ATAPI, max UDMA/33
Mar  7 23:16:42 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ata2.01: ATAPI, max UDMA/33
Mar  7 23:16:42 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ata2.00: configured for UDMA/33
Mar  7 23:16:42 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:16:42 joker ata2.01: configured for UDMA/33
Mar  7 23:16:42 joker scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
Mar  7 23:16:42 joker scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8526B  1.03 PQ: 0 ANSI: 5
Mar  7 23:16:42 joker scsi 1:0:1:0: CD-ROM            LITE-ON  DVD SOHD-167T    9S19 PQ: 0 ANSI: 5
Mar  7 23:16:42 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
Mar  7 23:16:42 joker sda: Write Protect is off
Mar  7 23:16:42 joker sda: Mode Sense: 00 3a 00 00
Mar  7 23:16:42 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  7 23:16:42 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
Mar  7 23:16:42 joker sda: Write Protect is off
Mar  7 23:16:42 joker sda: Mode Sense: 00 3a 00 00
Mar  7 23:16:42 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  7 23:16:42 joker sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  7 23:16:42 joker sd 0:0:0:0: Attached scsi disk sda
Mar  7 23:16:42 joker sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
Mar  7 23:16:42 joker Uniform CD-ROM driver Revision: 3.20
Mar  7 23:16:42 joker sr 1:0:0:0: Attached scsi CD-ROM sr0
Mar  7 23:16:42 joker sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Mar  7 23:16:42 joker sr 1:0:1:0: Attached scsi CD-ROM sr1
Mar  7 23:16:42 joker kjournald starting.  Commit interval 5 seconds
Mar  7 23:16:42 joker EXT3-fs: mounted filesystem with ordered data mode.
Mar  7 23:16:42 joker usbcore: registered new interface driver usbfs
Mar  7 23:16:42 joker usbcore: registered new interface driver hub
Mar  7 23:16:42 joker usbcore: registered new device driver usb
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 17
Mar  7 23:16:42 joker Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
Mar  7 23:16:42 joker Real Time Clock Driver v1.12ac
Mar  7 23:16:42 joker i2c /dev entries driver
Mar  7 23:16:42 joker fuse init (API version 7.8)
Mar  7 23:16:42 joker sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  7 23:16:42 joker sr 1:0:0:0: Attached scsi generic sg1 type 5
Mar  7 23:16:42 joker sr 1:0:1:0: Attached scsi generic sg2 type 5
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 18
Mar  7 23:16:42 joker rt2500 1.1.0 CVS CVS http://rt2x00.serialmonkey.com
Mar  7 23:16:42 joker gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io 0xec00, speed 1217kHz
Mar  7 23:16:42 joker ieee1394: Initialized config rom entry `ip1394'
Mar  7 23:16:42 joker sata_via 0000:00:0f.0: version 2.1
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 16
Mar  7 23:16:42 joker sata_via 0000:00:0f.0: routed to hard irq line 10
Mar  7 23:16:42 joker ata3: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 16
Mar  7 23:16:42 joker ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 16
Mar  7 23:16:42 joker scsi2 : sata_via
Mar  7 23:16:42 joker USB Universal Host Controller Interface driver v3.0
Mar  7 23:16:42 joker ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Mar  7 23:16:42 joker ATA: abnormal status 0x7F on port 0x0001e807
Mar  7 23:16:42 joker scsi3 : sata_via
Mar  7 23:16:42 joker via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
Mar  7 23:16:42 joker ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Mar  7 23:16:42 joker ATA: abnormal status 0x7F on port 0x0001e007
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 19
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.0: UHCI Host Controller
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.0: irq 19, io base 0x0000c000
Mar  7 23:16:42 joker usb usb1: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker hub 1-0:1.0: USB hub found
Mar  7 23:16:42 joker hub 1-0:1.0: 2 ports detected
Mar  7 23:16:42 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [6758]
Mar  7 23:16:42 joker drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [6758]
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 19
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.1: UHCI Host Controller
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.1: irq 19, io base 0x0000c400
Mar  7 23:16:42 joker usb usb2: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker hub 2-0:1.0: USB hub found
Mar  7 23:16:42 joker hub 2-0:1.0: 2 ports detected
Mar  7 23:16:42 joker PPP generic driver version 2.4.2
Mar  7 23:16:42 joker input: PC Speaker as /class/input/input3
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 19
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.2: UHCI Host Controller
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.2: irq 19, io base 0x0000c800
Mar  7 23:16:42 joker usb usb3: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker hub 3-0:1.0: USB hub found
Mar  7 23:16:42 joker hub 3-0:1.0: 2 ports detected
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 19
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.3: UHCI Host Controller
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
Mar  7 23:16:42 joker uhci_hcd 0000:00:10.3: irq 19, io base 0x0000cc00
Mar  7 23:16:42 joker usb usb4: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker hub 4-0:1.0: USB hub found
Mar  7 23:16:42 joker hub 4-0:1.0: 2 ports detected
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:0b.2[B] -> GSI 16 (level, low) -> IRQ 20
Mar  7 23:16:42 joker parport: PnPBIOS parport detected.
Mar  7 23:16:42 joker parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
Mar  7 23:16:42 joker usb 2-1: new low speed USB device using uhci_hcd and address 2
Mar  7 23:16:42 joker rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
Mar  7 23:16:42 joker pnp: Device 00:07 does not support disabling.
Mar  7 23:16:42 joker rtc_cmos: probe of 00:07 failed with error -16
Mar  7 23:16:42 joker usb 2-1: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[dfff9800-dfff9fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 19
Mar  7 23:16:42 joker ehci_hcd 0000:00:10.4: EHCI Host Controller
Mar  7 23:16:42 joker ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
Mar  7 23:16:42 joker ehci_hcd 0000:00:10.4: irq 19, io mem 0xdfff9600
Mar  7 23:16:42 joker ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  7 23:16:42 joker usb usb5: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker hub 5-0:1.0: USB hub found
Mar  7 23:16:42 joker hub 5-0:1.0: 8 ports detected
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 21
Mar  7 23:16:42 joker eth0: VIA Rhine II at 0xdfff9500, 00:0b:6a:99:27:12, IRQ 21.
Mar  7 23:16:42 joker eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
Mar  7 23:16:42 joker ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
Mar  7 23:16:42 joker PCI: Setting latency timer of device 0000:00:11.5 to 64
Mar  7 23:16:42 joker usb 2-1: USB disconnect, address 2
Mar  7 23:16:42 joker lp0: using parport0 (interrupt-driven).
Mar  7 23:16:42 joker usbcore: registered new interface driver hiddev
Mar  7 23:16:42 joker usbcore: registered new interface driver usbhid
Mar  7 23:16:42 joker drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Mar  7 23:16:42 joker ppdev: user-space parallel port driver
Mar  7 23:16:42 joker usb 2-1: new low speed USB device using uhci_hcd and address 3
Mar  7 23:16:42 joker ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00910047b3]
Mar  7 23:16:42 joker usb 2-1: configuration #1 chosen from 1 choice
Mar  7 23:16:42 joker input: HID 1241:1177 as /class/input/input4
Mar  7 23:16:42 joker input: USB HID v1.00 Mouse [HID 1241:1177] on usb-0000:00:10.1-1
Mar  7 23:16:42 joker EXT3 FS on sda2, internal journal
Mar  7 23:16:42 joker Adding 1534168k swap on /dev/disk/by-label/swap.  Priority:-1 extents:1 across:1534168k
Mar  7 23:16:42 joker init: Going single user
--reset--

And here's one with acpi=noirq..
Mar  7 23:20:41 joker syslog-ng[4340]: syslog-ng starting up; version='2.0.0' 
Mar  7 23:20:41 joker Linux version 2.6.21-beyondash (root@joker) (gcc version 4.1.2) #1 Wed Mar 7 11:39:45 GMT 2007
Mar  7 23:20:41 joker BIOS-provided physical RAM map:
Mar  7 23:20:41 joker sanitize start
Mar  7 23:20:41 joker sanitize end
Mar  7 23:20:41 joker copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
Mar  7 23:20:41 joker copy_e820_map() type is E820_RAM
Mar  7 23:20:41 joker copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
Mar  7 23:20:41 joker copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
Mar  7 23:20:41 joker copy_e820_map() start: 0000000000100000 size: 000000001fef0000 end: 000000001fff0000 type: 1
Mar  7 23:20:41 joker copy_e820_map() type is E820_RAM
Mar  7 23:20:41 joker copy_e820_map() start: 000000001fff0000 size: 0000000000008000 end: 000000001fff8000 type: 3
Mar  7 23:20:41 joker copy_e820_map() start: 000000001fff8000 size: 0000000000008000 end: 0000000020000000 type: 4
Mar  7 23:20:41 joker copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
Mar  7 23:20:41 joker copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
Mar  7 23:20:41 joker copy_e820_map() start: 00000000fff80000 size: 0000000000080000 end: 0000000100000000 type: 2
Mar  7 23:20:41 joker BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:20:41 joker BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:20:41 joker BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:20:41 joker BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:20:41 joker BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
Mar  7 23:20:41 joker BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
Mar  7 23:20:41 joker BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
Mar  7 23:20:41 joker BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Mar  7 23:20:41 joker BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Mar  7 23:20:41 joker limit_regions start: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:20:41 joker limit_regions start: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:20:41 joker limit_regions start: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:20:41 joker limit_regions start: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:20:41 joker limit_regions start: 000000001fff0000 - 000000001fff8000 (ACPI data)
Mar  7 23:20:41 joker limit_regions start: 000000001fff8000 - 0000000020000000 (ACPI NVS)
Mar  7 23:20:41 joker limit_regions start: 00000000fec00000 - 00000000fec01000 (reserved)
Mar  7 23:20:41 joker limit_regions start: 00000000fee00000 - 00000000fee01000 (reserved)
Mar  7 23:20:41 joker limit_regions start: 00000000fff80000 - 0000000100000000 (reserved)
Mar  7 23:20:41 joker limit_regions endfor: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:20:41 joker limit_regions endfor: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:20:41 joker limit_regions endfor: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:20:41 joker limit_regions endfor: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:20:41 joker user-defined physical RAM map:
Mar  7 23:20:41 joker user: 0000000000000000 - 000000000009fc00 (usable)
Mar  7 23:20:41 joker user: 000000000009fc00 - 00000000000a0000 (reserved)
Mar  7 23:20:41 joker user: 00000000000f0000 - 0000000000100000 (reserved)
Mar  7 23:20:41 joker user: 0000000000100000 - 000000001fff0000 (usable)
Mar  7 23:20:41 joker 511MB LOWMEM available.
Mar  7 23:20:41 joker Entering add_active_range(0, 0, 131056) 0 entries of 256 used
Mar  7 23:20:41 joker Zone PFN ranges:
Mar  7 23:20:41 joker DMA             0 ->     4096
Mar  7 23:20:41 joker Normal       4096 ->   131056
Mar  7 23:20:41 joker early_node_map[1] active PFN ranges
Mar  7 23:20:41 joker 0:        0 ->   131056
Mar  7 23:20:41 joker On node 0 totalpages: 131056
Mar  7 23:20:41 joker DMA zone: 32 pages used for memmap
Mar  7 23:20:41 joker DMA zone: 0 pages reserved
Mar  7 23:20:41 joker DMA zone: 4064 pages, LIFO batch:0
Mar  7 23:20:41 joker Normal zone: 991 pages used for memmap
Mar  7 23:20:41 joker Normal zone: 125969 pages, LIFO batch:31
Mar  7 23:20:41 joker DMI 2.3 present.
Mar  7 23:20:41 joker ACPI: RSDP 000FA8C0, 0014 (r0 AMI   )
Mar  7 23:20:41 joker ACPI: RSDT 1FFF0000, 002C (r1 AMIINT VIA_K7         10 MSFT       97)
Mar  7 23:20:41 joker ACPI: FACP 1FFF0030, 0081 (r1 AMIINT VIA_K7         11 MSFT       97)
Mar  7 23:20:41 joker ACPI: DSDT 1FFF0120, 3502 (r1    VIA    K7VT4     1000 MSFT  100000D)
Mar  7 23:20:41 joker ACPI: FACS 1FFF8000, 0040
Mar  7 23:20:41 joker ACPI: APIC 1FFF00C0, 0054 (r1 AMIINT VIA_K7          9 MSFT       97)
Mar  7 23:20:41 joker ACPI: PM-Timer IO Port: 0x808
Mar  7 23:20:41 joker ACPI: Local APIC address 0xfee00000
Mar  7 23:20:41 joker ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Mar  7 23:20:41 joker Processor #0 6:10 APIC version 16
Mar  7 23:20:41 joker Allocating PCI resources starting at 20000000 (gap: 1fff0000:e0010000)
Mar  7 23:20:41 joker Built 1 zonelists.  Total pages: 130033
Mar  7 23:20:41 joker Kernel command line: root=/dev/disk/by-label/root vga=ext ro agp=off acpi=noirq i8042.debug log_buf_len=131072 mem=524224K
Mar  7 23:20:41 joker log_buf_len: 131072
Mar  7 23:20:41 joker Found and enabled local APIC!
Mar  7 23:20:41 joker mapped APIC to ffffd000 (fee00000)
Mar  7 23:20:41 joker Enabling fast FPU save and restore... done.
Mar  7 23:20:41 joker Enabling unmasked SIMD FPU exception support... done.
Mar  7 23:20:41 joker Initializing CPU#0
Mar  7 23:20:41 joker CPU 0 irqstacks, hard=c0305000 soft=c0304000
Mar  7 23:20:41 joker PID hash table entries: 2048 (order: 11, 8192 bytes)
Mar  7 23:20:41 joker Detected 2198.078 MHz processor.
Mar  7 23:20:41 joker Console: colour VGA+ 80x50
Mar  7 23:20:41 joker Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Mar  7 23:20:41 joker Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Mar  7 23:20:41 joker Memory: 515908k/524224k available (1320k kernel code, 7740k reserved, 529k data, 188k init, 0k highmem)
Mar  7 23:20:41 joker virtual kernel memory layout:
Mar  7 23:20:41 joker fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
Mar  7 23:20:41 joker vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
Mar  7 23:20:41 joker lowmem  : 0xc0000000 - 0xdfff0000   ( 511 MB)
Mar  7 23:20:41 joker .init : 0xc02d0000 - 0xc02ff000   ( 188 kB)
Mar  7 23:20:41 joker .data : 0xc024a19d - 0xc02ce994   ( 529 kB)
Mar  7 23:20:41 joker .text : 0xc0100000 - 0xc024a19d   (1320 kB)
Mar  7 23:20:41 joker Checking if this processor honours the WP bit even in supervisor mode... Ok.
Mar  7 23:20:41 joker Calibrating delay using timer specific routine.. 4398.73 BogoMIPS (lpj=2199367)
Mar  7 23:20:41 joker Mount-cache hash table entries: 512
Mar  7 23:20:41 joker CPU: After generic identify, caps: 0383fbff c1c3fbff 00000000 00000000 00000000 00000000 00000000
Mar  7 23:20:41 joker CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
Mar  7 23:20:41 joker CPU: L2 Cache: 512K (64 bytes/line)
Mar  7 23:20:41 joker CPU: After all inits, caps: 0383fbff c1c3fbff 00000000 00000420 00000000 00000000 00000000
Mar  7 23:20:41 joker Intel machine check architecture supported.
Mar  7 23:20:41 joker Intel machine check reporting enabled on CPU#0.
Mar  7 23:20:41 joker CPU: AMD Athlon(tm) XP 3200+ stepping 00
Mar  7 23:20:41 joker Checking 'hlt' instruction... OK.
Mar  7 23:20:41 joker ACPI: Core revision 20070126
Mar  7 23:20:41 joker ACPI: setting ELCR to 1e20 (from 1c20)
Mar  7 23:20:41 joker NET: Registered protocol family 16
Mar  7 23:20:41 joker ACPI: bus type pci registered
Mar  7 23:20:41 joker PCI: PCI BIOS revision 2.10 entry at 0xfda71, last bus=1
Mar  7 23:20:41 joker PCI: Using configuration type 1
Mar  7 23:20:41 joker Setting up standard PCI resources
Mar  7 23:20:41 joker ACPI: Interpreter enabled
Mar  7 23:20:41 joker ACPI: (supports S0 S1 S3 S4 S5)
Mar  7 23:20:41 joker ACPI: Using PIC for interrupt routing
Mar  7 23:20:41 joker ACPI: PCI Root Bridge [PCI0] (0000:00)
Mar  7 23:20:41 joker PCI: Probing PCI hardware (bus 00)
Mar  7 23:20:41 joker 0000:00:0f.1: cannot adjust BAR0 (not I/O)
Mar  7 23:20:41 joker 0000:00:0f.1: cannot adjust BAR1 (not I/O)
Mar  7 23:20:41 joker 0000:00:0f.1: cannot adjust BAR2 (not I/O)
Mar  7 23:20:41 joker 0000:00:0f.1: cannot adjust BAR3 (not I/O)
Mar  7 23:20:41 joker Boot video device is 0000:01:00.0
Mar  7 23:20:41 joker ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Mar  7 23:20:41 joker ACPI: Power Resource [URP1] (off)
Mar  7 23:20:41 joker ACPI: Power Resource [URP2] (off)
Mar  7 23:20:41 joker ACPI: Power Resource [FDDP] (off)
Mar  7 23:20:41 joker ACPI: Power Resource [LPTP] (off)
Mar  7 23:20:41 joker Linux Plug and Play Support v0.97 (c) Adam Belay
Mar  7 23:20:41 joker pnp: PnP ACPI init
Mar  7 23:20:41 joker pnp: PnP ACPI: found 11 devices
Mar  7 23:20:41 joker PCI: Probing PCI hardware
Mar  7 23:20:41 joker pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
Mar  7 23:20:41 joker PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
Mar  7 23:20:41 joker PCI: setting IRQ 11 as level-triggered
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:12.0
Mar  7 23:20:41 joker pnp: 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
Mar  7 23:20:41 joker pnp: 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
Mar  7 23:20:41 joker Time: tsc clocksource has been installed.
Mar  7 23:20:41 joker PCI: Bridge: 0000:00:01.0
Mar  7 23:20:41 joker IO window: disabled.
Mar  7 23:20:41 joker MEM window: dde00000-dfefffff
Mar  7 23:20:41 joker PREFETCH window: cdd00000-ddcfffff
Mar  7 23:20:41 joker PCI: Setting latency timer of device 0000:00:01.0 to 64
Mar  7 23:20:41 joker NET: Registered protocol family 2
Mar  7 23:20:41 joker IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Mar  7 23:20:41 joker TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Mar  7 23:20:41 joker TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
Mar  7 23:20:41 joker TCP: Hash tables configured (established 16384 bind 16384)
Mar  7 23:20:41 joker TCP reno registered
Mar  7 23:20:41 joker checking if image is initramfs... it is
Mar  7 23:20:41 joker Freeing initrd memory: 866k freed
Mar  7 23:20:41 joker Machine check exception polling timer started.
Mar  7 23:20:41 joker VFS: Disk quotas dquot_6.5.1
Mar  7 23:20:41 joker Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Mar  7 23:20:41 joker io scheduler noop registered
Mar  7 23:20:41 joker io scheduler anticipatory registered
Mar  7 23:20:41 joker io scheduler deadline registered
Mar  7 23:20:41 joker io scheduler cfq registered (default)
Mar  7 23:20:41 joker PCI: Bypassing VIA 8237 APIC De-Assert Message
Mar  7 23:20:41 joker input: Power Button (FF) as /class/input/input0
Mar  7 23:20:41 joker ACPI: Power Button (FF) [PWRF]
Mar  7 23:20:41 joker input: Power Button (CM) as /class/input/input1
Mar  7 23:20:41 joker ACPI: Power Button (CM) [PWRB]
Mar  7 23:20:41 joker input: Sleep Button (CM) as /class/input/input2
Mar  7 23:20:41 joker ACPI: Sleep Button (CM) [SLPB]
Mar  7 23:20:41 joker isapnp: Scanning for PnP cards...
Mar  7 23:20:41 joker isapnp: No Plug & Play device found
Mar  7 23:20:41 joker Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
Mar  7 23:20:41 joker serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  7 23:20:41 joker 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Mar  7 23:20:41 joker RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Mar  7 23:20:41 joker loop: loaded (max 8 devices)
Mar  7 23:20:41 joker PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
Mar  7 23:20:41 joker PNP: PS/2 controller doesn't have AUX irq; using default 12
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 65 <- i8042 (return) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: d3 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c:      -- i8042 (auxerr) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: a9 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 00 <- i8042 (return) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: a7 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 74 <- i8042 (return) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: a8 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 54 <- i8042 (return) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: d3 -> i8042 (command) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c:      -- i8042 (auxerr) [0]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [1]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 60 -> i8042 (command) [1]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [1]
Mar  7 23:20:41 joker serio: i8042 KBD port at 0x60,0x64 irq 1
Mar  7 23:20:41 joker serio: i8042 AUX port at 0x60,0x64 irq 12
Mar  7 23:20:41 joker mice: PS/2 mouse device common for all mice
Mar  7 23:20:41 joker TCP cubic registered
Mar  7 23:20:41 joker NET: Registered protocol family 1
Mar  7 23:20:41 joker NET: Registered protocol family 17
Mar  7 23:20:41 joker Using IPI Shortcut mode
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [1]
Mar  7 23:20:41 joker Freeing unused kernel memory: 188k freed
Mar  7 23:20:41 joker Switched to high resolution mode on CPU 0
Mar  7 23:20:41 joker SCSI subsystem initialized
Mar  7 23:20:41 joker libata version 2.20 loaded.
Mar  7 23:20:41 joker pata_via 0000:00:0f.1: version 0.2.1
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:12.0
Mar  7 23:20:41 joker PCI: VIA VLink IRQ fixup for 0000:00:0f.1, from 255 to 11
Mar  7 23:20:41 joker ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001fc00 irq 14
Mar  7 23:20:41 joker ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001fc08 irq 15
Mar  7 23:20:41 joker scsi0 : pata_via
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [201]
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c149489c), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
Mar  7 23:20:41 joker ata1.00: 160086528 sectors, multi 16: LBA 
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV0._GTF] (Node c149489c), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata1.00: configured for UDMA/133
Mar  7 23:20:41 joker scsi1 : pata_via
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [401]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [401]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [601]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: ed -> i8042 (parameter) [601]
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata2.00: ATAPI, max UDMA/33
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata2.01: ATAPI, max UDMA/33
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata2.00: configured for UDMA/33
Mar  7 23:20:41 joker ACPI Error (dsopcode-0481): Attempt to CreateField of length zero [20070126]
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.RATA] (Node c1494f04), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN1.DRV0._GTF] (Node c14947d4), AE_AML_OPERAND_VALUE
Mar  7 23:20:41 joker ata2.01: configured for UDMA/33
Mar  7 23:20:41 joker scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
Mar  7 23:20:41 joker scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8526B  1.03 PQ: 0 ANSI: 5
Mar  7 23:20:41 joker scsi 1:0:1:0: CD-ROM            LITE-ON  DVD SOHD-167T    9S19 PQ: 0 ANSI: 5
Mar  7 23:20:41 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
Mar  7 23:20:41 joker sda: Write Protect is off
Mar  7 23:20:41 joker sda: Mode Sense: 00 3a 00 00
Mar  7 23:20:41 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  7 23:20:41 joker SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
Mar  7 23:20:41 joker sda: Write Protect is off
Mar  7 23:20:41 joker sda: Mode Sense: 00 3a 00 00
Mar  7 23:20:41 joker SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Mar  7 23:20:41 joker sda:sr0: scsi3-mmc drive: 52x/52x writer cd/rw xa/form2 cdda tray
Mar  7 23:20:41 joker Uniform CD-ROM driver Revision: 3.20
Mar  7 23:20:41 joker sr 1:0:0:0: Attached scsi CD-ROM sr0
Mar  7 23:20:41 joker sr1: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Mar  7 23:20:41 joker sr 1:0:1:0: Attached scsi CD-ROM sr1
Mar  7 23:20:41 joker sda1 sda2 sda3 sda4 < sda5 sda6 >
Mar  7 23:20:41 joker sd 0:0:0:0: Attached scsi disk sda
Mar  7 23:20:41 joker kjournald starting.  Commit interval 5 seconds
Mar  7 23:20:41 joker EXT3-fs: mounted filesystem with ordered data mode.
Mar  7 23:20:41 joker usbcore: registered new interface driver usbfs
Mar  7 23:20:41 joker usbcore: registered new interface driver hub
Mar  7 23:20:41 joker usbcore: registered new device driver usb
Mar  7 23:20:41 joker PCI: setting IRQ 5 as level-triggered
Mar  7 23:20:41 joker PCI: Found IRQ 5 for device 0000:00:0b.0
Mar  7 23:20:41 joker Installing spdif_bug patch: Audigy 2 Platinum [SB0240P]
Mar  7 23:20:41 joker Real Time Clock Driver v1.12ac
Mar  7 23:20:41 joker i2c /dev entries driver
Mar  7 23:20:41 joker fuse init (API version 7.8)
Mar  7 23:20:41 joker sd 0:0:0:0: Attached scsi generic sg0 type 0
Mar  7 23:20:41 joker sr 1:0:0:0: Attached scsi generic sg1 type 5
Mar  7 23:20:41 joker sr 1:0:1:0: Attached scsi generic sg2 type 5
Mar  7 23:20:41 joker PCI: setting IRQ 12 as level-triggered
Mar  7 23:20:41 joker PCI: Found IRQ 12 for device 0000:00:0a.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:10.4
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:11.5
Mar  7 23:20:41 joker rt2500 1.1.0 CVS CVS http://rt2x00.serialmonkey.com
Mar  7 23:20:41 joker gameport: EMU10K1 is pci0000:00:0b.1/gameport0, io 0xec00, speed 1217kHz
Mar  7 23:20:41 joker USB Universal Host Controller Interface driver v3.0
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:10.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:12.0
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.0: UHCI Host Controller
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.0: irq 11, io base 0x0000c000
Mar  7 23:20:41 joker usb usb1: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker hub 1-0:1.0: USB hub found
Mar  7 23:20:41 joker hub 1-0:1.0: 2 ports detected
Mar  7 23:20:41 joker sata_via 0000:00:0f.0: version 2.1
Mar  7 23:20:41 joker PCI: setting IRQ 10 as level-triggered
Mar  7 23:20:41 joker PCI: Found IRQ 10 for device 0000:00:0f.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:10.3
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:10.2
Mar  7 23:20:41 joker sata_via 0000:00:0f.0: routed to hard irq line 10
Mar  7 23:20:41 joker ata3: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e402 bmdma 0x0001d800 irq 10
Mar  7 23:20:41 joker ata4: SATA max UDMA/133 cmd 0x0001e000 ctl 0x0001dc02 bmdma 0x0001d808 irq 10
Mar  7 23:20:41 joker scsi2 : sata_via
Mar  7 23:20:41 joker ieee1394: Initialized config rom entry `ip1394'
Mar  7 23:20:41 joker input: PC Speaker as /class/input/input3
Mar  7 23:20:41 joker via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
Mar  7 23:20:41 joker ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Mar  7 23:20:41 joker ATA: abnormal status 0x7F on port 0x0001e807
Mar  7 23:20:41 joker scsi3 : sata_via
Mar  7 23:20:41 joker ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
Mar  7 23:20:41 joker ATA: abnormal status 0x7F on port 0x0001e007
Mar  7 23:20:41 joker PCI: Found IRQ 12 for device 0000:00:10.4
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:0a.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:11.5
Mar  7 23:20:41 joker ehci_hcd 0000:00:10.4: EHCI Host Controller
Mar  7 23:20:41 joker ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 2
Mar  7 23:20:41 joker ehci_hcd 0000:00:10.4: irq 12, io mem 0xdfff9600
Mar  7 23:20:41 joker ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 12) [7050]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [7050]
Mar  7 23:20:41 joker usb usb2: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker hub 2-0:1.0: USB hub found
Mar  7 23:20:41 joker hub 2-0:1.0: 8 ports detected
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7052]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [7053]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [7053]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [7053]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7055]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [7055]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7057]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [7057]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7059]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [7059]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7061]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [7061]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7063]
Mar  7 23:20:41 joker input: AT Translated Set 2 keyboard as /class/input/input4
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:12.0
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.1: UHCI Host Controller
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.1: irq 11, io base 0x0000c400
Mar  7 23:20:41 joker usb usb3: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker hub 3-0:1.0: USB hub found
Mar  7 23:20:41 joker hub 3-0:1.0: 2 ports detected
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: d4 -> i8042 (command) [7194]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [7194]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7196]
Mar  7 23:20:41 joker atkbd.c: Spurious ACK on isa0060/serio0. Some program might be trying access hardware directly.
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [7196]
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [7197]
Mar  7 23:20:41 joker PPP generic driver version 2.4.2
Mar  7 23:20:41 joker parport: PnPBIOS parport detected.
Mar  7 23:20:41 joker parport0: PC-style at 0x378 (0x778), irq 7, dma 0 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
Mar  7 23:20:41 joker PCI: Found IRQ 10 for device 0000:00:10.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:0f.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:10.3
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.2: UHCI Host Controller
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.2: irq 10, io base 0x0000c800
Mar  7 23:20:41 joker usb usb4: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker hub 4-0:1.0: USB hub found
Mar  7 23:20:41 joker hub 4-0:1.0: 2 ports detected
Mar  7 23:20:41 joker drivers/input/serio/i8042.c: Interrupt 12, without any data [7255]
Mar  7 23:20:41 joker PCI: Found IRQ 10 for device 0000:00:10.3
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:0f.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 10 with 0000:00:10.2
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.3: UHCI Host Controller
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
Mar  7 23:20:41 joker uhci_hcd 0000:00:10.3: irq 10, io base 0x0000cc00
Mar  7 23:20:41 joker usb usb5: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker hub 5-0:1.0: USB hub found
Mar  7 23:20:41 joker hub 5-0:1.0: 2 ports detected
Mar  7 23:20:41 joker rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
Mar  7 23:20:41 joker pnp: Device 00:07 does not support disabling.
Mar  7 23:20:41 joker rtc_cmos: probe of 00:07 failed with error -16
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:12.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.0
Mar  7 23:20:41 joker eth0: VIA Rhine II at 0xdfff9500, 00:0b:6a:99:27:12, IRQ 11.
Mar  7 23:20:41 joker eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link 0021.
Mar  7 23:20:41 joker PCI: Found IRQ 11 for device 0000:00:0b.2
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:0f.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.1
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:10.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 11 with 0000:00:12.0
Mar  7 23:20:41 joker usb 3-1: new low speed USB device using uhci_hcd and address 2
Mar  7 23:20:41 joker ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[dfff9800-dfff9fff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Mar  7 23:20:41 joker PCI: Found IRQ 12 for device 0000:00:11.5
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:0a.0
Mar  7 23:20:41 joker PCI: Sharing IRQ 12 with 0000:00:10.4
Mar  7 23:20:41 joker PCI: Setting latency timer of device 0000:00:11.5 to 64
Mar  7 23:20:41 joker usb 3-1: configuration #1 chosen from 1 choice
Mar  7 23:20:41 joker lp0: using parport0 (interrupt-driven).
Mar  7 23:20:41 joker ppdev: user-space parallel port driver
Mar  7 23:20:41 joker usbcore: registered new interface driver hiddev
Mar  7 23:20:41 joker input: HID 1241:1177 as /class/input/input5
Mar  7 23:20:41 joker input: USB HID v1.00 Mouse [HID 1241:1177] on usb-0000:00:10.1-1
Mar  7 23:20:41 joker usbcore: registered new interface driver usbhid
Mar  7 23:20:41 joker drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Mar  7 23:20:41 joker ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c00910047b3]
Mar  7 23:20:41 joker EXT3 FS on sda2, internal journal
Mar  7 23:20:41 joker Adding 1534168k swap on /dev/disk/by-label/swap.  Priority:-1 extents:1 across:1534168k
Mar  7 23:20:42 joker init: Going single user
Mar  7 23:20:44 joker drivers/input/serio/i8042.c: 36 <- i8042 (interrupt, 0, 1) [14807]
Mar  7 23:20:44 joker drivers/input/serio/i8042.c: 06 <- i8042 (interrupt, 0, 1) [14894]
Mar  7 23:20:44 joker drivers/input/serio/i8042.c: 86 <- i8042 (interrupt, 0, 1) [15004]
Mar  7 23:20:44 joker drivers/input/serio/i8042.c: b6 <- i8042 (interrupt, 0, 1) [15058]
Mar  7 23:20:44 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15203]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15375]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15398]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15421]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15444]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [15467]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [15486]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [15579]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [15614]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [15667]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [15753]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [15765]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [15833]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [15876]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [15965]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [15973]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [16040]
Mar  7 23:20:45 joker drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [16153]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [16263]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [16302]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [16358]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [16463]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [16541]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [16573]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [16632]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [16712]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0, 1) [16780]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [16821]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 8b <- i8042 (interrupt, 0, 1) [16873]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [16886]
Mar  7 23:20:46 joker drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [16989]
etc etc
