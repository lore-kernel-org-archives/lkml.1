Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbZJaXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbZJaXng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 19:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbZJaXnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 19:43:35 -0400
Received: from lucidpixels.com ([75.144.35.66]:52887 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320AbZJaXne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 19:43:34 -0400
Date: Sat, 31 Oct 2009 19:43:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       nut-upsuser@lists.alioth.debian.org, bruce.w.allan@intel.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.31.4: Intel P55 Chipset BUG [usbhid-raw/devices/broken?]
 [tested 3 different UPS']
In-Reply-To: <Pine.LNX.4.44L0.0910311115301.7118-100000@netrider.rowland.org>
Message-ID: <alpine.DEB.2.00.0910311847530.5522@p34.internal.lan>
References: <Pine.LNX.4.44L0.0910311115301.7118-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 31 Oct 2009, Alan Stern wrote:

> On Sat, 31 Oct 2009, Justin Piszcz wrote:
>
>> Hello,
>>
>> SUMMARY: P55 Chipset/USB has issues with UPS' (broken pipe on 3 diff UPS')
>> WORKAROUND: Buy/use PCI USB card if you want to use nut/connect a UPS.
>> NOTES: All other USB (non-UPS) devices seem to function without any
>>         problems.
>>
>> On Thu, 29 Oct 2009, Justin Piszcz wrote:
>>
>>> Problem: When I migrated from a DG965WH -> DP55KG motherboard, there were
>>> quite a bit of issues, host still does not reboot without special flags, e.g.
>>> reboot=a, the NIC driver is broken with the in-kernel version (the one on
>>> e1000.sourceforge) fixes that and finally my UPS USB has driver stale
>>> problems, with two issues already relating to the HW/drivers themselves it
>>> would not be unrealistic to speculate that there could be an issue with the
>>> USB chipset/driver with this P55 motherboard.
>>
>> --
>>
>> Tried another APC 1500VA UPS, same problem occurs, different cable/port etc.
>>
>> Problem appears to be the Intel P55KG / USB Chipset in the way that it
>> handles usbhid-raw devices as CD/USB sticks/kbd/mouse/etc do not appear to
>> be affected.
>>
>> So far all other USB devices work fine, with the exception of UPS', I
>> have tested two APC 1500VA (one an RS the other an XS), in addition I also
>> have a 'BELKIN 1200VA UPS with AVR' from a long time ago, the same
>> problem occurs.
>
> ...
>
>> A bit frustrated, I popped in a PCI card with 4 external USBs, and now no
>> more errors:
>
> We might learn something by comparing two usbmon logs for the same UPS
> device, one plugged into a USB port on the motherboard and the other
> plugged into an add-on card.
>
> Alan Stern
>

Hi Alan,

Got it--two runs:

1. 5 minutes of usbmon output on via chipset [working]
2. 5 minutes of usbmon output on intel p55 usb chipset [ehci/not working]

-- 

ORDER:

1. cat 0u | tee /tmp/1.mon.out
2. /etc/init.d/nut start
3. sleep 300; killall -9 cat

--

OUTPUT:

----

Issues/5-minute run (initial errors mainly occur within the first 2 min)
(5 minute capture)
http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.txt
Issues/5-minute run (initial errors mainly occur within the first 2 min)
(again) (5 minute capture)
http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.one.more.time.txt
Errors past 5 minutes occur around 6-7 minutes and later, hence this last one
nut had been running for 5-7 minutes when I started it, it captured a
disconnect and reconnect toward the end FYI. (capture until error > 5 min)
http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.one.more.time.while.nut.is.running.txt

No issues on the PCI USB card: (5 minute capture)
http://home.comcast.net/~jpiszcz/20091031/1.mon.out.via.no.errors.txt

==

FILES:

wget http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.one.more.time.txt
wget http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.one.more.time.while.nut.is.running.txt
wget http://home.comcast.net/~jpiszcz/20091031/1.mon.out.p55chipset.2.txt
wget http://home.comcast.net/~jpiszcz/20091031/1.mon.out.via.no.errors.txt

Justin.

