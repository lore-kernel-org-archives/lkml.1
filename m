Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbXLOVYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbXLOVYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 16:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757555AbXLOVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 16:24:11 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:46567 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbXLOVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 16:24:10 -0500
Date: Sat, 15 Dec 2007 16:24:09 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New question on that sata controller
In-reply-to: <47643FF6.7030701@shaw.ca>
To: Robert Hancock <hancockr@shaw.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200712151624.09115.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <fa.JX5deKXb3TDJ1pV6ig+xHviNfRI@ifi.uio.no>
 <47643FF6.7030701@shaw.ca>
User-Agent: KMail/1.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 December 2007, Robert Hancock wrote:
>Gene Heskett wrote:
>> Greetings;
>>
>> When I asked about a sata controller earlier this week, I gave a link to
>> it. Unforch (maybe) when it actually arrived, the cards box showed a
>> silicon image chip, and the card had a via.  So much for getting what I
>> ordered...
>>
>> The required module then was sata_via, not sata_uli, and it seems to be
>> working ok.  However, this one claims its a raid controller according to
>> an lspci -v:
>>
>> 01:0a.0 RAID bus controller: VIA Technologies, Inc. VT6421 IDE RAID
>> Controller (rev 50)
>>         Subsystem: VIA Technologies, Inc. VT6421 IDE RAID Controller
>>         Flags: bus master, medium devsel, latency 32, IRQ 19
>>         I/O ports at 9400 [size=16]
>>         I/O ports at 9800 [size=16]
>>         I/O ports at 9c00 [size=16]
>>         I/O ports at a000 [size=16]
>>         I/O ports at a400 [size=32]
>>         I/O ports at a800 [size=256]
>>         [virtual] Expansion ROM at e9000000 [disabled] [size=64K]
>>         Capabilities: [e0] Power Management version 2
>>
>> I just noted that the Expansion ROM is disabled, but I didn't see any
>> jumpers to enable it on the card prior to installing it.  Does anyone know
>> how this is supposed to work?  I would like to make it directly bootable
>> but I believe this has to be 'enabled' for that.
>
>It's usually normal for it to be disabled after boot, I believe. Are you
>getting anything showing up on boot indicating its BIOS is active?

No, not a thing.  Also invisible in the mainboards bios config AFAICT.

>> I cannot find any references to this particular chip in a 'make xconfig'
>> for 2.6.24-rc5.
>>
>> Should this be a concern, or is this one a 'Just Works(TM)' chipset?  This
>> card has 3 sata port connectors and one ide fitted.
>>
>> Two rather pleasant side effects of going to the Biostar.tw site and
>> finding a newer bios and installing it on an M7NCD Pro mobo are:
>>
>> 1: FSB now running at 400MHZ, was 333 before as it was not at all stable
>> at 400 and I have been told the XP-2800 Athlon only supports 333 and AMD's
>> site agrees.
>>
>> 2: CPU temps are down around 13F.  CPU speed still the same at 2079MHZ
>> according to dmesg.
>>
>> The reduced temps at a higher FSB indicates better interface timing, and
>> if it runs the rest of the night at 400 without a self reboot or crash,
>> I'll leave it there.

Running at 400 FSB it gradually ate itself and turned into a brick.  Took 
about 3 hours of screwing around to recover cuz even a cmos reset left it 400 
and it wouldn't recognize my usb keyboard, so I had to dig out an IBM 
clickity clakker, one of those cast iron models & plug it into the ps2 socket 
to get its attention and get back into the bios and get it slowed down.  This 
must have been good though cuz the cpu went down another 5 degrees when I 
did.

I did another install of F8 on that drive, but on the reboot, only FC6 
on /dev/hda1(=/boot and hda3=/) were visible so I'm still on FC6.

This is with a bios release only about 90 days old for what can best be 
described as a legacy mobo, a Biostar M7NCD Pro.  No onboard sata or 
firewire.

The install did put its bootfile stuff on /dev/sda1, and I've copied them back 
to the FC6 /boot partition, but I am confused as to how to handle the 
differences for this in the kernel arguments I use in adding that stanza to 
the existing /boot/grub/grub.conf, and, what to do with the differences 
in /boot/grub/device.map between the 2 installs.  Some guidance with this 
regard would be nice.

FWIW, the f8 install is on VolGroup01, so it does know the difference, but 
udev did NOT generate those files in /dev when it ran, so I'm reticent to do 
a fix there by any method but editing some udev file somehow so its permanent 
once done.

Thanks Robert.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Don't discount flying pigs before you have good air defense."
-- jvh@clinet.FI
