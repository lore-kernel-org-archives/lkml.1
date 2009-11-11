Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZKKMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZKKMN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757447AbZKKMN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:13:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbZKKMNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:13:25 -0500
Date: Wed, 11 Nov 2009 13:11:51 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime()
Message-ID: <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com>
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com> <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop> <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF8FE76.406@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hidetoshi 

On Tue, Nov 10, 2009 at 02:47:34PM +0900, Hidetoshi Seto wrote:
> Remove casting to clock_t from task_u/stime(), and keep granularity of
> cputime_t over the calculation.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  kernel/sched.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 28dd4f4..1632e82 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5171,41 +5171,44 @@ cputime_t task_stime(struct task_struct *p)
>  	return p->stime;
>  }
>  #else
> +
> +#ifndef nsecs_to_cputime
> +# define nsecs_to_cputime(__nsecs) msecs_to_cputime((__nsecs) / NSEC_PER_MSEC)
> +#endif
> +

I would like to test, but unfortunately with the patch kernel not build
on my system:

kernel/built-in.o: In function `task_utime':
/usr/src/rhel5/linux-2.6/kernel/sched.c:5187: undefined reference to
`__udivdi3'
kernel/built-in.o: In function `task_stime':
/usr/src/rhel5/linux-2.6/kernel/sched.c:5208: undefined reference to
`__udivdi3'
make: *** [.tmp_vmlinux1] Error 1

Cheers
Stanislaw
