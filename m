Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbYKQP5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbYKQP5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYKQP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:57:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58015 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYKQP5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:57:36 -0500
Date: Mon, 17 Nov 2008 16:57:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Doug Chapman <doug.chapman@hp.com>,
       Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/3] thread_group_cputime: move a couple of callsites
	outside of ->siglock
Message-ID: <20081117155706.GC12081@elte.hu>
References: <20081117144008.GA5386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117144008.GA5386@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> ->siglock buys nothing for thread_group_cputime() in do_sys_times() and
> wait_task_zombie() (which btw takes the unrelated parent's ->siglock).
> Actually I think do_sys_times() doesn't need ->siglock at all.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

applied your changes to tip/core/signal:

2b5fe6d: thread_group_cputime: move a couple of callsites outside of ->siglock
ce39447: thread_group_cputime: kill the bogus ->signal != NULL check
74fcd52: account_steal_time: kill the unneeded account_group_system_time()

(merged the sched/urgent fixlet before them)

thanks Oleg!

	Ingo
