Return-Path: <linux-kernel-owner+w=401wt.eu-S936699AbXGMJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936699AbXGMJc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbXGMJcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:32:16 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:54054
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936467AbXGMJcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:32:13 -0400
Date: Fri, 13 Jul 2007 02:25:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707131117.38426.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707130211570.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <877ip54cti.fsf@jbms.ath.cx> <Pine.LNX.4.64.0707122008550.25614@asgard.lang.hm>
 <200707131117.38426.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:

> Date: Fri, 13 Jul 2007 11:17:37 +0200
> From: Rafael J. Wysocki <rjw@sisk.pl>
> To: david@lang.hm
> Cc: Jeremy Maitin-Shepard <jbms@cmu.edu>,
>     "Huang, Ying" <ying.huang@intel.com>,
>     Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
>     nigel@nigel.suspend2.net, linux-kernel@vger.kernel.org,
>     linux-pm@lists.linux-foundation.org
> Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
> 
> On Friday, 13 July 2007 05:12, david@lang.hm wrote:
>> On Thu, 12 Jul 2007, Jeremy Maitin-Shepard wrote:
>>
>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>>>> 3. Support the in-place kexec? The relocatable kernel is not necessary
>>>>>>> if this can be implemented.
>>>>>>> 4. Image writing/reading. (Only user space application is needed).
>>>>>>
>>>>>> And a kernel interface for that application.
>>>>>
>>>>> I do't understand this statement, this application is just useing the
>>>>> standard kernel interfaces (block devices to read/write to disk, network
>>>>> devices to read/write to a server, etc). no new interfaces needed.
>>>
>>>> Yes, but it will have to know _what_ to save, no?
>>>
>>> I agree that a kernel interface would be important; something like
>>> /dev/snapshot that can be read by the "save image" kernel, and written
>>> to by the "restore image" kernel.  Note that similarly, kdump provides a
>>> kernel interface to an ELF image of the old kernel.
>>
>> I thought that the idea was to save the entire contents of ram so that
>> caches, etc remain populated.
>>
>> having the system kernel free up ram and then making a sg list of what
>> memory needs to be backed up would be a nice enhancement, but let's let
>> that remain a future enhancement until everyone agrees that the basic
>> approach works.
>
> It's not that easy. :-)
>
> First, there are memory regions that we don't want to save, because the
> restoration of them may cause problems (generally all of the reserved pages
> fall into this category).
>
> We also don't want to save free RAM and we don't want to save the memory
> occupied by the hibernation kernel (ie. the "new" one).

free ram is useually a pretty small number of pages (unless you free up 
ram before suspend). avoiding the ram reserved for the new kernel should 
be pretty simple (actually, it doesn't hurt much to save that ram, it just 
hurts if you try to restore it)

> Also, please note that we can't restore 100% of RAM, even if we save it.

Ok, now we need a data channel from the old kernel to the hibernate 
kernel, to the restore kernel. and the messier the memory layout the 
larger this data channel needs to be (hmm, what's the status on the memory 
defrag patches being proposed?) if this list can be made small enough it 
would work to just have the old kernel put the data in a known location in 
ram, and let the other two parts find it (in ram for the hibernate kernel, 
in the hibernate image for the wakeup kernel). how do the existing 
hibernate processes store this? since people are complaining about the 
amount of ram that a kexec kernel would take up I'm assuiming it's 
somethingmore complex then just a bitmap of all possible pages.

most of the conversation so far has been around the process of makeing the 
snapshot and storing it. what are the processes and tools available to 
restore images?

David Lang
