Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbZJ2HQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbZJ2HQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZJ2HQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:16:47 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:46922 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbZJ2HQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gns6MWxLhWi9O2KKO1degwGCzBvMt6zWeAJGJA2Xj++xNAj4df4pFbDWgHJbvrwzhw
         2GJr1Le4iPk1KbtLD9cv67A/LQ/FpiiTbwWhLxbhOxR2ptkkOYxrusj7uK+fG8LH+aF5
         z5v09qrlg4a0m8W57J63k6Vs4HFP+X9WoTQbQ=
Date: Thu, 29 Oct 2009 15:15:45 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH][RFC] input: remove bios I8042_CTR_XLATE check to make
	keyboard usable
Message-ID: <20091029071544.GA2220@darkstar.vlan7>
References: <20091027053404.GA2241@darkstar.vlan7> <20091028054309.GA2368@core.coreip.homeip.net> <20091028100318.GA4861@suse.cz> <20091028104211.GA2207@darkstar.vlan7> <20091029003325.GA2739@darkstar.vlan7> <20091029032633.GA7959@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029032633.GA7959@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 08:26:33PM -0700, Dmitry Torokhov wrote:
> On Thu, Oct 29, 2009 at 08:33:26AM +0800, Dave Young wrote:
> > On Wed, Oct 28, 2009 at 06:42:12PM +0800, Dave Young wrote:
> > > On Wed, Oct 28, 2009 at 11:03:18AM +0100, Vojtech Pavlik wrote:
> > > > On Tue, Oct 27, 2009 at 10:43:10PM -0700, Dmitry Torokhov wrote:
> > > > > Hi Dave,
> > > > > 
> > > > > On Tue, Oct 27, 2009 at 01:34:04PM +0800, Dave Young wrote:
> > > > > > 
> > > > > > Pressing somekey at early booting phase cause keyboard to be not usable
> > > > > > (The hardware is DELL latitude e5400):
> > > > 
> > > > Does early booting mean while the BIOS is coming up? Does the keyboard
> > > > work in GRUB then? Or is it during the early init of the Linux kernel?
> > > 
> > > Keyboard work under lilo.
> > > For the early booting I means the early init of the linux kernel
> > > 
> > > >  
> > > > > > atkbd.c: Unknown key pressed (raw set 2, code 0xd3 on isa0060/serio0).
> > > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > > > atkbd.c: Unknown key pressed (raw set 2, code 0x1d3 on isa0060/serio0).
> > > > > > atkbd.c: Use 'setkeycodes e053 <keycode>' to make it known.
> > > > > > 
> > > > > > i8042.c set i8042_direct to true when the controller init. But the result
> > > > > > is keyboard not usable, The only option is press the power button to shutdown. 
> > > > > > 
> > > > > > So here remove the bios check to fix it.
> > > > 
> > > > My question would be: Why this happens? Could it be that the probe is
> > > > confused by the keypress and reads the CTR incorrectly? Or is it just
> > > > that the keyboard controller is in fact in translating mode, yet the CTR
> > > > indicates otherwise?
> > > > 
> > > > A i8042.debug=1 log of the bad init would be good.
> > > 
> > > Here it is (retrieve from syslog):
> > 
> > Syslog redirect the debug info to another log file, sorry, post again:
> > 
> 
> Any chance of reconfiguring syslog so debug is captured in the same
> file? It is easier to see what is happening with the rest of context
> present...

Sure, here it is:

