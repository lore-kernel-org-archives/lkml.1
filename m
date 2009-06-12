Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbZFLHsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbZFLHsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZFLHsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:48:25 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:47529 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbZFLHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:48:24 -0400
Message-ID: <4A320848.6000701@rsk.demon.co.uk>
Date: Fri, 12 Jun 2009 08:48:24 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] posix-cpu-timers: remove tasklist_lock where we can
References: <20090612084927.11673956@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20090612084927.11673956@dhcp-lab-109.englab.brq.redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka wrote:
> tasklist_lock is not needed to protect find_task_by_vpid() nor
> thread_group_leader() nor same_thread_group() , use rcu_read_lock() instead.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  kernel/posix-cpu-timers.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
> index bece7c0..1d9cdf3 100644
> --- a/kernel/posix-cpu-timers.c
> +++ b/kernel/posix-cpu-timers.c
> @@ -37,13 +37,13 @@ static int check_clock(const clockid_t which_clock)
>  	if (pid == 0)
>  		return 0;
>  
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
>  		   same_thread_group(p, current) : thread_group_leader(p))) {
>  		error = -EINVAL;
>  	}
> -	read_unlock(&tasklist_lock);
> +	rcu_read_lock();
>  
Did you really intend to replace an unlock with a lock?

regards
Richard
