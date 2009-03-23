Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbZCWTA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbZCWTA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZCWTAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:00:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32811 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZCWTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:00:10 -0400
Date: Mon, 23 Mar 2009 15:00:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] trace: ring_buffer.c fix various signedness
 issues
In-Reply-To: <1237747471.8713.1.camel@ht.satnam>
Message-ID: <alpine.DEB.2.00.0903231458490.3578@gandalf.stny.rr.com>
References: <1237747471.8713.1.camel@ht.satnam>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


You're a little late:

  http://lkml.org/lkml/2009/2/10/262

-- Steve



On Mon, 23 Mar 2009, Jaswinder Singh Rajput wrote:

> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 23 Mar 2009 00:02:38 +0530
> Subject: [PATCH] trace: ring_buffer.c fix various signedness issues
> 
> Impact:cleanup
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  kernel/trace/ring_buffer.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index bd38c5c..114811b 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -57,7 +57,7 @@ enum {
>  	RB_BUFFERS_DISABLED	= 1 << RB_BUFFERS_DISABLED_BIT,
>  };
>  
> -static long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
> +static unsigned long ring_buffer_flags __read_mostly = RB_BUFFERS_ON;
>  
>  /**
>   * tracing_on - enable all tracing buffers
> @@ -2466,7 +2466,7 @@ static ssize_t
>  rb_simple_read(struct file *filp, char __user *ubuf,
>  	       size_t cnt, loff_t *ppos)
>  {
> -	long *p = filp->private_data;
> +	unsigned long *p = filp->private_data;
>  	char buf[64];
>  	int r;
>  
> @@ -2482,9 +2482,9 @@ static ssize_t
>  rb_simple_write(struct file *filp, const char __user *ubuf,
>  		size_t cnt, loff_t *ppos)
>  {
> -	long *p = filp->private_data;
> +	unsigned long *p = filp->private_data;
> +	unsigned long val;
>  	char buf[64];
> -	long val;
>  	int ret;
>  
>  	if (cnt >= sizeof(buf))
> -- 
> 1.6.0.6
> 
> 
> 
> 
