Return-Path: <linux-kernel-owner+w=401wt.eu-S1763711AbZANQOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763711AbZANQOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbZANQOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:14:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60652 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbZANQOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:14:30 -0500
Date: Wed, 14 Jan 2009 08:14:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: add __cpuinit to rcu_init_percpu_data()
Message-ID: <20090114161428.GB6734@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <496D8D07.5080108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496D8D07.5080108@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:58:15PM +0800, Lai Jiangshan wrote:
> 
> Impact: rcu_init_percpu_data() is not use after boot when !CONFIG_HOTPLUG_CPU
> 
> add __cpuinit to rcu_init_percpu_data(), and this function's text
> will be discarded after boot when !CONFIG_HOTPLUG_CPU.

Good catch!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index 490934f..bd5a900 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -716,7 +716,7 @@ void rcu_check_callbacks(int cpu, int user)
>  	raise_rcu_softirq();
>  }
> 
> -static void rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
> +static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
>  						struct rcu_data *rdp)
>  {
>  	unsigned long flags;
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index f2d8638..b2fd602 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1314,7 +1314,7 @@ int rcu_needs_cpu(int cpu)
>   * access due to the fact that this CPU cannot possibly have any RCU
>   * callbacks in flight yet.
>   */
> -static void
> +static void __cpuinit
>  rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
>  {
>  	unsigned long flags;
> 
> 
> 
