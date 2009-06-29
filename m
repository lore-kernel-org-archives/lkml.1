Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZF2SNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZF2SNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZF2SNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:13:08 -0400
Received: from www17.your-server.de ([213.133.104.17]:35370 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZF2SNH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:13:07 -0400
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
From: Thomas Meyer <thomas@m3y3r.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0906171816280.23010-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0906171816280.23010-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Jun 2009 20:13:06 +0200
Message-Id: <1246299186.15821.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 17.06.2009, 18:53 -0400 schrieb Alan Stern: 
> On Wed, 17 Jun 2009, Thomas Meyer wrote:
> 
> > > Can you run the test again, this time with no extraneous USB devices 
> > > plugged in?  (That includes hubs.)  And before starting the test, 
> > > collect the contents of /sys/kernel/debug/usb/devices (you'll probably 
> > > have to mount /sys/kernel/debug first).
> > 
> > Sure. Rearranging the usb devices and removing some hubs makes the
> > problem go away in most cases...
> > 
> > This device combination seems to show the immediate wake up behaviour:
> 
> These logs are much better.  The ideal would be to have no I/O from 
> the mouse or keyboard.  (Which means you'd have to use a PS/2 keyboard 
> or a network login to initiate the test...)
> 
> Or no I/O from the network device.  What happens if you ifconfig it
> down before starting the test?

Same result. booting without the network device attached the problem
still occur.

> 
> > Here /proc/bus/usb/devices:
> > 
> > T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#= 45 Spd=480 MxCh= 0
> > D:  Ver= 2.00 Cls=02(comm.) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=0411 ProdID=00bc Rev= 0.06
> > S:  Manufacturer=Broadcom
> > S:  Product=WLI-U2-KG125S
> > S:  SerialNumber=8057
> > C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=rndis_wlan
> > E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
> > I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_wlan
> > E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
> 
> If you unplug the Broadcom device from this reduced configuration, do 
> the immediate resumes still happen?

Yes.

> 
> > T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#= 47 Spd=480 MxCh= 4
> > D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=02 MxPS=64 #Cfgs=  1
> > P:  Vendor=04b4 ProdID=6560 Rev= 0.09
> > C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=100mA
> > I:  If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=01 Driver=hub
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
> > I:* If#= 0 Alt= 1 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=02 Driver=hub
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms
> 
> This a separate (not built into the keyboard) powered hub, right?

Yes. And this thing seems to be responsible for the instant resume. Not
using a USB 2.0 hub, than the problem doesn't occur any more!

> 
> > T:  Bus=01 Lev=02 Prnt=47 Port=01 Cnt=01 Dev#= 48 Spd=1.5 MxCh= 0
> > D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> > P:  Vendor=413c ProdID=2003 Rev= 1.00
> > S:  Manufacturer=DELL
> > S:  Product=DELL USB Keyboard
> > C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> > I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
> > E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
> 
> If you unplug the keyboard but leave the mouse attached, do you still 
> get the immediate resumes?

Yes. But not using a USB 2.0 hub, the problem goes away.

> 
> > T:  Bus=01 Lev=02 Prnt=47 Port=02 Cnt=02 Dev#= 49 Spd=1.5 MxCh= 0
> > D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> > P:  Vendor=045e ProdID=0029 Rev= 1.08
> > S:  Manufacturer=Microsoft
> > S:  Product=Microsoft IntelliMouseÂ® Optical
> > C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
> > E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms
> > 
> > Fail log:
> 
> > success with above setup (re-plugging mouse, then suspend to ram works):
> 
> No other changes, just unplugging and replugging the mouse?  Do you
> think this was responsible for the success or was it only a
> coincidence? If you leave the mouse unplugged, does suspend work 100%
> of the time?

I guess the USB 2.0 hub does something differently than expected?!
Hardware bug or linux bug? (But re-plugging the mouse into the USB 2.0
hub, makes resume work again! Strange, mhh?)

> 
> I won't go into details about the log data.  A few things stand out:
> 
> 	There was no remote wakeup request from either the mouse
> 	or the keyboard.
> 
> 	Your EHCI controller showed an overcurrent condition on
> 	ports 1 and 2 after the resume.  But this showed up in
> 	both logs, so it probably wasn't the cause.
> 
> 	The EHCI controller showed that it had received wakeup
> 	events on both ports: the one connected to the Broadcom
> 	and the one connected to the hub.  That's very suspicious,
> 	but it also occurred in both logs.
> 
> 	Neither log shows the mouse being resumed.  But it must
> 	have been, because the "success" log shows data transfers
> 	from the mouse later on.  This may indicate that the usbmon
> 	buffer is getting filled up.  You can check this by looking
> 	in usbmon's 0s or 1s file.
> 
> 	The rndis_wlan driver didn't behave very well during suspend.
> 	It tried to carry out several transfers to the device while
> 	the device was suspended, which it shouldn't have done.
> 	The transfers all failed, of course.  The same thing happened
> 	in both logs.
> 
> In short, I don't see any significant difference to explain why you
> sometimes get an immediate resume.  More testing is needed, especially
> to make sure that the earlier results weren't just random coincidences.  
> And of course, the answer to the questions above will help.

My current working setup involves no USB 2.0 hub and it's:

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh=10
B:  Alloc= 39/900 us ( 4%), #Int=  3, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.30 ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:00:02.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=413c ProdID=2003 Rev= 1.00
S:  Manufacturer=DELL
S:  Product=DELL USB Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  5 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=045e ProdID=0029 Rev= 1.08
S:  Manufacturer=Microsoft
S:  Product=Microsoft IntelliMouse® Optical
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh=10
B:  Alloc=  0/800 us ( 0%), #Int=  1, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.30 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:02.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#= 23 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=02(comm.) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0411 ProdID=00bc Rev= 0.06
S:  Manufacturer=Broadcom
S:  Product=WLI-U2-KG125S
S:  SerialNumber=8057
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=ff Driver=rndis_wlan
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=rndis_wlan
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=125us

greetings
thomas


