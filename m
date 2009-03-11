Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZCKW4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZCKW4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZCKWz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:55:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCKWz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:55:56 -0400
Date: Wed, 11 Mar 2009 23:55:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
Message-ID: <20090311225526.GA23203@elte.hu>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com> <20090310223733.GA4016@elte.hu> <1236786082.3270.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236786082.3270.20.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-03-10 at 23:37 +0100, Ingo Molnar wrote: 
> > * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > 
> > > Given the lack of feedback, I went ahead and implemented the 
> > > additions to smp_ops and x86_quirks (and a dynamic mca NMI 
> > > hook) to allow voyager to be plumbed in.
> > > 
> > > There also needs to be changes in the boot setup to make 
> > > voyager work dynamically: It has to be detected first, so the 
> > > a20 gate check is only executed if a voyager is not found.
> > > 
> > > I also completed some of the subarchitecture eliminations, so 
> > > all the include file infrastructure should be gone.
> > > 
> > > The result is that I can boot both my PC SMP x86 boxes and 
> > > voyager with the same kernel.
> > > 
> > > This patch series applies on the x86/apic branch of the x86 
> > > tree (obviously with 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 
> > > reverted)
> > 
> > The question is, why would we want to merge Voyager back ever 
> > again?
> 
> What do you mean merge back?  It's an existing and supported 
> architecture in git head.

That's revisionist history that ignores a few inconvenient 
facts. The x86/Voyager subarch last built successfully in 
v2.6.26.0 - in the summer of last year (!):

  v2.6.27.0:   Voyager was broken - it did not even build.
  v2.6.28.0:   Voyager was broken - it did not even build.
  v2.6.29-rc5: Voyager was broken - it did not even build.

... then we removed it from the x86 development tree and 
mentioned that it did not even build for a long time, and Cc:-ed 
you to all that. A few days later you finally sent a fix patch 
for mainline.

We merged that fix into -rc6 as it was small so yes, technically 
'git head works now', but that ignores the long negative track 
record of that code that we as x86 maintainers have experienced.

I.e. by all means it was broken code for almost 3 full kernel 
cycles, up until the very last minute when you saw us removing 
it. Talking about any sort of 'downstream community' and 
'supported architecture' is mocking these terms.

With regards to v2.6.30 it's simply too late - at least as far 
as my schedule goes. v2.6.29-final is maybe a week or two away, 
the merge window is very crowded already and we've pretty much 
closed down APIC related changes already.

You can still try to convince Thomas or Peter (i'm not the only 
x86 maintainer so merge decisions do not depend on me alone and 
you can convince them if you disagree with my position - they 
have symmetric commit rights to the x86 devel tree), but as far 
as i'm concerned personally, this merge window is too tight 
already.

In any case, if you find that code useful feel free to maintain 
it in a separate git tree (where any interested people/users can 
access it easily) and we can revisit this issue in the next 
development cycle, in 2-3 weeks or so, after the merge window.

Thanks,

	Ingo
