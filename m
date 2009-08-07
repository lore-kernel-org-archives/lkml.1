Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZHGPPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZHGPPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZHGPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:15:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60420 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbZHGPPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:15:07 -0400
Date: Fri, 7 Aug 2009 11:15:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: linux kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] ring-buffer: Fix memleak in ring_buffer_free()
In-Reply-To: <4A7C06B9.2090302@gmail.com>
Message-ID: <alpine.DEB.2.00.0908071113420.10926@gandalf.stny.rr.com>
References: <4A7C06B9.2090302@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 7 Aug 2009, Eric Dumazet wrote:

> I noticed oprofile memleaked in linux-2.6 current tree,
> and tracked this ring-buffer leak.
> 
> This is a stable candidate.

Thanks! I'll pull it in now.

-- Steve

> 
> [PATCH] ring-buffer: Fix memleak in ring_buffer_free()
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index bf27bb7..c1d874e 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -735,6 +735,7 @@ ring_buffer_free(struct ring_buffer *buffer)
>  
>  	put_online_cpus();
>  
> +	kfree(buffer->buffers);
>  	free_cpumask_var(buffer->cpumask);
>  
>  	kfree(buffer);
> 
