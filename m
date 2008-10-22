Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbYJVMK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbYJVMK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYJVMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:10:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46964 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYJVMKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:10:14 -0400
Date: Wed, 22 Oct 2008 14:10:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] pending scheduler updates
Message-ID: <20081022121007.GG8095@elte.hu>
References: <20081017172701.047939625@chello.nl> <20081020120538.GD10594@elte.hu> <20081021173529.GG11679@linux.vnet.ibm.com> <20081022094019.GG12453@elte.hu> <1224669821.6871.16.camel@marge.simson.net> <1224671528.7511.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224671528.7511.11.camel@marge.simson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2008-10-22 at 12:03 +0200, Mike Galbraith wrote:
> 
> > It has positive effects too, but IMHO, the bad outweigh the good.
> 
> BTW, most dramatic on the other end of the spectrum is pgsql+oltp.  
> With preemption as is, it collapses as load climbs to heavy with 
> preemption knobs at stock.  Postgres uses user-land spinlocks and 
> _appears_ to wake others while these are still held.  For this load, 
> there is such a thing as too much short-term fairness, preempting lock 
> holder creates nasty gaggle of contended lock spinners.  It's curable 
> with knobs, and I think it's postgres's own fault, but may be wrong.
> 
> With that patch, pgsql+oltp scales perfectly.

hm, tempting.

Have you tried to hack/fix pgsql to do proper wakeups?

Right now pgsql it punishes schedulers that preempt it while it is 
holding totally undeclared (to the kernel) user-space spinlocks ... 

Hence postgresql is rewarding a _bad_ scheduler policy in essence. And 
pgsql scalability seems to fall totally apart above 16 cpus - regardless 
of scheduler policy.

	Ingo
