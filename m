Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZCVTFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZCVTFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 15:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZCVTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 15:05:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:52398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbZCVTF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 15:05:28 -0400
Subject: Re: [PATCH -tip] trace: ring_buffer.c fix various signedness issues
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237747471.8713.1.camel@ht.satnam>
References: <1237747471.8713.1.camel@ht.satnam>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 00:35:10 +0530
Message-Id: <1237748710.25810.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 00:14 +0530, Jaswinder Singh Rajput wrote:
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 23 Mar 2009 00:02:38 +0530
> Subject: [PATCH] trace: ring_buffer.c fix various signedness issues
> 

BTW, these issues were solved by this patch:

  CHECK   kernel/trace/ring_buffer.c
kernel/trace/ring_buffer.c:70:30: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:70:30:    expected unsigned long volatile *addr
kernel/trace/ring_buffer.c:70:30:    got long static [toplevel] *<noident>
kernel/trace/ring_buffer.c:84:32: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:84:32:    expected unsigned long volatile *addr
kernel/trace/ring_buffer.c:84:32:    got long static [toplevel] *<noident>
kernel/trace/ring_buffer.c:96:36: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:96:36:    expected unsigned long volatile *addr
kernel/trace/ring_buffer.c:96:36:    got long static [toplevel] *<noident>
kernel/trace/ring_buffer.c:2473:6: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2473:6:    expected unsigned long const volatile *addr
kernel/trace/ring_buffer.c:2473:6:    got long *p
kernel/trace/ring_buffer.c:2473:6: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2473:6:    expected unsigned long const volatile *addr
kernel/trace/ring_buffer.c:2473:6:    got long *p
kernel/trace/ring_buffer.c:2476:28: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2476:28:    expected unsigned long const volatile *addr
kernel/trace/ring_buffer.c:2476:28:    got long *p
kernel/trace/ring_buffer.c:2476:28: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2476:28:    expected unsigned long const volatile *addr
kernel/trace/ring_buffer.c:2476:28:    got long *p
kernel/trace/ring_buffer.c:2498:33: warning: incorrect type in argument 3 (different signedness)
kernel/trace/ring_buffer.c:2498:33:    expected unsigned long *<noident>
kernel/trace/ring_buffer.c:2498:33:    got long *<noident>
kernel/trace/ring_buffer.c:2503:30: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2503:30:    expected unsigned long volatile *addr
kernel/trace/ring_buffer.c:2503:30:    got long *p
kernel/trace/ring_buffer.c:2505:32: warning: incorrect type in argument 2 (different signedness)
kernel/trace/ring_buffer.c:2505:32:    expected unsigned long volatile *addr
kernel/trace/ring_buffer.c:2505:32:    got long *p

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

