Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbZJMV2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbZJMV2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761428AbZJMV2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:28:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761427AbZJMV2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:28:48 -0400
Subject: Re: [PATCH 1/5] [PATCH 1/5] function-graph/x86: replace unbalanced
 ret with jmp
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20091013212126.GA8039@Krystal>
References: <20091013203349.814936710@goodmis.org>
	 <20091013203425.042034383@goodmis.org> <20091013204702.GA4533@Krystal>
	 <1255468214.7113.2396.camel@gandalf.stny.rr.com>
	 <20091013212126.GA8039@Krystal>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 13 Oct 2009 17:26:50 -0400
Message-Id: <1255469210.7113.2436.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 17:21 -0400, Mathieu Desnoyers wrote:

> > What it was:
> > 
> > call function
> >   function:
> >   call mcount
> >      mcount:
> >      call ftrace_entry
> 
> Can we manage to change this call

Note, that call jumps to C code.

> 
> >        ftrace_entry:
> >        mess up with return code of caller
> >        ret
> 
> .. and this ret for 2 jmp instructions too ?

The code is all in C, and it too calls functions. Not sure where this
helps out any. The ret here matches their calls. Thus the prediction
will work.

> 
> Given that we have no choice but to kill call/ret prediction logic, I
> think it might be good to try to use this logic as little as possible
> (by favoring jmp jmp over call/ret when the return target is invariant).
> 
> That's just an idea, benchmarks could prove me right/wrong.

I don't see how this would help. And I'm not about to waste time
experimenting. What's the rational?

-- Steve


