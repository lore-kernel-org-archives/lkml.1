Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab0BAPoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:44:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63999 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0BAPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:44:18 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=L0Yyq6P2Bu0c8ooMiKEA:9 a=NIq1NPsk-6RvwV0qevEA:7 a=8NtfxfjWIq-rO41h2sDvtv0eVUQA:4 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Nick Piggin <npiggin@suse.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
In-Reply-To: <1265037815.29013.0.camel@gandalf.stny.rr.com>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca> <20100201073341.GH9085@laptop>
	 <1265017350.24455.122.camel@laptop> <20100201101142.GE12759@laptop>
	 <1265020561.24455.142.camel@laptop> <20100201104901.GH12759@laptop>
	 <20100201144759.GD10894@Krystal>  <20100201145831.GB19520@laptop>
	 <1265037815.29013.0.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 10:44:12 -0500
Message-ID: <1265039052.29013.28.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 10:23 -0500, Steven Rostedt wrote:
> On Tue, 2010-02-02 at 01:58 +1100, Nick Piggin wrote:
> > On Mon, Feb 01, 2010 at 09:47:59AM -0500, Mathieu Desnoyers wrote:
> > > * Nick Piggin (npiggin@suse.de) wrote:
> > > > Well I just mean that it's something for -rt to work out. Apps can
> > > > still work if the call is unsupported completely.
> > > 
> > > OK, so we seem to be settling for the spinlock-based sys_membarrier()
> > > this time, which is much less intrusive in terms of scheduler
> > > fast path modification, but adds more system overhead each time
> > > sys_membarrier() is called. This trade-off makes sense to me, as we
> > > expect the scheduler to execute _much_ more often than sys_membarrier().
> > > 
> > > When I get confirmation that's the route to follow from both of you,
> > > I'll go back to the spinlock-based scheme for v9.
> > 
> > I think locking or cacheline bouncing DoS is just something we can't
> > realistically worry too much about in the standard kernel. No further
> > than just generally good practice of good scalability, avoiding
> > starvations and long lock hold times etc.
> > 
> > So I would prefer the simpler version that doesn't add overhead to
> > ctxsw, at least for the first implementation.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>

I'm in agreement with Nick on this issue. Peter, I think you are being a
bit paranoid here. But that's a good thing. Anyone working in the
scheduler must be paranoid. That's what brings out issues that people
normally do no think about. :-)

-- Steve


