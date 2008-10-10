Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYJJHfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYJJHfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 03:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbYJJHfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 03:35:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35441 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbYJJHfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 03:35:34 -0400
Date: Fri, 10 Oct 2008 09:35:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: bit-field is not thread-safe nor smp-safe
Message-ID: <20081010073520.GC16016@elte.hu>
References: <48EEF9AD.9040401@cn.fujitsu.com> <20081010073136.GC23247@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010073136.GC23247@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> > 
> > bit-field is not thread-safe nor smp-safe.
> > 
> > struct marker_entry.rcu_pending is not protected by any lock
> > in rcu-callback free_old_closure().
> > so we must turn it into a safe type.
> > 
> 
> 
> hrm, yes, you are right. I first test for 
> 
>         if (entry->rcu_pending)
>            rcu_barrier_sched();
> 
> To check if I must execute the rcu callback, and _this_ races against
> the entry->rcu_pending = 0; within the callback.
> 
> Your fix is therefore needed.
> 
> Thanks !
> 
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

applied to tip/tracing/markers, thanks guys!

	Ingo
