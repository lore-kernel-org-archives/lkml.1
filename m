Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZDEWAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZDEWAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 18:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZDEWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 18:00:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZDEWAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 18:00:19 -0400
Date: Sun, 5 Apr 2009 23:59:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       John Levon <levon@movementarian.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH] x86, oprofile: fix P4 oprofile CPU setup bug
Message-ID: <20090405215916.GA27633@elte.hu>
References: <1238958725.3522.1.camel@ht.satnam> <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain> <1238962495.3301.0.camel@ht.satnam> <20090405213828.GA1059@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090405213828.GA1059@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Hm, you only seem to be looking at solving that warning message, 
> and your interest does not seem to go outside of that scope at 
> all. Your first fix was to make the message go away, your second 
> fix minimally (tried to address) the review from Linus and did a 
> mechanic change to make the message go away.
> 
> This second change was actually subtly worse than the first one: 
> because it spread the uncleanliness elsewhere. The getting of 
> 'stagger' is in no way central to the code, it does not denote 
> critical sections at all.

btw. - and this is a pet peeve of mine - in the x86 tree we never 
ever "fix" warnings.

Warnings can only be dealt with in two ways correctly:

 - Fix _false positive_ warnings - carefully analyzing and 
   explaining why the warning is a false positive.

 - .. or by fixing _real bugs_, which bugs some warning mechanism
   exposed. The warning there does not need to be 'fixed' - it was
   the canary for a real bug and we fix the _bug_, not the warning. 
   ( the warning does go away but only as a side-effect of the bug
     going away. )

The moment you start 'fixing warnings' (and i note here that you 
seem to be interested in doing many such changes and cleanups, so we 
better talk about this fine distinction), you risk the exact pattern 
that happened above:

... something subtle happened somewhere - and you sent a patch that 
you denoted as a 'fix' in the subject line. Your commit log did not 
show at all whether you understood the full context, and you did not 
analyze the _reason_ for the warning, at all.

I routinely reject such patches, just based on that pattern, even if 
i happen to agree with the change.

They are in fact _actively harmful_, because a poor overworked 
maintainer like me might apply it in a weak moment. [ except Linus, 
who is overworked and still notices such patches but what's new ;-) ]

Instead, if you see such warnings, and dont know why they trigger - 
please send in the message denoted as a bug report. Or if you have a 
guess of a patch but are unsure about a change in any way send in an 
RFC patch and _declare_ the bits you are sure about and the bits you 
are unsure about, and ask specific questions and show how far you 
got in the analysis. It is not a problem to declare the area you 
dont understand - it is useful information to those reading your 
emails. Conversely, the _lack_ of such information is harmful. Ok?

Please dont _ever_ send in patches without a meaningful changelog.

Take this as a warning! ;-)

	Ingo
