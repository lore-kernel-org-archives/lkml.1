Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYJCPOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYJCPOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJCPOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:14:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37883 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYJCPOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:14:35 -0400
Date: Fri, 3 Oct 2008 08:14:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       akpm@linux-foundation.org, laijs@cn.fujitsu.com,
       manfred@colorfullife.com, dipankar@in.ibm.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, josht@linux.vnet.ibm.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: [PATCH] rcu: RCU-based detection of stalled CPUs for Classic
	RCU, fix
Message-ID: <20081003151431.GC6246@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081002003628.GA7877@linux.vnet.ibm.com> <20081002080726.GB17695@elte.hu> <20081002140507.GB6729@linux.vnet.ibm.com> <20081002151046.GB2473@Krystal> <20081002174318.GB7324@linux.vnet.ibm.com> <20081002185115.GA11047@Krystal> <20081002225537.GA6706@linux.vnet.ibm.com> <20081002230639.GA7522@linux.vnet.ibm.com> <20081003083947.GB7636@elte.hu> <20081003084233.GA15637@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003084233.GA15637@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 10:42:33AM +0200, Ingo Molnar wrote:
> 
> -tip testing found a minor build bug - find the fix below.
> 
> 	Ingo
> 
> -------------------->
> >From 2ec2b482b10a1ed3493c224f1893cddd3d33833b Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 3 Oct 2008 10:41:00 +0200
> Subject: [PATCH] rcu: RCU-based detection of stalled CPUs for Classic RCU, fix
> 
> fix the !CONFIG_RCU_CPU_STALL_DETECTOR path:
> 
>  kernel/rcuclassic.c: In function '__rcu_pending':
>  kernel/rcuclassic.c:609: error: too few arguments to function 'check_cpu_stall'
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/rcuclassic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 0d07e6e..37f72e5 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -239,7 +239,7 @@ static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
>  {
>  }
> 
> -static void check_cpu_stall(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
> +static inline void check_cpu_stall(struct rcu_ctrlblk *rcp)
>  {
>  }

I should have learned by now to test with all relevant config parameter
combinations...  My apologies for the hassle!!!

							Thanx, Paul
