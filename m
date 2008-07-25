Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbYGYFqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbYGYFqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYGYFqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:46:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:41355 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750729AbYGYFqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:46:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+r7CQ0dvGrbAb/nooAI8pKzDRn66XJBuS1XCAeI/
	1qG1x3Ny40bfGc
Subject: Re: [oops] sysdev: Pass the attribute to the low level sysdev
	show/store function
From: Mike Galbraith <efault@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080724202711.GI20882@one.firstfloor.org>
References: <1216898844.5564.7.camel@marge.simson.net>
	 <20080724202711.GI20882@one.firstfloor.org>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 07:45:57 +0200
Message-Id: <1216964757.5601.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 22:27 +0200, Andi Kleen wrote:
> On Thu, Jul 24, 2008 at 01:27:24PM +0200, Mike Galbraith wrote:
> > Greetings,
> > 
> > Oops below bisects to..
> 
> This patch should fix it.

Confirmed, and thanks.

	-Mike

> 
> -Andi
> 
> 
> commit a2ab909933f8c8623282979dfa64f3e358bdb9fc
> Author: Andi Kleen <ak@gargoyle.(none)>
> Date:   Thu Jul 24 21:57:40 2008 +0200
> 
>     Make scheduler sysfs attributes sysdev class devices
>     
>     They are really class devices, but were incorrectly declared. This leads
>     to crashes with the recent changes that makes non normal sysdevs
>     use a different prototype.
>     
>     Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6acf749..24358ca 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7641,34 +7641,34 @@ static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
>  }
>  
>  #ifdef CONFIG_SCHED_MC
> -static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
> -				struct sysdev_attribute *attr, char *page)
> +static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
> +					   char *page)
>  {
>  	return sprintf(page, "%u\n", sched_mc_power_savings);
>  }
> -static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
> -					    struct sysdev_attribute *attr,
> +static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
>  					    const char *buf, size_t count)
>  {
>  	return sched_power_savings_store(buf, count, 0);
>  }
> -static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
> -		   sched_mc_power_savings_store);
> +static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644, 
> +			 sched_mc_power_savings_show,
> +		         sched_mc_power_savings_store);
>  #endif
>  
>  #ifdef CONFIG_SCHED_SMT
> -static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
> -				struct sysdev_attribute *attr, char *page)
> +static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
> +					    char *page)
>  {
>  	return sprintf(page, "%u\n", sched_smt_power_savings);
>  }
> -static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
> -					     struct sysdev_attribute *attr,
> +static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
>  					     const char *buf, size_t count)
>  {
>  	return sched_power_savings_store(buf, count, 1);
>  }
> -static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
> +static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644, 
> +		   sched_smt_power_savings_show,
>  		   sched_smt_power_savings_store);
>  #endif
>  

