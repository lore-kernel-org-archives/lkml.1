Return-Path: <linux-kernel-owner+w=401wt.eu-S934075AbXHYL7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbXHYL7W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 07:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXHYL7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 07:59:14 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:43896 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbXHYL7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 07:59:13 -0400
Message-ID: <46D0194E.6090903@tremplin-utc.net>
Date: Sat, 25 Aug 2007 13:58:06 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.6) Gecko/20070805 Mandriva/2.0.0.6-2mdv2008.0 (2008.0) Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: James Bruce <bruce@andrew.cmu.edu>
CC: linux-kernel@vger.kernel.org, Casey Dahlin <cjdahlin@ncsu.edu>
Subject: Re: USB Key light on/off state depending on mount
References: <fa.BwCgwGvTNIOD+KEeBrvP11xCEmw@ifi.uio.no> <46CF6791.8040509@shaw.ca> <46D00928.1080901@andrew.cmu.edu>
In-Reply-To: <46D00928.1080901@andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

25/08/07 12:49, James Bruce wrote/a écrit:
> Robert Hancock wrote:
>> Casey Dahlin wrote:
>>> Most USB keys nowadays have a small LED somewhere inside of them that 
>>> lights up when they are plugged in. On a windows box, the key is lit 
>>> up whenever it is mounted, and as soon as it is unmounted it turns 
>>> off, giving a handy physical indicator that the key is safe to 
>>> remove. On linux, the light is simply on whenever the key is plugged in.
>>>
>>> Should linux toggle the light depending on mount state? Is it as 
>>> trivial as it seems or does this reflect some larger issue?
>>
>> I think that Windows turns off power to the port when you do the 
>> "safely remove hardware" on it, or something like that. Mount/unmount 
>> doesn't really indicate whether the device is in use in Linux, though, 
>> since it can still be potentially accessed even when the device isn't 
>> mounted.
> 
> If there is a way to toggle the power state from userspace, then a 
> desktop environment or userland tool can emulate the Windows behavior if 
> that is desired.  A lot of devices can charge via USB now, and this is 
> actually more convenient on Linux than on Windows (in effect Windows 
> requires drivers in order to charge something).  However, having direct 
> control over this is useful.
Yes, maybe some userspace such as HAL could turn off the usb devices at 
the same time it's unmounted. Actually that would be rather intuitive 
way to tell the user the umount is finished. There doesn't seem to be 
any loss of funcitonality, once it's turned off you can still re-access 
the device, and it's automatically turned on again (at least on my PC).

For the record, here is how one can switch off a usb device (as root):
# cd /sys/bus/usb/devices/usb*/[0-9]-[0-9] (just go to the directory of 
the device)
# echo -n 2 > *:1.0/power/state
# echo -n 2 > power/state

I use this to turn off my optical mouse when watching movies, but it 
works fine as well to turn off usb storage devices.
It can also be turned on with
# echo -n 0 > power/state

See you,
Eric
