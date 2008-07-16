Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYGPLRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYGPLRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYGPLRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:17:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59088 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752036AbYGPLRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:17:16 -0400
Date: Wed, 16 Jul 2008 06:17:15 -0500
From: Dean Nelson <dcn@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cpumask: Optimize cpumask_of_cpu in drivers/misc/sgi-xp/xpc_main.c
Message-ID: <20080716111715.GA15671@sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com> <20080715211430.040646000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715211430.040646000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:14:33PM -0700, Mike Travis wrote:
>   * Optimize various places where a pointer to the cpumask_of_cpu value
>     will result in reducing stack pressure.
> 
> Based on linux-2.6.tip/master at the following commit:
> 
>     commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
>     Merge: 9a635fa... 724dce0...
>     Author: Ingo Molnar <mingo@elte.hu>
>     Date:   Tue Jul 15 14:55:17 2008 +0200
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Dean Nelson <dcn@sgi.com>
> ---
>  drivers/misc/sgi-xp/xpc_main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.tip.orig/drivers/misc/sgi-xp/xpc_main.c
> +++ linux-2.6.tip/drivers/misc/sgi-xp/xpc_main.c
> @@ -229,10 +229,11 @@ xpc_hb_checker(void *ignore)
>  	int last_IRQ_count = 0;
>  	int new_IRQ_count;
>  	int force_IRQ = 0;
> +	cpumask_of_cpu_ptr(cpumask, XPC_HB_CHECK_CPU);
>  
>  	/* this thread was marked active by xpc_hb_init() */
>  
> -	set_cpus_allowed(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
> +	set_cpus_allowed_ptr(current, cpumask);
>  
>  	/* set our heartbeating to other partitions into motion */
>  	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
> 

Acked-by: Dean Nelson <dcn@sgi.com>

