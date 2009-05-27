Return-Path: <linux-kernel-owner+w=401wt.eu-S1759556AbZE0WCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556AbZE0WCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZE0WCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:02:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47439 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZE0WCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:02:06 -0400
Date: Thu, 28 May 2009 00:01:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
Message-ID: <20090527220119.GA9555@elte.hu>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org> <1243409850-21577-18-git-send-email-jeremy@goop.org> <alpine.LFD.2.01.0905270829530.3435@localhost.localdomain> <20090527211828.GA6166@elte.hu> <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 27 May 2009, Ingo Molnar wrote:
> > 
> > hm, i have to concur. Too often it ends up splitting attention 
> > away from the title of the commit. I do reject (or fix up) bad 
> > impact lines - will stop doing them altogether if you think 
> > there's a net downside to them ...
> 
> I actually think that if there is a good reason for them, they can 
> stay.
> 
> Just don't make it one of those "every commit that goes through me 
> has to have one".
> 
> Pu another way: if they actually add value in highlighting the 
> commits that _should_ stand out, then hey, by all means, keep such 
> ones. I would not at all object if it was an issue of
> 
>  [ Impact: fix bugzilla entry 455123 ]
> 
> or
> 
>  [ Impact: fix user-triggerable oops ]
> 
> or something that actually matters, and that you _want_ to stand 
> out, and that you may well _want_ to grep for.
> 
> It's when the whole series has them, and they don't add anything 
> that isn't better said in the summary line, _that's_ what I 
> dislike.
> 
> So to take the above bugzilla example: it really wouldn't be a 
> good summary line (because the summary line should describe what 
> the commit does, not point to some bugzilla entry), but at the 
> same time it's clearly something that I do think we might want to 
> automate the logs for.
> 
> IOW, that is something even I personally wouldn't mind adding to a 
> commit, to help people like Rafael that track bugzilla. It makes 
> sense as a special marker, even though it clearly _shoudln't_ be 
> the summary. See?
> 
> Similarly, the "user-triggerable oops" might well be worth 
> high-lighting in some manner. Now, the summary _might_ talk about 
> it, but equally well the summary might be more specific in the 
> actual implementation issue, and then perhaps the impact line is 
> worth it.
> 
> But if all commits have them (at least for the x86-tip), then it's 
> not a really highlight event any more, is it? At that point, 
> anything it says is probably just as well described by the summary 
> line - at least for any "regular" commits that aren't in some way 
> worth the extra attention.

ok.

Beyond impact lines for bugfixes, there's one other 'bulk' impact 
line that i find pretty important - the most boring and most 
repetitive ones:

   Impact: cleanup

Sometimes also in the form of:

   Impact: refactor code

It signals a conscious "this is not intended to have direct side 
effects" marker. It's mis-used sometimes - but the ones i add tend 
to be very specific (and common) type of patches.

Obviously for any buggy commit that designation will be patently 
false: but then again every commit in the kernel claims and intends 
to be bug free - still a significant proportion, 2-3% of all 
upstream kernel commits are buggy ;-)

So later on it makes it easy to see how much of an known impact a 
commit was supposed to have - and whether a badness/misbehavior was 
intended or not. (It also makes it easier for me to chastise repeat 
offenders who send 'cleanup' patches which are all but.)

The 'cleanups which are not' tend to contain the most surprising 
bugs (because those tend to be the most unexpected bugs - commits 
marked known-dangerous tend not to surprise anyone if they break), 
so i think it makes sense to delineate that category sharply, and 
observe (and enforce) safe coding techniques for 
cleanup/code-preparation patches.

That concept works great for us in arch/x86, we tend to be less and 
less surprised about what kind of commits produce what kinds of 
bugs.

The impact-line quality of non-cleanup and non-bugfix patches tends 
to be the poorest. And for them there's no surprise generally if 
there's some unexpected impact.

	Ingo
