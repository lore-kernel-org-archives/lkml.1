Return-Path: <linux-kernel-owner+w=401wt.eu-S1755559AbZAUR0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbZAUR0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbZAUR0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:26:39 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36170 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753135AbZAUR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:26:30 -0500
Subject: Re: ACPI hotplug panic with current git head
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, shaohua.li@intel.com
In-Reply-To: <4973EF64.2050404@jp.fujitsu.com>
References: <1231604250.3642.33.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
	 <1231807693.27151.21.camel@localhost.localdomain>
	 <1232046108.5966.57.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0901151421110.4737@localhost.localdomain>
	 <1232049269.5966.64.camel@localhost.localdomain>
	 <1232050347.5966.66.camel@localhost.localdomain>
	 <4970242C.4010404@jp.fujitsu.com>
	 <1232115546.3224.5.camel@localhost.localdomain>
	 <4973D2EE.3060203@jp.fujitsu.com>
	 <1232328216.3247.68.camel@localhost.localdomain>
	 <4973EF64.2050404@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 12:26:20 -0500
Message-Id: <1232558780.736.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-19 at 12:11 +0900, Kenji Kaneshige wrote:
> I'm sending the debug patch against 2.6.29-rc1 below. I'm also
> sending it as an attachment. It also contains the code to prevent
> the kernel panic from you. Please note that you will see two
> WARN_ON(1) messages with the patch. Those are shown by my debug
> patch.
> 
> Could you try it and send me the whole dmsg output?

Actually, the machine is now running -rc2, so the patch doesn't quite
apply: 

jejb@sparkweed> patch -p1 < ~/tmp.diff
patching file include/linux/pci-acpi.h
patching file drivers/pci/hotplug/acpiphp_glue.c
Hunk #1 FAILED at 266.
Hunk #2 succeeded at 467 (offset 2 lines).
Hunk #3 succeeded at 489 (offset 2 lines).
Hunk #4 succeeded at 518 (offset 2 lines).
Hunk #5 succeeded at 556 (offset 2 lines).

Looks like the rejection is in the NULL check piece, so I've already
actually sent you the information it would produce.

The dmesg output is pretty big, below.

James

---

 D1 D2
pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:03.2: PME# disabled
pci 0000:00:0f.1: reg 10 io port: [0x1f0-0x1f7]
pci 0000:00:0f.1: reg 14 io port: [0x3f4-0x3f7]
pci 0000:00:0f.1: reg 18 io port: [0x170-0x177]
pci 0000:00:0f.1: reg 1c io port: [0x374-0x377]
pci 0000:00:0f.1: reg 20 io port: [0x700-0x70f]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP00._PRT]
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
PM: Adding info for pci:0000:00:00.0
device: '0000:00:01.0': device_add
bus: 'pci': add device 0000:00:01.0
PM: Adding info for pci:0000:00:01.0
device: '0000:00:03.0': device_add
bus: 'pci': add device 0000:00:03.0
PM: Adding info for pci:0000:00:03.0
device: '0000:00:03.1': device_add
bus: 'pci': add device 0000:00:03.1
PM: Adding info for pci:0000:00:03.1
device: '0000:00:03.2': device_add
bus: 'pci': add device 0000:00:03.2
PM: Adding info for pci:0000:00:03.2
device: '0000:00:0f.0': device_add
bus: 'pci': add device 0000:00:0f.0
PM: Adding info for pci:0000:00:0f.0
device: '0000:00:0f.1': device_add
bus: 'pci': add device 0000:00:0f.1
PM: Adding info for pci:0000:00:0f.1
device: '0000:00:0f.3': device_add
bus: 'pci': add device 0000:00:0f.3
PM: Adding info for pci:0000:00:0f.3
driver: 'PNP0A03:00': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:00 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:01 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:01
ACPI: PCI Root Bridge [VP01] (0000:01)
device: 'pci0000:01': device_add
PM: Adding info for No Bus:pci0000:01
device: '0000:01': device_add
PM: Adding info for No Bus:0000:01
pci 0000:01:01.0: reg 10 64bit mmio: [0xf35c0000-0xf35cffff]
pci 0000:01:01.0: PME# supported from D3hot D3cold
pci 0000:01:01.0: PME# disabled
pci 0000:01:01.1: reg 10 64bit mmio: [0xf35d0000-0xf35dffff]
pci 0000:01:01.1: PME# supported from D3hot D3cold
pci 0000:01:01.1: PME# disabled
pci 0000:01:02.0: reg 10 64bit mmio: [0xf3580000-0xf35bffff]
pci 0000:01:02.0: reg 18 64bit mmio: [0xf1800000-0xf181ffff]
pci 0000:01:02.0: reg 20 io port: [0x2000-0x20ff]
pci 0000:01:02.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci_bus 0000:01: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP01._PRT]
device: '0000:01:00.0': device_add
bus: 'pci': add device 0000:01:00.0
PM: Adding info for pci:0000:01:00.0
device: '0000:01:01.0': device_add
bus: 'pci': add device 0000:01:01.0
PM: Adding info for pci:0000:01:01.0
device: '0000:01:01.1': device_add
bus: 'pci': add device 0000:01:01.1
PM: Adding info for pci:0000:01:01.1
device: '0000:01:02.0': device_add
bus: 'pci': add device 0000:01:02.0
PM: Adding info for pci:0000:01:02.0
driver: 'PNP0A03:01': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:01 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:02 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:02
ACPI: PCI Root Bridge [VP02] (0000:02)
device: 'pci0000:02': device_add
PM: Adding info for No Bus:pci0000:02
device: '0000:02': device_add
PM: Adding info for No Bus:0000:02
pci_bus 0000:02: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP02._PRT]
device: '0000:02:00.0': device_add
bus: 'pci': add device 0000:02:00.0
PM: Adding info for pci:0000:02:00.0
driver: 'PNP0A03:02': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:02 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:03 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:03
ACPI: PCI Root Bridge [VP03] (0000:04)
device: 'pci0000:04': device_add
PM: Adding info for No Bus:pci0000:04
device: '0000:04': device_add
PM: Adding info for No Bus:0000:04
pci_bus 0000:04: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP03._PRT]
device: '0000:04:00.0': device_add
bus: 'pci': add device 0000:04:00.0
PM: Adding info for pci:0000:04:00.0
driver: 'PNP0A03:03': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:03 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:04 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:04
ACPI: PCI Root Bridge [VP04] (0000:06)
device: 'pci0000:06': device_add
PM: Adding info for No Bus:pci0000:06
device: '0000:06': device_add
PM: Adding info for No Bus:0000:06
pci_bus 0000:06: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP04._PRT]
device: '0000:06:00.0': device_add
bus: 'pci': add device 0000:06:00.0
PM: Adding info for pci:0000:06:00.0
driver: 'PNP0A03:04': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:04 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:05 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:05
ACPI: PCI Root Bridge [VP05] (0000:08)
device: 'pci0000:08': device_add
PM: Adding info for No Bus:pci0000:08
device: '0000:08': device_add
PM: Adding info for No Bus:0000:08
pci_bus 0000:08: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP05._PRT]
device: '0000:08:00.0': device_add
bus: 'pci': add device 0000:08:00.0
PM: Adding info for pci:0000:08:00.0
driver: 'PNP0A03:05': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:05 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:06 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:06
ACPI: PCI Root Bridge [VP06] (0000:0a)
device: 'pci0000:0a': device_add
PM: Adding info for No Bus:pci0000:0a
device: '0000:0a': device_add
PM: Adding info for No Bus:0000:0a
pci_bus 0000:0a: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP06._PRT]
device: '0000:0a:00.0': device_add
bus: 'pci': add device 0000:0a:00.0
PM: Adding info for pci:0000:0a:00.0
driver: 'PNP0A03:06': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:06 to driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A03:07 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A03:07
ACPI: PCI Root Bridge [VP07] (0000:0c)
device: 'pci0000:0c': device_add
PM: Adding info for No Bus:pci0000:0c
device: '0000:0c': device_add
PM: Adding info for No Bus:0000:0c
pci_bus 0000:0c: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.VP07._PRT]
device: '0000:0c:00.0': device_add
bus: 'pci': add device 0000:0c:00.0
PM: Adding info for pci:0000:0c:00.0
driver: 'PNP0A03:07': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A03:07 to driver pci_root
bus: 'acpi': add driver pci_link
bus: 'acpi': add driver power
bus: 'pnp': registered
device class 'misc': registering
bus: 'serio': registered
device class 'input': registering
device class 'power_supply': registering
device class 'hwmon': registering
device class 'thermal': registering
PCI: Using ACPI for IRQ routing
device class 'net': registering
device: 'lo': device_add
PM: Adding info for No Bus:lo
device class 'rfkill': registering
PCI-DMA: Using Calgary IOMMU
Calgary: enabling translation on Calgary PHB 0x0
Calgary: errant DMAs will now be prevented on this bus.
Calgary: enabling translation on Calgary PHB 0x1
Calgary: errant DMAs will now be prevented on this bus.
pnp: PnP ACPI init
device: 'pnp0': device_add
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
device: '00:00': device_add
bus: 'pnp': add device 00:00
PM: Adding info for pnp:00:00
device: '00:01': device_add
bus: 'pnp': add device 00:01
PM: Adding info for pnp:00:01
device: '00:02': device_add
bus: 'pnp': add device 00:02
PM: Adding info for pnp:00:02
device: '00:03': device_add
bus: 'pnp': add device 00:03
PM: Adding info for pnp:00:03
device: '00:04': device_add
bus: 'pnp': add device 00:04
PM: Adding info for pnp:00:04
device: '00:05': device_add
bus: 'pnp': add device 00:05
PM: Adding info for pnp:00:05
device: '00:06': device_add
bus: 'pnp': add device 00:06
PM: Adding info for pnp:00:06
device: '00:07': device_add
bus: 'pnp': add device 00:07
PM: Adding info for pnp:00:07
pnp 00:08: IRQ 8 override to edge, low
device: '00:08': device_add
bus: 'pnp': add device 00:08
PM: Adding info for pnp:00:08
device: '00:09': device_add
bus: 'pnp': add device 00:09
PM: Adding info for pnp:00:09
device: '00:0a': device_add
bus: 'pnp': add device 00:0a
PM: Adding info for pnp:00:0a
device: '00:0b': device_add
bus: 'pnp': add device 00:0b
PM: Adding info for pnp:00:0b
pnp 00:0c: mem resource (0x400-0x4ff) overlaps 0000:00:01.0 BAR 6 (0x0-0x1ffff), disabling
pnp 00:0c: mem resource (0x400-0x4ff) overlaps 0000:01:02.0 BAR 6 (0x0-0x7ffff), disabling
device: '00:0c': device_add
bus: 'pnp': add device 00:0c
PM: Adding info for pnp:00:0c
device: '00:0d': device_add
bus: 'pnp': add device 00:0d
PM: Adding info for pnp:00:0d
device: '00:0e': device_add
bus: 'pnp': add device 00:0e
PM: Adding info for pnp:00:0e
device: '00:0f': device_add
bus: 'pnp': add device 00:0f
PM: Adding info for pnp:00:0f
device: '00:10': device_add
bus: 'pnp': add device 00:10
PM: Adding info for pnp:00:10
device: '00:11': device_add
bus: 'pnp': add device 00:11
PM: Adding info for pnp:00:11
device: '00:12': device_add
bus: 'pnp': add device 00:12
PM: Adding info for pnp:00:12
device: '00:13': device_add
bus: 'pnp': add device 00:13
PM: Adding info for pnp:00:13
device: '00:14': device_add
bus: 'pnp': add device 00:14
PM: Adding info for pnp:00:14
pnp: PnP ACPI: found 21 devices
ACPI: ACPI bus type pnp unregistered
bus: 'pnp': add driver system
bus: 'pnp': driver_probe_device: matched device 00:0b with driver system
bus: 'pnp': really_probe: probing driver system with device 00:0b
system 00:0b: ioport range 0x400-0x47f has been reserved
system 00:0b: ioport range 0x480-0x4ff has been reserved
system 00:0b: ioport range 0x500-0x55f has been reserved
system 00:0b: ioport range 0x600-0x600 has been reserved
system 00:0b: ioport range 0x800-0x803 has been reserved
system 00:0b: ioport range 0xc00-0xcdf has been reserved
system 00:0b: ioport range 0xf50-0xf5f has been reserved
driver: '00:0b': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:0b to driver system
bus: 'pnp': driver_probe_device: matched device 00:0c with driver system
bus: 'pnp': really_probe: probing driver system with device 00:0c
driver: '00:0c': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:0c to driver system
bus: 'pnp': driver_probe_device: matched device 00:0d with driver system
bus: 'pnp': really_probe: probing driver system with device 00:0d
driver: '00:0d': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:0d to driver system
device class 'mem': registering
device: 'mem': device_add
PM: Adding info for No Bus:mem
device: 'kmem': device_add
PM: Adding info for No Bus:kmem
device: 'null': device_add
PM: Adding info for No Bus:null
device: 'port': device_add
PM: Adding info for No Bus:port
device: 'zero': device_add
PM: Adding info for No Bus:zero
device: 'full': device_add
PM: Adding info for No Bus:full
device: 'random': device_add
PM: Adding info for No Bus:random
device: 'urandom': device_add
PM: Adding info for No Bus:urandom
device: 'kmsg': device_add
PM: Adding info for No Bus:kmsg
device class 'firmware': registering
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x00-0xffff]
pci_bus 0000:01: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:02: resource 0 io:  [0x00-0xffff]
pci_bus 0000:02: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:04: resource 0 io:  [0x00-0xffff]
pci_bus 0000:04: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:06: resource 0 io:  [0x00-0xffff]
pci_bus 0000:06: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:08: resource 0 io:  [0x00-0xffff]
pci_bus 0000:08: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:0a: resource 0 io:  [0x00-0xffff]
pci_bus 0000:0a: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:0c: resource 0 io:  [0x00-0xffff]
pci_bus 0000:0c: resource 1 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 46947k freed
Calgary: fixing up tce spaces
Registering sysdev class 'i8259'
Registering sys device of class 'i8259'
Registering sys device 'i82590'
Registering sysdev class 'i8237'
Registering sys device of class 'i8237'
Registering sys device 'i82370'
Registering sysdev class 'lapic'
Registering sys device of class 'lapic'
Registering sys device 'lapic0'
Registering sysdev class 'ioapic'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic0'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic1'
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
PM: Adding info for platform:pcspkr
Registering sysdev class 'timekeeping'
Registering sys device of class 'timekeeping'
Registering sys device 'timekeeping0'
Registering sysdev class 'clocksource'
Registering sys device of class 'clocksource'
Registering sys device 'clocksource0'
Registering sysdev class 'rttest'
Registering sys device of class 'rttest'
Registering sys device 'rttest0'
Registering sys device of class 'rttest'
Registering sys device 'rttest1'
Registering sys device of class 'rttest'
Registering sys device 'rttest2'
Registering sys device of class 'rttest'
Registering sys device 'rttest3'
Registering sys device of class 'rttest'
Registering sys device 'rttest4'
Registering sys device of class 'rttest'
Registering sys device 'rttest5'
Registering sys device of class 'rttest'
Registering sys device 'rttest6'
Registering sys device of class 'rttest'
Registering sys device 'rttest7'
Initializing RT-Tester: OK
device: 'snapshot': device_add
PM: Adding info for No Bus:snapshot
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 3960
alg: No test for stdrng (krng)
device class 'bsg': registering
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:01.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
add_bridge: Detecting slots under root bridge (\_SB_.VP00)
acpi_pci_get_bridge_handle: bridge(pbus->self) = ffff88007f0f3478, pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as PtoP.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:00: (null) <NULL>
acpi_pci_get_bridge_handle: bridge(pbus->self) = ffff88007f0f3478, pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as PtoP.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:00: (null) <NULL>
add_bridge: Detecting slots under root bridge (\_SB_.VP01)
acpi_pci_get_bridge_handle: bridge(pbus->self) = ffff88007f0ba4c8, pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as PtoP.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:01: (null) <NULL>
acpi_pci_get_bridge_handle: bridge(pbus->self) = ffff88007f0ba4c8, pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as PtoP.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:01: (null) <NULL>
add_bridge: Detecting slots under root bridge (\_SB_.VP02)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpiphp: Slot [1] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:02: ffff88007f84ffb8 \_SB_.VP02
add_bridge: Detecting slots under root bridge (\_SB_.VP03)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpiphp: Slot [2] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:04: ffff88007f850a08 \_SB_.VP03
add_bridge: Detecting slots under root bridge (\_SB_.VP04)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpiphp: Slot [3] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:06: ffff88007f851180 \_SB_.VP04
add_bridge: Detecting slots under root bridge (\_SB_.VP05)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpiphp: Slot [4] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:08: ffff88007f851ce0 \_SB_.VP05
add_bridge: Detecting slots under root bridge (\_SB_.VP06)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpiphp: Slot [5] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0a: ffff88007f853b58 \_SB_.VP06
add_bridge: Detecting slots under root bridge (\_SB_.VP07)
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpiphp: Slot [6] registered
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
acpi_pci_get_bridge_handle: bridge(pbus->self) = (null), pbus->parent = (null)
acpi_pci_get_bridge_handle: handle the bridge as root.
acpi_pci_get_bridge_handle: ACPI handle of the bridge for 0000:0c: ffff88007f8542d0 \_SB_.VP07
bus: 'platform': add driver generic-bl
bus: 'acpi': add driver button
bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00 with driver button
bus: 'acpi': really_probe: probing driver button with device LNXPWRBN:00
device: 'input0': device_add
PM: Adding info for No Bus:input0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
bus: 'acpi': really_probe: bound device LNXPWRBN:00 to driver button
bus: 'acpi': add driver fan
Registering sysdev class 'irqrouter'
Registering sys device of class 'irqrouter'
Registering sys device 'irqrouter0'
bus: 'acpi': add driver processor
bus: 'acpi': driver_probe_device: matched device ACPI_CPU:00 with driver processor
bus: 'acpi': really_probe: probing driver processor with device ACPI_CPU:00
device: 'cooling_device0': device_add
PM: Adding info for No Bus:cooling_device0
processor ACPI_CPU:00: registered as cooling_device0
driver: 'ACPI_CPU:00': driver_bound: bound to device 'processor'
bus: 'acpi': really_probe: bound device ACPI_CPU:00 to driver processor
bus: 'acpi': driver_probe_device: matched device ACPI_CPU:01 with driver processor
bus: 'acpi': really_probe: probing driver processor with device ACPI_CPU:01
device: 'cooling_device1': device_add
PM: Adding info for No Bus:cooling_device1
processor ACPI_CPU:01: registered as cooling_device1
driver: 'ACPI_CPU:01': driver_bound: bound to device 'processor'
bus: 'acpi': really_probe: bound device ACPI_CPU:01 to driver processor
bus: 'acpi': add driver container
bus: 'acpi': add driver thermal
bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with driver thermal
bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
device: 'tty': device_add
PM: Adding info for No Bus:tty
device: 'console': device_add
PM: Adding info for No Bus:console
device: 'tty0': device_add
PM: Adding info for No Bus:tty0
device class 'vc': registering
device: 'vcs': device_add
PM: Adding info for No Bus:vcs
device: 'vcsa': device_add
PM: Adding info for No Bus:vcsa
device: 'tty1': device_add
PM: Adding info for No Bus:tty1
device: 'tty2': device_add
PM: Adding info for No Bus:tty2
device: 'tty3': device_add
PM: Adding info for No Bus:tty3
device: 'tty4': device_add
PM: Adding info for No Bus:tty4
device: 'tty5': device_add
PM: Adding info for No Bus:tty5
device: 'tty6': device_add
PM: Adding info for No Bus:tty6
device: 'tty7': device_add
PM: Adding info for No Bus:tty7
device: 'tty8': device_add
PM: Adding info for No Bus:tty8
device: 'tty9': device_add
PM: Adding info for No Bus:tty9
device: 'tty10': device_add
PM: Adding info for No Bus:tty10
device: 'tty11': device_add
PM: Adding info for No Bus:tty11
device: 'tty12': device_add
PM: Adding info for No Bus:tty12
device: 'tty13': device_add
PM: Adding info for No Bus:tty13
device: 'tty14': device_add
PM: Adding info for No Bus:tty14
device: 'tty15': device_add
PM: Adding info for No Bus:tty15
device: 'tty16': device_add
PM: Adding info for No Bus:tty16
device: 'tty17': device_add
PM: Adding info for No Bus:tty17
device: 'tty18': device_add
PM: Adding info for No Bus:tty18
device: 'tty19': device_add
PM: Adding info for No Bus:tty19
device: 'tty20': device_add
PM: Adding info for No Bus:tty20
device: 'tty21': device_add
PM: Adding info for No Bus:tty21
device: 'tty22': device_add
PM: Adding info for No Bus:tty22
device: 'tty23': device_add
PM: Adding info for No Bus:tty23
device: 'tty24': device_add
PM: Adding info for No Bus:tty24
device: 'tty25': device_add
PM: Adding info for No Bus:tty25
device: 'tty26': device_add
PM: Adding info for No Bus:tty26
device: 'tty27': device_add
PM: Adding info for No Bus:tty27
device: 'tty28': device_add
PM: Adding info for No Bus:tty28
device: 'tty29': device_add
PM: Adding info for No Bus:tty29
device: 'tty30': device_add
PM: Adding info for No Bus:tty30
device: 'tty31': device_add
PM: Adding info for No Bus:tty31
device: 'tty32': device_add
PM: Adding info for No Bus:tty32
device: 'tty33': device_add
PM: Adding info for No Bus:tty33
device: 'tty34': device_add
PM: Adding info for No Bus:tty34
device: 'tty35': device_add
PM: Adding info for No Bus:tty35
device: 'tty36': device_add
PM: Adding info for No Bus:tty36
device: 'tty37': device_add
PM: Adding info for No Bus:tty37
device: 'tty38': device_add
PM: Adding info for No Bus:tty38
device: 'tty39': device_add
PM: Adding info for No Bus:tty39
device: 'tty40': device_add
PM: Adding info for No Bus:tty40
device: 'tty41': device_add
PM: Adding info for No Bus:tty41
device: 'tty42': device_add
PM: Adding info for No Bus:tty42
device: 'tty43': device_add
PM: Adding info for No Bus:tty43
device: 'tty44': device_add
PM: Adding info for No Bus:tty44
device: 'tty45': device_add
PM: Adding info for No Bus:tty45
device: 'tty46': device_add
PM: Adding info for No Bus:tty46
device: 'tty47': device_add
PM: Adding info for No Bus:tty47
device: 'tty48': device_add
PM: Adding info for No Bus:tty48
device: 'tty49': device_add
PM: Adding info for No Bus:tty49
device: 'tty50': device_add
PM: Adding info for No Bus:tty50
device: 'tty51': device_add
PM: Adding info for No Bus:tty51
device: 'tty52': device_add
PM: Adding info for No Bus:tty52
device: 'tty53': device_add
PM: Adding info for No Bus:tty53
device: 'tty54': device_add
PM: Adding info for No Bus:tty54
device: 'tty55': device_add
PM: Adding info for No Bus:tty55
device: 'tty56': device_add
PM: Adding info for No Bus:tty56
device: 'tty57': device_add
PM: Adding info for No Bus:tty57
device: 'tty58': device_add
PM: Adding info for No Bus:tty58
device: 'tty59': device_add
PM: Adding info for No Bus:tty59
device: 'tty60': device_add
PM: Adding info for No Bus:tty60
device: 'tty61': device_add
PM: Adding info for No Bus:tty61
device: 'tty62': device_add
PM: Adding info for No Bus:tty62
device: 'tty63': device_add
PM: Adding info for No Bus:tty63
device: 'ptyp0': device_add
PM: Adding info for No Bus:ptyp0
device: 'ptyp1': device_add
PM: Adding info for No Bus:ptyp1
device: 'ptyp2': device_add
PM: Adding info for No Bus:ptyp2
device: 'ptyp3': device_add
PM: Adding info for No Bus:ptyp3
device: 'ptyp4': device_add
PM: Adding info for No Bus:ptyp4
device: 'ptyp5': device_add
PM: Adding info for No Bus:ptyp5
device: 'ptyp6': device_add
PM: Adding info for No Bus:ptyp6
device: 'ptyp7': device_add
PM: Adding info for No Bus:ptyp7
device: 'ptyp8': device_add
PM: Adding info for No Bus:ptyp8
device: 'ptyp9': device_add
PM: Adding info for No Bus:ptyp9
device: 'ptypa': device_add
PM: Adding info for No Bus:ptypa
device: 'ptypb': device_add
PM: Adding info for No Bus:ptypb
device: 'ptypc': device_add
PM: Adding info for No Bus:ptypc
device: 'ptypd': device_add
PM: Adding info for No Bus:ptypd
device: 'ptype': device_add
PM: Adding info for No Bus:ptype
device: 'ptypf': device_add
PM: Adding info for No Bus:ptypf
device: 'ptyq0': device_add
PM: Adding info for No Bus:ptyq0
device: 'ptyq1': device_add
PM: Adding info for No Bus:ptyq1
device: 'ptyq2': device_add
PM: Adding info for No Bus:ptyq2
device: 'ptyq3': device_add
PM: Adding info for No Bus:ptyq3
device: 'ptyq4': device_add
PM: Adding info for No Bus:ptyq4
device: 'ptyq5': device_add
PM: Adding info for No Bus:ptyq5
device: 'ptyq6': device_add
PM: Adding info for No Bus:ptyq6
device: 'ptyq7': device_add
PM: Adding info for No Bus:ptyq7
device: 'ptyq8': device_add
PM: Adding info for No Bus:ptyq8
device: 'ptyq9': device_add
PM: Adding info for No Bus:ptyq9
device: 'ptyqa': device_add
PM: Adding info for No Bus:ptyqa
device: 'ptyqb': device_add
PM: Adding info for No Bus:ptyqb
device: 'ptyqc': device_add
PM: Adding info for No Bus:ptyqc
device: 'ptyqd': device_add
PM: Adding info for No Bus:ptyqd
device: 'ptyqe': device_add
PM: Adding info for No Bus:ptyqe
device: 'ptyqf': device_add
PM: Adding info for No Bus:ptyqf
device: 'ptyr0': device_add
PM: Adding info for No Bus:ptyr0
device: 'ptyr1': device_add
PM: Adding info for No Bus:ptyr1
device: 'ptyr2': device_add
PM: Adding info for No Bus:ptyr2
device: 'ptyr3': device_add
PM: Adding info for No Bus:ptyr3
device: 'ptyr4': device_add
PM: Adding info for No Bus:ptyr4
device: 'ptyr5': device_add
PM: Adding info for No Bus:ptyr5
device: 'ptyr6': device_add
PM: Adding info for No Bus:ptyr6
device: 'ptyr7': device_add
PM: Adding info for No Bus:ptyr7
device: 'ptyr8': device_add
PM: Adding info for No Bus:ptyr8
device: 'ptyr9': device_add
PM: Adding info for No Bus:ptyr9
device: 'ptyra': device_add
PM: Adding info for No Bus:ptyra
device: 'ptyrb': device_add
PM: Adding info for No Bus:ptyrb
device: 'ptyrc': device_add
PM: Adding info for No Bus:ptyrc
device: 'ptyrd': device_add
PM: Adding info for No Bus:ptyrd
device: 'ptyre': device_add
PM: Adding info for No Bus:ptyre
device: 'ptyrf': device_add
PM: Adding info for No Bus:ptyrf
device: 'ptys0': device_add
PM: Adding info for No Bus:ptys0
device: 'ptys1': device_add
PM: Adding info for No Bus:ptys1
device: 'ptys2': device_add
PM: Adding info for No Bus:ptys2
device: 'ptys3': device_add
PM: Adding info for No Bus:ptys3
device: 'ptys4': device_add
PM: Adding info for No Bus:ptys4
device: 'ptys5': device_add
PM: Adding info for No Bus:ptys5
device: 'ptys6': device_add
PM: Adding info for No Bus:ptys6
device: 'ptys7': device_add
PM: Adding info for No Bus:ptys7
device: 'ptys8': device_add
PM: Adding info for No Bus:ptys8
device: 'ptys9': device_add
PM: Adding info for No Bus:ptys9
device: 'ptysa': device_add
PM: Adding info for No Bus:ptysa
device: 'ptysb': device_add
PM: Adding info for No Bus:ptysb
device: 'ptysc': device_add
PM: Adding info for No Bus:ptysc
device: 'ptysd': device_add
PM: Adding info for No Bus:ptysd
device: 'ptyse': device_add
PM: Adding info for No Bus:ptyse
device: 'ptysf': device_add
PM: Adding info for No Bus:ptysf
device: 'ptyt0': device_add
PM: Adding info for No Bus:ptyt0
device: 'ptyt1': device_add
PM: Adding info for No Bus:ptyt1
device: 'ptyt2': device_add
PM: Adding info for No Bus:ptyt2
device: 'ptyt3': device_add
PM: Adding info for No Bus:ptyt3
device: 'ptyt4': device_add
PM: Adding info for No Bus:ptyt4
device: 'ptyt5': device_add
PM: Adding info for No Bus:ptyt5
device: 'ptyt6': device_add
PM: Adding info for No Bus:ptyt6
device: 'ptyt7': device_add
PM: Adding info for No Bus:ptyt7
device: 'ptyt8': device_add
PM: Adding info for No Bus:ptyt8
device: 'ptyt9': device_add
PM: Adding info for No Bus:ptyt9
device: 'ptyta': device_add
PM: Adding info for No Bus:ptyta
device: 'ptytb': device_add
PM: Adding info for No Bus:ptytb
device: 'ptytc': device_add
PM: Adding info for No Bus:ptytc
device: 'ptytd': device_add
PM: Adding info for No Bus:ptytd
device: 'ptyte': device_add
PM: Adding info for No Bus:ptyte
device: 'ptytf': device_add
PM: Adding info for No Bus:ptytf
device: 'ptyu0': device_add
PM: Adding info for No Bus:ptyu0
device: 'ptyu1': device_add
PM: Adding info for No Bus:ptyu1
device: 'ptyu2': device_add
PM: Adding info for No Bus:ptyu2
device: 'ptyu3': device_add
PM: Adding info for No Bus:ptyu3
device: 'ptyu4': device_add
PM: Adding info for No Bus:ptyu4
device: 'ptyu5': device_add
PM: Adding info for No Bus:ptyu5
device: 'ptyu6': device_add
PM: Adding info for No Bus:ptyu6
device: 'ptyu7': device_add
PM: Adding info for No Bus:ptyu7
device: 'ptyu8': device_add
PM: Adding info for No Bus:ptyu8
device: 'ptyu9': device_add
PM: Adding info for No Bus:ptyu9
device: 'ptyua': device_add
PM: Adding info for No Bus:ptyua
device: 'ptyub': device_add
PM: Adding info for No Bus:ptyub
device: 'ptyuc': device_add
PM: Adding info for No Bus:ptyuc
device: 'ptyud': device_add
PM: Adding info for No Bus:ptyud
device: 'ptyue': device_add
PM: Adding info for No Bus:ptyue
device: 'ptyuf': device_add
PM: Adding info for No Bus:ptyuf
device: 'ptyv0': device_add
PM: Adding info for No Bus:ptyv0
device: 'ptyv1': device_add
PM: Adding info for No Bus:ptyv1
device: 'ptyv2': device_add
PM: Adding info for No Bus:ptyv2
device: 'ptyv3': device_add
PM: Adding info for No Bus:ptyv3
device: 'ptyv4': device_add
PM: Adding info for No Bus:ptyv4
device: 'ptyv5': device_add
PM: Adding info for No Bus:ptyv5
device: 'ptyv6': device_add
PM: Adding info for No Bus:ptyv6
device: 'ptyv7': device_add
PM: Adding info for No Bus:ptyv7
device: 'ptyv8': device_add
PM: Adding info for No Bus:ptyv8
device: 'ptyv9': device_add
PM: Adding info for No Bus:ptyv9
device: 'ptyva': device_add
PM: Adding info for No Bus:ptyva
device: 'ptyvb': device_add
PM: Adding info for No Bus:ptyvb
device: 'ptyvc': device_add
PM: Adding info for No Bus:ptyvc
device: 'ptyvd': device_add
PM: Adding info for No Bus:ptyvd
device: 'ptyve': device_add
PM: Adding info for No Bus:ptyve
device: 'ptyvf': device_add
PM: Adding info for No Bus:ptyvf
device: 'ptyw0': device_add
PM: Adding info for No Bus:ptyw0
device: 'ptyw1': device_add
PM: Adding info for No Bus:ptyw1
device: 'ptyw2': device_add
PM: Adding info for No Bus:ptyw2
device: 'ptyw3': device_add
PM: Adding info for No Bus:ptyw3
device: 'ptyw4': device_add
PM: Adding info for No Bus:ptyw4
device: 'ptyw5': device_add
PM: Adding info for No Bus:ptyw5
device: 'ptyw6': device_add
PM: Adding info for No Bus:ptyw6
device: 'ptyw7': device_add
PM: Adding info for No Bus:ptyw7
device: 'ptyw8': device_add
PM: Adding info for No Bus:ptyw8
device: 'ptyw9': device_add
PM: Adding info for No Bus:ptyw9
device: 'ptywa': device_add
PM: Adding info for No Bus:ptywa
device: 'ptywb': device_add
PM: Adding info for No Bus:ptywb
device: 'ptywc': device_add
PM: Adding info for No Bus:ptywc
device: 'ptywd': device_add
PM: Adding info for No Bus:ptywd
device: 'ptywe': device_add
PM: Adding info for No Bus:ptywe
device: 'ptywf': device_add
PM: Adding info for No Bus:ptywf
device: 'ptyx0': device_add
PM: Adding info for No Bus:ptyx0
device: 'ptyx1': device_add
PM: Adding info for No Bus:ptyx1
device: 'ptyx2': device_add
PM: Adding info for No Bus:ptyx2
device: 'ptyx3': device_add
PM: Adding info for No Bus:ptyx3
device: 'ptyx4': device_add
PM: Adding info for No Bus:ptyx4
device: 'ptyx5': device_add
PM: Adding info for No Bus:ptyx5
device: 'ptyx6': device_add
PM: Adding info for No Bus:ptyx6
device: 'ptyx7': device_add
PM: Adding info for No Bus:ptyx7
device: 'ptyx8': device_add
PM: Adding info for No Bus:ptyx8
device: 'ptyx9': device_add
PM: Adding info for No Bus:ptyx9
device: 'ptyxa': device_add
PM: Adding info for No Bus:ptyxa
device: 'ptyxb': device_add
PM: Adding info for No Bus:ptyxb
device: 'ptyxc': device_add
PM: Adding info for No Bus:ptyxc
device: 'ptyxd': device_add
PM: Adding info for No Bus:ptyxd
device: 'ptyxe': device_add
PM: Adding info for No Bus:ptyxe
device: 'ptyxf': device_add
PM: Adding info for No Bus:ptyxf
device: 'ptyy0': device_add
PM: Adding info for No Bus:ptyy0
device: 'ptyy1': device_add
PM: Adding info for No Bus:ptyy1
device: 'ptyy2': device_add
PM: Adding info for No Bus:ptyy2
device: 'ptyy3': device_add
PM: Adding info for No Bus:ptyy3
device: 'ptyy4': device_add
PM: Adding info for No Bus:ptyy4
device: 'ptyy5': device_add
PM: Adding info for No Bus:ptyy5
device: 'ptyy6': device_add
PM: Adding info for No Bus:ptyy6
device: 'ptyy7': device_add
PM: Adding info for No Bus:ptyy7
device: 'ptyy8': device_add
PM: Adding info for No Bus:ptyy8
device: 'ptyy9': device_add
PM: Adding info for No Bus:ptyy9
device: 'ptyya': device_add
PM: Adding info for No Bus:ptyya
device: 'ptyyb': device_add
PM: Adding info for No Bus:ptyyb
device: 'ptyyc': device_add
PM: Adding info for No Bus:ptyyc
device: 'ptyyd': device_add
PM: Adding info for No Bus:ptyyd
device: 'ptyye': device_add
PM: Adding info for No Bus:ptyye
device: 'ptyyf': device_add
PM: Adding info for No Bus:ptyyf
device: 'ptyz0': device_add
PM: Adding info for No Bus:ptyz0
device: 'ptyz1': device_add
PM: Adding info for No Bus:ptyz1
device: 'ptyz2': device_add
PM: Adding info for No Bus:ptyz2
device: 'ptyz3': device_add
PM: Adding info for No Bus:ptyz3
device: 'ptyz4': device_add
PM: Adding info for No Bus:ptyz4
device: 'ptyz5': device_add
PM: Adding info for No Bus:ptyz5
device: 'ptyz6': device_add
PM: Adding info for No Bus:ptyz6
device: 'ptyz7': device_add
PM: Adding info for No Bus:ptyz7
device: 'ptyz8': device_add
PM: Adding info for No Bus:ptyz8
device: 'ptyz9': device_add
PM: Adding info for No Bus:ptyz9
device: 'ptyza': device_add
PM: Adding info for No Bus:ptyza
device: 'ptyzb': device_add
PM: Adding info for No Bus:ptyzb
device: 'ptyzc': device_add
PM: Adding info for No Bus:ptyzc
device: 'ptyzd': device_add
PM: Adding info for No Bus:ptyzd
device: 'ptyze': device_add
PM: Adding info for No Bus:ptyze
device: 'ptyzf': device_add
PM: Adding info for No Bus:ptyzf
device: 'ptya0': device_add
PM: Adding info for No Bus:ptya0
device: 'ptya1': device_add
PM: Adding info for No Bus:ptya1
device: 'ptya2': device_add
PM: Adding info for No Bus:ptya2
device: 'ptya3': device_add
PM: Adding info for No Bus:ptya3
device: 'ptya4': device_add
PM: Adding info for No Bus:ptya4
device: 'ptya5': device_add
PM: Adding info for No Bus:ptya5
device: 'ptya6': device_add
PM: Adding info for No Bus:ptya6
device: 'ptya7': device_add
PM: Adding info for No Bus:ptya7
device: 'ptya8': device_add
PM: Adding info for No Bus:ptya8
device: 'ptya9': device_add
PM: Adding info for No Bus:ptya9
device: 'ptyaa': device_add
PM: Adding info for No Bus:ptyaa
device: 'ptyab': device_add
PM: Adding info for No Bus:ptyab
device: 'ptyac': device_add
PM: Adding info for No Bus:ptyac
device: 'ptyad': device_add
PM: Adding info for No Bus:ptyad
device: 'ptyae': device_add
PM: Adding info for No Bus:ptyae
device: 'ptyaf': device_add
PM: Adding info for No Bus:ptyaf
device: 'ptyb0': device_add
PM: Adding info for No Bus:ptyb0
device: 'ptyb1': device_add
PM: Adding info for No Bus:ptyb1
device: 'ptyb2': device_add
PM: Adding info for No Bus:ptyb2
device: 'ptyb3': device_add
PM: Adding info for No Bus:ptyb3
device: 'ptyb4': device_add
PM: Adding info for No Bus:ptyb4
device: 'ptyb5': device_add
PM: Adding info for No Bus:ptyb5
device: 'ptyb6': device_add
PM: Adding info for No Bus:ptyb6
device: 'ptyb7': device_add
PM: Adding info for No Bus:ptyb7
device: 'ptyb8': device_add
PM: Adding info for No Bus:ptyb8
device: 'ptyb9': device_add
PM: Adding info for No Bus:ptyb9
device: 'ptyba': device_add
PM: Adding info for No Bus:ptyba
device: 'ptybb': device_add
PM: Adding info for No Bus:ptybb
device: 'ptybc': device_add
PM: Adding info for No Bus:ptybc
device: 'ptybd': device_add
PM: Adding info for No Bus:ptybd
device: 'ptybe': device_add
PM: Adding info for No Bus:ptybe
device: 'ptybf': device_add
PM: Adding info for No Bus:ptybf
device: 'ptyc0': device_add
PM: Adding info for No Bus:ptyc0
device: 'ptyc1': device_add
PM: Adding info for No Bus:ptyc1
device: 'ptyc2': device_add
PM: Adding info for No Bus:ptyc2
device: 'ptyc3': device_add
PM: Adding info for No Bus:ptyc3
device: 'ptyc4': device_add
PM: Adding info for No Bus:ptyc4
device: 'ptyc5': device_add
PM: Adding info for No Bus:ptyc5
device: 'ptyc6': device_add
PM: Adding info for No Bus:ptyc6
device: 'ptyc7': device_add
PM: Adding info for No Bus:ptyc7
device: 'ptyc8': device_add
PM: Adding info for No Bus:ptyc8
device: 'ptyc9': device_add
PM: Adding info for No Bus:ptyc9
device: 'ptyca': device_add
PM: Adding info for No Bus:ptyca
device: 'ptycb': device_add
PM: Adding info for No Bus:ptycb
device: 'ptycc': device_add
PM: Adding info for No Bus:ptycc
device: 'ptycd': device_add
PM: Adding info for No Bus:ptycd
device: 'ptyce': device_add
PM: Adding info for No Bus:ptyce
device: 'ptycf': device_add
PM: Adding info for No Bus:ptycf
device: 'ptyd0': device_add
PM: Adding info for No Bus:ptyd0
device: 'ptyd1': device_add
PM: Adding info for No Bus:ptyd1
device: 'ptyd2': device_add
PM: Adding info for No Bus:ptyd2
device: 'ptyd3': device_add
PM: Adding info for No Bus:ptyd3
device: 'ptyd4': device_add
PM: Adding info for No Bus:ptyd4
device: 'ptyd5': device_add
PM: Adding info for No Bus:ptyd5
device: 'ptyd6': device_add
PM: Adding info for No Bus:ptyd6
device: 'ptyd7': device_add
PM: Adding info for No Bus:ptyd7
device: 'ptyd8': device_add
PM: Adding info for No Bus:ptyd8
device: 'ptyd9': device_add
PM: Adding info for No Bus:ptyd9
device: 'ptyda': device_add
PM: Adding info for No Bus:ptyda
device: 'ptydb': device_add
PM: Adding info for No Bus:ptydb
device: 'ptydc': device_add
PM: Adding info for No Bus:ptydc
device: 'ptydd': device_add
PM: Adding info for No Bus:ptydd
device: 'ptyde': device_add
PM: Adding info for No Bus:ptyde
device: 'ptydf': device_add
PM: Adding info for No Bus:ptydf
device: 'ptye0': device_add
PM: Adding info for No Bus:ptye0
device: 'ptye1': device_add
PM: Adding info for No Bus:ptye1
device: 'ptye2': device_add
PM: Adding info for No Bus:ptye2
device: 'ptye3': device_add
PM: Adding info for No Bus:ptye3
device: 'ptye4': device_add
PM: Adding info for No Bus:ptye4
device: 'ptye5': device_add
PM: Adding info for No Bus:ptye5
device: 'ptye6': device_add
PM: Adding info for No Bus:ptye6
device: 'ptye7': device_add
PM: Adding info for No Bus:ptye7
device: 'ptye8': device_add
PM: Adding info for No Bus:ptye8
device: 'ptye9': device_add
PM: Adding info for No Bus:ptye9
device: 'ptyea': device_add
PM: Adding info for No Bus:ptyea
device: 'ptyeb': device_add
PM: Adding info for No Bus:ptyeb
device: 'ptyec': device_add
PM: Adding info for No Bus:ptyec
device: 'ptyed': device_add
PM: Adding info for No Bus:ptyed
device: 'ptyee': device_add
PM: Adding info for No Bus:ptyee
device: 'ptyef': device_add
PM: Adding info for No Bus:ptyef
device: 'ttyp0': device_add
PM: Adding info for No Bus:ttyp0
device: 'ttyp1': device_add
PM: Adding info for No Bus:ttyp1
device: 'ttyp2': device_add
PM: Adding info for No Bus:ttyp2
device: 'ttyp3': device_add
PM: Adding info for No Bus:ttyp3
device: 'ttyp4': device_add
PM: Adding info for No Bus:ttyp4
device: 'ttyp5': device_add
PM: Adding info for No Bus:ttyp5
device: 'ttyp6': device_add
PM: Adding info for No Bus:ttyp6
device: 'ttyp7': device_add
PM: Adding info for No Bus:ttyp7
device: 'ttyp8': device_add
PM: Adding info for No Bus:ttyp8
device: 'ttyp9': device_add
PM: Adding info for No Bus:ttyp9
device: 'ttypa': device_add
PM: Adding info for No Bus:ttypa
device: 'ttypb': device_add
PM: Adding info for No Bus:ttypb
device: 'ttypc': device_add
PM: Adding info for No Bus:ttypc
device: 'ttypd': device_add
PM: Adding info for No Bus:ttypd
device: 'ttype': device_add
PM: Adding info for No Bus:ttype
device: 'ttypf': device_add
PM: Adding info for No Bus:ttypf
device: 'ttyq0': device_add
PM: Adding info for No Bus:ttyq0
device: 'ttyq1': device_add
PM: Adding info for No Bus:ttyq1
device: 'ttyq2': device_add
PM: Adding info for No Bus:ttyq2
device: 'ttyq3': device_add
PM: Adding info for No Bus:ttyq3
device: 'ttyq4': device_add
PM: Adding info for No Bus:ttyq4
device: 'ttyq5': device_add
PM: Adding info for No Bus:ttyq5
device: 'ttyq6': device_add
PM: Adding info for No Bus:ttyq6
device: 'ttyq7': device_add
PM: Adding info for No Bus:ttyq7
device: 'ttyq8': device_add
PM: Adding info for No Bus:ttyq8
device: 'ttyq9': device_add
PM: Adding info for No Bus:ttyq9
device: 'ttyqa': device_add
PM: Adding info for No Bus:ttyqa
device: 'ttyqb': device_add
PM: Adding info for No Bus:ttyqb
device: 'ttyqc': device_add
PM: Adding info for No Bus:ttyqc
device: 'ttyqd': device_add
PM: Adding info for No Bus:ttyqd
device: 'ttyqe': device_add
PM: Adding info for No Bus:ttyqe
device: 'ttyqf': device_add
PM: Adding info for No Bus:ttyqf
device: 'ttyr0': device_add
PM: Adding info for No Bus:ttyr0
device: 'ttyr1': device_add
PM: Adding info for No Bus:ttyr1
device: 'ttyr2': device_add
PM: Adding info for No Bus:ttyr2
device: 'ttyr3': device_add
PM: Adding info for No Bus:ttyr3
device: 'ttyr4': device_add
PM: Adding info for No Bus:ttyr4
device: 'ttyr5': device_add
PM: Adding info for No Bus:ttyr5
device: 'ttyr6': device_add
PM: Adding info for No Bus:ttyr6
device: 'ttyr7': device_add
PM: Adding info for No Bus:ttyr7
device: 'ttyr8': device_add
PM: Adding info for No Bus:ttyr8
device: 'ttyr9': device_add
PM: Adding info for No Bus:ttyr9
device: 'ttyra': device_add
PM: Adding info for No Bus:ttyra
device: 'ttyrb': device_add
PM: Adding info for No Bus:ttyrb
device: 'ttyrc': device_add
PM: Adding info for No Bus:ttyrc
device: 'ttyrd': device_add
PM: Adding info for No Bus:ttyrd
device: 'ttyre': device_add
PM: Adding info for No Bus:ttyre
device: 'ttyrf': device_add
PM: Adding info for No Bus:ttyrf
device: 'ttys0': device_add
PM: Adding info for No Bus:ttys0
device: 'ttys1': device_add
PM: Adding info for No Bus:ttys1
device: 'ttys2': device_add
PM: Adding info for No Bus:ttys2
device: 'ttys3': device_add
PM: Adding info for No Bus:ttys3
device: 'ttys4': device_add
PM: Adding info for No Bus:ttys4
device: 'ttys5': device_add
PM: Adding info for No Bus:ttys5
device: 'ttys6': device_add
PM: Adding info for No Bus:ttys6
device: 'ttys7': device_add
PM: Adding info for No Bus:ttys7
device: 'ttys8': device_add
PM: Adding info for No Bus:ttys8
device: 'ttys9': device_add
PM: Adding info for No Bus:ttys9
device: 'ttysa': device_add
PM: Adding info for No Bus:ttysa
device: 'ttysb': device_add
PM: Adding info for No Bus:ttysb
device: 'ttysc': device_add
PM: Adding info for No Bus:ttysc
device: 'ttysd': device_add
PM: Adding info for No Bus:ttysd
device: 'ttyse': device_add
PM: Adding info for No Bus:ttyse
device: 'ttysf': device_add
PM: Adding info for No Bus:ttysf
device: 'ttyt0': device_add
PM: Adding info for No Bus:ttyt0
device: 'ttyt1': device_add
PM: Adding info for No Bus:ttyt1
device: 'ttyt2': device_add
PM: Adding info for No Bus:ttyt2
device: 'ttyt3': device_add
PM: Adding info for No Bus:ttyt3
device: 'ttyt4': device_add
PM: Adding info for No Bus:ttyt4
device: 'ttyt5': device_add
PM: Adding info for No Bus:ttyt5
device: 'ttyt6': device_add
PM: Adding info for No Bus:ttyt6
device: 'ttyt7': device_add
PM: Adding info for No Bus:ttyt7
device: 'ttyt8': device_add
PM: Adding info for No Bus:ttyt8
device: 'ttyt9': device_add
PM: Adding info for No Bus:ttyt9
device: 'ttyta': device_add
PM: Adding info for No Bus:ttyta
device: 'ttytb': device_add
PM: Adding info for No Bus:ttytb
device: 'ttytc': device_add
PM: Adding info for No Bus:ttytc
device: 'ttytd': device_add
PM: Adding info for No Bus:ttytd
device: 'ttyte': device_add
PM: Adding info for No Bus:ttyte
device: 'ttytf': device_add
PM: Adding info for No Bus:ttytf
device: 'ttyu0': device_add
PM: Adding info for No Bus:ttyu0
device: 'ttyu1': device_add
PM: Adding info for No Bus:ttyu1
device: 'ttyu2': device_add
PM: Adding info for No Bus:ttyu2
device: 'ttyu3': device_add
PM: Adding info for No Bus:ttyu3
device: 'ttyu4': device_add
PM: Adding info for No Bus:ttyu4
device: 'ttyu5': device_add
PM: Adding info for No Bus:ttyu5
device: 'ttyu6': device_add
PM: Adding info for No Bus:ttyu6
device: 'ttyu7': device_add
PM: Adding info for No Bus:ttyu7
device: 'ttyu8': device_add
PM: Adding info for No Bus:ttyu8
device: 'ttyu9': device_add
PM: Adding info for No Bus:ttyu9
device: 'ttyua': device_add
PM: Adding info for No Bus:ttyua
device: 'ttyub': device_add
PM: Adding info for No Bus:ttyub
device: 'ttyuc': device_add
PM: Adding info for No Bus:ttyuc
device: 'ttyud': device_add
PM: Adding info for No Bus:ttyud
device: 'ttyue': device_add
PM: Adding info for No Bus:ttyue
device: 'ttyuf': device_add
PM: Adding info for No Bus:ttyuf
device: 'ttyv0': device_add
PM: Adding info for No Bus:ttyv0
device: 'ttyv1': device_add
PM: Adding info for No Bus:ttyv1
device: 'ttyv2': device_add
PM: Adding info for No Bus:ttyv2
device: 'ttyv3': device_add
PM: Adding info for No Bus:ttyv3
device: 'ttyv4': device_add
PM: Adding info for No Bus:ttyv4
device: 'ttyv5': device_add
PM: Adding info for No Bus:ttyv5
device: 'ttyv6': device_add
PM: Adding info for No Bus:ttyv6
device: 'ttyv7': device_add
PM: Adding info for No Bus:ttyv7
device: 'ttyv8': device_add
PM: Adding info for No Bus:ttyv8
device: 'ttyv9': device_add
PM: Adding info for No Bus:ttyv9
device: 'ttyva': device_add
PM: Adding info for No Bus:ttyva
device: 'ttyvb': device_add
PM: Adding info for No Bus:ttyvb
device: 'ttyvc': device_add
PM: Adding info for No Bus:ttyvc
device: 'ttyvd': device_add
PM: Adding info for No Bus:ttyvd
device: 'ttyve': device_add
PM: Adding info for No Bus:ttyve
device: 'ttyvf': device_add
PM: Adding info for No Bus:ttyvf
device: 'ttyw0': device_add
PM: Adding info for No Bus:ttyw0
device: 'ttyw1': device_add
PM: Adding info for No Bus:ttyw1
device: 'ttyw2': device_add
PM: Adding info for No Bus:ttyw2
device: 'ttyw3': device_add
PM: Adding info for No Bus:ttyw3
device: 'ttyw4': device_add
PM: Adding info for No Bus:ttyw4
device: 'ttyw5': device_add
PM: Adding info for No Bus:ttyw5
device: 'ttyw6': device_add
PM: Adding info for No Bus:ttyw6
device: 'ttyw7': device_add
PM: Adding info for No Bus:ttyw7
device: 'ttyw8': device_add
PM: Adding info for No Bus:ttyw8
device: 'ttyw9': device_add
PM: Adding info for No Bus:ttyw9
device: 'ttywa': device_add
PM: Adding info for No Bus:ttywa
device: 'ttywb': device_add
PM: Adding info for No Bus:ttywb
device: 'ttywc': device_add
PM: Adding info for No Bus:ttywc
device: 'ttywd': device_add
PM: Adding info for No Bus:ttywd
device: 'ttywe': device_add
PM: Adding info for No Bus:ttywe
device: 'ttywf': device_add
PM: Adding info for No Bus:ttywf
device: 'ttyx0': device_add
PM: Adding info for No Bus:ttyx0
device: 'ttyx1': device_add
PM: Adding info for No Bus:ttyx1
device: 'ttyx2': device_add
PM: Adding info for No Bus:ttyx2
device: 'ttyx3': device_add
PM: Adding info for No Bus:ttyx3
device: 'ttyx4': device_add
PM: Adding info for No Bus:ttyx4
device: 'ttyx5': device_add
PM: Adding info for No Bus:ttyx5
device: 'ttyx6': device_add
PM: Adding info for No Bus:ttyx6
device: 'ttyx7': device_add
PM: Adding info for No Bus:ttyx7
device: 'ttyx8': device_add
PM: Adding info for No Bus:ttyx8
device: 'ttyx9': device_add
PM: Adding info for No Bus:ttyx9
device: 'ttyxa': device_add
PM: Adding info for No Bus:ttyxa
device: 'ttyxb': device_add
PM: Adding info for No Bus:ttyxb
device: 'ttyxc': device_add
PM: Adding info for No Bus:ttyxc
device: 'ttyxd': device_add
PM: Adding info for No Bus:ttyxd
device: 'ttyxe': device_add
PM: Adding info for No Bus:ttyxe
device: 'ttyxf': device_add
PM: Adding info for No Bus:ttyxf
device: 'ttyy0': device_add
PM: Adding info for No Bus:ttyy0
device: 'ttyy1': device_add
PM: Adding info for No Bus:ttyy1
device: 'ttyy2': device_add
PM: Adding info for No Bus:ttyy2
device: 'ttyy3': device_add
PM: Adding info for No Bus:ttyy3
device: 'ttyy4': device_add
PM: Adding info for No Bus:ttyy4
device: 'ttyy5': device_add
PM: Adding info for No Bus:ttyy5
device: 'ttyy6': device_add
PM: Adding info for No Bus:ttyy6
device: 'ttyy7': device_add
PM: Adding info for No Bus:ttyy7
device: 'ttyy8': device_add
PM: Adding info for No Bus:ttyy8
device: 'ttyy9': device_add
PM: Adding info for No Bus:ttyy9
device: 'ttyya': device_add
PM: Adding info for No Bus:ttyya
device: 'ttyyb': device_add
PM: Adding info for No Bus:ttyyb
device: 'ttyyc': device_add
PM: Adding info for No Bus:ttyyc
device: 'ttyyd': device_add
PM: Adding info for No Bus:ttyyd
device: 'ttyye': device_add
PM: Adding info for No Bus:ttyye
device: 'ttyyf': device_add
PM: Adding info for No Bus:ttyyf
device: 'ttyz0': device_add
PM: Adding info for No Bus:ttyz0
device: 'ttyz1': device_add
PM: Adding info for No Bus:ttyz1
device: 'ttyz2': device_add
PM: Adding info for No Bus:ttyz2
device: 'ttyz3': device_add
PM: Adding info for No Bus:ttyz3
device: 'ttyz4': device_add
PM: Adding info for No Bus:ttyz4
device: 'ttyz5': device_add
PM: Adding info for No Bus:ttyz5
device: 'ttyz6': device_add
PM: Adding info for No Bus:ttyz6
device: 'ttyz7': device_add
PM: Adding info for No Bus:ttyz7
device: 'ttyz8': device_add
PM: Adding info for No Bus:ttyz8
device: 'ttyz9': device_add
PM: Adding info for No Bus:ttyz9
device: 'ttyza': device_add
PM: Adding info for No Bus:ttyza
device: 'ttyzb': device_add
PM: Adding info for No Bus:ttyzb
device: 'ttyzc': device_add
PM: Adding info for No Bus:ttyzc
device: 'ttyzd': device_add
PM: Adding info for No Bus:ttyzd
device: 'ttyze': device_add
PM: Adding info for No Bus:ttyze
device: 'ttyzf': device_add
PM: Adding info for No Bus:ttyzf
device: 'ttya0': device_add
PM: Adding info for No Bus:ttya0
device: 'ttya1': device_add
PM: Adding info for No Bus:ttya1
device: 'ttya2': device_add
PM: Adding info for No Bus:ttya2
device: 'ttya3': device_add
PM: Adding info for No Bus:ttya3
device: 'ttya4': device_add
PM: Adding info for No Bus:ttya4
device: 'ttya5': device_add
PM: Adding info for No Bus:ttya5
device: 'ttya6': device_add
PM: Adding info for No Bus:ttya6
device: 'ttya7': device_add
PM: Adding info for No Bus:ttya7
device: 'ttya8': device_add
PM: Adding info for No Bus:ttya8
device: 'ttya9': device_add
PM: Adding info for No Bus:ttya9
device: 'ttyaa': device_add
PM: Adding info for No Bus:ttyaa
device: 'ttyab': device_add
PM: Adding info for No Bus:ttyab
device: 'ttyac': device_add
PM: Adding info for No Bus:ttyac
device: 'ttyad': device_add
PM: Adding info for No Bus:ttyad
device: 'ttyae': device_add
PM: Adding info for No Bus:ttyae
device: 'ttyaf': device_add
PM: Adding info for No Bus:ttyaf
device: 'ttyb0': device_add
PM: Adding info for No Bus:ttyb0
device: 'ttyb1': device_add
PM: Adding info for No Bus:ttyb1
device: 'ttyb2': device_add
PM: Adding info for No Bus:ttyb2
device: 'ttyb3': device_add
PM: Adding info for No Bus:ttyb3
device: 'ttyb4': device_add
PM: Adding info for No Bus:ttyb4
device: 'ttyb5': device_add
PM: Adding info for No Bus:ttyb5
device: 'ttyb6': device_add
PM: Adding info for No Bus:ttyb6
device: 'ttyb7': device_add
PM: Adding info for No Bus:ttyb7
device: 'ttyb8': device_add
PM: Adding info for No Bus:ttyb8
device: 'ttyb9': device_add
PM: Adding info for No Bus:ttyb9
device: 'ttyba': device_add
PM: Adding info for No Bus:ttyba
device: 'ttybb': device_add
PM: Adding info for No Bus:ttybb
device: 'ttybc': device_add
PM: Adding info for No Bus:ttybc
device: 'ttybd': device_add
PM: Adding info for No Bus:ttybd
device: 'ttybe': device_add
PM: Adding info for No Bus:ttybe
device: 'ttybf': device_add
PM: Adding info for No Bus:ttybf
device: 'ttyc0': device_add
PM: Adding info for No Bus:ttyc0
device: 'ttyc1': device_add
PM: Adding info for No Bus:ttyc1
device: 'ttyc2': device_add
PM: Adding info for No Bus:ttyc2
device: 'ttyc3': device_add
PM: Adding info for No Bus:ttyc3
device: 'ttyc4': device_add
PM: Adding info for No Bus:ttyc4
device: 'ttyc5': device_add
PM: Adding info for No Bus:ttyc5
device: 'ttyc6': device_add
PM: Adding info for No Bus:ttyc6
device: 'ttyc7': device_add
PM: Adding info for No Bus:ttyc7
device: 'ttyc8': device_add
PM: Adding info for No Bus:ttyc8
device: 'ttyc9': device_add
PM: Adding info for No Bus:ttyc9
device: 'ttyca': device_add
PM: Adding info for No Bus:ttyca
device: 'ttycb': device_add
PM: Adding info for No Bus:ttycb
device: 'ttycc': device_add
PM: Adding info for No Bus:ttycc
device: 'ttycd': device_add
PM: Adding info for No Bus:ttycd
device: 'ttyce': device_add
PM: Adding info for No Bus:ttyce
device: 'ttycf': device_add
PM: Adding info for No Bus:ttycf
device: 'ttyd0': device_add
PM: Adding info for No Bus:ttyd0
device: 'ttyd1': device_add
PM: Adding info for No Bus:ttyd1
device: 'ttyd2': device_add
PM: Adding info for No Bus:ttyd2
device: 'ttyd3': device_add
PM: Adding info for No Bus:ttyd3
device: 'ttyd4': device_add
PM: Adding info for No Bus:ttyd4
device: 'ttyd5': device_add
PM: Adding info for No Bus:ttyd5
device: 'ttyd6': device_add
PM: Adding info for No Bus:ttyd6
device: 'ttyd7': device_add
PM: Adding info for No Bus:ttyd7
device: 'ttyd8': device_add
PM: Adding info for No Bus:ttyd8
device: 'ttyd9': device_add
PM: Adding info for No Bus:ttyd9
device: 'ttyda': device_add
PM: Adding info for No Bus:ttyda
device: 'ttydb': device_add
PM: Adding info for No Bus:ttydb
device: 'ttydc': device_add
PM: Adding info for No Bus:ttydc
device: 'ttydd': device_add
PM: Adding info for No Bus:ttydd
device: 'ttyde': device_add
PM: Adding info for No Bus:ttyde
device: 'ttydf': device_add
PM: Adding info for No Bus:ttydf
device: 'ttye0': device_add
PM: Adding info for No Bus:ttye0
device: 'ttye1': device_add
PM: Adding info for No Bus:ttye1
device: 'ttye2': device_add
PM: Adding info for No Bus:ttye2
device: 'ttye3': device_add
PM: Adding info for No Bus:ttye3
device: 'ttye4': device_add
PM: Adding info for No Bus:ttye4
device: 'ttye5': device_add
PM: Adding info for No Bus:ttye5
device: 'ttye6': device_add
PM: Adding info for No Bus:ttye6
device: 'ttye7': device_add
PM: Adding info for No Bus:ttye7
device: 'ttye8': device_add
PM: Adding info for No Bus:ttye8
device: 'ttye9': device_add
PM: Adding info for No Bus:ttye9
device: 'ttyea': device_add
PM: Adding info for No Bus:ttyea
device: 'ttyeb': device_add
PM: Adding info for No Bus:ttyeb
device: 'ttyec': device_add
PM: Adding info for No Bus:ttyec
device: 'ttyed': device_add
PM: Adding info for No Bus:ttyed
device: 'ttyee': device_add
PM: Adding info for No Bus:ttyee
device: 'ttyef': device_add
PM: Adding info for No Bus:ttyef
device: 'ptmx': device_add
PM: Adding info for No Bus:ptmx
Linux agpgart interface v0.103
device class 'drm': registering
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Registering platform device 'serial8250'. Parent at platform
device: 'serial8250': device_add
bus: 'platform': add device serial8250
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
device: 'ttyS1': device_add
PM: Adding info for No Bus:ttyS1
device: 'ttyS2': device_add
PM: Adding info for No Bus:ttyS2
device: 'ttyS3': device_add
PM: Adding info for No Bus:ttyS3
bus: 'platform': add driver serial8250
bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
bus: 'platform': really_probe: probing driver serial8250 with device serial8250
driver: 'serial8250': driver_bound: bound to device 'serial8250'
bus: 'platform': really_probe: bound device serial8250 to driver serial8250
bus: 'pnp': add driver serial
bus: 'pnp': driver_probe_device: matched device 00:04 with driver serial
bus: 'pnp': really_probe: probing driver serial with device 00:04
device: 'ttyS0': device_unregister
PM: Removing info for No Bus:ttyS0
device: 'ttyS0': device_create_release
00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
device: 'ttyS0': device_add
PM: Adding info for No Bus:ttyS0
driver: '00:04': driver_bound: bound to device 'serial'
bus: 'pnp': really_probe: bound device 00:04 to driver serial
bus: 'pnp': driver_probe_device: matched device 00:05 with driver serial
bus: 'pnp': really_probe: probing driver serial with device 00:05
device: 'ttyS1': device_unregister
PM: Removing info for No Bus:ttyS1
device: 'ttyS1': device_create_release
00:05: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
device: 'ttyS1': device_add
PM: Adding info for No Bus:ttyS1
driver: '00:05': driver_bound: bound to device 'serial'
bus: 'pnp': really_probe: bound device 00:05 to driver serial
bus: 'pci': add driver serial
device: 'ram0': device_add
PM: Adding info for No Bus:ram0
device: '1:0': device_add
PM: Adding info for No Bus:1:0
device: 'ram1': device_add
PM: Adding info for No Bus:ram1
device: '1:1': device_add
PM: Adding info for No Bus:1:1
device: 'ram2': device_add
PM: Adding info for No Bus:ram2
device: '1:2': device_add
PM: Adding info for No Bus:1:2
device: 'ram3': device_add
PM: Adding info for No Bus:ram3
device: '1:3': device_add
PM: Adding info for No Bus:1:3
device: 'ram4': device_add
PM: Adding info for No Bus:ram4
device: '1:4': device_add
PM: Adding info for No Bus:1:4
device: 'ram5': device_add
PM: Adding info for No Bus:ram5
device: '1:5': device_add
PM: Adding info for No Bus:1:5
device: 'ram6': device_add
PM: Adding info for No Bus:ram6
device: '1:6': device_add
PM: Adding info for No Bus:1:6
device: 'ram7': device_add
PM: Adding info for No Bus:ram7
device: '1:7': device_add
PM: Adding info for No Bus:1:7
device: 'ram8': device_add
PM: Adding info for No Bus:ram8
device: '1:8': device_add
PM: Adding info for No Bus:1:8
device: 'ram9': device_add
PM: Adding info for No Bus:ram9
device: '1:9': device_add
PM: Adding info for No Bus:1:9
device: 'ram10': device_add
PM: Adding info for No Bus:ram10
device: '1:10': device_add
PM: Adding info for No Bus:1:10
device: 'ram11': device_add
PM: Adding info for No Bus:ram11
device: '1:11': device_add
PM: Adding info for No Bus:1:11
device: 'ram12': device_add
PM: Adding info for No Bus:ram12
device: '1:12': device_add
PM: Adding info for No Bus:1:12
device: 'ram13': device_add
PM: Adding info for No Bus:ram13
device: '1:13': device_add
PM: Adding info for No Bus:1:13
device: 'ram14': device_add
PM: Adding info for No Bus:ram14
device: '1:14': device_add
PM: Adding info for No Bus:1:14
device: 'ram15': device_add
PM: Adding info for No Bus:ram15
device: '1:15': device_add
PM: Adding info for No Bus:1:15
brd: module loaded
device: 'loop0': device_add
PM: Adding info for No Bus:loop0
device: '7:0': device_add
PM: Adding info for No Bus:7:0
device: 'loop1': device_add
PM: Adding info for No Bus:loop1
device: '7:1': device_add
PM: Adding info for No Bus:7:1
device: 'loop2': device_add
PM: Adding info for No Bus:loop2
device: '7:2': device_add
PM: Adding info for No Bus:7:2
device: 'loop3': device_add
PM: Adding info for No Bus:loop3
device: '7:3': device_add
PM: Adding info for No Bus:7:3
device: 'loop4': device_add
PM: Adding info for No Bus:loop4
device: '7:4': device_add
PM: Adding info for No Bus:7:4
device: 'loop5': device_add
PM: Adding info for No Bus:loop5
device: '7:5': device_add
PM: Adding info for No Bus:7:5
device: 'loop6': device_add
PM: Adding info for No Bus:loop6
device: '7:6': device_add
PM: Adding info for No Bus:7:6
device: 'loop7': device_add
PM: Adding info for No Bus:loop7
device: '7:7': device_add
PM: Adding info for No Bus:7:7
loop: module loaded
bus: 'pnp': add driver i8042 kbd
bus: 'pnp': driver_probe_device: matched device 00:01 with driver i8042 kbd
bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:01
driver: '00:01': driver_bound: bound to device 'i8042 kbd'
bus: 'pnp': really_probe: bound device 00:01 to driver i8042 kbd
bus: 'pnp': add driver i8042 aux
bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 aux
bus: 'pnp': really_probe: probing driver i8042 aux with device 00:02
driver: '00:02': driver_bound: bound to device 'i8042 aux'
bus: 'pnp': really_probe: bound device 00:02 to driver i8042 aux
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
bus: 'platform': add driver i8042
Registering platform device 'i8042'. Parent at platform
device: 'i8042': device_add
bus: 'platform': add device i8042
PM: Adding info for platform:i8042
bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
bus: 'platform': really_probe: probing driver i8042 with device i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
device: 'serio0': device_add
bus: 'serio': add device serio0
PM: Adding info for serio:serio0
driver: 'i8042': driver_bound: bound to device 'i8042'
bus: 'platform': really_probe: bound device i8042 to driver i8042
device: 'serio1': device_add
bus: 'serio': add device serio1
device: 'mice': device_add
PM: Adding info for serio:serio1
PM: Adding info for No Bus:mice
device: 'psaux': device_add
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
device: 'event0': device_add
PM: Adding info for No Bus:event0
bus: 'serio': add driver atkbd
i2c /dev entries driver
bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio0
device class 'i2c-dev': registering
bus: 'i2c': add driver dev_driver
device: 'device-mapper': device_add
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
EDAC MC: Ver: 2.1.0 Jan 18 2009
Registering sysdev class 'edac'
bus: 'acpi': add driver asus_acpi
bus: 'acpi': remove driver asus_acpi
driver: 'asus_acpi': driver_release
GACT probability on
bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
bus: 'serio': really_probe: probing driver atkbd with device serio1
device: 'cpu_dma_latency': device_add
PM: Adding info for No Bus:cpu_dma_latency
device: 'network_latency': device_add
PM: Adding info for No Bus:network_latency
device: 'network_throughput': device_add
PM: Adding info for No Bus:network_throughput
registered taskstats version 1
Freeing unused kernel memory: 364k freed
all_generic_ide used greatest stack depth: 5528 bytes left
device: 'device:00': dev_uevent: bus uevent() returned -12
device: 'device:01': dev_uevent: bus uevent() returned -12
device: 'device:02': dev_uevent: bus uevent() returned -12
device: 'device:03': dev_uevent: bus uevent() returned -12
device: 'device:04': dev_uevent: bus uevent() returned -12
device: 'device:05': dev_uevent: bus uevent() returned -12
device: 'device:06': dev_uevent: bus uevent() returned -12
device: 'device:07': dev_uevent: bus uevent() returned -12
device: 'device:08': dev_uevent: bus uevent() returned -12
device: 'device:09': dev_uevent: bus uevent() returned -12
device: 'device:0a': dev_uevent: bus uevent() returned -12
device: 'device:0b': dev_uevent: bus uevent() returned -12
device: 'device:0c': dev_uevent: bus uevent() returned -12
device: 'device:0d': dev_uevent: bus uevent() returned -12
device: 'device:0e': dev_uevent: bus uevent() returned -12
device: 'device:0f': dev_uevent: bus uevent() returned -12
device: 'device:10': dev_uevent: bus uevent() returned -12
device: 'device:11': dev_uevent: bus uevent() returned -12
device: 'device:12': dev_uevent: bus uevent() returned -12
device: 'device:13': dev_uevent: bus uevent() returned -12
device: 'device:14': dev_uevent: bus uevent() returned -12
device: 'device:15': dev_uevent: bus uevent() returned -12
device: 'device:16': dev_uevent: bus uevent() returned -12
device: 'device:17': dev_uevent: bus uevent() returned -12
device: 'device:18': dev_uevent: bus uevent() returned -12
device: 'device:19': dev_uevent: bus uevent() returned -12
device: 'device:1a': dev_uevent: bus uevent() returned -12
device: 'device:1b': dev_uevent: bus uevent() returned -12
device: 'device:1c': dev_uevent: bus uevent() returned -12
device: 'device:1d': dev_uevent: bus uevent() returned -12
device: 'device:1e': dev_uevent: bus uevent() returned -12
device: 'device:1f': dev_uevent: bus uevent() returned -12
device: 'device:20': dev_uevent: bus uevent() returned -12
device: 'device:21': dev_uevent: bus uevent() returned -12
device: 'device:22': dev_uevent: bus uevent() returned -12
device: 'device:23': dev_uevent: bus uevent() returned -12
device: 'device:24': dev_uevent: bus uevent() returned -12
device: 'device:25': dev_uevent: bus uevent() returned -12
device: 'device:26': dev_uevent: bus uevent() returned -12
device: 'device:27': dev_uevent: bus uevent() returned -12
device: 'device:28': dev_uevent: bus uevent() returned -12
device: 'device:29': dev_uevent: bus uevent() returned -12
device: 'device:2a': dev_uevent: bus uevent() returned -12
device: 'device:2b': dev_uevent: bus uevent() returned -12
device: 'device:2c': dev_uevent: bus uevent() returned -12
device: 'device:2d': dev_uevent: bus uevent() returned -12
device: 'device:2e': dev_uevent: bus uevent() returned -12
device: 'device:2f': dev_uevent: bus uevent() returned -12
device: 'device:30': dev_uevent: bus uevent() returned -12
device: 'device:31': dev_uevent: bus uevent() returned -12
bus: 'usb': registered
device class 'usb_host': registering
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
usbcore: registered new device driver usb
device class 'mdio_bus': registering
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
modprobe used greatest stack depth: 5472 bytes left
device class 'scsi_host': registering
bus: 'scsi': registered
device class 'scsi_device': registering
SCSI subsystem initialized
bus: 'pci': add driver tg3
bus: 'pci': driver_probe_device: matched device 0000:01:01.0 with driver tg3
bus: 'pci': really_probe: probing driver tg3 with device 0000:01:01.0
tg3.c:v3.97 (December 10, 2008)
tg3 0000:01:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
tg3 0000:01:01.0: PME# disabled
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
bus: 'pci': add driver ohci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:03.0 with driver ohci_hcd
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:03.0
ohci_hcd 0000:00:03.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
device: 'eth0': device_add
PM: Adding info for No Bus:eth0
eth0: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:0d:60:98:12:e0
eth0: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
driver: '0000:01:01.0': driver_bound: bound to device 'tg3'
bus: 'pci': really_probe: bound device 0000:01:01.0 to driver tg3
bus: 'pci': driver_probe_device: matched device 0000:01:01.1 with driver tg3
bus: 'pci': really_probe: probing driver tg3 with device 0000:01:01.1
tg3 0000:01:01.1: PCI INT B -> GSI 28 (level, low) -> IRQ 28
tg3 0000:01:01.1: PME# disabled
tg3 0000:01:01.1: firmware: requesting tigon/tg3_tso.bin
device: '0000:01:01.1': device_add
PM: Adding info for No Bus:0000:01:01.1
device: '0000:01:01.1': device_unregister
PM: Removing info for No Bus:0000:01:01.1
device: 'eth1': device_add
PM: Adding info for No Bus:eth1
eth1: Tigon3 [partno(BCM95704A6) rev 2100] (PCIX:66MHz:64-bit) MAC address 00:0d:60:98:12:e1
eth1: attached PHY is 5704 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
driver: '0000:01:01.1': driver_bound: bound to device 'tg3'
bus: 'pci': really_probe: bound device 0000:01:01.1 to driver tg3
device: 'usb_host1': device_add
PM: Adding info for No Bus:usb_host1
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.0: enabled NEC chipset lost interrupt quirk
ohci_hcd 0000:00:03.0: created debug files
ohci_hcd 0000:00:03.0: supports USB remote wakeup
ohci_hcd 0000:00:03.0: irq 20, io mem 0xf3410000
libata version 3.00 loaded.
device class 'sas_host': registering
device class 'sas_phy': registering
device class 'sas_port': registering
device class 'sas_device': registering
device class 'sas_end_device': registering
device class 'sas_expander': registering
bus: 'pci': add driver ata_generic
Floppy drive(s): fd0 is 1.44M, fd1 is 1.44M
ohci_hcd 0000:00:03.0: OHCI controller state
ohci_hcd 0000:00:03.0: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:03.0: control 0x283 RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:03.0: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:03.0: intrstatus 0x00000004 SF
ohci_hcd 0000:00:03.0: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:03.0: hcca frame #001e
ohci_hcd 0000:00:03.0: roothub.a 0f000202 POTPGT=15 NPS NDP=2(2)
ohci_hcd 0000:00:03.0: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:03.0: roothub.status 00008000 DRWE
ohci_hcd 0000:00:03.0: roothub.portstatus [0] 0x00000100 PPS
ohci_hcd 0000:00:03.0: roothub.portstatus [1] 0x00000100 PPS
usb usb1: default language 0x0409
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc2 ohci_hcd
usb usb1: SerialNumber: 0000:00:03.0
device: 'usb1': device_add
bus: 'usb': add device usb1
PM: Adding info for usb:usb1
usb usb1: uevent
bus: 'usb': driver_probe_device: matched device usb1 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb1
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
device: '1-0:1.0': device_add
bus: 'usb': add device 1-0:1.0
PM: Adding info for usb:1-0:1.0
usb 1-0:1.0: uevent
bus: 'usb': driver_probe_device: matched device 1-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 1-0:1.0
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: global over-current protection
hub 1-0:1.0: power on to power good time: 30ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: no over-current condition exists
hub 1-0:1.0: trying to enable port power on non-switchable hub
driver: '1-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
device class 'usb_endpoint': registering
device: 'usbdev1.1_ep81': device_add
PM: Adding info for No Bus:usbdev1.1_ep81
drivers/usb/core/inode.c: creating file '001'
driver: 'usb1': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb1 to driver usb
device: 'usbdev1.1_ep00': device_add
PM: Adding info for No Bus:usbdev1.1_ep00
driver: '0000:00:03.0': driver_bound: bound to device 'ohci_hcd'
bus: 'pci': really_probe: bound device 0000:00:03.0 to driver ohci_hcd
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
bus: 'pci': add driver aic94xx
bus: 'pci': driver_probe_device: matched device 0000:01:02.0 with driver aic94xx
bus: 'pci': really_probe: probing driver aic94xx with device 0000:01:02.0
aic94xx 0000:01:02.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
bus: 'pci': driver_probe_device: matched device 0000:00:0f.1 with driver ata_generic
bus: 'pci': really_probe: probing driver ata_generic with device 0000:00:0f.1
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:01:02.0
FDC 0 is a National Semiconductor PC87306
Registering platform device 'floppy.0'. Parent at platform
device: 'floppy.0': device_add
bus: 'platform': add device floppy.0
PM: Adding info for platform:floppy.0
device: 'fd0': device_add
PM: Adding info for No Bus:fd0
device: '2:0': device_add
PM: Adding info for No Bus:2:0
Registering platform device 'floppy.1'. Parent at platform
device: 'floppy.1': device_add
bus: 'platform': add device floppy.1
PM: Adding info for platform:floppy.1
device: 'fd1': device_add
PM: Adding info for No Bus:fd1
scsi0 : aic94xx
device: 'host0': device_add
PM: Adding info for No Bus:host0
device: 'host0': device_add
PM: Adding info for No Bus:host0
bus: 'pci': driver_probe_device: matched device 0000:00:03.1 with driver ohci_hcd
bus: 'pci': really_probe: probing driver ohci_hcd with device 0000:00:03.1
ohci_hcd 0000:00:03.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.1: OHCI Host Controller
device: 'usb_host2': device_add
PM: Adding info for No Bus:usb_host2
drivers/usb/core/inode.c: creating file '002'
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.1: enabled NEC chipset lost interrupt quirk
ohci_hcd 0000:00:03.1: created debug files
ohci_hcd 0000:00:03.1: supports USB remote wakeup
ohci_hcd 0000:00:03.1: irq 20, io mem 0xf3411000
device: 'sas_host0': device_add
PM: Adding info for No Bus:sas_host0
device: 'host0': device_add
PM: Adding info for No Bus:host0
aic94xx: BIOS present (1,1), 1548
aic94xx: ue num:2, ue size:88
aic94xx: manuf sect SAS_ADDR 5005076a0115a840
aic94xx: manuf sect PCBA SN 
aic94xx: ms: num_phy_desc: 8
aic94xx: ms: phy0: ENABLED
aic94xx: ms: phy1: ENABLED
aic94xx: ms: phy2: ENABLED
aic94xx: ms: phy3: ENABLED
aic94xx: ms: phy4: ENABLED
aic94xx: ms: phy5: ENABLED
aic94xx: ms: phy6: ENABLED
aic94xx: ms: phy7: ENABLED
aic94xx: ms: max_phys:0x8, num_phys:0x8
aic94xx: ms: enabled_phys:0xff
ohci_hcd 0000:00:03.1: OHCI controller state
ohci_hcd 0000:00:03.1: OHCI 1.0, NO legacy support registers
ohci_hcd 0000:00:03.1: control 0x283 RWC HCFS=operational CBSR=3
ohci_hcd 0000:00:03.1: cmdstatus 0x00000 SOC=0
ohci_hcd 0000:00:03.1: intrstatus 0x00000004 SF
ohci_hcd 0000:00:03.1: intrenable 0x8000005a MIE RHSC UE RD WDH
ohci_hcd 0000:00:03.1: hcca frame #001e
ohci_hcd 0000:00:03.1: roothub.a 0f000202 POTPGT=15 NPS NDP=2(2)
ohci_hcd 0000:00:03.1: roothub.b 00000000 PPCM=0000 DR=0000
ohci_hcd 0000:00:03.1: roothub.status 00008000 DRWE
ohci_hcd 0000:00:03.1: roothub.portstatus [0] 0x00010101 CSC PPS CCS
ohci_hcd 0000:00:03.1: roothub.portstatus [1] 0x00000100 PPS
usb usb2: default language 0x0409
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc2 ohci_hcd
usb usb2: SerialNumber: 0000:00:03.1
device: 'usb2': device_add
bus: 'usb': add device usb2
PM: Adding info for usb:usb2
usb usb2: uevent
bus: 'usb': driver_probe_device: matched device usb2 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb2
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
device: '2-0:1.0': device_add
bus: 'usb': add device 2-0:1.0
PM: Adding info for usb:2-0:1.0
usb 2-0:1.0: uevent
bus: 'usb': driver_probe_device: matched device 2-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 2-0:1.0
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: global over-current protection
hub 2-0:1.0: power on to power good time: 30ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: no over-current condition exists
hub 2-0:1.0: trying to enable port power on non-switchable hub
driver: '2-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
device: 'usbdev2.1_ep81': device_add
PM: Adding info for No Bus:usbdev2.1_ep81
drivers/usb/core/inode.c: creating file '001'
driver: 'usb2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb2 to driver usb
device: 'usbdev2.1_ep00': device_add
PM: Adding info for No Bus:usbdev2.1_ep00
driver: '0000:00:03.1': driver_bound: bound to device 'ohci_hcd'
bus: 'pci': really_probe: bound device 0000:00:03.1 to driver ohci_hcd
aic94xx: ctrla: phy0: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy1: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy2: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy3: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy4: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy5: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy6: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: ctrla: phy7: sas_addr: 5005076a0115a840, sas rate:0x9-0x8, sata rate:0x0-0x0, flags:0x0
aic94xx: max_scbs:512, max_ddbs:128
aic94xx: setting phy0 addr to 5005076a0115a840
aic94xx: setting phy1 addr to 5005076a0115a840
aic94xx: setting phy2 addr to 5005076a0115a840
aic94xx: setting phy3 addr to 5005076a0115a840
aic94xx: setting phy4 addr to 5005076a0115a840
aic94xx: setting phy5 addr to 5005076a0115a840
aic94xx: setting phy6 addr to 5005076a0115a840
aic94xx: setting phy7 addr to 5005076a0115a840
aic94xx: num_edbs:21
aic94xx: num_escbs:3
aic94xx 0000:01:02.0: firmware: requesting aic94xx-seq.fw
device: '0000:01:02.0': device_add
PM: Adding info for No Bus:0000:01:02.0
bus: 'pci': add driver pata_serverworks
bus: 'pci': driver_probe_device: matched device 0000:00:0f.1 with driver pata_serverworks
bus: 'pci': really_probe: probing driver pata_serverworks with device 0000:00:0f.1
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
modprobe used greatest stack depth: 4888 bytes left
ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00010101 CSC PPS CCS
hub 2-0:1.0: port 1: status 0101 change 0001
scsi1 : pata_serverworks
device: 'host1': device_add
PM: Adding info for No Bus:host1
device: 'host1': device_add
PM: Adding info for No Bus:host1
scsi2 : pata_serverworks
device: 'host2': device_add
PM: Adding info for No Bus:host2
device: 'host2': device_add
PM: Adding info for No Bus:host2
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x700 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x708 irq 15
device: '0000:01:02.0': device_unregister
PM: Removing info for No Bus:0000:01:02.0
aic94xx: Found sequencer Firmware version 1.1 (V30)
aic94xx: downloading CSEQ...
aic94xx: dma-ing 8192 bytes
aic94xx: verified 8192 bytes, passed
aic94xx: downloading LSEQs...
aic94xx: dma-ing 14336 bytes
aic94xx: LSEQ0 verified 14336 bytes, passed
aic94xx: LSEQ1 verified 14336 bytes, passed
aic94xx: LSEQ2 verified 14336 bytes, passed
aic94xx: LSEQ3 verified 14336 bytes, passed
aic94xx: LSEQ4 verified 14336 bytes, passed
aic94xx: LSEQ5 verified 14336 bytes, passed
aic94xx: LSEQ6 verified 14336 bytes, passed
aic94xx: LSEQ7 verified 14336 bytes, passed
aic94xx: max_scbs:446
aic94xx: first_scb_site_no:0x20
aic94xx: last_scb_site_no:0x1fe
aic94xx: First SCB dma_handle: 0x2c000
aic94xx: device 0000:01:02.0: SAS addr 5005076a0115a840, PCBA SN , 8 phys, 8 enabled phys, flash present, BIOS build 1548
aic94xx: posting 3 escbs
aic94xx: escbs posted
device: 'phy-0:0': device_add
PM: Adding info for No Bus:phy-0:0
device: 'phy-0:0': device_add
PM: Adding info for No Bus:phy-0:0
device: 'phy-0:1': device_add
PM: Adding info for No Bus:phy-0:1
device: 'phy-0:1': device_add
PM: Adding info for No Bus:phy-0:1
device: 'phy-0:2': device_add
PM: Adding info for No Bus:phy-0:2
device: 'phy-0:2': device_add
PM: Adding info for No Bus:phy-0:2
device: 'phy-0:3': device_add
PM: Adding info for No Bus:phy-0:3
device: 'phy-0:3': device_add
PM: Adding info for No Bus:phy-0:3
device: 'phy-0:4': device_add
PM: Adding info for No Bus:phy-0:4
device: 'phy-0:4': device_add
PM: Adding info for No Bus:phy-0:4
device: 'phy-0:5': device_add
PM: Adding info for No Bus:phy-0:5
device: 'phy-0:5': device_add
PM: Adding info for No Bus:phy-0:5
device: 'phy-0:6': device_add
PM: Adding info for No Bus:phy-0:6
device: 'phy-0:6': device_add
PM: Adding info for No Bus:phy-0:6
device: 'phy-0:7': device_add
PM: Adding info for No Bus:phy-0:7
device: 'phy-0:7': device_add
PM: Adding info for No Bus:phy-0:7
aic94xx: posting 8 control phy scbs
aic94xx: control_phy_tasklet_complete: phy0, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy0: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 03 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x1 for phy0
aic94xx: control_phy_tasklet_complete: phy1, lrate:0x9, proto:0xe
device: 'port-0:0': device_add
PM: Adding info for No Bus:port-0:0
device: 'port-0:0': device_add
PM: Adding info for No Bus:port-0:0
sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5005076a00000620)
sas: DOING DISCOVERY on port 0, pid:1902
device: 'expander-0:0': device_add
PM: Adding info for No Bus:expander-0:0
device: 'expander-0:0': device_add
PM: Adding info for No Bus:expander-0:0
device: 'expander-0:0': device_add
PM: Adding info for No Bus:expander-0:0
device: 'expander-0:0': device_add
PM: Adding info for No Bus:expander-0:0
aic94xx: escb_tasklet_complete: phy1: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 04 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x3 for phy1
aic94xx: control_phy_tasklet_complete: phy2, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy2: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 07 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x7 for phy2
aic94xx: control_phy_tasklet_complete: phy3, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy3: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 06 20
aic94xx: 14: 08 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0xf for phy3
aic94xx: control_phy_tasklet_complete: phy4, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy4: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 03 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x10 for phy4
aic94xx: control_phy_tasklet_complete: phy5, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy5: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 04 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x30 for phy5
aic94xx: control_phy_tasklet_complete: phy6, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy6: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 07 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0x70 for phy6
aic94xx: control_phy_tasklet_complete: phy7, lrate:0x9, proto:0xe
aic94xx: escb_tasklet_complete: phy7: BYTES_DMAED
aic94xx: SAS proto IDENTIFY:
aic94xx: 00: 20 00 02 02
aic94xx: 04: 00 00 00 00
aic94xx: 08: 00 00 00 00
aic94xx: 0c: 50 05 07 6a
aic94xx: 10: 00 00 2c 50
aic94xx: 14: 08 00 00 00
aic94xx: 18: 00 00 00 00
aic94xx: asd_form_port: updating phy_mask 0xf0 for phy7
ohci_hcd 0000:00:03.0: auto-stop root hub
hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
hub 2-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
device: 'phy-0:0:0': device_add
PM: Adding info for No Bus:phy-0:0:0
device: 'phy-0:0:0': device_add
PM: Adding info for No Bus:phy-0:0:0
sas: ex 5005076a00000620 phy00:T attached: 0000000000000000
device: 'phy-0:0:1': device_add
PM: Adding info for No Bus:phy-0:0:1
device: 'phy-0:0:1': device_add
PM: Adding info for No Bus:phy-0:0:1
sas: ex 5005076a00000620 phy01:T attached: 0000000000000000
device: 'phy-0:0:2': device_add
PM: Adding info for No Bus:phy-0:0:2
device: 'phy-0:0:2': device_add
PM: Adding info for No Bus:phy-0:0:2
sas: ex 5005076a00000620 phy02:T attached: 0000000000000000
device: 'phy-0:0:3': device_add
PM: Adding info for No Bus:phy-0:0:3
device: 'phy-0:0:3': device_add
PM: Adding info for No Bus:phy-0:0:3
sas: ex 5005076a00000620 phy03:S attached: 5005076a0115a840
device: 'phy-0:0:4': device_add
PM: Adding info for No Bus:phy-0:0:4
device: 'phy-0:0:4': device_add
PM: Adding info for No Bus:phy-0:0:4
sas: ex 5005076a00000620 phy04:S attached: 5005076a0115a840
device: 'phy-0:0:5': device_add
PM: Adding info for No Bus:phy-0:0:5
device: 'phy-0:0:5': device_add
PM: Adding info for No Bus:phy-0:0:5
sas: ex 5005076a00000620 phy05:T attached: 0000000000000000
device: 'phy-0:0:6': device_add
PM: Adding info for No Bus:phy-0:0:6
device: 'phy-0:0:6': device_add
PM: Adding info for No Bus:phy-0:0:6
sas: ex 5005076a00000620 phy06:T attached: 0000000000000000
device: 'phy-0:0:7': device_add
PM: Adding info for No Bus:phy-0:0:7
device: 'phy-0:0:7': device_add
PM: Adding info for No Bus:phy-0:0:7
sas: ex 5005076a00000620 phy07:S attached: 5005076a0115a840
ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
device: 'phy-0:0:8': device_add
PM: Adding info for No Bus:phy-0:0:8
device: 'phy-0:0:8': device_add
PM: Adding info for No Bus:phy-0:0:8
sas: ex 5005076a00000620 phy08:S attached: 5005076a0115a840
device: 'phy-0:0:9': device_add
PM: Adding info for No Bus:phy-0:0:9
device: 'phy-0:0:9': device_add
PM: Adding info for No Bus:phy-0:0:9
sas: ex 5005076a00000620 phy09:T attached: 0000000000000000
device: 'phy-0:0:10': device_add
PM: Adding info for No Bus:phy-0:0:10
device: 'phy-0:0:10': device_add
PM: Adding info for No Bus:phy-0:0:10
sas: ex 5005076a00000620 phy10:T attached: 0000000000000000
device: 'phy-0:0:11': device_add
PM: Adding info for No Bus:phy-0:0:11
device: 'phy-0:0:11': device_add
PM: Adding info for No Bus:phy-0:0:11
sas: ex 5005076a00000620 phy11:D attached: 50010b9000001305
usb 2-1: new full speed USB device using ohci_hcd and address 2
device: 'phy-0:0:12': device_add
PM: Adding info for No Bus:phy-0:0:12
device: 'phy-0:0:12': device_add
PM: Adding info for No Bus:phy-0:0:12
sas: ex 5005076a00000620 phy12:D attached: 5005076a0000062d
device: 'port-0:0:3': device_add
PM: Adding info for No Bus:port-0:0:3
device: 'port-0:0:3': device_add
PM: Adding info for No Bus:port-0:0:3
device: 'port-0:0:11': device_add
PM: Adding info for No Bus:port-0:0:11
device: 'port-0:0:11': device_add
PM: Adding info for No Bus:port-0:0:11
device: 'end_device-0:0:11': device_add
PM: Adding info for No Bus:end_device-0:0:11
device: 'end_device-0:0:11': device_add
PM: Adding info for No Bus:end_device-0:0:11
device: 'end_device-0:0:11': device_add
PM: Adding info for No Bus:end_device-0:0:11
device: 'end_device-0:0:11': device_add
PM: Adding info for No Bus:end_device-0:0:11
scsi 0:0:0:0: Direct-Access     IBM-ESXS GNA073C3ESTT0Z N BH0C PQ: 0 ANSI: 5
ata1.00: ATAPI: HL-DT-ST CD-ROM GCR-8482B, 1.06, max UDMA/33
ata1.00: configured for UDMA/33
isa bounce pool size: 16 pages
device: 'target0:0:0': device_add
PM: Adding info for No Bus:target0:0:0
device: '0:0:0:0': device_add
bus: 'scsi': add device 0:0:0:0
PM: Adding info for scsi:0:0:0:0
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
device: 'port-0:0:12': device_add
PM: Adding info for No Bus:port-0:0:12
device: 'port-0:0:12': device_add
PM: Adding info for No Bus:port-0:0:12
device: 'end_device-0:0:12': device_add
PM: Adding info for No Bus:end_device-0:0:12
device: 'end_device-0:0:12': device_add
PM: Adding info for No Bus:end_device-0:0:12
device: 'end_device-0:0:12': device_add
PM: Adding info for No Bus:end_device-0:0:12
device: 'end_device-0:0:12': device_add
PM: Adding info for No Bus:end_device-0:0:12
scsi 1:0:0:0: CD-ROM            HL-DT-ST CD-ROM GCR-8482B 1.06 PQ: 0 ANSI: 5
ohci_hcd 0000:00:03.1: GetStatus roothub.portstatus [0] = 0x00100103 PRSC PPS PES CCS
scsi 0:0:1:0: Enclosure         IBM-ESXS VSC7160          1.01 PQ: 0 ANSI: 3
device: 'target1:0:0': device_add
PM: Adding info for No Bus:target1:0:0
device: '1:0:0:0': device_add
bus: 'scsi': add device 1:0:0:0
PM: Adding info for scsi:1:0:0:0
device: '1:0:0:0': device_add
PM: Adding info for No Bus:1:0:0:0
device: '1:0:0:0': device_add
PM: Adding info for No Bus:1:0:0:0
sas: device 5005076a0000062d, LUN 0 doesn't support TCQ
device: 'target0:0:1': device_add
PM: Adding info for No Bus:target0:0:1
device: '0:0:1:0': device_add
bus: 'scsi': add device 0:0:1:0
PM: Adding info for scsi:0:0:1:0
device: '0:0:1:0': device_add
PM: Adding info for No Bus:0:0:1:0
device: '0:0:1:0': device_add
PM: Adding info for No Bus:0:0:1:0
sas: DONE DISCOVERY on port 0, pid:1902, result:0
sas: phy1 matched wide port0
sas: phy-0:1 added to port-0:0, phy_mask:0x3 (5005076a00000620)
sas: phy2 matched wide port0
sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5005076a00000620)
sas: phy3 matched wide port0
sas: phy-0:3 added to port-0:0, phy_mask:0xf (5005076a00000620)
usb 2-1: skipped 1 descriptor after interface
usb 2-1: skipped 1 descriptor after interface
usb 2-1: skipped 1 descriptor after interface
device: 'port-0:1': device_add
PM: Adding info for No Bus:port-0:1
device: 'port-0:1': device_add
PM: Adding info for No Bus:port-0:1
sas: phy-0:4 added to port-0:1, phy_mask:0x10 (5005076a00002c50)
usb 2-1: default language 0x0409
sas: phy5 matched wide port1
sas: phy-0:5 added to port-0:1, phy_mask:0x30 (5005076a00002c50)
sas: phy6 matched wide port1
driver: '0000:00:0f.1': driver_bound: bound to device 'pata_serverworks'
bus: 'pci': really_probe: bound device 0000:00:0f.1 to driver pata_serverworks
sas: phy-0:6 added to port-0:1, phy_mask:0x70 (5005076a00002c50)
usb 2-1: New USB device found, idVendor=04b3, idProduct=4001
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: PPC I/F
usb 2-1: Manufacturer: IBM
usb 2-1: SerialNumber: 000d6046109e
device: '2-1': device_add
bus: 'usb': add device 2-1
PM: Adding info for usb:2-1
usb 2-1: uevent
bus: 'usb': driver_probe_device: matched device 2-1 with driver usb
bus: 'usb': really_probe: probing driver usb with device 2-1
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
sas: phy7 matched wide port1
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
device: '2-1:1.0': device_add
bus: 'usb': add device 2-1:1.0
PM: Adding info for usb:2-1:1.0
sas: phy-0:7 added to port-0:1, phy_mask:0xf0 (5005076a00002c50)
usb 2-1:1.0: uevent
device: 'usbdev2.2_ep81': device_add
PM: Adding info for No Bus:usbdev2.2_ep81
usb 2-1: adding 2-1:1.1 (config #1, interface 1)
device: '2-1:1.1': device_add
bus: 'usb': add device 2-1:1.1
PM: Adding info for usb:2-1:1.1
driver: '0000:01:02.0': driver_bound: bound to device 'aic94xx'
bus: 'pci': really_probe: bound device 0000:01:02.0 to driver aic94xx
sas: DOING DISCOVERY on port 1, pid:1902
device: 'expander-0:1': device_add
usb 2-1:1.1: uevent
device: 'usbdev2.2_ep82': device_add
PM: Adding info for No Bus:usbdev2.2_ep82
usb 2-1: adding 2-1:1.2 (config #1, interface 2)
device: '2-1:1.2': device_add
bus: 'usb': add device 2-1:1.2
PM: Adding info for usb:2-1:1.2
usb 2-1:1.2: uevent
device: 'usbdev2.2_ep83': device_add
PM: Adding info for No Bus:usbdev2.2_ep83
device: 'usbdev2.2_ep03': device_add
PM: Adding info for No Bus:usbdev2.2_ep03
drivers/usb/core/inode.c: creating file '002'
driver: '2-1': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device 2-1 to driver usb
device: 'usbdev2.2_ep00': device_add
PM: Adding info for No Bus:usbdev2.2_ep00
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
Driver 'sr' needs updating - please use bus_type methods
bus: 'scsi': add driver sr
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 0:0:0:0
bus: 'scsi': driver_probe_device: matched device 1:0:0:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 1:0:0:0
sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:expander-0:1
device: 'expander-0:1': device_add
PM: Adding info for No Bus:expander-0:1
device: 'expander-0:1': device_add
PM: Adding info for No Bus:expander-0:1
device: 'expander-0:1': device_add
PM: Adding info for No Bus:expander-0:1
device: 'sr0': device_add
device: 'phy-0:1:0': device_add
PM: Adding info for No Bus:phy-0:1:0
device: 'phy-0:1:0': device_add
PM: Adding info for No Bus:phy-0:1:0
sas: ex 5005076a00002c50 phy00:D attached: 50010b9000001369
PM: Adding info for No Bus:sr0
device: '11:0': device_add
PM: Adding info for No Bus:11:0
sr 1:0:0:0: Attached scsi CD-ROM sr0
driver: '1:0:0:0': driver_bound: bound to device 'sr'
bus: 'scsi': really_probe: bound device 1:0:0:0 to driver sr
bus: 'scsi': driver_probe_device: matched device 0:0:1:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 0:0:1:0
device: 'phy-0:1:1': device_add
PM: Adding info for No Bus:phy-0:1:1
device: 'phy-0:1:1': device_add
PM: Adding info for No Bus:phy-0:1:1
sas: ex 5005076a00002c50 phy01:T attached: 0000000000000000
device: 'phy-0:1:2': device_add
PM: Adding info for No Bus:phy-0:1:2
device: 'phy-0:1:2': device_add
PM: Adding info for No Bus:phy-0:1:2
sas: ex 5005076a00002c50 phy02:T attached: 0000000000000000
device: 'phy-0:1:3': device_add
PM: Adding info for No Bus:phy-0:1:3
device: 'phy-0:1:3': device_add
PM: Adding info for No Bus:phy-0:1:3
sas: ex 5005076a00002c50 phy03:S attached: 5005076a0115a840
device: 'phy-0:1:4': device_add
PM: Adding info for No Bus:phy-0:1:4
device: 'phy-0:1:4': device_add
PM: Adding info for No Bus:phy-0:1:4
sas: ex 5005076a00002c50 phy04:S attached: 5005076a0115a840
device: 'phy-0:1:5': device_add
PM: Adding info for No Bus:phy-0:1:5
device: 'phy-0:1:5': device_add
PM: Adding info for No Bus:phy-0:1:5
sas: ex 5005076a00002c50 phy05:T attached: 0000000000000000
device: 'phy-0:1:6': device_add
PM: Adding info for No Bus:phy-0:1:6
device: 'phy-0:1:6': device_add
PM: Adding info for No Bus:phy-0:1:6
sas: ex 5005076a00002c50 phy06:T attached: 0000000000000000
device: 'phy-0:1:7': device_add
PM: Adding info for No Bus:phy-0:1:7
device: 'phy-0:1:7': device_add
device class 'scsi_disk': registering
PM: Adding info for No Bus:phy-0:1:7
Driver 'sd' needs updating - please use bus_type methods
sas: ex 5005076a00002c50 phy07:S attached: 5005076a0115a840
bus: 'scsi': add driver sd
bus: 'scsi': driver_probe_device: matched device 0:0:0:0 with driver sd
device: 'phy-0:1:8': device_add
bus: 'scsi': really_probe: probing driver sd with device 0:0:0:0
PM: Adding info for No Bus:phy-0:1:8
device: 'phy-0:1:8': device_add
PM: Adding info for No Bus:phy-0:1:8
sas: ex 5005076a00002c50 phy08:S attached: 5005076a0115a840
device: '0:0:0:0': device_add
PM: Adding info for No Bus:0:0:0:0
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: d3 00 10 08
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
device: 'sda': device_add
PM: Adding info for No Bus:sda
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors: (73.4 GB/68.3 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: d3 00 10 08
device class 'scsi_generic': registering
device: 'phy-0:1:9': device_add
device: 'sg0': device_add
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
PM: Adding info for No Bus:sg0
sd 0:0:0:0: Attached scsi generic sg0 type 0
device: 'sg1': device_add
PM: Adding info for No Bus:sg1
sr 1:0:0:0: Attached scsi generic sg1 type 5
device: 'sg2': device_add
PM: Adding info for No Bus:sg2
scsi 0:0:1:0: Attached scsi generic sg2 type 13
PM: Adding info for No Bus:phy-0:1:9
device: 'phy-0:1:9': device_add
PM: Adding info for No Bus:phy-0:1:9
sas: ex 5005076a00002c50 phy09:T attached: 0000000000000000
device: 'phy-0:1:10': device_add
PM: Adding info for No Bus:phy-0:1:10
device: 'phy-0:1:10': device_add
PM: Adding info for No Bus:phy-0:1:10
 sda:<5>sas: ex 5005076a00002c50 phy10:T attached: 0000000000000000
device: 'phy-0:1:11': device_add
PM: Adding info for No Bus:phy-0:1:11
device: 'phy-0:1:11': device_add
PM: Adding info for No Bus:phy-0:1:11
sas: ex 5005076a00002c50 phy11:T attached: 0000000000000000
device: 'phy-0:1:12': device_add
PM: Adding info for No Bus:phy-0:1:12
device: 'phy-0:1:12': device_add
PM: Adding info for No Bus:phy-0:1:12
sas: ex 5005076a00002c50 phy12:D attached: 5005076a00002c5d
device: 'port-0:1:0': device_add
PM: Adding info for No Bus:port-0:1:0
device: 'port-0:1:0': device_add
PM: Adding info for No Bus:port-0:1:0
device: 'end_device-0:1:0': device_add
PM: Adding info for No Bus:end_device-0:1:0
device: 'end_device-0:1:0': device_add
PM: Adding info for No Bus:end_device-0:1:0
device: 'end_device-0:1:0': device_add
PM: Adding info for No Bus:end_device-0:1:0
device: 'end_device-0:1:0': device_add
PM: Adding info for No Bus:end_device-0:1:0
scsi 0:0:2:0: Direct-Access     IBM-ESXS BBA036C3ESTT0Z N BH06 PQ: 0 ANSI: 5
device: 'target0:0:2': device_add
PM: Adding info for No Bus:target0:0:2
device: '0:0:2:0': device_add
bus: 'scsi': add device 0:0:2:0
PM: Adding info for scsi:0:0:2:0
bus: 'scsi': driver_probe_device: matched device 0:0:2:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 0:0:2:0
device: '0:0:2:0': device_add
PM: Adding info for No Bus:0:0:2:0
device: 'sg3': device_add
PM: Adding info for No Bus:sg3
scsi 0:0:2:0: Attached scsi generic sg3 type 0
device: '0:0:2:0': device_add
PM: Adding info for No Bus:0:0:2:0
device: 'port-0:1:3': device_add
PM: Adding info for No Bus:port-0:1:3
device: 'port-0:1:3': device_add
PM: Adding info for No Bus:port-0:1:3
device: 'port-0:1:12': device_add
PM: Adding info for No Bus:port-0:1:12
device: 'port-0:1:12': device_add
PM: Adding info for No Bus:port-0:1:12
device: 'end_device-0:1:12': device_add
PM: Adding info for No Bus:end_device-0:1:12
device: 'end_device-0:1:12': device_add
PM: Adding info for No Bus:end_device-0:1:12
device: 'end_device-0:1:12': device_add
PM: Adding info for No Bus:end_device-0:1:12
device: 'end_device-0:1:12': device_add
PM: Adding info for No Bus:end_device-0:1:12
device class 'enclosure': registering
 sda1
device: 'sda1': device_add
PM: Adding info for No Bus:sda1
scsi 0:0:3:0: Enclosure         IBM-ESXS VSC7160          1.01 PQ: 0 ANSI: 3
sas: device 5005076a00002c5d, LUN 0 doesn't support TCQ
device: '259:0': device_add
PM: Adding info for No Bus:259:0
sd 0:0:0:0: [sda] Attached SCSI disk
driver: '0:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
bus: 'scsi': driver_probe_device: matched device 0:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:1:0
bus: 'scsi': driver_probe_device: matched device 0:0:2:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:2:0
device: '0:0:2:0': device_add
PM: Adding info for No Bus:0:0:2:0
device: 'target0:0:3': device_add
PM: Adding info for No Bus:target0:0:3
device: '0:0:3:0': device_add
bus: 'scsi': add device 0:0:3:0
PM: Adding info for scsi:0:0:3:0
bus: 'scsi': driver_probe_device: matched device 0:0:3:0 with driver sr
bus: 'scsi': really_probe: probing driver sr with device 0:0:3:0
device: '0:0:3:0': device_add
sd 0:0:2:0: [sdb] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: d3 00 10 08
PM: Adding info for No Bus:0:0:3:0
device: 'sg4': device_add
PM: Adding info for No Bus:sg4
scsi 0:0:3:0: Attached scsi generic sg4 type 13
sd 0:0:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
device: 'sdb': device_add
PM: Adding info for No Bus:sdb
device: '0:0:3:0': device_add
sd 0:0:2:0: [sdb] 71096640 512-byte hardware sectors: (36.4 GB/33.9 GiB)
PM: Adding info for No Bus:0:0:3:0
sas: DONE DISCOVERY on port 1, pid:1902, result:0
sd 0:0:2:0: [sdb] Write Protect is off
sd 0:0:2:0: [sdb] Mode Sense: d3 00 10 08
sd 0:0:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1 sdb2 sdb3
device: 'sdb1': device_add
PM: Adding info for No Bus:sdb1
device: 'sdb2': device_add
PM: Adding info for No Bus:sdb2
device: 'sdb3': device_add
PM: Adding info for No Bus:sdb3
device: '259:262144': device_add
PM: Adding info for No Bus:259:262144
sd 0:0:2:0: [sdb] Attached SCSI disk
driver: '0:0:2:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 0:0:2:0 to driver sd
bus: 'scsi': driver_probe_device: matched device 0:0:3:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 0:0:3:0
device: '0:0:1:0': device_add
PM: Adding info for No Bus:0:0:1:0
device: 'SLOT 000': device_add
PM: Adding info for No Bus:SLOT 000
device: 'SLOT 001': device_add
PM: Adding info for No Bus:SLOT 001
device: 'SLOT 002': device_add
PM: Adding info for No Bus:SLOT 002
device: 'SLOT 003': device_add
PM: Adding info for No Bus:SLOT 003
device: 'SLOT 004': device_add
PM: Adding info for No Bus:SLOT 004
device: 'SLOT 005': device_add
PM: Adding info for No Bus:SLOT 005
device: '0:0:3:0': device_add
PM: Adding info for No Bus:0:0:3:0
device: 'SLOT 006': device_add
PM: Adding info for No Bus:SLOT 006
device: 'SLOT 007': device_add
PM: Adding info for No Bus:SLOT 007
device: 'SLOT 008': device_add
PM: Adding info for No Bus:SLOT 008
device: 'SLOT 009': device_add
PM: Adding info for No Bus:SLOT 009
device: 'SLOT 010': device_add
PM: Adding info for No Bus:SLOT 010
device: 'SLOT 011': device_add
PM: Adding info for No Bus:SLOT 011
Driver 'ses' needs updating - please use bus_type methods
bus: 'scsi': add driver ses
bus: 'scsi': driver_probe_device: matched device 0:0:1:0 with driver ses
bus: 'scsi': really_probe: probing driver ses with device 0:0:1:0
ses 0:0:1:0: Attached Enclosure device
driver: '0:0:1:0': driver_bound: bound to device 'ses'
bus: 'scsi': really_probe: bound device 0:0:1:0 to driver ses
bus: 'scsi': driver_probe_device: matched device 0:0:3:0 with driver ses
bus: 'scsi': really_probe: probing driver ses with device 0:0:3:0
ses 0:0:3:0: Attached Enclosure device
driver: '0:0:3:0': driver_bound: bound to device 'ses'
bus: 'scsi': really_probe: bound device 0:0:3:0 to driver ses
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
modprobe used greatest stack depth: 4520 bytes left
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
grep used greatest stack depth: 3800 bytes left
udevd version 125 started
device: 'device:00': dev_uevent: bus uevent() returned -12
device: 'device:01': dev_uevent: bus uevent() returned -12
device: 'device:02': dev_uevent: bus uevent() returned -12
device: 'device:03': dev_uevent: bus uevent() returned -12
device: 'device:04': dev_uevent: bus uevent() returned -12
device: 'device:05': dev_uevent: bus uevent() returned -12
device: 'device:06': dev_uevent: bus uevent() returned -12
device: 'device:07': dev_uevent: bus uevent() returned -12
device: 'device:08': dev_uevent: bus uevent() returned -12
device: 'device:09': dev_uevent: bus uevent() returned -12
device: 'device:0a': dev_uevent: bus uevent() returned -12
device: 'device:0b': dev_uevent: bus uevent() returned -12
device: 'device:0c': dev_uevent: bus uevent() returned -12
device: 'device:0d': dev_uevent: bus uevent() returned -12
device: 'device:0e': dev_uevent: bus uevent() returned -12
device: 'device:0f': dev_uevent: bus uevent() returned -12
device: 'device:10': dev_uevent: bus uevent() returned -12
device: 'device:11': dev_uevent: bus uevent() returned -12
device: 'device:12': dev_uevent: bus uevent() returned -12
device: 'device:13': dev_uevent: bus uevent() returned -12
device: 'device:14': dev_uevent: bus uevent() returned -12
device: 'device:15': dev_uevent: bus uevent() returned -12
device: 'device:16': dev_uevent: bus uevent() returned -12
device: 'device:17': dev_uevent: bus uevent() returned -12
device: 'device:18': dev_uevent: bus uevent() returned -12
device: 'device:19': dev_uevent: bus uevent() returned -12
device: 'device:1a': dev_uevent: bus uevent() returned -12
device: 'device:1b': dev_uevent: bus uevent() returned -12
device: 'device:1c': dev_uevent: bus uevent() returned -12
device: 'device:1d': dev_uevent: bus uevent() returned -12
device: 'device:1e': dev_uevent: bus uevent() returned -12
device: 'device:1f': dev_uevent: bus uevent() returned -12
device: 'device:20': dev_uevent: bus uevent() returned -12
device: 'device:21': dev_uevent: bus uevent() returned -12
device: 'device:22': dev_uevent: bus uevent() returned -12
device: 'device:23': dev_uevent: bus uevent() returned -12
device: 'device:24': dev_uevent: bus uevent() returned -12
device: 'device:25': dev_uevent: bus uevent() returned -12
device: 'device:26': dev_uevent: bus uevent() returned -12
device: 'device:27': dev_uevent: bus uevent() returned -12
device: 'device:28': dev_uevent: bus uevent() returned -12
device: 'device:29': dev_uevent: bus uevent() returned -12
device: 'device:2a': dev_uevent: bus uevent() returned -12
device: 'device:2b': dev_uevent: bus uevent() returned -12
device: 'device:2c': dev_uevent: bus uevent() returned -12
device: 'device:2d': dev_uevent: bus uevent() returned -12
device: 'device:2e': dev_uevent: bus uevent() returned -12
device: 'device:2f': dev_uevent: bus uevent() returned -12
device: 'device:30': dev_uevent: bus uevent() returned -12
device: 'device:31': dev_uevent: bus uevent() returned -12
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-1: uevent
usb 2-1:1.0: uevent
usb 2-1:1.1: uevent
usb 2-1:1.2: uevent
bus: 'pci': add driver piix4_smbus
bus: 'pci': driver_probe_device: matched device 0000:00:0f.0 with driver piix4_smbus
bus: 'pci': really_probe: probing driver piix4_smbus with device 0000:00:0f.0
piix4_smbus 0000:00:0f.0: SMBus Host Controller at 0x440, revision 0
device: 'i2c-0': device_add
PM: Adding info for No Bus:i2c-0
device: 'i2c-0': device_add
PM: Adding info for No Bus:i2c-0
driver: '0000:00:0f.0': driver_bound: bound to device 'piix4_smbus'
bus: 'pci': really_probe: bound device 0000:00:0f.0 to driver piix4_smbus
device class 'rtc': registering
bus: 'pnp': add driver rtc_cmos
bus: 'pnp': driver_probe_device: matched device 00:08 with driver rtc_cmos
bus: 'pnp': really_probe: probing driver rtc_cmos with device 00:08
device: 'rtc0': device_add
PM: Adding info for No Bus:rtc0
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, 242 bytes nvram
driver: '00:08': driver_bound: bound to device 'rtc_cmos'
bus: 'pnp': really_probe: bound device 00:08 to driver rtc_cmos
bus: 'serio': add driver serio_raw
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1
device: 'vcs1': device_unregister
PM: Removing info for No Bus:vcs1
device: 'vcs1': device_create_release
device: 'vcsa1': device_unregister
PM: Removing info for No Bus:vcsa1
device: 'vcsa1': device_create_release
Adding 506036k swap on /dev/sdb2.  Priority:-1 extents:1 across:506036k 
EXT3 FS on sdb3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
tg3 0000:01:01.0: PME# disabled
rc used greatest stack depth: 3592 bytes left
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
device: 'vcs5': device_add
PM: Adding info for No Bus:vcs5
device: 'vcsa5': device_add
PM: Adding info for No Bus:vcsa5
device: 'vcs2': device_add
PM: Adding info for No Bus:vcs2
device: 'vcsa2': device_add
PM: Adding info for No Bus:vcsa2
device: 'vcs4': device_add
PM: Adding info for No Bus:vcs4
device: 'vcsa4': device_add
PM: Adding info for No Bus:vcsa4
device: 'vcs6': device_add
PM: Adding info for No Bus:vcs6
device: 'vcsa6': device_add
PM: Adding info for No Bus:vcsa6
device: 'vcs3': device_add
PM: Adding info for No Bus:vcs3
device: 'vcsa3': device_add
PM: Adding info for No Bus:vcsa3
device: 'vcs1': device_add
PM: Adding info for No Bus:vcs1
device: 'vcsa1': device_add
PM: Adding info for No Bus:vcsa1




