Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZBIRDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZBIRDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbZBIRCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:02:53 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:53530 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105AbZBIRCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:02:52 -0500
Date: Mon, 9 Feb 2009 22:32:43 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu hotplug: remove unused cpuhotplug_mutex_lock()
Message-ID: <20090209170243.GE12696@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <498BDB15.6050609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498BDB15.6050609@cn.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

On Fri, Feb 06, 2009 at 02:39:17PM +0800, Lai Jiangshan wrote:
> 
> cpuhotplug_mutex_lock() is not used. this patch remove it.

This should have been long gone with get_online_cpus()/put_online_cpus()
patch series. My bad, I missed it.

Thanks for the patch.
Acked-by: Gautham R Shenoy <ego@in.ibm.com>
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  cpu.h |   16 ----------------
>  1 file changed, 16 deletions(-)
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index c2747ac..2643d84 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -23,7 +23,6 @@
>  #include <linux/node.h>
>  #include <linux/compiler.h>
>  #include <linux/cpumask.h>
> -#include <linux/mutex.h>
> 
>  struct cpu {
>  	int node_id;		/* The node which contains the CPU */
> @@ -103,16 +102,6 @@ extern struct sysdev_class cpu_sysdev_class;
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* Stop CPUs going up and down. */
> 
> -static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
> -{
> -	mutex_lock(cpu_hp_mutex);
> -}
> -
> -static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
> -{
> -	mutex_unlock(cpu_hp_mutex);
> -}
> -
>  extern void get_online_cpus(void);
>  extern void put_online_cpus(void);
>  #define hotcpu_notifier(fn, pri) {				\
> @@ -126,11 +115,6 @@ int cpu_down(unsigned int cpu);
> 
>  #else		/* CONFIG_HOTPLUG_CPU */
> 
> -static inline void cpuhotplug_mutex_lock(struct mutex *cpu_hp_mutex)
> -{ }
> -static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
> -{ }
> -
>  #define get_online_cpus()	do { } while (0)
>  #define put_online_cpus()	do { } while (0)
>  #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> 

-- 
Thanks and Regards
gautham
