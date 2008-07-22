Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbYGVJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbYGVJE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYGVJEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:04:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYGVJEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:04:50 -0400
Date: Tue, 22 Jul 2008 11:04:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix pte_flags() to only return flags, fix lguest
	(updated)
Message-ID: <20080722090432.GD2065@elte.hu>
References: <200807221431.58991.rusty@rustcorp.com.au> <488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807221540.47161.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Jeremy said:
> 	rusty: use PTE_MASK
> 	rusty: use PTE_MASK
> 	rusty: use PTE_MASK
>  When I asked:
> 	jsgf: does that include the NX flag?
>  He responded eloquently:
> 	rusty: use PTE_MASK
> 	rusty: use PTE_MASK
> 	yes, it's the official constant of masking flags out of ptes
> )
> 
> Change a15af1c9ea2750a9ff01e51615c45950bad8221b 'x86/paravirt: add
> pte_flags to just get pte flags' removed lguest's private pte_flags()
> in favor of a generic one.
> 
> Unfortunately, the generic one doesn't filter out the non-flags bits:
> this results in lguest creating corrupt shadow page tables and blowing
> up host memory.
> 
> Since noone is supposed to use the pfn part of pte_flags(), it seems
> safest to always do the filtering.
> 
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

applied to tip/x86/urgent - thanks Rusty!

i'm wondering. My randconfig tests boot up an lguest enabled kernel 
every 30 minutes or so:

 config-Mon_Jul_21_19_05_54_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_19_43_13_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_19_47_40_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_20_37_41_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_22_11_42_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_22_16_59_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_22_32_22_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_23_25_55_CEST_2008.good:CONFIG_LGUEST=y
 config-Mon_Jul_21_23_51_29_CEST_2008.good:CONFIG_LGUEST=y

Would it be possible to have some really stupid lguest self-test which 
would complain spectacularly in the host kernel if it fails to reach 
some minimal user-space?

Something that could be self-contained within a single bzImage. (i.e. it 
would contain a minimalistic image of some sort with a very minimalistic 
userspace component as well - or something like that)

I test many distros so installing anything on the user-space side is 
quite a PITA and it can go bust without me noticing.

If we had something like that then we'd have noticed the lguest breakage 
within 30 minutes of adding the bad commit. (Unless of course you insist 
on us adding hard to find random breakages to lguest - which service i'm 
afraid we are bound to provide to you in the future too! ;)

	Ingo
