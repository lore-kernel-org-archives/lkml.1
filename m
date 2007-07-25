Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbXGYUf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbXGYUf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXGYUft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:35:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33624 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbXGYUfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:35:48 -0400
Date: Wed, 25 Jul 2007 22:35:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Rene Herman <rene.herman@gmail.com>, Jos Poortvliet <jos@mijnkamer.nl>,
       david@lang.hm, Nick Piggin <nickpiggin@yahoo.com.au>,
       Valdis.Kletnieks@vt.edu, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ck list <ck@vds.kolivas.org>, linux-mm@kvack.org,
       Paul Jackson <pj@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Message-ID: <20070725203523.GA10750@elte.hu>
References: <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm> <46A6DFFD.9030202@gmail.com> <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com> <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com> <5c77e14b0707250353r48458316x5e6adde6dbce1fbd@mail.gmail.com> <46A75062.1050809@gmail.com> <20070725135016.GA18633@elte.hu> <a781481a0707251033t5b95cde7k620810bcc0b98c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707251033t5b95cde7k620810bcc0b98c1@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam.sharma@gmail.com> wrote:

> > concentrate on making sure that both you and the maintainer 
> > understands the problem correctly,
> 
> This itself may require some "convincing" to do. What if the 
> maintainer just doesn't recognize the problem? Note that the 
> development model here is more about the "social" thing than purely a 
> "technical" thing. People do handwave, possibly due to innocent 
> misunderstandings, possibly without. Often it's just a case of seeing 
> different reasons behind the "problematic behaviour". Or it could be a 
> case of all of the above.

sure - but i was really not talking about from the user's perspective, 
but from the enterprising kernel developer's perspective who'd like to 
solve a particular problem. And the nice thing about concentrating on 
the problem: if you do that well, it does not really matter what the 
maintainer thinks!

( Talking to the maintainer can of course be of enormous help in the 
  quest for understanding the problem and figuring out the best fix - 
  the maintainer will most likely know more about the subject than 
  yourself. More communication never hurts. It's an additional bonus if 
  you manage to convince the maintainer to take up the matter for 
  himself. It's not a given right though - a maintainer's main task is 
  to judge code that is being submitted, to keep a subsystem running
  smoothly and to not let it regress - but otherwise there can easily be
  different priorities of what tasks to tackle first, and in that sense 
  the maintainer is just one of the many overworked kernel developers 
  who has no real obligation what to tackle first. )

If the maintainer rejects something despite it being well-reasoned, 
well-researched and robustly implemented with no tradeoffs and 
maintainance problems at all then it's a bad maintainer. (but from all 
i've seen in the past few years the VM maintainers do their job pretty 
damn fine.) And note that i _do_ disagree with them in this particular 
swap-prefetch case, but still, the non-merging of swap-prefetch was not 
a final decision at all. It was more of a "hm, dunno, i still dont 
really like it - shouldnt this be done differently? Could we debug this 
a bit better?" reaction. Yes, it can be frustrating after more than one 
year.

> > possibly write some testcase that clearly exposes it, and
> 
> Oh yes -- that'll be helpful, but definitely not necessarily a 
> prerequisite for all issues, and then you can't even expect everybody 
> to write or test/benchmark with testcases. (oh, btw, this is assuming 
> you do find consensus on a testcase)

no, but Con is/was certainly more than capable to write testcases and to 
debug various scenarios. That's the way how new maintainers are found 
within Linux: people take matters in their own hands and improve a 
subsystem so that they'll either peacefully co-work with the other 
maintainers or they replace them (sometimes not so peacefully - like in 
the IDE/SATA/PATA saga).

> > help the maintainer debug the problem.
> 
> Umm ... well. Should this "dance-with-the-maintainer" and all be 
> really necessary? What you're saying is easy if a "bug" is simple and 
> objective, with mathematically few (probably just one) possible 
> correct solutions. Often (most often, in fact) it's a subjective issue 
> -- could be about APIs, high level design, tradeoffs, even little 
> implementation nits ... with one person wanting to do it one way, 
> another thinks there's something hacky or "band-aidy" about it and a 
> more beautiful/elegant solution exists elsewhere. I think there's a 
> similar deadlock here (?)

you dont _have to_ cooperative with the maintainer, but it's certainly 
useful to work with good maintainers, if your goal is to improve Linux. 
Or if for some reason communication is not working out fine then grow 
into the job and replace the maintainer by doing a better job.

> > _Optionally_, if you find joy in it, you are also free to write a 
> > proposed solution for that problem
> 
> Oh yes. But why "optionally"? This is *precisely* what the spirit of 
> development in such open / distributed projects is ... unless Linux 
> wants to die the same, slow, ivory-towered, miserable death that *BSD 
> have.

perhaps you misunderstood how i meant the 'optional': it is certainly 
not required to write a solution for every problem you are reporting. 
Best-case the maintainer picks the issue up and solves it. Worst-case 
you get ignored. But you always have the option to take matters into 
your own hands and solve the problem.

> >and submit it to the maintainer.
> 
> Umm, ok ... pretty unlikely Linus or Andrew would take patches for any 
> kernel subsystem (that isn't obvious/trivial) from anybody just like 
> that, so you do need to Cc: the ones they trust (maintainer) to ensure 
> they review/ack your work and pick it up.

actually, it happens pretty frequently, and NACK-ing perfectly 
reasonable patches is a sure way towards getting replaced as a 
maintainer.

> > is the wrong way around. It might still work out fine if the 
> > solution is correct (especially if the patch is small and obvious), 
> > but if there are any non-trivial tradeoffs involved, or if 
> > nontrivial amount of code is involved, you might see your patch at 
> > the end of a really long (and constantly growing) waiting list of 
> > patches.
> 
> That's the whole point. For non-trivial / non-obvious / subjective 
> issues, the "process" you laid out above could itself become a problem 
> ...

firstly, there's rarely any 'subjective' issue in maintainance 
decisions, even when it comes to complex patches. The 'subjective' issue 
becomes a factor mostly when a problem has not been researched well 
enough, when it becomes more of a faith thing ('i believe it helps me') 
than a fully fact-backed argument. Maintainers tend to dodge such issues 
until they become more clearly fact-backed.

providing more and more facts gradually reduces the 'judgement/taste' 
leeway of maintainers, down to an almost algorithmic level.

but in any case there's always the ultimate way out: prove that you can 
do a better job yourself and replace the maintainer. But providing an 
overwhelming, irresistable body of facts in favor of a patch does the 
trick too in 99.9% of the cases.

	Ingo
