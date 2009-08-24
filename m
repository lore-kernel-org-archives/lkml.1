Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbZHXIXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbZHXIXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 04:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZHXIXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 04:23:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33790 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbZHXIXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 04:23:45 -0400
Date: Mon, 24 Aug 2009 10:23:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090824082318.GD2424@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org> <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase> <20090822153346.GA3313@elte.hu> <19088.47213.327897.703458@cargo.ozlabs.ibm.com> <20090823084740.GA7651@elte.hu> <19090.1800.521794.839576@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19090.1800.521794.839576@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Do you ask Linus to rebase the upstream kernel as well, if the 
> > powerpc or x86 build happens to break? There's more than a dozen 
> > such cases per development cycle triggering on my tests alone. If 
> > not, why not?
> 
> I see you pulling commits out of the tip tree quite often, when 
> they have testing failures of various kinds.  I presume that, like 
> other maintainers, you have some branches that you try hard not to 
> rebase and other testing branches that are quite volatile and get 
> reconstructed frequently (though I don't know what branch names 
> you use for them).
> 
> I presumed that you wouldn't have put a commit that hadn't even 
> passed basic build testing into one of your non-rebasing branches.  
> That's why I assumed you could fold the fix into the original 
> patch without difficulty.

Sometimes rebasing is possible, sometimes not. Here it's borderline 
- the commit was already behind other commits.

> > The thing is, we'll probably redo this portion of the timer tree 
> > as i found other problems in testing, but generally the 
> > disadvantages of a build breakage with a very small 
> > non-bisectability window has to be weighed against the 
> > disadvantages of a rebase (which are significant).
> > 
> > The equation does not automatically flip in favor of a rebase as 
> > you seem to suggest - in fact it generally goes _against_ a 
> > rebase.
> 
> In a stable, non-rebasing branch, sure.  But putting untested 
> patches into such a branch would be a bit silly, so I assumed you 
> hadn't done that. :)

You have not answered my primary question though AFAICS. There's 
_more_ build breakages in Linus's tree (in a volume-scaled form), so 
why dont you request rebases there?

If you requested them you'd have a snowball's chance in hell, Linus 
has never rebased the upstream tree, ever. Once pushed out for 
others to pull it's cast into stone. Yes, sometimes the build 
breaks, especially on rarely used architectures. We fix them.

The more frequently an architecture is tested, the more it is used 
in practice, the more a driver and an architecture matters the 
shorter the bisection breakage window becomes. The upstream kernel 
is a self-tuning process of quality, even without rebases and 
backmerges.

(DaveM does something quite similar to Linus too AFAICS, he too 
never rebases the networking tree.)

I'm thinking about starting to do the same for all -tip trees too: i 
do reasonable testing before pushing it out, on the most common 
architecture and driver selection, and once pushed out it's cast 
into stone Git-wise.

I actually start regretting that i do rebases too frequently - some 
people (not you really, but you gave me the perfect example to reply 
to) want more and seem to think they are _entitled_ to rebases and 
are entitled to backmerges. The thing is, rebases are not free. They 
are risky and error-prone, and they destroy Git history.

	Ingo
