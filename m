Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbZEWU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbZEWU6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 16:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZEWU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 16:58:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:51369 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZEWU6B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 16:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=WiIg2HIMdth398U+kbXLrE8UDwWPN7ZlyneSMkpYtMyJ69aP7m8sFi/YLavo5/tOAf
         9u0coz11gRFayWLrC4Iy/lRTRFXRuzj0PIks43LvNqs1O/akM0hjyXh9OQgBck0gfnlE
         8FuuCQHCz0re+HVJQ253R46Dh75cqw0zqk0MA=
MIME-Version: 1.0
Date: Sat, 23 May 2009 22:58:00 +0200
Message-ID: <c384c5ea0905231358t4803fbc6gf54618b2839a448a@mail.gmail.com>
Subject: mpc8315e-rdb: pci_enable_msi() fails (using today's galak/powerpc.git 
	tree)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Linux PPC <linuxppc-dev@ozlabs.org>, linuxppc-embedded@ozlabs.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

using this tree: git://git.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git

pci_enable_msi() fails on my MPC8315E-RDB board with PCIe device in
the PCIe x1 slot.

Log (with some fsl_{msi|pci}.c DEBUG enabled) and config included.

Last known working is the 2.6.24.3 kernel with Freescale patches from
the BSP, such as:
http://www.bitshrine.org/gpp/linux-fsl-2.6.24.3-MPC8315ERDB-pcie-INTx-support.patch


What can I do to help find the problem?


Regards,

Leon.


