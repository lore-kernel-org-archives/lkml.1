Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZAFWsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZAFWsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZAFWs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:48:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbZAFWsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:48:25 -0500
Date: Tue, 6 Jan 2009 14:47:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       roel.kluin@gmail.com, pq@iki.fi, srostedt@redhat.com
Subject: Re: [PATCH 2/3] ring-buffer: rename debugfs file tracing_on to
 writing_enabled
Message-Id: <20090106144740.686c3f33.akpm@linux-foundation.org>
In-Reply-To: <20090106223405.512131804@goodmis.org>
References: <20090106223337.677427397@goodmis.org>
	<20090106223405.512131804@goodmis.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2009 17:33:39 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: clean up
> 
> The debugfs file name tracing_on is confusing since there is also
> a tracing_enabled. When a tracer is added to current_tracer and
> tracing_enabled is set to 1, then the tracer will start tracing.
> The current file tracing_on, if set to 1, will allow writing to
> the ring buffers. If tracing_on is set to 0 then the ring buffers
> are read only, and any attempt by the tracers to write to the
> ring buffers will fail.
> 
> But the name tracing_on confuses both developers and users.
> This patch renames it to 'writing_enabled'.  This is exactly what
> the file does. When set to 1, the ring buffers have writing enabled
> and when set to 0, the ring buffers can not be written to.
> 
> The tracers do not get any call backs called or other notification
> that the ring buffers have been set to read only, except when they
> attempt to write to the ring buffers, that write will fail.
> 
> Note: it is a requirement that any tracer that uses the ring buffers
> must handle a failure to write to the ring buffers, since the ring buffers
> may be disabled for any number of reasons.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/ring_buffer.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index a9d9760..dba6876 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -2514,10 +2514,11 @@ static __init int rb_init_debugfs(void)
>  
>  	d_tracer = tracing_init_dentry();
>  
> -	entry = debugfs_create_file("tracing_on", 0644, d_tracer,
> +	entry = debugfs_create_file("writing_enabled", 0644, d_tracer,
>  				    &ring_buffer_flags, &rb_simple_fops);
>  	if (!entry)
> -		pr_warning("Could not create debugfs 'tracing_on' entry\n");
> +		pr_warning("Could not create debugfs"
> +			   " 'writing_enabled' entry\n");
>  
>  	return 0;
>  }

There's no corresponding documentation update needed?
