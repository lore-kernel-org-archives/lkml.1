Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZLYSpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZLYSpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 13:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbZLYSph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 13:45:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbZLYSpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 13:45:36 -0500
Date: Fri, 25 Dec 2009 19:45:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, torvalds@linux-foundation.org, peterz@infradead.org,
       efault@gmx.de, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
Message-ID: <20091225184514.GA381@elte.hu>
References: <1261315437.4314.6.camel@laptop>
 <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org>
 <20091225132642.GA1419@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091225132642.GA1419@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2009-12-20 18:00:38, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> > Gitweb:     http://git.kernel.org/tip/6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Sun, 20 Dec 2009 14:23:57 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sun, 20 Dec 2009 18:45:57 +0100
> > 
> > sched: Restore printk sanity
> > 
> > Revert the braindead pr_* crap. (Commit 663997d "sched: Use
> > pr_fmt() and pr_<level>()")
> > 
> > It's dumb and causes stupid "sched: " strings all over the place.
> 
> It seems rest of kernel is moving towards pr_*. [...]

Git stats do not agree with you:

 - for every pr_*() line in the kernel source code there's more than 6
   printk's:

     $ git grep '\<pr_' | wc -l
     10861
     $ git grep '\<printk' | wc -l
     61126

 - in the last stable kernel, v2.6.32, still more new printk()s were 
   introduced than pr_*() lines:

     $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<pr_' | wc -l
     2016
     $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<printk' | wc -l
     3531

An estimated completion of the 'conversion' to pr_*() to be in infinite number 
of years.

> [...] just removing the "sched:" would be better for consistency.
> 
> Or alternatively... deprecate pr_*?

Or alternatively, my favorite: let people who write the code use whichever 
variant they prefer.

	Ingo
