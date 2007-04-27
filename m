Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbXD0WAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbXD0WAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757388AbXD0WAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:00:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58440 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440AbXD0WA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:00:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer;
        b=pit3e71wUNi2wfoNDFETAT/txZ9bRTrXi6gV0FRrlN1R0y83L4BRV8p8aM8VryksBYlWvABKzwHMIIWKJSGUdcm8sxSS207wELFOi5wNwm1V/o403pjwiVyQelC67QHa5/N03INJSHfY5f4C52dnzHHM1OPIxvNpPSicEy2iiy8=
Subject: Re: [linux-dvb] Re: More than 2Gb problem (dvb related) ?
From: Jon Burgess <jburgess777@googlemail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Gregoire Favre <Gregoire.Favre@gmail.com>, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
References: <20070427111047.GB10284@gmail.com>
	 <d9def9db0704271346i1556c59dgad222d5de7d919f6@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-fs6zZfmiFYZU9RoB7lLE"
Date: Fri, 27 Apr 2007 23:00:20 +0100
Message-Id: <1177711220.26292.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fs6zZfmiFYZU9RoB7lLE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2007-04-27 at 22:46 +0200, Markus Rechberger wrote:
> just for the completeness, what does dmesg show up?
> You forgot to mention what device you have too...
> 
> Markus
> 
> On 4/27/07, Gregoire Favre <Gregoire.Favre@gmail.com> wrote:
> > Hello,
> >
> > I have a computer (mother Asus Commando) with 4x1Gb Ram.
> >
> > If I start without the BIOS remap memory, my BIOS and linux just see 2Gb
> > of ram, and DVB apps works just great.
> >
> > When I enable the remapping of the memory, my BIOS and linux just see
> > the whole 4Gb but then, I can tune to any transponder without problem,
> > but I am unable to get a TS...
> >
> > I have tested it with vdr/kaffeine/mplayer.
> >
> > szap/kaffeine/vdr get the lock just well.
> >
> > I had already asked about this on just linux-dvb ml, but maybe I am the
> > first one to try DVB with a system with more than 2 Gb as I didn't
> > receive any further info as someone get it working or not with such
> > amount of ram.
> >
> > Anyone got an idea on what could be done to solve this issue ?
> >
> > PLEASE CC to me all message in lkml as I am not subscribed to this ml :)
> > --
> > Grégoire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.org
> >                http://picasaweb.google.com/Gregoire.Favre
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 

Interesting - I see similar symptoms after upgrading my PC:
* old PC was AMD Athlon 64 3000 w/ 2GB of RAM which had no issues
* new PC is a Intel Core 2 Duo w/ 4GB of RAM and fails in the way you
describe.

I have a Nova-T PCI using the budget-ci driver which I have been using
successfully for several years.

When the problem occurs the card tunes OK and even generates interrupts
at a normal rate - just no data reaches dvr0.

If I reload the driver multiple times it works some of the time. It
seems to work more reliably if I reload the driver while the machine is
under some other load, e.g. run "find /" in one window while performing
the following:

# modprobe -r budget_ci; sleep 1; modprobe budget_ci
$ tzap -r "BBC One"
$ cat /dev/dvb/adapter0/dvr0

if no random data appears repeat the modprobe and try again.

Since i've upgraded the whole of the machine it could be due to any
number of factors (RAM, CPU, SMP, Chipset ...).

The boot log is attached.

	Jon



--=-fs6zZfmiFYZU9RoB7lLE
Content-Disposition: attachment; filename=bootlog.txt
Content-Type: text/plain; name=bootlog.txt; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.21-1.3116 (jburgess@shark.nightingale.homedns.org) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)) #1 SMP Thu Apr 26 19:54:55 BST 2007
Command line: ro root=/dev/VolGroup00/LogVol00 vga=0x315 console=ttyS0,115200 console=tty0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf6e0000 (usable)
 BIOS-e820: 00000000cf6e0000 - 00000000cf6e3000 (ACPI NVS)
 BIOS-e820: 00000000cf6e3000 - 00000000cf6f0000 (ACPI data)
 BIOS-e820: 00000000cf6f0000 - 00000000cf700000 (reserved)
 BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
