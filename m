Return-Path: <linux-kernel-owner+w=401wt.eu-S935887AbXGTWr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935887AbXGTWr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXGTWrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:47:22 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57753
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXGTWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:47:22 -0400
Date: Fri, 20 Jul 2007 15:39:19 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jim Crilly <jim@why.dont.jablowme.net>, Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linuxfoundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707210022.03205.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707201536330.5166@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
 <200707202343.29307.rjw@sisk.pl> <Pine.LNX.4.64.0707201435520.5166@asgard.lang.hm>
 <200707210022.03205.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Rafael J. Wysocki wrote:

> On Friday, 20 July 2007 23:39, david@lang.hm wrote:
>> On Fri, 20 Jul 2007, Rafael J. Wysocki wrote:
>>
>>> On Friday, 20 July 2007 17:36, david@lang.hm wrote:
>>>> On Fri, 20 Jul 2007, Jim Crilly wrote:
>>>>
>>>>>>> has
>>>>>>> requested the image to be not greater than 50% of RAM.  In that case you
>>>>>>> have
>>>>>>> to free some memory _before_ identifying memory to save and you must not
>>>>>>> race with applications that attempt to allocate memory while you're doing
>>>>>>> it.
>>>>>>
>>>>>> I disagree a little bit.
>>>>>>
>>>>>> first off, only the suspending kernel can know what can be freed and what
>>>>>> is needed to do so (remember this is kernel internals, it can change from
>>>>>> patch to patch, let alone version to version)
>>>>>>
>>>>>> second, if you have a lot of memory to free, and you can't just throw away
>>>>>> caches to do so, you don't know what is going to be involved in freeing
>>>>>> the memory, it's very possilbe that it is going to involve userspace, so
>>>>>> you can't freeze any significant portion of the system, so you can't
>>>>>> eliminate all chance of races
>>>>>>
>>>>>> what you can do is
>>>>>>
>>>>>> 1. try to free stuff
>>>>>> 2. stop the system and account for memory, is enough free
>>>>>> if not goto 1
>>>>>>
>>>>>> if userspace is dirtying memory fast enough, or is just useing enough
>>>>>> memory that you can't meet your limit you just won't be able to suspend.
>>>>>>
>>>>>> but under any other conditions you will eventually get enough memory free.
>>>>>>
>>>>>> so try several times and if you still fail tell the user they have too
>>>>>> much stuff running and they need to kill something.
>>>>>
>>>>> Which would be a pretty big regression from what we have now. With the
>>>>> current implementation I can hibernate under virtually any workload because
>>>>> the freezer stops everything and there's no competition for resources.
>>>>
>>>> as long as what you are trying to save is <=50% of ram (at least with some
>>>> implementations). if you are trying to save more then 50% of ram with some
>>>> current implmenetations you just can't
>>>
>>> With some, you can't, with the others, you can. :-)
>>>
>>> The argument given was about the freezer and IMO it was valid.
>>>
>>> Why didn't you address it directly?
>>
>> I thought it had been covered in other messages (with as big as this
>> thread is I'm trying to avoid repeating the same thing more then a couple
>> times a day :-)
>>
>> there was another message talking about ways that you could reduce the
>> image size without it being racy (allocate pinned memory until the
>> remainder is small enough, then don't backup the pinned memory)
>>
>> that's a much cleaner answer then what I was thinking, so I'll go with it
>> instead ;-)
>
> Wouldn't that cause the OOM killer to act, in some cases?

only in the case where the image absolutly cannot be made small enough.

and this should be detectable by the process that's pinning memory (this 
can be a kernel process) so that it stops before the OOM killer is 
triggered, even if that means that it returns 'unable to fit'

David Lang

