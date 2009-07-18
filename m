Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZGRUFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZGRUFP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZGRUFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:05:13 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:35569 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZGRUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:05:13 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: 2.6.31-rc3: replugging USB serial converter uses new device node
Date: Sat, 18 Jul 2009 22:04:57 +0200
Message-ID: <87zlb1u592.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
keeps increasing on each replug.  Output of udevadm monitor:

==poff==
UEVENT[1247946169.580772] remove   /devices/virtual/net/ppp0 (net)
UDEV  [1247946169.589775] remove   /devices/virtual/net/ppp0 (net)
==unplug==
UEVENT[1247946186.700698] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
UEVENT[1247946186.700737] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
UEVENT[1247946186.700749] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
UEVENT[1247946186.700760] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
UEVENT[1247946186.700771] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
UDEV  [1247946186.701535] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
UDEV  [1247946186.705822] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
UDEV  [1247946186.711662] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
UDEV  [1247946186.715237] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
UDEV  [1247946186.718872] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
==replug==
UEVENT[1247946199.654628] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
UDEV  [1247946199.660946] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
UEVENT[1247946199.661096] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
UEVENT[1247946199.688206] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
UEVENT[1247946199.688254] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
UEVENT[1247946199.688266] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
UDEV  [1247946199.710642] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
UDEV  [1247946199.713898] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
UDEV  [1247946199.729618] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
UDEV  [1247946199.739566] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
==pon==
UEVENT[1247946268.571857] add      /devices/virtual/net/ppp0 (net)
UDEV  [1247946268.593127] add      /devices/virtual/net/ppp0 (net)

Dmesg is available at http://pastebin.com/d516e3e00.
-- 
Regards,
Feri.
