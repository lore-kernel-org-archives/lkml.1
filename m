Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256Ab0ASRsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0ASRsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130Ab0ASRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:48:16 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:48449 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0ASRsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:48:15 -0500
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
From: Jim Keniston <jkenisto@us.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B556855.6040800@redhat.com>
References: <1263740593.557.20967.camel@twins>
	 <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com>
	 <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com>
	 <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com>
	 <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com>
	 <4B545146.3080001@redhat.com>	 <20100118124419.GC1628@linux.vnet.ibm.com>
	 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
	 <4B5459CA.9060603@redhat.com>  <4B545ACF.40203@cs.helsinki.fi>
	 <1263852957.2266.38.camel@localhost.localdomain>
	 <4B556855.6040800@redhat.com>
Content-Type: text/plain
Date: Tue, 19 Jan 2010 09:47:45 -0800
Message-Id: <1263923265.4998.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2010-01-19 at 10:07 +0200, Avi Kivity wrote:
> On 01/19/2010 12:15 AM, Jim Keniston wrote:
> >
> >> I don't like the idea but if the performance benefits are real (are
> >> they?),
> >>      
> > Based on what seems to be the closest thing to an apples-to-apples
> > comparison -- counting the number of calls to a specified function --
> > uprobes is 6-7 times faster than the ptrace-based equivalent, ltrace -c.
> > And of course, uprobes provides much, much more flexibility, appears to
> > scale better, and works with multithreaded apps.
> >
> > Likewise, FWIW, utrace is more than 10x faster than strace -c in
> > counting system calls.
> >
> >    
> 
> This is still with a kernel entry, yes?

Yes, this involves setting a breakpoint and trapping into the kernel
when it's hit.  The 6-7x figure is with the current 2-trap approach
(breakpoint, single-step).  Boosting could presumably make that more
like 12-14x.

> Do you have plans for a variant 
> that's completely in userspace?

I don't know of any such plans, but I'd be interested to read more of
your thoughts here.  As I understand it, you've suggested replacing the
probed instruction with a jump into an instrumentation vma (the XOL
area, or something similar).  Masami has demonstrated -- through his
djprobes enhancement to kprobes -- that this can be done for many x86
instructions.

What does the code in the jumped-to vma do?  Is the instrumentation code
that corresponds to the uprobe handlers encoded in an ad hoc .so?

BTW, when some people say "completely in userspace," they mean something
like ptrace, where the kernel is still heavily involved but the
instrumentation code runs in user space.  The ubp layer is intended to
support that model as well.  In our various implementations of the XOL
vma/address area, however, the XOL area is either created on exec or
created/expanded only by the probed process.

Jim

