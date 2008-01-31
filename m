Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbYAaNdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbYAaNdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763582AbYAaNdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:33:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933956AbYAaNdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:33:07 -0500
Date: Thu, 31 Jan 2008 14:32:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, ebiederm@xmission.com,
       paulmck@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-ID: <20080131133235.GD8499@elte.hu>
References: <20080129164019.GA2060@tv-sign.ru> <20080129150209.663538cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129150209.663538cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> On Tue, 29 Jan 2008 19:40:19 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply 
> > rcu_read_lock(),
> 
> I'm suspecting that we have other code which assumes that read_lock, 
> write_lock and spin_lock imply rcu_read_lock().
> 
> I wonder if there are any sane runtime checks we can put in there to 
> find such problems.

we usually caught them via the DEBUG_PREEMPT checks on PREEMPT_RT: stuff 
that has such implicit reliance tends to use smp_processor_id() along 
the way and that gets flagged if the non-preemptability guarantee of 
spin_lock() vanishes.

	Ingo
