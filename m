Return-Path: <linux-kernel-owner+w=401wt.eu-S1030506AbXCLQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030506AbXCLQLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030512AbXCLQLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:11:42 -0400
Received: from rtr.ca ([64.26.128.89]:2244 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030506AbXCLQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:11:38 -0400
Message-ID: <45F57BB8.5010705@rtr.ca>
Date: Mon, 12 Mar 2007 12:11:36 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de> <45F56E37.9050506@rtr.ca> <20070312152920.GA29597@kroah.com> <45F579CF.7040802@rtr.ca>
In-Reply-To: <45F579CF.7040802@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Greg KH wrote:
>> Does userspace have it open when you suspend/resume?
> 
> For the ooops I just posted, yes, I may have left Linux ckermit
> running on the serial port before the suspend.

Here's a retest under linux-2.6.21-rc3-git7,
doing suspend/resume (RAM) with ckermit open on the serial port.

(LONG, Ooops at the bottom).

12:06:54 kernel: Stopping tasks ... done.
12:06:54 kernel: Suspending console(s)
12:06:54 kernel: pl2303 5-5.3:1.0: no suspend for driver pl2303?
12:06:54 kernel: ACPI: PCI interrupt for device 0000:03:01.2 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:03:00.0 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1f.2 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1e.2 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1d.7 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1d.3 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1d.2 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1d.1 disabled
12:06:54 kernel: ACPI: PCI interrupt for device 0000:00:1d.0 disabled
12:06:54 kernel: Intel machine check architecture supported.
12:06:54 kernel: Intel machine check reporting enabled on CPU#0.
12:06:54 kernel: Back to C!
12:06:54 kernel: PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 2000d0d0, writing d0d0)
12:06:54 kernel: PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10010)
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:01.0 to 64
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1d.0 to 64
12:06:54 kernel: usb usb1: root hub lost power or was reset
12:06:54 kernel: PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 18
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1d.1 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20a)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.1 at offset 8 (was 1, writing bf61)
12:06:54 kernel: usb usb2: root hub lost power or was reset
12:06:54 kernel: PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1d.2 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 309)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.2 at offset 8 (was 1, writing bf41)
12:06:54 kernel: usb usb3: root hub lost power or was reset
12:06:54 kernel: PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 17
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1d.3 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 407)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1d.3 at offset 8 (was 1, writing bf21)
12:06:54 kernel: usb usb4: root hub lost power or was reset
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 16 (level, low) -> IRQ 16
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1d.7 to 64
12:06:54 kernel: usb usb5: root hub lost power or was reset
12:06:54 kernel: ehci_hcd 0000:00:1d.7: debug port 1
12:06:54 kernel: PCI: cache line size of 32 is not supported by device 0000:00:1d.7
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001, writing 8bf18801)
12:06:54 NetworkManager: <information>^ISWITCH: terminating current connection 'eth0' because it's no longer valid. 
12:06:54 NetworkManager: <information>^IDeactivating device eth0. 
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, writing dfc0dfc0)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 2280e0f0, writing 22802020)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 6 (was 20030300, writing 20070300)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100107)
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1e.0 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset f (was 100, writing 10b)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 7 (was 0, writing dffffd00)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 6 (was 0, writing dffffe00)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 5 (was 1, writing ec41)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 4 (was 1, writing ed01)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1e.2 at offset 1 (was 2900000, writing 2900003)
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 16 (level, low) -> IRQ 16
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1e.2 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1f.0 at offset 1 (was 2000007, writing 2000107)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 20a)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1f.2 at offset 9 (was d0000, writing 0)
12:06:54 kernel: ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 18
12:06:54 kernel: PCI: Setting latency timer of device 0000:00:1f.2 to 64
12:06:54 kernel: PM: Writing back config space on device 0000:00:1f.3 at offset f (was 200, writing 20a)
12:06:54 kernel: PM: Writing back config space on device 0000:00:1f.3 at offset 1 (was 2800001, writing 2800101)
12:06:54 kernel: PM: Writing back config space on device 0000:01:00.0 at offset f (was 1ff, writing 10b)
12:06:54 kernel: PM: Writing back config space on device 0000:01:00.0 at offset c (was 0, writing dfe00000)
12:06:54 kernel: PM: Writing back config space on device 0000:01:00.0 at offset 3 (was 0, writing 10)
12:06:54 kernel: ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
12:06:54 kernel: PM: Writing back config space on device 0000:03:00.0 at offset f (was 100, writing 109)
12:06:54 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 0, writing dfcfe000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 4000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100106)
12:06:54 kernel: ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 19
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset f (was 7800100, writing 58001ff)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset e (was 0, writing 24fc)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset d (was 0, writing 2400)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset c (was 0, writing 20fc)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset b (was 0, writing 2000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset a (was 0, writing 8ffff000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 9 (was 0, writing 8c000000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 8 (was 0, writing 8bfff000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 7 (was 0, writing 88000000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 6 (was 0, writing b0070403)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 4 (was 0, writing dfc00000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.0 at offset 3 (was 820000, writing 82a800)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 4 (was 0, writing dfcfc800)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 3 (was 800000, writing 804000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.1 at offset 1 (was 2100000, writing 2100106)
12:06:54 kernel: ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[dfcfc800-dfcfcfff]  Max Packet=[2048]  IR/IT contexts=[4/4]
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 4 (was 0, writing dfcfc700)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 3 (was 800000, writing 804000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:01.2 at offset 1 (was 2100000, writing 2100106)
12:06:54 kernel: ACPI: PCI Interrupt 0000:03:01.2[C] -> GSI 17 (level, low) -> IRQ 18
12:06:54 kernel: PM: Writing back config space on device 0000:03:03.0 at offset f (was 18030100, writing 1803010a)
12:06:54 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 4 (was 0, writing dfcfd000)
12:06:54 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 3 (was 0, writing 4010)
12:06:54 kernel: PM: Writing back config space on device 0000:03:03.0 at offset 1 (was 2900000, writing 2900112)
12:06:54 kernel: pnp: Device 00:04 does not support activation.
12:06:54 kernel: pnp: Device 00:05 does not support activation.
12:06:54 kernel:  usbdev5.2_ep00: PM: resume from 0, parent 5-5 still 2
12:06:54 kernel: hub 5-5:1.0: PM: resume from 2, parent 5-5 still 2
12:06:54 kernel:  usbdev5.2_ep81: PM: resume from 0, parent 5-5:1.0 still 2
12:06:54 kernel:  usbdev5.2: PM: resume from 0, parent 5-5 still 2
12:06:54 kernel: usb 5-5.3: PM: resume from 2, parent 5-5 still 2
12:06:54 kernel:  usbdev5.3_ep00: PM: resume from 0, parent 5-5.3 still 2
12:06:54 kernel: pl2303 5-5.3:1.0: PM: resume from 2, parent 5-5.3 still 2
12:06:54 kernel:  usbdev5.3_ep81: PM: resume from 0, parent 5-5.3:1.0 still 2
12:06:54 kernel:  usbdev5.3_ep02: PM: resume from 0, parent 5-5.3:1.0 still 2
12:06:54 kernel:  usbdev5.3_ep83: PM: resume from 0, parent 5-5.3:1.0 still 2
12:06:54 kernel:  usbdev5.3: PM: resume from 0, parent 5-5.3 still 2
12:06:54 kernel: usb 5-5.4: PM: resume from 2, parent 5-5 still 2
12:06:54 kernel:  usbdev5.4_ep00: PM: resume from 0, parent 5-5.4 still 2
12:06:54 kernel: usbhid 5-5.4:1.0: PM: resume from 2, parent 5-5.4 still 2
12:06:54 kernel:  usbdev5.4_ep81: PM: resume from 0, parent 5-5.4:1.0 still 2
12:06:54 kernel:  usbdev5.4: PM: resume from 0, parent 5-5.4 still 2
12:06:54 kernel: pl2303 ttyUSB0: PM: resume from 0, parent 5-5.3:1.0 still 2
12:06:54 kernel: Restarting tasks ... done.
12:06:54 kernel: usb 5-5: USB disconnect, address 2
12:06:54 kernel: usb 5-5.3: USB disconnect, address 3
12:06:54 kernel: pl2303 5-5.3:1.0: device disconnected
12:06:54 kernel: usb 5-5.4: USB disconnect, address 4
12:06:54 kernel: ata1.00: configured for UDMA/100
12:06:54 kernel: SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
12:06:54 kernel: sda: Write Protect is off
12:06:54 kernel: sda: Mode Sense: 00 3a 00 00
12:06:54 dhclient: DHCPRELEASE on eth0 to 10.0.0.2 port 67
12:06:54 kernel: SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
12:06:54 dhcdbd: dhco_value_from_text: Non ascii char outside valid hex string:  0 
12:06:54 dhcdbd: dhco_input_option: Value silvy cannot be converted to type X 
12:06:54 dhcdbd: dhco_parse_option_settings: bad option setting: old_host_name = silvy 
12:06:54 kernel: usb 5-5: new high speed USB device using ehci_hcd and address 5
12:06:54 kernel: usb 5-5: configuration #1 chosen from 1 choice
12:06:55 kernel: hub 5-5:1.0: USB hub found
12:06:55 kernel: hub 5-5:1.0: 4 ports detected
12:06:55 kernel: ata2.00: configured for UDMA/33
12:06:55 kernel: [drm] Loading R300 Microcode
12:06:55 kernel: usb 5-5.3: new full speed USB device using ehci_hcd and address 6
12:06:55 kernel: usb 5-5.3: configuration #1 chosen from 1 choice
12:06:55 kernel: pl2303 5-5.3:1.0: pl2303 converter detected
12:06:55 kernel: usb 5-5.3: pl2303 converter now attached to ttyUSB1
12:06:55 NetworkManager: nm_device_is_802_3_ethernet: assertion `dev != NULL' failed
12:06:55 NetworkManager: nm_device_is_802_11_wireless: assertion `dev != NULL' failed
12:06:55 NetworkManager: <information>^Imatch 
12:06:55 NetworkManager: <information>^Imatch 
12:06:55 kernel: usb 5-5.4: new low speed USB device using ehci_hcd and address 7
12:06:55 kernel: usb 5-5.4: configuration #1 chosen from 1 choice
12:06:55 kernel: input: Logitech Optical USB Mouse as /class/input/input8
12:06:55 kernel: input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-5.4
12:06:56 kernel: b44: eth0: Link is up at 100 Mbps, full duplex.
12:06:56 kernel: b44: eth0: Flow control is off for TX and off for RX.
12:06:56 NetworkManager: <information>^IWill activate wired connection 'eth0' because it now has a link. 
12:06:56 NetworkManager: <information>^ISWITCH: no current connection, found better connection 'eth0'. 
12:06:56 NetworkManager: <information>^IWill activate connection 'eth0'. 
12:06:56 NetworkManager: <information>^IDevice eth0 activation scheduled... 
12:06:56 NetworkManager: <information>^IActivation (eth0) started... 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) scheduled... 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) started... 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) scheduled... 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 1 of 5 (Device Prepare) complete. 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) starting... 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) successful. 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) scheduled. 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 2 of 5 (Device Configure) complete. 
12:06:56 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) started... 
12:06:56 NetworkManager: <information>^Imatch 
12:06:57 NetworkManager: <information>^IActivation (eth0) Beginning DHCP transaction. 
12:06:57 NetworkManager: <information>^IActivation (eth0) Stage 3 of 5 (IP Configure Start) complete. 
12:06:57 NetworkManager: <information>^IDHCP daemon state is now 12 (successfully started) for interface eth0 
12:06:58 NetworkManager: <information>^IDHCP daemon state is now 1 (starting) for interface eth0 
12:06:59 dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 3
12:06:59 dhclient: DHCPOFFER from 10.0.0.2
12:06:59 dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
12:06:59 dhclient: DHCPACK from 10.0.0.2
12:06:59 dhclient: bound to 10.0.0.14 -- renewal in 34884 seconds.
12:06:59 kernel: pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
12:06:59 kernel: BUG: unable to handle kernel NULL pointer dereference at virtual address 00000168
12:06:59 kernel:  printing eip:
12:06:59 kernel: f89fe1f6
12:06:59 kernel: *pde = 00000000
12:06:59 kernel: Oops: 0000 [#1]
12:06:59 kernel: PREEMPT 
12:06:59 kernel: Modules linked in: radeon drm nfsd exportfs lockd nfs_acl sunrpc acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_stats freq_table cpufreq_conservative ac fan button thermal video battery container processor rfcomm l2cap bluetooth cfq_iosched deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key af_packet sbp2 usbhid hid pl2303 usbserial mousedev pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer ipw2200 snd ieee80211 ieee80211_crypt ohci1394 serio_raw psmouse soundcore snd_page_alloc pcspkr sdhci firmware_class ahci ieee1394 yenta_socket rsrc_nonstatic pcmcia_core ehci_hcd mmc_core b44 mii uhci_hcd usbcore intel_agp agpgart sg sr_mod cdrom unix
12:06:59 kernel: CPU:    0
12:06:59 kernel: EIP:    0060:[<f89fe1f6>]    Not tainted VLI
12:06:59 kernel: EFLAGS: 00010297   (2.6.21-rc3-git7 #7)
12:06:59 kernel: EIP is at pl2303_shutdown+0x37/0x70 [pl2303]
12:06:59 kernel: eax: 00000000   ebx: f7560d80   ecx: c20df5c0   edx: f89fe1bf
12:06:59 kernel: esi: f7560d80   edi: 00000000   ebp: f7560d80   esp: f5d45e78
12:06:59 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
12:06:59 kernel: Process kermit (pid: 4403, ti=f5d44000 task=f5cdb0b0 task.ti=f5d44000)
12:06:59 kernel: Stack: c01ab1b5 f7b39a78 00000000 f7560d80 00000001 00000000 00000000 f8a29ca1 
12:06:59 kernel:        00200200 f7b39a00 f7b39a08 f5f71bc0 f7560db4 f8a29c18 c01ab1b5 c01e5b0c 
12:06:59 kernel:        f5f634cc f5f63400 f5f63400 f5f63400 f5f71bc0 c01e7758 f6c4bc40 c0138a0a 
12:06:59 kernel: Call Trace:
12:06:59 kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
12:06:59 kernel:  [<f8a29ca1>] destroy_serial+0x89/0x122 [usbserial]
12:06:59 kernel:  [<f8a29c18>] destroy_serial+0x0/0x122 [usbserial]
12:06:59 kernel:  [kref_put+95/110] kref_put+0x5f/0x6e
12:06:59 kernel:  [tty_fasync+60/180] tty_fasync+0x3c/0xb4
12:06:59 kernel:  [release_dev+484/1496] release_dev+0x1e4/0x5d8
12:06:59 kernel:  [find_get_page+21/69] find_get_page+0x15/0x45
12:06:59 kernel:  [filemap_nopage+385/726] filemap_nopage+0x181/0x2d6
12:06:59 kernel:  [pty_write+43/53] pty_write+0x2b/0x35
12:06:59 kernel:  [getnstimeofday+48/216] getnstimeofday+0x30/0xd8
12:06:59 kernel:  [enqueue_hrtimer+256/268] enqueue_hrtimer+0x100/0x10c
12:06:59 kernel:  [tty_release+15/24] tty_release+0xf/0x18
12:06:59 kernel:  [__fput+150/336] __fput+0x96/0x150
12:06:59 kernel:  [filp_close+79/86] filp_close+0x4f/0x56
12:06:59 kernel:  [sys_close+117/183] sys_close+0x75/0xb7
12:06:59 kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
12:06:59 kernel:  =======================
12:06:59 kernel: Code: 2c a0 f8 00 74 1c c7 44 24 08 2f 04 a0 f8 c7 44 24 04 33 05 a0 f8 c7 04 24 09 06 a0 f8 e8 8f 9e 71 c7 89 ee 31 ff eb 2c 8b 46 14 <8b> 98 68 01 00 00 85 db 74 1b 8b 03 e8 f9 fd ff ff 89 d8 e8 95 
12:06:59 kernel: EIP: [<f89fe1f6>] pl2303_shutdown+0x37/0x70 [pl2303] SS:ESP 0068:f5d45e78
