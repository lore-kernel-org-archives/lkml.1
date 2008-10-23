Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYJWMD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYJWMD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYJWMDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:03:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45943 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbYJWMDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:03:42 -0400
Date: Thu, 23 Oct 2008 14:03:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Message-ID: <20081023120322.GC25132@elte.hu>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023020826.051012000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> [Resubmit: cleanup and rebase on latest tip/master.]
> 
> Redesign cpumask API to explicitly declare struct cpumask pointers to 
> the cpumask_* operators and add functions to make it easier to support 
> struct cpumask pointers on the stack.
> 
> This patchset supplies the infrastructure going forward to implement 
> this new struct cpumask API.  Many more patches (currently 58) have 
> been written and tested to verify the functionality of this API.  
> These will be submitted as soon as they are thoroughly tested.
> 
> Compiled and tested on x86_64.
> 
> Based on tip/master @ v2.6.27-6973-ga90cd11

okay, i've picked up these patches into tip/cpus4096-v2 and started 
testing them.

I fixed the From: line oddities - please holler if they are wrong 
anywhere, we can still rebase this.

Note, i've merged this to _after_ the huge arch/x86/include/asm/ headers 
move which we sent a pull request for earlier today - this will simplify 
logistics.

( I also fixed up a handful of obvious style problems in various places
  - please be more careful about comment structure, whitespaces, etc. -
  they just distract from general review and hurt the merits of your
  patches. )

I also added "Impact:" lines to every commit - a one-line summary of the 
expected outcome of the change. (Please double-check those impact lines 
- if you see anything odd it means that i missed some detail in the 
commit - that will need to be fixed if it happens.)

I've just completed the first basic step of testing: i did 68 kernel 
builds to test bisectability: all 34 commit point builds fine on both 
64-bit and 32-bit as well. (This took some time as almost every commit 
touches cpumask.h, forcing a full kernel rebuild.)

	Ingo
