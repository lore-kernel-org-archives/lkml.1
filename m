Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZCXCoL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 23 Mar 2009 22:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZCXCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 22:43:53 -0400
Received: from f153.mail.ru ([194.67.57.29]:55341 "EHLO f153.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbZCXCnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 22:43:52 -0400
X-Greylist: delayed 102941 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2009 22:43:52 EDT
From: Peter Lojkin <ia6432@inbox.ru>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
   Peter Zijlstra <peterz@infradead.org>, rjw@sisk.pl
Subject: =?koi8-r?Q?Re=3A_2.6.28,_limiting_cpu_time_doesn't_work?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: unknown via proxy [83.167.111.116]
Date: Tue, 24 Mar 2009 05:43:47 +0300
References: <20090322231111.GA21775@redhat.com>
In-Reply-To: <20090322231111.GA21775@redhat.com>
Reply-To: Peter Lojkin <ia6432@inbox.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LlwcF-0000PC-00.ia6432-inbox-ru@f153.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:

> I am not sure what should we do, this needs more discussion.
> 
> Probably the most simple patch for -stable and 2.6.29 is below.
> (with this patch we don't even need update_rlimit_cpu(), afaics).

tested on both 2.6.28.9 and 2.6.29 - RLIMIT_CPU works as expected

> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -1263,7 +1263,8 @@ static inline int fastpath_timer_check(s
>  		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
>  			return 1;
>  	}
> -	return 0;
> +
> +	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
>  }
>  
>  /*

