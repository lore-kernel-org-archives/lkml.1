Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYKHM3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYKHM3R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 07:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYKHM27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 07:28:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209AbYKHM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 07:28:59 -0500
Date: Sat, 8 Nov 2008 13:28:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpumask: introduce new API, without changing anything
Message-ID: <20081108122833.GH8354@elte.hu>
References: <20081029152849.3883d072.sfr@canb.auug.org.au> <20081107093911.GD7787@elte.hu> <20081107122400.GA20777@elte.hu> <200811082024.20157.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811082024.20157.rusty@rustcorp.com.au>
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

> On Friday 07 November 2008 23:24:00 Ingo Molnar wrote:
> > Find below the delta patch between the two versions, and an
> > analysis/review of the changes. I've started testing it as well, and
> > it's looking good so far.
> 
> Ok, I sent through the latest delta on top of this before, but see below.
> 
> > - the cpumask_of() is added to the SMP section of cpumask.h but not to
> >   the UP section.
> 
> Not quite: it's in the general section.  Don't scare me like that :)

heh, indeed - i looked twice and both times i missed this in the 
middle of that code:

 #endif /* SMP */

... sorry, my bad! (a newline before this line might have helped)

> > - the free_bootmem_cpumask_var() addition looks good but is a tiny bit
> >   incomplete: the free_bootmem_cpumask_var() function should be marked
> >   __init, like all bootmem methods are.
> 
> Looks like you took that draft I mailed around?  Mike asked for 
> free_... as a response to that.  But I'll fix the __init.
> 
> I've restored the patch into that version you have, plus separate 
> updates.  I hope that fixes the workflow issues.
> 
> Updates below for reference.

thanks a ton, this looks perfect.

Mike, could you please double-check that the version that is in 
tip/cpus4096 [622e0ed] is the final version you need, and that if you 
base subsequent patches on it it works as expected?

Then it would be all green and Rusty could send the final version of 
the patch to Linus. It has my ack obviously:

  Acked-by: Ingo Molnar <mingo@elte.hu>

and once that patch hits upstream, we could restructure/rebase the 
commits in cpus4096-v2 ontop of upstream and spread them out properly. 
Does that sound optimal?

Thomas also did a cross-build of it, and it looks all good:

   Run 141: 2008-11-07 13:54:41 .. 2008-11-07 15:02:59

   Run 141: 17 of 19 operations OK
   Run 141: 2 of 19 operations FAILED

   http://www.tglx.de/autoqa-logs/000141-0008-0005.log
   http://www.tglx.de/autoqa-logs/000141-0008-0015.log

the two build failures are not related to these changes.

	Ingo
