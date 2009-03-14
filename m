Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZCNLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZCNLsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbZCNLsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:48:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42666 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbZCNLsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:48:05 -0400
Date: Sat, 14 Mar 2009 12:47:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au, mail@tobiasvolk.de
Subject: Re: enable padlock on x86_64
Message-ID: <20090314114732.GB3805@elte.hu>
References: <49B83002.9040705@tobiasvolk.de> <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237029843-28076-1-git-send-email-sebastian@breakpoint.cc>
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


* Sebastian Andrzej Siewior <sebastian@breakpoint.cc> wrote:

> To enable the padlock unit, two msr bits have to flipped. This is allready
> done in the 32bit path and is missing in the other. Instead of copy paste
> the code, I merged the 64bit part into the 32bit part. The things that
> changed during the merge:
> - the fixups from x86_64 (family 6, model >= 15) were not present in 32bit
>   path but are now. They might be usefull if this CPU is booted in 32bit
>   mode.
> - the fixups which are executed via ->c_early_init() are now executed
>   again via ->c_init(). This was done in the 64bit path and without this I
>   lost the constant_tsc flag. However, tsc is not useable due to
> | [    2.023006] Marking TSC unstable due to TSC halts in idle
> | [    2.500082] Clocksource tsc unstable (delta = -326436711 ns)
> 
> The two patches are against the current tip tree. A version of 
> patch 1 against current -rc8 is available at [0].

thanks, looks good. We can apply #1 to -tip just fine - but a 
drivers/crypto/ change should go via the crypto tree. Can the 
crypto tree apply #2 without having #1 right away? [i.e. will it 
still build and boot fine - even though the padlock 
functionality might not be fully present on 32-bit? ]

Then in 2.6.30 once both the x86 tree and the crypto tree are 
merged we'll have both changes combined.

Does that sound good?

	Ingo
