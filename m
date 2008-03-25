Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYCYRUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYCYRUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbYCYRUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:20:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40886 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbYCYRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:20:01 -0400
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups
	- formatting only
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, viro@ZenIV.linux.org.uk, joe@perches.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <87od93gfbj.fsf@basil.nowhere.org>
References: <20080323085210.GE10722@ZenIV.linux.org.uk>
	 <20080323.032013.79276201.davem@davemloft.net> <47E647AC.1060906@gmail.com>
	 <20080323.051929.267232495.davem@davemloft.net>
	 <20080325104841.GA24211@elte.hu>  <87od93gfbj.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 18:19:07 +0100
Message-Id: <1206465548.6437.167.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-25 at 13:26 +0100, Andi Kleen wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> > 
> > On a more conceptual angle: "coding style", despite being entirely 
> > "non-functional" (it does not affect the generated code), is still very 
> > much an integral part of the code because source code is fundamentally 
> > about "knowledge" - and extra style noise in knowledge can never 
> > possibly increase the quality of that knowledge. There are strong links 
> > between code correctness and typography/aesthetics.
> 
> You assert that all the time, but it is just that: an assertation.
> I assert that code style is only a small part of code correctness.
> Also just an assertation. Who is more right? Probably the truth 
> is somewhere inbetween. At least I think it is nearer my position
> than yours @)

I think someone with a consistent code style generates better code than
someone who can't even make up his mind on how to write it, let alone
what to write.

With Linux we have many people, many of us with a preferred style, most
of which will differ from the suggested style.

Much like natural languages, many of us don't speak English as their
native tongue, mine is Dutch, yours is German. Still we communicate with
each other using English, because that is the de-facto standard on LKML
[ and of course because my German truly sucks ;-) ].

Similarly for coding style, if we all stick to one style its easier to
read (and hopefully fix) each others code. All checkpatch.pl attempts is
help us do that.

Sure it complains about sometimes trivial things - but if truly trivial
making the change isn't hard - or might even not be done in favour of
'better' taste. Its a guide, not hard rules, it suggests we inspect a
certain piece of code again, to see if we really intended to write it
so.

Does it get things wrong; Yes I do think so. The change in patch 120/148
is utter nonsense IMHO.

Checkpatch will also not complain about larger things that make a bigger
difference; for instance it will happily let you write a 200 line
function, even though the code would have been so much better in 10
smaller functions.

Does it help; Yes, I do think it does. If only people would apply common
sense along with it...

> Also regarding the rules enforced by checkpatch I think there is a wide
> range on how much they impact readability: e.g. if someone uses
> the wrong bracket style consistently that is somewhat disrupting.
> I agree.
> 
> But is trailing white space disrupting to code reading in any 
> way? Very doubtful. 

The trailing and leading whitespace thingies are trivial to fix (and
quilt refresh --strip-trailing-whitespace does half of it already, so
anybody using quilt doesn't have any excuse in ever seeing that error
anyway).

There is something to say to send Linus a script that fixes up the whole
tree and be done with it. These are petty things indeed.

> Most rules are somewhere inbetween. They vary widely in how
> much they impact readability.
> 
> Also sometimes the rules conflict. Example: the 80 column rule
> often conflicts with the "always space around operator" rule.
> That is because expressions split over multiple lines are harder
> to read than an expression on a single line (at least here) and at 
> least I would rather trade a few missing spaces around operators
> than to have a multi-line expression.
> 
> It's always a trade-off and checkpatch.pl is not very good
> (read it doesn't really handle) trade-offs.

Which is why it is a guide, a human using the tool can use his good
taste and discretion by choosing which suggestions to take and which to
politely ignore.

> > So, in the specific example of the scheduler subsystem, i've only 
> > observed advantages to checkpatch and zero downsides. Could anyone give 
> > me _any_ objective reason why i shouldnt be using checkpatch for the 
> > scheduler? More broadly, could anyone give me an objective reason why we 
> > shouldnt be doing it for arch/x86? And even more broadly, could anyone 
> > give me an objective reason why we shouldnt be doing it for all actively 
> > maintained areas of the kernel?
> 
> For new code being added (like your CFS scheduler) it is fine, but for
> old code it has the problem of conflicting with other actually useful
> changes on the same areas which are pending.  And doing merges into
> such changing code bases is always somewhat error prone because the people
> who do it are also only human and can apply subtle typos etc.  

Sure, and I think that when there is actual work pending its 'actively'
maintained and will eventually gravitate towards cleaniness anyway.

> Strictly seen each such merge requires a whole new testing cycle and
> doing such a testing cycle just for someone's checkpatch changes is
> really a waste of time and seriously impacting real progress. 
> The only saving grace is that it will hopefully only happen once
> per file, but the point still holds. There are a lot of different files
> in Linux, so it has the potential to be a serious problem.

The good thing is that most of these checkpatch patches could be
validated by comparing object code of the affected translation units -
they're that trivial.

When generating 100% identical code, there is no issue.

> That is an objective (not just random assertation) reason against
> doing extensive changes of existing files like Joe's patchkit.

Building a single allyesconfig for x86_32 and x86_64 before and after
and getting identical binaries is pretty strong.

Although I think this patch series doesn't manage to accomplish it, if
only because it moves __LINE__ statements around.

> I think it would be fair at least if people doing this asked first at least:
> - Does anybody have pending changes against file X, perhaps
> also checking mm and linux-next 
> and then wait a bit and if someone says he has pending changes then not do 
> the reformatting until the pending changes get merged.

Sure, cleanups like this should never bother real work - good chance
that the real work already cleans up most issues anyway.

> Or better really only do it on new code.

It might be an incentive to touch (and get to know and appreciate and
eventually clean up or start maintaining) otherwise dead code. I don't
think we should stop such incentives (even if they are very small).

