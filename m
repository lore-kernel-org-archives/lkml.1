Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbZAVHRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbZAVHRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 02:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZAVHRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 02:17:10 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40022 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929AbZAVHRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 02:17:08 -0500
Date: Wed, 21 Jan 2009 23:17:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove duplicate CONFIG_RCU_CPU_STALL_DETECTOR
Message-ID: <20090122071705.GC6290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4977CFFE.2020405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4977CFFE.2020405@cn.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 09:46:38AM +0800, Lai Jiangshan wrote:
> 
> Impact: remove the old CONFIG_RCU_CPU_STALL_DETECTOR
> 
> tree_rcu introduce CONFIG_RCU_CPU_STALL_DETECTOR again.
> 
> These two are the same exactly except:
> the old one "depends on CLASSIC_RCU"
> the new one "depends on CLASSIC_RCU || TREE_RCU"
> 
> This patch remove the old one.

Good eyes!

However, Jiri Kosina has already queued this up for the trivial tree:

	http://lkml.org/lkml/2009/1/15/218

						Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4c9ae60..e770e85 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -633,19 +633,6 @@ config RCU_TORTURE_TEST_RUNNABLE
> 
>  config RCU_CPU_STALL_DETECTOR
>  	bool "Check for stalled CPUs delaying RCU grace periods"
> -	depends on CLASSIC_RCU
> -	default n
> -	help
> -	  This option causes RCU to printk information on which
> -	  CPUs are delaying the current grace period, but only when
> -	  the grace period extends for excessive time periods.
> -
> -	  Say Y if you want RCU to perform such checks.
> -
> -	  Say N if you are unsure.
> -
> -config RCU_CPU_STALL_DETECTOR
> -	bool "Check for stalled CPUs delaying RCU grace periods"
>  	depends on CLASSIC_RCU || TREE_RCU
>  	default n
>  	help
> 
> 
