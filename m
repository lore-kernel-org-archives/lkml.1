Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYJAJIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYJAJIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 05:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYJAJI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 05:08:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52157 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbYJAJI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 05:08:27 -0400
Date: Wed, 1 Oct 2008 11:08:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/31] cpumask: Provide new cpumask API
Message-ID: <20081001090809.GA8281@elte.hu>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com> <20080929180250.825653000@polaris-admin.engr.sgi.com> <20080930091140.GB27452@elte.hu> <48E248CB.5080305@sgi.com> <48E25111.7060305@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E25111.7060305@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Mike Travis wrote:
> > Ingo Molnar wrote:
> ...
> > 
> >> In what way will Rusty's changes differ? Since you incorporate some of 
> >> Rusty's changes already, could you please iterate towards a single 
> >> patchset which we could then start testing?
> > 
> > Our timezones are not very conducive to a lot of email exchanges 
> > (and he's moving.) From what I've seen I believe he's leaning 
> > towards using struct cpumask * and less trickery than I have.

actually, that's quite sane to do. const_cpumask_t looked a bit weird to 
me.

the extra indirection to a cpumask_t is not a big issue IMO, so in that 
sense whether we pass by value or pass by reference is not a _big_ 
performance item.

The complications (both present and expected ones) all come from the 
allocations.

> Oh yeah, I forgot the other major point of Rusty's approach.  He wants 
> the patchset to be completely bisectable.  That's far from true in my 
> version.

well, it should be a smooth transition and completely bisectable, 
there's hundreds of usages of cpumask_t and quite many in the pipeline. 
It's far easier to _you_ to get this stuff to work if it's all gradual 
and is expected to work all across. Have a default-off debug mode that 
turns off compatible cpumask_t perhaps - we can remove that later on.

with 'struct cpumask' we could keep cpumask_t as the compatible API, and 
could see the impact of these changes in a very finegrained and gradual 
way. Seems like a fundamentally sane approach to me ...

	Ingo
