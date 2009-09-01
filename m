Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbZIAJcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbZIAJcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 05:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZIAJcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 05:32:05 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49096 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZIAJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 05:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hT+hNIN2wSXn8wO3pRlQGCIoTW4jKbOGA/Tuzosj2PZ/HrxaGzOKfZd1/OTPpa4egG
         abi5Ne+A0hwyd5XRT/M74uzKDkqfF0lWCEexrD8OEIfZ77xpp9G/aR4MFM+RHutAFFo7
         zBwJ6LUNynHDfkvne3gvqO15D4UWXUA7D4nWg=
Date: Tue, 1 Sep 2009 11:32:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation, fix memory leak
Message-ID: <20090901093159.GA6485@nowhere>
References: <4A9B8EA5.6020700@cn.fujitsu.com> <20090831174107.GB6048@nowhere> <4A9CB1BA.3060402@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9CB1BA.3060402@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 01:31:38PM +0800, Li Zefan wrote:
> Check if we have already allocated memory for filter preds.
> 
> Spotted-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/trace_events_filter.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index c6b2edf..93660fb 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -409,6 +409,9 @@ static int init_preds(struct ftrace_event_call *call)
>  	struct filter_pred *pred;
>  	int i;
>  
> +	if (call->filter)
> +		return 0;
> +
>  	filter = call->filter = kzalloc(sizeof(*filter), GFP_KERNEL);
>  	if (!call->filter)
>  		return -ENOMEM;
> @@ -447,11 +450,9 @@ static int init_subsystem_preds(struct event_subsystem *system)
>  		if (strcmp(call->system, system->name) != 0)
>  			continue;
>  
> -		if (!call->filter) {
> -			err = init_preds(call);
> -			if (err)
> -				return err;
> -		}
> +		err = init_preds(call);
> +		if (err)
> +			return err;
>  	}
>  
>  	return 0;
> -- 
> 1.6.3
> 

