Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbYJJQqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbYJJQqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 12:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760435AbYJJQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 12:45:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758900AbYJJQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 12:45:51 -0400
Date: Fri, 10 Oct 2008 18:45:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
Message-ID: <20081010164537.GA23664@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> > 
> > Ingo Molnar (12):
> >       Revert "reduce tlb/cache flush times of agpgart memory allocation"
> >       Revert "introduce two APIs for page attribute"
> >       Revert "x86: handle error returns in set_memory_*()"
> >       Revert "x86: track memtype for RAM in page struct"
> >       Revert "x86, cpa: global flush tlb after splitting large page and before doing cpa"
> >       Revert "x86, cpa: remove cpa pool code"
> >       Revert "x86, cpa: fix taking the pgd_lock with interrupts off"
> >       Revert "x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC"
> >       Revert "x86, cpa: make the kernel physical mapping initialization a two pass sequence"
> >       Revert "x86, cpa: remove USER permission from the very early identity mapping attribute"
> >       Revert "x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot"
> >       x86, pat: cleanups
> 
> So half of the commits by Suresh were reverted.
> 
> Not only that, they were reverted WITH ABSOLUTELY NO EXPLANATIONS OF 
> WHY THEY WERE CLEARLY BUGGY PILES OF CRUD. The revert messages are 
> just things like
> 
> 	This reverts commit <sha1>.
> 
> which makes both the original commit _and_ the revert just totally 
> pointless, because we didn't learn anything.

hm, those reverts werent supposed to survive. Again, my bad. I'll clean 
it out.

Here is how the screwup happened: a series was sent, i applied it, found 
a test failure with it and reported it:

  http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/2388.html

but to be able to continue testing i temporarily reverted those bits 
manually in reverse order, because it took some down to pin down the 
breakage and these bits got intermixed with other commits - and i did 
not want to rebase commits that came after the broken series.

Then the corrected v2 series arrived (not a delta fix) and i applied 
those. The idea was to create a delta patch against the first series so 
that i can see the changes.

v2 worked well in testing:

  http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/2375.html

So it's basically a v1 -> v2 sequence, with artificial reverts surviving 
unintentionally. That's why there were no revert messages either: i 
never intended them to become public. I even rember having taken a good 
look at "git diff 6b5b551..6e3e492", which the v1->v2 delta was.

What i havent done was to squash all these artificial commits together 
and create the delta commit - this is one of the few cases where 
rebasing of that temporary tail would have been the right thing to do, 
before pushing it out.

And i should also have noticed this weird sequence of commit logs when 
doing the pull request.

Sorry :-(

	Ingo
