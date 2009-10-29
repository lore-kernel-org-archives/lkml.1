Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZJ2K6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZJ2K6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 06:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJ2K6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 06:58:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:49132 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbZJ2K6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 06:58:48 -0400
Date: Thu, 29 Oct 2009 10:58:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, nut-upsuser@lists.alioth.debian.org
Subject: 2.6.31.4: Any other suggestions regarding a UPS/USB (APC1500VA) on
 (Intel P55KG) stale issue?
Message-ID: <alpine.DEB.2.00.0910291047530.14066@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Problem: When I migrated from a DG965WH -> DP55KG motherboard, there were 
quite a bit of issues, host still does not reboot without special flags, 
e.g. reboot=a, the NIC driver is broken with the in-kernel version (the 
one on e1000.sourceforge) fixes that and finally my UPS USB has driver 
stale problems, with two issues already relating to the HW/drivers 
themselves it would not be unrealistic to speculate that there could be an 
issue with the USB chipset/driver with this P55 motherboard.

Is anyone else out there running an APC1500VA UPS on a P55 motherboard? 
If so, what have been your results?

Motherboard: Intel P55KG
Kernel: 2.6.31.4 x86_64

Details from nut/kernel usb trace:
http://home.comcast.net/~jpiszcz/20091014/nut-problem.txt

The last thread petered out:
http://www.gossamer-threads.com/lists/linux/kernel/1143579

# From ups -D
Got 2 HID objects...
Quick update...
upsdrv_updateinfo...
Got 2 HID objects...
Quick update...
Can't retrieve Report 22: Broken pipe
upsdrv_updateinfo...
Got to reconnect!
upsdrv_updateinfo...
Got to reconnect!
Can't retrieve Report 19: Broken pipe
upsdrv_updateinfo...
Got to reconnect!
Can't retrieve Report 15: Broken pipe
upsdrv_updateinfo...
Got to reconnect!
upsdrv_updateinfo...

# From the system logs:
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 6:01 ...
Communications with UPS apc@localhost lost
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 6:02 ...
Communications with UPS apc@localhost established
Broadcast Message from nut@p34.internal.lan
         (somewhere) at 6:03 ...

# From ups.conf:
[apc]
         driver = usbhid-ups
         port = auto
         desc = "APC 1500VA"

All other USB devices work properly, USB CD/DVD writer, keyboard, mouse, 
etc.  The same UPS (APC 1500VA) worked fine on the last board, same cable, 
etc.  I have tried power cycling the UPS and using a different port on the 
motherboard, to no avail.

Aside from purchasing a different UPS (if I wanted to use nut)- is it 
possible there is a bug in the chipset on these P55 boards in the way the 
driver communicates with it?

Since this problem is 100% reproducible every time, is there anyway to 
look into this issue any further?

Justin.
