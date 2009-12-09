Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbZLIWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbZLIWeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbZLIWeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:34:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:56942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbZLIWeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:34:17 -0500
Subject: Re: [PATCH] avoid out of bounds array reference in save_trace()
From: Peter Zijlstra <peterz@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: mingo@elte.hu, luming.yu@intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
References: <4b2024d085302c2a2@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 23:34:18 +0100
Message-ID: <1260398058.5489.1623.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 14:29 -0800, Luck, Tony wrote:
> ia64 found this the hard way (because we currently have a stub for
> save_stack_trace() that does nothing). But it would be a good idea to 
> be cautious in case a real save_stack_trace() bailed out with an
> error before it set trace->nr_entries.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Thanks Tony,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 03c06af..429540c 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -387,7 +387,8 @@ static int save_trace(struct stack_trace *trace)
>  	 * complete trace that maxes out the entries provided will be reported
>  	 * as incomplete, friggin useless </rant>
>  	 */
> -	if (trace->entries[trace->nr_entries-1] == ULONG_MAX)
> +	if (trace->nr_entries != 0 &&
> +	    trace->entries[trace->nr_entries-1] == ULONG_MAX)
>  		trace->nr_entries--;
>  
>  	trace->max_entries = trace->nr_entries;


