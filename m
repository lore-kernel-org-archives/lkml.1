Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYLaTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYLaTM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYLaTMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:12:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:3481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbYLaTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:12:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QhWdFiD2NtQdfU7GNTXkWxa6Go/8d2kuKxI4HOcucFB6AI+r9tFnzx/rwHPG6gwPPh
         uuEdmSKdWAkck3VDT2Abk4G/8zXsbP5BqnCjrASlyljf5niFKxdVmxZ5Jp0Bsy5hDIQI
         iUhXb7pYsS+tsdt38ygEVvoWdm0YCKtrFJxzo=
Date: Wed, 31 Dec 2008 22:12:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20081231191214.GF20882@localhost>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <87k59hur5f.fsf@basil.nowhere.org> <alpine.DEB.1.10.0812301737320.16936@asgard.lang.hm> <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <alpine.DEB.1.10.0812311204580.18334@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0812311204580.18334@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[david@lang.hm - Wed, Dec 31, 2008 at 12:07:33PM -0800]
> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>
>> [david@lang.hm - Wed, Dec 31, 2008 at 11:12:12AM -0800]
>>> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>>>
>>>> [david@lang.hm - Tue, Dec 30, 2008 at 05:39:29PM -0800]
>>>>> On Wed, 31 Dec 2008, Andi Kleen wrote:
>>>>>
>>>>>> david@lang.hm writes:
>>>>>>>
>>>>>>> doing a grep through System.map for the address that appears in the
>>>>>>> error returns nothing
>>>>>>
>>>>>> This might be obvious, but you can't grep directly for these addresses
>>>>>> because System.map contains the starting addresses of functions only
>>>>>> and normally the reported address is somewhere in the middle of a
>>>>>> function. So you instead have to look for the highest number lower or equal
>>>>>> the address from the exception.
>>>>>
>>>>> thanks, this was not obvious to me
>>>>>
>>>>> the -2 error maps to
>>>>>
>>>>> ffffffff8099e4c1 T free_bootmem_node
>>>>> ffffffff8099e4e5 t alloc_bootmem_core
>>>>> ffffffff8099e774 t ___alloc_bootmem_nopanic
>>>>>
>>>>>
>>>>> the first error maps to
>>>>>
>>>>> ffffffff809c2de4 T free_bootmem_node
>>>>> ffffffff809c2e08 t alloc_bootmem_core
>>>>> ffffffff809c3097 t ___alloc_bootmem_nopanic
>>>>>
>>>>>
>>>>> so it looks like this is in alloc_bootmem_core in both cases.
>>>>>
>>>>> David Lang
>>>>>
>>>>
>>>> Along with Andi's proposed earlyprintk=vga I think
>>>> bootmem_debug option could be usefull here too.
>>>
>>> adding bootmem_debug creates so much additonal output that the oops
>>> scrolls off the screen (except the last 'paragraph' of it)
>>>
>>> it looks like it's individual items being allocated (trying to scan it as
>>> it scrolled by)
>>
>> on the picture you sent me i noticed the message
>> "Your memory is not aligned you need to rebuild your
>> kernel with bigger NODEMAP SIZE shift=20" and then
>> srat code complains about "No NUMA code hash function found"
>> which looks a bit scary. Btw, could you post this picture
>> on some public resource so NUMA people could check it?
>
> http://linux.lang.hm/linux/IMG00030.jpg
>
> I'll try rebuilding with a bigger nodemap size and let you know
>
> David Lang
>

also you could just pass numa=off and check if it help.
(even if it help it would not mean that problem are gone
 but become hidden)

		- Cyrill -
