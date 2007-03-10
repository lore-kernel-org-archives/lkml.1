Return-Path: <linux-kernel-owner+w=401wt.eu-S1767696AbXCJA7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767696AbXCJA7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767698AbXCJA7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:59:11 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:59520 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767696AbXCJA7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:59:09 -0500
Date: Fri, 09 Mar 2007 19:59:07 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [linux-usb-devel] Question re hiddev
In-reply-to: <02da01c762a9$20988510$84163e05@kroptech.com>
To: "Adam Kropelin" <akropel1@rochester.rr.com>, jikos@suse.cz,
       linux-kernel@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net
Message-id: <200703091959.07232.gene.heskett@verizon.net>
Organization: Organization? Not detectable
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703081354.28281.gene.heskett@verizon.net>
 <200703090103.32583.gene.heskett@verizon.net>
 <02da01c762a9$20988510$84163e05@kroptech.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007, Adam Kropelin wrote:
>Gene Heskett wrote:
>> On Thursday 08 March 2007, Gene Heskett wrote:
>>> Greetings;
>>>
>>> Belkin is being non-responsive to requests for updated drivers for
>>> their line of UPS's, all of which now have a USB port which is the
>>> Belkin recommended way to talk to these things.
>>>
>>> Unforch, the belkin supplied *nix stuff was last compiled on an rh5.2
>>> machine using gcc-2.7.2, so there has been some bitrot.
>>>
>>> I believe the problem to be that when their version of upsd is
>>> trying to open the /dev/name its given, it is assuming and hard
>>> coded to do the ioctl's to set the ports speed in baudrate, width of
>>> word, parity etc.
>>>
>>> Getting failure messages for that, it retrys the open until it has
>>> 1024 links to /dev/hiddev0 according to an lsof|grep hiddev0, all of
>>> which presumably have failed so it never actually opens the
>>> /dev/hiddev0 port in r/w mode successfully.
>>>
>>> I can, from a shell, 'cat' the data from this port, its not very fast
>>> taking about 8-10 seconds to output all the integers or bytes to
>>> constitute a complete screen update when translated by the gui into
>>> sensible data.
>>>
>>> My proposal, and I'll see if I can make a patch, is to add to the
>>> hiddev.c code, stubs for these otherwise useless functions that do
>>> nothing but return a 0 indicating success so that these legacy
>>> drivers can make use of a port whose data is just fine but fails
>>> these configuration things that don't mean squat to hiddev anyway.
>>>
>>> Would this effort at making legacy drivers who think they are
>>> using /dev/ttySx, work with /dev/hiddev constitute an acceptable
>>> reason for such a patch to hiddev.c?
>>
>> Its been about a day now, and no one has commented.  Am I an idiot or
>> ??
>
>I think you fundamentally misunderstand hiddev. It's an interface to HID
>devices, which are not (NOT!) byte streams of the sort you'd get on
>/dev/ttySx. hiddev speaks in specific structures via read/write/ioctl as
>detailed in Documentation/usb/hiddev.txt. Any application which is
>making tty ioctls to set baud rate, etc. will never work (unmodified)
>with hiddev.
>
>Your Belkin UPS may follow the USB HID class spec for Power Devices, in
>which case a suite like NUT will be able to handle it with their
>USB-generic driver.
>
>--Adam

I *think* I had the nut daemon working a couple of days ago, it at least 
ran without getting a tummy ache and upchucking into the logs.  But as 
for using that data usefully, nuts docs might as well be written in 
swahili.  It also doesn't seem to have a gui like the belkin programs 
give.  Or I don't know how to set it up to use a gui.  Either is a strong 
possibility...

If anyone else has it working, please speak up.  The ups is a Belkin 
F6C-1500, with some more adjectives appended that have nothing to do with 
the electronics in it.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
UPS interrupted the server's power