[    0.000000] Using MPC831x RDB machine description
[    0.000000] Linux version 2.6.30-rc6 (leon@witty) (gcc version
4.2.4) #3 PREEMPT Sat May 23 22:35:58 CEST 2009
[    0.000000] Found legacy serial port 0 for /immr@e0000000/serial@4500
[    0.000000]   mem=e0004500, taddr=e0004500, irq=0, clk=133333333, speed=0
[    0.000000] Found legacy serial port 1 for /immr@e0000000/serial@4600
[    0.000000]   mem=e0004600, taddr=e0004600, irq=0, clk=133333333, speed=0
[    0.000000] console [udbg0] enabled
[    0.000000] Found FSL PCI host bridge at 0x00000000e0008500.
Firmware bus number: 0->0
[    0.000000] PCI host bridge /pci@e0008500 (primary) ranges:
[    0.000000]  MEM 0x0000000090000000..0x000000009fffffff ->
0x0000000090000000
[    0.000000]  MEM 0x0000000080000000..0x000000008fffffff ->
0x0000000080000000 Prefetch
[    0.000000]   IO 0x00000000e0300000..0x00000000e03fffff -> 0x0000000000000000
[    0.000000] No pci config register base in dev tree, using default
[    0.000000] Found FSL PCI host bridge at 0x00000000e0009000.
Firmware bus number: 0->255
[    0.000000] PCI host bridge /pcie@e0009000  ranges:
[    0.000000]  MEM 0x00000000a0000000..0x00000000afffffff ->
0x00000000a0000000
[    0.000000]   IO 0x00000000b1000000..0x00000000b17fffff -> 0x0000000000000000
[    0.000000] No pci config register base in dev tree, using default
[    0.000000] Found FSL PCI host bridge at 0x00000000e000a000.
Firmware bus number: 0->255
[    0.000000] PCI host bridge /pcie@e000a000  ranges:
[    0.000000]  MEM 0x00000000c0000000..0x00000000cfffffff ->
0x00000000c0000000
[    0.000000]   IO 0x00000000d1000000..0x00000000d17fffff -> 0x0000000000000000
[    0.000000] Top of RAM: 0x8000000, Total RAM: 0x8000000
[    0.000000] Memory hole size: 0MB
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00008000
[    0.000000]   Normal   0x00008000 -> 0x00008000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00008000
[    0.000000] On node 0 totalpages: 32768
[    0.000000] free_area_init_node: node 0, pgdat c04a4594,
node_mem_map c053c000
[    0.000000]   DMA zone: 256 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 32512 pages, LIFO batch:7
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 32512
[    0.000000] Kernel command line: root=/dev/nfs rw
nfsroot=192.168.1.24:/nfsroot/mpc8315e
ip=192.168.1.15:192.168.1.24::::eth0:off console=ttyS0,115200n8
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] IPIC (128 IRQ sources) at fcef8700
[    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
[    0.000000] time_init: decrementer frequency = 33.333333 MHz
[    0.000000] time_init: processor frequency   = 400.000002 MHz
[    0.000000] clocksource: timebase mult[7800001] shift[22] registered
[    0.000000] clockevent: decrementer mult[888] shift[16] cpu[0]
[  131.166261] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[  132.414608] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[  133.657038] Memory: 124400k/131072k available (4576k kernel code,
6508k reserved, 192k data, 524k bss, 200k init)
[  135.291237] Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
[  136.538105] Mount-cache hash table entries: 512
[  137.523999] net_namespace: 984 bytes
[  138.395916] NET: Registered protocol family 16
[  139.995483] irq: irq 38 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 38
[  141.462012] PCI: Probing PCI hardware
[  142.343760] PCI: Scanning bus 0000:00
[  143.225023] pci 0000:00:00.0: found [1957:00b4] class 000b20 header type 00
[  144.482481] pci 0000:00:00.0: calling pmac_pci_fixup_pciata+0x0/0x1e0
[  145.680512] pci 0000:00:00.0: reg 10 32bit mmio: [0x000000-0x0fffff]
[  146.868657] pci 0000:00:00.0: reg 18 64bit mmio: [0x000000-0x7ffffff]
[  148.066713] pci 0000:00:00.0: calling fixup_hide_host_resource_fsl+0x0/0x68
[  149.324147] pci 0000:00:00.0: calling pcibios_fixup_resources+0x0/0xe4
[  150.532088] pci 0000:00:00.0: calling quirk_fsl_pcie_header+0x0/0x50
[  151.720232] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1b0
[  152.947968] pci 0000:00:00.0: supports D1 D2
[  153.898474] pci 0000:00:00.0: PME# supported from D0 D1 D2 D3hot
[  155.047028] pci 0000:00:00.0: PME# disabled
[  155.987691] PCI: Fixups for bus 0000:00
[  156.888759] PCI: Bus scan for 0000:00 returning with max=00
[  157.988933] PCI: Scanning bus 0001:01
[  158.870181] PCI: Fixups for bus 0001:01
[  159.771178] PCI: Bus scan for 0001:01 returning with max=01
[  160.870716] PCI: Scanning bus 0002:02
[  161.751977] pci 0002:02:00.0: found [1957:00b4] class 000b20 header type 01
[  163.009432] pci 0002:02:00.0: calling pmac_pci_fixup_pciata+0x0/0x1e0
[  164.207447] pci 0002:02:00.0: ignoring class b20 (doesn't match
header type 01)
[  165.504480] pci 0002:02:00.0: calling fixup_hide_host_resource_fsl+0x0/0x68
[  166.761906] pci 0002:02:00.0: calling pcibios_fixup_resources+0x0/0xe4
[  167.969878] pci 0002:02:00.0: calling quirk_fsl_pcie_header+0x0/0x50
[  169.158024] pci 0002:02:00.0: calling quirk_resource_alignment+0x0/0x1b0
[  170.385753] pci 0002:02:00.0: supports D1 D2
[  171.336256] pci 0002:02:00.0: PME# supported from D0 D1 D2 D3hot
[  172.484787] pci 0002:02:00.0: PME# disabled
[  173.425437] PCI: Fixups for bus 0002:02
[  174.326455] pci 0002:02:00.0: scanning behind bridge, config ff0100, pass 0
[  175.583864] pci 0002:02:00.0: bus configuration invalid, reconfiguring
[  176.791782] pci 0002:02:00.0: scanning behind bridge, config 000000, pass 1
[  178.049218] PCI: Scanning bus 0002:03
[  178.930470] pci 0002:03:00.0: found [1172:0004] class 00ff00 header type 00
[  180.187928] pci 0002:03:00.0: calling pmac_pci_fixup_pciata+0x0/0x1e0
[  181.385968] pci 0002:03:00.0: reg 10 32bit mmio: [0x000000-0x007fff]
[  182.574135] pci 0002:03:00.0: calling pcibios_fixup_resources+0x0/0xe4
[  183.782066] pci 0002:03:00.0: calling quirk_resource_alignment+0x0/0x1b0
[  185.009869] PCI: Fixups for bus 0002:03
[  185.910880] pci 0002:02:00.0: bridge io port: [0x00-0xfff]
[  186.999988] pci 0002:02:00.0: bridge 32bit mmio: [0x000000-0x0fffff]
[  188.188099] pci 0002:02:00.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[  189.425795] irq: irq 2 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 16
[  190.881221] PCI: Bus scan for 0002:03 returning with max=03
[  191.980227] PCI: Bus scan for 0002:02 returning with max=03
[  193.081000] pci 0002:03:00.0: BAR 0: got res
[0xc0000000-0xc0007fff] bus [0xc0000000-0xc0007fff] flags 0x20020200
[  194.714659] pci 0002:03:00.0: BAR 0: moved to bus
[0xc0000000-0xc0007fff] flags 0x20200
[  196.090880] pci 0002:02:00.0: PCI bridge, secondary bus 0002:03
[  197.229482] pci 0002:02:00.0:   IO window: disabled
[  198.249295] pci 0002:02:00.0:   MEM window: 0xc0000000-0xc00fffff
[  199.407704] pci 0002:02:00.0:   PREFETCH window: disabled
[  200.486937] pci_bus 0000:00: resource 0 io:  [0x00-0xfffff]
[  201.585955] pci_bus 0000:00: resource 1 mem: [0x90000000-0x9fffffff]
[  202.774071] pci_bus 0000:00: resource 2 pref mem [0x80000000-0x8fffffff]
[  204.001788] pci_bus 0001:01: resource 0 io:  [0xff7fe000-0xffffdfff]
[  205.189903] pci_bus 0001:01: resource 1 mem: [0xa0000000-0xafffffff]
[  206.378019] pci_bus 0002:02: resource 0 io:  [0xfeffc000-0xff7fbfff]
[  207.566179] pci_bus 0002:02: resource 1 mem: [0xc0000000-0xcfffffff]
[  208.754307] pci_bus 0002:03: resource 0 mem: [0xfeffc000-0xfeffcfff]
[  209.942424] pci_bus 0002:03: resource 1 mem: [0xc0000000-0xc00fffff]
[  211.130539] pci_bus 0002:03: resource 2 mem: [0x0-0xfffff]
[  212.220104] Registering ipic with sysfs...
[  213.176198] bio: create slab <bio-0> at 0
[  214.099863] SCSI subsystem initialized
[  214.993768] usbcore: registered new interface driver usbfs
[  216.083850] usbcore: registered new interface driver hub
[  217.153875] usbcore: registered new device driver usb
[  218.434816] cfg80211: Using static regulatory domain info
[  219.514038] cfg80211: Regulatory domain: US
[  220.454634] 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  221.741749] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[  222.979361] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  224.216971] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  225.454581] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  226.692191] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[  227.929802] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[  229.167613] cfg80211: Calling CRDA for country: US
[  230.181603] Switched to high resolution mode on CPU 0
[  231.223517] NET: Registered protocol family 2
[  232.317839] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[  233.566079] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[  234.833770] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[  236.031990] TCP: Hash tables configured (established 4096 bind 4096)
[  237.220162] TCP reno registered
[  238.089874] NET: Registered protocol family 1
[  239.050852] irq: irq 9 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 17
[  240.506421] irq: irq 10 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 18
[  241.979286] irq: irq 20 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 20
[  243.444750] irq: irq 19 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 19
[  244.919702] Freescale PowerQUICC MII Bus: probed
[  245.912402] Freescale PowerQUICC MII Bus: probed
[  246.910002] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[  248.039400] JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
[  249.189859] msgmni has been set to 243
[  250.082849] alg: No test for stdrng (krng)
[  251.013757] io scheduler noop registered
[  251.924970] io scheduler cfq registered (default)
[  252.925095] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x54
[  254.103409] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x450
[  255.321312] pci 0002:02:00.0: calling quirk_cardbus_legacy+0x0/0x54
[  256.499634] pci 0002:02:00.0: calling quirk_usb_early_handoff+0x0/0x450
[  257.717554] pci 0002:03:00.0: calling quirk_cardbus_legacy+0x0/0x54
[  258.895844] pci 0002:03:00.0: calling quirk_usb_early_handoff+0x0/0x450
[  260.522958] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[  261.717360] serial8250.0: ttyS0 at MMIO 0xe0004500 (irq = 17) is a 16550A
[  262.955247] console handover: boot [udbg0] -> real [ttyS0]
[  264.046878] serial8250.0: ttyS1 at MMIO 0xe0004600 (irq = 18) is a 16550A
[  264.074357] brd: module loaded
[  264.086847] loop: module loaded
[  264.091969] Driver 'sd' needs updating - please use bus_type methods
[  264.099362] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[  264.105868] Copyright (c) 1999-2006 Intel Corporation.
[  264.111602] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[  264.118006] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[  264.124677] irq: irq 32 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 32
[  264.133609] irq: irq 33 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 33
[  264.142689] irq: irq 34 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 34
[  264.152554] eth0: Gianfar Ethernet Controller Version 1.2, 00:00:00:00:00:00
[  264.159666] eth0: Running with NAPI enabled
[  264.163900] eth0: 256/256 RX/TX BD ring size
[  264.168498] irq: irq 35 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 35
[  264.177389] irq: irq 36 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 36
[  264.186268] irq: irq 37 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 37
[  264.196160] eth1: Gianfar Ethernet Controller Version 1.2, 00:00:00:00:00:00
[  264.203334] eth1: Running with NAPI enabled
[  264.207571] eth1: 256/256 RX/TX BD ring size
[  264.212373] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[  264.218524] e100: Copyright(c) 1999-2006 Intel Corporation
[  264.227106] irq: irq 16 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 21
[  264.236744] e0007000.spi: MPC83xx SPI Controller driver at
0xc906c000 (irq = 21)
[  264.246146] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[  264.252827] fsl-ehci fsl-ehci.0: Freescale On-Chip EHCI Host Controller
[  264.261005] fsl-ehci fsl-ehci.0: new USB bus registered, assigned
bus number 1
[  264.289676] fsl-ehci fsl-ehci.0: irq 38, io base 0xe0023000
[  264.305621] fsl-ehci fsl-ehci.0: USB 2.0 started, EHCI 1.00
[  264.312344] usb usb1: configuration #1 chosen from 1 choice
[  264.318634] hub 1-0:1.0: USB hub found
[  264.322536] hub 1-0:1.0: 1 port detected
[  264.330939] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[  264.338294] uhci_hcd: USB Universal Host Controller Interface driver
[  264.345300] Initializing USB Mass Storage driver...
[  264.350837] usbcore: registered new interface driver usb-storage
[  264.356919] USB Mass Storage support registered.
[  264.362090] i2c /dev entries driver
[  264.367264] irq: irq 14 on host
/immr@e0000000/interrupt-controller@700 mapped to virtual irq 22
[  264.384255] rtc-ds1307 0-0068: rtc core: registered ds1339 as rtc0
[  264.392159] Driver for 1-wire Dallas network protocol.
[  264.399668] TCP cubic registered
[  264.403023] NET: Registered protocol family 17
[  264.408081] RPC: Registered udp transport module.
[  264.412851] RPC: Registered tcp transport module.
[  264.422923] rtc-ds1307 0-0068: setting system clock to 2009-05-23
22:33:47 UTC (1243118027)
[  264.641654] usb 1-1: new high speed USB device using fsl-ehci and address 2
[  264.780509] usb 1-1: configuration #1 chosen from 1 choice
[  264.786991] hub 1-1:1.0: USB hub found
[  264.791238] hub 1-1:1.0: 4 ports detected
[  265.937627] IP-Config: Guessing netmask 255.255.255.0
[  265.943020] IP-Config: Complete:
[  265.946134]      device=eth0, addr=192.168.1.15,
mask=255.255.255.0, gw=255.255.255.255,
[  265.954325]      host=192.168.1.15, domain=, nis-domain=(none),
[  265.960280]      bootserver=192.168.1.24, rootserver=192.168.1.24, rootpath=
[  265.967964] Looking up port of RPC 100003/2 on 192.168.1.24
[  266.934444] PHY: mdio@e0024520:00 - Link is Up - 1000/Full
[  266.985418] Looking up port of RPC 100005/1 on 192.168.1.24
[  267.050384] VFS: Mounted root (nfs filesystem) on device 0:13.
[  267.056526] Freeing unused kernel memory: 200k init
[  319.199280]
[  319.200782] altpciesgdma init(), built May 23 2009 21:46:23
[  319.207458] probe(dev = 0xc7811000, pciid = 0xc90c2374)
[  319.213317] probe() ape = 0xc798b1a0
[  319.217511] pci_enable_device()
[  319.221303] altpciesgdma 0002:03:00.0: enabling device (0000 -> 0002)
[  319.228370] pci_set_master()
[  319.231885] altpciesgdma 0002:03:00.0: enabling bus mastering

