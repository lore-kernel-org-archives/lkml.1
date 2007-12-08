Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbXLHSR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbXLHSR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXLHSRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:17:47 -0500
Received: from simmts7-qfe0.srvr.bell.ca ([206.47.199.165]:36175 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbXLHSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:17:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAC9uWkecIsMU/2dsb2JhbAAI
Message-ID: <475ADFC5.4030108@gmail.com>
Date: Sat, 08 Dec 2007 14:17:41 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Walker <dwalker@mvista.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Possible locking issue in viotape.c
References: <20071206021857.826386004@mvista.com>	 <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu>	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>	 <47588610.5010804@gmail.com>	 <1196989515.1568.131.camel@jnielson-xp.ddns.mvista.com>	 <4758A216.3030401@gmail.com> <1196991637.1568.140.camel@jnielson-xp.ddns.mvista.com>
In-Reply-To: <1196991637.1568.140.camel@jnielson-xp.ddns.mvista.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Thu, 2007-12-06 at 21:29 -0400, Kevin Winchester wrote:
>> Daniel Walker wrote:
>>> I've posted all the ones I've done so far ..
>>>
>>> ftp://source.mvista.com/pub/dwalker/sem2mutex-2.6.24-rc4/
>>>
>>> Feel free to review or test them.. I've found it pretty easy to simply
>>> grep for certain class of semaphore usage, check if it's conforming to
>>> the mutex requirements, then convert it or not.. Checking them is
>>> getting to be a habit, so I don't think a list would help me.. However,
>>> someone else might be able to use it..
>>>
>> Thanks, that helps me not duplicate anything.  One of the first ones I
>> was looking at (before your post) was viotape.c, which is in your patch
>> set.  However, looking at the uses of the semaphore, I see that on line
>> 409-410 the following code:
>>
>>         if (noblock)
>>                 return count;
>>
>> which seems to ignore the fact that the semaphore has been downed (not
>> to mention the dma buffer and op struct allocations.  I think it should be:
>>
>> 	if (noblock)
>> 		ret = count;
>> 		goto free_dma;
>>
>> instead.  Do you want to make sure I'm right about that and fold it into
>> your patch?  Or have you already submitted your patch (or should it be
>> in a separate patch?  Alternatively, I can submit the patch if you don't
>> want to bother with it.
> 
> viotape was one of the first I started converting, but later I noticed
> the same thing you found above. I have it commented out of my series for
> that reason ..
> 
> I think this noblock path is actually doing what the author intended..
> There are a few stray up() calls related to event handling and ioctls ,
> and I think those are used to release the semaphore..
> 
> Daniel
> 
> 

Yes, you are right, I hadn't finished looking at all of the up() calls
when I came to my conclusion.  I will try to convert a few that are not
on your list, but I would like to know how you are generating your
patches into those files with the diffstat and recipient list.  Is that
a feature of some git command?

-- 
Kevin Winchester
