Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886Ab0ATSEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0ATSEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849Ab0ATSEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:04:35 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:64137 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab0ATSEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:04:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ggvQtGDRRBMDTAd6LnP+neokr9YNwyx8xhNohcO0ro2LyUAShnKKv/XbebX2h2FxyK
         60hMOi0ChGRmPR38I3DwY0MWA40iZezdjXZCUxUb3aR31UEx7t7CoWuOaVn3cR2ehkS9
         iEgCm4m+i3eX8aBcSJCjXAhYMx8y+9gFNdB9A=
Date: Wed, 20 Jan 2010 19:04:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/6] tracing: event_id_read() uses simple buffer
	instead of trace_seq
Message-ID: <20100120180428.GC5017@nowhere>
References: <4B556069.3060200@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B556069.3060200@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:34:01PM +0800, Lai Jiangshan wrote:
> 
> It seems that struct trace_seq is too heavy for event_id_read().
> we use simple buffer instead of struct trace_seq.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>



> ---
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 04d3f90..835b370 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -604,23 +604,16 @@ static ssize_t
>  event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  {
>  	struct ftrace_event_call *call = filp->private_data;
> -	struct trace_seq *s;
> -	int r;
> +	char buf[20];
> +	int len;
>  
>  	if (*ppos)
>  		return 0;
>  
> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
> -	if (!s)
> -		return -ENOMEM;
> +	len = snprintf(buf, sizeof(buf), "%d\n", call->id);
> +	len = simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
>  
> -	trace_seq_init(s);
> -	trace_seq_printf(s, "%d\n", call->id);
> -
> -	r = simple_read_from_buffer(ubuf, cnt, ppos,
> -				    s->buffer, s->len);
> -	kfree(s);
> -	return r;
> +	return len;
>  }
>  
>  static ssize_t
> 
> 

