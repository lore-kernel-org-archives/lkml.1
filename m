Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZBTLAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZBTLAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZBTLA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:00:28 -0500
Received: from [62.67.244.94] ([62.67.244.94]:38367 "EHLO
	s8073.evanzo-server.de" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbZBTLA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:00:26 -0500
From: Tobias Kaminsky <mail@finswimmer.de>
To: linux-kernel@vger.kernel.org
Subject: Re: No Scancodes for "Logitech NuLOOQ"
Date: Fri, 20 Feb 2009 11:59:26 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.6; KDE/4.2.0; x86_64; ; )
References: <200902191216.24045.mail@finswimmer.de> <alpine.LRH.1.10.0902191606360.11868@twin.jikos.cz> <200902191709.29334.mail@finswimmer.de>
In-Reply-To: <200902191709.29334.mail@finswimmer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902201159.26658.mail@finswimmer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

evtest is giving this additional informations:

Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x46d product 0xc640 version 0x110
Input device name: "3Dconnexion NuLOOQ Navigator"                 
Supported events:
  Event type 0 (Sync)
  Event type 1 (Key)
    Event code 256 (Btn0)
    Event code 257 (Btn1)
    Event code 258 (Btn2)
    Event code 259 (Btn3)
    Event code 260 (Btn4)
    Event code 330 (Touch)
  Event type 2 (Relative)
    Event code 0 (X)
    Event code 1 (Y)
    Event code 2 (Z)
    Event code 5 (?)
  Event type 3 (Absolute)
    Event code 24 (Pressure)
      Value      0
      Min        0
      Max       63
  Event type 4 (Misc)
    Event code 4 (ScanCode)
  Event type 17 (LED)
    Event code 6 (Suspend)
    Event code 8 (Misc)
    Event code 10 (?)

Turning the "navring" gives me this:
Event: time 1235127125.142516, -------------- Report Sync ------------        
Event: time 1235127125.150507, type 2 (Relative), code 0 (X), value 43        
Event: time 1235127125.150510, type 2 (Relative), code 1 (Y), value -23       
Event: time 1235127125.150511, type 2 (Relative), code 5 (?), value -258      
Event: time 1235127125.150511, -------------- Report Sync ------------        
Event: time 1235127125.158508, type 2 (Relative), code 0 (X), value 46        
Event: time 1235127125.158511, type 2 (Relative), code 1 (Y), value -9        
Event: time 1235127125.158512, type 2 (Relative), code 5 (?), value -252      
Event: time 1235127125.158513, -------------- Report Sync ------------        
Event: time 1235127125.166510, type 2 (Relative), code 0 (X), value 33        
Event: time 1235127125.166513, type 2 (Relative), code 1 (Y), value 7
Event: time 1235127125.166514, type 2 (Relative), code 5 (?), value -241
Event: time 1235127125.166514, -------------- Report Sync ------------
Event: time 1235127125.174508, type 2 (Relative), code 0 (X), value 29
Event: time 1235127125.174511, type 2 (Relative), code 1 (Y), value 35
Event: time 1235127125.174511, type 2 (Relative), code 5 (?), value -224
Event: time 1235127125.174512, -------------- Report Sync ------------
Event: time 1235127125.182510, type 2 (Relative), code 0 (X), value 33
Event: time 1235127125.182513, type 2 (Relative), code 1 (Y), value 43
Event: time 1235127125.182514, type 2 (Relative), code 5 (?), value -205
Event: time 1235127125.182514, -------------- Report Sync ------------
Event: time 1235127125.190510, type 2 (Relative), code 0 (X), value 45
Event: time 1235127125.190512, type 2 (Relative), code 1 (Y), value 31
Event: time 1235127125.190513, type 2 (Relative), code 5 (?), value -175
Event: time 1235127125.190513, -------------- Report Sync ------------
Event: time 1235127125.206509, type 2 (Relative), code 0 (X), value 55
Event: time 1235127125.206512, type 2 (Relative), code 1 (Y), value 7
Event: time 1235127125.206513, type 2 (Relative), code 5 (?), value -126


