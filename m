Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZLUHpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZLUHpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 02:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZLUHpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 02:45:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:59425 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbZLUHpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 02:45:15 -0500
Message-ID: <4B2F2820.5030904@kernel.org>
Date: Mon, 21 Dec 2009 16:47:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [this_cpu_xx V8 07/16] Module handling: Use this_cpu_xx to dynamically
 allocate counters
References: <20091218222617.384355422@quilx.com> <20091218222651.319887863@quilx.com>
In-Reply-To: <20091218222651.319887863@quilx.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/19/2009 07:26 AM, Christoph Lameter wrote:
> Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
> requirements, cache footprint and decreases cycle counts.
> 
> The this_cpu_xx operations are also used for !SMP mode. Otherwise we could
> not drop the use of __module_ref_addr() which would make per cpu data handling
> complicated. this_cpu_xx operations have their own fallback for !SMP.
> 
> The last hold out of users of local_t is the tracing ringbuffer after this patch
> has been applied.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Please keep Rusty Russell cc'd on module changes.

> Index: linux-2.6/kernel/trace/ring_buffer.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/ring_buffer.c	2009-12-18 13:13:24.000000000 -0600
> +++ linux-2.6/kernel/trace/ring_buffer.c	2009-12-18 14:15:57.000000000 -0600
> @@ -12,6 +12,7 @@
>  #include <linux/hardirq.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/module.h>
> +#include <asm/local.h>

This doesn't belong to this patch, right?  I stripped this part out,
added Cc: to Rusty and applied 1, 2, 7 and 8 to percpu branch.  I'll
post the updated patch here.

Thanks.

-- 
tejun
