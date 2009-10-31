Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZJaL74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZJaL74 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 07:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbZJaL74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 07:59:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:46622 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586AbZJaL7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 07:59:55 -0400
Date: Sat, 31 Oct 2009 07:59:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org,
       stern@rowland.harvard.edu, bruce.w.allan@intel.com,
       Alan Piszcz <ap@solarrain.com>
Subject: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?] [tested
 3 different UPS']
In-Reply-To: <alpine.DEB.2.00.0910291047530.14066@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910310429410.10116@p34.internal.lan>
References: <alpine.DEB.2.00.0910291047530.14066@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

SUMMARY: P55 Chipset/USB has issues with UPS' (broken pipe on 3 diff UPS')
WORKAROUND: Buy/use PCI USB card if you want to use nut/connect a UPS.
NOTES: All other USB (non-UPS) devices seem to function without any
        problems.

On Thu, 29 Oct 2009, Justin Piszcz wrote:

> Problem: When I migrated from a DG965WH -> DP55KG motherboard, there were 
> quite a bit of issues, host still does not reboot without special flags, e.g. 
> reboot=a, the NIC driver is broken with the in-kernel version (the one on 
> e1000.sourceforge) fixes that and finally my UPS USB has driver stale 
> problems, with two issues already relating to the HW/drivers themselves it 
> would not be unrealistic to speculate that there could be an issue with the 
> USB chipset/driver with this P55 motherboard.

--

Tried another APC 1500VA UPS, same problem occurs, different cable/port etc.

Problem appears to be the Intel P55KG / USB Chipset in the way that it 
handles usbhid-raw devices as CD/USB sticks/kbd/mouse/etc do not appear to 
be affected.

So far all other USB devices work fine, with the exception of UPS', I 
have tested two APC 1500VA (one an RS the other an XS), in addition I also 
have a 'BELKIN 1200VA UPS with AVR' from a long time ago, the same
problem occurs.

Results:

- 3 different UPS models (APC 1500VA RS/XS & Belkin 1200VA)
- 2 different manufacturers (APC/Belkin)
- no other USB devices have problems (tried usb sticks,read cd/dvd, etc)

Output from Belkin UPS test:

Full update...
Can't retrieve Report 7: Broken pipe
upsdrv_updateinfo...
Got to reconnect!

Got 1 HID objects...
Full update...
upsdrv_updateinfo...
Got 1 HID objects...
Quick update...
Signal 2: exiting

BTW, other USB devices are OK, dd'd two USB sticks and a Knoppix DVD on a 
USB CD/DVD burner with no USB errors/issues.

# dd if=/dev/sr0 of=/x/knoppix.iso
8685248+0 records in
8685248+0 records out
4446846976 bytes (4.4 GB) copied, 287.585 s, 15.5 MB/s

Given the prior problems with this board (noted at the top, reboot=a, 
e1000e, etc)- is it possible that Intel needs to provide a BIOS update to 
fix this or does the USB UHCI driver need an update due to a possible? quirk
in this chipset / usb chip?

I also tested nut-2.2.2 from Debian Stable and the same problem 
occurred.

A bit frustrated, I popped in a PCI card with 4 external USBs, and now no
more errors:

Got 11 HID objects...
Quick update...
upsdrv_updateinfo...
Got 3 HID objects...
Quick update...
upsdrv_updateinfo...
Got 2 HID objects...
Full update...
upsdrv_updateinfo...
Got 3 HID objects...
Quick update...
upsdrv_updateinfo...
Got 2 HID objects...
Quick update...
upsdrv_updateinfo...
Got 3 HID objects...
Full update...
upsdrv_updateinfo...

07:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
07:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 61)
07:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)

It now works fine, using the PCI USB card.

However, this P55 board has 12-14 USB ports, it would be nice to use them.

Justin.
