Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZBJP0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZBJP0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZBJP0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:26:31 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:18382 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZBJP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:26:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xgV7Hajx7sYALHg1kJMXB1Ibh7PUKucvujEC6AxksEK6Px4k5I3FBbT2hFgr4MJANU
         2Ojm9vYE4yUWybM552rUNZeXMtalgyCXRE12Fn/SvUbbEPVWhmPSKjmUkRSZA/MUKjEr
         zic59/8SG4t9RXRE8NKMKe0N+dq8jDEkZ7kLE=
Date: Tue, 10 Feb 2009 16:26:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] trace: use the more accurate parameter.
Message-ID: <20090210152624.GH5836@nowhere>
References: <1234225804-13314-1-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234225804-13314-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 07:30:04PM -0500, Wenji Huang wrote:
> Pass tsk to __update_max_tr instead of current to avoid latent hazard.
> 
> Impact: clean up
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 5b1e9a9..c1592f1 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -335,7 +335,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  	data->rt_priority = tsk->rt_priority;
>  
>  	/* record this tasks comm */
> -	tracing_record_cmdline(current);
> +	tracing_record_cmdline(tsk);
>  }


Indeed. At this stage, tsk is the next task in the middle of a context
switch. So I guess current is right, but this is more proper to use tsk.

  
>  static void
> -- 
> 1.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

