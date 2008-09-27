Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYI0RvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYI0RvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYI0Rlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:41:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47982 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbYI0Rlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:41:31 -0400
Message-ID: <48DE7016.5040209@redhat.com>
Date: Sat, 27 Sep 2008 20:40:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][RFC] ioctl dispatcher
References: <1222530242-1272-1-git-send-email-avi@redhat.com> <20080927091304.12b8c4c3@infradead.org>
In-Reply-To: <20080927091304.12b8c4c3@infradead.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>   
>> While ioctls are officially ugly, they are the best choice for some
>> use cases, not to mention compatibility issues.  Currently ioctl
>> writers face the following hurdles:
>>
>> - if the ioctl uses a data buffer, the ioctl handler must allocate
>>   kernel memory for this buffer
>>   - the memory may be allocated on the heap or on the stack,
>> depending on the buffer size
>> - handle any errors from the operation
>> - copy the data from userspace, if necessary
>> - handle any errors from the operation
>> - actually perform the operation
>> - copy the data back to userspace, if necessary
>> - handle any errors from the operation
>> - free the buffer, if allocated from the heap
>>
>> The first patch automates these operations, only requiring the caller
>> to supply the ioctl number and a callback in a table.
>>
>>     
> this doesn't seem to be much different from the way the DRM code deals
> with ioctls. Or the V4L code.
> Personally I hate that code though.....
>
> There is a fine balance here; between driver writers screwing something
> up they shouldn't be doing in the first place and us being able to
> clearly see what the code is doing; your patch kinda hides some key
> elements of the ioctl path... 

Which key elements?

It hides the big switch (ioctl), memory allocation, and error handling, 
and exposes the actual ioctl-specific code, which I thought was the key 
element.

Why are we interested in boilerplate?

> I'm afraid it gives a false sense of
> security though. Not having to deal with one aspect of security just to
> have to deal with the rest....
>   

It reduces the number of potential mistakes a driver author can make.

> Lets put it this way: if the driver author has to type "copy_from_user"
> there's a chance that he'll remember that the data comes from the user
> and isn't to be trusted on face value.
>   

I'll rename the argp variable to argp_user_supplied.

I can't believe you think writing the copy code from scratch (or worse, 
copy/paste) each time helps security.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

