Return-Path: <linux-kernel-owner+w=401wt.eu-S939232AbXGUPUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939232AbXGUPUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939863AbXGUPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:07:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861AbXGUPHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:07:33 -0400
Date: Sat, 21 Jul 2007 17:05:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@mandriva.com>
Subject: Re: [PATCH] pi-futex: set PF_EXITING without taking ->pi_lock
Message-ID: <20070721150547.GA23560@elte.hu>
References: <20070721115712.GA871@tv-sign.ru> <20070721123159.GB1769@elte.hu> <20070721141814.GA1013@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070721141814.GA1013@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> 	static inline void ccids_read_lock(void)
> 	{
> 		atomic_inc(&ccids_lockct);
> 		spin_unlock_wait(&ccids_lock);
> 	}
> 
> This looks racy, in theory atomic_inc() and spin_unlock_wait() could 
> be re-ordered. However, in this particular case we have an "optimized" 
> smp_mb_after_atomic_inc(), perhaps it is good that the caller can 
> choose the "right" barrier by hand.

_all_ default locking and atomic APIs should be barrier-safe i believe. 
(and that includes atomic_inc() too) Most people dont have barriers on 
their mind when their code. _If_ someone is barrier-conscious then we 
should have barrier-less APIs too for that purpose of squeezing the last 
half cycle out of the code, but it should be a non-default choice. The 
reason: nobody notices an unnecessary barrier, but a missing barrier can 
be nasty.

	Ingo
