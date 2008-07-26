Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYGZNJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYGZNJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYGZNIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:08:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbYGZNIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:08:51 -0400
Date: Sat, 26 Jul 2008 15:08:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: more header fixes
Message-ID: <20080726130840.GA14466@elte.hu>
References: <20080716142225.GA19054@elte.hu> <20080722123231.GA13172@localhost.localdomain> <20080722103632.GA27029@elte.hu> <19f34abd0807220413sabb9f65h6ac20f98efb680bf@mail.gmail.com> <20080722113823.GA9351@elte.hu> <19f34abd0807221127q1c26fed7w5b276cadb7319fec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807221127q1c26fed7w5b276cadb7319fec@mail.gmail.com>
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Tue, Jul 22, 2008 at 1:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >> Though I still believe it should be squashed for bisectability.
> >
> > hm, i pulled it but 1ab9e368 cannot be squashed into aa27f9586 cleanly.
> 
> Yes, you are right. I forgot to check.
> 
> > I'd suggest the following approach, which we used for the scripted
> > unification of arch/x86. Do a couple of preparatory patches that just
> > bring all the header guards into proper shape. _Then_ run the script
> > against that "prepared" tree. The end result should be correct to the
> > best of our current knowledge. (i'll figure out any remaining build
> > breakages quickly - i can build 120+ random kernels per hour)
> >
> > We can rebase x86/header-guards to such a bisectable approach no problem
> > if you can do it like that, it's not yet merged anywhere. Just send me a
> > pull URI that i'll pull into a x86/header-guards that is reset back to
> > linus/master.
> >
> > Can you see any complications with that approach?
> 
> There's not really that much to prepare. But it really helps to work
> against the right tree to begin with :-)
> 
> So here's another one, this time prepared against linus/master, and
> fully bisectable by delaying the fixing of the headers which have
> external users of their guard-names. Check out the (new) 'for-tip'
> branch of
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git
> 
> There are still headers left which have no guard at all; that's okay. 
> If they should be changed, it can be done later, it shouldn't make a 
> difference for now.

pulled into tip/x86/header-guards, thanks Vegard.

One small request: in the future, could you use git-request-pull to 
generate pull requests?

That way the full URI is included (otherwise it's easy to forget to add 
the 'for-tip' branch to the pull i do, etc.). Something like:

 git-request-pull linus/master \
  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/linux-2.6-headers.git \
   for-tip

should do the trick. Thanks,

	Ingo
