Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZLKPA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZLKPA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZLKPAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:00:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628AbZLKPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:00:20 -0500
X-Authority-Analysis: v=1.0 c=1 a=gSC5VE2jCJUA:10 a=7U3hwN5JcxgA:10 a=yPCof4ZbAAAA:8 a=LhvtY-3z_8CeNFjCQLAA:9 a=MLrfXKkvA2CiOS1eJrNx1jUHsA8A:4 a=7DSvI1NPTFQA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: add checks for printing graph irq
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com
In-Reply-To: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
References: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 10:00:26 -0500
Message-ID: <1260543626.2146.357.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 17:38 +0800, Wenji Huang wrote:
> Check return value of trace_seq_printf.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_functions_graph.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 45e6c01..3fa4055 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -555,8 +555,11 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
>  		return TRACE_TYPE_PARTIAL_LINE;
>  
>  	/* Don't close the duration column if haven't one */
> -	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION)
> -		trace_seq_printf(s, " |");
> +	if (tracer_flags.val & TRACE_GRAPH_PRINT_DURATION) {
> +		ret = trace_seq_printf(s, " |");
> +		if (!ret)
> +			return TRACE_TYPE_PARTIAL_LINE;
> +	}
>  	ret = trace_seq_printf(s, "\n");

Actually these checks are no longer needed. I would like to start
removing them. Only the last one is needed.

This is because trace_seq_* now has a "full" attribute. If the s buffer
gets full, it wont write anymore, and all new "trace_seq_*" calls will
return the same.

-- Steve

>  
>  	if (!ret)


