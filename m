Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbXGKBQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbXGKBQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXGKBP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:15:56 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:48817 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757460AbXGKBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:15:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=33pEKxHCo+bVldt79eMuX4JzjXfym1KmyUYDApm/EjIzKc/HioCMVS+OlIxAGrG7KawOyVoQQ+HZXfH6tUk0sGC6L2/uE7zgKyLR6lvjXb3l1kuBmnHFIRnkG2H4+np9HC9nAOM9cHUIcLxNpfzf522JF96z4KHsgSk1HcjMk2E=  ;
X-YMail-OSG: yxkUs74VM1nvw4vH96VJNtqvIjBnk0JP3FDgJaHdSGgbiHnXZ5IhApmKgWZQsEhFdNnFe0pMZg--
Message-ID: <46942F45.2090502@yahoo.com.au>
Date: Wed, 11 Jul 2007 11:15:49 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Matt Mackall <mpm@selenic.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au> <20070710233938.GT11166@waste.org> <46941E0F.3040209@yahoo.com.au> <20070711003611.GY11115@waste.org> <20070711005514.GA29071@Krystal>
In-Reply-To: <20070711005514.GA29071@Krystal>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Matt Mackall (mpm@selenic.com) wrote:
> 
>>On Wed, Jul 11, 2007 at 10:02:23AM +1000, Nick Piggin wrote:
>>
>>>>I like this patch a lot. Even if we don't add the underlying mechanism
>>>>right now, adding migration_disable as an alias for preempt_disable
>>>>will much better document quite a number of the users.
>>>
>>>I'd have no problem with that, and it might make it easier in future to
>>>justify a more complex scheme.
>>
>>What do you think, Mathieu?
>>
> 
> 
> That's an excellent idea. It should probably come with some
> documentation explaining what difference should be expected between
> preempt_disable and migrate_disable in the future so that people can
> choose the right alternative for their code.
> 
> 
>>Also, small nit: it ought to be migrate_disable to match the form of
>>preempt_disable.
> 
> 
> Yes, that's fine with me. :)
> 
> I though a little more about this whole concept of migrate_disable, and
> I think it could be brought further. One of the main problems with per
> cpu variables is that this concept cannot be ported to this grey place
> called "user-space" because preemption cannot be disabled. The
> equivalent (kind of) is currently per thread variables, but it can
> consume a lot of space if many threads are running.
> 
> However, it could be possible, if we implement a vsyscall based
> migration preemption counter accessible with read/write access from
> user-space, to tie a thread to a CPU during a user-space critical path.
> If we combine this with local atomic operations done in user-space, we
> could have highly scalable access to per cpu data structures reentrant
> with respect to signal handlers.

That's all well and good, but for most non-trivial stuff, you
have to disable preemption as well which you cannot do in
userspace. Which I suspect is why there is not a great deal
that can use it in kernelspace either.

So it will remain to be seen what kind of per-cpu data structures
you can access in a highly scalable way, and how big the niche is
between real per-thread data structures and real locking. I'm
skeptical :)

-- 
SUSE Labs, Novell Inc.
