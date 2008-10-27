Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbYJ0QU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbYJ0QU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYJ0QUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:20:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbYJ0QUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:20:44 -0400
Date: Mon, 27 Oct 2008 17:20:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Message-ID: <20081027162023.GA19476@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <200810240953.15814.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810240953.15814.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Thursday 23 October 2008 23:03:22 Ingo Molnar wrote:
> > I also added "Impact:" lines to every commit - a one-line summary of the
> > expected outcome of the change. (Please double-check those impact lines
> > - if you see anything odd it means that i missed some detail in the
> > commit - that will need to be fixed if it happens.)
> 
> Note that "removed" and "deprecated" are using the terms loosely.  
> No old API was removed, and I didn't actually mark anything 
> __deprecated (I just documented it in the header).

ok.

> Here are my revisions:
> 
> f1ad2eefc7644467a5b8bec38b540f40260f0f03:
> cpumask: cpu_all_mask and cpu_none_mask
>     
> -Impact: introduce new constants, convert old usage to them
> +Impact: introduce new constants, convert core files.
> 
> 
> 88e316949934e187e4f131d99bf156413632e56b
> cpumask: deprecate any_online_cpu() in favour of cpumask_any/cpumask_any_and
>     
> -Impact: cleanup
> +Impact: new API, deprecate old
> 
> 
> 4d57c437e6d239f46a881fdb04a57fb2664bfc97
> cpumask: cpumask_first/cpumask_next
>     
> -Impact: remove old API, convert all users to new API
> +Impact: new API, deprecate old 
> (We convert one place only)
> 
> 
> dfa1385db10e1b1d5a1687f0184d9c11735192aa
> cpumask: for_each_cpu(): for_each_cpu_mask which takes a pointer
>     
> -Impact: remove old API, convert all users to new API
> +Impact: remove old API, convert core trivial users
> 
> a55659d4f58eaacde2681298d003bbeeafb16436
> cpumask: cpumask_of(): cpumask_of_cpu() which returns a pointer
>     
> -Impact: cleanup
> +Impact: new API, deprecate old API.

i've propagated these impact-line fixes into tip/cpus4096-v2, thanks 
Rusty!

And once we have something that works reasonably well we can do a 
final respin of this branch with all fixlets back-propagated, for good 
bisectability.

the current variant, which force-disabled MAXSMP (i.e. only uses the 
non-dynamic cpumask_t branch), is looking good in my testing so far. 
(it has passed more than 100 boot tests today, on a handful of x86 
boxes)

	Ingo
