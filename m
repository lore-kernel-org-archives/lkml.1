Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940Ab0AEG1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0AEG1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255Ab0AEG1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:27:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:35558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0AEG1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:27:30 -0500
Message-ID: <4B42DCF7.9040609@kernel.org>
Date: Tue, 05 Jan 2010 15:32:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V9 5/7] this_cpu_ops: page allocator conversion
References: <20100104223439.228028923@quilx.com> <20100104223556.613041583@quilx.com>
In-Reply-To: <20100104223556.613041583@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 07:34 AM, Christoph Lameter wrote:
>  static int __cpuinit pageset_cpuup_callback(struct notifier_block *nfb,
>  		unsigned long action,
>  		void *hcpu)
>  {
>  	int cpu = (long)hcpu;
> -	int ret = NOTIFY_OK;
>  
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> -		if (process_zones(cpu))
> -			ret = NOTIFY_BAD;
> -		break;
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> -		free_zone_pagesets(cpu);
> +		node_set_state(cpu_to_node(cpu), N_CPU);
>  		break;
>  	default:
>  		break;

The above chunk causes build failure due to removed ret used later on
return statement.  Changed it to return NOTIFY_OK.

Thanks.

-- 
tejun
