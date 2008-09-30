Return-Path: <linux-kernel-owner+w=401wt.eu-S1752873AbYI3JoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbYI3JoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbYI3Jnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:43:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50274 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbYI3Jnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:43:53 -0400
Date: Tue, 30 Sep 2008 11:43:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Samuel Sieb <samuel@sieb.net>
Subject: Re: [PATCH] x86: enable CPUID on Cyrix cpus with CPUID disabled
Message-ID: <20080930094330.GA15607@elte.hu>
References: <20080929192407.1c31fe90.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929192407.1c31fe90.krzysztof.h1@poczta.fm>
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


* Krzysztof Helt <krzysztof.h1@poczta.fm> wrote:

> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> The macros setCx86_old() and getCx86_old() do not
> work as a comment says in the processor-cyrix.h.
> 
> Use working inline functions instead to enable
> the CPUID instriction on Cyrix cpus. 
> 
> Tested on IBM 6x86MX cpu with disabled the
> CPUID instruction.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> ---
> 
> This patch is against the linux-next tree (20080819)
> as it contains the following patch:
> 
> x86, cyrix: debug
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=026e2c05ef58ef413e2d52696f125d5ea1aa8bce
> 
> The linux-2.6-tip tree has not the Ingo's patch so it 
> does not require my patch.
> 
> I am confused. Is the x86 detection code for Cyrix
> cpus is right in the linux-next or in the linux-2.6-tip?
> Should I prepare patches against the linux-2.6-tip
> or linux-next?

now that the bug is correctly understood and fixed, could you please 
send a patch that cleans it all up and gets rid of the setCx86_old() / 
setCx86() API distinction? I.e. revert commit 026e2c0 ("x86, cyrix: 
debug"). Against tip/master please.

note that this was all done in connection to:

 commit c6744955d0ec0cb485c28c51eeb7185e260f6172
 Author: Samuel Sieb <samuel@sieb.net>
 Date:   Wed Aug 6 22:06:29 2008 -0700

    x86: fix "kernel won't boot on a Cyrix MediaGXm (Geode)"

	Ingo
