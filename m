Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYGNQot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYGNQot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYGNQom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:44:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536AbYGNQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:44:41 -0400
Date: Mon, 14 Jul 2008 09:44:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core/softirq for v2.6.27
Message-Id: <20080714094422.e7ae255a.akpm@linux-foundation.org>
In-Reply-To: <20080714163141.GA21068@elte.hu>
References: <20080714144243.GA21079@elte.hu>
	<20080714092215.0efd7fa3.akpm@linux-foundation.org>
	<20080714163141.GA21068@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 18:31:41 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 14 Jul 2008 16:42:43 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > 
> > It would be nice if these short-form summaries were to include the
> > commit IDs.  eg:
> > 
> > Carlos R. Mafra (1):
> >       Remove argument from open_softirq which is always NULL (962cf36)
> 
> yeah, but not sure whether git-shortlog

This was a git-shortlog feature request ;)

> can do that and this shortlog is 
> the Preferred Way of getting pull requests.
> 
> I'm using the sha1's myself for non-shortlog formats, like:
> 
>   earth4:~/tip> git-log-line linus..core/softirq
>   0f476b6: softirq: remove irqs_disabled warning from local_bh_enable
>   4620b49: softirq: remove initialization of static per-cpu variable
>   962cf36: Remove argument from open_softirq which is always NULL
> 
> where git-log-line does the obvious single-line shortcut:
> 
>   git log --no-merges --pretty=format:"%h: %s" $@
> 
> > > Carlos R. Mafra (1):
> > >       Remove argument from open_softirq which is always NULL
> > > 
> > > Johannes Berg (1):
> > >       softirq: remove irqs_disabled warning from local_bh_enable
> > 
> > This doesn't remove the warning?  (Nor should it)
> > 
> > +static inline void _local_bh_enable_ip(unsigned long ip)
> >  {
> > +       WARN_ON_ONCE(in_irq() || irqs_disabled());
> > -       WARN_ON_ONCE(in_irq());
> > -       WARN_ON_ONCE(irqs_disabled());
> > 
> > It just makes it a bit less useful.
> 
> hm, it does more than that

Yes, but it does what I said:

- Doesn't do something which the changelog said it did.  I brought this up
  because if the patch _did_ do what it said it did, davem would cry.

- Makes the warning less useful.  The reason for the warning can still
  probably be worked out from the backtrace, but it'll take more work.

> - this commit (0f476b6d9) actually caught a 
> real bug/lockup on one of my testboxes, see this (in v2.6.26) fix:
> 
> | commit c5643cab7bf663ae049b11be43de8819683176dd
> | Author: Ingo Molnar <mingo@elte.hu>
> | Date:   Mon Jun 23 10:41:23 2008 +0200
> |
> |    [netdrvr] 3c59x: remove irqs_disabled warning from local_bh_enable

OK, that title kinda makes sense.

> |    Original Author: Michael Buesch <mb@bu3sch.de>
> |
> |    net, vortex: fix lockup

Although that would be a better title for the 3c59x.c fix.

> [ i didnt send it to v2.6.26 because it came relatively late, it touches 
>   a sensitive, #ifdef laden piece of code and it was unknown how many 
>   false positives it would trigger. But it's perfect for v2.6.27. ]
> 

It's a small issue - it's just that the title of
0f476b6d91a1395bda6464e653ce66ea9bea7167 ("softirq: remove
irqs_disabled warning from local_bh_enable") appears to be quite
wrong.
