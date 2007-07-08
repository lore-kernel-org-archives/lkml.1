Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXGHJF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXGHJF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 05:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbXGHJFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 05:05:51 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:30012 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751610AbXGHJFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 05:05:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=aimcUBBU+bkCOFdY5zuS6xjTptt+bq6GcZ0DzKhIcx1OwUZ7lPIdiJ/7q6Bxz3wx4EYgUPYmchZSTTDyWKNrNLD8A9kcYmhNyoq6FbGjGG3+j4kXTL3X+O6PanriaXkHp4SBVnukeOm7QNnH0D5gOxBxkwalkyqmYWwzntA2F2w=  ;
X-YMail-OSG: c1LB9xoVM1nJEoPATwQ3QtPlKFWHfbinvxjHRX.eDOjJR62vqcFR5a4X5iuEk2eABGyW42LuLw--
Message-ID: <4690A8E9.9060605@yahoo.com.au>
Date: Sun, 08 Jul 2007 19:05:45 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
References: <20070705215152.GA4865@Krystal>  <468DDD3A.6010308@yahoo.com.au> <1183732495.17319.133.camel@localhost.localdomain>
In-Reply-To: <1183732495.17319.133.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2007-07-06 at 16:12 +1000, Nick Piggin wrote:
> 
>>Mathieu Desnoyers wrote:
> 
> 
>>>migration_disable();
>>>local_inc(&__get_cpu_var(&my_local_t_var));
>>>migration_enable();
>>>
> 
> 
> [...]
> 
> 
>>This seems like way too much stuff to add just for this type of thing. Why
>>not just disable and reenable preempt? Surely local_inc is not going to take
>>so long that disabling preemption matters.
> 
> 
> For this given example, it may be too much fine tuning. But there are
> other things (at least in RT) where this would be very helpful. One
> thing is that in RT an IRQ thread might service a softirq if that
> softirq thread is of the same priority as the IRQ thread. The difference
> between an IRQ thread and a softirq thread is that the IRQ thread may
> migrate but the softirq thread may not. So to do this performance
> enhancement, we need to temporarily pin the IRQ thread to the CPU, which
> is expensive (set_cpus_allowed).  This would make it much simpler and
> light weight to implement.

Well if this was just intended for -rt, then OK.


>>The task struct is not something we should just be carefree putting crap
>>into because it is seemingly free :(
>>
> 
> 
> Agreed, but as the subject says "RFC".  Perhaps we can make it a bit
> more complex and put this as one of the most significant bits in the
> preempt_count. We would just need to mask off that bit in all the archs
> when determining if we should preempt or not.  That's more complex, but
> keeps the task struct free from more luggage.

Just so long as it stays out of mainline without a good reason
that's fine.

-- 
SUSE Labs, Novell Inc.
