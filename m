Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097Ab0ARLgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0ARLgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283Ab0ARLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:36:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42026 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0ARLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:36:06 -0500
Date: Mon, 18 Jan 2010 12:35:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joshua Pincus <joshua.pincus@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>, peterz@infradead.org,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100118113559.GA21012@basil.fritz.box>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com> <20100118110406.GC5256@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100118110406.GC5256@nowhere>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 12:04:07PM +0100, Frederic Weisbecker wrote:
> I don't quite understand what signals are masked here,

ptrace reports all signals to the tracer and only
delivers them on PTRACE_CONT. "Masking" is probably
not the right term for it.

This could be fixed relatively easily with a new signal
mask ptrace option I guess.

> actually I'm not sure what is the true problem with ptrace.
> Is it because a breakpoint in a thread is going to stop
> all thread in the process until the parent handles the
> signal?

I didn't think ptrace stopped all threads by its own,
it just stops the current one and also only until 
the problem is reported. And for a break point you
typically want (in fact need to) to stop until it is handled.

> 
> Anyway, although I first suggested extending perf, with
> more thoughts I now agree that perf should keep doing what
> it does currently (profiling) and not trying to become an
> messy mix of a profiler, debugger, etc...

I find it surprising that you say that -- my
impression is that whatever gets proposed recently: 
error injection, testing, error handling, any other event 
someone proposed perf as the answer.

"If all I got is a hammer everything starts to look like a thumb"

But yes I fully agree with you.


> What about extending ptrace to support a new type of
> breakpoint debugging interface?

There's this utrace interface, but it seems to be more
a in kernel layer with some "we can't make up our mind what
the interface to the user looks like" and a lot of
overengineering in interfaces thrown in.

ptrace in its current form is somewhat messy, but for
me it seems there isn't anything better. So yes extending
it would seem like a good idea.

A good starting point might be the debug store interfaces
that got recently added to ptrace.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
