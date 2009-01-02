Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbZABIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbZABIZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZABIZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:25:17 -0500
Received: from rtr.ca ([76.10.145.34]:49879 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbZABIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:25:15 -0500
Message-ID: <495DCF69.8000207@rtr.ca>
Date: Fri, 02 Jan 2009 03:25:13 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: libusb broken on 2.6.28 x86_64 ?
References: <495DB4AC.50602@rtr.ca> <495DBBC1.7040202@rtr.ca> <20090102072436.GA3444@suse.de> <495DC771.9030103@rtr.ca> <20090102075835.GA3955@suse.de> <495DCD18.8060900@rtr.ca>
In-Reply-To: <495DCD18.8060900@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Greg KH wrote:
>> On Fri, Jan 02, 2009 at 02:51:13AM -0500, Mark Lord wrote:
>>> Greg KH wrote:
>>>> On Fri, Jan 02, 2009 at 02:01:21AM -0500, Mark Lord wrote:
>>>>> Mark Lord wrote:
>>> ..
>>>>> Mmm.. broken only for 64-bit userspace, it seems.
>>>>>
>>>>> I've recompiled the same app against 32-bit libs,
>>>>> and it works just fine on that 64-bit system,
>>>>> as well as on 32-bit systems.
>>>>>
>>>>> But not when compiled for pure 64-bit operation on a 64-bit system.
>>> ..
>>>> Which version of libusb, a new one was just released a few weeks ago
>>>> that fixes a lot of problems reported in the older libusb versions, and
>>>> made things much faster to boot.  You might want to check it out.
>>> ..
>>>
>>> This is with libusb-0.1-4, which has been working fine with all prior 
>>> kernels,
>>> including the 2.6.27.xx series.
>>>
>>> Userspace stuff like this is not supposed to be broken from kernel to 
>>> kernel.
>>
>> No it shouldn't, I was thinking this was the first time you had tried
>> such a thing (64bit userspace apps.)
>>
>> If using 2.6.27 works, then we need to fix this.
> ..
> 
> Yup.  I don't really see anything likely in kernel from 2.6.27 to 2.6.28,
> other than perhaps the new "poisoning" code.  I wonder if that could be it?
> 
> Kinda weird that the device works with libusb the first time it is used,
> but then fails on all subsequent runs of the same app, until replugged.
> 
> But.. I can run the 32-bit compat app after a 64-bit failure,
> and *that* does work.  There's gotta be a useful clue in there somewhere.
..

It is failing on the very first submiturb call, getting -ENOENT back:

open("/dev/bus/usb/004/002", O_RDWR)    = 3
ioctl(3, USBDEVFS_GETDRIVER, 0x7fff5d0486b0) = -1 ENODATA (No data available)
ioctl(3, USBDEVFS_CLAIMINTERFACE, 0x7fff5d0487bc) = 0
ioctl(3, USBDEVFS_CLEAR_HALT, 0x7fff5d0487c4) = 0
ioctl(3, USBDEVFS_SUBMITURB, 0x7fff5d0486c0) = -1 ENOENT (No such file or directory)