So I think that this definiton is correct:
Event type 1:
Button 1- 4
Touchbutton 5

Event type 2:
X: Pushing the navring sidewards: from left: value positive till: 547
X: Pushing the navring sidewards: from right: value negative till: -447

Z: Touching the buttons: "9oclock" (button 1) : 4100/0
then counter clockwise raising from 0 till 4100

Rotating the navring results in relative changes of all values:
Event: time 1235127083.205421, type 2 (Relative), code 0 (X), value -22
Event: time 1235127083.205424, type 2 (Relative), code 1 (Y), value -17
Event: time 1235127083.205425, type 2 (Relative), code 5 (?), value -1


Someone in the logitech forum suggested if it is not possible to parse these 
values to REL_WHEEL and REL_DIAL events.

There is also a piece of software which lets read me the events:
got motion event: t(-2, 4001, 3) r(0, 3, 0) till 
got motion event: t(-2, 2, 3) r(0, 3, 0)
this should be the same as Z above.

Many thanks
Tobi


On Thursday 19 February 2009 17:09:28 you wrote:
> On Thursday 19 February 2009 16:08:06 Jiri Kosina wrote:
> > On Thu, 19 Feb 2009, Tobias Kaminsky wrote:
> > > 589827 (0x90003)
> > > 589827 (0x90003)
> > > 589825 (0x90001)
> > > 589825 (0x90001)
> > > 589825 (0x90001)
> > > 589828 (0x90004)
> > > 589825 (0x90001)
> > > 589828 (0x90004)
> > > 589826 (0x90002)
> > > 589826 (0x90002)
> > > 589829 (0x90005)
> > > 589829 (0x90005) Button "II"
> >
> > Do these events come out of kernel correctly? I.e. what is the output of
> >
> > 	evtest /dev/input/event3
> >
> > when pressing these buttons?
>
> Button 2:
> Event: time 1235059431.874735, -------------- Report Sync ------------
> Event: time 1235059432.298757, type 4 (Misc), code 4 (ScanCode), value
> 90005 Event: time 1235059432.298762, type 1 (Key), code 260 (Btn4), value 1
> Event: time 1235059432.298763, -------------- Report Sync ------------
> Event: time 1235059432.362746, type 4 (Misc), code 4 (ScanCode), value
> 90005 Event: time 1235059432.362750, type 1 (Key), code 260 (Btn4), value 0
> Event: time 1235059432.362751, -------------- Report Sync ------------
>
> Button 1: (It supports pressing and tabbing on it)
>
> Event: time 1235059514.508954, type 2 (Relative), code 2 (Z), value 94
> Event: time 1235059514.508965, type 1 (Key), code 330 (Touch), value 1
> Event: time 1235059514.508966, type 3 (Absolute), code 24 (Pressure), value
> 15 Event: time 1235059514.508967, -------------- Report Sync ------------
> Event: time 1235059514.524937, type 2 (Relative), code 2 (Z), value 92
> Event: time 1235059514.524946, type 3 (Absolute), code 24 (Pressure), value
> 13 Event: time 1235059514.524947, -------------- Report Sync ------------
> Event: time 1235059514.540940, type 2 (Relative), code 2 (Z), value 94
> Event: time 1235059514.540949, -------------- Report Sync ------------
> Event: time 1235059514.548942, type 2 (Relative), code 2 (Z), value 99
> Event: time 1235059514.548951, type 3 (Absolute), code 24 (Pressure), value
> 11 Event: time 1235059514.548952, -------------- Report Sync ------------
> Event: time 1235059514.564942, type 2 (Relative), code 2 (Z), value 99
> Event: time 1235059514.564951, type 1 (Key), code 330 (Touch), value 0
> Event: time 1235059514.564952, type 3 (Absolute), code 24 (Pressure), value
> 6 Event: time 1235059514.564952, -------------- Report Sync ------------
> Event: time 1235059514.572949, type 3 (Absolute), code 24 (Pressure), value
> 0 Event: time 1235059514.572951, -------------- Report Sync ------------
>
> > > But the NuLOOQ has a "navring" which you can turn left/right. This does
> > > not generates a scancode.
> >
> > Could you please compile the kernel with CONFIG_HID_DEBUG enabled,
> > modprobe the 'hid' module with 'debug=2' parameter, move the "narving" in
> > both directions, and send me the output that appears in dmesg?
> >
> > Thanks,
>
> As it is my aim to get it working with kino  (www.kinodv.org) I talked to
> the Developer. He says that Kino expects the shuttle to support REL_WHEEL
> and REL_DIAL events.
> I hope that this is not a complete other directions.
>
>
> modprobe hid debug=2 gives me this when I plug in the device:
> (very long)
>
> But it does not react on the navring nor on the buttons.
>
> Thank you for your help!
>
> dmesg:
>
> [  396.973645] drivers/hid/hid-core.c: report (size 6) (numbered)
> [  396.973652] drivers/hid/hid-core.c: report 1 (size 5) =  00 00 00 00 00
> [  396.973666] hid-debug: input Button.0001 = 0
> [  396.973683] hid-debug: input Button.0002 = 0
> [  396.973689] hid-debug: input Button.0003 = 0
> [  396.973696] hid-debug: input Button.0004 = 0
> [  396.973701] hid-debug: input Button.0005 = 0
> [  396.973708] hid-debug: input GenericDesktop.X = 0
> [  396.973714] hid-debug: input GenericDesktop.Y = 0
> [  396.973720] hid-debug: input GenericDesktop.Wheel = 0
> [  396.973731] hid-debug: input LED.GenericIndicator = 0
> [  396.973737] hid-debug: input LED.GenericIndicator = 0
> [  396.973743] hid-debug: input LED.GenericIndicator = 0
> [  396.973754] hid-debug: input LED.GenericIndicator = 0
> [  396.973760] hid-debug: input LED.GenericIndicator = 0
> [  396.973770] hid-debug: input LED.GenericIndicator = 0
> [  396.973778] hid-debug: input LED.GenericIndicator = 0
> [  396.973785] hid-debug: input LED.GenericIndicator = 0
>
>
> /var/log/messages:
> Feb 19 17:00:03 tobi-desktop [  276.051423] usb 3-2: skipped 1 descriptor
> after interface
> Feb 19 17:00:03 tobi-desktop [  276.054419] usb 3-2: default language
> 0x0409 Feb 19 17:00:03 tobi-desktop [  276.062505] usb 3-2: uevent
> Feb 19 17:00:03 tobi-desktop [  276.062961] usb 3-2: usb_probe_device
> Feb 19 17:00:03 tobi-desktop [  276.062968] usb 3-2: configuration #1
> chosen from 1 choice
> Feb 19 17:00:03 tobi-desktop [  276.065418] usb 3-2: adding 3-2:1.0 (config
> #1, interface 0)
> Feb 19 17:00:03 tobi-desktop [  276.065518] usb 3-2:1.0: uevent
> Feb 19 17:00:03 tobi-desktop [  276.065723] usbhid 3-2:1.0:
> usb_probe_interface
> Feb 19 17:00:03 tobi-desktop [  276.065729] usbhid 3-2:1.0:
> usb_probe_interface - got id
> Feb 19 17:00:03 tobi-desktop [  276.065827] drivers/hid/usbhid/hid-core.c:
> HID probe called for ifnum 0
> Feb 19 17:00:03 tobi-desktop [  276.082427] drivers/hid/usbhid/hid-core.c:
> report descriptor (size 211, read 211) =  05 01 09 08 a1 01 a1 00 85 01 16
> 00 fe 26 00 02 09 30 09 31 09 35 75 10 95 03 81 06 c0 a1 00 85 02 05 01 09
> 32 15 00 26 ff 0f 75 10 95 01 81 06 05 0d 09 30 25 3f 95 01 81 06 c0 a1 02
> 85 03 05 01 05 09 19 01 29 05 15 00 25 01 35 00 45 01 75 01 95 05 81 02 95
> 0b 81 03 c0 a1 02 85 04 05 08 19 4b 29 4f 15 00 25 01 95 05 75 01 91 02 95
> 01 75 03 91 03 c0 06 00 ff 09 01 a1 02 15 80 25 7f 75 08 09 3a a1 02 85 05
> 09 20 95 03 b1 02 c0 a1 02 85 06 09 21 95 01 b1 02 c0 a1 02 85 07 09 22 95
> 01 b1 02 c0 a1 02 85 08 09 23 95 07 b1 02 c0 a1 02 85 09 09 24 95 07 b1 02
> c0 a1 02 85 0a 09 25 95 07 b1 02 c0 a1 02 85 0b 09 26 95 01 b1 02 c0 c0 c0
> Feb 19 17:00:03 tobi-desktop [  276.083856] drivers/hid/usbhid/hid-core.c:
> submitting ctrl urb: Get_Report wValue=0x0101 wIndex=0x0000 wLength=7
> Feb 19 17:00:03 tobi-desktop [  276.085412] drivers/hid/hid-core.c: report
> (size 7) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.085419] drivers/hid/hid-core.c: report
> 1 (size 6) =  00 00 00 00 00 00
> Feb 19 17:00:03 tobi-desktop [  276.085430] hid-debug: input
> GenericDesktop.X = 0
> Feb 19 17:00:03 tobi-desktop [  276.085437] hid-debug: input
> GenericDesktop.Y = 0
> Feb 19 17:00:03 tobi-desktop [  276.085443] hid-debug: input
> GenericDesktop.Rz = 0
> Feb 19 17:00:03 tobi-desktop [  276.085453] drivers/hid/usbhid/hid-core.c:
> submitting ctrl urb: Get_Report wValue=0x0102 wIndex=0x0000 wLength=5
> Feb 19 17:00:03 tobi-desktop [  276.087407] drivers/hid/hid-core.c: report
> (size 5) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.087415] drivers/hid/hid-core.c: report
> 2 (size 4) =  00 00 00 00
> Feb 19 17:00:03 tobi-desktop [  276.087423] hid-debug: input
> GenericDesktop.Z = 0
> Feb 19 17:00:03 tobi-desktop [  276.087429] hid-debug: input
> Digitizers.TipPressure = 0
> Feb 19 17:00:03 tobi-desktop [  276.087438] drivers/hid/usbhid/hid-core.c:
> submitting ctrl urb: Get_Report wValue=0x0103 wIndex=0x0000 wLength=3
> Feb 19 17:00:03 tobi-desktop [  276.088411] drivers/hid/hid-core.c: report
> (size 3) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.088418] drivers/hid/hid-core.c: report
> 3 (size 2) =  00 00
> Feb 19 17:00:03 tobi-desktop [  276.088424] hid-debug: input Button.0001 =
> 0 Feb 19 17:00:03 tobi-desktop [  276.088431] hid-debug: input Button.0002
> = 0 Feb 19 17:00:03 tobi-desktop [  276.088438] hid-debug: input
> Button.0003 = 0 Feb 19 17:00:03 tobi-desktop [  276.088444] hid-debug:
> input Button.0004 = 0 Feb 19 17:00:03 tobi-desktop [  276.088450]
> hid-debug: input Button.0005 = 0 Feb 19 17:00:03 tobi-desktop [ 
> 276.088458] drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report
> wValue=0x0305 wIndex=0x0000 wLength=4 Feb 19 17:00:03 tobi-desktop [ 
> 276.089408] drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report
> wValue=0x0306 wIndex=0x0000 wLength=2 Feb 19 17:00:03 tobi-desktop [ 
> 276.090407] drivers/hid/hid-core.c: report (size 2) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.090414] drivers/hid/hid-core.c: report
> 6 (size 1) =  03
> Feb 19 17:00:03 tobi-desktop [  276.090419] hid-debug: input ff00.0021 = 3
> Feb 19 17:00:03 tobi-desktop [  276.090430] drivers/hid/usbhid/hid-core.c:
> submitting ctrl urb: Get_Report wValue=0x0307 wIndex=0x0000 wLength=2
> Feb 19 17:00:03 tobi-desktop [  276.091408] drivers/hid/usbhid/hid-core.c:
> submitting ctrl urb: Get_Report wValue=0x0308 wIndex=0x0000 wLength=8
> Feb 19 17:00:03 tobi-desktop [  276.100411] drivers/hid/hid-core.c: report
> (size 8) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.100418] drivers/hid/hid-core.c: report
> 8 (size 7) =  8e 0f d5 0f 00 00 74
> Feb 19 17:00:03 tobi-desktop [  276.100430] hid-debug: input ff00.0023 =
> -114 Feb 19 17:00:03 tobi-desktop [  276.100441] hid-debug: input ff00.0023
> = 15 Feb 19 17:00:03 tobi-desktop [  276.100450] hid-debug: input ff00.0023
> = -43 Feb 19 17:00:03 tobi-desktop [  276.100458] hid-debug: input
> ff00.0023 = 15 Feb 19 17:00:03 tobi-desktop [  276.100465] hid-debug: input
> ff00.0023 = 0 Feb 19 17:00:03 tobi-desktop [  276.100473] hid-debug: input
> ff00.0023 = 0 Feb 19 17:00:03 tobi-desktop [  276.100481] hid-debug: input
> ff00.0023 = 116 Feb 19 17:00:03 tobi-desktop [  276.100490]
> drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Get_Report
> wValue=0x0309 wIndex=0x0000 wLength=8 Feb 19 17:00:03 tobi-desktop [ 
> 276.103411] drivers/hid/hid-core.c: report (size 8) (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.103418] drivers/hid/hid-core.c: report
> 9 (size 7) =  7d 81 80 80 7d 80 7f
> Feb 19 17:00:03 tobi-desktop [  276.103428] hid-debug: input ff00.0024 =
> 125 Feb 19 17:00:03 tobi-desktop [  276.103436] hid-debug: input ff00.0024
> = -127 Feb 19 17:00:03 tobi-desktop [  276.103444] hid-debug: input
> ff00.0024 = -128 Feb 19 17:00:03 tobi-desktop [  276.103452] hid-debug:
> input ff00.0024 = -128 Feb 19 17:00:03 tobi-desktop [  276.103460]
> hid-debug: input ff00.0024 = 125 Feb 19 17:00:03 tobi-desktop [ 
> 276.103468] hid-debug: input ff00.0024 = -128 Feb 19 17:00:03 tobi-desktop
> [  276.103477] hid-debug: input ff00.0024 = 127 Feb 19 17:00:03
> tobi-desktop [  276.103486] drivers/hid/usbhid/hid-core.c: submitting ctrl
> urb: Get_Report wValue=0x030a wIndex=0x0000 wLength=8 Feb 19 17:00:03
> tobi-desktop [  276.106406] drivers/hid/hid-core.c: report (size 8)
> (numbered)
> Feb 19 17:00:03 tobi-desktop [  276.106413] drivers/hid/hid-core.c: report
> 10 (size 7) =  87 86 82 82 86 86 be
> Feb 19 17:00:03 tobi-desktop [  276.106425] hid-debug: input ff00.0025 =
> -121 Feb 19 17:00:03 tobi-desktop [  276.106433] hid-debug: input ff00.0025
> = -122 Feb 19 17:00:03 tobi-desktop [  276.106441] hid-debug: input
> ff00.0025 = -126 Feb 19 17:00:03 tobi-desktop [  276.106449] hid-debug:
> input ff00.0025 = -126 Feb 19 17:00:03 tobi-desktop [  276.106456]
> hid-debug: input ff00.0025 = -122 Feb 19 17:00:03 tobi-desktop [ 
> 276.106467] hid-debug: input ff00.0025 = -122 Feb 19 17:00:03 tobi-desktop
> [  276.106478] hid-debug: input ff00.0025 = -66 Feb 19 17:00:03
> tobi-desktop [  276.106489] drivers/hid/usbhid/hid-core.c: submitting ctrl
> urb: Get_Report wValue=0x030b wIndex=0x0000 wLength=2 Feb 19 17:00:03
> tobi-desktop [  276.107422]   INPUT(1)[INPUT]
> Feb 19 17:00:03 tobi-desktop [  276.107430]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107433]       Usage(3)
> Feb 19 17:00:03 tobi-desktop [  276.107436]         GenericDesktop.X
> Feb 19 17:00:03 tobi-desktop [  276.107442]         GenericDesktop.Y
> Feb 19 17:00:03 tobi-desktop [  276.107448]         GenericDesktop.Rz
> Feb 19 17:00:03 tobi-desktop [  276.107453]       Logical Minimum(-512)
> Feb 19 17:00:03 tobi-desktop [  276.107457]       Logical Maximum(512)
> Feb 19 17:00:03 tobi-desktop [  276.107461]       Report Size(16)
> Feb 19 17:00:03 tobi-desktop [  276.107464]       Report Count(3)
> Feb 19 17:00:03 tobi-desktop [  276.107468]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107471]       Flags( Variable Relative
> ) Feb 19 17:00:03 tobi-desktop [  276.107481]   INPUT(2)[INPUT]
> Feb 19 17:00:03 tobi-desktop [  276.107489]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107492]       Usage(1)
> Feb 19 17:00:03 tobi-desktop [  276.107495]         GenericDesktop.Z
> Feb 19 17:00:03 tobi-desktop [  276.107501]       Logical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107504]       Logical Maximum(4095)
> Feb 19 17:00:03 tobi-desktop [  276.107508]       Report Size(16)
> Feb 19 17:00:03 tobi-desktop [  276.107511]       Report Count(1)
> Feb 19 17:00:03 tobi-desktop [  276.107514]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107517]       Flags( Variable Relative
> ) Feb 19 17:00:03 tobi-desktop [  276.107527]     Field(1)
> Feb 19 17:00:03 tobi-desktop [  276.107530]       Usage(1)
> Feb 19 17:00:03 tobi-desktop [  276.107533]         Digitizers.TipPressure
> Feb 19 17:00:03 tobi-desktop [  276.107539]       Logical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107543]       Logical Maximum(63)
> Feb 19 17:00:03 tobi-desktop [  276.107546]       Report Size(16)
> Feb 19 17:00:03 tobi-desktop [  276.107549]       Report Count(1)
> Feb 19 17:00:03 tobi-desktop [  276.107553]       Report Offset(16)
> Feb 19 17:00:03 tobi-desktop [  276.107556]       Flags( Variable Relative
> ) Feb 19 17:00:03 tobi-desktop [  276.107567]   INPUT(3)[INPUT]
> Feb 19 17:00:03 tobi-desktop [  276.107572]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107580]       Usage(5)
> Feb 19 17:00:03 tobi-desktop [  276.107583]         Button.0001
> Feb 19 17:00:03 tobi-desktop [  276.107592]         Button.0002
> Feb 19 17:00:03 tobi-desktop [  276.107599]         Button.0003
> Feb 19 17:00:03 tobi-desktop [  276.107605]         Button.0004
> Feb 19 17:00:03 tobi-desktop [  276.107611]         Button.0005
> Feb 19 17:00:03 tobi-desktop [  276.107616]       Logical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107620]       Logical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107625]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107628]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107632]       Report Size(1)
> Feb 19 17:00:03 tobi-desktop [  276.107635]       Report Count(5)
> Feb 19 17:00:03 tobi-desktop [  276.107640]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107644]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.107654]   OUTPUT(4)[OUTPUT]
> Feb 19 17:00:03 tobi-desktop [  276.107659]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107662]       Usage(5)
> Feb 19 17:00:03 tobi-desktop [  276.107669]         LED.GenericIndicator
> Feb 19 17:00:03 tobi-desktop [  276.107675]         LED.004c
> Feb 19 17:00:03 tobi-desktop [  276.107681]         LED.004d
> Feb 19 17:00:03 tobi-desktop [  276.107690]         LED.004e
> Feb 19 17:00:03 tobi-desktop [  276.107695]         LED.004f
> Feb 19 17:00:03 tobi-desktop [  276.107701]       Logical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107704]       Logical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107710]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107713]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107717]       Report Size(1)
> Feb 19 17:00:03 tobi-desktop [  276.107720]       Report Count(5)
> Feb 19 17:00:03 tobi-desktop [  276.107723]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107726]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.107736]   FEATURE(5)[FEATURE]
> Feb 19 17:00:03 tobi-desktop [  276.107742]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107747]       Logical(ff00.003a)
> Feb 19 17:00:03 tobi-desktop [  276.107756]       Usage(3)
> Feb 19 17:00:03 tobi-desktop [  276.107759]         ff00.0020
> Feb 19 17:00:03 tobi-desktop [  276.107766]         ff00.0020
> Feb 19 17:00:03 tobi-desktop [  276.107777]         ff00.0020
> Feb 19 17:00:03 tobi-desktop [  276.107784]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.107788]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.107791]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107794]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107798]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.107801]       Report Count(3)
> Feb 19 17:00:03 tobi-desktop [  276.107806]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107809]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.107820]   FEATURE(6)[FEATURE]
> Feb 19 17:00:03 tobi-desktop [  276.107825]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107828]       Usage(1)
> Feb 19 17:00:03 tobi-desktop [  276.107831]         ff00.0021
> Feb 19 17:00:03 tobi-desktop [  276.107838]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.107842]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.107847]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107851]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107854]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.107857]       Report Count(1)
> Feb 19 17:00:03 tobi-desktop [  276.107860]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107863]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.107873]   FEATURE(7)[FEATURE]
> Feb 19 17:00:03 tobi-desktop [  276.107882]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107885]       Usage(1)
> Feb 19 17:00:03 tobi-desktop [  276.107888]         ff00.0022
> Feb 19 17:00:03 tobi-desktop [  276.107895]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.107900]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.107903]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.107906]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.107910]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.107916]       Report Count(1)
> Feb 19 17:00:03 tobi-desktop [  276.107919]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.107924]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.107934]   FEATURE(8)[FEATURE]
> Feb 19 17:00:03 tobi-desktop [  276.107939]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.107945]       Usage(7)
> Feb 19 17:00:03 tobi-desktop [  276.107948]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107957]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107967]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107974]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107983]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107990]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.107998]         ff00.0023
> Feb 19 17:00:03 tobi-desktop [  276.108005]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.108009]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.108013]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.108016]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.108019]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.108022]       Report Count(7)
> Feb 19 17:00:03 tobi-desktop [  276.108025]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.108029]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.108038]   FEATURE(9)[FEATURE]
> Feb 19 17:00:03 tobi-desktop [  276.108047]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.108050]       Usage(7)
> Feb 19 17:00:03 tobi-desktop [  276.108053]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108060]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108067]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108074]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108081]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108089]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108096]         ff00.0024
> Feb 19 17:00:03 tobi-desktop [  276.108103]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.108110]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.108113]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.108117]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.108120]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.108126]       Report Count(7)
> Feb 19 17:00:03 tobi-desktop [  276.108129]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.108132]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.108142]   FEATURE(10)[FEATURE] Feb 19
> 17:00:03 tobi-desktop [  276.108150]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.108153]       Usage(7)
> Feb 19 17:00:03 tobi-desktop [  276.108156]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108165]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108172]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108180]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108190]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108197]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108204]         ff00.0025
> Feb 19 17:00:03 tobi-desktop [  276.108211]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.108215]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.108218]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.108221]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.108225]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.108228]       Report Count(7)
> Feb 19 17:00:03 tobi-desktop [  276.108233]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.108237]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.108247]   FEATURE(11)[FEATURE] Feb 19
> 17:00:03 tobi-desktop [  276.108254]     Field(0)
> Feb 19 17:00:03 tobi-desktop [  276.108257]       Usage(1)
> Feb 19 17:00:03 tobi-desktop [  276.108260]         ff00.0026
> Feb 19 17:00:03 tobi-desktop [  276.108267]       Logical Minimum(-128)
> Feb 19 17:00:03 tobi-desktop [  276.108275]       Logical Maximum(127)
> Feb 19 17:00:03 tobi-desktop [  276.108279]       Physical Minimum(0)
> Feb 19 17:00:03 tobi-desktop [  276.108282]       Physical Maximum(1)
> Feb 19 17:00:03 tobi-desktop [  276.108285]       Report Size(8)
> Feb 19 17:00:03 tobi-desktop [  276.108288]       Report Count(1)
> Feb 19 17:00:03 tobi-desktop [  276.108291]       Report Offset(0)
> Feb 19 17:00:03 tobi-desktop [  276.108295]       Flags( Variable Absolute
> ) Feb 19 17:00:03 tobi-desktop [  276.108312] drivers/hid/hid-input.c:
> Mapping: GenericDesktop.X ---> Relative.X
> Feb 19 17:00:03 tobi-desktop [  276.108323] drivers/hid/hid-input.c:
> Mapping: GenericDesktop.Y ---> Relative.Y
> Feb 19 17:00:03 tobi-desktop [  276.108335] drivers/hid/hid-input.c:
> Mapping: GenericDesktop.Rz ---> Relative.Rz
> Feb 19 17:00:03 tobi-desktop [  276.108344] drivers/hid/hid-input.c:
> Mapping: GenericDesktop.Z ---> Relative.Z
> Feb 19 17:00:03 tobi-desktop [  276.108352] drivers/hid/hid-input.c:
> Mapping: Digitizers.TipPressure ---> Absolute.Pressure
> Feb 19 17:00:03 tobi-desktop [  276.108367] drivers/hid/hid-input.c:
> Mapping: Button.0001 ---> Key.Btn0
> Feb 19 17:00:03 tobi-desktop [  276.108423] drivers/hid/hid-input.c:
> Mapping: Button.0002 ---> Key.Btn1
> Feb 19 17:00:03 tobi-desktop [  276.108432] drivers/hid/hid-input.c:
> Mapping: Button.0003 ---> Key.Btn2
> Feb 19 17:00:03 tobi-desktop [  276.108441] drivers/hid/hid-input.c:
> Mapping: Button.0004 ---> Key.Btn3
> Feb 19 17:00:03 tobi-desktop [  276.108449] drivers/hid/hid-input.c:
> Mapping: Button.0005 ---> Key.Btn4
> Feb 19 17:00:03 tobi-desktop [  276.108461] drivers/hid/hid-input.c:
> Mapping: LED.GenericIndicator ---> LED.Misc
> Feb 19 17:00:03 tobi-desktop [  276.108471] drivers/hid/hid-input.c:
> Mapping: LED.004c ---> LED.Suspend
> Feb 19 17:00:03 tobi-desktop [  276.108483] drivers/hid/hid-input.c:
> Mapping: LED.004d ---> LED.?
> Feb 19 17:00:03 tobi-desktop [  276.108494] drivers/hid/hid-input.c:
> Mapping: LED.004e ---> IGNORED
> Feb 19 17:00:03 tobi-desktop [  276.108502] drivers/hid/hid-input.c:
> Mapping: LED.004f ---> IGNORED
> Feb 19 17:00:03 tobi-desktop [  276.108618] input: 3Dconnexion NuLOOQ
> Navigator as
> /devices/pci0000:00/0000:00:02.0/usb3/3-2/3-2:1.0/input/input11 Feb 19
> 17:00:03 tobi-desktop [  276.116505] input,hidraw0: USB HID v1.10
> Multi-Axis Controller [3Dconnexion NuLOOQ Navigator] on usb-0000:00:02.0-2
> Feb 19 17:00:03 tobi-desktop [  276.116579] drivers/usb/core/inode.c:
> creating file '003'
> Feb 19 17:00:03 tobi-desktop [  276.116652] usb 3-2: New USB device found,
> idVendor=046d, idProduct=c640
> Feb 19 17:00:03 tobi-desktop [  276.116657] usb 3-2: New USB device
> strings: Mfr=3, Product=1, SerialNumber=0
> Feb 19 17:00:03 tobi-desktop [  276.116661] usb 3-2: Product: NuLOOQ
> Navigator Feb 19 17:00:03 tobi-desktop [  276.116664] usb 3-2:
> Manufacturer: 3Dconnexion Feb 19 17:00:03 tobi-desktop [  276.116670] hub
> 3-0:1.0: state 7 ports 6 chg 0000 evt 0004
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

