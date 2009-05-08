Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbZEHE4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbZEHE4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbZEHE4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:56:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757314AbZEHE4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:56:05 -0400
Date: Thu, 7 May 2009 21:54:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/4] ring-buffer: change WARN_ON from checking
 preempt_count to preemptible
Message-Id: <20090507215427.4256cc3c.akpm@linux-foundation.org>
In-Reply-To: <20090508043331.726786617@goodmis.org>
References: <20090508043250.372421144@goodmis.org>
	<20090508043331.726786617@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 May 2009 00:32:54 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> There's a WARN_ON in the ring buffer code that makes sure preemption
> is disabled. It checks "!preempt_count()". But when CONFIG_PREEMPT is not
> enabled, preempt_count() is always zero, and this will trigger the warning.
> 
> [ Impact: prevent false warning on non preemptible kernels ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ring_buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 3ae5ccf..3611706 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1688,7 +1688,7 @@ void ring_buffer_discard_commit(struct ring_buffer *buffer,
>  	 * committed yet. Thus we can assume that preemption
>  	 * is still disabled.
>  	 */
> -	RB_WARN_ON(buffer, !preempt_count());
> +	RB_WARN_ON(buffer, preemptible());
>  
>  	cpu = smp_processor_id();
>  	cpu_buffer = buffer->buffers[cpu];

smp_processor_id() will warn too.
