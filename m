Return-Path: <linux-kernel-owner+w=401wt.eu-S2992511AbXCGToY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992511AbXCGToY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:44:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992514AbXCGToY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:44:24 -0500
Received: from rtr.ca ([64.26.128.89]:3685 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992511AbXCGToW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:44:22 -0500
Message-ID: <45EF161B.6050404@rtr.ca>
Date: Wed, 07 Mar 2007 14:44:27 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Tejun Heo <htejun@gmail.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: regression: SATA dead after resume from RAM 2.6.21-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mmm.. like others, I've now been bitten by what looks like
a SATA failure on resume from RAM, with 2.6.21-rc3.

I don't have enough info to blame this specific -rc* kernel,
as it has only done it once to me so far.

So, a datapoint, but not much of clue beyond that.
Unless it happens again.

Yes, the GUI did come back from suspend, but the disk
(ICH6M) did not seem want to talk to anything afterwards,
and the system hung on a manual "alt-sysrq-Sync".
I waited only about a minute or so before rebooting.

Here's the lspci and the last kernel logs from around
the suspend/resume before I rebooted.

# lspci
0000:00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to DRAM Controller (rev 03)
0000:00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI Express Root Port (rev 03)
0000:00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1 (rev 03)
0000:00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2 (rev 03)
0000:00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3 (rev 03)
0000:00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4 (rev 03)
0000:00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller (rev 03)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
0000:00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio Controller (rev 03)
0000:00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
0000:00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 03)
0000:00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus Controller (rev 03)
0000:01:00.0 VGA compatible controller: ATI Technologies Inc M22 [Radeon Mobility M300]
0000:03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
0000:03:01.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
0000:03:01.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
0000:03:01.2 0805: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 17)
0000:03:03.0 Network controller: Intel Corporation PRO/Wireless 2915ABG MiniPCI Adapter (rev 05)

