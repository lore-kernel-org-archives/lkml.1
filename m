Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXKGObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXKGObU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbXKGObM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:31:12 -0500
Received: from mailgw.infracomspa.it ([217.12.183.244]:1669 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757866AbXKGObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:31:10 -0500
X-Greylist: delayed 943 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Nov 2007 09:31:09 EST
Message-ID: <4731C86B.1040704@infracomspa.it>
Date: Wed, 07 Nov 2007 15:15:07 +0100
From: Roberto Oppedisano <roppedisano@infracomspa.it>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 11/07/2007 03:15:20 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 07/11/2007 15.31.09,
	Serialize complete at 07/11/2007 15.31.09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I noticed that after suspending to ram the DVD-ROM/CDRW
drive in no more recognized on my laptop. Looking at dmesg
after suspend i found:

[    5.313446] ata2.00: _GTF unexpected object type 0x1
[    5.313453] ata2.00: ACPI on devcfg failed the second time, disabling 
(errno=-22)
[    5.313457] ata2.00: revalidation failed (errno=1)
[    5.313459] ata2.00: disabled


Not sure when the bug was introduced or if it has been always been there
(but I can investigate if needed).

More details on request.

Following dmesg pre and after suspend.

Kind regards
R.


- pre suspend

roppedisano@poppero1:~$ dmesg
3700] io scheduler noop registered
[   11.443745] io scheduler anticipatory registered (default)
[   11.443792] io scheduler deadline registered
[   11.443896] io scheduler cfq registered
[   11.444006] Boot video device is 0000:01:00.0
[   11.464741] Real Time Clock Driver v1.12ac
[   11.464794] Linux agpgart interface v0.102
[   11.464880] agpgart: Detected an Intel 855PM Chipset.
[   11.479558] agpgart: AGP aperture is 256M @ 0xb0000000
[   11.479673] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   11.479723] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   11.479888] ata_piix 0000:00:1f.1: version 2.12
[   11.479901] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   11.479955] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [C0C4] -> GSI 
5 (level, low) -> IRQ 5
[   11.480114] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   11.480185] scsi0 : ata_piix
[   11.480282] scsi1 : ata_piix
[   11.480425] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x4c40 
irq 14
[   11.480475] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x4c48 
irq 15
[   11.671876] ata1.00: ATA-7: WDC WD1000UE-00KVT0, 01.03K01, max UDMA/100
[   11.671926] ata1.00: 195371568 sectors, multi 16: LBA48
[   11.675442] ata1.00: configured for UDMA/100
[   11.924993] Switched to high resolution mode on CPU 0
[   12.052537] ata2.00: ATAPI: SD-R2512, 1A04, max MWDMA2
[   12.228484] ata2.00: configured for MWDMA2
[   12.229348] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1000UE-00K 
01.0 PQ: 0 ANSI: 5
[   12.229506] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors 
(100030 MB)
[   12.229565] sd 0:0:0:0: [sda] Write Protect is off
[   12.229613] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.229627] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   12.229726] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors 
(100030 MB)
[   12.229781] sd 0:0:0:0: [sda] Write Protect is off
[   12.229828] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   12.229841] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   12.229902]  sda: sda1 sda2 < sda5 sda6 >
[   12.302219] sd 0:0:0:0: [sda] Attached SCSI disk
[   12.307592] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-R2512 
1A04 PQ: 0 ANSI: 5
[   12.307853] PNP: PS/2 Controller [PNP0303:C1A3,PNP0f13:C1A4] at 
0x60,0x64 irq 1,12
[   12.317941] i8042.c: Detected active multiplexing controller, rev 1.1.
[   12.323459] serio: i8042 KBD port at 0x60,0x64 irq 1
[   12.323542] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[   12.323590] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[   12.323638] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[   12.323685] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[   12.323933] mice: PS/2 mouse device common for all mice
[   12.346985] input: AT Translated Set 2 keyboard as /class/input/input0
[   12.360775] cpuidle: using governor ladder
[   12.360821] cpuidle: using governor menu
[   12.360951] TCP cubic registered
[   12.361002] NET: Registered protocol family 1
[   12.361059] NET: Registered protocol family 17
[   12.361107] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   12.361156] ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
[   12.361226] ieee80211_crypt: registered algorithm 'NULL'
[   12.361230] Using IPI Shortcut mode
[   13.038080] Synaptics Touchpad, model: 1, fw: 5.9, id: 0x236eb3, 
caps: 0x904713/0x10008
[   13.089011] input: SynPS/2 Synaptics TouchPad as /class/input/input1
[   13.223554] kjournald starting.  Commit interval 5 seconds
[   13.223608] EXT3-fs: mounted filesystem with ordered data mode.
[   13.223661] VFS: Mounted root (ext3 filesystem) readonly.
[   13.223809] Freeing unused kernel memory: 152k freed
[   16.737952] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   16.738035] Uniform CD-ROM driver Revision: 3.20
[   16.738133] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   16.815873] usbcore: registered new interface driver usbfs
[   16.815949] usbcore: registered new interface driver hub
[   16.817658] usbcore: registered new device driver usb
[   16.859293] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.859368] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   16.872367] ACPI: PCI Interrupt Link [C0C3] enabled at IRQ 10
[   16.872420] PCI: setting IRQ 10 as level-triggered
[   16.872424] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   16.872554] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   17.025230] input: Power Button (FF) as /class/input/input2
[   17.030684] ACPI: Power Button (FF) [PWRF]
[   17.030813] input: Power Button (CM) as /class/input/input3
[   17.037689] ACPI: Power Button (CM) [C1BE]
[   17.037783] input: Lid Switch as /class/input/input4
[   17.041787] ACPI: Lid Switch [C136]
[   17.046878] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   17.047050] ACPI: Processor [CPU0] (supports 8 throttling states)
[   17.096295] USB Universal Host Controller Interface driver v3.0
[   17.097066] ACPI: PCI Interrupt Link [C0C2] enabled at IRQ 10
[   17.097116] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[   17.097247] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.097251] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.097566] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 1
[   17.097647] uhci_hcd 0000:00:1d.0: irq 10, io base 0x000048c0
[   17.097849] usb usb1: configuration #1 chosen from 1 choice
[   17.097927] hub 1-0:1.0: USB hub found
[   17.097978] hub 1-0:1.0: 2 ports detected
[   17.199123] ACPI: PCI Interrupt Link [C0C5] enabled at IRQ 5
[   17.199179] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [C0C5] -> GSI 
5 (level, low) -> IRQ 5
[   17.199309] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.199314] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.199386] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 2
[   17.199467] uhci_hcd 0000:00:1d.1: irq 5, io base 0x000048e0
[   17.199626] usb usb2: configuration #1 chosen from 1 choice
[   17.199712] hub 2-0:1.0: USB hub found
[   17.199762] hub 2-0:1.0: 2 ports detected
[   17.300845] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [C0C4] -> GSI 
5 (level, low) -> IRQ 5
[   17.300984] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   17.300988] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.301058] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 3
[   17.301138] uhci_hcd 0000:00:1d.2: irq 5, io base 0x00004c00
[   17.301302] usb usb3: configuration #1 chosen from 1 choice
[   17.301378] hub 3-0:1.0: USB hub found
[   17.301427] hub 3-0:1.0: 2 ports detected
[   17.313015] ACPI: AC Adapter [C134] (on-line)
[   17.322009] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
[   17.356141] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 
1.2.2kmprq
[   17.356387] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   17.384259] ACPI: Battery Slot [C11F] (battery present)
[   17.384567] input: Video Bus as /class/input/input5
[   17.391776] ACPI: Video Device [C0D0] (multi-head: yes  rom: no  
post: no)
[   17.402197] ACPI: PCI Interrupt Link [C0C9] enabled at IRQ 5
[   17.402251] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [C0C9] -> GSI 
5 (level, low) -> IRQ 5
[   17.402384] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   17.402388] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.402460] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 4
[   17.406415] ehci_hcd 0000:00:1d.7: debug port 1
[   17.406465] PCI: cache line size of 32 is not supported by device 
0000:00:1d.7
[   17.406473] ehci_hcd 0000:00:1d.7: irq 5, io mem 0xa0000000
[   17.409711] usb 1-1: new full speed USB device using uhci_hcd and 
address 2
[   17.411845] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[   17.412005] usb usb4: configuration #1 chosen from 1 choice
[   17.412079] hub 4-0:1.0: USB hub found
[   17.412128] hub 4-0:1.0: 6 ports detected
[   17.473565] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   17.473621] wbsd: Copyright(c) Pierre Ossman
[   17.474374] wbsd 00:02: activated
[   17.479535] mmc0: W83L51xD id 7112 at 0x248 irq 6 dma 0 PnP
[   17.512862] ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   17.513474] eth0: RTL-8139C+ at 0xf8830000, 00:0f:b0:0e:de:a8, IRQ 10
[   17.513614] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [C0C5] -> GSI 
5 (level, low) -> IRQ 5
[   17.519105] NET: Registered protocol family 23
[   17.521512] ipw2200: Detected Intel PRO/Wireless 2200BG Network 
Connection
[   17.535301] Detected unconfigured Compaq x1000 family SMSC IrDA chip, 
pre-configuring device.
[   17.535367] Setting up Intel 82801 controller and SMSC device
[   17.535537] found SMC SuperIO Chip (devid=0x5a rev=00 base=0x002e): 
LPC47N227
[   17.535600] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, 
irq: 7, mode: 0x0e
[   17.535670] SMsC IrDA Controller found
[   17.535671]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3, irq=7
[   17.535831] No transceiver found. Defaulting to Fast pin select
[   17.635719] Marking TSC unstable due to: TSC halts in idle.
[   17.635781] Time: acpi_pm clocksource has been installed.
[   17.783728] usb 4-1: new high speed USB device using ehci_hcd and 
address 2
[   17.899592] usb 4-1: configuration #1 chosen from 1 choice
[   17.934233] ipw2200: Radio Frequency Kill Switch is On:
[   17.934235] Kill switch must be turned off for wireless networking to 
work.
[   17.937560] IrDA: Registered device irda0
[   17.945309] ipw2200: Detected geography ZZR (14 802.11bg channels, 0 
802.11a channels)
[   17.945422] Yenta: CardBus bridge found at 0000:02:04.0 [0e11:0860]
[   17.945487] Yenta: Using CSCINT to route CSC interrupts to PCI
[   17.945535] Yenta: Routing CardBus interrupts to PCI
[   17.945584] Yenta TI: socket 0000:02:04.0, mfunc 0x001c1112, devctl 0x44
[   17.959053] udev: renamed network interface eth1 to eth2
[   17.963928] Initializing USB Mass Storage driver...
[   18.054764] scsi2 : SCSI emulation for USB Mass Storage devices
[   18.055003] usbcore: registered new interface driver usb-storage
[   18.055054] USB Mass Storage support registered.
[   18.056582] usb-storage: device found at 2
[   18.056585] usb-storage: waiting for device to settle before scanning
[   18.168110] Yenta: ISA IRQ mask 0x0898, PCI irq 5
[   18.168161] Socket status: 30000006
[   18.168206] Yenta: Raising subordinate bus# of parent bus (#02) from 
#03 to #06
[   18.168268] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   18.168318] cs: IO port probe 0x2000-0x2fff: clean.
[   18.168623] pcmcia: parent PCI bridge Memory window: 0x90000000 - 
0x903fffff
[   18.169296] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[   18.224489] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  
MMIO=[90200000-902007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.229750] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   18.229886] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   18.358686] usb 3-1: new low speed USB device using uhci_hcd and 
address 2
[   18.518968] usb 3-1: configuration #1 chosen from 1 choice
[   18.595042] usbcore: registered new interface driver hiddev
[   18.608225] input: PS/2+USB Mouse as /class/input/input6
[   18.613904] input,hidraw0: USB HID v1.11 Mouse [PS/2+USB Mouse] on 
usb-0000:00:1d.2-1
[   18.614093] usbcore: registered new interface driver usbhid
[   18.614142] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   18.676639] cs: IO port probe 0x100-0x4ff: excluding 0x140-0x14f 
0x200-0x20f 0x378-0x37f
[   18.679305] cs: IO port probe 0x800-0x8ff: clean.
[   18.680107] cs: IO port probe 0xc00-0xcff: clean.
[   18.680953] cs: IO port probe 0xa00-0xaff: clean.
[   19.041708] intel8x0_measure_ac97_clock: measured 50439 usecs
[   19.041762] intel8x0: clocking to 48000
[   19.043620] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   19.043771] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[   19.487840] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00023f494a405951]
[   20.432072] Adding 971892k swap on /dev/sda5.  Priority:-1 extents:1 
across:971892k
[   20.708471] EXT3 FS on sda6, internal journal
[   21.386927] IA-32 Microcode Update Driver: v1.14a 
<tigran@aivazian.fsnet.co.uk>
[   21.419174] usbcore: registered new interface driver usbserial
[   21.419238] drivers/usb/serial/usb-serial.c: USB Serial support 
registered for generic
[   21.419310] usbcore: registered new interface driver usbserial_generic
[   21.419359] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   21.501969] device-mapper: uevent: version 1.0.3
[   21.502043] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) 
initialised: dm-devel@redhat.com
[   21.885393] NTFS driver 2.1.29 [Flags: R/W MODULE].
[   21.975324] NTFS volume version 3.1.
[   21.975377] NTFS-fs warning (device sda1): load_system_files(): 
Unsupported volume flags 0x4000 encountered.
[   21.975440] NTFS-fs error (device sda1): load_system_files(): Volume 
has unsupported flags set.  Mounting read-only.  Run chkdsk and mount in 
Windows.
[   23.056920] scsi 2:0:0:0: Direct-Access     USB 2.0  Flash Disk       
1100 PQ: 0 ANSI: 0 CCS
[   23.061899] sd 2:0:0:0: [sdb] 3963904 512-byte hardware sectors (2030 MB)
[   23.062893] sd 2:0:0:0: [sdb] Write Protect is off
[   23.062941] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   23.062944] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.065516] sd 2:0:0:0: [sdb] 3963904 512-byte hardware sectors (2030 MB)
[   23.066515] sd 2:0:0:0: [sdb] Write Protect is off
[   23.066563] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   23.066565] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.066615]  sdb: sdb1
[   23.067639] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   23.067728] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   23.067976] usb-storage: device scan complete
[   24.114262] ieee80211_crypt: registered algorithm 'WEP'
[   24.924188] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   42.014307] Clocksource tsc unstable (delta = -135778174 ns)
[   71.993044] NET: Registered protocol family 10
[   71.997147] lo: Disabled Privacy Extensions
[   71.998745] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   78.327134] usbcore: registered new interface driver usblp
[   41.561843] Bluetooth: Core ver 2.11
[   41.561961] NET: Registered protocol family 31
[   41.562007] Bluetooth: HCI device and connection manager initialized
[   41.562056] Bluetooth: HCI socket layer initialized
[   41.613902] Bluetooth: L2CAP ver 2.9
[   41.615504] Bluetooth: L2CAP socket layer initialized
[   41.694692] Bluetooth: RFCOMM socket layer initialized
[   41.694913] Bluetooth: RFCOMM TTY layer initialized
[   41.694961] Bluetooth: RFCOMM ver 1.8
[   43.781048] [drm] Initialized drm 1.1.0 20060810
[   43.785506] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[   43.786123] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   45.160388] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[   45.160518] agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
[   45.160550] agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[  123.009876] [drm] Setting GART location based on new memory map
[  123.010070] [drm] Loading R200 Microcode
[  123.010133] [drm] writeback test succeeded in 2 usecs



