Return-Path: <linux-kernel-owner+w=401wt.eu-S1759951AbZJMOEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbZJMOEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbZJMOEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:04:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZJMOEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:04:36 -0400
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091013132656.GA12292@elte.hu>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
	 <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
	 <1255404309.7113.948.camel@gandalf.stny.rr.com>
	 <20091013070853.GA13175@elte.hu>
	 <1255439822.7113.1541.camel@gandalf.stny.rr.com>
	 <20091013132656.GA12292@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 10:02:37 -0400
Message-Id: <1255442557.7113.1623.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 15:26 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 2009-10-13 at 09:08 +0200, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > 
> > > > (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)
> > > > 
> > > > Is not easy. It's basically implementing a C interpreter :-(
> > > 
> > > Btw., what i suggested quite some time ago was that we should bind 
> > > tracepoints by emitting C source code stubs, which tools can then build 
> > > and link in, using gcc.
> > 
> > Yeah, and I thought about that too. But that kills any chance of 
> > running the trace on one box (non x86) and reading it on another 
> > (x86). And that is one of my goals for this.
> 
> Why does it kill that chance?

Ah, I was thinking binary libraries from the trace points. But I missed
you said C source code.

But still, we need to build a way to convert big endian to little, as
well as perhaps converting 32bit to 64 bit longs. As well as vice versa.

We also need a way to export all structures (here ktime_t) as well as
enums. Of course we need to export enums now anyway, since the tools
don't know how to convert them now.

-- Steve


