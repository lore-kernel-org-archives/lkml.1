Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZCWEwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZCWEwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 00:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZCWEvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 00:51:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZCWEvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 00:51:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
X-Fcc: ~/Mail/utrace
Cc: Renzo Davoli <renzo@cs.unibo.it>,
       Andrew Morton <akpm@linux-foundation.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
In-Reply-To: Ingo Molnar's message of  Saturday, 21 March 2009 17:44:31 +0100 <20090321164431.GK11183@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014140.AA4F5FC3AB@magilla.sf.frob.com>
	<20090321014909.6b654f55.akpm@linux-foundation.org>
	<20090321140822.GE18690@cs.unibo.it>
	<20090321143457.GA24254@elte.hu>
	<20090321163700.GA22292@cs.unibo.it>
	<20090321164431.GK11183@elte.hu>
X-Zippy-Says: Pardon me, but do you know what it means to be TRULY ONE with your BOOTH!
Message-Id: <20090323043448.B07D1FC3AB@magilla.sf.frob.com>
Date: Sun, 22 Mar 2009 21:34:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's btw. what i see as the biggest value of utrace: it's a 
> comprehesive, all-encompassing framework all around process state 
> events and process state manipulation.

Me too!  

And while we're on the btw's, I want to let everyone know that Ingo is the
one who came up with the name "utrace".  I had only completely dismal ideas
for names, and nothing but the philosophy, "For the love of God, anything
but [a-z]trace!"  So that's one tiny piece of the whole mess that you can't
blame on me.  (Yes, I do believe I would be killed if we changed it again now.)
;-) ;-) ;-)

> Utrace came from Frysk (generic debugger), but the fact that you 
> were able to build a completely unanticipated usecase and 
> virtualization module on top of it is a very good sign of a robust 
> and complete design. I'm impressed.

Um, thanks, I guess.  The antecedents of your statement are not really
accurate, but I'll take the consequent as a compliment! :-)

In fact, utrace came from my experience of maintaining the old ptrace code.
Nor was this particular use "completely unanticipated".  

I was not aware of Renzo or his work before he got in touch about making
use of utrace.  But my imagined list of vaporware always included
"specialized engines for UML or other syscall-interception type things".
(e.g. seccomp is trivial with no need for per-arch asm work.)  I swear,
a third of the people who ever came to me complaining about ptrace being
so hard to work with were doing things that to me are all "syscall
interception and/or tracking", whether for some security-minded purpose
or something more virtualization-like.  Surely for many of those cases,
it was really the wrong way to solve the problem they were tackling.
Seems it's just the next stop after someone talks you out of LD_PRELOAD.
But who am I to say?  It was quite clear that people really wanted
easier ways to experiment with doing this sort of thing.

That said, I certainly have always hoped for completely unanticipated
uses.  (I will readily admit to succumbing to "Build it and they will
come" mentality.  I'm sure flames about my deep character flaws, moral
turpitude, and dubious lineage will follow.  The history of my career
will show that I was not striving for the appearance of cogent planning.)

I hatched the essential design of utrace when I'd recently spent a whole
lot of time fixing the innards of ptrace and a whole lot of time helping
userland implementors of debuggers and the like figure out how to work
with ptrace (and hearing their complaints about it).  At the same time,
the group I'm in (still) was contemplating both the implementation
issues of a generic debugger, how to make it tractable to work up to far
smarter debuggers, and also the design of what became systemtap.

It was clear to me that this whole space of problems and potential
features would be an open-ended area where different approaches would
need to be hashed out, and that there would not be one "ptrace killer"
feature that would be the right fit for all uses.  It has long been
clear that the threshold of effort was far too high for people to
experiment and innovate in this area.  Hence the plan to make a new
platform that lowered that threshold at least closer to "pretty easy"
from "intractable", staying about as simple as what both brings that
threshold down enough and lets unrelated developments in these things
coexist well on the system.


Thanks,
Roland
