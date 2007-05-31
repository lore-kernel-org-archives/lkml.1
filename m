Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbXEaOZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbXEaOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbXEaOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:25:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49206 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbXEaOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:25:50 -0400
Date: Thu, 31 May 2007 16:24:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause application deadlock
Message-ID: <20070531142455.GA11310@elte.hu>
References: <1180572567.6126.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180572567.6126.44.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> 	So we've been seeing PI mutex deadlocks with a few of our 
> applications using the -rt kernel. After narrowing things down, we 
> were finding that the applications were indirectly calling 
> futex_unlock_pi(), which on occasion would return -EFAULT, which is 
> promptly ignored by glibc. This would cause the application to 
> continue on as if it has unlocked the mutex, until it tried to 
> reacquire it and deadlock.

> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2011,6 +2011,7 @@ pi_faulted:
>  					 attempt);
>  		if (ret)
>  			goto out_unlock;
> +		uval = 0;
>  		goto retry_locked;

this looks good to me. Oleg has posted a few more fixes as well - have 
you tried those too?

	Ingo
