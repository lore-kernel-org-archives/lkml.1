Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0CCMJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:09:32 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:40685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab0CCMJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:09:28 -0500
Date: Wed, 3 Mar 2010 13:09:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: John Hughes <john@Calva.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15426] New: Running many copies of bonnie++
	on different filesystems seems to deadlock in sync
Message-ID: <20100303120927.GQ5768@kernel.dk>
References: <bug-15426-10286@http.bugzilla.kernel.org/> <20100302161627.bf02d0a2.akpm@linux-foundation.org> <4B8E517E.3010702@Calva.COM> <20100303115015.GN5768@kernel.dk> <4B8E5805.30505@Calva.COM> <20100303120317.GP5768@kernel.dk> <4B8E59CC.2030004@Calva.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8E59CC.2030004@Calva.COM>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, John Hughes wrote:
> Jens Axboe wrote:
>> On Wed, Mar 03 2010, John Hughes wrote:
>>   
>>> Just a thought.  What exactly is sync(2) supposed to do - block until 
>>>  there are no more dirty pages, or block until all pages that were 
>>> dirty  when the sync was done are clean?  In other words is the 
>>> problem simply  that pages are being dirtied faster than the sync is 
>>> writing them out?
>>>     
>>
>> Our sync is currently broken in that regard, since it'll wait for too
>> long. We have a debated patch going, I have included it below. Any
>> chance you could give it a whirl?
>>
>> The semantics of sync are supposed to be 'wait for dirty IO generated
>> BEFORE this sync call'.
>>   
> Ok, I will try this patch and get back to you.

Looking at your bug report, I saw that you were on 2.6.32. If you are
testing 2.6.33, let me know, the patch wont apply (I have another
variant for that).

-- 
Jens Axboe

