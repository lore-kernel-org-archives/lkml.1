Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbYJNHkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbYJNHkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYJNHkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:40:24 -0400
Received: from moog.chdir.org ([88.191.42.160]:60765 "EHLO moog.chdir.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbYJNHkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:40:23 -0400
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 03:40:22 EDT
Date: Tue, 14 Oct 2008 09:20:45 +0200
From: Nicolas Bareil <nico@chdir.org>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: USB problem on x86_64: nommu_map_single() issue?
Message-ID: <20081014072045.GA1252@sd-5945.dedibox.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 2.6.27, I can't use any USB device (mass storage, mouse) anymore on my x86_64 system, the devices
are not detected: lsusb returns nothing except the hub.

I have the following logs in kern.log when booting with my USB mouse plugged :

Oct 13 15:43:48 brew kernel: USB Universal Host Controller Interface driver v3.0
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.0: setting latency timer to 64
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.0: irq 16, io base 0x00002000
Oct 13 15:43:48 brew kernel: usb usb1: configuration #1 chosen from 1 choice
Oct 13 15:43:48 brew kernel: hub 1-0:1.0: USB hub found
Oct 13 15:43:48 brew kernel: hub 1-0:1.0: 2 ports detected
Oct 13 15:43:48 brew kernel: intel_rng: Firmware space is locked read-only. If you can't or
Oct 13 15:43:48 brew kernel: intel_rng: don't want to disable this in firmware setup, and if
Oct 13 15:43:48 brew kernel: intel_rng: you are certain that your system has a functional
Oct 13 15:43:48 brew kernel: intel_rng: RNG, try using the 'no_fwh_detect' option.
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.1: setting latency timer to 64
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002020
Oct 13 15:43:48 brew kernel: usb usb2: configuration #1 chosen from 1 choice
Oct 13 15:43:48 brew kernel: hub 2-0:1.0: USB hub found
Oct 13 15:43:48 brew kernel: hub 2-0:1.0: 2 ports detected
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.2: setting latency timer to 64
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
Oct 13 15:43:48 brew kernel: usb usb3: configuration #1 chosen from 1 choice
Oct 13 15:43:48 brew kernel: hub 3-0:1.0: USB hub found
Oct 13 15:43:48 brew kernel: hub 3-0:1.0: 2 ports detected
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 22 (level, low) -> IRQ 22
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.3: setting latency timer to 64
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.3: UHCI Host Controller
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Oct 13 15:43:48 brew kernel: uhci_hcd 0000:00:1d.3: irq 22, io base 0x00002060
Oct 13 15:43:48 brew kernel: usb usb4: configuration #1 chosen from 1 choice
Oct 13 15:43:48 brew kernel: hub 4-0:1.0: USB hub found
Oct 13 15:43:48 brew kernel: hub 4-0:1.0: 2 ports detected
Oct 13 15:43:48 brew kernel: usb 2-1: new low speed USB device using uhci_hcd and address 2
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e8b78e0+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11f0fd480+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e8b78e0+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11f0fd480+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e8b78e0+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11f0fd480+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Oct 13 15:43:48 brew kernel: HDA Intel 0000:00:1b.0: setting latency timer to 64
Oct 13 15:43:48 brew kernel: usb 2-1: device descriptor read/64, error -32
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: setting latency timer to 64
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: debug port 1
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: irq 16, io mem 0xf0204000
Oct 13 15:43:48 brew kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Oct 13 15:43:48 brew kernel: usb usb5: configuration #1 chosen from 1 choice
Oct 13 15:43:48 brew kernel: hub 5-0:1.0: USB hub found
Oct 13 15:43:48 brew kernel: hub 5-0:1.0: 8 ports detected
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e9de620+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11ed07d80+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e9de620+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11ed07d80+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 12e9de620+8 of device mask ffffffff
Oct 13 15:43:48 brew kernel: nommu_map_single: overflow 11ed07d80+64 of device mask ffffffff
Oct 13 15:43:48 brew kernel: hub 2-0:1.0: unable to enumerate USB device on port 1
...

The whole kern.log and my config are available here :
 http://chdir.org/~nbareil/kern.log
 http://chdir.or/~nbareil/config-2.6.27-brew

Thanks!