[  319.238269] pci_enable_msi()
[  319.241171] Could not enable MSI interrupting, rc = -38.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[  319.247476] pci_read_config_byte(..., PCI_REVISION_ID, ...)
[  319.253838] Board revision: 0x01.
[  319.257151] pci_request_regions()
[  319.261491] pci_set_dma_mask()
[  319.265169] Using a 64-bit DMA mask.
[  319.269370] pci_read_config_byte(..., PCI_INTERRUPT_PIN, ...)
[  319.275757] IRQ pin #1 (0=none, 1=INTA#...4=INTD#).
[  319.281272] IRQ line #0.
[  319.284425] request_irq()
[  319.287738] Succesfully requested IRQ #16 with dev_id 0xc798b1a0
[  319.294379] BAR0 0x00000000c0000000-0x00000000c0007fff flags 0x00020200
[  319.301737] BAR[0] mapped at 0xc90d0000 with length  32768(/32768).
[  319.308632] About to perform ioread32(0xc90d0400).
[  319.314127] 1: Address 0xc90d0400 reads data 0x40004d47.
[  319.320056] About to perform ioread32(0xc90d040c).
[  319.325482] 1: Address 0xc90d040c (perf_counter) reads data 0x00000000.
[  319.332718] About to perform ioread32(0xc90d0404).
[  319.338174] 1: Address 0xc90d0404 (counter) reads data 0x00000000.
[  319.344972] datagenerator_test() = 0.
[  319.351052] altpciesgdma sg_init()
[  319.355214] altpciesgdma = 251:0
[  319.359064] probe() successful.


