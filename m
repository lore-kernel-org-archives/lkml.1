Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbXF0Qsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbXF0Qsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXF0Qsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:48:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:56569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbXF0Qsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:48:38 -0400
Message-ID: <468294E4.40801@anagramm.de>
Date: Wed, 27 Jun 2007 18:48:36 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.21.5: BUG: usbtouchscreen.c DMC TSC-10 wrong descriptor type
 / type->init() failed.
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX18rBAZLMrpBuQ2AsqnHTvogF6dQL9seBHfaKaf
 WnbHSbhfiQ6emmVmg238UxjWqLoWwA3aYiLm0v3cTT6FtFhR5F
 PyU4ftXvmpIubbSdv6EYw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again!

Well, with lots of debugging enabled, I got to some more details about the
non working DMC TSC-10 USB Touchscreen:

(see also: http://lkml.org/lkml/2007/6/26/228 )

Whenever I plug in the TSC-10 I get the following output

hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0004
ehci_hcd 0000:00:14.2: GetStatus port 2 status 001403 POWER sig=k CSC CONNECT
hub 3-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:14.2: port 2 low speed --> companion
ehci_hcd 0000:00:14.2: GetStatus port 2 status 003402 POWER OWNER sig=k CSC
hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0004
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
ohci_hcd 0000:00:14.1: GetStatus roothub.portstatus [0] = 0x00010301 CSC LSDA PPS CCS
hub 2-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
ohci_hcd 0000:00:14.1: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
usb 2-1: new low speed USB device using ohci_hcd and address 16
ohci_hcd 0000:00:14.1: GetStatus roothub.portstatus [0] = 0x00100303 PRSC LSDA PPS PES CCS
usb 2-1: default language 0x0054
usb 2-1: wrong descriptor type 00 for string 1 ("TSC-10 DM")
usb 2-1: new device strings: Mfr=1, Product=0, SerialNumber=0
usb 2-1: Manufacturer: TSC-10 DM
usb 2-1: uevent
usb 2-1: usb_probe_device
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: adding 2-1:1.0 (config #1, interface 0)
usb 2-1:1.0: uevent
usbtouchscreen 2-1:1.0: usb_probe_interface
usbtouchscreen 2-1:1.0: usb_probe_interface - got id
drivers/usb/input/usbtouchscreen.c: usbtouch_probe - type->init() failed, err: -19
drivers/usb/core/inode.c: creating file '016'
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002


And when I unplug it, it cleans up the device properly:

hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0002
ohci_hcd 0000:00:14.1: GetStatus roothub.portstatus [0] = 0x00010100 CSC PPS
hub 2-0:1.0: port 1, status 0100, change 0001, 12 Mb/s
usb 2-1: USB disconnect, address 16
usb 2-1: unregistering device
usb 2-1: usb_disable_device nuking all URBs
usb 2-1: unregistering interface 2-1:1.0
  usbdev2.16_ep81: ep_device_release called for usbdev2.16_ep81
usb 2-1:1.0: uevent
  usbdev2.16_ep00: ep_device_release called for usbdev2.16_ep00
usb 2-1: uevent
hub 2-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x100

Any ideas of what's wrong here before I have to start to
dig deeper in the source?!

The touchscreen controller chip is a TSC-103 088 F3J0
it has no EEPROM attached. (which should be optional to save
calibration data)
The USB controller is a Philips ISP1563BM PCI Host Controller
DateCode April-2006.

The same problem appears with 2.6.21.5 and 2.6.20.1-ubuntu-something
on x86 platform.

-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
