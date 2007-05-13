Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXEMVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXEMVyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbXEMVyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:54:17 -0400
Received: from mail.screens.ru ([213.234.233.54]:55068 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbXEMVyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:54:16 -0400
Date: Mon, 14 May 2007 01:54:25 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: 2.6.22-rc1: Broken suspend on SMP with tifm
Message-ID: <20070513215425.GA3240@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <200705132322.10032.rjw@sisk.pl> <20070513213424.GA3198@tv-sign.ru> <200705132350.32582.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705132350.32582.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Rafael J. Wysocki wrote:
>
> On Sunday, 13 May 2007 23:34, Oleg Nesterov wrote:
> > On 05/13, Rafael J. Wysocki wrote:
> > >
> > > @@ -819,20 +843,31 @@ static int __devinit workqueue_cpu_callb
> > >  
> > > +
> > > +		case CPU_DEAD_FROZEN:
> > > +			if (wq->freezeable) {
> > > +				take_over_work(wq, cpu);
> > > +				thaw_process(cwq->thread);
> > 
> > Suppose that PF_NOFREEZE task T does flush_workqueue(), and CPU 1 has pending
> > works. T does flush_cpu_workqueue(0), CPU_DEAD_FROZEN moves works from CPU 1
> > to CPU 0, T does flush_cpu_workqueue(1) and finds nothing.
> 
> I don't think this is possible, because we've acquired workqueue_mutex in
> _cpu_down().

Yes, we did... but flush_workqueue() doesn't take it?

Oleg.

