Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXGNHUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXGNHUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758238AbXGNHUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:20:41 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:52508
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758192AbXGNHUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:20:39 -0400
Date: Sat, 14 Jul 2007 00:12:04 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
In-Reply-To: <200707131359.53309.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0707140008130.25614@asgard.lang.hm>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
 <200707131129.34974.rjw@sisk.pl> <Pine.LNX.4.64.0707130227310.25614@asgard.lang.hm>
 <200707131359.53309.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Rafael J. Wysocki wrote:

>> remember release early, release often (with something that functions)
>>
>>>> fo rthe current stage where we are trying to make things work don't worry
>>>> about packaging everything tight with initrd and re-useing partitions or
>>>> kernel images. once everything is working reliably then it's time to look
>>>> at useing the same kernel for multiple functions, writing to a partition
>>>> that's i use for other things, etc
>>>
>>> I don't agree.  You need to think of many limitations in advance, because
>>> they need to be taken into consideration in the design.
>>>
>>> Otherwise we'll end up with something that will need to be bandaided like the
>>> freezer. :-)
>>
>> on the other hand, worrying about all the possible ways to do things can
>> paralize you.
>>
>> the big advantage of the kexec approach is that the new userspace that's
>> setup with the new kernel can do _anything_.
>
> No, it can't.  For example, it can't access filesystems mounted by the
> hibernated kernel, or they may get corrupted after the restore (if they are
> journaling, it can't even read from them).

it's only ext3 that has this bug when mounting a fileystem read-only 
AFAIK.

> Which reminds me of one more issue, which is that the image-saving kernel
> won't be able to use these filesystems either, so its modules and user space
> will have to be available from somewhere else (like a RAM disk or dedicated
> partition).  So things get ugly.

another reason to go ahead and make a dedicated no-module kernel for the 
hibernate phase ;-)

> Apart from this, the new kernel's user space cannot blindly modify swap space
> that might be in use by the hibernated kernel.

with swap space you have two options

1. free it up (to a swap file if needed) and don't worry about it

2. try and ensure that nothing else on the system attempts to use the swap 
partition until you reboot.

#2 is failure prone, #1 would be more reliable.

David Lang
