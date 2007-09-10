Return-Path: <linux-kernel-owner+w=401wt.eu-S965800AbXIJTgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965800AbXIJTgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965245AbXIJTf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:35:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965125AbXIJTf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:35:56 -0400
Date: Mon, 10 Sep 2007 21:35:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 3/3] futex_compat: update to match native version
Message-ID: <20070910193552.GC4964@elte.hu>
References: <20070910191324.847651727@arndb.de> <20070910191648.868241883@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910191648.868241883@arndb.de>
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


* arnd@arndb.de <arnd@arndb.de> wrote:

> A few changes have gone into the futex code but not into the 
> futex_compat code, the most significant one being a fix for 
> FUTEX_WAKE_OP in commit f54f098612d7f86463b5fb4763d03533d634de73.
> 
> This brings both versions in sync again.

> -	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
> -		val2 = (int) (unsigned long) utime;
> +	/*
> +	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
> +	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
> +	 */
> +	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
> +	    cmd == FUTEX_WAKE_OP)
> +		val2 = (u32) (unsigned long) utime;

thanks.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
