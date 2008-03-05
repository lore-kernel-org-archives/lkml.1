Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYCEPhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYCEPhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYCEPh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:37:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbYCEPhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:37:25 -0500
Date: Wed, 5 Mar 2008 16:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: profile_pc() bogus since <= 2.6.19 (x86 at least)?
Message-ID: <20080305153711.GC19300@elte.hu>
References: <47CE8EAD.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE8EAD.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jan Beulich <jbeulich@novell.com> wrote:

> Ingo,
> 
> while the comment at the top of kernel/spinlock.c states so:
> 
>  * Note that some architectures have special knowledge about the
>  * stack frames of these functions in their profile_pc. If you
>  * change anything significant here that could change the stack
>  * frame contact the architecture maintainers.
> 
> the actual code doesn't seem to match this anymore. With all (and even 
> before that, many) functions being written in C, there cannot be 
> validly made assumptions about the stack frame layout. Indeed, if I 
> check the disassembly framed by __lock_text_{start,end} on x86, there 
> are a number of functions that push one or two registers (in 
> lock_kernel() even stack variables are being allocated), which clearly 
> breaks profile_pc()'s assumptions.
> 
> Since it's been this way for so long, I wonder how frequently this 
> code is actually being exercised...

yeah - i guess it's not really relevant anymore now that lockdep saves 
full stack traces. I doubt anyone bothers to look at wchan anymore. We 
might even remove all the __lock and __sched sections and annotations?

	Ingo
