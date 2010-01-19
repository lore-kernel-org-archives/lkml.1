Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385Ab0ASOkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0ASOkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790Ab0ASOkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:40:11 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61775 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0ASOkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tgQXaSN/CMx4oNWHr9L5yq5PWFtQMHNQtze8bQmdlnkAIStONKkAzRfeiTfwPO4h0b
         FTHaYAg0ezPIH89Wxlect5/zLgLSNjN1Q7biNyxxiwd2fUgpK35Z331bTSCH7yX8rumL
         Yn6CxyymMBXiOBUNdxvt/7CGY6lAojdrSs0QI=
Date: Tue, 19 Jan 2010 15:40:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joshua Pincus <joshua.pincus@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100119144003.GA8061@nowhere>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com> <20100118110406.GC5256@nowhere> <20100118113559.GA21012@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118113559.GA21012@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 12:35:59PM +0100, Andi Kleen wrote:
> On Mon, Jan 18, 2010 at 12:04:07PM +0100, Frederic Weisbecker wrote:
> > I don't quite understand what signals are masked here,
> 
> ptrace reports all signals to the tracer and only
> delivers them on PTRACE_CONT. "Masking" is probably
> not the right term for it.


Ah, ok.

> > actually I'm not sure what is the true problem with ptrace.
> > Is it because a breakpoint in a thread is going to stop
> > all thread in the process until the parent handles the
> > signal?
> 
> I didn't think ptrace stopped all threads by its own,
> it just stops the current one and also only until 
> the problem is reported. And for a break point you
> typically want (in fact need to) to stop until it is handled.


Yeah, ok.

 
> > Anyway, although I first suggested extending perf, with
> > more thoughts I now agree that perf should keep doing what
> > it does currently (profiling) and not trying to become an
> > messy mix of a profiler, debugger, etc...
> 
> I find it surprising that you say that -- my
> impression is that whatever gets proposed recently: 
> error injection, testing, error handling, any other event 
> someone proposed perf as the answer.


Event injection is not off boundaries. This is still
in the topic of profiling/tracing.

Not sure what you mean. My point was that perf should
keep being an event performance observation tool, and
that controlling the execution flow of a process is not
the role of perf.

 
> 
> > What about extending ptrace to support a new type of
> > breakpoint debugging interface?
> 
> There's this utrace interface, but it seems to be more
> a in kernel layer with some "we can't make up our mind what
> the interface to the user looks like" and a lot of
> overengineering in interfaces thrown in.
> 
> ptrace in its current form is somewhat messy, but for
> me it seems there isn't anything better. So yes extending
> it would seem like a good idea.
> 
> A good starting point might be the debug store interfaces
> that got recently added to ptrace.


I need to look at this then. Thanks.

