Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbYAEBUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbYAEBUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 20:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbYAEBUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 20:20:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46039 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594AbYAEBUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 20:20:03 -0500
Date: Sat, 5 Jan 2008 02:19:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH x86] [12/16] Optimize lock prefix switching to run less
	frequently
Message-ID: <20080105011949.GA5107@elte.hu>
References: <20080103442.621670000@suse.de> <200801041539.27370.ak@suse.de> <alpine.LFD.0.99999.0801041546230.4042@localhost.localdomain> <200801042311.57837.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801042311.57837.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > > > The kernel process request that _all_ contributors run their 
> > > > patches through checkpath.pl and fix the problems.
> > > 
> > > That's new. When and by whom was that rule been introduced? And 
> > > with what rationale?
> > 
> > Documentation/SubmitChecklist
> 
> That says
> 
> " You should be able to justify all violations that remain in your patch."
> 
> I think I did that.

i dont think you did. A good number of bona fide style problems were 
pointed out in your patch and you werent even aware of them even after 
the fact was pointed out to you. In fact we are at silly mail #10 
already that argues about this.

I said in the very first mail that your patch looks good to me in 
principle, just please clean it up a bit. I also applied a lot of your 
other, clean patches. I dont know why you make such a big fuss about it, 
have you never been requested to clean up your code before? I too make 
cleanliness errors quite often and get asked to fix them up. That's what 
review cycles are about and it serves us well.

> > > Anyways if you care so much about space<->tabs why don't you just 
> > > write a filter that converts spaces to tabs for incoming patches? 
> > > Like it is traditionally done for trailing white spaces? Would be 
> > > a trivial perl script.
> > 
> > I need to fix up your sloppiness ?
> 
> That's the wrong way to see it.
> 
> See it this way: Is forcing humans to convert spaces to tabs an useful 
> activity? Is rejecting patches for that and requiring repost a useful 
> activity that improves Linux in any way? Will it help Linux to let 
> people spend time to convert spaces to tabs instead of writing patches 
> or testing?

the half dozen style problems i listed in your patch are very much not 
just about spaces to tabs, and the answer is a resounding: YES, fixing 
them helps Linux in general.

Why? Because the most important asset an outstanding programmer can have 
(besides the ability to abstract) is a good eye for small details.

It's _very_ easy for humans to slip over small details. Like the sign of 
a variable. Or parentheses in the wrong place. Or a missing check for 
NULL. Or implicit type conversions. Small details that a different 
system - like a computer - will _never_ get wrong.

And having a good eye for details is a VERY non-human ability - just 
like mathematics. Millions of years of evolution have taught our brain 
that all that matters is statistics and fuzzy rules - momentary details 
rarely matter in the physical world. Being able to pick an apple 80% of 
the time is plenty good as a survival tactic in the jungle. On the other 
hand, being correct 99.9% of the time in a computer program makes it 
virtually unusable most of the time.

Getting code alignment wrong, introducing various visible whitespace 
problems, getting convention wrong and thus making it harder for kernel 
developers to read each other's code shows a lack for attention to 
details - be that temporary or permanent inability. And lack of 
attention to details - even if it's only for a seemingly unimportant 
thing like coding style - is a disease that easily spreads to other 
areas such as the code's logic itself. Sloppy style is often an early 
indicator for sloppy logic.

There are many details that reviewers have to check, and if you sprinkle 
your code with other, irrelevant style mistakes then they will distract 
from the primary task: to understand and maintain the logic changes you 
do via your patch. Style errors can easily distract the human eye and 
can cause us to miss a much more serious error. In other words: style 
errors add random noise to the code and they thus make review of code 
more complex.

Sloppy and inconsistent code also leaves a lasting negative impression 
on newbie developers. I've heard quite a few opinions about Linux's code 
base being a lot less consistent (and hence harder to understand) than 
that of other OSs. I dont think it's a good policy for us to 
intentionally obfuscate our code and make it harder to read for 
everyone.

Frankly, if you dont understand the necessity of clean code, and the 
negative effect that a large number of small uncleanlinesses can have on 
a large system then you wont be getting the big picture either.

checkpatch.pl is not perfect (and it cannot be), and we dont use it as a 
rigid criterium (and dont want to), but it's quite conservative (its 
false positive rate for code that i maintain is below 1% - which is 
phenomenal for such a tool) and it is a pretty good tool at flagging 
sloppy patches. It gives us a way to improve the kernel's code quality 
gradually. We change about 10% of the kernel codebase in every kernel 
release, that is about 30% of the kernel every year. With checkpatch.pl 
we'll have a very clean kernel in just a few years.

And yes, the hardest task as usual is not to convince newbies and casual 
kernel developers, but to convince well-established kernel hackers who 
think they are perfect and write the cleanest code on the planet ;-) 
[and that list included me too] And yes, this too is a fundamentally 
human weakness ;-)

	Ingo
