Return-Path: <linux-kernel-owner+w=401wt.eu-S1764097AbXFCA1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764097AbXFCA1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 20:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762995AbXFCA10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 20:27:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:42035 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760616AbXFCA1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 20:27:25 -0400
Date: Sat, 2 Jun 2007 20:27:22 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Christian Kujau <lists@nerdbynature.de>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.64.0706022026570.10213@p34.internal.lan>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <4661F511.4070207@goop.org> <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
 <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Christian Kujau wrote:

> On Sat, 2 Jun 2007, Justin Piszcz wrote:
>> On Sat, 2 Jun 2007, Jeremy Fitzhardinge wrote:
>>> XFS currently has a data-corrupting bug, where files which were appended
>>> by small amounts may lose their updates on umount - I see this
>>> corrupting hg repos. There's a patch which works for me, and is in
>>> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.
>
> Just for the record, you mean this one:
> http://lkml.org/lkml/2007/5/12/93   ..right? (haven't been bitten by this 
> one...yet)
>
>> Ah that's it- and USB appears to be broken as well, I'll stick with 
>> 2.6.21.3 for now.
>
> Got any pointers? I'm using USB right now, one is i386 with 2.6.22-rc3, 
> another one is powerpc, tracking -git and USB seems to work.
>
> C.
> -- 
> BOFH excuse #15:
>
> temporary routing anomaly
>

Sent this in another e-mail to LKML, it breaks support for my UPS:

>From jpiszcz@lucidpixels.com Sat Jun  2 18:43:52 2007
Date: Sat, 2 Jun 2007 18:43:52 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error sending control message: Operation not permitted)

I use nut-2.0.4-4 with a UPS attached via USB and from 2.6.21.3 -> 2.6.22-rc3 it
stops working, see below.  My .config is attached.

2.6.21.3:

p34:~# /lib/nut/newhidups -u nut -DDDDDD auto
Checking device (050D/0912) (005/002)
- VendorID: 050d
- ProductID: 0912
- Manufacturer:
- Product: UPS
- Serial Number: unknown
- Bus: 005
Trying to match device
Device matches
HID descriptor retrieved (Reportlen = 820)
Size read for the report descriptor: 820
Report descriptor retrieved (Reportlen = 820)
Found HID device
Network UPS Tools: New USB/HID UPS driver 0.28 (2.0.4)

Report Descriptor size = 820
Report Descriptor: (200 bytes) => 05 84 09 04 A1 01 05 86 09 26 A1 02 85 01 75
08
Detected a UPS:        /UPS
Using subdriver: Belkin HID 0.1
Looking up 00840004
Looking up 00860026
Looking up 00860040
entering string_to_path()
parsing UPS
Looking up UPS
hid_lookup_usage: found 840004
parsing BELKINConfig
Looking up BELKINConfig
hid_lookup_usage: found 860026
parsing BELKINConfigVoltage
Looking up BELKINConfigVoltage
hid_lookup_usage: found 860040
Path depth = 3
0: UPage(84), Usage(4)
1: UPage(86), Usage(26)
2: UPage(86), Usage(40)
Entering libusb_get_report
=>> Before exponent: 120, 0/0)
=>> After conversion: 120.000000 (120), 0/0)
Report : (8 bytes) => 01 78 80 00 00 00 00 00
Path: UPS.BELKINConfig.BELKINConfigVoltage, Type: Feature, Value: 120.000000
Looking up 00840004
Looking up 00860026
Looking up 00860042

(works fine)

2.6.22-rc3:

p34:~# /lib/nut/newhidups -u nut -DDDDDD auto
Checking device (050D/0912) (005/002)
- VendorID: 050d
- ProductID: 0912
- Manufacturer: unknown
- Product: unknown
- Serial Number: unknown
- Bus: 005
Trying to match device
Device matches
failed to claim USB device, trying 2 more time(s)...
detaching kernel driver from USB device...
failed to detach kernel driver from USB device...
trying again to claim USB device...
failed to claim USB device, trying 1 more time(s)...
detaching kernel driver from USB device...
failed to detach kernel driver from USB device...
trying again to claim USB device...
failed to claim USB device, trying 0 more time(s)...
detaching kernel driver from USB device...
failed to detach kernel driver from USB device...
trying again to claim USB device...
Unable to get HID descriptor (error sending control message: Operation not
permitted)

     [ Part 2, ""  Application/OCTET-STREAM (Name: "config-2.6.22-rc3.bz2") ]
     [ 10KB. ]
     [ Unable to print this part. ]

