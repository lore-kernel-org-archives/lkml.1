Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbXBAVw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbXBAVw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 16:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXBAVw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 16:52:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32692 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbXBAVwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 16:52:54 -0500
In-Reply-To: <20070201130234.GA15257@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5678BC95-E548-414F-85F9-9D6B4DC914EC@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Thu, 1 Feb 2007 13:52:13 -0800
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> let me clarify this: i very much like your AIO patchset in general, in
> the sense that it 'completes' the AIO implementation: finally  
> everything
> can be done via it, greatly increasing its utility and hopefully its
> penetration. This is the most important step, by far.

We violently agree on this :).

> what i dont really like /the particular/ concept above - the
> introduction of 'fibrils' as a hard distinction of kernel threads.  
> They
> are /almost/ kernel threads, but still by being different they create
> alot of duplication and miss out on a good deal of features that  
> kernel
> threads have naturally.

I might quibble with some of the details, but I understand your  
fundamental concern.  I do.  I don't get up each morning *thrilled*  
by the idea of having to update lockdep, sysrq-t, etc, to understand  
these fibril things :).  The current fibril switch isn't nearly as  
clever as the lock-free task scheduling switch.  It'd be nice if we  
didn't have to do that work to optimize the hell out of it, sure.

> It kind of hurts to say this because i'm usually quite concept-happy -
> one can easily get addicted to the introduction of new core kernel
> concepts :-)

:)

> so my suggestions center around the notion of extending kernel threads
> to support the features you find important in fibrils:
>
>> would it be hard to redo your AIO patches based on a pool of plain
>> simple kernel threads?

It'd certainly be doable to throw together a credible attempt to  
service "asys" system call submission with full-on kernel threads.   
That seems like reasonable due diligence to me.  If full-on threads  
are almost as cheap, great.  If fibrils are so much cheaper that they  
seem to warrant investing in, great.

I am concerned about the change in behaviour if we fall back to full  
kernel threads, though.  I really, really, want aio syscalls to  
behave just like sync ones.

Would your strategy be to update the syscall implementations to share  
data in task_struct so that there isn't as significant a change in  
behaviour?  (sharing current->ioprio, instead if just inheriting it,  
for example.).  We'd be betting that there would be few of these and  
that they'd be pretty reasonable to share?

- z
