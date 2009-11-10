Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbZKJUja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbZKJUja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbZKJUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:39:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104AbZKJUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:39:28 -0500
Date: Tue, 10 Nov 2009 21:39:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110203913.GA18509@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <20091110193747.GB12686@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110193747.GB12686@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> > By the looks of the above it's only a few commits, or is it the 
> > entire branch?
> 
> I'm thinking the commit would be the merge, right Ingo?  So it would 
> just be a single commit that has the marker in it.

Correct.

This is really a special case, a small variation of the commit eae0c9d 
-stable tagging scheme i outlined in the first mail.

When i merge */urgent branches into the for-linus branch in the merge 
window, i cannot change the commits anymore (it would amount to a 
rebase), but i have the opportunity to modify the merge commit message 
itself. (which is typically a regular merge commit and does not carry 
any -stable actionable change itself.)

I already annotate merge commits today - for example:

 | commit 43315956509ca6913764861ac7dec128b91eb1ec
 | Merge: 9bf4e7f 6beba7a
 | Author: Ingo Molnar <mingo@elte.hu>
 | Date:   Fri Oct 23 08:23:20 2009 +0200
 |
 |     Merge branch 'perf/core' into perf/probes
 |    
 |     Conflicts:
 |         tools/perf/Makefile
 |    
 |     Merge reason:
 |    
 |      - fix the conflict
 |      - pick up the pr_*() infrastructure to queue up dependent patch
 |    
 |     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Note how i already put a SOB line into the merge commit - i treat every 
merge as something that 'had to be done' so they are never arbitrary and 
always carry real information.

So my idea was to potentially use the extended -stable notification 
scheme in certain merge commits too. Here's a mockup merge commit log:

    Merge branch 'sched/urgent' into sched/core
     
    Conflicts:
        tools/perf/Makefile
     
    Merge reason:
     
     - resolve the conflict
     - queue up urgent fixes for the next merge window

    Cc: <stable@kernel.org> # .32.x: a1f84a3: sched: Check for an idle shared cache
    Cc: <stable@kernel.org> # .32.x: 1b9508f: sched: Rate-limit newidle
    Cc: <stable@kernel.org> # .32.x: fd21073: sched: Fix affinity logic
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Note that the merge commit itself carries no action for -stable: there's 
no "Cc: <stable@kernel.org>" line - only 'pointer' lines in the form 
of:

    Cc: <stable@kernel.org> # .32.x: sha1: title

But ... if you or Linus dislikes this direction of tagging for some 
reason i can still do the manual approach as well. It seemed useful to 
me though and it would be a natural portion of my workflow.

	Ingo
