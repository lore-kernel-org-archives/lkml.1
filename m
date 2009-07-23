Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZGWIWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZGWIWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 04:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZGWIWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 04:22:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbZGWIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 04:22:35 -0400
Date: Thu, 23 Jul 2009 01:21:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device
 node
Message-Id: <20090723012140.39f697d2.akpm@linux-foundation.org>
In-Reply-To: <87zlb1u592.fsf@tac.ki.iif.hu>
References: <87zlb1u592.fsf@tac.ki.iif.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc linux-usb)

On Sat, 18 Jul 2009 22:04:57 +0200 Ferenc Wagner <wferi@niif.hu> wrote:

> Hi,
> 
> Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
> keeps increasing on each replug.  Output of udevadm monitor:
> 
> ==poff==
> UEVENT[1247946169.580772] remove   /devices/virtual/net/ppp0 (net)
> UDEV  [1247946169.589775] remove   /devices/virtual/net/ppp0 (net)
> ==unplug==
> UEVENT[1247946186.700698] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
> UEVENT[1247946186.700737] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
> UEVENT[1247946186.700749] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UEVENT[1247946186.700760] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
> UEVENT[1247946186.700771] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> UDEV  [1247946186.701535] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
> UDEV  [1247946186.705822] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
> UDEV  [1247946186.711662] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UDEV  [1247946186.715237] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
> UDEV  [1247946186.718872] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> ==replug==
> UEVENT[1247946199.654628] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> UDEV  [1247946199.660946] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
> UEVENT[1247946199.661096] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UEVENT[1247946199.688206] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
> UEVENT[1247946199.688254] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
> UEVENT[1247946199.688266] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
> UDEV  [1247946199.710642] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
> UDEV  [1247946199.713898] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
> UDEV  [1247946199.729618] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
> UDEV  [1247946199.739566] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
> ==pon==
> UEVENT[1247946268.571857] add      /devices/virtual/net/ppp0 (net)
> UDEV  [1247946268.593127] add      /devices/virtual/net/ppp0 (net)
> 
> Dmesg is available at http://pastebin.com/d516e3e00.

Can anyone say whether this is expected behaviour?

Does it actually cause any observeable problems?  I expect things will
get ugly once it runs out of range.

