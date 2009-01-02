Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbZABU5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbZABU5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbZABU5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:57:37 -0500
Received: from main.gmane.org ([80.91.229.2]:34172 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758298AbZABU5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:57:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: early exception error
Date: Fri, 02 Jan 2009 14:57:17 -0600
Message-ID: <495E7FAD.6020305@shaw.ca>
References: <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: david@lang.hm, Andi Kleen <andi@firstfloor.org>
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
In-Reply-To: <20090102172426.GB5372@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [david@lang.hm - Fri, Jan 02, 2009 at 10:21:52AM -0800]
>> On Wed, 31 Dec 2008, david@lang.hm wrote:
>>
>>> On Thu, 1 Jan 2009, Andi Kleen wrote:
>>>
>>>> On Wed, Dec 31, 2008 at 12:59:08PM -0800, david@lang.hm wrote:
>>>>> On Wed, 31 Dec 2008, Andi Kleen wrote:
>>>>>
>>>>>>> on the picture you sent me i noticed the message
>>>>>>> "Your memory is not aligned you need to rebuild your
>>>>>>> kernel with bigger NODEMAP SIZE shift=20" and then
>>>>>>> srat code complains about "No NUMA code hash function found"
>>>>>>> which looks a bit scary. Btw, could you post this picture
>>>>>>> on some public resource so NUMA people could check it?
>>>>>> This case used to be handled cleanly (NUMA disabled), but perhaps
>>>>>> that has regressed. But still it sounds like something is going wrong,
>>>>>> unless his machine really has a very weird memory map.
>>>>> it shouldn't, it was one of the high-volume servers 4-5 years ago and only
>>>>> has 4G of ram in it
>>>> From looking at the screenshot Cyrill sent you seem to have a funny
>>>> SRAT with overlapping areas that is rejected in the end. I suspect the
>>>> fallback code doesn't handle this properly.
>>>>
>>>> Does it work when you boot with numa=noacpi ?
>>> it gets past the point where the bootmemory_debug messages flow by, but 
>>> I get another oops (snapshot of the screen is at  
>>> http://linux.lang.hm/linux/IMG00031.jpg )
>> oops, I misread your mail, IMG00031.jpg was with numa=off
>>
>> I just posted IMG00033.jpg which is with numa=noacpi and earlyprintk=vga  
>> but not bootmem_debug
>>
>> David Lang
>>
> 
> Thanks, David! Trying to understand what is going on :)
> 
> Here is a new picture if someone would like to jump into
> the bug handling
> 
> 	http://linux.lang.hm/linux/IMG00033.jpg

alloc_bootmem_core is a reasonably big function, it would be useful if 
we could track down what line it's blowing up on.. Can you try to find 
out what line that fault address (ffffffff8096452a in this crash) is on 
as described in Documentation/BUG-HUNTING, i.e. build with 
CONFIG_DEBUG_INFO enabled, run gdb on vmlinux and do:

l *0xffffffff8096452a

