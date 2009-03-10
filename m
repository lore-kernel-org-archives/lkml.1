Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZCJQbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZCJQbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbZCJQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:30:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42305 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612AbZCJQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:30:50 -0400
Date: Tue, 10 Mar 2009 11:23:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Alexey@smtp1.linux-foundation.org,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090310162350.GB9354@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel> <20090310105702.43eb1402@thinkcentre.lan> <20090310110000.24893e0c@thinkcentre.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310110000.24893e0c@thinkcentre.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nathan Lynch (ntl@pobox.com):
> >From 3695fbda6225d2436e4af67a4bce6984df0891be Mon Sep 17 00:00:00 2001
> From: Nathan Lynch <ntl@pobox.com>
> Date: Mon, 9 Mar 2009 22:36:40 -0500
> Subject: [PATCH] ratelimit files_deny_checkpointing output
> 
> Any common distribution's boot sequence causes thousands of
> "<something> performed an action that cannot be checkpointed"
> messages.  Kernels are known to produce other messages of interest at
> times,

nonense...

> so ratelimit the output of files_deny_checkpointing.

Yes, please.

> Signed-off-by: Nathan Lynch <ntl@pobox.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  include/linux/checkpoint.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
> index 27366ac..efdb8f0 100644
> --- a/include/linux/checkpoint.h
> +++ b/include/linux/checkpoint.h
> @@ -108,8 +108,10 @@ static inline void __files_deny_checkpointing(const struct task_struct *tsk,
>  {
>  	if (!test_and_clear_bit(0, &files->may_checkpoint))
>  		return;
> -	printk(KERN_INFO "%s/%i performed an action that can not be "
> -	       "checkpointed at: %s:%d\n", tsk->comm, tsk->pid, file, line);
> +	if (printk_ratelimit())
> +		printk(KERN_INFO "%s/%i performed an action that can not be "
> +				"checkpointed at: %s:%d\n",
> +				tsk->comm, tsk->pid, file, line);
>  }
>  #define files_deny_checkpointing(tsk,f)				\
>  	__files_deny_checkpointing(tsk, f, __FILE__, __LINE__)
> -- 
> 1.6.0.6
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
