Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZGNOPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZGNOPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZGNOPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:15:54 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:55484 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbZGNOPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:15:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f2ocY2kI69VEcsK46WLw78mC2SzQQqbXmDL6RSrf14FbHSXk4miJs42dUHjn9PbNc0
         i0Jlj0zXO/HPaPWU1jK65SGwL1krlG58OTTx6iXV7qWqHjbbyTAQ9tvIF4TObPyE5dQ9
         zyr2b0yc7IrvEbaQSZ6CVmhjHIQe7MuQIB09Y=
Date: Tue, 14 Jul 2009 16:15:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] ring_buffer: fix warning
Message-ID: <20090714141544.GA5728@nowhere>
References: <4A5C3549.7000905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5C3549.7000905@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 03:35:37PM +0800, Lai Jiangshan wrote:
> 
> kernel/trace/ring_buffer.c: In function 'rb_tail_page_update':
> kernel/trace/ring_buffer.c:849: warning: value computed is not used
> kernel/trace/ring_buffer.c:850: warning: value computed is not used
> 
> Add a "(void)" to fix this warning.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index e648ba4..d371279 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -846,8 +846,8 @@ static int rb_tail_page_update(struct ring_buffer_per_cpu *cpu_buffer,
>  		 * not come in and change it. In which case, we
>  		 * do not want to modify it.
>  		 */
> -		local_cmpxchg(&next_page->write, old_write, val);
> -		local_cmpxchg(&next_page->entries, old_entries, eval);
> +		(void)local_cmpxchg(&next_page->write, old_write, val);
> +		(void)local_cmpxchg(&next_page->entries, old_entries, eval);
>  
>  		/*
>  		 * No need to worry about races with clearing out the commit.


Looks good. Indeed the rest of the path remains the same, whether the
interrupts have already won the race or not.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

