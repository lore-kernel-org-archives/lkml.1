Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZLPFiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZLPFiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 00:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZLPFiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 00:38:20 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42891 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbZLPFiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 00:38:19 -0500
Message-ID: <4B287242.5070002@in.ibm.com>
Date: Wed, 16 Dec 2009 11:08:10 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org
Subject: Re: [Next] CPU Hotplug test failures on powerpc
References: <4B2224C7.1020908@in.ibm.com> <1260786122.4165.142.camel@twins> <4B261D7A.9040802@in.ibm.com>  <1260793182.4165.223.camel@twins> <1260825420.2217.40.camel@pasglop>  <4B275A6B.9030200@in.ibm.com> <1260873827.4165.362.camel@twins>  <4B279370.5050800@in.ibm.com> <1260889402.4165.434.camel@twins>
In-Reply-To: <1260889402.4165.434.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Could you try the below?
>   
No luck. Still the same issue. The mask values don't change.

Thanks
-Sachin

> ---
>  init/main.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 4051d75..4be7de2 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -369,12 +369,6 @@ static void __init smp_init(void)
>  {
>  	unsigned int cpu;
>  
> -	/*
> -	 * Set up the current CPU as possible to migrate to.
> -	 * The other ones will be done by cpu_up/cpu_down()
> -	 */
> -	set_cpu_active(smp_processor_id(), true);
> -
>  	/* FIXME: This should be done in userspace --RR */
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= setup_max_cpus)
> @@ -486,6 +480,7 @@ static void __init boot_cpu_init(void)
>  	int cpu = smp_processor_id();
>  	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
>  	set_cpu_online(cpu, true);
> +	set_cpu_active(cpu, true);
>  	set_cpu_present(cpu, true);
>  	set_cpu_possible(cpu, true);
>  }
>
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

