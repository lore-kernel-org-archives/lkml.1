Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYIHPYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYIHPYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYIHPXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:23:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbYIHPXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:23:52 -0400
Date: Mon, 8 Sep 2008 17:23:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Message-ID: <20080908152330.GA9784@elte.hu>
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 7 Sep 2008, H. Peter Anvin wrote:
> > 
> > Under that logic we shouldn't even have CPU configurables, since you want it
> > to "just work" whatever crap you're running on.  That is EXACTLY what
> > CONFIG_X86_GENERIC means
> 
> I dunno.. Event he help-text doesn't actually agree with that:
> 
>   config X86_GENERIC
>         bool "Generic x86 support"
>         depends on X86_32
>         help
>           Instead of just including optimizations for the selected
>           x86 variant (e.g. PII, Crusoe or Athlon), include some more
>           generic optimizations as well. This will make the kernel
>           perform better on x86 CPUs other than that selected.
>           
>           This is really intended for distributors who need more
>           generic optimizations.
> 
> Also, quite frankly, while the CPU processor type message says
> 
>           The kernel will not necessarily run on earlier architectures than
>           the one you have chosen, e.g. a Pentium optimized kernel will run on
>           a PPro, but not necessarily on a i486.
> 
> I thought you agreed that CPU virtualization can be a problem? That 
> was the whole excuse for why the dynamic code was changed. Why would 
> it not be true for the static code?
> 
> The fact is, if you want to run on a Core2 or other modern CPU, then 
> "Virtual PC" is apparently buggy in this respect. You worked around it 
> for the dynamic choice - but that's totally _pointless_ if you then 
> don't want to work around it for the static one.

yes. X86_P6_NOPS is a totally insignificant optimization and if it makes 
_any_ CPU not boot (be that virtual or real), then it's frankly not 
worth it.

David, exactly how does the kernel fail to boot with latest -git? 
(v2.6.27-rc5-313-g64f996f or later) Does detect_nopl() run? It really 
should, and it should detect the non-working instructions.

	Ingo
