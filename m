Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZKJVVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZKJVVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZKJVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:21:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56622 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZKJVVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:21:22 -0500
Date: Tue, 10 Nov 2009 22:20:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110212059.GC23196@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de>
 <4AF9BB2A.7060109@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9BB2A.7060109@nortel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Friesen <cfriesen@nortel.com> wrote:

> On 11/10/2009 09:52 AM, Stefan Richter wrote:
> 
> > More importantly, isn't this against the character of the -stable kernel
> > branches as _safe and simple_ hotfix branches?
> > 
> > If a fix has a number of prerequisites which ar not -stable fixes
> > themselves, then it is more than a hint that this fix is not really well
> > suited for -stable.
> 
> Alternately, it's conceivable that the prerequisites were not 
> in-and-of-themselves candidates for -stable (maybe they didn't do 
> anything by themselves) but when combined with the final commit the 
> overall change is suitable for inclusion in -stable.

Yeah.

The way i do it as a maintainer is that when i add a new commit that i 
realize as a -stable candidate, and i know that it has no semantic 
prereqs (such as a new API, etc.), i git-cherry-pick it into stable in a 
test branch. If that works fine i mark it -stable straight away.

If it conflicts, i figure out the prereqs, and look at those. If they 
are too big, or too risky, i often decide not to mark a patch for 
-stable backporting. (If it's not obvious to be in -stable then it 
should not be in -stable, almost by definition - a _LOT_ of people are 
using the stable kernels.)

If the prereqs look sane and are wanted for -stable, i end up with a 
list of 2 or at most 3 commits that will cherry-pick cleanly. (rarely 
more than that - the 4 commits here are really an exception - they are a 
string of prereqs that are also fixes)

I send that list of commits to stable@kernel.org.

( Sidenote: rarely does it make sense to port a conflicting commit to 
  -stable. The risks of introducing some regression are just too high. 
  Cherry-picking of commits, (while not entirely risk-free of course), 
  is far more robust in practice. (conflicting backmerges do happen too 
  occasionally, for high-profile bug fixes that justify the cost.) )

So this 'send the list to stable@kernel.org' step is simplified via 
these tags:

    Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
    Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
    Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
    Cc: <stable@kernel.org> # .32.x

I'd have done that via a plain email in any case - so this scheme does 
not enable anything new - it just simplifies the process and makes it a 
bit more robust.

	Ingo