#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc6
# Sat May 23 21:01:36 2009
#
# CONFIG_PPC64 is not set

#
# Processor support
#
CONFIG_6xx=y
# CONFIG_PPC_85xx is not set
# CONFIG_PPC_8xx is not set
# CONFIG_40x is not set
# CONFIG_44x is not set
# CONFIG_E200 is not set
CONFIG_PPC_BOOK3S=y
CONFIG_PPC_FPU=y
# CONFIG_FSL_EMB_PERFMON is not set
# CONFIG_ALTIVEC is not set
CONFIG_PPC_STD_MMU=y
CONFIG_PPC_STD_MMU_32=y
# CONFIG_PPC_MM_SLICES is not set
# CONFIG_SMP is not set
CONFIG_PPC32=y
CONFIG_WORD_SIZE=32
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_MMU=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_HARDIRQS=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
CONFIG_IRQ_PER_CPU=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
# CONFIG_ARCH_NO_VIRT_TO_BUS is not set
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_NVRAM=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_OF=y
CONFIG_PPC_UDBG_16550=y
# CONFIG_GENERIC_TBSYNC is not set
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
CONFIG_DTC=y
CONFIG_DEFAULT_UIMAGE=y
CONFIG_HIBERNATE_32=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_PREEMPT_RCU_TRACE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=18
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EMBEDDED=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
# CONFIG_SLOW_WORK is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
# CONFIG_FREEZER is not set
CONFIG_PPC_MSI_BITMAP=y

