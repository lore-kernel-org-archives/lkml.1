Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab0BHSsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:48:17 -0500
Received: from ppp-156-198.adsl.restena.lu ([158.64.156.198]:39260 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0BHSsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:48:15 -0500
Date: Mon, 8 Feb 2010 19:47:45 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
Message-ID: <20100208194745.3aab6d1a@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1002081313260.1316-100000@iolanthe.rowland.org>
References: <20100208175145.606ca761@neptune.home>
	<Pine.LNX.4.44L0.1002081313260.1316-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Bruno [UTF-8] Prémont wrote:
> 2.6.33-rc7 (don't know if any previous version resumes properly)
> crashes during resume from S2Ram when my USB keyboard is connected
> but resumes properly (viafb corruption put apart) when the USB
> keyboard is not connected.
>
> Keyboard detection:
> [    3.070054] usb 2-2: new full speed USB device using uhci_hcd and address 2
> [    3.220179] kbd_mode used greatest stack depth: 2228 bytes left
> [    3.276403] usb 2-2: New USB device found, idVendor=058f, idProduct=9462
> [    3.276514] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.276619] usb 2-2: Product: Multimedia USB Keyboard
> [    3.276711] usb 2-2: Manufacturer: Multimedia USB Keyboard
> [    3.278056] loadkeys used greatest stack depth: 1904 bytes left
> [    3.278791] init-early.sh used greatest stack depth: 1700 bytes left
> [    3.282561] hub 2-2:1.0: USB hub found
> [    3.286387] hub 2-2:1.0: 3 ports detected
> [    3.571454] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
> [    3.761474] usb 2-2.1: New USB device found, idVendor=058f, idProduct=9462
> [    3.761584] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.761719] usb 2-2.1: Product: Multimedia USB Keyboard
> [    3.762518] usb 2-2.1: Manufacturer: Multimedia USB Keyboard
> [    3.762612] usb 2-2.1: SerialNumber: Multimedia USB Keyboard
> [    3.789221] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2.1/2-2.1:1.0/input/input4
> [    3.789585] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:10.0-2.1/input0
> [    3.818001] generic-usb: probe of 0003:058F:9462.0002 failed with error -22  


On Mon, 08 February 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> > Could the crash be related to the generic-usb probe error?
> 
> Yes, it could.  Can you post the contents of 
> /sys/kernel/debug/usb/devices (after mounting a debugfs filesystem on 
> /sys/kernel/debug), with the keyboard plugged in?

Here it is:

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-rc7-venus uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:10.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-rc7-venus uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:10.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  2/900 us ( 0%), #Int=  2, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-rc7-venus uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:10.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12  MxCh= 3
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=058f ProdID=9462 Rev= 1.58
S:  Manufacturer=Multimedia USB Keyboard
S:  Product=Multimedia USB Keyboard
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 50mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=255ms

T:  Bus=02 Lev=02 Prnt=02 Port=00 Cnt=01 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=058f ProdID=9462 Rev= 4.10
S:  Manufacturer=Multimedia USB Keyboard
S:  Product=Multimedia USB Keyboard
S:  SerialNumber=Multimedia USB Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr= 50mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   4 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-rc7-venus ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:10.4
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms


Thanks,
Bruno