14:28:37 gconfd (root-10138): starting (version 2.14.0), pid 10138 user 'root'
14:28:37 gconfd (root-10138): Resolved address "xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only configuration source at position 0
14:28:37 gconfd (root-10138): Resolved address "xml:readwrite:/root/.gconf" to a writable configuration source at position 1
14:28:37 gconfd (root-10138): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only configuration source at position 2
14:28:37 gconfd (root-10138): Resolved address "xml:readonly:/var/lib/gconf/debian.defaults" to a read-only configuration source at position 3
14:28:37 gconfd (root-10138): Resolved address "xml:readonly:/var/lib/gconf/defaults" to a read-only configuration source at position 4
14:32:43 gconfd (root-10138): GConf server is not in use, shutting down.
14:32:43 gconfd (root-10138): Exiting
14:32:43 kernel: Stopping tasks ... done.
14:32:43 kernel: Suspending console(s)
14:32:43 kernel: pl2303 5-1.3:1.0: no suspend for driver pl2303?
14:32:43 kernel: ACPI: PCI interrupt for device 0000:03:01.2 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1e.2 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
14:32:43 kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
14:32:43 kernel: Intel machine check architecture supported.
14:32:43 kernel: Intel machine check reporting enabled on CPU#0.
14:32:43 kernel: Back to C!
14:32:43 kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
14:32:43 kernel: usb usb1: root hub lost power or was reset
14:32:43 kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 18
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20a)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
14:32:43 kernel: usb usb2: root hub lost power or was reset
14:32:43 kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
14:32:43 kernel: usb usb3: root hub lost power or was reset
14:32:43 kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 17
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
14:32:43 kernel: usb usb4: root hub lost power or was reset
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 16
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
14:32:43 kernel: usb usb5: root hub lost power or was reset
14:32:43 kernel: ehci_hcd 0000:00:1d.7: debug port 1
14:32:43 kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001, writing 8bf18801)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, writing dfc0dfc0)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 22802020)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20030300, writing 20070300)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100107)
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset f (was 100, writing 10b)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 7 (was 0, writing dffffd00)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 6 (was 0, writing dffffe00)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 5 (was 1, writing ec41)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 4 (was 1, writing ed01)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 1 (was 2900000, writing 2900003)
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 16 (level, low) -> IRQ 16
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1e.2 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2000007, writing 2000107)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 20a)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1f.2 at offset 9 (was d0000, writing 0)
14:32:43 kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 18
14:32:43 kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
14:32:43 kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 20a)
14:32:43 kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
14:32:43 kernel: PM: Writing back config space on device 0000:01:00.0 at offset f (was 1ff, writing 10b)
14:32:43 kernel: PM: Writing back config space on device 0000:01:00.0 at offset c (was 0, writing dfe00000)
14:32:43 kernel: PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 10)
14:32:43 kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
14:32:43 kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 109)
14:32:43 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing dfcfe000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
14:32:43 kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 19
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 7800100, writing 58001ff)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset e (was 0, writing 24fc)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset d (was 0, writing 2400)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset c (was 0, writing 20fc)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset b (was 0, writing 2000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset a (was 0, writing 8ffff000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 9 (was 0, writing 8c000000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 8 (was 0, writing 8bfff000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 7 (was 0, writing 88000000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 6 (was 0, writing b0070403)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing dfc00000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 820000, writing 82a800)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing dfcfc800)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
14:32:43 kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfcfc800-dfcfcfff]  Max Packet=[2048]  IR/IT contexts=[4/4]
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing dfcfc700)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 3 (was 800000, writing 804000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
14:32:43 kernel: ACPI: PCI Interrupt 0000:03:01.2[C] -> GSI 17 (level, low) -> IRQ 18
14:32:43 kernel: PM: Writing back config space on device 0000:03:03.0 at offset f (was 18030100, writing 1803010a)
14:32:43 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 4 (was 0, writing dfcfd000)
14:32:43 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 3 (was 0, writing 4010)
14:32:43 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 1 (was 2900000, writing 2900112)
14:32:43 kernel: pnp: Device 00:04 does not support activation.
14:32:43 kernel: pnp: Device 00:05 does not support activation.
14:32:43 kernel:  usbdev5.11_ep00: PM: resume from 0, parent 5-1 still 2
14:32:43 kernel: hub 5-1:1.0: PM: resume from 2, parent 5-1 still 2
14:32:43 kernel:  usbdev5.11_ep81: PM: resume from 0, parent 5-1:1.0 still 2
14:32:43 kernel:  usbdev5.11: PM: resume from 0, parent 5-1 still 2
14:32:43 kernel: usb 5-1.3: PM: resume from 2, parent 5-1 still 2
14:32:43 kernel:  usbdev5.12_ep00: PM: resume from 0, parent 5-1.3 still 2
14:32:43 kernel: pl2303 5-1.3:1.0: PM: resume from 2, parent 5-1.3 still 2
14:32:43 kernel: pl2303 ttyUSB0: PM: resume from 0, parent 5-1.3:1.0 still 2
14:32:43 kernel:  usbdev5.12_ep81: PM: resume from 0, parent 5-1.3:1.0 still 2
14:32:43 kernel:  usbdev5.12_ep02: PM: resume from 0, parent 5-1.3:1.0 still 2
14:32:43 kernel:  usbdev5.12_ep83: PM: resume from 0, parent 5-1.3:1.0 still 2
14:32:43 kernel:  usbdev5.12: PM: resume from 0, parent 5-1.3 still 2
14:32:43 kernel: usb 5-1.4: PM: resume from 2, parent 5-1 still 2
14:32:43 kernel:  usbdev5.13_ep00: PM: resume from 0, parent 5-1.4 still 2
14:32:43 kernel: usbhid 5-1.4:1.0: PM: resume from 2, parent 5-1.4 still 2
14:32:43 kernel:  usbdev5.13_ep81: PM: resume from 0, parent 5-1.4:1.0 still 2
14:32:43 kernel:  usbdev5.13: PM: resume from 0, parent 5-1.4 still 2
14:32:43 kernel: Restarting tasks ... done.
14:32:43 NetworkManager: <information>^ISWITCH: terminating current connection 'eth0' because it's no longer valid. 
14:32:43 NetworkManager: <information>^IDeactivating device eth0. 
14:32:44 kernel: usb 5-1: USB disconnect, address 11
14:32:44 kernel: usb 5-1.3: USB disconnect, address 12
14:32:44 kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
14:32:44 kernel: pl2303 5-1.3:1.0: device disconnected
14:32:44 kernel: usb 5-1.4: USB disconnect, address 13
14:32:44 kernel: ata1.00: configured for UDMA/100
14:32:44 kernel: SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
14:32:44 kernel: sda: Write Protect is off
14:32:44 kernel: sda: Mode Sense: 00 3a 00 00
14:32:44 kernel: SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
14:32:44 dhclient: DHCPRELEASE on eth0 to 10.0.0.2 port 67
14:32:44 kernel: usb 5-1: new high speed USB device using ehci_hcd and address 14
14:32:44 dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
14:32:44 dhcdbd: dhco_input_option: Value silvy cannot be converted to type X 
14:32:44 dhcdbd: dhco_parse_option_settings: bad option setting: old_host_name = silvy 
14:32:44 kernel: usb 5-1: configuration #1 chosen from 1 choice
14:32:44 kernel: hub 5-1:1.0: USB hub found
14:32:44 kernel: hub 5-1:1.0: 4 ports detected
14:32:44 kernel: ata2.00: configured for UDMA/33
14:32:44 kernel: [drm] Loading R300 Microcode
14:32:44 kernel: usb 5-1.3: new full speed USB device using ehci_hcd and address 15
14:32:44 kernel: usb 5-1.3: configuration #1 chosen from 1 choice
14:32:44 kernel: pl2303 5-1.3:1.0: pl2303 converter detected
14:32:44 kernel: usb 5-1.3: pl2303 converter now attached to ttyUSB0
14:32:44 NetworkManager: nm_device_is_802_3_ethernet: assertion `dev != NULL' failed
14:32:44 NetworkManager: nm_device_is_802_11_wireless: assertion `dev != NULL' failed
14:32:44 NetworkManager: <information>^Imatch 
14:32:44 NetworkManager: <information>^Imatch 
14:32:45 kernel: usb 5-1.4: new low speed USB device using ehci_hcd and address 16
14:32:45 kernel: usb 5-1.4: configuration #1 chosen from 1 choice
14:32:45 kernel: input: Logitech Optical USB Mouse as /class/input/input11
14:32:45 kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-1.4
14:32:46 kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
14:32:46 kernel: b44: eth0: Flow control is off for TX and off for RX.
14:32:46 NetworkManager: <information>^IWill activate wired connection 'eth0' because it now has a link. 
14:32:46 NetworkManager: <information>^ISWITCH: no current connection, found better connection 'eth0'. 
14:32:46 NetworkManager: <information>^IWill activate connection 'eth0'. 
14:32:46 NetworkManager: <information>^IDevice eth0 activation scheduled... 
14:32:46 NetworkManager: <information>^IActivation (eth0) started... 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) scheduled... 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) started... 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) scheduled... 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) complete. 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) starting... 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) successful. 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) scheduled. 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) complete. 
14:32:46 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) started... 
14:32:46 NetworkManager: <information>^Imatch 
14:32:47 NetworkManager: <information>^IActivation (eth0) Beginning DHCP transaction. 
14:32:47 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) complete. 
14:32:47 NetworkManager: <information>^IDHCP daemon state is now 12 (successfully started) for interface eth0 
14:32:47 gconfd (root-10312): starting (version 2.14.0), pid 10312 user 'root'
14:32:47 gconfd (root-10312): Resolved address "xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only configuration source at position 0
14:32:47 gconfd (root-10312): Resolved address "xml:readwrite:/root/.gconf" to a writable configuration source at position 1
14:32:47 gconfd (root-10312): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only configuration source at position 2
14:32:47 gconfd (root-10312): Resolved address "xml:readonly:/var/lib/gconf/debian.defaults" to a read-only configuration source at position 3
14:32:47 gconfd (root-10312): Resolved address "xml:readonly:/var/lib/gconf/defaults" to a read-only configuration source at position 4
14:32:48 NetworkManager: <information>^IDHCP daemon state is now 1 (starting) for interface eth0 
