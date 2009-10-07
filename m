Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbZJGPhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbZJGPhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZJGPhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:37:16 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:61573 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZJGPhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P481lGZPxirYpWL8nSGnzpc2d5sSruF8vmhERn0yMp05xd+Rnu0ofidJCuqODXAO1b
         6BtDSZGu5mjabnvYzbo6OIjD8Gm/1eyysf+5aiXugFA7zj4V9hOTuvunmjWeD8RsZNcQ
         MFs+T6BkYt8YdiBJ87EHMnzK1nH877AdArDig=
Date: Wed, 7 Oct 2009 17:36:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhenwen Xu <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V3] fix a warning on kernel/trace/trace_branch.c
	andtrace_hw_branches.c
Message-ID: <20091007153635.GA5411@nowhere>
References: <20091007113915.GA5265@helight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007113915.GA5265@helight>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 07:39:15PM +0800, Zhenwen Xu wrote:
> fix warnings that caused the API change of trace_buffer_lock_reserve()
> change files: kernel/trace/trace_hw_branch.c
> 	      kernel/trace/trace_branch.c
> 
> Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
> ---
>  kernel/trace/trace_branch.c      |    2 +-
>  kernel/trace/trace_hw_branches.c |    6 ++++--
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 7a7a9fd..216e2dd 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
>  		goto out;
>  
>  	pc = preempt_count();
> -	event = trace_buffer_lock_reserve(tr, TRACE_BRANCH,
> +	event = trace_buffer_lock_reserve(tr->buffer, TRACE_BRANCH,
>  					  sizeof(*entry), flags, pc);



Your change in kernel/trace/trace_hw_branches.c is fine, because
you have handled the fact the buffer can be changed and then
saved it in a temporary var.

But you forgot to do it in trace_branch.c

Frederic.