Oct 29 15:08:32 darkstar kernel: [    1.769328] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
Oct 29 15:08:32 darkstar kernel: [    1.775105] Console: switching to colour dummy device 80x25
Oct 29 15:08:32 darkstar kernel: [    1.836980] [drm] LVDS-8: set mode 1280x800 c
Oct 29 15:08:32 darkstar kernel: [    2.067531] async/0 used greatest stack depth: 6184 bytes left
Oct 29 15:08:32 darkstar kernel: [    2.228157] Console: switching to colour frame buffer device 160x50
Oct 29 15:08:32 darkstar kernel: [    2.260999] fb0: inteldrmfb frame buffer device
Oct 29 15:08:32 darkstar kernel: [    2.261001] registered panic notifier
Oct 29 15:08:32 darkstar kernel: [    2.309878] acpi device:3b: registered as cooling_device2
Oct 29 15:08:32 darkstar kernel: [    2.311325] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input3
Oct 29 15:08:32 darkstar kernel: [    2.311794] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
Oct 29 15:08:32 darkstar kernel: [    2.312212] ACPI Warning for \_SB_.PCI0.VID2._DOD: Return Package has no elements (empty) (20090903/nspredef-433)
Oct 29 15:08:32 darkstar kernel: [    2.312910] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:02/input/input4
Oct 29 15:08:32 darkstar kernel: [    2.313337] ACPI: Video Device [VID2] (multi-head: yes  rom: no  post: no)
Oct 29 15:08:32 darkstar kernel: [    2.313768] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Oct 29 15:08:32 darkstar kernel: [    2.314252] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Oct 29 15:08:32 darkstar kernel: [    2.321153] brd: module loaded
Oct 29 15:08:32 darkstar kernel: [    2.323814] loop: module loaded
Oct 29 15:08:32 darkstar kernel: [    2.324372] Loading iSCSI transport class v2.0-870.
Oct 29 15:08:32 darkstar kernel: [    2.325679] ata_piix 0000:00:1f.2: version 2.13
Oct 29 15:08:32 darkstar kernel: [    2.325706] ata_piix 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Oct 29 15:08:32 darkstar kernel: [    2.326042] ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
Oct 29 15:08:32 darkstar kernel: [    2.326420] ata_piix 0000:00:1f.2: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    2.326548] scsi0 : ata_piix
Oct 29 15:08:32 darkstar kernel: [    2.327157] scsi1 : ata_piix
Oct 29 15:08:32 darkstar kernel: [    2.329192] ata1: SATA max UDMA/133 cmd 0x6e70 ctl 0x6e78 bmdma 0x6ea0 irq 19
Oct 29 15:08:32 darkstar kernel: [    2.329525] ata2: SATA max UDMA/133 cmd 0x6e80 ctl 0x6e88 bmdma 0x6ea8 irq 19
Oct 29 15:08:32 darkstar kernel: [    2.329918] ata_piix 0000:00:1f.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Oct 29 15:08:32 darkstar kernel: [    2.330280] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
Oct 29 15:08:32 darkstar kernel: [    2.483399] ata_piix 0000:00:1f.5: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    2.483472] scsi2 : ata_piix
Oct 29 15:08:32 darkstar kernel: [    2.483889] scsi3 : ata_piix
Oct 29 15:08:32 darkstar kernel: [    2.494799] ata3: SATA max UDMA/133 cmd 0x6eb0 ctl 0x6eb8 bmdma 0x6ee0 irq 19
Oct 29 15:08:32 darkstar kernel: [    2.505374] ata4: SATA max UDMA/133 cmd 0x6ec0 ctl 0x6ec8 bmdma 0x6ee8 irq 19
Oct 29 15:08:32 darkstar kernel: [    2.517131] tg3.c:v3.102 (September 1, 2009)
Oct 29 15:08:32 darkstar kernel: [    2.527407] tg3 0000:09:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 29 15:08:32 darkstar kernel: [    2.537850] tg3 0000:09:00.0: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    2.556144] eth0: Tigon3 [partno(BCM95756m) rev a200] (PCI Express) MAC address 00:21:9b:f5:60:0f
Oct 29 15:08:32 darkstar kernel: [    2.566888] eth0: attached PHY is 5722/5756 (10/100/1000Base-T Ethernet) (WireSpeed[1])
Oct 29 15:08:32 darkstar kernel: [    2.577614] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
Oct 29 15:08:32 darkstar kernel: [    2.588351] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
Oct 29 15:08:32 darkstar kernel: [    2.599287] sky2 driver version 1.25
Oct 29 15:08:32 darkstar kernel: [    2.610019] PPP generic driver version 2.4.2
Oct 29 15:08:32 darkstar kernel: [    2.620820] PPP Deflate Compression module registered
Oct 29 15:08:32 darkstar kernel: [    2.631273] PPP BSD Compression module registered
Oct 29 15:08:32 darkstar kernel: [    2.642068] PPP MPPE Compression module registered
Oct 29 15:08:32 darkstar kernel: [    2.652346] NET: Registered protocol family 24
Oct 29 15:08:32 darkstar kernel: [    2.662740] PPPoL2TP kernel driver, V1.0
Oct 29 15:08:32 darkstar kernel: [    2.673215] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
Oct 29 15:08:32 darkstar kernel: [    2.684287] CSLIP: code copyright 1989 Regents of the University of California.
Oct 29 15:08:32 darkstar kernel: [    2.695418] SLIP linefill/keepalive option.
Oct 29 15:08:32 darkstar kernel: [    2.706655] console [netcon0] enabled
Oct 29 15:08:32 darkstar kernel: [    2.717759] netconsole: network logging started
Oct 29 15:08:32 darkstar kernel: [    2.729216] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Oct 29 15:08:32 darkstar kernel: [    2.740669] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Oct 29 15:08:32 darkstar kernel: [    2.752135] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    2.752141] ehci_hcd 0000:00:1a.7: EHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    2.763541] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
Oct 29 15:08:32 darkstar kernel: [    2.774930] ehci_hcd 0000:00:1a.7: debug port 1
Oct 29 15:08:32 darkstar kernel: [    2.789956] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
Oct 29 15:08:32 darkstar kernel: [    2.789984] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
Oct 29 15:08:32 darkstar kernel: [    2.803419] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Oct 29 15:08:32 darkstar kernel: [    2.805095] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Oct 29 15:08:32 darkstar kernel: [    2.838801] ata4: SATA link down (SStatus 4 SControl 300)
Oct 29 15:08:32 darkstar kernel: [    2.850203] ata3: SATA link down (SStatus 0 SControl 300)
Oct 29 15:08:32 darkstar kernel: [    2.850605] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
Oct 29 15:08:32 darkstar kernel: [    2.850787] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
Oct 29 15:08:32 darkstar kernel: [    2.850790] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    2.850793] usb usb1: Product: EHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    2.850795] usb usb1: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 ehci_hcd
Oct 29 15:08:32 darkstar kernel: [    2.850797] usb usb1: SerialNumber: 0000:00:1a.7
Oct 29 15:08:32 darkstar kernel: [    2.851349] usb usb1: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    2.851747] hub 1-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    2.851792] hub 1-0:1.0: 6 ports detected
Oct 29 15:08:32 darkstar kernel: [    2.852198] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Oct 29 15:08:32 darkstar kernel: [    2.852216] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    2.852220] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    2.852233] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Oct 29 15:08:32 darkstar kernel: [    2.852275] ehci_hcd 0000:00:1d.7: debug port 1
Oct 29 15:08:32 darkstar kernel: [    2.856179] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Oct 29 15:08:32 darkstar kernel: [    2.856205] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
Oct 29 15:08:32 darkstar kernel: [    3.000521] ata1.00: ATA-8: ST9160310AS, DE04, max UDMA/133
Oct 29 15:08:32 darkstar kernel: [    3.000905] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-L633A, D500, max UDMA/100
Oct 29 15:08:32 darkstar kernel: [    3.000919] ata2.00: applying bridge limits
Oct 29 15:08:32 darkstar kernel: [    3.030396] ata2.00: configured for UDMA/100
Oct 29 15:08:32 darkstar kernel: [    3.040423] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Oct 29 15:08:32 darkstar kernel: [    3.040485] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
Oct 29 15:08:32 darkstar kernel: [    3.060761] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
Oct 29 15:08:32 darkstar kernel: [    3.071186] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.071212] ata1.00: configured for UDMA/133
Oct 29 15:08:32 darkstar kernel: [    3.071835] scsi 0:0:0:0: Direct-Access     ATA      ST9160310AS      DE04 PQ: 0 ANSI: 5
Oct 29 15:08:32 darkstar kernel: [    3.073532] sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 29 15:08:32 darkstar kernel: [    3.074208] sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
Oct 29 15:08:32 darkstar kernel: [    3.074331] sd 0:0:0:0: [sda] Write Protect is off
Oct 29 15:08:32 darkstar kernel: [    3.074334] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 29 15:08:32 darkstar kernel: [    3.074397] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Oct 29 15:08:32 darkstar kernel: [    3.142477] usb usb2: Product: EHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.152723] usb usb2: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 ehci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.163136] usb usb2: SerialNumber: 0000:00:1d.7
Oct 29 15:08:32 darkstar kernel: [    3.173957] usb usb2: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.184694] hub 2-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.186168] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-L633A D500 PQ: 0 ANSI: 5
Oct 29 15:08:32 darkstar kernel: [    3.205673]  sda:
Oct 29 15:08:32 darkstar kernel: [    3.205887] hub 2-0:1.0: 6 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.226536] uhci_hcd: USB Universal Host Controller Interface driver
Oct 29 15:08:32 darkstar kernel: [    3.236805] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Oct 29 15:08:32 darkstar kernel: [    3.247146] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.247152] uhci_hcd 0000:00:1a.0: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.257722] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
Oct 29 15:08:32 darkstar kernel: [    3.268019] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f60
Oct 29 15:08:32 darkstar kernel: [    3.271348] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Oct 29 15:08:32 darkstar kernel: [    3.271352] Uniform CD-ROM driver Revision: 3.20
Oct 29 15:08:32 darkstar kernel: [    3.271935] sr 1:0:0:0: Attached scsi CD-ROM sr0
Oct 29 15:08:32 darkstar kernel: [    3.272214] sr 1:0:0:0: Attached scsi generic sg1 type 5
Oct 29 15:08:32 darkstar kernel: [    3.309009] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.319485] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.329938] usb usb3: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.340494] usb usb3: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.351173] usb usb3: SerialNumber: 0000:00:1a.0
Oct 29 15:08:32 darkstar kernel: [    3.362274] usb usb3: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.373209] hub 3-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.383878] hub 3-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.394578] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Oct 29 15:08:32 darkstar kernel: [    3.405325] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.405330] uhci_hcd 0000:00:1a.1: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.415917] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
Oct 29 15:08:32 darkstar kernel: [    3.426596] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f80
Oct 29 15:08:32 darkstar kernel: [    3.437249] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.447963] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.458896] usb usb4: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.469684] usb usb4: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.480609] usb usb4: SerialNumber: 0000:00:1a.1
Oct 29 15:08:32 darkstar kernel: [    3.491487]  sda1 sda2 sda3 sda4 <
Oct 29 15:08:32 darkstar kernel: [    3.491970] usb usb4: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.513750] hub 4-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.524608] hub 4-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.535457] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Oct 29 15:08:32 darkstar kernel: [    3.546368] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.546373] uhci_hcd 0000:00:1a.2: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.557269] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
Oct 29 15:08:32 darkstar kernel: [    3.568246] uhci_hcd 0000:00:1a.2: irq 22, io base 0x00006fa0
Oct 29 15:08:32 darkstar kernel: [    3.579151] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.590038] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.601062] usb usb5: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.611827] usb usb5: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.622664] usb usb5: SerialNumber: 0000:00:1a.2
Oct 29 15:08:32 darkstar kernel: [    3.633580] usb usb5: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.644466] hub 5-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.655057] hub 5-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.665643] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Oct 29 15:08:32 darkstar kernel: [    3.676188] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.676193] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.686592] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
Oct 29 15:08:32 darkstar kernel: [    3.697039] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f00
Oct 29 15:08:32 darkstar kernel: [    3.707478] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.717980] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.728432] usb usb6: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.738725] usb usb6: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.749227] usb usb6: SerialNumber: 0000:00:1d.0
Oct 29 15:08:32 darkstar kernel: [    3.759744]  sda5
Oct 29 15:08:32 darkstar kernel: [    3.759936] usb usb6: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.780577] hub 6-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.790864] hub 6-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.801175] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Oct 29 15:08:32 darkstar kernel: [    3.811517] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.811523] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.821680] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
Oct 29 15:08:32 darkstar kernel: [    3.831928] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f20
Oct 29 15:08:32 darkstar kernel: [    3.842070] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.852336] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.862506] usb usb7: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.872556] usb usb7: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    3.882704] usb usb7: SerialNumber: 0000:00:1d.1
Oct 29 15:08:32 darkstar kernel: [    3.893017] usb usb7: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    3.903360] hub 7-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    3.913514] hub 7-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    3.923668] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
Oct 29 15:08:32 darkstar kernel: [    3.933900] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [    3.933906] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.944027] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
Oct 29 15:08:32 darkstar kernel: [    3.954264] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
Oct 29 15:08:32 darkstar kernel: [    3.964387] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
Oct 29 15:08:32 darkstar kernel: [    3.974574] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Oct 29 15:08:32 darkstar kernel: [    3.984724] usb usb8: Product: UHCI Host Controller
Oct 29 15:08:32 darkstar kernel: [    3.994775] usb usb8: Manufacturer: Linux 2.6.32-rc5-00081-g964fe08 uhci_hcd
Oct 29 15:08:32 darkstar kernel: [    4.004946] usb usb8: SerialNumber: 0000:00:1d.2
Oct 29 15:08:32 darkstar kernel: [    4.015031]  sda6
Oct 29 15:08:32 darkstar kernel: [    4.015363] usb usb8: configuration #1 chosen from 1 choice
Oct 29 15:08:32 darkstar kernel: [    4.035532] hub 8-0:1.0: USB hub found
Oct 29 15:08:32 darkstar kernel: [    4.045674] hub 8-0:1.0: 2 ports detected
Oct 29 15:08:32 darkstar kernel: [    4.055871] Initializing USB Mass Storage driver...
Oct 29 15:08:32 darkstar kernel: [    4.065990] usbcore: registered new interface driver usb-storage
Oct 29 15:08:32 darkstar kernel: [    4.076095] USB Mass Storage support registered.
Oct 29 15:08:32 darkstar kernel: [    4.086460] usbcore: registered new interface driver libusual
Oct 29 15:08:32 darkstar kernel: [    4.096753] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Oct 29 15:08:32 darkstar kernel: [    4.107118] drivers/input/serio/i8042.c: 25 <- i8042 (flush, kbd) [3]
Oct 29 15:08:32 darkstar kernel: [    4.107251] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
Oct 29 15:08:32 darkstar kernel: [    4.107260] drivers/input/serio/i8042.c: 1f <- i8042 (return) [3]
Oct 29 15:08:32 darkstar kernel: [    4.107265] i8042.c: Warning: Keylock active.
Oct 29 15:08:32 darkstar kernel: [    4.117378] drivers/input/serio/i8042.c: 60 -> i8042 (command) [6]
Oct 29 15:08:32 darkstar kernel: [    4.117437] drivers/input/serio/i8042.c: 1e -> i8042 (parameter) [6]
Oct 29 15:08:32 darkstar kernel: [    4.117497] drivers/input/serio/i8042.c: 65 <- i8042 (flush, kbd) [6]
Oct 29 15:08:32 darkstar kernel: [    4.117557] drivers/input/serio/i8042.c: d3 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.117668] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [7]
Oct 29 15:08:32 darkstar kernel: [    4.117992] drivers/input/serio/i8042.c: 5a <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118003] drivers/input/serio/i8042.c: a7 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118061] drivers/input/serio/i8042.c: 20 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118383] drivers/input/serio/i8042.c: 3e <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118388] drivers/input/serio/i8042.c: a8 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118445] drivers/input/serio/i8042.c: 20 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118768] drivers/input/serio/i8042.c: 1e <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118773] drivers/input/serio/i8042.c: 60 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118832] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [7]
Oct 29 15:08:32 darkstar kernel: [    4.118998] drivers/input/serio/i8042.c: d3 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119110] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119434] drivers/input/serio/i8042.c: f0 <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119439] drivers/input/serio/i8042.c: d3 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119498] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119770] drivers/input/serio/i8042.c: 56 <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119775] drivers/input/serio/i8042.c: d3 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.119834] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [7]
Oct 29 15:08:32 darkstar kernel: [    4.120159] drivers/input/serio/i8042.c: a4 <- i8042 (return) [7]
Oct 29 15:08:32 darkstar kernel: [    4.120194] drivers/input/serio/i8042.c: 60 -> i8042 (command) [7]
Oct 29 15:08:32 darkstar kernel: [    4.122915] drivers/input/serio/i8042.c: 1e -> i8042 (parameter) [8]
Oct 29 15:08:32 darkstar kernel: [    4.123043] drivers/input/serio/i8042.c: 60 -> i8042 (command) [8]
Oct 29 15:08:32 darkstar kernel: [    4.123154] drivers/input/serio/i8042.c: 0f -> i8042 (parameter) [8]
Oct 29 15:08:32 darkstar kernel: [    4.123160] serio: i8042 KBD port at 0x60,0x64 irq 1
Oct 29 15:08:32 darkstar kernel: [    4.123464] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [8]
Oct 29 15:08:32 darkstar kernel: [    4.133281] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [11]
Oct 29 15:08:32 darkstar kernel: [    4.133325] serio: i8042 AUX port at 0x60,0x64 irq 12
Oct 29 15:08:32 darkstar kernel: [    4.133411] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [11]
Oct 29 15:08:32 darkstar kernel: [    4.143256] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [14]
Oct 29 15:08:32 darkstar kernel: [    4.143385] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [14]
Oct 29 15:08:32 darkstar kernel: [    4.143527] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [14]
Oct 29 15:08:32 darkstar kernel: [    4.143662] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [14]
Oct 29 15:08:32 darkstar kernel: [    4.143670] mice: PS/2 mouse device common for all mice
Oct 29 15:08:32 darkstar kernel: [    4.153624] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [17]
Oct 29 15:08:32 darkstar kernel: [    4.153754] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [17]
Oct 29 15:08:32 darkstar kernel: [    4.153937] drivers/input/serio/i8042.c: 24 <- i8042 (interrupt, 0, 1) [17]
Oct 29 15:08:32 darkstar kernel: [    4.154696] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [18]
Oct 29 15:08:32 darkstar kernel: [    4.154826] Driver 'rtc_cmos' needs updating - please use bus_type methods
Oct 29 15:08:32 darkstar kernel: [    4.154947] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [18]
Oct 29 15:08:32 darkstar kernel: [    4.164935] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [21]
Oct 29 15:08:32 darkstar kernel: [    4.165054] rtc_cmos 00:03: RTC can wake from S4
Oct 29 15:08:32 darkstar kernel: [    4.165068] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [21]
Oct 29 15:08:32 darkstar kernel: [    4.165086] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [21]
Oct 29 15:08:32 darkstar kernel: [    4.175208] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [24]
Oct 29 15:08:32 darkstar kernel: [    4.175226] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [24]
Oct 29 15:08:32 darkstar kernel: [    4.175345] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [24]
Oct 29 15:08:32 darkstar kernel: [    4.175471] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Oct 29 15:08:32 darkstar kernel: [    4.185639] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [27]
Oct 29 15:08:32 darkstar kernel: [    4.185661] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [27]
Oct 29 15:08:32 darkstar kernel: [    4.185698] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Oct 29 15:08:32 darkstar kernel: [    4.185957] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [27]
Oct 29 15:08:32 darkstar kernel: [    4.185972] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [27]
Oct 29 15:08:32 darkstar kernel: [    4.195933] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [30]
Oct 29 15:08:32 darkstar kernel: [    4.195955] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [30]
Oct 29 15:08:32 darkstar kernel: [    4.196035] i2c /dev entries driver
Oct 29 15:08:32 darkstar kernel: [    4.197044] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [30]
Oct 29 15:08:32 darkstar kernel: [    4.197497] input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
Oct 29 15:08:32 darkstar kernel: [    4.197766] drivers/input/serio/i8042.c: d4 -> i8042 (command) [31]
Oct 29 15:08:32 darkstar kernel: [    4.197825] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [31]
Oct 29 15:08:32 darkstar kernel: [    4.216640] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [36]
Oct 29 15:08:32 darkstar kernel: [    4.216785] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [36]
Oct 29 15:08:32 darkstar kernel: [    4.216818] drivers/input/serio/i8042.c: 60 -> i8042 (command) [36]
Oct 29 15:08:32 darkstar kernel: [    4.216878] drivers/input/serio/i8042.c: 0d -> i8042 (parameter) [36]
Oct 29 15:08:32 darkstar kernel: [    4.216988] drivers/input/serio/i8042.c: 60 -> i8042 (command) [36]
Oct 29 15:08:32 darkstar kernel: [    4.217099] drivers/input/serio/i8042.c: 0f -> i8042 (parameter) [36]
Oct 29 15:08:32 darkstar kernel: [    4.217241] drivers/input/serio/i8042.c: d4 -> i8042 (command) [36]
Oct 29 15:08:32 darkstar kernel: [    4.217353] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [36]
Oct 29 15:08:32 darkstar kernel: [    4.218739] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 29 15:08:32 darkstar kernel: [    4.220373] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [37]
Oct 29 15:08:32 darkstar kernel: [    4.229267] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [40]
Oct 29 15:08:32 darkstar kernel: [    4.229290] drivers/input/serio/i8042.c: d4 -> i8042 (command) [40]
Oct 29 15:08:32 darkstar kernel: [    4.229455] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [40]
Oct 29 15:08:32 darkstar kernel: [    4.229467] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [40]
Oct 29 15:08:32 darkstar kernel: [    4.229570] atkbd.c: Unknown key pressed (raw set 2, code 0x20 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.232057] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [40]
Oct 29 15:08:32 darkstar kernel: [    4.232608] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.250787] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [47]
Oct 29 15:08:32 darkstar kernel: [    4.250794] atkbd.c: Unknown key pressed (raw set 2, code 0x1f on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.254107] atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.272408]  sda7
Oct 29 15:08:32 darkstar kernel: [    4.272598] i6300ESB timer: Intel 6300ESB WatchDog Timer Driver v0.04
Oct 29 15:08:32 darkstar kernel: [    4.272602] async/1 used greatest stack depth: 6128 bytes left
Oct 29 15:08:32 darkstar kernel: [    4.272704] drivers/input/serio/i8042.c: d4 -> i8042 (command) [53]
Oct 29 15:08:32 darkstar kernel: [    4.272763] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [53]
Oct 29 15:08:32 darkstar kernel: [    4.273045] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [53]
Oct 29 15:08:32 darkstar kernel: [    4.273062] drivers/input/serio/i8042.c: d4 -> i8042 (command) [53]
Oct 29 15:08:32 darkstar kernel: [    4.273121] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [53]
Oct 29 15:08:32 darkstar kernel: [    4.304310] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [63]
Oct 29 15:08:32 darkstar kernel: [    4.304334] drivers/input/serio/i8042.c: d4 -> i8042 (command) [63]
Oct 29 15:08:32 darkstar kernel: [    4.304393] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [63]
Oct 29 15:08:32 darkstar kernel: [    4.304575] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Oct 29 15:08:32 darkstar kernel: [    4.304733] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [63]
Oct 29 15:08:32 darkstar kernel: [    4.304749] drivers/input/serio/i8042.c: d4 -> i8042 (command) [63]
Oct 29 15:08:32 darkstar kernel: [    4.304807] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [63]
Oct 29 15:08:32 darkstar kernel: [    4.315406] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [66]
Oct 29 15:08:32 darkstar kernel: [    4.315429] drivers/input/serio/i8042.c: d4 -> i8042 (command) [66]
Oct 29 15:08:32 darkstar kernel: [    4.315540] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [66]
Oct 29 15:08:32 darkstar kernel: [    4.315726] iTCO_wdt: Found a ICH9M TCO device (Version=2, TCOBASE=0x1060)
Oct 29 15:08:32 darkstar kernel: [    4.315835] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [66]
Oct 29 15:08:32 darkstar kernel: [    4.315850] drivers/input/serio/i8042.c: d4 -> i8042 (command) [66]
Oct 29 15:08:32 darkstar kernel: [    4.315909] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [66]
Oct 29 15:08:32 darkstar kernel: [    4.326568] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [69]
Oct 29 15:08:32 darkstar kernel: [    4.326591] drivers/input/serio/i8042.c: d4 -> i8042 (command) [69]
Oct 29 15:08:32 darkstar kernel: [    4.326755] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [69]
Oct 29 15:08:32 darkstar kernel: [    4.326767] drivers/input/serio/i8042.c: 25 <- i8042 (interrupt, 0, 1) [69]
Oct 29 15:08:32 darkstar kernel: [    4.326783] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Oct 29 15:08:32 darkstar kernel: [    4.337663] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [73]
Oct 29 15:08:32 darkstar kernel: [    4.337682] drivers/input/serio/i8042.c: d4 -> i8042 (command) [73]
Oct 29 15:08:32 darkstar kernel: [    4.337692] iTCO_vendor_support: vendor-support=0
Oct 29 15:08:32 darkstar kernel: [    4.337846] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [73]
Oct 29 15:08:32 darkstar kernel: [    4.337858] drivers/input/serio/i8042.c: a4 <- i8042 (interrupt, 0, 1) [73]
Oct 29 15:08:32 darkstar kernel: [    4.337871] atkbd.c: Unknown key pressed (raw set 2, code 0x124 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.337874] atkbd.c: Use 'setkeycodes 24 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.370530] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [82]
Oct 29 15:08:32 darkstar kernel: [    4.370552] drivers/input/serio/i8042.c: d4 -> i8042 (command) [82]
Oct 29 15:08:32 darkstar kernel: [    4.370717] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [82]
Oct 29 15:08:32 darkstar kernel: [    4.370729] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [82]
Oct 29 15:08:32 darkstar kernel: [    4.370743] atkbd.c: Unknown key pressed (raw set 2, code 0x121 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.371011] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [82]
Oct 29 15:08:32 darkstar kernel: [    4.371197] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Oct 29 15:08:32 darkstar kernel: [    4.371429] device-mapper: dm-log-userspace: version 1.0.0 loaded
Oct 29 15:08:32 darkstar kernel: [    4.372402] cpuidle: using governor ladder
Oct 29 15:08:32 darkstar kernel: [    4.373871] atkbd.c: Use 'setkeycodes 21 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.426476] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [99]
Oct 29 15:08:32 darkstar kernel: [    4.426518] drivers/input/serio/i8042.c: d4 -> i8042 (command) [99]
Oct 29 15:08:32 darkstar kernel: [    4.428191] cpuidle: using governor menu
Oct 29 15:08:32 darkstar kernel: [    4.429084] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [99]
Oct 29 15:08:32 darkstar kernel: [    4.434432] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [100]
Oct 29 15:08:32 darkstar kernel: [    4.434478] drivers/input/serio/i8042.c: d4 -> i8042 (command) [102]
Oct 29 15:08:32 darkstar kernel: [    4.434641] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [102]
Oct 29 15:08:32 darkstar kernel: [    4.439332] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [102]
Oct 29 15:08:32 darkstar kernel: [    4.439347] atkbd.c: Unknown key pressed (raw set 2, code 0x126 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.439349] atkbd.c: Use 'setkeycodes 26 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.439654] sdhci: Secure Digital Host Controller Interface driver
Oct 29 15:08:32 darkstar kernel: [    4.439656] sdhci: Copyright(c) Pierre Ossman
Oct 29 15:08:32 darkstar kernel: [    4.439707] sdhci-pci 0000:02:01.2: SDHCI controller found [1180:0822] (rev 21)
Oct 29 15:08:32 darkstar kernel: [    4.439735] sdhci-pci 0000:02:01.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 29 15:08:32 darkstar kernel: [    4.442116] Registered led device: mmc0::
Oct 29 15:08:32 darkstar kernel: [    4.443389] mmc0: SDHCI controller on PCI [0000:02:01.2] using DMA
Oct 29 15:08:32 darkstar kernel: [    4.443641] wbsd: Winbond W83L51xD SD/MMC card interface driver
Oct 29 15:08:32 darkstar kernel: [    4.443644] wbsd: Copyright(c) Pierre Ossman
Oct 29 15:08:32 darkstar kernel: [    4.444232] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
Oct 29 15:08:32 darkstar kernel: [    4.447550] usbcore: registered new interface driver hiddev
Oct 29 15:08:32 darkstar kernel: [    4.447680] usbcore: registered new interface driver usbhid
Oct 29 15:08:32 darkstar kernel: [    4.447685] usbhid: v2.6:USB HID core driver
Oct 29 15:08:32 darkstar kernel: [    4.447900] Advanced Linux Sound Architecture Driver Version 1.0.21.
Oct 29 15:08:32 darkstar kernel: [    4.447902] ALSA device list:
Oct 29 15:08:32 darkstar kernel: [    4.447904]   No soundcards found.
Oct 29 15:08:32 darkstar kernel: [    4.447907] Netfilter messages via NETLINK v0.30.
Oct 29 15:08:32 darkstar kernel: [    4.447987] nf_conntrack version 0.5.0 (15347 buckets, 61388 max)
Oct 29 15:08:32 darkstar kernel: [    4.448841] ctnetlink v0.93: registering with nfnetlink.
Oct 29 15:08:32 darkstar kernel: [    4.450911] ip_tables: (C) 2000-2006 Netfilter Core Team
Oct 29 15:08:32 darkstar kernel: [    4.450992] TCP cubic registered
Oct 29 15:08:32 darkstar kernel: [    4.450997] NET: Registered protocol family 17
Oct 29 15:08:32 darkstar kernel: [    4.451028] lib80211: common routines for IEEE802.11 drivers
Oct 29 15:08:32 darkstar kernel: [    4.451041] lib80211_crypt: registered algorithm 'NULL'
Oct 29 15:08:32 darkstar kernel: [    4.463024] Using IPI No-Shortcut mode
Oct 29 15:08:32 darkstar kernel: [    4.463687] PM: Checking image partition /dev/sda8
Oct 29 15:08:32 darkstar kernel: [    4.463733] PM: Resume from partition 8:8
Oct 29 15:08:32 darkstar kernel: [    4.463735] PM: Checking hibernation image.
Oct 29 15:08:32 darkstar kernel: [    4.473031] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [110]
Oct 29 15:08:32 darkstar kernel: [    4.473047] atkbd.c: Unknown key pressed (raw set 2, code 0x120 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.473049] atkbd.c: Use 'setkeycodes 20 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.511209]  sda8 >
Oct 29 15:08:32 darkstar kernel: [    4.715234] drivers/input/serio/i8042.c: a5 <- i8042 (interrupt, 0, 1) [186]
Oct 29 15:08:32 darkstar kernel: [    4.715242] atkbd.c: Unknown key pressed (raw set 2, code 0x125 on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.715244] atkbd.c: Use 'setkeycodes 25 <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.716589] drivers/input/serio/i8042.c: d4 -> i8042 (command) [186]
Oct 29 15:08:32 darkstar kernel: [    4.716649] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [186]
Oct 29 15:08:32 darkstar kernel: [    4.783675] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [207]
Oct 29 15:08:32 darkstar kernel: [    4.783683] atkbd.c: Unknown key pressed (raw set 2, code 0x11f on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    4.783685] atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    4.913583] drivers/input/serio/i8042.c: d4 -> i8042 (command) [246]
Oct 29 15:08:32 darkstar kernel: [    4.956571] PM: Resume from disk failed.
Oct 29 15:08:32 darkstar kernel: [    4.956677] registered taskstats version 1
Oct 29 15:08:32 darkstar kernel: [    4.979979] sd 0:0:0:0: [sda] Attached SCSI disk
Oct 29 15:08:32 darkstar kernel: [    5.004842]   Magic number: 13:858:134
Oct 29 15:08:32 darkstar kernel: [    5.027235] acpi device:09: hash matches
Oct 29 15:08:32 darkstar kernel: [    5.049367] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Oct 29 15:08:32 darkstar kernel: [    5.072385] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [258]
Oct 29 15:08:32 darkstar kernel: [    5.319685] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [367]
Oct 29 15:08:32 darkstar kernel: [    5.319755] drivers/input/serio/i8042.c: d4 -> i8042 (command) [367]
Oct 29 15:08:32 darkstar kernel: [    5.322450] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [367]
Oct 29 15:08:32 darkstar kernel: [    5.330489] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [370]
Oct 29 15:08:32 darkstar kernel: [    5.330576] atkbd.c: Unknown key pressed (raw set 2, code 0x11e on isa0060/serio0).
Oct 29 15:08:32 darkstar kernel: [    5.333797] atkbd.c: Use 'setkeycodes 1e <keycode>' to make it known.
Oct 29 15:08:32 darkstar kernel: [    5.520261] drivers/input/serio/i8042.c: d4 -> i8042 (command) [428]
Oct 29 15:08:32 darkstar kernel: [    5.523457] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [486]
Oct 29 15:08:32 darkstar kernel: [    5.839759] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [523]
Oct 29 15:08:32 darkstar kernel: [    5.839792] drivers/input/serio/i8042.c: d4 -> i8042 (command) [523]
Oct 29 15:08:32 darkstar kernel: [    5.842149] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [524]
Oct 29 15:08:32 darkstar kernel: [    5.847357] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [526]
Oct 29 15:08:32 darkstar kernel: [    5.847398] drivers/input/serio/i8042.c: d4 -> i8042 (command) [526]
Oct 29 15:08:32 darkstar kernel: [    5.847514] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [526]
Oct 29 15:08:32 darkstar kernel: [    5.847894] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [526]
Oct 29 15:08:32 darkstar kernel: [    5.847929] drivers/input/serio/i8042.c: d4 -> i8042 (command) [526]
Oct 29 15:08:32 darkstar kernel: [    5.847991] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [526]
Oct 29 15:08:32 darkstar kernel: [    5.853332] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [527]
Oct 29 15:08:32 darkstar kernel: [    5.853374] drivers/input/serio/i8042.c: d4 -> i8042 (command) [528]
Oct 29 15:08:32 darkstar kernel: [    5.853435] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [528]
Oct 29 15:08:32 darkstar kernel: [    5.853865] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [528]
Oct 29 15:08:32 darkstar kernel: [    5.853899] drivers/input/serio/i8042.c: d4 -> i8042 (command) [528]
Oct 29 15:08:32 darkstar kernel: [    5.853960] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [528]
Oct 29 15:08:32 darkstar kernel: [    5.859306] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [529]
Oct 29 15:08:32 darkstar kernel: [    5.859347] drivers/input/serio/i8042.c: d4 -> i8042 (command) [529]
Oct 29 15:08:32 darkstar kernel: [    5.859408] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [529]
Oct 29 15:08:32 darkstar kernel: [    5.862548] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [530]
Oct 29 15:08:32 darkstar kernel: [    5.863755] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [531]
Oct 29 15:08:32 darkstar kernel: [    5.863796] drivers/input/serio/i8042.c: d4 -> i8042 (command) [531]
Oct 29 15:08:32 darkstar kernel: [    5.863857] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [531]
Oct 29 15:08:32 darkstar kernel: [    5.864236] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [531]
Oct 29 15:08:32 darkstar kernel: [    5.864269] drivers/input/serio/i8042.c: d4 -> i8042 (command) [531]
Oct 29 15:08:32 darkstar kernel: [    5.864331] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [531]
Oct 29 15:08:32 darkstar kernel: [    5.869766] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [532]
Oct 29 15:08:32 darkstar kernel: [    5.869806] drivers/input/serio/i8042.c: d4 -> i8042 (command) [532]
Oct 29 15:08:32 darkstar kernel: [    5.869867] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [532]
Oct 29 15:08:32 darkstar kernel: [    5.870251] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [533]
Oct 29 15:08:32 darkstar kernel: [    5.870284] drivers/input/serio/i8042.c: d4 -> i8042 (command) [533]
Oct 29 15:08:32 darkstar kernel: [    5.870346] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [533]
Oct 29 15:08:32 darkstar kernel: [    5.875813] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [534]
Oct 29 15:08:32 darkstar kernel: [    5.875853] drivers/input/serio/i8042.c: d4 -> i8042 (command) [534]
Oct 29 15:08:32 darkstar kernel: [    5.875914] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [534]
Oct 29 15:08:32 darkstar kernel: [    5.876297] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [534]
Oct 29 15:08:32 darkstar kernel: [    5.876330] drivers/input/serio/i8042.c: d4 -> i8042 (command) [534]
Oct 29 15:08:32 darkstar kernel: [    5.876391] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [534]
Oct 29 15:08:32 darkstar kernel: [    5.881873] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [536]
Oct 29 15:08:32 darkstar kernel: [    5.881913] drivers/input/serio/i8042.c: d4 -> i8042 (command) [536]
Oct 29 15:08:32 darkstar kernel: [    5.881975] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [536]
Oct 29 15:08:32 darkstar kernel: [    5.882340] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [536]
Oct 29 15:08:32 darkstar kernel: [    5.882374] drivers/input/serio/i8042.c: d4 -> i8042 (command) [536]
Oct 29 15:08:32 darkstar kernel: [    5.882435] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [536]
Oct 29 15:08:32 darkstar kernel: [    5.887905] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [538]
Oct 29 15:08:32 darkstar kernel: [    5.887945] drivers/input/serio/i8042.c: d4 -> i8042 (command) [538]
Oct 29 15:08:32 darkstar kernel: [    5.888007] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [538]
Oct 29 15:08:32 darkstar kernel: [    5.891177] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [539]
Oct 29 15:08:32 darkstar kernel: [    5.894188] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [540]
Oct 29 15:08:32 darkstar kernel: [    5.894315] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [540]
Oct 29 15:08:32 darkstar kernel: [    5.894538] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 1, 12) [540]
Oct 29 15:08:32 darkstar kernel: [    5.894577] drivers/input/serio/i8042.c: d4 -> i8042 (command) [540]
Oct 29 15:08:32 darkstar kernel: [    5.894638] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [540]
Oct 29 15:08:32 darkstar kernel: [    5.897753] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [541]
Oct 29 15:08:32 darkstar kernel: [    5.897793] drivers/input/serio/i8042.c: d4 -> i8042 (command) [541]
Oct 29 15:08:32 darkstar kernel: [    5.897855] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [541]
Oct 29 15:08:32 darkstar kernel: [    5.898230] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [541]
Oct 29 15:08:32 darkstar kernel: [    5.898264] drivers/input/serio/i8042.c: d4 -> i8042 (command) [541]
Oct 29 15:08:32 darkstar kernel: [    5.898326] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [541]
Oct 29 15:08:32 darkstar kernel: [    5.903804] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [543]
Oct 29 15:08:32 darkstar kernel: [    5.903844] drivers/input/serio/i8042.c: d4 -> i8042 (command) [543]
Oct 29 15:08:32 darkstar kernel: [    5.903905] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [543]
Oct 29 15:08:32 darkstar kernel: [    5.907069] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [544]
Oct 29 15:08:32 darkstar kernel: [    5.907109] drivers/input/serio/i8042.c: d4 -> i8042 (command) [544]
Oct 29 15:08:32 darkstar kernel: [    5.907170] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [544]
Oct 29 15:08:32 darkstar kernel: [    5.909865] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [544]
Oct 29 15:08:32 darkstar kernel: [    5.909905] drivers/input/serio/i8042.c: d4 -> i8042 (command) [544]
Oct 29 15:08:32 darkstar kernel: [    5.909966] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [544]
Oct 29 15:08:32 darkstar kernel: [    5.913103] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [545]
Oct 29 15:08:32 darkstar kernel: [    5.913143] drivers/input/serio/i8042.c: d4 -> i8042 (command) [545]
Oct 29 15:08:32 darkstar kernel: [    5.913204] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [545]
Oct 29 15:08:32 darkstar kernel: [    5.916550] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [546]
Oct 29 15:08:32 darkstar kernel: [    5.919557] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [547]
Oct 29 15:08:32 darkstar kernel: [    5.919719] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [547]
Oct 29 15:08:32 darkstar kernel: [    5.919932] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [547]
Oct 29 15:08:32 darkstar kernel: [    5.919971] drivers/input/serio/i8042.c: d4 -> i8042 (command) [547]
Oct 29 15:08:32 darkstar kernel: [    5.920032] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [547]
Oct 29 15:08:32 darkstar kernel: [    5.920396] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [548]
Oct 29 15:08:32 darkstar kernel: [    5.920430] drivers/input/serio/i8042.c: d4 -> i8042 (command) [548]
Oct 29 15:08:32 darkstar kernel: [    5.920491] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [548]
Oct 29 15:08:32 darkstar kernel: [    5.925916] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [549]
Oct 29 15:08:32 darkstar kernel: [    5.925956] drivers/input/serio/i8042.c: d4 -> i8042 (command) [549]
Oct 29 15:08:32 darkstar kernel: [    5.926018] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [549]
Oct 29 15:08:32 darkstar kernel: [    5.929179] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [550]
Oct 29 15:08:32 darkstar kernel: [    5.929219] drivers/input/serio/i8042.c: d4 -> i8042 (command) [550]
Oct 29 15:08:32 darkstar kernel: [    5.929281] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [550]
Oct 29 15:08:32 darkstar kernel: [    5.932607] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [551]
Oct 29 15:08:32 darkstar kernel: [    5.932647] drivers/input/serio/i8042.c: d4 -> i8042 (command) [551]
Oct 29 15:08:32 darkstar kernel: [    5.932708] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [551]
Oct 29 15:08:32 darkstar kernel: [    5.936036] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [552]
Oct 29 15:08:32 darkstar kernel: [    5.936076] drivers/input/serio/i8042.c: d4 -> i8042 (command) [552]
Oct 29 15:08:32 darkstar kernel: [    5.936137] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [552]
Oct 29 15:08:32 darkstar kernel: [    5.939444] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [553]
Oct 29 15:08:32 darkstar kernel: [    5.942512] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [554]
Oct 29 15:08:32 darkstar kernel: [    5.942673] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [554]
Oct 29 15:08:32 darkstar kernel: [    5.942886] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 1, 12) [554]
Oct 29 15:08:32 darkstar kernel: [    5.942933] drivers/input/serio/i8042.c: d4 -> i8042 (command) [554]
Oct 29 15:08:32 darkstar kernel: [    5.942995] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [554]
Oct 29 15:08:32 darkstar kernel: [    5.943347] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [555]
Oct 29 15:08:32 darkstar kernel: [    5.943381] drivers/input/serio/i8042.c: d4 -> i8042 (command) [555]
Oct 29 15:08:32 darkstar kernel: [    5.943442] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [555]
Oct 29 15:08:32 darkstar kernel: [    5.948979] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [556]
Oct 29 15:08:32 darkstar kernel: [    5.949020] drivers/input/serio/i8042.c: d4 -> i8042 (command) [556]
Oct 29 15:08:32 darkstar kernel: [    5.949081] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [556]
Oct 29 15:08:32 darkstar kernel: [    5.952244] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [557]
Oct 29 15:08:32 darkstar kernel: [    5.952284] drivers/input/serio/i8042.c: d4 -> i8042 (command) [557]
Oct 29 15:08:32 darkstar kernel: [    5.952345] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [557]
Oct 29 15:08:32 darkstar kernel: [    5.954432] async/0 used greatest stack depth: 6036 bytes left
Oct 29 15:08:32 darkstar kernel: [    5.955629] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [558]
Oct 29 15:08:32 darkstar kernel: [    5.955687] drivers/input/serio/i8042.c: d4 -> i8042 (command) [558]
Oct 29 15:08:32 darkstar kernel: [    5.955750] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [558]
Oct 29 15:08:32 darkstar kernel: [    5.959057] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [558]
Oct 29 15:08:32 darkstar kernel: [    5.959168] drivers/input/serio/i8042.c: d4 -> i8042 (command) [558]
Oct 29 15:08:32 darkstar kernel: [    5.959231] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [558]
Oct 29 15:08:32 darkstar kernel: [    5.976954] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977073] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977191] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977336] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977370] drivers/input/serio/i8042.c: d4 -> i8042 (command) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977431] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977798] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977826] drivers/input/serio/i8042.c: d4 -> i8042 (command) [565]
Oct 29 15:08:32 darkstar kernel: [    5.977888] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [565]
Oct 29 15:08:32 darkstar kernel: [    5.983314] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [566]
Oct 29 15:08:32 darkstar kernel: [    5.983369] drivers/input/serio/i8042.c: d4 -> i8042 (command) [566]
Oct 29 15:08:32 darkstar kernel: [    5.983430] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [566]
Oct 29 15:08:32 darkstar kernel: [    5.986598] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [567]
Oct 29 15:08:32 darkstar kernel: [    5.986633] drivers/input/serio/i8042.c: d4 -> i8042 (command) [567]
Oct 29 15:08:32 darkstar kernel: [    5.986694] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [567]
Oct 29 15:08:32 darkstar kernel: [    5.990039] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [568]
Oct 29 15:08:32 darkstar kernel: [    5.990150] drivers/input/serio/i8042.c: d4 -> i8042 (command) [568]
Oct 29 15:08:32 darkstar kernel: [    5.990214] drivers/input/serio/i8042.c: e7 -> i8042 (parameter) [568]
Oct 29 15:08:32 darkstar kernel: [    5.993986] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [569]
Oct 29 15:08:32 darkstar kernel: [    5.994064] drivers/input/serio/i8042.c: d4 -> i8042 (command) [569]
Oct 29 15:08:32 darkstar kernel: [    5.994128] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [569]
Oct 29 15:08:32 darkstar kernel: [    5.997399] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [570]
Oct 29 15:08:32 darkstar kernel: [    6.000394] drivers/input/serio/i8042.c: 73 <- i8042 (interrupt, 1, 12) [571]
Oct 29 15:08:32 darkstar kernel: [    6.000638] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [571]
Oct 29 15:08:32 darkstar kernel: [    6.000855] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 1, 12) [571]
Oct 29 15:08:32 darkstar kernel: [    6.000975] drivers/input/serio/i8042.c: d4 -> i8042 (command) [572]
Oct 29 15:08:32 darkstar kernel: [    6.001040] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [572]
Oct 29 15:08:32 darkstar kernel: [    6.004211] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [572]
Oct 29 15:08:32 darkstar kernel: [    6.007249] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [574]
Oct 29 15:08:32 darkstar kernel: [    6.007387] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [574]
Oct 29 15:08:32 darkstar kernel: [    6.007641] drivers/input/serio/i8042.c: 64 <- i8042 (interrupt, 1, 12) [574]
Oct 29 15:08:32 darkstar kernel: [    6.007729] drivers/input/serio/i8042.c: d4 -> i8042 (command) [574]
Oct 29 15:08:32 darkstar kernel: [    6.007793] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [574]
Oct 29 15:08:32 darkstar kernel: [    6.010910] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [575]
Oct 29 15:08:32 darkstar kernel: [    6.010995] drivers/input/serio/i8042.c: d4 -> i8042 (command) [575]
Oct 29 15:08:32 darkstar kernel: [    6.011059] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [575]
Oct 29 15:08:32 darkstar kernel: [    6.014288] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [576]
Oct 29 15:08:32 darkstar kernel: [    6.014374] drivers/input/serio/i8042.c: d4 -> i8042 (command) [576]
Oct 29 15:08:32 darkstar kernel: [    6.014439] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [576]
Oct 29 15:08:32 darkstar kernel: [    6.014840] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [576]
Oct 29 15:08:32 darkstar kernel: [    6.014914] drivers/input/serio/i8042.c: d4 -> i8042 (command) [576]
Oct 29 15:08:32 darkstar kernel: [    6.014979] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [576]
Oct 29 15:08:32 darkstar kernel: [    6.020364] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [578]
Oct 29 15:08:32 darkstar kernel: [    6.020451] drivers/input/serio/i8042.c: d4 -> i8042 (command) [578]
Oct 29 15:08:32 darkstar kernel: [    6.020516] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [578]
Oct 29 15:08:32 darkstar kernel: [    6.023620] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [579]
Oct 29 15:08:32 darkstar kernel: [    6.023705] drivers/input/serio/i8042.c: d4 -> i8042 (command) [579]
Oct 29 15:08:32 darkstar kernel: [    6.023770] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [579]
Oct 29 15:08:32 darkstar kernel: [    6.026976] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [580]
Oct 29 15:08:32 darkstar kernel: [    6.027063] drivers/input/serio/i8042.c: d4 -> i8042 (command) [580]
Oct 29 15:08:32 darkstar kernel: [    6.027601] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [580]
Oct 29 15:08:32 darkstar kernel: [    6.030817] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [581]
Oct 29 15:08:32 darkstar kernel: [    6.030875] drivers/input/serio/i8042.c: d4 -> i8042 (command) [581]
Oct 29 15:08:32 darkstar kernel: [    6.030939] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [581]
Oct 29 15:08:32 darkstar kernel: [    6.034248] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [582]
Oct 29 15:08:32 darkstar kernel: [    6.037294] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 1, 12) [583]
Oct 29 15:08:32 darkstar kernel: [    6.037432] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [583]
Oct 29 15:08:32 darkstar kernel: [    6.037673] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [583]
Oct 29 15:08:32 darkstar kernel: [    6.037760] drivers/input/serio/i8042.c: d4 -> i8042 (command) [583]
Oct 29 15:08:32 darkstar kernel: [    6.037824] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [583]
Oct 29 15:08:32 darkstar kernel: [    6.040942] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [584]
Oct 29 15:08:32 darkstar kernel: [    6.041029] drivers/input/serio/i8042.c: d4 -> i8042 (command) [584]
Oct 29 15:08:32 darkstar kernel: [    6.041094] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [584]
Oct 29 15:08:32 darkstar kernel: [    6.044325] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [585]
Oct 29 15:08:32 darkstar kernel: [    6.044411] drivers/input/serio/i8042.c: d4 -> i8042 (command) [585]
Oct 29 15:08:32 darkstar kernel: [    6.044475] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [585]
Oct 29 15:08:32 darkstar kernel: [    6.047695] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [586]
Oct 29 15:08:32 darkstar kernel: [    6.047781] drivers/input/serio/i8042.c: d4 -> i8042 (command) [586]
Oct 29 15:08:32 darkstar kernel: [    6.047846] drivers/input/serio/i8042.c: f5 -> i8042 (parameter) [586]
Oct 29 15:08:32 darkstar kernel: [    6.051075] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [587]
Oct 29 15:08:32 darkstar kernel: [    6.051161] drivers/input/serio/i8042.c: d4 -> i8042 (command) [587]
Oct 29 15:08:32 darkstar kernel: [    6.051225] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [587]
Oct 29 15:08:32 darkstar kernel: [    6.054427] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [588]
Oct 29 15:08:32 darkstar kernel: [    6.054516] drivers/input/serio/i8042.c: d4 -> i8042 (command) [588]
Oct 29 15:08:32 darkstar kernel: [    6.054580] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [588]
Oct 29 15:08:32 darkstar kernel: [    6.057823] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [589]
Oct 29 15:08:32 darkstar kernel: [    6.057908] drivers/input/serio/i8042.c: d4 -> i8042 (command) [589]
Oct 29 15:08:32 darkstar kernel: [    6.057973] drivers/input/serio/i8042.c: ea -> i8042 (parameter) [589]
Oct 29 15:08:32 darkstar kernel: [    6.061698] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [590]
Oct 29 15:08:32 darkstar kernel: [    6.062978] input: PS/2 Mouse as /devices/platform/i8042/serio1/input/input6
Oct 29 15:08:32 darkstar kernel: [    6.086920] drivers/input/serio/i8042.c: d4 -> i8042 (command) [598]
Oct 29 15:08:32 darkstar kernel: [    6.086986] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [598]
Oct 29 15:08:32 darkstar kernel: [    6.087282] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [598]
Oct 29 15:08:32 darkstar kernel: [    6.087325] drivers/input/serio/i8042.c: d4 -> i8042 (command) [598]
Oct 29 15:08:32 darkstar kernel: [    6.087390] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [598]
Oct 29 15:08:32 darkstar kernel: [    6.092777] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [599]
Oct 29 15:08:32 darkstar kernel: [    6.092861] drivers/input/serio/i8042.c: d4 -> i8042 (command) [599]
Oct 29 15:08:32 darkstar kernel: [    6.092925] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [599]
Oct 29 15:08:32 darkstar kernel: [    6.093316] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [599]
Oct 29 15:08:32 darkstar kernel: [    6.093426] drivers/input/serio/i8042.c: d4 -> i8042 (command) [600]
Oct 29 15:08:32 darkstar kernel: [    6.093491] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [600]
Oct 29 15:08:32 darkstar kernel: [    6.098930] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [601]
Oct 29 15:08:32 darkstar kernel: [    6.099009] drivers/input/serio/i8042.c: d4 -> i8042 (command) [601]
Oct 29 15:08:32 darkstar kernel: [    6.099074] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [601]
Oct 29 15:08:32 darkstar kernel: [    6.102264] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [602]
Oct 29 15:08:32 darkstar kernel: [    6.102920] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio1/input/input7
Oct 29 15:08:32 darkstar kernel: [    6.126546] drivers/input/serio/i8042.c: d4 -> i8042 (command) [609]
Oct 29 15:08:32 darkstar kernel: [    6.126612] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [609]
Oct 29 15:08:32 darkstar kernel: [    6.129705] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [610]
Oct 29 15:08:32 darkstar kernel: [    6.129990] md: Waiting for all devices to be available before autodetect
Oct 29 15:08:32 darkstar kernel: [    6.152892] md: If you don't use raid, use raid=noautodetect
Oct 29 15:08:32 darkstar kernel: [    6.178277] md: Autodetecting RAID arrays.
Oct 29 15:08:32 darkstar kernel: [    6.189302] md: Scanned 0 and added 0 devices.
Oct 29 15:08:32 darkstar kernel: [    6.200230] md: autorun ...
Oct 29 15:08:32 darkstar kernel: [    6.211012] md: ... autorun DONE.
Oct 29 15:08:32 darkstar kernel: [    6.501012] kjournald starting.  Commit interval 5 seconds
Oct 29 15:08:32 darkstar kernel: [    6.501731] EXT3-fs: mounted filesystem with writeback data mode.
Oct 29 15:08:32 darkstar kernel: [    6.501973] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
Oct 29 15:08:32 darkstar kernel: [    6.566188] Freeing unused kernel memory: 384k freed
Oct 29 15:08:32 darkstar kernel: [    6.588717] Write protecting the kernel text: 3404k
Oct 29 15:08:32 darkstar kernel: [    6.599694] Write protecting the kernel read-only data: 1932k
Oct 29 15:08:32 darkstar kernel: [    8.993092] cdrom_id used greatest stack depth: 5856 bytes left
Oct 29 15:08:32 darkstar kernel: [    9.012525] cfg80211: Using static regulatory domain info
Oct 29 15:08:32 darkstar kernel: [    9.023380] cfg80211: Regulatory domain: US
Oct 29 15:08:32 darkstar kernel: [    9.033906] ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Oct 29 15:08:32 darkstar kernel: [    9.044924] ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.055982] ^I(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.066742] ^I(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.069530] ACPI: WMI: Mapper loaded
Oct 29 15:08:32 darkstar kernel: [    9.088499] ^I(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.099789] ^I(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.110511] ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
Oct 29 15:08:32 darkstar kernel: [    9.215994] cfg80211: Calling CRDA for country: US
Oct 29 15:08:32 darkstar kernel: [    9.576264] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
Oct 29 15:08:32 darkstar kernel: [    9.621094] b43-phy0 debug: Found PHY: Analog 6, Type 5, Revision 1
Oct 29 15:08:32 darkstar kernel: [    9.621119] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2062, Revision 2
Oct 29 15:08:32 darkstar kernel: [    9.643418] phy0: Selected rate control algorithm 'minstrel'
Oct 29 15:08:32 darkstar kernel: [    9.647010] Registered led device: b43-phy0::tx
Oct 29 15:08:32 darkstar kernel: [    9.668083] Registered led device: b43-phy0::rx
Oct 29 15:08:32 darkstar kernel: [    9.688675] Registered led device: b43-phy0::radio
Oct 29 15:08:32 darkstar kernel: [    9.698934] Broadcom 43xx driver loaded [ Features: PLS, Firmware-ID: FW13 ]
Oct 29 15:08:32 darkstar kernel: [   10.006303] ohci1394 0000:02:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Oct 29 15:08:32 darkstar kernel: [   10.083112] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[f67ff800-f67fffff]  Max Packet=[2048]  IR/IT contexts=[4/4]
Oct 29 15:08:32 darkstar kernel: [   10.189891] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Oct 29 15:08:32 darkstar kernel: [   10.211309] HDA Intel 0000:00:1b.0: setting latency timer to 64
Oct 29 15:08:32 darkstar kernel: [   10.659098] Adding 2008084k swap on /dev/sda8.  Priority:-1 extents:1 across:2008084k 
Oct 29 15:08:32 darkstar kernel: [   11.373895] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[464fc0001679c05c]
Oct 29 15:08:32 darkstar kernel: [   12.833903] EXT3 FS on sda2, internal journal
Oct 29 15:08:32 darkstar kernel: [   17.492595] kjournald starting.  Commit interval 5 seconds
Oct 29 15:08:32 darkstar kernel: [   17.493282] EXT3 FS on sda3, internal journal
Oct 29 15:08:32 darkstar kernel: [   17.493315] EXT3-fs: mounted filesystem with writeback data mode.

> 
> -- 
> Dmitry
