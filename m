Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYGWO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYGWO0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYGWO0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:26:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39858 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbYGWO0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:26:46 -0400
Message-ID: <48873FA0.50504@sgi.com>
Date: Wed, 23 Jul 2008 07:26:40 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Dave Jones <davej@codemonkey.org.uk>,
       Paul Jackson <pj@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Robert Richter <robert.richter@amd.com>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/8] cpumask: Replace cpumask_of_cpu with	cpumask_of_cpu_ptr
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <200807181530.10044.rusty@rustcorp.com.au> <48809DEB.5060104@sgi.com> <200807202003.31526.rusty@rustcorp.com.au> <20080723112042.GA16420@elte.hu> <20080723112309.GA30519@elte.hu>
In-Reply-To: <20080723112309.GA30519@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>> The simple version is just a static array of [NR_CPUS] cpumask_t's.  
>>> Do that, with an override for smarter archs?
>>>
>>> I really REALLY prefer that over the fairly tortuous macros.
>> a fresh commit in -git has exposed the topology.h mess - see the hack 
>> below. We now have diverging versions of topology_core_siblings() 
>> semantics - that sure cannot be right. Mike?
> 
> also i had to do the net/sunrpc/svc.c fixup below.
> 
> 	Ingo
> 
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index 5a32cb7..835d274 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -310,7 +310,8 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
>  	switch (m->mode) {
>  	case SVC_POOL_PERCPU:
>  	{
> -		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
> +		cpumask_of_cpu_ptr(cpumask, node);
> +		set_cpus_allowed_ptr(task, cpumask);
>  		break;
>  	}
>  	case SVC_POOL_PERNODE:


I had sent in a patch that has this change.

Standby, the "generic" cpumask_of_cpu_map patch is coming... just testing now.

THanks,
Mike
