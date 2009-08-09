Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZHIU45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZHIU45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZHIU45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:56:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57948 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbZHIU44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:56:56 -0400
Date: Sun, 9 Aug 2009 22:56:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, dvhltc@us.ibm.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, johnstul@us.ibm.com,
       peterz@infradead.org, dino@in.ibm.com, rostedt@goodmis.org,
       stable@kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] futex: Update woken requeued futex_q lock_ptr
Message-ID: <20090809205611.GA23276@elte.hu>
References: <4A7A016C.1090002@us.ibm.com> <tip-4047446de8fa83d8d5922e9448eb0cbb7ac3f475@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-4047446de8fa83d8d5922e9448eb0cbb7ac3f475@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Darren Hart <dvhltc@us.ibm.com> wrote:

> @@ -1030,6 +1034,11 @@ void requeue_pi_wake_futex(struct futex_q *q, union futex_key *key)
>  	WARN_ON(!q->rt_waiter);
>  	q->rt_waiter = NULL;
>  
> +	q->lock_ptr = &hb->lock;
> +#ifdef CONFIG_DEBUG_PI_LIST
> +	q->list.plist.slock = &hb->lock;
> +#endif
> +
>  	wake_up_state(q->task, TASK_NORMAL);
>  }
>  

-tip testing found a build error with v2 of the patch:

kernel/futex.c: In function ‘requeue_pi_wake_futex’:
kernel/futex.c:1039: error: ‘struct plist_head’ has no member named ‘slock’

	Ingo
