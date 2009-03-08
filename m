Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZCHNfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZCHNfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 09:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZCHNfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 09:35:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:56230 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751884AbZCHNff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 09:35:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19KuF4d0yhKQAziNlpjOIUvVkRRiT/9BrvvSB6pnj
	S1n6Ny11a0n6Wr
Subject: Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balazs Scheidler <bazsi@balabit.hu>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1236507594.22914.3641.camel@twins>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net>
	 <1236507594.22914.3641.camel@twins>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 14:35:30 +0100
Message-Id: <1236519330.5933.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 11:19 +0100, Peter Zijlstra wrote:

> Wouldn't something like the below be more suited:
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 89e2ca0..94c8b02 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2501,7 +2501,7 @@ static void __sched_fork(struct task_struct *p)
>  	p->se.prev_sum_exec_runtime	= 0;
>  	p->se.nr_migrations		= 0;
>  	p->se.last_wakeup		= 0;
> -	p->se.avg_overlap		= 0;
> +	p->se.avg_overlap		= sysctl_sched_migration_cost;
>  	p->se.start_runtime		= 0;
>  	p->se.avg_wakeup		= sysctl_sched_wakeup_granularity;
>  

Dunno exactly what we need to do here.  My hacklet certainly ain't it,
but I suspect this isn't going to work out either.  Having tasks begin
life at zero or sysctl_sched_migration_cost won't matter much methinks.

	-Mike

