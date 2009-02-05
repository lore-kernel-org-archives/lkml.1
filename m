Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZBELb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZBELb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZBELbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:31:14 -0500
Received: from pfw.demon.co.uk ([62.49.22.168]:13805 "EHLO demon.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbZBELbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:31:03 -0500
Date: Thu, 5 Feb 2009 11:30:56 +0000
From: Larry Keegan <lk@pfw.demon.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: 'vmap allocation failed' with 2 graphics cards and kernel
 2.6.28
Message-ID: <20090205113056.2d8abf54@cs2.al.itld>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew,

Sorry for the email mess up; hopefully things should work now.

Please find below, the data you requested. In order to get this data I
ran my normal boot scripts. These scripts load lots of modules, DHCP,
and bring up a volume group. At this point I drop into bash and run
the commands you see. I'm sorry it's not quite as clear-cut as you
might like.

Here's the data from a Gigabyte GA-G31M-S2L with F9 BIOS and no
additional video card:

sh-3.1# uname -a
Linux xxx 2.6.28.2 #1 SMP Wed Feb 4 09:16:04 UTC 2009 i686 GNU/Linux
sh-3.1# mkswap /dev/mapper/vgmaster-dom0.swap.0000 
Setting up swapspace version 1, size = 4194300 KiB
no label, UUID=3324890d-dd35-4cad-84a1-78c9d862fa1c
sh-3.1# swapon /dev/mapper/vgmaster-dom0.swap.0000 
Adding 4194296k swap on /dev/mapper/vgmaster-dom0.swap.0000.  Priority:-1 extents:1 across:4194296k
sh-3.1# cat /proc/iomem 
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cb400-000cbfff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-bf5dffff : System RAM
  00200000-005bd7e5 : Kernel code
  005bd7e6-007eb85b : Kernel data
  00857000-008e3f4f : Kernel bss
bf5e0000-bf5e2fff : ACPI Non-volatile Storage
bf5e3000-bf5effff : ACPI Tables
bf5f0000-bf5fffff : reserved
c0000000-cfffffff : PCI MMCONFIG 0
  c0000000-cfffffff : reserved
    c0000000-cfffffff : pnp 00:0b
d0000000-dfffffff : 0000:00:02.0
e0000000-e0ffffff : PCI Bus 0000:02
e1000000-e2ffffff : PCI Bus 0000:03
  e2000000-e20003ff : 0000:03:00.0
    e2000000-e20003ff : tulip
e3000000-e30fffff : PCI Bus 0000:02
  e3000000-e300ffff : 0000:02:00.0
    e3000000-e300ffff : r8169
  e3010000-e3010fff : 0000:02:00.0
    e3010000-e3010fff : r8169
  e3020000-e302ffff : 0000:02:00.0
e3100000-e31fffff : 0000:00:02.0
e3200000-e327ffff : 0000:00:02.0
e3280000-e3283fff : 0000:00:1b.0
e3284000-e32843ff : 0000:00:1d.7
  e3284000-e32843ff : ehci_hcd
e3285000-e3285fff : Intel Flush Page
e3300000-e33fffff : PCI Bus 0000:03
  e3300000-e333ffff : 0000:03:00.0
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : pnp 00:0c
  fed00000-fed003ff : HPET 0
  fed13000-fed1dfff : pnp 00:0c
  fed20000-fed8ffff : pnp 00:0c
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0c
  ffb00000-ffb7ffff : pnp 00:0c
  fff00000-ffffffff : pnp 00:0c
sh-3.1# cat /proc/vmallocinfo 
0xf7bfe000-0xf7c00000    8192 hpet_enable+0x2b/0xe0 phys=fed00000 ioremap
0xf7c02000-0xf7c04000    8192 acpi_os_map_memory+0x11/0x26 phys=bf5e7000 ioremap
0xf7c04000-0xf7c07000   12288 acpi_os_map_memory+0x11/0x26 phys=bf5e7000 ioremap
0xf7c08000-0xf7c0e000   24576 acpi_os_map_memory+0x11/0x26 phys=bf5e3000 ioremap
0xf7c10000-0xf7c12000    8192 acpi_os_map_memory+0x11/0x26 phys=bf5e0000 ioremap
0xf7c14000-0xf7c16000    8192 acpi_os_map_memory+0x11/0x26 phys=fed1f000 ioremap
0xf7c18000-0xf7c1a000    8192 acpi_os_map_memory+0x11/0x26 phys=bf5e3000 ioremap
0xf7c1c000-0xf7c1e000    8192 acpi_os_map_memory+0x11/0x26 phys=bf5e7000 ioremap
0xf7c20000-0xf7c22000    8192 acpi_os_map_memory+0x11/0x26 phys=bf5e7000 ioremap
0xf7c23000-0xf7c28000   20480 agp_backend_initialize+0x80/0x220 pages=4 vmalloc
0xf7c2a000-0xf7c2c000    8192 intel_i9xx_setup_flush+0xc9/0x110 phys=e3285000 ioremap
0xf7c2d000-0xf7c32000   20480 drm_ht_create+0x5a/0xd0 pages=4 vmalloc
0xf7c3a000-0xf7c3c000    8192 usb_hcd_pci_probe+0x2ed/0x460 phys=e3284000 ioremap
0xf7c42000-0xf7c46000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7c47000-0xf7c4c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7c4d000-0xf7c59000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf7c5d000-0xf7c62000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7c63000-0xf7c6a000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf7c6b000-0xf7c6f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7c7e000-0xf7c80000    8192 0xf7c5d95b phys=fed1f000 ioremap
0xf7c80000-0xf7d81000 1052672 intel_i915_create_gatt_table+0x8f/0x110 phys=e3100000 ioremap
0xf7d82000-0xf7d8c000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7d8d000-0xf7d9a000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf7d9c000-0xf7da7000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf7da8000-0xf7db0000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf7db5000-0xf7dbf000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7dc4000-0xf7dc6000    8192 0xf7db9667 phys=e3010000 ioremap
0xf7dfb000-0xf7e00000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7e00000-0xf7e81000  528384 intel_i915_create_gatt_table+0xb2/0x110 phys=e3200000 ioremap
0xf7e88000-0xf7e8c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7e95000-0xf7ea4000   61440 vmalloc_exec+0x12/0x20 pages=14 vmalloc
0xf7ea5000-0xf7eca000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xf7ee6000-0xf7efc000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xf7f00000-0xf7f81000  528384 i915_driver_load+0x16a/0x270 phys=e3200000 ioremap
0xf7f89000-0xf7f8f000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf7f9c000-0xf7fa6000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7fad000-0xf7fb1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7fb7000-0xf7fbb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7fc5000-0xf7fcc000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf7fd4000-0xf7fd9000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7fed000-0xf7ffa000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf8005000-0xf800a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8023000-0xf8033000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf803c000-0xf8040000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf804a000-0xf804e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8059000-0xf805e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf806b000-0xf8072000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf807b000-0xf807f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8083000-0xf8085000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xf8086000-0xf8088000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xf8090000-0xf8095000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf809f000-0xf80a3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf80b9000-0xf80c7000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf80d0000-0xf80d4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf80dd000-0xf80e1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf80ed000-0xf80f3000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf80fd000-0xf8101000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf810b000-0xf810f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf811a000-0xf8120000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf812d000-0xf8134000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8140000-0xf8146000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf814f000-0xf8153000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf815e000-0xf8163000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8170000-0xf8177000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8180000-0xf8184000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8196000-0xf81a1000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf81ab000-0xf81af000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf81b8000-0xf81bc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf81c3000-0xf81c8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf81d4000-0xf81dc000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf81e7000-0xf81ec000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf81f9000-0xf8200000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf820e000-0xf8216000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8221000-0xf8226000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf822e000-0xf8233000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8249000-0xf8259000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf826f000-0xf827d000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf8288000-0xf828d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8298000-0xf829d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf82a7000-0xf82ae000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf82c2000-0xf82ce000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf82dc000-0xf82e4000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf82ed000-0xf82f1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8311000-0xf8316000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf831f000-0xf8323000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8330000-0xf8337000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8345000-0xf834c000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8355000-0xf8359000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8367000-0xf836f000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf83a1000-0xf83c9000  163840 vmalloc_exec+0x12/0x20 pages=39 vmalloc
0xf83d2000-0xf83d6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf83ed000-0xf83ff000   73728 vmalloc_exec+0x12/0x20 pages=17 vmalloc
0xf8450000-0xf848e000  253952 vmalloc_exec+0x12/0x20 pages=61 vmalloc
0xf8499000-0xf849e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf84a7000-0xf84ab000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf84b1000-0xf84b5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf84c7000-0xf84d2000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf84df000-0xf84e6000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf84f0000-0xf84f5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf84ff000-0xf8504000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf850e000-0xf8513000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf851c000-0xf8520000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8529000-0xf852d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf854c000-0xf8571000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xf85b9000-0xf85ec000  208896 vmalloc_exec+0x12/0x20 pages=50 vmalloc
0xf85f6000-0xf85fa000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8604000-0xf8608000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf865a000-0xf869a000  262144 vmalloc_exec+0x12/0x20 pages=63 vmalloc
0xf86a4000-0xf86a9000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf86b3000-0xf86b7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86bd000-0xf86c1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86ca000-0xf86ce000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86de000-0xf86e8000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf86fa000-0xf8705000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8713000-0xf871a000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf872c000-0xf8737000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8743000-0xf8749000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8753000-0xf8757000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf875f000-0xf8764000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf878c000-0xf87a8000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xf87b3000-0xf87b8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf87c1000-0xf87c5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87cf000-0xf87d3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87dd000-0xf87e1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87ea000-0xf87ee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87f8000-0xf87fc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8807000-0xf880d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8817000-0xf881b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8826000-0xf882c000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8852000-0xf886e000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xf8872000-0xf887b000   36864 0xf886f010 pages=8 vmalloc
0xf8883000-0xf8888000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8891000-0xf8895000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf889c000-0xf88a0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88a9000-0xf88ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88b6000-0xf88ba000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88c0000-0xf88c4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88ca000-0xf88ce000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88db000-0xf88e2000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf88eb000-0xf88ef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88fb000-0xf8901000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf890e000-0xf8916000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf891e000-0xf8923000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8938000-0xf8945000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf8956000-0xf8960000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf8972000-0xf897d000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8987000-0xf898b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8994000-0xf8998000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf89a4000-0xf89aa000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf89b2000-0xf89b8000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf89c2000-0xf89c6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf89d0000-0xf89d6000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8a04000-0xf8a27000  143360 vmalloc_exec+0x12/0x20 pages=34 vmalloc
0xf8a35000-0xf8a41000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf8a4a000-0xf8a4e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a58000-0xf8a5c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a66000-0xf8a6a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a74000-0xf8a79000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8a86000-0xf8a8f000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8a9d000-0xf8aa8000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8ac4000-0xf8ad9000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xf8ae7000-0xf8aef000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8af9000-0xf8afd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b06000-0xf8b0a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b14000-0xf8b18000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b22000-0xf8b26000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b2d000-0xf8b32000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8b3b000-0xf8b3f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b48000-0xf8b4c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b5d000-0xf8b67000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf8b72000-0xf8b77000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8b83000-0xf8b89000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8b93000-0xf8b97000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ba1000-0xf8ba5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bb0000-0xf8bb5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8bbb000-0xf8bbf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bc6000-0xf8bca000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bd4000-0xf8bd8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8be2000-0xf8be6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bef000-0xf8bf3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bfd000-0xf8c02000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c0b000-0xf8c0f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c18000-0xf8c1c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c26000-0xf8c2b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c3c000-0xf8c45000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8c4f000-0xf8c53000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c5e000-0xf8c63000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c6f000-0xf8c75000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8c7f000-0xf8c84000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c8f000-0xf8c94000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c9d000-0xf8ca1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8cb4000-0xf8cc2000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf8ccd000-0xf8cd2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8cdb000-0xf8cdf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ceb000-0xf8cf1000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8cfb000-0xf8cff000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d0b000-0xf8d12000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8d1f000-0xf8d2a000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8d2e000-0xf8d3a000   49152 0xf8d2b06d pages=11 vmalloc
0xf8d41000-0xf8d45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d4e000-0xf8d52000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d60000-0xf8d67000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8d70000-0xf8d74000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d7f000-0xf8d84000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8d8a000-0xf8d8e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d97000-0xf8d9b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8da4000-0xf8da8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8db3000-0xf8db8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8dc2000-0xf8dc7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8de2000-0xf8df7000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xf8e01000-0xf8e05000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8e0f000-0xf8e14000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e1e000-0xf8e23000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e30000-0xf8e36000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8e40000-0xf8e44000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8e4f000-0xf8e54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e63000-0xf8e6c000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8e75000-0xf8e79000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ec0000-0xf8efa000  237568 vmalloc_exec+0x12/0x20 pages=57 vmalloc
0xf8f04000-0xf8f08000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f12000-0xf8f17000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f20000-0xf8f24000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f31000-0xf8f38000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8f41000-0xf8f45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f4f000-0xf8f54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f5d000-0xf8f61000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f6c000-0xf8f71000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f78000-0xf8f7c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f82000-0xf8f86000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f8f000-0xf8f93000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f9c000-0xf8fa0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fa9000-0xf8fad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fb6000-0xf8fba000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fc6000-0xf8fcc000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8fd5000-0xf8fd9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fe7000-0xf8fef000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8ffa000-0xf8fff000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9009000-0xf900e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9019000-0xf901e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9025000-0xf9029000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9032000-0xf9036000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9054000-0xf9058000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9060000-0xf9065000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf906e000-0xf9072000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf907b000-0xf907f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9088000-0xf908c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9092000-0xf9096000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf909f000-0xf90a3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90ba000-0xf90be000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90c7000-0xf90cb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90d4000-0xf90d8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90e1000-0xf90e5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90ee000-0xf90f2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9100000-0xf9107000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9110000-0xf9114000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf911a000-0xf911e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9128000-0xf912d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9137000-0xf913c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9145000-0xf9149000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9153000-0xf9158000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9161000-0xf9165000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9189000-0xf9190000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf919b000-0xf91a0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf91a9000-0xf91ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf91b7000-0xf91bc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf91c5000-0xf91c9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf91dd000-0xf91e9000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf91f2000-0xf91f6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9203000-0xf920b000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9216000-0xf921b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9227000-0xf922d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf923e000-0xf9249000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf9252000-0xf9256000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9260000-0xf9265000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf926e000-0xf9272000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf927e000-0xf9284000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf928d000-0xf9291000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf929b000-0xf92a0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ab000-0xf92b0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ba000-0xf92be000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf92c8000-0xf92cc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf92d6000-0xf92db000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ec000-0xf92f6000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9301000-0xf9307000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9311000-0xf9315000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf931f000-0xf9323000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf932d000-0xf9332000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf933b000-0xf933f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9348000-0xf934c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9354000-0xf9359000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9372000-0xf9376000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf937f000-0xf9383000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf938c000-0xf9390000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf939c000-0xf93a2000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf93ab000-0xf93af000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93b9000-0xf93bd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93cb000-0xf93d3000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf93dc000-0xf93e0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93e9000-0xf93ed000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93fe000-0xf9407000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9411000-0xf9415000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf942d000-0xf9432000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf943b000-0xf943f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf944a000-0xf944f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf945b000-0xf9461000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9471000-0xf947c000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf9487000-0xf948d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf94a5000-0xf94a9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94b2000-0xf94b6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94bf000-0xf94c3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94d2000-0xf94da000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf94e7000-0xf94ee000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf94fa000-0xf9500000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf950c000-0xf9512000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf951b000-0xf951f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9526000-0xf952b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9536000-0xf953b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9545000-0xf9549000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9554000-0xf9559000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9563000-0xf9567000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9576000-0xf957f000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9588000-0xf958c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9635000-0xf96b7000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xf96c3000-0xf96c9000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf96da000-0xf96e4000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf96ed000-0xf96f1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf96f5000-0xf96f7000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xf96f8000-0xf96fa000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xf9700000-0xf9704000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf970d000-0xf9713000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf971c000-0xf9720000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf973b000-0xf9751000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xf975b000-0xf975f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9768000-0xf976c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf977a000-0xf9782000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf979e000-0xf97a2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf97b7000-0xf97c4000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf97ce000-0xf97d2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf97db000-0xf97df000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9800000-0xf9804000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf980e000-0xf9812000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf981b000-0xf981f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf982d000-0xf9834000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9840000-0xf9846000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf984f000-0xf9853000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf985c000-0xf9860000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf986b000-0xf9871000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf987a000-0xf987e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9887000-0xf988b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf98a9000-0xf98ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf98b7000-0xf98bc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98c6000-0xf98cb000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98d5000-0xf98da000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98e6000-0xf98eb000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98f4000-0xf98f8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9902000-0xf9906000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9911000-0xf9916000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9928000-0xf9934000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf9941000-0xf9948000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9956000-0xf995e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9968000-0xf996d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9976000-0xf997a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9985000-0xf998a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9993000-0xf9997000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf99a2000-0xf99a8000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf99ce000-0xf99d9000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf99e2000-0xf99e6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf99f3000-0xf99fa000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9a03000-0xf9a07000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a12000-0xf9a18000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9a23000-0xf9a29000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9a32000-0xf9a36000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a3c000-0xf9a40000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a47000-0xf9a4c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9a6f000-0xf9a77000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9a84000-0xf9a8b000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9a94000-0xf9a98000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9b30000-0xf9bb2000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xf9bbb000-0xf9bbf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9bc9000-0xf9bce000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9bda000-0xf9be0000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9bea000-0xf9bef000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9bf9000-0xf9bfd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c06000-0xf9c0a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c17000-0xf9c1d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9c27000-0xf9c2b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c44000-0xf9c48000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c52000-0xf9c57000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9c60000-0xf9c64000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c6f000-0xf9c74000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9c7d000-0xf9c81000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9cd0000-0xf9cd5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9cde000-0xf9ce2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9ceb000-0xf9cef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9cfa000-0xf9d00000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d0c000-0xf9d12000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d20000-0xf9d27000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9d33000-0xf9d3a000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9d46000-0xf9d4c000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d57000-0xf9d5c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9d66000-0xf9d6a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9d78000-0xf9d80000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9d99000-0xf9da9000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf9db2000-0xf9db6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9dc7000-0xf9dd1000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9ddc000-0xf9de1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9dea000-0xf9dee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9df7000-0xf9dfb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e05000-0xf9e09000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e12000-0xf9e16000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e1d000-0xf9e21000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e2a000-0xf9e2e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e34000-0xf9e38000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e41000-0xf9e45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e4f000-0xf9e54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9e5d000-0xf9e61000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e6b000-0xf9e70000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9e7c000-0xf9e82000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9e8b000-0xf9e8f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e98000-0xf9e9c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9eb7000-0xf9ebc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9ecd000-0xf9ed7000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9ee1000-0xf9ee6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9ef1000-0xf9ef6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9f00000-0xf9f05000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9f0f000-0xf9f13000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f1c000-0xf9f20000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f37000-0xf9f3d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9f47000-0xf9f4b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f57000-0xf9f5d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9f67000-0xf9f6b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f7c000-0xf9f85000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9f91000-0xf9f97000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9fa2000-0xf9fa7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9fb1000-0xf9fb5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fc1000-0xf9fc7000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9fd0000-0xf9fd4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fdd000-0xf9fe1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fea000-0xf9fee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9ff8000-0xf9ffc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa01e000-0xfa022000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa02d000-0xfa032000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa03b000-0xfa03f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa048000-0xfa04c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa056000-0xfa05b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa06b000-0xfa074000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfa07f000-0xfa084000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa08e000-0xfa092000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa09b000-0xfa09f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0a9000-0xfa0ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0b7000-0xfa0bb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0c5000-0xfa0ca000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa0d3000-0xfa0d7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0e0000-0xfa0e4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0ee000-0xfa0f3000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa101000-0xfa108000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa111000-0xfa115000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa121000-0xfa127000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa130000-0xfa134000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa140000-0xfa147000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa153000-0xfa159000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa163000-0xfa167000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa176000-0xfa17e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa188000-0xfa18d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa196000-0xfa19a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1a3000-0xfa1a7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1ab000-0xfa1ad000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xfa1ae000-0xfa1b0000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xfa1b6000-0xfa1ba000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1c3000-0xfa1c7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1d2000-0xfa1d7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa1e2000-0xfa1e7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa1f2000-0xfa1f7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa201000-0xfa205000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa213000-0xfa21b000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa224000-0xfa228000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa235000-0xfa23c000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa245000-0xfa249000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa253000-0xfa257000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa262000-0xfa267000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa273000-0xfa279000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa282000-0xfa286000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa2a1000-0xfa2a5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa2b1000-0xfa2b7000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa2c3000-0xfa2c8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa2d3000-0xfa2d9000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa2e3000-0xfa2e8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa2f3000-0xfa2f8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa302000-0xfa307000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa311000-0xfa315000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa320000-0xfa325000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa331000-0xfa337000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa346000-0xfa34e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa35a000-0xfa360000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa36a000-0xfa36e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa379000-0xfa37e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa3a5000-0xfa3a9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa449000-0xfa44b000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc
0xfa500000-0xfa502000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc
0xfa563000-0xfa764000 2101248 sys_swapon+0x42f/0x7a0 pages=512 vmalloc

Here's the data from a Gigabyte GA-G31M-S2L with F9 BIOS and with a
second graphics (nVIDIA) card, but with the BIOS configured to
initialise the On-board Intel graphics first:

sh-3.1# uname -a
Linux xxx 2.6.28.2 #1 SMP Wed Feb 4 09:27:32 UTC 2009 i686 GNU/Linux
sh-3.1# mkswap /dev/mapper/vgmaster-dom0.swap.0000 
Setting up swapspace version 1, size = 4194300 KiB
no label, UUID=c4f0dfff-1197-4f2c-a945-d8a0ece6fb22
sh-3.1# swapon /dev/mapper/vgmaster-dom0.swap.0000 
Adding 4194296k swap on /dev/mapper/vgmaster-dom0.swap.0000.  Priority:-1 extents:1 across:4194296k
sh-3.1# cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cb400-000cbfff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-af5dffff : System RAM
  00200000-005bd7e5 : Kernel code
  005bd7e6-007eb85b : Kernel data
  00857000-008e3f4f : Kernel bss
af5e0000-af5e2fff : ACPI Non-volatile Storage
af5e3000-af5effff : ACPI Tables
af5f0000-af5fffff : reserved
b0000000-bfffffff : PCI MMCONFIG 0
  b0000000-bfffffff : reserved
    b0000000-bfffffff : pnp 00:0b
c0000000-cfffffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
d0000000-dfffffff : 0000:00:02.0
e0000000-e2ffffff : PCI Bus 0000:01
  e0000000-e0ffffff : 0000:01:00.0
  e1000000-e1ffffff : 0000:01:00.0
  e2000000-e201ffff : 0000:01:00.0
e3000000-e3ffffff : PCI Bus 0000:03
e4000000-e5ffffff : PCI Bus 0000:04
  e5000000-e50003ff : 0000:04:00.0
    e5000000-e50003ff : tulip
e6000000-e60fffff : PCI Bus 0000:03
  e6000000-e600ffff : 0000:03:00.0
    e6000000-e600ffff : r8169
  e6010000-e6010fff : 0000:03:00.0
    e6010000-e6010fff : r8169
  e6020000-e602ffff : 0000:03:00.0
e6100000-e61fffff : 0000:00:02.0
e6200000-e627ffff : 0000:00:02.0
e6280000-e6283fff : 0000:00:1b.0
e6284000-e62843ff : 0000:00:1d.7
  e6284000-e62843ff : ehci_hcd
e6285000-e6285fff : Intel Flush Page
e6300000-e63fffff : PCI Bus 0000:04
  e6300000-e633ffff : 0000:04:00.0
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : pnp 00:0c
  fed00000-fed003ff : HPET 0
  fed13000-fed1dfff : pnp 00:0c
  fed20000-fed8ffff : pnp 00:0c
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0c
  ffb00000-ffb7ffff : pnp 00:0c
  fff00000-ffffffff : pnp 00:0c
sh-3.1# cat /proc/vmallocinfo 
0xf7bfe000-0xf7c00000    8192 hpet_enable+0x2b/0xe0 phys=fed00000 ioremap
0xf7c02000-0xf7c04000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c04000-0xf7c07000   12288 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c08000-0xf7c0e000   24576 acpi_os_map_memory+0x11/0x26 phys=af5e3000 ioremap
0xf7c10000-0xf7c12000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e0000 ioremap
0xf7c14000-0xf7c16000    8192 acpi_os_map_memory+0x11/0x26 phys=fed1f000 ioremap
0xf7c18000-0xf7c1a000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e3000 ioremap
0xf7c1c000-0xf7c1e000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c20000-0xf7c22000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c23000-0xf7c28000   20480 agp_backend_initialize+0x80/0x220 pages=4 vmalloc
0xf7c2a000-0xf7c2c000    8192 intel_i9xx_setup_flush+0xc9/0x110 phys=e6285000 ioremap
0xf7c2d000-0xf7c32000   20480 drm_ht_create+0x5a/0xd0 pages=4 vmalloc
0xf7c3a000-0xf7c3c000    8192 usb_hcd_pci_probe+0x2ed/0x460 phys=e6284000 ioremap
0xf7c42000-0xf7c46000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7c47000-0xf7c4c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7c4d000-0xf7c59000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf7c5d000-0xf7c62000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7c63000-0xf7c6a000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf7c6b000-0xf7c6f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7c7e000-0xf7c80000    8192 0xf7c5d95b phys=fed1f000 ioremap
0xf7c80000-0xf7d81000 1052672 intel_i915_create_gatt_table+0x8f/0x110 phys=e6100000 ioremap
0xf7d82000-0xf7d8c000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7d8d000-0xf7d9a000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf7d9c000-0xf7da7000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf7da8000-0xf7db0000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf7db5000-0xf7dbf000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7dc4000-0xf7dc6000    8192 0xf7db9667 phys=e6010000 ioremap
0xf7dfb000-0xf7e00000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7e00000-0xf7e81000  528384 intel_i915_create_gatt_table+0xb2/0x110 phys=e6200000 ioremap
0xf7e88000-0xf7e8c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7e95000-0xf7ea4000   61440 vmalloc_exec+0x12/0x20 pages=14 vmalloc
0xf7ea5000-0xf7eca000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xf7ee6000-0xf7efc000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xf7f00000-0xf7f81000  528384 i915_driver_load+0x16a/0x270 phys=e6200000 ioremap
0xf7f89000-0xf7f8f000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf7f9e000-0xf7fa9000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf7fb3000-0xf7fba000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf7fc7000-0xf7fd1000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7fdb000-0xf7fdf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7fe5000-0xf7fe9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7ff3000-0xf7ffa000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8005000-0xf800a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf801e000-0xf802b000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf8036000-0xf803b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8054000-0xf8064000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf806d000-0xf8071000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf807b000-0xf807f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf808a000-0xf808f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf809c000-0xf80a3000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf80ac000-0xf80b0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf80b4000-0xf80b6000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xf80b7000-0xf80b9000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xf80c1000-0xf80c6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf80d0000-0xf80d4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf80ea000-0xf80f8000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf8101000-0xf8105000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf810e000-0xf8112000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf811e000-0xf8124000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf812e000-0xf8132000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf813c000-0xf8140000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf814b000-0xf8151000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf815e000-0xf8165000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8171000-0xf8177000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8180000-0xf8184000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf818f000-0xf8194000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf81a1000-0xf81a8000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf81b1000-0xf81b5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf81bf000-0xf81c3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf81cc000-0xf81d0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf81d7000-0xf81dc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf81e8000-0xf81f0000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf81fb000-0xf8200000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf820d000-0xf8214000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8222000-0xf822a000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8235000-0xf823a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8242000-0xf8247000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf825d000-0xf826d000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf8283000-0xf8291000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf829c000-0xf82a1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf82ac000-0xf82b1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf82bb000-0xf82c2000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf82d6000-0xf82e2000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf82f0000-0xf82f8000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8301000-0xf8305000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8325000-0xf832a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8333000-0xf8337000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8344000-0xf834b000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8359000-0xf8360000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8369000-0xf836d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf837b000-0xf8383000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf83b5000-0xf83dd000  163840 vmalloc_exec+0x12/0x20 pages=39 vmalloc
0xf83e6000-0xf83ea000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8401000-0xf8413000   73728 vmalloc_exec+0x12/0x20 pages=17 vmalloc
0xf8464000-0xf84a2000  253952 vmalloc_exec+0x12/0x20 pages=61 vmalloc
0xf84ad000-0xf84b2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf84bb000-0xf84bf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf84c5000-0xf84c9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf84db000-0xf84e6000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf84f3000-0xf84fa000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8504000-0xf8509000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8513000-0xf8518000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8522000-0xf8527000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8530000-0xf8534000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf853d000-0xf8541000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8560000-0xf8585000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xf85cd000-0xf8600000  208896 vmalloc_exec+0x12/0x20 pages=50 vmalloc
0xf860a000-0xf860e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8618000-0xf861c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf866e000-0xf86ae000  262144 vmalloc_exec+0x12/0x20 pages=63 vmalloc
0xf86b8000-0xf86bd000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf86c7000-0xf86cb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86d1000-0xf86d5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86de000-0xf86e2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf86f2000-0xf86fc000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf870e000-0xf8719000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8727000-0xf872e000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8740000-0xf874b000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8757000-0xf875d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8767000-0xf876b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8773000-0xf8778000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf87a0000-0xf87bc000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xf87c7000-0xf87cc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf87d5000-0xf87d9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87e3000-0xf87e7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87f1000-0xf87f5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf87fe000-0xf8802000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf880c000-0xf8810000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf881b000-0xf8821000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf882b000-0xf882f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf883a000-0xf8840000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8866000-0xf8882000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xf8886000-0xf888f000   36864 0xf8883010 pages=8 vmalloc
0xf8897000-0xf889c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf88a5000-0xf88a9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88b0000-0xf88b4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88bd000-0xf88c1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88ca000-0xf88ce000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88d4000-0xf88d8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88de000-0xf88e2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88eb000-0xf88ef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf88fb000-0xf8901000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf890e000-0xf8916000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf891e000-0xf8923000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8938000-0xf8945000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf8956000-0xf8960000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf8972000-0xf897d000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8987000-0xf898b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8994000-0xf8998000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf89a4000-0xf89aa000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf89b2000-0xf89b8000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf89c2000-0xf89c6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf89d0000-0xf89d6000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8a04000-0xf8a27000  143360 vmalloc_exec+0x12/0x20 pages=34 vmalloc
0xf8a35000-0xf8a41000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf8a4a000-0xf8a4e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a58000-0xf8a5c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a66000-0xf8a6a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8a74000-0xf8a79000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8a86000-0xf8a8f000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8a9d000-0xf8aa8000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8aaf000-0xf8ab3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ad2000-0xf8ae7000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xf8af5000-0xf8afd000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8b06000-0xf8b0a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b14000-0xf8b18000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b22000-0xf8b26000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b2d000-0xf8b32000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8b3b000-0xf8b3f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b48000-0xf8b4c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8b5d000-0xf8b67000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf8b72000-0xf8b77000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8b83000-0xf8b89000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8b93000-0xf8b97000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ba1000-0xf8ba5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bb0000-0xf8bb5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8bbb000-0xf8bbf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bc6000-0xf8bca000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bd4000-0xf8bd8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8be2000-0xf8be6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bef000-0xf8bf3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8bfd000-0xf8c02000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c0b000-0xf8c0f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c18000-0xf8c1c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c26000-0xf8c2b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c3c000-0xf8c45000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8c4f000-0xf8c53000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8c5e000-0xf8c63000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c6f000-0xf8c75000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8c7f000-0xf8c84000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c8f000-0xf8c94000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8c9d000-0xf8ca1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8cb4000-0xf8cc2000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xf8ccd000-0xf8cd2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8cdb000-0xf8cdf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ceb000-0xf8cf1000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8cfb000-0xf8cff000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d0b000-0xf8d12000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8d1f000-0xf8d2a000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8d2e000-0xf8d3a000   49152 0xf8d2b06d pages=11 vmalloc
0xf8d41000-0xf8d45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d4e000-0xf8d52000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d60000-0xf8d67000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8d70000-0xf8d74000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d7f000-0xf8d84000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8d8a000-0xf8d8e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d97000-0xf8d9b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8da4000-0xf8da8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8db3000-0xf8db8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8dc2000-0xf8dc7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8de2000-0xf8df7000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xf8e01000-0xf8e05000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8e0f000-0xf8e14000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e1e000-0xf8e23000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e30000-0xf8e36000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8e40000-0xf8e44000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8e4f000-0xf8e54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8e63000-0xf8e6c000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf8e75000-0xf8e79000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8ec0000-0xf8efa000  237568 vmalloc_exec+0x12/0x20 pages=57 vmalloc
0xf8f04000-0xf8f08000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f12000-0xf8f17000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f20000-0xf8f24000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f31000-0xf8f38000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf8f41000-0xf8f45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f4f000-0xf8f54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f5d000-0xf8f61000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f6c000-0xf8f71000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf8f78000-0xf8f7c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f82000-0xf8f86000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f8f000-0xf8f93000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8f9c000-0xf8fa0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fa9000-0xf8fad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fb6000-0xf8fba000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fc6000-0xf8fcc000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf8fd5000-0xf8fd9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8fe7000-0xf8fef000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8ffa000-0xf8fff000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9009000-0xf900e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9019000-0xf901e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9025000-0xf9029000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9032000-0xf9036000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9054000-0xf9058000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9060000-0xf9065000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf906e000-0xf9072000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf907b000-0xf907f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9088000-0xf908c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9092000-0xf9096000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf909f000-0xf90a3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90ba000-0xf90be000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90c7000-0xf90cb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90d4000-0xf90d8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90e1000-0xf90e5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf90ee000-0xf90f2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9100000-0xf9107000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9110000-0xf9114000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf911a000-0xf911e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9128000-0xf912d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9137000-0xf913c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9145000-0xf9149000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9153000-0xf9158000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9161000-0xf9165000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9189000-0xf9190000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf919b000-0xf91a0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf91a9000-0xf91ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf91b7000-0xf91bc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf91c5000-0xf91c9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf91dd000-0xf91e9000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf91f2000-0xf91f6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9203000-0xf920b000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9216000-0xf921b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9227000-0xf922d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf923e000-0xf9249000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf9252000-0xf9256000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9260000-0xf9265000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf926e000-0xf9272000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf927e000-0xf9284000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf928d000-0xf9291000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf929b000-0xf92a0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ab000-0xf92b0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ba000-0xf92be000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf92c8000-0xf92cc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf92d6000-0xf92db000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf92ec000-0xf92f6000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9301000-0xf9307000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9311000-0xf9315000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf931f000-0xf9323000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf932d000-0xf9332000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf933b000-0xf933f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9348000-0xf934c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9354000-0xf9359000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9372000-0xf9376000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf937f000-0xf9383000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf938c000-0xf9390000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf939c000-0xf93a2000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf93ab000-0xf93af000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93b9000-0xf93bd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93cb000-0xf93d3000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf93dc000-0xf93e0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93e9000-0xf93ed000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf93fe000-0xf9407000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9411000-0xf9415000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf942d000-0xf9432000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf943b000-0xf943f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf944a000-0xf944f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf945b000-0xf9461000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9471000-0xf947c000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf9487000-0xf948d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf94a5000-0xf94a9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94b2000-0xf94b6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94bf000-0xf94c3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf94d2000-0xf94da000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf94e7000-0xf94ee000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf94fa000-0xf9500000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf950c000-0xf9512000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf951b000-0xf951f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9526000-0xf952b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9536000-0xf953b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9545000-0xf9549000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9554000-0xf9559000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9563000-0xf9567000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9576000-0xf957f000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9588000-0xf958c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9635000-0xf96b7000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xf96c3000-0xf96c9000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf96da000-0xf96e4000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf96ed000-0xf96f1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf96f5000-0xf96f7000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xf96f8000-0xf96fa000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xf9700000-0xf9704000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf970d000-0xf9713000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf971c000-0xf9720000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf973b000-0xf9751000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xf975b000-0xf975f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9768000-0xf976c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf977a000-0xf9782000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf979e000-0xf97a2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf97b7000-0xf97c4000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf97ce000-0xf97d2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf97db000-0xf97df000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9800000-0xf9804000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf980e000-0xf9812000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf981b000-0xf981f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf982d000-0xf9834000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9840000-0xf9846000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf984f000-0xf9853000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf985c000-0xf9860000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf986b000-0xf9871000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf987a000-0xf987e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9887000-0xf988b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf98a9000-0xf98ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf98b7000-0xf98bc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98c6000-0xf98cb000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98d5000-0xf98da000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98e6000-0xf98eb000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf98f4000-0xf98f8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9902000-0xf9906000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9911000-0xf9916000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9928000-0xf9934000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf9941000-0xf9948000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9956000-0xf995e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9968000-0xf996d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9976000-0xf997a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9985000-0xf998a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9993000-0xf9997000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf99a2000-0xf99a8000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf99ce000-0xf99d9000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf99e2000-0xf99e6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf99f3000-0xf99fa000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9a03000-0xf9a07000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a12000-0xf9a18000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9a23000-0xf9a29000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9a32000-0xf9a36000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a3c000-0xf9a40000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9a47000-0xf9a4c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9a6f000-0xf9a77000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9a84000-0xf9a8b000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9a94000-0xf9a98000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9b30000-0xf9bb2000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xf9bbb000-0xf9bbf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9bc9000-0xf9bce000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9bda000-0xf9be0000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9bea000-0xf9bef000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9bf9000-0xf9bfd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c06000-0xf9c0a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c17000-0xf9c1d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9c27000-0xf9c2b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c44000-0xf9c48000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c52000-0xf9c57000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9c60000-0xf9c64000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9c6f000-0xf9c74000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9c7d000-0xf9c81000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9cce000-0xf9cd2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9cdd000-0xf9ce2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9ceb000-0xf9cef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9cfa000-0xf9d00000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d0c000-0xf9d12000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d20000-0xf9d27000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9d33000-0xf9d3a000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf9d46000-0xf9d4c000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9d57000-0xf9d5c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9d66000-0xf9d6a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9d78000-0xf9d80000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf9d99000-0xf9da9000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xf9db2000-0xf9db6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9dc7000-0xf9dd1000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9ddc000-0xf9de1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9dea000-0xf9dee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9df7000-0xf9dfb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e05000-0xf9e09000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e12000-0xf9e16000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e1d000-0xf9e21000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e2a000-0xf9e2e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e34000-0xf9e38000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e41000-0xf9e45000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e4f000-0xf9e54000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9e5d000-0xf9e61000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e6b000-0xf9e70000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9e7c000-0xf9e82000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9e8b000-0xf9e8f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9e98000-0xf9e9c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9eb7000-0xf9ebc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9ecd000-0xf9ed7000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf9ee1000-0xf9ee6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9ef1000-0xf9ef6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9f00000-0xf9f05000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9f0f000-0xf9f13000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f1c000-0xf9f20000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f37000-0xf9f3d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9f47000-0xf9f4b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f57000-0xf9f5d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9f67000-0xf9f6b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9f7c000-0xf9f85000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xf9f91000-0xf9f97000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9fa2000-0xf9fa7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf9fb1000-0xf9fb5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fc1000-0xf9fc7000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xf9fd0000-0xf9fd4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fdd000-0xf9fe1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9fea000-0xf9fee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf9ff8000-0xf9ffc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa01e000-0xfa022000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa02d000-0xfa032000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa03b000-0xfa03f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa048000-0xfa04c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa056000-0xfa05b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa06b000-0xfa074000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfa07f000-0xfa084000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa08e000-0xfa092000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa09b000-0xfa09f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0a9000-0xfa0ad000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0b7000-0xfa0bb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0c5000-0xfa0ca000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa0d3000-0xfa0d7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0e0000-0xfa0e4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa0ee000-0xfa0f3000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa101000-0xfa108000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa111000-0xfa115000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa121000-0xfa127000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa130000-0xfa134000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa140000-0xfa147000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa153000-0xfa159000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa163000-0xfa167000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa176000-0xfa17e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa188000-0xfa18d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa196000-0xfa19a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1a3000-0xfa1a7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1ab000-0xfa1ad000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xfa1ae000-0xfa1b0000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xfa1b6000-0xfa1ba000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1c3000-0xfa1c7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa1d2000-0xfa1d7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa1e2000-0xfa1e7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa1f2000-0xfa1f7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa201000-0xfa205000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa213000-0xfa21b000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa224000-0xfa228000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa235000-0xfa23c000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfa245000-0xfa249000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa253000-0xfa257000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa262000-0xfa267000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa273000-0xfa279000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa282000-0xfa286000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa2a1000-0xfa2a5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa2b1000-0xfa2b7000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa2c3000-0xfa2c8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa2d3000-0xfa2d9000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa2e3000-0xfa2e8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa2f3000-0xfa2f8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa302000-0xfa307000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa311000-0xfa315000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa320000-0xfa325000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa331000-0xfa337000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa346000-0xfa34e000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfa35a000-0xfa360000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfa36a000-0xfa36e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa379000-0xfa37e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfa3a5000-0xfa3a9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfa449000-0xfa44b000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc
0xfa500000-0xfa502000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc
0xfa563000-0xfa764000 2101248 sys_swapon+0x42f/0x7a0 pages=512 vmalloc

Now, here's the data from the same box booted in the same way, but
this time with the BIOS set to initialise the nVIDIA first:

sh-3.1# uname -a
Linux xxx 2.6.28.2 #1 SMP Wed Feb 4 09:27:32 UTC 2009 i686 GNU/Linux
sh-3.1# mkswap /dev/mapper/vgmaster-dom0.swap.0000 
Setting up swapspace version 1, size = 4194300 KiB
no label, UUID=55ffd6d5-5443-41b5-929b-219feeab3745
sh-3.1# swapon /dev/mapper/vgmaster-dom0.swap.0000 
vmap allocation failed: use vmalloc=<size> to increase size.
swapon: /dev/mapper/vgmaster-dom0.swap.0000: Cannot allocate memory
sh-3.1# cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ce1ff : Video ROM
000ce200-000cffff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-af5dffff : System RAM
  00200000-005bd7e5 : Kernel code
  005bd7e6-007eb85b : Kernel data
  00857000-008e3f4f : Kernel bss
af5e0000-af5e2fff : ACPI Non-volatile Storage
af5e3000-af5effff : ACPI Tables
af5f0000-af5fffff : reserved
b0000000-bfffffff : PCI MMCONFIG 0
  b0000000-bfffffff : reserved
    b0000000-bfffffff : pnp 00:0b
c0000000-cfffffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
    c0000000-cfffffff : nvidiafb
d0000000-dfffffff : 0000:00:02.0
e0000000-e2ffffff : PCI Bus 0000:01
  e0000000-e0ffffff : 0000:01:00.0
    e0000000-e0ffffff : nvidiafb
  e1000000-e1ffffff : 0000:01:00.0
    e1000000-e1ffffff : nvidiafb
  e2000000-e201ffff : 0000:01:00.0
e3000000-e3ffffff : PCI Bus 0000:03
e4000000-e5ffffff : PCI Bus 0000:04
  e5000000-e50003ff : 0000:04:00.0
    e5000000-e50003ff : tulip
e6000000-e60fffff : PCI Bus 0000:03
  e6000000-e600ffff : 0000:03:00.0
    e6000000-e600ffff : r8169
  e6010000-e6010fff : 0000:03:00.0
    e6010000-e6010fff : r8169
  e6020000-e602ffff : 0000:03:00.0
e6100000-e61fffff : 0000:00:02.0
e6200000-e627ffff : 0000:00:02.0
e6280000-e6283fff : 0000:00:1b.0
e6284000-e62843ff : 0000:00:1d.7
  e6284000-e62843ff : ehci_hcd
e6285000-e6285fff : Intel Flush Page
e6300000-e63fffff : PCI Bus 0000:04
  e6300000-e633ffff : 0000:04:00.0
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : pnp 00:0c
  fed00000-fed003ff : HPET 0
  fed13000-fed1dfff : pnp 00:0c
  fed20000-fed8ffff : pnp 00:0c
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0c
  ffb00000-ffb7ffff : pnp 00:0c
  fff00000-ffffffff : pnp 00:0c
sh-3.1# cat /proc/vmallocinfo
0xf7bfe000-0xf7c00000    8192 hpet_enable+0x2b/0xe0 phys=fed00000 ioremap
0xf7c02000-0xf7c04000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c04000-0xf7c07000   12288 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c08000-0xf7c0e000   24576 acpi_os_map_memory+0x11/0x26 phys=af5e3000 ioremap
0xf7c10000-0xf7c12000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e0000 ioremap
0xf7c14000-0xf7c16000    8192 acpi_os_map_memory+0x11/0x26 phys=fed1f000 ioremap
0xf7c18000-0xf7c1a000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e3000 ioremap
0xf7c1c000-0xf7c1e000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c20000-0xf7c22000    8192 acpi_os_map_memory+0x11/0x26 phys=af5e7000 ioremap
0xf7c23000-0xf7c28000   20480 agp_backend_initialize+0x80/0x220 pages=4 vmalloc
0xf7c2a000-0xf7c2c000    8192 intel_i9xx_setup_flush+0xc9/0x110 phys=e6285000 ioremap
0xf7c2e000-0xf7c30000    8192 usb_hcd_pci_probe+0x2ed/0x460 phys=e6284000 ioremap
0xf7c37000-0xf7c39000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc
0xf7c3b000-0xf7c40000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xf7c41000-0xf7c4d000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xf7c4e000-0xf7c52000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf7c5d000-0xf7c64000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xf7c65000-0xf7c72000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xf7c75000-0xf7c7f000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf7c80000-0xf8c81000 16781312 nvidiafb_probe+0x174/0x480 phys=e0000000 ioremap
0xf8c94000-0xf8c9f000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xf8ca0000-0xf8caf000   61440 vmalloc_exec+0x12/0x20 pages=14 vmalloc
0xf8cb0000-0xf8cba000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xf8cbe000-0xf8cc0000    8192 0xf8cb4667 phys=e6010000 ioremap
0xf8cee000-0xf8cf6000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xf8cf7000-0xf8cfb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xf8d00000-0xfcd01000 67112960 nvidiafb_probe+0x27f/0x480 phys=c0000000 ioremap
0xfcd02000-0xfcd07000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfcd0a000-0xfcd0f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfcd10000-0xfcd12000    8192 init_module+0x400e95b/0x400eb20 [iTCO_wdt] phys=fed1f000 ioremap
0xfcd13000-0xfcd38000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xfcd54000-0xfcd6a000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xfcd71000-0xfcd75000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfcd80000-0xfce81000 1052672 intel_i915_create_gatt_table+0x8f/0x110 phys=e6100000 ioremap
0xfce82000-0xfce88000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfce97000-0xfcea2000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfceac000-0xfceb3000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfcec3000-0xfcecd000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfced7000-0xfcedb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfcee1000-0xfcee5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfceef000-0xfcef6000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfcf00000-0xfcf81000  528384 intel_i915_create_gatt_table+0xb2/0x110 phys=e6200000 ioremap
0xfcf82000-0xfcf87000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfcf9b000-0xfcfa8000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xfcfb3000-0xfcfb8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfcfd1000-0xfcfe1000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xfcfea000-0xfcfee000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfcff8000-0xfcffc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd007000-0xfd00c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd019000-0xfd020000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd029000-0xfd02d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd031000-0xfd033000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xfd034000-0xfd036000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xfd03e000-0xfd043000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd04d000-0xfd051000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd067000-0xfd075000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xfd07e000-0xfd082000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd08b000-0xfd08f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd09b000-0xfd0a1000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd0ab000-0xfd0af000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd0b9000-0xfd0bd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd0c8000-0xfd0ce000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd0db000-0xfd0e2000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd0ee000-0xfd0f4000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd0fd000-0xfd101000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd10c000-0xfd111000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd11e000-0xfd125000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd12e000-0xfd132000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd13c000-0xfd140000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd149000-0xfd14d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd154000-0xfd159000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd165000-0xfd16d000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfd178000-0xfd17d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd18a000-0xfd191000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd19f000-0xfd1a7000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfd1b2000-0xfd1b7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd1bf000-0xfd1c4000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd1da000-0xfd1ea000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xfd200000-0xfd20e000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xfd219000-0xfd21e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd229000-0xfd22e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd238000-0xfd23f000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd253000-0xfd25f000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xfd26d000-0xfd275000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfd27e000-0xfd282000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd2a2000-0xfd2a7000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd2b0000-0xfd2b4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd2c1000-0xfd2c8000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd2d6000-0xfd2dd000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd2e6000-0xfd2ea000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd2f8000-0xfd300000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfd332000-0xfd35a000  163840 vmalloc_exec+0x12/0x20 pages=39 vmalloc
0xfd363000-0xfd367000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd37e000-0xfd390000   73728 vmalloc_exec+0x12/0x20 pages=17 vmalloc
0xfd3e1000-0xfd41f000  253952 vmalloc_exec+0x12/0x20 pages=61 vmalloc
0xfd42a000-0xfd42f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd438000-0xfd43c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd442000-0xfd446000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd458000-0xfd463000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfd470000-0xfd477000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd481000-0xfd486000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd490000-0xfd495000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd49f000-0xfd4a4000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd4ad000-0xfd4b1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd4ba000-0xfd4be000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd4dd000-0xfd502000  151552 vmalloc_exec+0x12/0x20 pages=36 vmalloc
0xfd54a000-0xfd57d000  208896 vmalloc_exec+0x12/0x20 pages=50 vmalloc
0xfd587000-0xfd58b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd595000-0xfd599000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd5eb000-0xfd62b000  262144 vmalloc_exec+0x12/0x20 pages=63 vmalloc
0xfd635000-0xfd63a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd644000-0xfd648000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd64e000-0xfd652000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd65b000-0xfd65f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd66f000-0xfd679000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfd68b000-0xfd696000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfd6a4000-0xfd6ab000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfd6bd000-0xfd6c8000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfd6d4000-0xfd6da000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd6e4000-0xfd6e8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd6f0000-0xfd6f5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd71d000-0xfd739000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xfd744000-0xfd749000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd752000-0xfd756000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd760000-0xfd764000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd76e000-0xfd772000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd77b000-0xfd77f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd789000-0xfd78d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd798000-0xfd79e000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd7a8000-0xfd7ac000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd7b7000-0xfd7bd000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd7e3000-0xfd7ff000  114688 vmalloc_exec+0x12/0x20 pages=27 vmalloc
0xfd803000-0xfd80c000   36864 0xfd800010 pages=8 vmalloc
0xfd814000-0xfd819000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd822000-0xfd826000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd82d000-0xfd831000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd83a000-0xfd83e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd847000-0xfd84b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd851000-0xfd855000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd85b000-0xfd85f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd868000-0xfd86c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd878000-0xfd87e000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd88b000-0xfd893000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfd89b000-0xfd8a0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfd8b5000-0xfd8c2000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xfd8d3000-0xfd8dd000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfd8ef000-0xfd8fa000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfd904000-0xfd908000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd911000-0xfd915000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd921000-0xfd927000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd92f000-0xfd935000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd93f000-0xfd943000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd94d000-0xfd953000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfd981000-0xfd9a4000  143360 vmalloc_exec+0x12/0x20 pages=34 vmalloc
0xfd9b2000-0xfd9be000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xfd9c7000-0xfd9cb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd9d5000-0xfd9d9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd9e3000-0xfd9e7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfd9f1000-0xfd9f6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfda03000-0xfda0c000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfda1a000-0xfda25000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfda2c000-0xfda30000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfda4f000-0xfda64000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xfda72000-0xfda7a000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfda83000-0xfda87000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfda91000-0xfda95000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfda9f000-0xfdaa3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdaaa000-0xfdaaf000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdab8000-0xfdabc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdac5000-0xfdac9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdada000-0xfdae4000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfdaef000-0xfdaf4000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdb00000-0xfdb06000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfdb10000-0xfdb14000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb1e000-0xfdb22000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb2d000-0xfdb32000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdb38000-0xfdb3c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb43000-0xfdb47000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb51000-0xfdb55000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb5f000-0xfdb63000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb6c000-0xfdb70000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb7a000-0xfdb7f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdb88000-0xfdb8c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdb95000-0xfdb99000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdba3000-0xfdba8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdbb9000-0xfdbc2000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfdbcc000-0xfdbd0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdbdb000-0xfdbe0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdbec000-0xfdbf2000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfdbfc000-0xfdc01000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdc0c000-0xfdc11000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdc1a000-0xfdc1e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdc31000-0xfdc3f000   57344 vmalloc_exec+0x12/0x20 pages=13 vmalloc
0xfdc4a000-0xfdc4f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdc58000-0xfdc5c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdc68000-0xfdc6e000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfdc78000-0xfdc7c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdc88000-0xfdc8f000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfdc9c000-0xfdca7000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfdcab000-0xfdcb7000   49152 0xfdca806d pages=11 vmalloc
0xfdcbe000-0xfdcc2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdccb000-0xfdccf000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdcdd000-0xfdce4000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfdced000-0xfdcf1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdcfc000-0xfdd01000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdd07000-0xfdd0b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdd14000-0xfdd18000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdd21000-0xfdd25000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdd30000-0xfdd35000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdd3f000-0xfdd44000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdd5f000-0xfdd74000   86016 vmalloc_exec+0x12/0x20 pages=20 vmalloc
0xfdd7e000-0xfdd82000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdd8c000-0xfdd91000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdd9b000-0xfdda0000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfddad000-0xfddb3000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfddbd000-0xfddc1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfddcc000-0xfddd1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdde0000-0xfdde9000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfddf2000-0xfddf6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfde3d000-0xfde77000  237568 vmalloc_exec+0x12/0x20 pages=57 vmalloc
0xfde81000-0xfde85000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfde8f000-0xfde94000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfde9d000-0xfdea1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdeae000-0xfdeb5000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfdebe000-0xfdec2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdecc000-0xfded1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdeda000-0xfdede000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdee9000-0xfdeee000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdef5000-0xfdef9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdeff000-0xfdf03000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf0c000-0xfdf10000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf19000-0xfdf1d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf26000-0xfdf2a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf33000-0xfdf37000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf43000-0xfdf49000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfdf52000-0xfdf56000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdf64000-0xfdf6c000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfdf77000-0xfdf7c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdf86000-0xfdf8b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdf96000-0xfdf9b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdfa2000-0xfdfa6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdfaf000-0xfdfb3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdfd1000-0xfdfd5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdfdd000-0xfdfe2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfdfeb000-0xfdfef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfdff8000-0xfdffc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe005000-0xfe009000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe00f000-0xfe013000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe01c000-0xfe020000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe037000-0xfe03b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe044000-0xfe048000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe051000-0xfe055000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe05e000-0xfe062000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe06b000-0xfe06f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe07d000-0xfe084000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe08d000-0xfe091000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe097000-0xfe09b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe0a5000-0xfe0aa000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe0b4000-0xfe0b9000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe0c2000-0xfe0c6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe0d0000-0xfe0d5000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe0de000-0xfe0e2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe106000-0xfe10d000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe118000-0xfe11d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe126000-0xfe12a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe134000-0xfe139000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe142000-0xfe146000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe15a000-0xfe166000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xfe16f000-0xfe173000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe180000-0xfe188000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfe193000-0xfe198000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe1a4000-0xfe1aa000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe1bb000-0xfe1c6000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfe1cf000-0xfe1d3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe1dd000-0xfe1e2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe1eb000-0xfe1ef000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe1fb000-0xfe201000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe20a000-0xfe20e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe218000-0xfe21d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe228000-0xfe22d000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe237000-0xfe23b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe245000-0xfe249000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe253000-0xfe258000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe269000-0xfe273000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfe27e000-0xfe284000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe28e000-0xfe292000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe29c000-0xfe2a0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe2aa000-0xfe2af000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe2b8000-0xfe2bc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe2c5000-0xfe2c9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe2d1000-0xfe2d6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe2ef000-0xfe2f3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe2fc000-0xfe300000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe309000-0xfe30d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe319000-0xfe31f000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe328000-0xfe32c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe336000-0xfe33a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe348000-0xfe350000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfe359000-0xfe35d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe366000-0xfe36a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe37b000-0xfe384000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfe38e000-0xfe392000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe3aa000-0xfe3af000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe3b8000-0xfe3bc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe3c7000-0xfe3cc000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe3d8000-0xfe3de000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe3ee000-0xfe3f9000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfe404000-0xfe40a000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe422000-0xfe426000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe42f000-0xfe433000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe43c000-0xfe440000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe44f000-0xfe457000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfe464000-0xfe46b000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe477000-0xfe47d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe489000-0xfe48f000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe498000-0xfe49c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe4a3000-0xfe4a8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe4b3000-0xfe4b8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe4c2000-0xfe4c6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe4d1000-0xfe4d6000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe4e0000-0xfe4e4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe4f3000-0xfe4fc000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfe505000-0xfe509000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe5b2000-0xfe634000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xfe640000-0xfe646000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe657000-0xfe661000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfe66a000-0xfe66e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe672000-0xfe674000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xfe675000-0xfe677000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xfe67d000-0xfe681000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe68a000-0xfe690000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe699000-0xfe69d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe6b8000-0xfe6ce000   90112 vmalloc_exec+0x12/0x20 pages=21 vmalloc
0xfe6d8000-0xfe6dc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe6e5000-0xfe6e9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe6f7000-0xfe6ff000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfe71b000-0xfe71f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe734000-0xfe741000   53248 vmalloc_exec+0x12/0x20 pages=12 vmalloc
0xfe74b000-0xfe74f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe758000-0xfe75c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe77d000-0xfe781000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe78b000-0xfe78f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe798000-0xfe79c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe7aa000-0xfe7b1000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe7bd000-0xfe7c3000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe7cc000-0xfe7d0000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe7d9000-0xfe7dd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe7e8000-0xfe7ee000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe7f7000-0xfe7fb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe804000-0xfe808000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe826000-0xfe82a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe834000-0xfe839000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe843000-0xfe848000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe852000-0xfe857000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe863000-0xfe868000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe871000-0xfe875000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe87f000-0xfe883000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe88e000-0xfe893000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe8a5000-0xfe8b1000   49152 vmalloc_exec+0x12/0x20 pages=11 vmalloc
0xfe8be000-0xfe8c5000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe8d3000-0xfe8db000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfe8e5000-0xfe8ea000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe8f3000-0xfe8f7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe902000-0xfe907000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe910000-0xfe914000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe91f000-0xfe925000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe94b000-0xfe956000   45056 vmalloc_exec+0x12/0x20 pages=10 vmalloc
0xfe95f000-0xfe963000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe970000-0xfe977000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfe980000-0xfe984000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe98f000-0xfe995000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe9a0000-0xfe9a6000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfe9af000-0xfe9b3000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe9b9000-0xfe9bd000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfe9c4000-0xfe9c9000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfe9ec000-0xfe9f4000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfea01000-0xfea08000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfea11000-0xfea15000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeaad000-0xfeb2f000  532480 vmalloc_exec+0x12/0x20 pages=129 vmalloc
0xfeb38000-0xfeb3c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeb46000-0xfeb4b000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfeb57000-0xfeb5d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfeb67000-0xfeb6c000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfeb76000-0xfeb7a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeb83000-0xfeb87000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeb94000-0xfeb9a000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfeba4000-0xfeba8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfebc1000-0xfebc5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfebcf000-0xfebd4000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfebdd000-0xfebe1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfebec000-0xfebf1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfebfa000-0xfebfe000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfec4b000-0xfec4f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfec5a000-0xfec5f000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfec68000-0xfec6c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfec77000-0xfec7d000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfec89000-0xfec8f000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfec9d000-0xfeca4000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfecb0000-0xfecb7000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xfecc3000-0xfecc9000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfecd4000-0xfecd9000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfece3000-0xfece7000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfecf5000-0xfecfd000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xfed16000-0xfed26000   65536 vmalloc_exec+0x12/0x20 pages=15 vmalloc
0xfed2f000-0xfed33000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfed44000-0xfed4e000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfed59000-0xfed5e000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfed67000-0xfed6b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfed74000-0xfed78000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfed82000-0xfed86000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfed8f000-0xfed93000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfed9a000-0xfed9e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeda7000-0xfedab000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfedb1000-0xfedb5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfedbe000-0xfedc2000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfedcc000-0xfedd1000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfedda000-0xfedde000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfede8000-0xfeded000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfedf9000-0xfedff000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfee08000-0xfee0c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfee15000-0xfee19000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfee34000-0xfee39000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfee4a000-0xfee54000   40960 vmalloc_exec+0x12/0x20 pages=9 vmalloc
0xfee5e000-0xfee63000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfee6e000-0xfee73000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfee7d000-0xfee82000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfee8c000-0xfee90000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfee99000-0xfee9d000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeeb4000-0xfeeba000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfeec4000-0xfeec8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeed4000-0xfeeda000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfeee4000-0xfeee8000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfeef9000-0xfef02000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfef0e000-0xfef14000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfef1f000-0xfef24000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfef2e000-0xfef32000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfef3e000-0xfef44000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xfef4d000-0xfef51000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfef5a000-0xfef5e000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfef67000-0xfef6b000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfef75000-0xfef79000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfef9b000-0xfef9f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfefaa000-0xfefaf000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfefb8000-0xfefbc000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfefc5000-0xfefc9000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xfefd3000-0xfefd8000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xfefe8000-0xfeff1000   36864 vmalloc_exec+0x12/0x20 pages=8 vmalloc
0xfeffc000-0xff001000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff00b000-0xff00f000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff018000-0xff01c000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff026000-0xff02a000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff034000-0xff038000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff042000-0xff047000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff050000-0xff054000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff05d000-0xff061000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff06b000-0xff070000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff07e000-0xff085000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xff08e000-0xff092000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff09e000-0xff0a4000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff0ad000-0xff0b1000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff0bd000-0xff0c4000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xff0d0000-0xff0d6000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff0e0000-0xff0e4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff0f3000-0xff0fb000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xff105000-0xff10a000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff113000-0xff117000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff120000-0xff124000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff128000-0xff12a000    8192 ebt_register_table+0x7a/0x2d0 [ebtables] pages=1 vmalloc
0xff12b000-0xff12d000    8192 ebt_register_table+0x98/0x2d0 [ebtables] pages=1 vmalloc
0xff133000-0xff137000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff140000-0xff144000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff14f000-0xff154000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff15f000-0xff164000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff16f000-0xff174000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff17e000-0xff182000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff190000-0xff198000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xff1a1000-0xff1a5000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff1b2000-0xff1b9000   28672 vmalloc_exec+0x12/0x20 pages=6 vmalloc
0xff1c2000-0xff1c6000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff1d0000-0xff1d4000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff1df000-0xff1e4000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff1f0000-0xff1f6000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff1ff000-0xff203000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff21e000-0xff222000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff22e000-0xff234000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff240000-0xff245000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff250000-0xff256000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff260000-0xff265000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff270000-0xff275000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff27f000-0xff284000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff28e000-0xff292000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff29d000-0xff2a2000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff2ae000-0xff2b4000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff2c3000-0xff2cb000   32768 vmalloc_exec+0x12/0x20 pages=7 vmalloc
0xff2d7000-0xff2dd000   24576 vmalloc_exec+0x12/0x20 pages=5 vmalloc
0xff2e7000-0xff2eb000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff2f6000-0xff2fb000   20480 vmalloc_exec+0x12/0x20 pages=4 vmalloc
0xff322000-0xff326000   16384 vmalloc_exec+0x12/0x20 pages=3 vmalloc
0xff3c6000-0xff3c8000    8192 dm_vcalloc+0x2a/0x160 [dm_mod] pages=1 vmalloc

Finally, here's the data for the same box with the nVIDIA still set
in the BIOS as the primary display, but this time with the 2.6.25.4
kernel. Note that in this example the kernel options are slightly
different. The most notable difference being that CONFIG_AGP=y in the
2.6.25.4 kernel and CONFIG_AGP=n in the 2.6.28.2 kernel (because
CONFIG_AGP=y causes a panic when the i810 driver loads). I'll
investigate this later.

sh-3.1# uname -a
Linux cs3 2.6.25.4 #1 SMP Fri Nov 28 15:21:55 UTC 2008 i686 GNU/Linux
sh-3.1# mkswap /dev/mapper/vgmaster-dom0.swap.0000 
Setting up swapspace version 1, size = 4194300 KiB
no label, UUID=3d48f2d1-a362-4ea9-9a7b-375a26d491dc
sh-3.1# swapon /dev/mapper/vgmaster-dom0.swap.0000 
Adding 4194296k swap on /dev/mapper/vgmaster-dom0.swap.0000.  Priority:-1 extents:1 across:4194296k
sh-3.1# cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ce1ff : Video ROM
000ce200-000cffff : pnp 00:0c
000e0000-000effff : pnp 00:0c
000f0000-000fffff : System ROM
00100000-af5dffff : System RAM
  00100000-003a512c : Kernel code
  003a512d-004cf9db : Kernel data
  00525000-005b8f33 : Kernel bss
af5e0000-af5e2fff : ACPI Non-volatile Storage
af5e3000-af5effff : ACPI Tables
af5f0000-af5fffff : reserved
b0000000-bfffffff : PCI MMCONFIG 0
  b0000000-bfffffff : reserved
c0000000-cfffffff : PCI Bus #01
  c0000000-cfffffff : 0000:01:00.0
    c0000000-cfffffff : nvidiafb
d0000000-dfffffff : 0000:00:02.0
e0000000-e2ffffff : PCI Bus #01
  e0000000-e0ffffff : 0000:01:00.0
    e0000000-e0ffffff : nvidiafb
  e1000000-e1ffffff : 0000:01:00.0
    e1000000-e1ffffff : nvidiafb
e3000000-e3ffffff : PCI Bus #03
e4000000-e5ffffff : PCI Bus #04
  e5000000-e50003ff : 0000:04:00.0
    e5000000-e50003ff : tulip
e6000000-e60fffff : PCI Bus #03
  e6000000-e600ffff : 0000:03:00.0
  e6010000-e6010fff : 0000:03:00.0
e6100000-e61fffff : 0000:00:02.0
e6200000-e627ffff : 0000:00:02.0
e6280000-e6283fff : 0000:00:1b.0
e6284000-e62843ff : 0000:00:1d.7
  e6284000-e62843ff : ehci_hcd
e6285000-e6285fff : Intel Flush Page
fec00000-ffffffff : reserved
  fed00000-fed003ff : HPET 0
100000000-14fffffff : System RAM

Here's the .config file from the 2.6.25.4 kernel which works:

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25.4
# Fri Jan 16 23:30:30 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_DEFCONFIG_LIST="arch/x86/configs/i386_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
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
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CPUSETS=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_KMOD is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_PC is not set
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
CONFIG_X86_GENERICARCH=y
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
# CONFIG_VMI is not set
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_X86_CYCLONE_TIMER=y
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
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
# CONFIG_SPARSEMEM_STATIC is not set
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HIGHPTE=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_EFI=y
CONFIG_IRQBALANCE=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_ACPI_CPUFREQ_PROC_INTF=y
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

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
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=m
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
# CONFIG_IP6_NF_QUEUE is not set
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
# CONFIG_BRIDGE_EBT_ULOG is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RR=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=m
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
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
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=m
CONFIG_IDEDISK_MULTI_MODE=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=m
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=m
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=m
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_EMC is not set
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=m
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
# CONFIG_ELPLUS is not set
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
# CONFIG_3C515 is not set
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
# CONFIG_DE4X5 is not set
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=m
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=m
# CONFIG_R8169_NAPI is not set
CONFIG_R8169_VLAN=y
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E_MAYBE is not set
# CONFIG_ATM_HE is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_HVC_XEN=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=m
CONFIG_RTC=m
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

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
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_IMAC is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

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
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_RTCTIMER=m
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_DUMMY=m
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_PORTMAN2X4 is not set

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_MON=y

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP2101=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
CONFIG_USB_SERIAL_SAFE_PADDED=y
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
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# Conflicting RTC option has been selected, check GEN_RTC and RTC
#

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_S35390A=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EFI_VARS=m
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=m
CONFIG_EXT4DEV_FS_XATTR=y
CONFIG_EXT4DEV_FS_POSIX_ACL=y
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_SECURITY=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_NOLOCK=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_4KSTACKS is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

I hope this makes sense.

Yours sincerely,

Larry.
