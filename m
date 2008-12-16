Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYLPKYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYLPKYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 05:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYLPKXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 05:23:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYLPKXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 05:23:50 -0500
Date: Tue, 16 Dec 2008 11:23:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>
Subject: Re: [mmotm and linux-next][PATCH] irq: enclose irq_desc_lock_class
	in CONFIG_LOCKDEP
Message-ID: <20081216102340.GA1003@elte.hu>
References: <20081216170635.DBB8.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081216003428.43d37b6b.akpm@linux-foundation.org> <20081216101827.GB27481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216101827.GB27481@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > >  #include "internals.h"
> > >  
> > > +#ifdef CONFIG_LOCKDEP
> > >  /*
> > >   * lockdep: we want to handle all irq_desc locks as a single lock-class:
> > >   */
> > >  static struct lock_class_key irq_desc_lock_class;
> > > +#endif
> > >  
> > >  /**
> > >   * handle_bad_irq - handle spurious and unhandled irqs
> > > 
> > 
> > No, lockdep.h (which we forgot to include) already handles that:
> > 
> > # define lockdep_set_class(lock, key)		do { (void)(key); } while (0)
> > 
> > the problem is that the code which references irq_desc_lock_class is
> > inside #ifdef CONFIG_SPARSE_IRQ, so this is a better fix:
> 
> agreed that this is the better fix - applied to tip/irq/sparseirq, 
> thanks!

actually, this breaks the build on !SPARSEIRQ because we will use that 
class in the non-sparseirq case. So we've converted a build warning to a 
build failure ;-)

	Ingo
