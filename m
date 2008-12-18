Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752687AbYLRKo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYLRKo3 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYLRKoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:44:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYLRKoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:44:18 -0500
Date: Thu, 18 Dec 2008 11:44:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: "lkml," <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>, Nick Piggin <npiggin@suse.de>
Subject: Re: Update futex_q to clarify single waiter symmantics
Message-ID: <20081218104408.GA14332@elte.hu>
References: <4949A794.8000502@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4949A794.8000502@us.ibm.com>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> From: Darren Hart <dvhltc@us.ibm.com>
>
> I've tripped over this a couple times.  The futex_q uses a waiters list
> to represent a single blocked task and then calles wake_up_all().  This
> can lead to confusion in trying to understand the intent of the code,
> which is to have a single futex_q for every task waiting on a futex.
> This patch corrects the problem, using a single pointer to the waiting
> task, and an appropriate call to wake_up, rather than wake_up_all.
>
> Compile and boot tested on an 8way x86_64 machine.
>
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> ---
>
> kernel/futex.c |   11 ++++++-----
> 1 files changed, 6 insertions(+), 5 deletions(-)

applied to tip/core/futexes, thanks Darren!

> -	wake_up_all(&q->waiters);
> +	wake_up(&q->waiter);

yeah, the naming and the wake_up_all is a relic from the FUTEX_FD days - 
but we removed that earlier this year:

| commit 82af7aca56c67061420d618cc5a30f0fd4106b80
| Author: Eric Sesterhenn <snakebyte@gmx.de>
| Date:   Fri Jan 25 10:40:46 2008 +0100
|
|     Removal of FUTEX_FD

	Ingo
