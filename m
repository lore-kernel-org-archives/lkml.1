Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbXIVRLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbXIVRLH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbXIVRKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:10:55 -0400
Received: from smtp3.versatel.nl ([62.58.50.90]:58166 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbXIVRKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:10:55 -0400
Message-ID: <46F54C08.3050300@hhs.nl>
Date: Sat, 22 Sep 2007 19:08:24 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070813)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive
 leds
References: <Pine.LNX.4.44L0.0709221020080.22762-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709221020080.22762-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sat, 22 Sep 2007, Hans de Goede wrote:
> 
>> I'm afraid that that doesn't work for usb mass-storage devices.
>>
>> Here is what I did:
>> 1) kill hal
>> 2) insert usb stick -> led lights
>> 3):
>> echo -n 1 >    /sys/bus/usb/devices/.../power/autosuspend
>> echo -n auto > /sys/bus/usb/devices/.../power/level
>>
>> 4) wait
>>
>> Nothing happens, where as sending "suspend" to power/level does turn the led 
>> off.
> 
> I don't know what went wrong.  It works fine on my systems.  You did 
> fill in the correct device path for the "...", right?

Yes, the one that comes and goes as I plug in one of the USB-sticks I ue for 
testing.

> And you don't 
> need the "-n" -- adding it shouldn't matter, but you should try reading 
> back the contents of those files to make sure the values did get 
> written correctly.
>

I did read them back and it did get written correctly.

>> Now call me naive, but I would expect a mass-storage devices with no 
>> partitions mounted to autosuspend when autosuspend is enabled for that device.
> 
> Yes, that is naive.  The driver has no way to tell whether or not any 
> partitions are mounted.  Furthermore, you might very well want to 
> access the raw device without mounting any partitions (database 
> managers frequently do such things to reduce I/O overhead), in which 
> case you certainly would not the device to be autosuspended.
> 

How does this relate to your "It works fine on my systems" remark, do I need to 
do anything other the unmounting the paritions to make the device eligible for 
autosuspend, like unbind the sd driver or even the usb-storage driver?

If so I must say I find that a little counter intuitive.

Regards,

Hans


p.s.

As always, please keep me CC-ed, not on the list.

