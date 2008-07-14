Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYGNQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYGNQcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYGNQb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:31:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbYGNQb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:31:57 -0400
Date: Mon, 14 Jul 2008 18:31:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core/softirq for v2.6.27
Message-ID: <20080714163141.GA21068@elte.hu>
References: <20080714144243.GA21079@elte.hu> <20080714092215.0efd7fa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714092215.0efd7fa3.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 14 Jul 2008 16:42:43 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> >
> 
> It would be nice if these short-form summaries were to include the
> commit IDs.  eg:
> 
> Carlos R. Mafra (1):
>       Remove argument from open_softirq which is always NULL (962cf36)

yeah, but not sure whether git-shortlog can do that and this shortlog is 
the Preferred Way of getting pull requests.

I'm using the sha1's myself for non-shortlog formats, like:

  earth4:~/tip> git-log-line linus..core/softirq
  0f476b6: softirq: remove irqs_disabled warning from local_bh_enable
  4620b49: softirq: remove initialization of static per-cpu variable
  962cf36: Remove argument from open_softirq which is always NULL

where git-log-line does the obvious single-line shortcut:

  git log --no-merges --pretty=format:"%h: %s" $@

> > Carlos R. Mafra (1):
> >       Remove argument from open_softirq which is always NULL
> > 
> > Johannes Berg (1):
> >       softirq: remove irqs_disabled warning from local_bh_enable
> 
> This doesn't remove the warning?  (Nor should it)
> 
> +static inline void _local_bh_enable_ip(unsigned long ip)
>  {
> +       WARN_ON_ONCE(in_irq() || irqs_disabled());
> -       WARN_ON_ONCE(in_irq());
> -       WARN_ON_ONCE(irqs_disabled());
> 
> It just makes it a bit less useful.

hm, it does more than that - this commit (0f476b6d9) actually caught a 
real bug/lockup on one of my testboxes, see this (in v2.6.26) fix:

| commit c5643cab7bf663ae049b11be43de8819683176dd
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Mon Jun 23 10:41:23 2008 +0200
|
|    [netdrvr] 3c59x: remove irqs_disabled warning from local_bh_enable
|
|    Original Author: Michael Buesch <mb@bu3sch.de>
|
|    net, vortex: fix lockup

[ i didnt send it to v2.6.26 because it came relatively late, it touches 
  a sensitive, #ifdef laden piece of code and it was unknown how many 
  false positives it would trigger. But it's perfect for v2.6.27. ]

	Ingo
