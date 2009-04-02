Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZDBM02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZDBM02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 08:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbZDBM0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 08:26:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:56513 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZDBM0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 08:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CkyU6vbTEWgrakZ0D+6ghEjNFt8fdDrL4GNzLjq1ZhXnkzTHYN9Ry15Em8jhN0CTjV
         jJilYUiafbNbzQu8YiQDJ7sGznwlGFBpQ16GDC7sF+hK7VcbgpTjOy7OVtDwzVB7Ukbt
         ijVYgC9Tuy680pfcfZSA97sv8WOSTVl7Uqus0=
Date: Thu, 2 Apr 2009 14:26:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: mark get_parent_ip() notrace
Message-ID: <20090402122612.GB5965@nowhere>
References: <49D458B1.5000703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D458B1.5000703@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 02:18:25PM +0800, Lai Jiangshan wrote:
> 
> Impact: remove redundancy tracing log
> 
> When tracer is "function" or "function_graph", too much
> "get_parent_ip" are recorded in ring_buffer.


Thanks, indeed this get_parent_ip was a bit harrassing
in the traces, though I still don't understand why it is
called so often.

Anyway, tracing it seems to me not useful.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 706517c..a0ec10c 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4860,7 +4860,7 @@ void scheduler_tick(void)
>  #endif
>  }
>  
> -unsigned long get_parent_ip(unsigned long addr)
> +notrace unsigned long get_parent_ip(unsigned long addr)
>  {
>  	if (in_lock_functions(addr)) {
>  		addr = CALLER_ADDR2;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

