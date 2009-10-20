Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZJTOSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZJTOSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZJTOSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:18:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZJTOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:18:03 -0400
Message-ID: <4ADDC69A.5000701@suse.com>
Date: Tue, 20 Oct 2009 10:18:02 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-1.1 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: Commit 34d76c41 causes linker errors on ia64 with NR_CPUS=4096
References: <4ADB967A.4080707@suse.com> <alpine.LRH.2.00.0910200356340.20992@twin.jikos.cz> <alpine.LRH.2.00.0910200651510.20992@twin.jikos.cz> <4ADD48D1.1040701@kernel.org> <alpine.LSU.2.00.0910200756300.8582@wotan.suse.de> <4ADD54D4.70808@kernel.org> <4ADD5530.3050107@kernel.org> <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910200826220.8582@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2009 02:27 AM, Jiri Kosina wrote:
> @@ -1627,11 +1623,10 @@ static int tg_shares_up(struct task_group *tg, void *data)
>  		return 0;
>  
>  	local_irq_save(flags);
> -	usd = &__get_cpu_var(update_shares_data);
>  
>  	for_each_cpu(i, sched_domain_span(sd)) {
>  		weight = tg->cfs_rq[i]->load.weight;
> -		usd->rq_weight[i] = weight;
> +		usd = *per_cpu_ptr(update_shares_data, i) = weight;
>  
>  		/*
>  		 * If there are currently no tasks on the cpu pretend there

I don't think this is what you want here.

In the original version, usd is the percpu var using the current cpu. In
your version, usd is the percpu var using i instead of the current cpu.

I'll post my version of the patch shortly. I don't think keeping most of
the original version is a bad thing. We can just allocate it dynamically
instead.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
