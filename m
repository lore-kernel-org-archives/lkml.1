Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZGaXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZGaXSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbZGaXSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 19:18:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51704 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZGaXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 19:18:34 -0400
Message-ID: <4A737BC8.7080205@us.ibm.com>
Date: Fri, 31 Jul 2009 16:18:32 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] futex: futex_wait_requeue_pi commentary corrections
References: <4A737261.20601@us.ibm.com>
In-Reply-To: <4A737261.20601@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> futex: futex_wait_requeue_pi commentary corrections
> 
> From: Darren Hart <dvhltc@us.ibm.com>
> 
> The state machine described in the comments wasn't updated with a follow-on
> fix.  Address that and cleanup the corresponding commentary in the 
> function.
> 
> Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
> kernel/futex.c |   23 ++++++++++-------------
> 1 files changed, 10 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 0672ff8..18752ae 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2102,11 +2102,11 @@ int handle_early_requeue_pi_wakeup(struct 
> futex_hash_bucket *hb,
>  * We call schedule in futex_wait_queue_me() when we enqueue and return 
> there
>  * via the following:
>  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
> - * 2) wakeup on uaddr2 after a requeue and subsequent unlock
> - * 3) signal (before or after requeue)
> - * 4) timeout (before or after requeue)
> + * 2) wakeup on uaddr2 after a requeue
> + * 3) signal
> + * 4) timeout
>  *
> - * If 3, we setup a restart_block with futex_wait_requeue_pi() as the 
> function.
> + * If 3, we setup a restart_block and return -ERESTARTNOINTR.

Gah, not we don't.  We removed the restart block altogether.  Sorry.  V2 
en route.

Nacked-by: Darren Hart <dvhltc@us.ibm.com>

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