#
# Platform support
#
CONFIG_PPC_CHRP=y
# CONFIG_MPC5121_ADS is not set
# CONFIG_MPC5121_GENERIC is not set
# CONFIG_PPC_MPC52xx is not set
CONFIG_PPC_PMAC=y
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PPC_82xx is not set
# CONFIG_PQ2ADS is not set
CONFIG_PPC_83xx=y
CONFIG_MPC831x_RDB=y
# CONFIG_MPC832x_MDS is not set
# CONFIG_MPC832x_RDB is not set
# CONFIG_MPC834x_MDS is not set
# CONFIG_MPC834x_ITX is not set
# CONFIG_MPC836x_MDS is not set
# CONFIG_MPC836x_RDK is not set
# CONFIG_MPC837x_MDS is not set
# CONFIG_MPC837x_RDB is not set
# CONFIG_SBC834x is not set
# CONFIG_ASP834x is not set
CONFIG_PPC_MPC831x=y
# CONFIG_PPC_86xx is not set
# CONFIG_EMBEDDED6xx is not set
# CONFIG_AMIGAONE is not set
CONFIG_PPC_NATIVE=y
CONFIG_PPC_OF_BOOT_TRAMPOLINE=y
# CONFIG_UDBG_RTAS_CONSOLE is not set
CONFIG_IPIC=y
CONFIG_MPIC=y
# CONFIG_MPIC_WEIRD is not set
CONFIG_PPC_I8259=y
CONFIG_PPC_RTAS=y
# CONFIG_RTAS_ERROR_LOGGING is not set
CONFIG_RTAS_PROC=y
# CONFIG_MMIO_NVRAM is not set
CONFIG_PPC_MPC106=y
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_INDIRECT_IO is not set
# CONFIG_GENERIC_IOMAP is not set
# CONFIG_CPU_FREQ is not set
# CONFIG_PPC601_SYNC_FIX is not set
# CONFIG_TAU is not set
# CONFIG_QUICC_ENGINE is not set
# CONFIG_FSL_ULI1575 is not set
# CONFIG_MPC8xxx_GPIO is not set
# CONFIG_SIMPLE_GPIO is not set
# CONFIG_MCU_MPC8349EMITX is not set

