Return-Path: <linux-kernel-owner+w=401wt.eu-S938077AbXGTWu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938077AbXGTWu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbXGTWuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:50:51 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57765
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXGTWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:50:50 -0400
Date: Fri, 20 Jul 2007 15:43:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Stern <stern@rowland.harvard.edu>
cc: Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.64.0707201540260.5166@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007, Alan Stern wrote:

> On Fri, 20 Jul 2007, Jeremy Maitin-Shepard wrote:
>
>>>> when doing a suspend-to-ram you get to a point where you just don't use
>>>> any userspace.
>>
>>> What do you mean?  How can you prevent user tasks from running?  That's
>>> basically what the freezer does, and the whole point of this approach
>>> is to eliminate the freezer.  Right?
>>
>> Presumably no tasks at all would be scheduled.
>
> How would you prevent tasks from being scheduled?  How would you
> prevent drivers from deadlocking because in order to put their device
> in a low-power state they need to acquire a lock which is held by a
> user task?

you give up on the suspend becouse you have no way of getting the user 
task to give up the lock.

however, kernel locks should not be held by user tasks, user tasks are not 
expected to behave in rational ways, allowing them to compete with kernel 
tasks for locks is a sure way to get a deadlock or indefinate stall.

what locks are accessed this way?

>>>> from that point on you are just walking the device tree
>>>> putting things into low-power mode. This is the point where we are talking
>>>> about jumping to.
>>
>>> Yes.  And putting things into low-power mode requires the ability to
>>> run the scheduler, which means that user tasks can be scheduled, which
>>> means that they can run.
>>
>> Does it really (fundamentally) require scheduling tasks, particularly in
>> the case that the devices have already been put in the "quiesced" state?
>
> I can't say for sure.  That's the way we have been doing it.  It
> wouldn't be easy to change, because the driver would have to busy-wait
> during delays -- which would mean it would need to use different code
> for system-wide suspend and runtime suspend.

please define terms so that we are all on the same page

what do you mean by
system-wide suspend
runtime suspend

David Lang