end_pfn_map = 1245184
DMI 2.4 present.
ACPI: RSDP 000F6DA0, 0014 (r0 GBT   )
ACPI: RSDT CF6E3040, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP CF6E30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT CF6E3180, 5222 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS CF6E0000, 0040
ACPI: HPET CF6E8500, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG CF6E8580, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC CF6E8400, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: SSDT CF6E8600, 015C (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
ACPI: SSDT CF6E8A90, 0275 (r1  PmRef    CpuPm     3000 INTL 20040311)
No NUMA configuration found
Faking a node at 0000000000000000-0000000130000000
Bootmem setup node 0 0000000000000000-0000000130000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1245184
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   849632
    0:  1048576 ->  1245184
ACPI: PM-Timer IO Port: 0x408
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009e000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000f0000
Nosave address range: 00000000000f0000 - 0000000000100000
Nosave address range: 00000000cf6e0000 - 00000000cf6e3000
Nosave address range: 00000000cf6e3000 - 00000000cf6f0000
Nosave address range: 00000000cf6f0000 - 00000000cf700000
Nosave address range: 00000000cf700000 - 00000000d0000000
Nosave address range: 00000000d0000000 - 00000000e0000000
Nosave address range: 00000000e0000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 44672 bytes of per cpu data
Built 1 zonelists.  Total pages: 1017022
Kernel command line: ro root=/dev/VolGroup00/LogVol00 vga=0x315 console=ttyS0,115200 console=tty0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2399.998 MHz processor.
Console: colour dummy device 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1648 kB
 per task-struct memory footprint: 1680 bytes
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x6e8a000 - 0xae8a000
Memory: 4008368k/4980736k available (2465k kernel code, 176200k reserved, 1445k data, 332k init)
Calibrating delay using timer specific routine.. 4803.21 BogoMIPS (lpj=2401605)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16666658
Detected 16.666 MHz APIC timer.
lockdep: not fixing up alternatives.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.02 BogoMIPS (lpj=2400013)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=22
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
pnp: 00:09: ioport range 0x400-0x4bf could not be reserved
pnp: 00:0a: iomem range 0xd0000000-0xdfffffff could not be reserved
pnp: 00:0b: iomem range 0xce000-0xcffff has been reserved
pnp: 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
Time: tsc clocksource has been installed.
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: 7000-7fff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 8000-9fff
  MEM window: f4100000-f41fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: a000-afff
  MEM window: f0000000-f1ffffff
  PREFETCH window: f4300000-f43fffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: f2000000-f3ffffff
  PREFETCH window: f4400000-f44fffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 65536 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3956k freed
audit: initializing netlink socket (disabled)
audit(1177621309.827:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
ksign: Installing public key data
Loading keyring
- Added public key 73CCE72D1E09A933
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xe0000000, mapped to 0xffffc20000080000, using 3750k, total 7616k
vesafb: mode is 800x600x32, linelength=3200, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
ACPI: Processor [CPU0] (supports 2 throttling states)
ACPI: SSDT CF6E8A00, 0087 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
ACPI: Processor [CPU1] (supports 2 throttling states)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Freeing unused kernel memory: 332k freed
Write protecting the kernel read-only data: 1058k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000c400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000d400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000cc00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
libusual: modprobe for usb-storage succeeded, but module is not present
input: ImExPS/2 Generic Explorer Mouse as /class/input/input2
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf4205000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
usb 3-2: new low speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4204000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  8760.000 MB/sec
raid5: using function: generic_sse (8760.000 MB/sec)
raid6: int64x1   2046 MB/s
raid6: int64x2   2527 MB/s
raid6: int64x4   1902 MB/s
raid6: int64x8   1859 MB/s
raid6: sse2x1    4164 MB/s
raid6: sse2x2    4230 MB/s
raid6: sse2x4    7117 MB/s
raid6: using algorithm sse2x4 (7117 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
usb 3-2: device not accepting address 2, error -71
usb 6-1: new high speed USB device using ehci_hcd and address 2
usb 6-1: configuration #1 chosen from 1 choice
usb 1-1: USB disconnect, address 2
libusual: modprobe for usb-storage succeeded, but module is not present
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xffffc2000002e100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata2: SATA max UDMA/133 cmd 0xffffc2000002e180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 cmd 0xffffc2000002e300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata6: SATA max UDMA/133 cmd 0xffffc2000002e380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
scsi0 : ahci
usb 3-2: new low speed USB device using uhci_hcd and address 4
usb 3-2: configuration #1 chosen from 1 choice
input: Microsoft Microsoft 3-Button Mouse with IntelliEye(TM) as /class/input/input3
input: USB HID v1.10 Mouse [Microsoft Microsoft 3-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 390719855, hpa_sectors = 390721968
ata1.00: Host Protected Area detected:
	current size: 390719855 sectors
	native size: 390721968 sectors
ata1.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata1.00: 390719855 sectors, multi 0: LBA48 
ata1.00: ata_hpa_resize 1: sectors = 390719855, hpa_sectors = 390721968
ata1.00: Host Protected Area detected:
	current size: 390719855 sectors
	native size: 390721968 sectors
ata1.00: configured for UDMA/133
scsi1 : ahci
usb 5-2: new low speed USB device using uhci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata2.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata2.00: 390721968 sectors, multi 0: LBA48 
ata2.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata2.00: configured for UDMA/133
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
hiddev96: USB HID v1.11 Device [Belkin  UPS] on usb-0000:00:1d.2-2
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata5.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata5.00: 390721968 sectors, multi 0: LBA48 
ata5.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata5.00: configured for UDMA/133
scsi5 : ahci
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata6.00: ATA-6: ST3200822AS, 3.01, max UDMA/133
ata6.00: 390721968 sectors, multi 0: LBA48 
ata6.00: ata_hpa_resize 1: sectors = 390721968, hpa_sectors = 390721968
ata6.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
SCSI device sda: 390719855 512-byte hdwr sectors (200049 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 390719855 512-byte hdwr sectors (200049 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 390721968 512-byte hdwr sectors (200050 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
scsi 4:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
SCSI device sdc: 390721968 512-byte hdwr sectors (200050 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 390721968 512-byte hdwr sectors (200050 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 4:0:0:0: Attached scsi disk sdc
scsi 5:0:0:0: Direct-Access     ATA      ST3200822AS      3.01 PQ: 0 ANSI: 5
SCSI device sdd: 390721968 512-byte hdwr sectors (200050 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdd: 390721968 512-byte hdwr sectors (200050 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2
sd 5:0:0:0: Attached scsi disk sdd
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ata7: SATA max UDMA/133 cmd 0xffffc20000030100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
ata8: SATA max UDMA/133 cmd 0xffffc20000030180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
scsi6 : ahci
ata7: SATA link down (SStatus 0 SControl 300)
scsi7 : ahci
ata8: SATA link down (SStatus 0 SControl 300)
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdd2 ...
md:  adding sdd2 ...
md: sdd1 has different UUID to sdd2
md:  adding sdc2 ...
md: sdc1 has different UUID to sdd2
md:  adding sdb2 ...
md: sdb1 has different UUID to sdd2
md:  adding sda2 ...
md: sda1 has different UUID to sdd2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: running: <sdd2><sdc2><sdb2><sda2>
raid5: device sdd2 operational as raid disk 1
raid5: device sdc2 operational as raid disk 0
raid5: device sdb2 operational as raid disk 3
raid5: device sda2 operational as raid disk 2
raid5: allocated 4274kB for md1
raid5: raid level 5 set md1 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdc2
 disk 1, o:1, dev:sdd2
 disk 2, o:1, dev:sda2
 disk 3, o:1, dev:sdb2
md: considering sdd1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: running: <sdd1><sdc1><sdb1><sda1>
md: personality for level 1 is not loaded!
md: do_md_run() returned -22
md: md0 stopped.
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdb1>
md: export_rdev(sdb1)
md: unbind<sda1>
md: export_rdev(sda1)
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1177621329.020:2): enforcing=1 old_enforcing=0 auid=4294967295
audit(1177621329.356:3): policy loaded auid=4294967295
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc_cmos: probe of 00:03 failed with error -16
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
eth0: RTL8169s/8110s at 0xffffc20000034000, 00:17:3f:0b:0e:12, IRQ 18
iTCO_vendor_support: vendor-support=0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
ata9: PATA max UDMA/100 cmd 0x0000000000018000 ctl 0x0000000000018402 bmdma 0x0000000000019000 irq 16
ata10: PATA max UDMA/100 cmd 0x0000000000018800 ctl 0x0000000000018c02 bmdma 0x0000000000019008 irq 16
scsi8 : pata_jmicron
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 5:0:0:0: Attached scsi generic sg3 type 0
saa7146: register extension 'budget_ci dvb'.
ata9.01: ATAPI, max UDMA/33
ata9.01: configured for UDMA/33
scsi9 : pata_jmicron
audit(1177621335.173:4): avc:  denied  { getattr } for  pid=1468 comm="pam_console_app" name="event2" dev=tmpfs ino=7067 scontext=system_u:system_r:pam_console_t:s0-s0:c0.c1023 tcontext=system_u:object_r:event_device_t:s0 tclass=chr_file
ATA: abnormal status 0x7F on port 0x0000000000018807
scsi 8:0:1:0: CD-ROM            _NEC     DVD_RW ND-4570A  1.02 PQ: 0 ANSI: 5
scsi 8:0:1:0: Attached scsi generic sg4 type 5
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem ffffc20000042000 (revision 1, irq 20) (0x13c2,0x1011).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-T	 PCI).
adapter has MAC addr = 00:d0:5c:22:22:b4
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input4
DVB: registering frontend 0 (Philips TDA10045H DVB-T)...
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
floppy0: no floppy controllers found
lp0: using parport0 (interrupt-driven).
lp0: console ready
No dock devices found.
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input6
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sda1 ...
md:  adding sda1 ...
md:  adding sdb1 ...
md:  adding sdc1 ...
md:  adding sdd1 ...
md: created md0
md: bind<sdd1>
md: bind<sdc1>
md: bind<sdb1>
md: bind<sda1>
md: running: <sda1><sdb1><sdc1><sdd1>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 4 out of 4 mirrors
md: ... autorun DONE.
loop: loaded (max 32 devices)
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
audit(1177621344.659:5): avc:  denied  { getattr } for  pid=2385 comm="pam_console_app" name="event2" dev=tmpfs ino=7067 scontext=system_u:system_r:pam_console_t:s0 tcontext=system_u:object_r:event_device_t:s0 tclass=chr_file
Adding 2097144k swap on /dev/VolGroup00/LogVol03.  Priority:-1 extents:1 across:2097144k
Adding 4194296k swap on /store/video0/swap4g.  Priority:-2 extents:1070 across:29496840k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
usbcore: registered new interface driver zd1211rw
r8169: eth1: link up
r8169: eth1: link up
audit(1177621359.878:6): audit_pid=3122 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t:s0
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
it87: Found IT8718F chip at 0x290, revision 2
it87: in3 is VCC (+5V)
7]: kernel time sync status 0040
saa7146: unregister extension 'budget_ci dvb'.
ACPI: PCI interrupt for device 0000:04:00.0 disabled
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem ffffc20000042000 (revision 1, irq 20) (0x13c2,0x1011).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-T	 PCI).
adapter has MAC addr = 00:d0:5c:22:22:b4
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input7
DVB: registering frontend 0 (Philips TDA10045H DVB-T)...
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload (dvb-fe-tda10045.fw)...
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
tda1004x: firmware upload complete
tda1004x: found firmware revision 2c -- ok
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized i915 1.6.0 20060119 on minor 0
NET: Registered protocol family 4
NET: Registered protocol family 5
saa7146: unregister extension 'budget_ci dvb'.
ACPI: PCI interrupt for device 0000:04:00.0 disabled
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem ffffc20000042000 (revision 1, irq 20) (0x13c2,0x1011).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-T	 PCI).
adapter has MAC addr = 00:d0:5c:22:22:b4
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input8
DVB: registering frontend 0 (Philips TDA10045H DVB-T)...
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload (dvb-fe-tda10045.fw)...
tda1004x: firmware upload complete
tda1004x: found firmware revision 2c -- ok
saa7146: unregister extension 'budget_ci dvb'.
ACPI: PCI interrupt for device 0000:04:00.0 disabled
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem ffffc20000042000 (revision 1, irq 20) (0x13c2,0x1011).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-T	 PCI).
adapter has MAC addr = 00:d0:5c:22:22:b4
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
DVB: registering frontend 0 (Philips TDA10045H DVB-T)...
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload (dvb-fe-tda10045.fw)...
tda1004x: firmware upload complete
tda1004x: found firmware revision 2c -- ok

--=-fs6zZfmiFYZU9RoB7lLE--

