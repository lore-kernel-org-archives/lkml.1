Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYJJP04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYJJP04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbYJJP0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:26:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58499 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbYJJP0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:26:47 -0400
Date: Fri, 10 Oct 2008 17:26:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
Message-ID: <20081010152631.GB26231@elte.hu>
References: <20081009234705.GA20540@elte.hu> <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 10 Oct 2008, Ingo Molnar wrote:
> > 
> > Vegard Nossum (3):
> >       x86: consolidate header guards
> >       x86: consolidate header guards
> 
> Ok, so I pulled phase 1, but quite frankly, I think this was utter 
> crap. Why the hell did this go in?

we'll fix that up. We'll move all header files to arch/x86/include/asm/ 
anyway later in the merge window, once the dust settles, and can do a 
separate commit for this as well.

The main motivation was that we had a few incidents of missing header 
guards and Vegard asked whether he should script up some complete commit 
that adds guards to all files and i agreed and didnt look closely enough 
- my bad.

this aspect of it:

 -#ifndef _ASM_X86_I387_H
 -#define _ASM_X86_I387_H
 +#ifndef ASM_X86__I387_H
 +#define ASM_X86__I387_H

is indeed broken and deviates from the established convention of the 
header guards as well.

> And yes, yes, we could add the f*cking things back when we export them 
> as header files, but what's the point, really? And no, I'm not 
> guaranteeing that we're being super-careful about namespace issues in 
> all kernel headers that can get exported to user space, but we _try_.

yes, agreed. Sorry about that, it slipped through. (It was one of our 
first real Git pulls and i meanwhile learned to look at them much more 
carefully.)

It's completely my fault because Vegard offered multiple iterations of 
the script and asked us precisely what we wanted.

	Ingo
