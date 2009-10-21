Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZJUQYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZJUQYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZJUQYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:24:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZJUQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:24:16 -0400
Subject: Re: [PATCH 4/4] tracing: removing cpu arg from rb_time_stamp
 function
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1256135801-1849-5-git-send-email-jolsa@redhat.com>
References: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
	 <1256135801-1849-5-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 12:24:19 -0400
Message-Id: <1256142259.18347.3138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 16:36 +0200, Jiri Olsa wrote:
> The cpu argument is not used inside rb_time_stamp function. Plus typo fix.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  include/linux/trace_seq.h  |    2 +-
>  kernel/trace/ring_buffer.c |   10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> index c134dd1..09077f6 100644
> --- a/include/linux/trace_seq.h
> +++ b/include/linux/trace_seq.h
> @@ -7,7 +7,7 @@
>  
>  /*
>   * Trace sequences are used to allow a function to call several other functions
> - * to create a string of data to use (up to a max of PAGE_SIZE.
> + * to create a string of data to use (up to a max of PAGE_SIZE).
>   */
>  
>  struct trace_seq {
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index d33e5ca..63446f1 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -486,7 +486,7 @@ struct ring_buffer_iter {
>  /* Up this if you want to test the TIME_EXTENTS and normalization */
>  #define DEBUG_SHIFT 0
>  
> -static inline u64 rb_time_stamp(struct ring_buffer *buffer, int cpu)
> +static inline u64 rb_time_stamp(struct ring_buffer *buffer)
>  {
>  	/* shift to debug/test normalization and TIME_EXTENTS */
>  	return buffer->clock() << DEBUG_SHIFT;
> @@ -497,7 +497,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
>  	u64 time;
>  
>  	preempt_disable_notrace();
> -	time = rb_time_stamp(buffer, cpu);
> +	time = rb_time_stamp(buffer);

Yeah, originally this was to deal with cpu_clock() which takes cpu as
its parameter. But we now just call "raw_smp_processor_id" instead
directly when using cpu_clock.

Thanks,

-- Steve

>  	preempt_enable_no_resched_notrace();
>  
>  	return time;
> @@ -602,7 +602,7 @@ static struct list_head *rb_list_head(struct list_head *list)
>  }
>  

