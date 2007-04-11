Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbXDKNPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbXDKNPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXDKNPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:15:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:44656 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbXDKNPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:15:38 -0400
Date: Wed, 11 Apr 2007 17:15:24 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
Message-ID: <20070411131524.GA284@tv-sign.ru>
References: <20070410185133.GA104@tv-sign.ru> <m13b37v517.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m13b37v517.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Eric W. Biederman wrote:
> 
>  static int kthread(void *_create)
>  {
>  	struct kthread_create_info *create = _create;
>  	int (*threadfn)(void *data);
>  	void *data;
> -	sigset_t blocked;
>  	int ret = -EINTR;
>  
> -	kthread_exit_files();
> -
> -	/* Copy data: it's on keventd's stack */
> +	/* Copy data: it's on kthread's stack */
>  	threadfn = create->threadfn;
>  	data = create->data;
>  
> -	/* Block and flush all signals (in case we're not from keventd). */
> -	sigfillset(&blocked);
> -	sigprocmask(SIG_BLOCK, &blocked, NULL);
> -	flush_signals(current);
> -
> -	/* By default we can run anywhere, unlike keventd. */
> -	set_cpus_allowed(current, CPU_MASK_ALL);

The above is OK, but I believe you should add set_cpus_allowed() to
kthreadd_setup(). Note that kthreadd() is forked after init_idle().

Oleg.