poppero1:/home/roppedisano# s2ram
Switching from vt7 to vt1
Calling save_state
Allocated buffer at 0x2010 (base is 0x0)
ES: 0x0201 EBX: 0x0000
Calling get_mode
Calling restore_state_from
Function not supported?
Calling set_vbe_mode
switching back to vt7


- after suspend

roppedisano@poppero1:~$ dmesg
ime: acpi_pm clocksource has been installed.
[   17.783728] usb 4-1: new high speed USB device using ehci_hcd and 
address 2
[   17.899592] usb 4-1: configuration #1 chosen from 1 choice
[   17.934233] ipw2200: Radio Frequency Kill Switch is On:
[   17.934235] Kill switch must be turned off for wireless networking to 
work.
[   17.937560] IrDA: Registered device irda0
[   17.945309] ipw2200: Detected geography ZZR (14 802.11bg channels, 0 
802.11a channels)
[   17.945422] Yenta: CardBus bridge found at 0000:02:04.0 [0e11:0860]
[   17.945487] Yenta: Using CSCINT to route CSC interrupts to PCI
[   17.945535] Yenta: Routing CardBus interrupts to PCI
[   17.945584] Yenta TI: socket 0000:02:04.0, mfunc 0x001c1112, devctl 0x44
[   17.959053] udev: renamed network interface eth1 to eth2
[   17.963928] Initializing USB Mass Storage driver...
[   18.054764] scsi2 : SCSI emulation for USB Mass Storage devices
[   18.055003] usbcore: registered new interface driver usb-storage
[   18.055054] USB Mass Storage support registered.
[   18.056582] usb-storage: device found at 2
[   18.056585] usb-storage: waiting for device to settle before scanning
[   18.168110] Yenta: ISA IRQ mask 0x0898, PCI irq 5
[   18.168161] Socket status: 30000006
[   18.168206] Yenta: Raising subordinate bus# of parent bus (#02) from 
#03 to #06
[   18.168268] pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
[   18.168318] cs: IO port probe 0x2000-0x2fff: clean.
[   18.168623] pcmcia: parent PCI bridge Memory window: 0x90000000 - 
0x903fffff
[   18.169296] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[   18.224489] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  
MMIO=[90200000-902007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.229750] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   18.229886] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   18.358686] usb 3-1: new low speed USB device using uhci_hcd and 
address 2
[   18.518968] usb 3-1: configuration #1 chosen from 1 choice
[   18.595042] usbcore: registered new interface driver hiddev
[   18.608225] input: PS/2+USB Mouse as /class/input/input6
[   18.613904] input,hidraw0: USB HID v1.11 Mouse [PS/2+USB Mouse] on 
usb-0000:00:1d.2-1
[   18.614093] usbcore: registered new interface driver usbhid
[   18.614142] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   18.676639] cs: IO port probe 0x100-0x4ff: excluding 0x140-0x14f 
0x200-0x20f 0x378-0x37f
[   18.679305] cs: IO port probe 0x800-0x8ff: clean.
[   18.680107] cs: IO port probe 0xc00-0xcff: clean.
[   18.680953] cs: IO port probe 0xa00-0xaff: clean.
[   19.041708] intel8x0_measure_ac97_clock: measured 50439 usecs
[   19.041762] intel8x0: clocking to 48000
[   19.043620] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[   19.043771] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[   19.487840] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00023f494a405951]
[   20.432072] Adding 971892k swap on /dev/sda5.  Priority:-1 extents:1 
across:971892k
[   20.708471] EXT3 FS on sda6, internal journal
[   21.386927] IA-32 Microcode Update Driver: v1.14a 
<tigran@aivazian.fsnet.co.uk>
[   21.419174] usbcore: registered new interface driver usbserial
[   21.419238] drivers/usb/serial/usb-serial.c: USB Serial support 
registered for generic
[   21.419310] usbcore: registered new interface driver usbserial_generic
[   21.419359] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   21.501969] device-mapper: uevent: version 1.0.3
[   21.502043] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) 
initialised: dm-devel@redhat.com
[   21.885393] NTFS driver 2.1.29 [Flags: R/W MODULE].
[   21.975324] NTFS volume version 3.1.
[   21.975377] NTFS-fs warning (device sda1): load_system_files(): 
Unsupported volume flags 0x4000 encountered.
[   21.975440] NTFS-fs error (device sda1): load_system_files(): Volume 
has unsupported flags set.  Mounting read-only.  Run chkdsk and mount in 
Windows.
[   23.056920] scsi 2:0:0:0: Direct-Access     USB 2.0  Flash Disk       
1100 PQ: 0 ANSI: 0 CCS
[   23.061899] sd 2:0:0:0: [sdb] 3963904 512-byte hardware sectors (2030 MB)
[   23.062893] sd 2:0:0:0: [sdb] Write Protect is off
[   23.062941] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   23.062944] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.065516] sd 2:0:0:0: [sdb] 3963904 512-byte hardware sectors (2030 MB)
[   23.066515] sd 2:0:0:0: [sdb] Write Protect is off
[   23.066563] sd 2:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   23.066565] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[   23.066615]  sdb: sdb1
[   23.067639] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   23.067728] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   23.067976] usb-storage: device scan complete
[   24.114262] ieee80211_crypt: registered algorithm 'WEP'
[   24.924188] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[   42.014307] Clocksource tsc unstable (delta = -135778174 ns)
[   71.993044] NET: Registered protocol family 10
[   71.997147] lo: Disabled Privacy Extensions
[   71.998745] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   78.327134] usbcore: registered new interface driver usblp
[   41.561843] Bluetooth: Core ver 2.11
[   41.561961] NET: Registered protocol family 31
[   41.562007] Bluetooth: HCI device and connection manager initialized
[   41.562056] Bluetooth: HCI socket layer initialized
[   41.613902] Bluetooth: L2CAP ver 2.9
[   41.615504] Bluetooth: L2CAP socket layer initialized
[   41.694692] Bluetooth: RFCOMM socket layer initialized
[   41.694913] Bluetooth: RFCOMM TTY layer initialized
[   41.694961] Bluetooth: RFCOMM ver 1.8
[   43.781048] [drm] Initialized drm 1.1.0 20060810
[   43.785506] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[   43.786123] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[   45.160388] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[   45.160518] agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
[   45.160550] agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[  123.009876] [drm] Setting GART location based on new memory map
[  123.010070] [drm] Loading R200 Microcode
[  123.010133] [drm] writeback test succeeded in 2 usecs
[  555.546384] Syncing filesystems ... done.
[  555.995405] Freezing user space processes ... (elapsed 0.02 seconds) 
done.
[  556.015925] Freezing remaining freezable tasks ... (elapsed 0.00 
seconds) done.
[  556.016084] Suspending console(s)
[  556.094907] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  556.095062] sd 0:0:0:0: [sda] Stopping disk
[  556.096308] ACPI handle has no context!
[  556.096578] wbsd 00:02: disabled
[  556.096637] eth2: Going into suspend...
[  556.096672] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[  556.096677] ACPI handle has no context!
[  556.102017] ACPI handle has no context!
[  556.113013] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[  556.124013] codec_write 0: semaphore is not ready for register 0x26
[  556.124019] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[  556.124686] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[  556.124771] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  556.124920] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  556.124946] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  556.124972] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[    0.445798] Intel machine check architecture supported.
[    0.445805] Intel machine check reporting enabled on CPU#0.
[    0.445812] Back to C!
[    0.454486] PCI: Enabling device 0000:00:1d.0 (0000 -> 0001)
[    0.454491] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[    0.454499] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    0.454505] PM: Writing back config space on device 0000:00:1d.0 at 
offset f (was 100, writing 10a)
[    0.454517] PM: Writing back config space on device 0000:00:1d.0 at 
offset 8 (was 1, writing 48c1)
[    0.454546] usb usb1: root hub lost power or was reset
[    0.454561] PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
[    0.454565] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [C0C5] -> GSI 
5 (level, low) -> IRQ 5
[    0.454572] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    0.454577] PM: Writing back config space on device 0000:00:1d.1 at 
offset f (was 200, writing 205)
[    0.454589] PM: Writing back config space on device 0000:00:1d.1 at 
offset 8 (was 1, writing 48e1)
[    0.454616] usb usb2: root hub lost power or was reset
[    0.454630] PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
[    0.454633] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [C0C4] -> GSI 
5 (level, low) -> IRQ 5
[    0.454640] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    0.454646] PM: Writing back config space on device 0000:00:1d.2 at 
offset f (was 300, writing 305)
[    0.454658] PM: Writing back config space on device 0000:00:1d.2 at 
offset 8 (was 1, writing 4c01)
[    0.454685] usb usb3: root hub lost power or was reset
[    0.464886] PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
[    0.464889] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [C0C9] -> GSI 
5 (level, low) -> IRQ 5
[    0.464897] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    0.464909] PM: Writing back config space on device 0000:00:1d.7 at 
offset f (was 400, writing 405)
[    0.464927] PM: Writing back config space on device 0000:00:1d.7 at 
offset 4 (was 0, writing a0000000)
[    0.464957] PM: Writing back config space on device 0000:00:1e.0 at 
offset 7 (was 22802020, writing 2802020)
[    0.464974] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.465001] PM: Writing back config space on device 0000:00:1f.1 at 
offset f (was 100, writing 105)
[    0.465012] PM: Writing back config space on device 0000:00:1f.1 at 
offset 9 (was 0, writing 50000000)
[    0.465030] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [C0C4] -> GSI 
5 (level, low) -> IRQ 5
[    0.465036] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.466472] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[    0.466479] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    0.925828] ata2.00: _GTF unexpected object type 0x1
[    0.925831] ata2.00: revalidation failed (errno=-22)
[    0.925833] ata2: failed to recover some devices, retrying in 5 secs
[    1.482119] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [C0C3] -> GSI 
10 (level, low) -> IRQ 10
[    1.482126] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    1.848445] ipw2200: Unable to load ucode: -22
[    1.848472] ipw2200: Unable to load firmware: -22
[    1.848474] ipw2200: Failed to up device
[    2.486789] PM: Writing back config space on device 0000:01:00.0 at 
offset 6 (was 0, writing 90400000)
[    2.486796] PM: Writing back config space on device 0000:01:00.0 at 
offset 3 (was 0, writing 8008)
[    2.486815] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [C0C2] -> GSI 
10 (level, low) -> IRQ 10
[    2.497297] PM: Writing back config space on device 0000:02:00.0 at 
offset f (was 20000100, writing 2000010a)
[    2.497312] PM: Writing back config space on device 0000:02:00.0 at 
offset 5 (was 1, writing 2401)
[    2.497317] PM: Writing back config space on device 0000:02:00.0 at 
offset 4 (was 0, writing 90200000)
[    2.497322] PM: Writing back config space on device 0000:02:00.0 at 
offset 3 (was 0, writing 8008)
[    2.497328] PM: Writing back config space on device 0000:02:00.0 at 
offset 1 (was 2100080, writing 2100007)
[    2.550487] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  
MMIO=[90200000-902007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
[    2.563619] PM: Writing back config space on device 0000:02:01.0 at 
offset 1 (was 2900007, writing 2900017)
[    2.563653] eth2: Coming out of suspend...
[    2.563759] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[    2.563763] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [C0C5] -> GSI 
5 (level, low) -> IRQ 5
[    2.563773] PM: Writing back config space on device 0000:02:02.0 at 
offset f (was 18030100, writing 1803010b)
[    2.563789] PM: Writing back config space on device 0000:02:02.0 at 
offset 4 (was 0, writing 90000000)
[    2.563794] PM: Writing back config space on device 0000:02:02.0 at 
offset 3 (was 0, writing 8008)
[    2.563800] PM: Writing back config space on device 0000:02:02.0 at 
offset 1 (was 2900002, writing 2900006)
[    2.563862] PM: Writing back config space on device 0000:02:04.0 at 
offset f (was 34001ff, writing 5c00105)
[    2.563868] PM: Writing back config space on device 0000:02:04.0 at 
offset e (was 0, writing 2cfc)
[    2.563873] PM: Writing back config space on device 0000:02:04.0 at 
offset d (was 0, writing 2c00)
[    2.563878] PM: Writing back config space on device 0000:02:04.0 at 
offset c (was 0, writing 28fc)
[    2.563883] PM: Writing back config space on device 0000:02:04.0 at 
offset b (was 0, writing 2800)
[    2.563888] PM: Writing back config space on device 0000:02:04.0 at 
offset a (was 0, writing 5bfff000)
[    2.563893] PM: Writing back config space on device 0000:02:04.0 at 
offset 9 (was 0, writing 58000000)
[    2.563898] PM: Writing back config space on device 0000:02:04.0 at 
offset 8 (was 0, writing 57fff000)
[    2.563903] PM: Writing back config space on device 0000:02:04.0 at 
offset 7 (was 0, writing 54000000)
[    2.563909] PM: Writing back config space on device 0000:02:04.0 at 
offset 6 (was 0, writing b0060302)
[    2.563915] PM: Writing back config space on device 0000:02:04.0 at 
offset 4 (was 0, writing 90100000)
[    2.563920] PM: Writing back config space on device 0000:02:04.0 at 
offset 3 (was 20000, writing 2a820)
[    2.563926] PM: Writing back config space on device 0000:02:04.0 at 
offset 1 (was 2100000, writing 2100007)
[    2.610134] wbsd 00:02: activated
[    2.615366] sd 0:0:0:0: [sda] Starting disk
[    2.661801] ata1.00: configured for UDMA/100
[    2.663248] ata1.00: configured for UDMA/100
[    2.663251] ata1: EH complete
[    2.663431] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors 
(100030 MB)
[    2.663443] sd 0:0:0:0: [sda] Write Protect is off
[    2.663446] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.663460] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.663474] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors 
(100030 MB)
[    2.663482] sd 0:0:0:0: [sda] Write Protect is off
[    2.663484] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.663497] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.344191] Restarting tasks ... <6>usb 3-1: USB disconnect, address 2
[    3.360943] done.
[    3.541329] ipw2200: Radio Frequency Kill Switch is On:
[    3.541331] Kill switch must be turned off for wireless networking to 
work.
[    3.582665] usb 3-1: new low speed USB device using uhci_hcd and 
address 3
[    3.737808] usb 3-1: configuration #1 chosen from 1 choice
[    3.756110] input: PS/2+USB Mouse as /class/input/input7
[    3.762983] input,hidraw0: USB HID v1.11 Mouse [PS/2+USB Mouse] on 
usb-0000:00:1d.2-1
[    4.837211] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[    4.837232] agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
[    4.837263] agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[    4.837290] [drm] Loading R200 Microcode
[    5.313446] ata2.00: _GTF unexpected object type 0x1
[    5.313453] ata2.00: ACPI on devcfg failed the second time, disabling 
(errno=-22)
[    5.313457] ata2.00: revalidation failed (errno=1)
[    5.313459] ata2.00: disabled

-- 
Roberto Oppedisano [RO2480-RIPE]
Infracom Italia S.p.A.                         OSS and LIR Services
Tel. +39 045 8271518   Fax  +39 045 8271499   Cell. +39 348 7419534

