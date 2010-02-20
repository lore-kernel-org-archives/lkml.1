Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0BTOnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:43:17 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39864 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083Ab0BTOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rcNBahDudJAlvHkXN+p3hTKuaROd3F9x5CP237sYbHBPGshtp9aDVRMgbNKvKUqoVY
         fva363CRSapifvwVcPGfPJRCDvsrXakICmD/poQYNuTmFtfwee/F5P6zh4wTdgoRXg/A
         eXtKZOWE3/V7D1V1b0LLtmOVcoZJPzDYyixv0=
Date: Sat, 20 Feb 2010 15:43:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/1] ftrace - add support for tracing_thresh to
	function_graph tracer
Message-ID: <20100220144302.GB5354@nowhere>
References: <4B733721.3030503@am.sony.com> <4B7338BF.1070505@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7338BF.1070505@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 02:52:47PM -0800, Tim Bird wrote:
>  int trace_graph_entry(struct ftrace_graph_ent *trace)
>  {
>  	struct trace_array *tr = graph_array;
> @@ -221,6 +226,10 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	if (!ftrace_graph_addr(trace->func))
>  		return 0;
>  
> +	/* if tracing duration, only save function exits (omit function entries in log) */
> +	if (tracing_thresh)
> +		return 1;
> +


Instead of having yet another check here, may be should we
have a dedicated stub trace_graph_entry?



> @@ -254,6 +263,10 @@ static void __trace_graph_return(struct trace_array *tr,
>  	if (unlikely(__this_cpu_read(per_cpu_var(ftrace_cpu_disabled))))
>  		return;
>  
> +	if (tracing_thresh &&
> +		(trace->rettime - trace->calltime < tracing_thresh))
> +		return;
> +



And perhaps we can do the same for the return handler?
We could have a trace_graph_return_threshold that
performs the above check and then relies on trace_graph_return.

Thanks.

