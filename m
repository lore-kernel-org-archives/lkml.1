Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYJHRTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYJHRTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYJHRTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:19:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbYJHRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:19:23 -0400
Message-ID: <48ECEB75.2080906@redhat.com>
Date: Wed, 08 Oct 2008 13:18:45 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
References: <20080804130317.994042639@chello.nl> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org> <20081008152708.GA11207@goodmis.org> <200810090252.15384.nickpiggin@yahoo.com.au>
In-Reply-To: <200810090252.15384.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>
>> This can be a source of bugs, where people might notice an outer lock
>> being released and think the inner locks were too.
>>
>> Lately the kernel has been going through a lot of clean ups that have
>> been making the kernel a much more maintainable beast. I feel we should
>> enforce the rule of unlocking order (again, unless there is a good
>> reason not to). Not for a technical reason, but just for a more
>> maintainable one.
>>     
>
> I don't really think it would make things more maintainable, FWIW.
>   

I actually did come across one bug in my lifetime where the out of 
nesting order
of unlocks caused a bug. IIRC, it had to do (as Linus mentioned) with 
lots of
little functions that required locking. One of these functions was 
between the
out of order unlocking and was taking another inner lock.

I don't remember the exact details, but it was something that made me 
try to nest
locks and unlocks nicely when possible. And as Linus pointed out, there 
are several
cases where it just doesn't make sense to nest.

-- Steve

