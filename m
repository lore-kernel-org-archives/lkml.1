Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbYCYM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbYCYM0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 08:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYCYM01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 08:26:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:51760 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbYCYM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 08:26:27 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
References: <20080323085210.GE10722@ZenIV.linux.org.uk>
	<20080323.032013.79276201.davem@davemloft.net>
	<47E647AC.1060906@gmail.com>
	<20080323.051929.267232495.davem@davemloft.net>
	<20080325104841.GA24211@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 13:26:24 +0100
In-Reply-To: <20080325104841.GA24211@elte.hu>
Message-ID: <87od93gfbj.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 12:19:46.0736 (UTC) FILETIME=[83B82B00:01C88E72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> On a more conceptual angle: "coding style", despite being entirely 
> "non-functional" (it does not affect the generated code), is still very 
> much an integral part of the code because source code is fundamentally 
> about "knowledge" - and extra style noise in knowledge can never 
> possibly increase the quality of that knowledge. There are strong links 
> between code correctness and typography/aesthetics.

You assert that all the time, but it is just that: an assertation.
I assert that code style is only a small part of code correctness.
Also just an assertation. Who is more right? Probably the truth 
is somewhere inbetween. At least I think it is nearer my position
than yours @)

Also regarding the rules enforced by checkpatch I think there is a wide
range on how much they impact readability: e.g. if someone uses
the wrong bracket style consistently that is somewhat disrupting.
I agree.

But is trailing white space disrupting to code reading in any 
way? Very doubtful. 

Most rules are somewhere inbetween. They vary widely in how
much they impact readability.

Also sometimes the rules conflict. Example: the 80 column rule
often conflicts with the "always space around operator" rule.
That is because expressions split over multiple lines are harder
to read than an expression on a single line (at least here) and at 
least I would rather trade a few missing spaces around operators
than to have a multi-line expression.

It's always a trade-off and checkpatch.pl is not very good
(read it doesn't really handle) trade-offs.

> So, in the specific example of the scheduler subsystem, i've only 
> observed advantages to checkpatch and zero downsides. Could anyone give 
> me _any_ objective reason why i shouldnt be using checkpatch for the 
> scheduler? More broadly, could anyone give me an objective reason why we 
> shouldnt be doing it for arch/x86? And even more broadly, could anyone 
> give me an objective reason why we shouldnt be doing it for all actively 
> maintained areas of the kernel?

For new code being added (like your CFS scheduler) it is fine, but for
old code it has the problem of conflicting with other actually useful
changes on the same areas which are pending.  And doing merges into
such changing code bases is always somewhat error prone because the people
who do it are also only human and can apply subtle typos etc.  

Strictly seen each such merge requires a whole new testing cycle and
doing such a testing cycle just for someone's checkpatch changes is
really a waste of time and seriously impacting real progress. 
The only saving grace is that it will hopefully only happen once
per file, but the point still holds. There are a lot of different files
in Linux, so it has the potential to be a serious problem.

That is an objective (not just random assertation) reason against
doing extensive changes of existing files like Joe's patchkit.

I think it would be fair at least if people doing this asked first at least:
- Does anybody have pending changes against file X, perhaps
also checking mm and linux-next 
and then wait a bit and if someone says he has pending changes then not do 
the reformatting until the pending changes get merged.

Or better really only do it on new code.

-Andi
