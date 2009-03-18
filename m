Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZCRR5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZCRR5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756258AbZCRR5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:57:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:47216 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101AbZCRR5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:57:35 -0400
Subject: Re: [tip:tracing/ftrace] tracing: fix oops in
 tracepoint_update_probe_range()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org>
References: <1237394936.3132.1.camel@localhost.localdomain>
	 <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 23:26:37 +0530
Message-Id: <1237398997.22438.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 17:51 +0000, Jaswinder Singh Rajput wrote:
> Commit-ID:  966a6fdf6210e3ac8ce00b61cd1107cdf97ce744
> Gitweb:     http://git.kernel.org/tip/966a6fdf6210e3ac8ce00b61cd1107cdf97ce744
> Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> AuthorDate: Wed, 18 Mar 2009 22:18:56 +0530
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 18 Mar 2009 18:48:43 +0100
> 
> tracing: fix oops in tracepoint_update_probe_range()
> 
> Change this crash:
> 
>  BUG: unable to handle kernel NULL pointer dereference at (null)
>  IP: [<ffffffff8107d4de>] tracepoint_update_probe_range+0x1f/0x9b
>  PGD 13d5fb067 PUD 13d688067 PMD 0
>  Oops: 0000 [#1] SMP
> 
> To a more debuggable WARN_ONCE().
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <1237394936.3132.1.camel@localhost.localdomain>
> [ moved the check outside the lock and added a WARN_ON(). ]
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/tracepoint.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> index 7960274..dd15df9 100644
> --- a/kernel/tracepoint.c
> +++ b/kernel/tracepoint.c
> @@ -272,12 +272,17 @@ static void disable_tracepoint(struct tracepoint *elem)
>   *
>   * Updates the probe callback corresponding to a range of tracepoints.
>   */
> -void tracepoint_update_probe_range(struct tracepoint *begin,
> -	struct tracepoint *end)
> +void
> +tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
>  {
>  	struct tracepoint *iter;
>  	struct tracepoint_entry *mark_entry;
>  
> +	if (!iter) {
> +		WARN_ON_ONCE(1);
> +		return;
> +	}
> +
>  	mutex_lock(&tracepoints_mutex);
>  	for (iter = begin; iter < end; iter++) {
>  		mark_entry = get_tracepoint(iter->name);

my original patch was correct.

--
JSR


