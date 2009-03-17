Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZCQWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZCQWtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 18:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZCQWta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 18:49:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZCQWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 18:49:30 -0400
Date: Tue, 17 Mar 2009 18:49:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Ingo Molnar <mingo@elte.hu>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [RFC][PATCH 03/11] ftrace: fix memory leak
In-Reply-To: <20090317220419.599556888@chello.nl>
Message-ID: <alpine.DEB.2.00.0903171847170.10610@gandalf.stny.rr.com>
References: <20090317215606.037073805@chello.nl> <20090317220419.599556888@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tom Zanussi beat you to it ;-)

  http://marc.info/?l=linux-kernel&m=123727898221734&w=2

-- Steve


On Tue, 17 Mar 2009, Peter Zijlstra wrote:

> Don't return after an allocation without freeing -- fix it by moving the check
> up a few lines.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/trace/trace_events.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/kernel/trace/trace_events.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_events.c
> +++ linux-2.6/kernel/trace/trace_events.c
> @@ -380,15 +380,15 @@ event_format_read(struct file *filp, cha
>  	char *buf;
>  	int r;
>  
> +	if (*ppos)
> +		return 0;
> +
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
>  	if (!s)
>  		return -ENOMEM;
>  
>  	trace_seq_init(s);
>  
> -	if (*ppos)
> -		return 0;
> -
>  	/* If any of the first writes fail, so will the show_format. */
>  
>  	trace_seq_printf(s, "name: %s\n", call->name);
> 
> -- 
> 
> 
