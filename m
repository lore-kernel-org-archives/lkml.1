Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYLHP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYLHP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYLHP1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:27:46 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:62148 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYLHP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:27:46 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [BUG] idle_balance() does not call load_balance_newidle()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20081208152249.GI5457@dirshya.in.ibm.com>
References: <20081208152249.GI5457@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Mon, 08 Dec 2008 16:27:31 +0100
Message-Id: <1228750051.6939.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-08 at 20:52 +0530, Vaidyanathan Srinivasan wrote:
> Hi,
> 
> load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is
> set at higher level domain (3-CPU) and not in low level domain (2-MC).
> 
> pulled_task is initialised to -1 and checked for non-zero which is
> always true if the lowest level sched_domain does not have
> SD_BALANCE_NEWIDLE flag set.
> 
> Trivial fix to initialise pulled_task to zero.
> Patch against 2.6.28-rc7
> 
> Thanks,
> Vaidy
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

Seems sane

> ---
> 
>  kernel/sched.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index f79c7c4..4abdce1 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3801,7 +3801,7 @@ out_balanced:
>  static void idle_balance(int this_cpu, struct rq *this_rq)
>  {
>  	struct sched_domain *sd;
> -	int pulled_task = -1;
> +	int pulled_task = 0;
>  	unsigned long next_balance = jiffies + HZ;
>  	cpumask_t tmpmask;
>  

