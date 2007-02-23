Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbXBWHcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbXBWHcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 02:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXBWHcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 02:32:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:50181 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752138AbXBWHcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 02:32:11 -0500
X-Provags-ID: V01U2FsdGVkX19zzBkNbNFzeEHa21j/fUGitrEwZZOTTxlHYZIN8K
	X4Bg==
Subject: Re: 2.6.20-git15 BUG: soft lockup detected on CPU#0! - timers?
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070223060802.GA8562@elte.hu>
References: <6bffcb0e0702201054rb839bb2m11ef8d33bacffdb8@mail.gmail.com>
	 <1172008584.25076.0.camel@localhost.localdomain>
	 <6bffcb0e0702201437o66db38d5j3066eb3c9951a270@mail.gmail.com>
	 <1172072023.25076.64.camel@localhost.localdomain>
	 <6bffcb0e0702210738p687ca1bdt2c568d7ed5904fff@mail.gmail.com>
	 <1172088044.25076.125.camel@localhost.localdomain>
	 <45DCF644.9040009@googlemail.com> <45DD756D.3040006@googlemail.com>
	 <20070223060802.GA8562@elte.hu>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 08:32:03 +0100
Message-Id: <1172215923.6774.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-23 at 07:08 +0100, Ingo Molnar wrote:

> Index: linux/kernel/sched.c
> ===================================================================
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4689,6 +4689,7 @@ int __sched cond_resched_softirq(void)
>  	BUG_ON(!in_softirq());
>  
>  	if (need_resched() && system_state == SYSTEM_RUNNING) {
> +		WARN_ON(current->state != TASK_RUNNING);
>  		raw_local_irq_disable();
>  		_local_bh_enable();
>  		raw_local_irq_enable();

I'm getting NOHZ: local_softirq_pending 02 or 10 every few seconds if
the box is doing anything, and the WARN_ON() has yet to trigger.

	-Mike