#
# Kernel options
#
# CONFIG_HIGHMEM is not set
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_PPC_4K_PAGES=y
# CONFIG_PPC_16K_PAGES is not set
# CONFIG_PPC_64K_PAGES is not set
# CONFIG_PPC_256K_PAGES is not set
CONFIG_FORCE_MAX_ZONEORDER=11
CONFIG_PROC_DEVICETREE=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
# CONFIG_PM is not set
# CONFIG_SECCOMP is not set
CONFIG_ISA_DMA_API=y

#
# Bus options
#
# CONFIG_ISA is not set
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_PPC_INDIRECT_PCI=y
CONFIG_FSL_SOC=y
CONFIG_FSL_PCI=y
CONFIG_PPC_PCI_CHOICE=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_HAS_RAPIDIO is not set

#
# Advanced setup
#
CONFIG_ADVANCED_OPTIONS=y
# CONFIG_LOWMEM_SIZE_BOOL is not set
CONFIG_LOWMEM_SIZE=0x30000000
# CONFIG_PAGE_OFFSET_BOOL is not set
CONFIG_PAGE_OFFSET=0xc0000000
# CONFIG_KERNEL_START_BOOL is not set
CONFIG_KERNEL_START=0xc0000000
CONFIG_PHYSICAL_START=0x00000000
# CONFIG_TASK_SIZE_BOOL is not set
CONFIG_TASK_SIZE=0xc0000000
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
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
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
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
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
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
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
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
# CONFIG_NET_CLS_FLOW is not set
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
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
# CONFIG_MAC80211_RC_PID is not set
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
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
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
# CONFIG_MTD_NAND_FSL_ELBC is not set
# CONFIG_MTD_NAND_FSL_UPM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
# CONFIG_MTD_UBI is not set
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_SPI=y
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_MAC_FLOPPY is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32768
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_93CX6=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
# CONFIG_IFB is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_MACE is not set
# CONFIG_BMAC is not set
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_ENC28J60 is not set
# CONFIG_ETHOC is not set
# CONFIG_DNET is not set
# CONFIG_NET_TULIP is not set
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
CONFIG_FSL_PQ_MDIO=y
CONFIG_GIANFAR=y
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
CONFIG_NETDEV_10000=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3_DEPENDS=y
# CONFIG_CHELSIO_T3 is not set
# CONFIG_ENIC is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NIU is not set
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
# CONFIG_BNX2X is not set
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
# CONFIG_BE2NET is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
# CONFIG_LIBERTAS_SDIO is not set
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
# CONFIG_AT76C50X_USB is not set
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
CONFIG_RTL8187=m
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
# CONFIG_RT2X00 is not set
CONFIG_HERMES=m
CONFIG_HERMES_CACHE_FW_ON_INIT=y
# CONFIG_APPLE_AIRPORT is not set
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOL2TP=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
# CONFIG_INPUT_KEYBOARD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
# CONFIG_SERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_PMACZILOG is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_BRIQ_PANEL is not set
CONFIG_ALTPCIESGDMA=m
# CONFIG_ALTPCIECHDMA is not set
# CONFIG_HVC_RTAS is not set
# CONFIG_HVC_UDBG is not set
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# Mac SMBus host controller drivers
#
# CONFIG_I2C_HYDRA is not set
CONFIG_I2C_POWERMAC=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_MPC=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_MPC83xx=y

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
# CONFIG_SPI_TLE62X0 is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_AMS is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_LIS3_SPI is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_THERMAL is not set
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_8xxx_WDT is not set
# CONFIG_WATCHDOG_RTAS is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set
# CONFIG_SOUND is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set

