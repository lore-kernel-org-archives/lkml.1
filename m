Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYL2Phz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYL2Phz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYL2Phr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:37:47 -0500
Received: from relay3.sgi.com ([192.48.171.31]:57237 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751428AbYL2Phr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:37:47 -0500
Date: Mon, 29 Dec 2008 09:37:44 -0600
From: Dean Nelson <dcn@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 7/8] cpumask: convert misc driver functions
Message-ID: <20081229153744.GA6512@sgi.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.672392000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219160145.672392000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 08:01:51AM -0800, Mike Travis wrote:
> Impact: Reduce stack usage, use new cpumask API.
> 
> Convert misc driver functions to use struct cpumask.
> 
> To Do:
>   - Convert iucv_buffer_cpumask to cpumask_var_t.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Mike Travis <travis@sgi.com>

[...]

> --- linux-2.6-for-ingo.orig/drivers/misc/sgi-xp/xpc_main.c
> +++ linux-2.6-for-ingo/drivers/misc/sgi-xp/xpc_main.c
> @@ -318,7 +318,7 @@ xpc_hb_checker(void *ignore)
>  
>  	/* this thread was marked active by xpc_hb_init() */
>  
> -	set_cpus_allowed_ptr(current, &cpumask_of_cpu(XPC_HB_CHECK_CPU));
> +	set_cpus_allowed_ptr(current, cpumask_of(XPC_HB_CHECK_CPU));
>  
>  	/* set our heartbeating to other partitions into motion */
>  	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);

Acked-by: Dean Nelson <dcn@sgi.com>

