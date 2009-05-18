Return-Path: <linux-kernel-owner+w=401wt.eu-S1755765AbZERHCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbZERHCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbZERHCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:02:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755609AbZERHCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:02:14 -0400
Message-ID: <4A110768.2040707@cn.fujitsu.com>
Date: Mon, 18 May 2009 14:59:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, zbr@ioremap.net,
       jeff.chua.linux@gmail.com, paulus@samba.org, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
References: <20090517191141.GA25915@linux.vnet.ibm.com>
In-Reply-To: <20090517191141.GA25915@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> +void sched_expedited_wake(void *unused)
> +{
> +	mutex_lock(&__get_cpu_var(sched_expedited_done_mutex));
> +	if (__get_cpu_var(sched_expedited_done_qs) ==
> +	    SCHED_EXPEDITED_QS_DONE_QS) {
> +		__get_cpu_var(sched_expedited_done_qs) =
> +			SCHED_EXPEDITED_QS_NEED_QS;
> +		wake_up(&__get_cpu_var(sched_expedited_qs_wq));
> +	}
> +	mutex_unlock(&__get_cpu_var(sched_expedited_done_mutex));
> +}

[...]

> +		get_online_cpus();
> +		preempt_disable();
> +		mycpu = smp_processor_id();
> +		smp_call_function(sched_expedited_wake, NULL, 1);

sched_expedited_wake() calls mutex_lock() which may sleep?

And I think you have re-implement workqueue.

Thanks, Lai.

