Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZGWKZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZGWKZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZGWKZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:25:41 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:59711 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbZGWKZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:25:40 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.31-rc3: replugging USB serial converter uses new device node
References: <87zlb1u592.fsf@tac.ki.iif.hu>
	<20090723012140.39f697d2.akpm@linux-foundation.org>
Date: Thu, 23 Jul 2009 12:25:27 +0200
In-Reply-To: <20090723012140.39f697d2.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 23 Jul 2009 01:21:40 -0700")
Message-ID: <87tz13vgq0.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 18 Jul 2009 22:04:57 +0200 Ferenc Wagner <wferi@niif.hu> wrote:
>
>> Hi,
>> 
>> Since upgrading to 2.6.31-rc3 from 2.6.30, my ttyUSB device number
>> keeps increasing on each replug.  Output of udevadm monitor:
>> 
>> ==poff==
>> UEVENT[1247946169.580772] remove   /devices/virtual/net/ppp0 (net)
>> UDEV  [1247946169.589775] remove   /devices/virtual/net/ppp0 (net)
>> ==unplug==
>> UEVENT[1247946186.700698] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
>> UEVENT[1247946186.700737] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
>> UEVENT[1247946186.700749] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> UEVENT[1247946186.700760] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
>> UEVENT[1247946186.700771] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> UDEV  [1247946186.701535] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2/tty/ttyUSB2 (tty)
>> UDEV  [1247946186.705822] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB2 (usb-serial)
>> UDEV  [1247946186.711662] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> UDEV  [1247946186.715237] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.6 (usb_device)
>> UDEV  [1247946186.718872] remove   /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> ==replug==
>> UEVENT[1247946199.654628] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> UDEV  [1247946199.660946] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1 (usb)
>> UEVENT[1247946199.661096] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> UEVENT[1247946199.688206] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
>> UEVENT[1247946199.688254] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
>> UEVENT[1247946199.688266] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
>> UDEV  [1247946199.710642] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0 (usb)
>> UDEV  [1247946199.713898] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3 (usb-serial)
>> UDEV  [1247946199.729618] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/usb_device/usbdev3.7 (usb_device)
>> UDEV  [1247946199.739566] add      /devices/pci0000:00/0000:00:1d.1/usb3/3-1/3-1:1.0/ttyUSB3/tty/ttyUSB3 (tty)
>> ==pon==
>> UEVENT[1247946268.571857] add      /devices/virtual/net/ppp0 (net)
>> UDEV  [1247946268.593127] add      /devices/virtual/net/ppp0 (net)
>> 
>> Dmesg is available at http://pastebin.com/d516e3e00.
>
> Can anyone say whether this is expected behaviour?
> Does it actually cause any observeable problems?

The main problem is that I have to change my ppp config before each
pon.  I guess it could be solved by some udev trickery, but didn't
want to go that route before getting sure it's expected behaviour,
which I find improbable as it depends on a pppd run in the middle.
That's also why I didn't report it as an USB problem originally.
-- 
Thanks,
Feri.