#
# Special HID drivers
#
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_FSL=y
CONFIG_USB_EHCI_HCD_PPC_OF=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PPC_OF=y
CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
# CONFIG_USB_OHCI_HCD_PPC_OF_LE is not set
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_BIG_ENDIAN_DESC=y
CONFIG_USB_OHCI_BIG_ENDIAN_MMIO=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_GENERIC is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_SMX is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_STAGING is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=1
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_ROOT_NFS=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
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
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
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
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
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
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_HAVE_LMB=y
CONFIG_NLATTR=y

#
# Kernel hacking
#
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_EVENT_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_PRINT_STACK_DEPTH=64
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_CODE_PATCHING_SELFTEST is not set
# CONFIG_FTR_FIXUP_SELFTEST is not set
# CONFIG_MSI_BITMAP_SELFTEST is not set
# CONFIG_XMON is not set
# CONFIG_IRQSTACKS is not set
CONFIG_VIRQ_DEBUG=y
# CONFIG_BDI_SWITCH is not set
# CONFIG_BOOTX_TEXT is not set
CONFIG_PPC_EARLY_DEBUG=y
# CONFIG_PPC_EARLY_DEBUG_LPAR is not set
# CONFIG_PPC_EARLY_DEBUG_G5 is not set
CONFIG_PPC_EARLY_DEBUG_RTAS_PANEL=y
# CONFIG_PPC_EARLY_DEBUG_RTAS_CONSOLE is not set
# CONFIG_PPC_EARLY_DEBUG_MAPLE is not set
# CONFIG_PPC_EARLY_DEBUG_ISERIES is not set
# CONFIG_PPC_EARLY_DEBUG_PAS_REALMODE is not set
# CONFIG_PPC_EARLY_DEBUG_BEAT is not set
# CONFIG_PPC_EARLY_DEBUG_44x is not set
# CONFIG_PPC_EARLY_DEBUG_40x is not set
# CONFIG_PPC_EARLY_DEBUG_CPM is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_TALITOS is not set
# CONFIG_PPC_CLOCK is not set
# CONFIG_VIRTUALIZATION is not set

-- 
Leon
