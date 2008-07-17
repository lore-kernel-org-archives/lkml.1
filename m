Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYGQHMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYGQHMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbYGQHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:11:59 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:34743 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757272AbYGQHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:11:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BiWV5lJGgrsnTEN2YhRNvZQNFlnpJ5NTu+/Maq7y8yAikq3i6sqNYFi5XTcCfGdsHrjR1i+ykPAofy49Be+I7MNLXiRefxYG0HxmtSja7Wuo6PhmhXH4Ur6h9wXtoQrR9m/XyGDb/21I2xqffkv0XEFXS0+wsHFJKgWqQDzpWrM=  ;
X-YMail-OSG: P7jc19sVM1nA3zSjvuLbLaSGGgEVIItKJ4g2D1eY4jdGpx0dVfw3yF901U2ESB50V1BT3fWJIgtPM5cQup.yUBHcFD7ztBv2fRYoPr67S2crp_pekS7QN0p1ecNBmaLeKwI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 09/17] LTTng instrumentation - filemap
Date: Thu, 17 Jul 2008 17:11:50 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-mm@kvack.org,
       Dave Hansen <haveblue@us.ibm.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
References: <20080715222604.331269462@polymtl.ca> <200807171625.25302.nickpiggin@yahoo.com.au> <20080717070207.GA30312@Krystal>
In-Reply-To: <20080717070207.GA30312@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171711.51214.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2008 17:02, Mathieu Desnoyers wrote:
> * Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> > On Wednesday 16 July 2008 08:26, Mathieu Desnoyers wrote:
> > > Instrumentation of waits caused by memory accesses on mmap regions.
> > >
> > > Those tracepoints are used by LTTng.
> > >
> > > About the performance impact of tracepoints (which is comparable to
> > > markers), even without immediate values optimizations, tests done by
> > > Hideo Aoki on ia64 show no regression. His test case was using
> > > hackbench on a kernel where scheduler instrumentation (about 5 events
> > > in code scheduler code) was added. See the "Tracepoints" patch header
> > > for performance result detail.
> >
> > BTW. this sort of test is practically useless to measure overhead. If
> > a modern CPU is executing out of primed insn/data and branch prediction
> > cache, then yes this sort of thing is pretty well free.
> >
> > I see *real* workloads that have got continually and incrementally slower
> > eg from 2.6.5 to 2.6.20+ as "features" get added. Surprisingly, none of
> > them ever showed up individually on a microbenchmark.
> >
> > OK, for this case if you can configure it out, I guess that's fine. But
> > let's not pretend that adding code and branches and function calls are
> > ever free.
>
> I never pretended anything like that. Actually, that's what the

OK but saying "there is no detectable impact when running hackbench" is
basically meaningless.


> "immediate values" are for : they allow to patch load immediate value
> instead of a memory read to decrease d-cache impact. They now allow to
> patch a jump instead of the memory read/immediate value read + test +
> conditional branch to skip the function call with fairly minimal impact.
> I agree with you that eating precious d-cache and jump prediction buffer
> entries can eventually slow down the system. But this will be _hard_ to
> show on a single macro benchmark, and the microbenchmark showing it will
> have to be taken in conditions which will exacerbate the d-cache and BPB
> impact.

I'm not saying you have to reproduce it (although Intel's Oracle OLTP
benchmark is very sensitive to that kind of thing and schedule() is near
the top). But just acknowledge that it adds some cost. OK you're one of
the few people really trying hard to count every cycle so I don't mean to
pick on this code in particular.
