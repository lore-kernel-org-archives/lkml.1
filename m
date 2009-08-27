Return-Path: <linux-kernel-owner+w=401wt.eu-S1750886AbZH0RD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbZH0RD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZH0RDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:03:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36759 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZH0RDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:03:23 -0400
Date: Thu, 27 Aug 2009 13:03:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <gregory.haskins@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
In-Reply-To: <4A96BB40.1070306@gmail.com>
Message-ID: <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com>
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu> <4A96BB40.1070306@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 27 Aug 2009, Gregory Haskins wrote:

> Ingo Molnar wrote:
> > * Gregory Haskins <gregory.haskins@gmail.com> wrote:
> > 
> >> Hi Steve,
> >>
> >> I just moved from -rc6 to -rc7, and I noticed that the 
> >> function-graph tracer suddenly stopped working properly: I do not 
> >> see any output from seeming most things except a handful of 
> >> interrupt related events.  I currently believe it may be an issue 
> >> with tracing modules.
> >>
> >> I haven't had a chance to bisect yet, but I did confirm that 
> >> reverting the -rc7 merge restores the previous tracer behavior.  
> >> Any help/pointers appreciated.
> > 


> 
> Yeah, sorry.  I should have provided more detail.  Usually I'd hit Steve
> up directly on IRC and he'd point me in the right direction, but he
> wasn't online today.  But I guess the "IRC terseness" carried on to the
> mail. ;).  I guess I was wondering if anyone else had seen this before
> digging in.

Yeah, my IRC box is my laptop that is overheating. I'm currently backing 
it up and I'm going to take it apart today. Hopefully if all goes well, 
I'll be back on IRC with a cooler laptop ;-)

> 
> I digress.
> 
> All I was doing was enabling the basic function-graph tracer, enabling
> the tracer, run a test, stopping the tracer, and taking a look at the
> "trace" output by grepping for functions that I knew should have hit.
> 
> In -rc7, grep turns up empty and I can't seem to find evidence that any
> of my code was hit, even though other utilities (like top) indicated my
> code was indeed running (I could see kthreads belonging to my module use
> cpu, for instance).  In addition, the test passes so its not like it may
> have skipped over the function I was looking for.  Its just not being
> traced for some reason.
> 
> Reverting back to -rc6 and a simple recompile + repeat of the same steps
> indeed restored the behavior that I was accustomed to.
> 
> I noticed that both the output that I could observe, plus the output you
> provide above seem to be core-kernel related functions.  I know all the
> traces I was looking for were module related.  Therefore, I suspect that
> somehow module code (or at least, my module code) is not being
> instrumented for some reason.

Hmm, so you think something with the modules broke? I can test that out 
here.

Thanks,

-- Steve

