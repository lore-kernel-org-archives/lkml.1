Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZIGSqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZIGSqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZIGSqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:46:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57143 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZIGSqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:46:38 -0400
Date: Mon, 7 Sep 2009 20:46:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907184640.GG18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk> <4AA54AA7.9080709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA54AA7.9080709@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Avi Kivity wrote:
> On 09/07/2009 12:49 PM, Jens Axboe wrote:
>>
>> I ran a simple test as well, since I was curious to see how it performed
>> wrt interactiveness. One of my pet peeves with the current scheduler is
>> that I have to nice compile jobs, or my X experience is just awful while
>> the compile is running.
>>    
>
> I think the problem is that CFS is optimizing for the wrong thing.  It's  
> trying to be fair to tasks, but these are meaningless building blocks of  
> jobs, which is what the user sees and measures.  Your make -j128  
> dominates your interactive task by two orders of magnitude.  If the  
> scheduler attempts to bridge this gap using heuristics, it will fail  
> badly when it misdetects since it will starve the really important  
> 100-thread job for a task that was misdetected as interactive.

Agree, I was actually looking into doing joint latency for X number of
tasks for the test app. I'll try and do that and see if we can detect
something from that.

-- 
Jens Axboe

