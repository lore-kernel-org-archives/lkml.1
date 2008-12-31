Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYLaWYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYLaWYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:24:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYLaWYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:24:42 -0500
Received: from host58.190-226-94.telecom.net.ar ([190.226.94.58]:57081 "EHLO
	burns.springfield.home" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756744AbYLaWYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:24:39 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 17:24:37 EST
Date: Wed, 31 Dec 2008 19:59:29 -0200
From: Leandro Lucarella <llucax@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Resource map sanity check conflict on ACPI Non-volatile Storage
Message-ID: <20081231215929.GA24834@homero.springfield.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I've just upgraded to Linux 2.6.28 and when my system boot up I get
this warning:

resource map sanity check conflict: 0x1dffff00 0x1e0000ff 0x1dfff000 0x1dffffff ACPI Non-volatile Storage

And then a stack trace. Should I be worried? (please Cc me)

Here is the trace:
---------->8---------->8---------->8---------->8---------->8----------
Dec 31 15:13:38 homero kernel: ACPI: bus type pci registered
Dec 31 15:13:38 homero kernel: PCI: PCI BIOS revision 2.10 entry at 0xf1b20, last bus=2
Dec 31 15:13:38 homero kernel: PCI: Using configuration type 1 for base access
Dec 31 15:13:38 homero kernel: resource map sanity check conflict: 0x1dffff00 0x1e0000ff 0x1dfff000 0x1dffffff ACPI Non-volatile Storage
Dec 31 15:13:38 homero kernel: ------------[ cut here ]------------
Dec 31 15:13:38 homero kernel: WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x57/0x213()
Dec 31 15:13:38 homero kernel: Modules linked in:
Dec 31 15:13:38 homero kernel: Pid: 1, comm: swapper Not tainted 2.6.28 #2
Dec 31 15:13:38 homero kernel: Call Trace:
Dec 31 15:13:38 homero kernel:  [<c0332276>] ? printk+0xf/0x11
Dec 31 15:13:38 homero kernel:  [<c011b2e6>] warn_on_slowpath+0x41/0x62
Dec 31 15:13:38 homero kernel:  [<c02652fc>] ? acpi_os_release_object+0x8/0xc
Dec 31 15:13:38 homero kernel:  [<c027b839>] ? acpi_ut_delete_generic_state+0x13/0x15
Dec 31 15:13:38 homero kernel:  [<c02652fc>] ? acpi_os_release_object+0x8/0xc
Dec 31 15:13:38 homero kernel:  [<c027b5d4>] ? acpi_ut_delete_object_desc+0x38/0x3d
Dec 31 15:13:38 homero kernel:  [<c0332276>] ? printk+0xf/0x11
Dec 31 15:13:38 homero kernel:  [<c011f1ed>] ? iomem_map_sanity_check+0x6b/0x9a
Dec 31 15:13:38 homero kernel:  [<c0112237>] __ioremap_caller+0x57/0x213
Dec 31 15:13:38 homero kernel:  [<c027ad9a>] ? acpi_ut_update_ref_count+0x49/0x8d
Dec 31 15:13:38 homero kernel:  [<c027ae98>] ? acpi_ut_update_object_reference+0xba/0x11b
Dec 31 15:13:38 homero kernel:  [<c01124b3>] ioremap_nocache+0x10/0x12
Dec 31 15:13:38 homero kernel:  [<c032eae5>] ? acpi_os_map_memory+0x11/0x1a
Dec 31 15:13:38 homero kernel:  [<c032eae5>] acpi_os_map_memory+0x11/0x1a
Dec 31 15:13:38 homero kernel:  [<c02709a8>] acpi_ex_system_memory_space_handler+0xd7/0x207
Dec 31 15:13:38 homero kernel:  [<c02708d1>] ? acpi_ex_system_memory_space_handler+0x0/0x207
Dec 31 15:13:38 homero kernel:  [<c0269e33>] acpi_ev_address_space_dispatch+0x12f/0x16f
Dec 31 15:13:38 homero kernel:  [<c026dc8a>] acpi_ex_access_region+0x1b2/0x1c0
Dec 31 15:13:38 homero kernel:  [<c026ddaf>] acpi_ex_field_datum_io+0x117/0x1ae
Dec 31 15:13:38 homero kernel:  [<c026e103>] acpi_ex_write_with_update_rule+0xd5/0xde
Dec 31 15:13:38 homero kernel:  [<c026e3ec>] acpi_ex_insert_into_field+0x2e0/0x300
Dec 31 15:13:38 homero kernel:  [<c0272ee5>] ? acpi_ns_search_one_scope+0x15/0x3a
Dec 31 15:13:38 homero kernel:  [<c026ca35>] acpi_ex_write_data_to_field+0x169/0x181
Dec 31 15:13:38 homero kernel:  [<c0270b5a>] acpi_ex_store_object_to_node+0x82/0xb7
Dec 31 15:13:38 homero kernel:  [<c0270cfd>] acpi_ex_store+0xa6/0x201
Dec 31 15:13:38 homero kernel:  [<c026ecda>] acpi_ex_opcode_1A_1T_1R+0x3db/0x535
Dec 31 15:13:38 homero kernel:  [<c026f3fb>] ? acpi_ex_resolve_operands+0x18f/0x438
Dec 31 15:13:38 homero kernel:  [<c0267632>] acpi_ds_exec_end_op+0xe6/0x370
Dec 31 15:13:38 homero kernel:  [<c027661e>] acpi_ps_parse_loop+0x5cd/0x71f
Dec 31 15:13:38 homero kernel:  [<c0275a38>] acpi_ps_parse_aml+0x6d/0x267
Dec 31 15:13:38 homero kernel:  [<c0276c85>] acpi_ps_execute_method+0x11c/0x1d7
Dec 31 15:13:38 homero kernel:  [<c02738a0>] acpi_ns_evaluate+0x11c/0x1e4
Dec 31 15:13:38 homero kernel:  [<c0279682>] acpi_ut_evaluate_object+0x51/0x158
Dec 31 15:13:38 homero kernel:  [<c02797fa>] acpi_ut_execute_STA+0x1d/0x49
Dec 31 15:13:38 homero kernel:  [<c026535f>] ? acpi_os_signal_semaphore+0x25/0x29
Dec 31 15:13:38 homero kernel:  [<c0273286>] acpi_ns_get_device_callback+0x59/0x112
Dec 31 15:13:38 homero kernel:  [<c026539e>] ? acpi_os_wait_semaphore+0x3b/0x48
Dec 31 15:13:38 homero kernel:  [<c0274a42>] acpi_ns_walk_namespace+0x9a/0x110
Dec 31 15:13:38 homero kernel:  [<c04691b2>] ? acpi_init+0x0/0x237
Dec 31 15:13:38 homero kernel:  [<c02731b1>] acpi_get_devices+0x47/0x5d
Dec 31 15:13:38 homero kernel:  [<c027322d>] ? acpi_ns_get_device_callback+0x0/0x112
Dec 31 15:13:38 homero kernel:  [<c027f441>] ? ec_parse_device+0x0/0x80
Dec 31 15:13:38 homero kernel:  [<c0469743>] acpi_ec_ecdt_probe+0xc3/0x123
Dec 31 15:13:38 homero kernel:  [<c04691b2>] ? acpi_init+0x0/0x237
Dec 31 15:13:38 homero kernel:  [<c046922f>] acpi_init+0x7d/0x237
Dec 31 15:13:38 homero kernel:  [<c02a6233>] ? __class_create+0x44/0x5d
Dec 31 15:13:38 homero kernel:  [<c04678bb>] ? fbmem_init+0x0/0x78
Dec 31 15:13:38 homero kernel:  [<c010112f>] _stext+0x47/0x107
Dec 31 15:13:38 homero kernel:  [<c0145e3a>] ? __alloc_pages_internal+0x91/0x354
Dec 31 15:13:38 homero kernel:  [<c0243607>] ? idr_get_empty_slot+0x14f/0x238
Dec 31 15:13:38 homero kernel:  [<c024384d>] ? ida_get_new_above+0x15d/0x177
Dec 31 15:13:38 homero kernel:  [<c0243873>] ? ida_get_new+0xc/0xe
Dec 31 15:13:38 homero kernel:  [<c018b833>] ? proc_register+0x33/0x11a
Dec 31 15:13:38 homero kernel:  [<c018ba32>] ? create_proc_entry+0x7b/0x91
Dec 31 15:13:38 homero kernel:  [<c01407d6>] ? register_irq_proc+0x65/0x81
Dec 31 15:13:38 homero kernel:  [<c045049b>] kernel_init+0x6b/0xb9
Dec 31 15:13:38 homero kernel:  [<c0450430>] ? kernel_init+0x0/0xb9
Dec 31 15:13:38 homero kernel:  [<c0104453>] kernel_thread_helper+0x7/0x10
Dec 31 15:13:38 homero kernel: ---[ end trace 4eaa2a86a8e2da22 ]---
Dec 31 15:13:38 homero kernel: ACPI: Interpreter enabled
Dec 31 15:13:38 homero kernel: ACPI: (supports S0 S1 S3 S4 S5)
Dec 31 15:13:38 homero kernel: ACPI: Using IOAPIC for interrupt routing
----------8<----------8<----------8<----------8<----------8<----------


lshw:
---------->8---------->8---------->8---------->8---------->8----------

homero
    description: Tower Computer
    product: System Name
    vendor: System Manufacturer
    version: System Version
    serial: SYS-1234567890
    width: 32 bits
    configuration: boot=normal chassis=tower
  *-core
       description: Motherboard
       product: A7N266VM
       vendor: ASUSTeK Computer INC.
       physical id: 0
       version: REV 1.xx
       serial: xxxxxxxxxxx
     *-firmware
          description: BIOS
          vendor: Award Software, Inc.
          physical id: 0
          version: ASUS A7N266-VM ACPI BIOS Rev 1005 (11/19/2002)
          size: 64KiB
          capacity: 192KiB
          capabilities: pci pnp upgrade shadowing escd cdboot bootselect socketedrom edd int13floppy360 int13floppy1200 int13floppy720 int13floppy2880 int5printscreen int9keyboard int14serial int17printer int10video acpi usb agp
     *-cpu
          description: CPU
          product: AMD Athlon(TM) XP 2200+
          vendor: Advanced Micro Devices [AMD]
          physical id: 4
          bus info: cpu@0
          version: 6.8.0
          slot: SOCKET A
          size: 1800MHz
          capacity: 2GHz
          width: 32 bits
          clock: 133MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
        *-cache:0
             description: L1 cache
             physical id: 8
             slot: L1 Cache
             size: 128KiB
             capacity: 128KiB
             capabilities: synchronous internal write-back data
        *-cache:1
             description: L2 cache
             physical id: 9
             slot: L2 Cache
             size: 256KiB
             capacity: 8MiB
             capabilities: pipeline-burst synchronous internal write-back data
     *-memory
          description: System Memory
          physical id: 20
          slot: System board or motherboard
          size: 512MiB
          capacity: 512MiB
        *-bank:0
             description: DIMM DRAM Synchronous
             physical id: 0
             slot: DIMM 1
             size: 512MiB
             width: 64 bits
        *-bank:1
             description: DIMM DRAM Synchronous [empty]
             physical id: 1
             slot: DIMM 2
     *-pci
          description: Host bridge
          product: nForce CPU bridge
          vendor: nVidia Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: b2
          width: 32 bits
          clock: 66MHz
          configuration: driver=agpgart-nvidia module=nvidia_agp
        *-memory:0 UNCLAIMED
             description: RAM memory
             product: nForce 220/420 Memory Controller
             vendor: nVidia Corporation
             physical id: 0.1
             bus info: pci@0000:00:00.1
             version: b2
             width: 32 bits
             clock: 66MHz (15.2ns)
             configuration: latency=0
        *-memory:1 UNCLAIMED
             description: RAM memory
             product: nForce 220/420 Memory Controller
             vendor: nVidia Corporation
             physical id: 0.2
             bus info: pci@0000:00:00.2
             version: b2
             width: 32 bits
             clock: 66MHz (15.2ns)
             configuration: latency=0
        *-memory:2 UNCLAIMED
             description: RAM memory
             product: nVidia Corporation
             vendor: nVidia Corporation
             physical id: 0.3
             bus info: pci@0000:00:00.3
             version: b2
             width: 32 bits
             clock: 66MHz (15.2ns)
             configuration: latency=0
        *-isa
             description: ISA bridge
             product: nForce ISA Bridge
             vendor: nVidia Corporation
             physical id: 1
             bus info: pci@0000:00:01.0
             version: c3
             width: 32 bits
             clock: 66MHz
             capabilities: isa ht bus_master cap_list
             configuration: latency=0
        *-serial
             description: SMBus
             product: nForce PCI System Management
             vendor: nVidia Corporation
             physical id: 1.1
             bus info: pci@0000:00:01.1
             version: c1
             width: 32 bits
             clock: 66MHz
             capabilities: pm cap_list
             configuration: driver=amd756_smbus latency=0 maxlatency=1 mingnt=3 module=i2c_amd756
        *-usb:0
             description: USB Controller
             product: nForce USB Controller
             vendor: nVidia Corporation
             physical id: 2
             bus info: pci@0000:00:02.0
             version: c3
             width: 32 bits
             clock: 66MHz
             capabilities: pm ohci bus_master cap_list
             configuration: driver=ohci_hcd latency=0 maxlatency=1 mingnt=3 module=ohci_hcd
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.28 ohci_hcd
                physical id: 1
                bus info: usb@1
                logical name: usb1
                version: 2.06
                capabilities: usb-1.10
                configuration: driver=hub slots=3 speed=12.0MB/s
        *-usb:1
             description: USB Controller
             product: nForce USB Controller
             vendor: nVidia Corporation
             physical id: 3
             bus info: pci@0000:00:03.0
             version: c3
             width: 32 bits
             clock: 66MHz
             capabilities: pm ohci bus_master cap_list
             configuration: driver=ohci_hcd latency=0 maxlatency=1 mingnt=3 module=ohci_hcd
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.28 ohci_hcd
                physical id: 1
                bus info: usb@2
                logical name: usb2
                version: 2.06
                capabilities: usb-1.10
                configuration: driver=hub slots=3 speed=12.0MB/s
        *-network
             description: Ethernet interface
             product: nForce Ethernet Controller
             vendor: nVidia Corporation
             physical id: 4
             bus info: pci@0000:00:04.0
             logical name: eth0
             version: c2
             serial: 00:0c:6e:37:19:bf
             size: 100MB/s
             capacity: 100MB/s
             width: 32 bits
             clock: 66MHz
             capabilities: pm bus_master cap_list ethernet physical mii 10bt 10bt-fd 100bt 100bt-fd autonegotiation
             configuration: autonegotiation=on broadcast=yes driver=forcedeth driverversion=0.61 duplex=full ip=10.10.10.2 latency=0 link=yes maxlatency=20 mingnt=1 module=forcedeth multicast=yes port=MII speed=100MB/s
        *-multimedia:0 UNCLAIMED
             description: Multimedia audio controller
             product: nForce Audio Processing Unit
             vendor: nVidia Corporation
             physical id: 5
             bus info: pci@0000:00:05.0
             version: c2
             width: 32 bits
             clock: 66MHz
             capabilities: pm bus_master cap_list
             configuration: latency=0 maxlatency=12 mingnt=1
        *-multimedia:1
             description: Multimedia audio controller
             product: nForce AC'97 Audio Controller
             vendor: nVidia Corporation
             physical id: 6
             bus info: pci@0000:00:06.0
             version: c2
             width: 32 bits
             clock: 66MHz
             capabilities: pm bus_master cap_list
             configuration: driver=Intel ICH latency=0 maxlatency=5 mingnt=2 module=snd_intel8x0
        *-pci:0
             description: PCI bridge
             product: nForce PCI-to-PCI bridge
             vendor: nVidia Corporation
             physical id: 8
             bus info: pci@0000:00:08.0
             version: c2
             width: 32 bits
             clock: 66MHz
             capabilities: pci pm normal_decode bus_master
           *-multimedia
                description: Multimedia video controller
                product: Bt848 Video Capture
                vendor: Brooktree Corporation
                physical id: 7
                bus info: pci@0000:01:07.0
                version: 12
                width: 32 bits
                clock: 33MHz
                capabilities: bus_master
                configuration: driver=bttv latency=64 maxlatency=40 mingnt=16 module=bttv
        *-ide
             description: IDE interface
             product: nForce IDE
             vendor: nVidia Corporation
             physical id: 9
             bus info: pci@0000:00:09.0
             logical name: scsi0
             logical name: scsi1
             version: c3
             width: 32 bits
             clock: 66MHz
             capabilities: ide pm bus_master cap_list emulated
             configuration: driver=pata_amd latency=0 maxlatency=1 mingnt=3
           *-disk:0
                description: ATA Disk
                product: WDC WD1600JB-00G
                vendor: Western Digital
                physical id: 0
                bus info: scsi@0:0.0.0
                logical name: /dev/sda
                version: 08.0
                serial: WD-WMAL92195410
                size: 149GiB (160GB)
                capabilities: partitioned partitioned:dos
                configuration: ansiversion=5
              *-volume:0
                   description: EXT3 volume
                   vendor: Linux
                   physical id: 1
                   bus info: scsi@0:0.0.0,1
                   logical name: /dev/sda1
                   logical name: /boot
                   version: 1.0
                   serial: 09820bc3-b47e-459d-8be1-349e4db2fad5
                   size: 54MiB
                   capacity: 54MiB
                   capabilities: primary bootable journaled extended_attributes large_files huge_files recover ext3 ext2 initialized
                   configuration: created=2004-12-27 16:27:49 filesystem=ext3 modified=2008-12-31 15:13:01 mount.fstype=ext3 mount.options=rw,relatime,errors=continue,data=ordered mounted=2008-12-31 15:13:01 state=mounted
              *-volume:1
                   description: Linux LVM Physical Volume partition
                   physical id: 2
                   bus info: scsi@0:0.0.0,2
                   logical name: /dev/sda2
                   serial: tYFNMQ-pfSN-Xm51-PLRJ-Bj4w-31Rn-d6klVW
                   size: 148GiB
                   capacity: 148GiB
                   capabilities: primary multi lvm2
           *-disk:1
                description: ATA Disk
                product: WDC WD800BB-00DA
                vendor: Western Digital
                physical id: 1
                bus info: scsi@0:0.1.0
                logical name: /dev/sdb
                version: 02.1
                serial: WD-WMACM1228290
                size: 74GiB (80GB)
                capabilities: partitioned partitioned:dos
                configuration: ansiversion=5
              *-volume:0
                   description: EXT3 volume
                   vendor: Linux
                   physical id: 1
                   bus info: scsi@0:0.1.0,1
                   logical name: /dev/sdb1
                   version: 1.0
                   serial: 9cd921c6-92db-40a1-8eec-3703f81427c9
                   size: 54MiB
                   capacity: 54MiB
                   capabilities: primary bootable journaled extended_attributes large_files huge_files recover ext3 ext2 initialized
                   configuration: created=2004-12-28 14:45:27 filesystem=ext3 modified=2007-12-15 22:29:37 mounted=2007-12-15 22:28:58 state=clean
              *-volume:1
                   description: Linux LVM Physical Volume partition
                   physical id: 2
                   bus info: scsi@0:0.1.0,2
                   logical name: /dev/sdb2
                   serial: 7X1NQP-A5MR-EDvh-IYjJ-DTTl-fzf9-tw1SMK
                   size: 74GiB
                   capacity: 74GiB
                   capabilities: primary multi lvm2
           *-disk:2
                description: ATA Disk
                product: SAMSUNG SP1614N
                physical id: 2
                bus info: scsi@1:0.0.0
                logical name: /dev/sdc
                version: TM10
                serial: S016J10Y246160
                size: 149GiB (160GB)
                capabilities: partitioned partitioned:dos
                configuration: ansiversion=5 signature=000eb58e
              *-volume:0
                   description: Linux swap volume
                   physical id: 1
                   bus info: scsi@1:0.0.0,1
                   logical name: /dev/sdc1
                   version: 1
                   serial: 8098e78d-4fc9-423a-aed4-7f12a2d76a3e
                   size: 494MiB
                   capacity: 494MiB
                   capabilities: primary nofs swap initialized
                   configuration: filesystem=swap pagesize=4096
              *-volume:1
                   description: EXT3 volume
                   vendor: Linux
                   physical id: 2
                   bus info: scsi@1:0.0.0,2
                   logical name: /dev/sdc2
                   logical name: /mnt/media
                   version: 1.0
                   serial: 534b81d9-b4d5-463f-8c71-caa54ef8c9c9
                   size: 148GiB
                   capacity: 148GiB
                   capabilities: primary journaled extended_attributes large_files huge_files recover ext3 ext2 initialized
                   configuration: created=2008-08-04 19:41:27 filesystem=ext3 modified=2008-12-31 15:13:02 mount.fstype=ext3 mount.options=rw,relatime,errors=continue,data=ordered mounted=2008-12-31 15:13:02 state=mounted
           *-cdrom
                description: DVD writer
                product: DVDRW SOHW-832S
                vendor: LITE-ON
                physical id: 3
                bus info: scsi@1:0.1.0
                logical name: /dev/cdrom
                logical name: /dev/cdrw
                logical name: /dev/dvd
                logical name: /dev/dvdrw
                logical name: /dev/scd0
                logical name: /dev/sr0
                version: CG5M
                capabilities: removable audio cd-r cd-rw dvd dvd-r
                configuration: ansiversion=5 status=nodisc
        *-pci:1
             description: PCI bridge
             product: nForce AGP to PCI Bridge
             vendor: nVidia Corporation
             physical id: 1e
             bus info: pci@0000:00:1e.0
             version: b2
             width: 32 bits
             clock: 66MHz
             capabilities: pci normal_decode bus_master
           *-display UNCLAIMED
                description: VGA compatible controller
                product: NVCrush11 [GeForce2 MX Integrated Graphics]
                vendor: nVidia Corporation
                physical id: 0
                bus info: pci@0000:02:00.0
                version: b1
                width: 32 bits
                clock: 66MHz
                capabilities: pm agp agp-2.0 vga_controller cap_list
                configuration: latency=32 maxlatency=1 mingnt=5
----------8<----------8<----------8<----------8<----------8<----------

If you need any extra information, please let me know.

Thank you.

-- 
Leandro Lucarella (luca) | Blog colectivo: http://www.mazziblog.com.ar/blog/
----------------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------------
Far away across the field
The tolling of the iron bell
Calls the faithful to their knees
To hear the softly spoken magic spells.
