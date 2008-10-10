Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYJJLnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYJJLnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYJJLmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:42:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYJJLmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:42:55 -0400
Date: Fri, 10 Oct 2008 13:42:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Evgeniy Polyakov <s0mbre@tservice.net.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [tbench regression fixes]: digging out smelly deadmen.
Message-ID: <20081010114245.GB19487@elte.hu>
References: <20081009231759.GA8664@tservice.net.ru> <20081010080910.GA31723@tservice.net.ru> <20081010091511.GC5116@elte.hu> <20081010113100.GA1030@tservice.net.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010113100.GA1030@tservice.net.ru>
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


* Evgeniy Polyakov <s0mbre@tservice.net.ru> wrote:

> > i'm glad that you are looking into this! That is an SMP box, right? 
> > If yes then could you try this sched-domains tuning utility i have 
> > written yesterday (incidentally):
> > 
> >   http://redhat.com/~mingo/cfs-scheduler/tune-sched-domains
> 
> I've removed SD_BALANCE_NEWIDLE:
> # ./tune-sched-domains $[191-2]

> And got noticeble improvement (each new line has fixes from previous):
> 
> vanilla 27: 347.222
> no TSO/GSO: 357.331
> no hrticks: 382.983
> no balance: 389.802

okay. The target is 470 MB/sec, right? (Assuming the workload is sane 
and 'fixing' it does not mean we have to schedule worse.)

We are still way off from 470 MB/sec.

	Ingo
