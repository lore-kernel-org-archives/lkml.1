Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZHaTTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZHaTTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbZHaTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:19:40 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:40342 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZHaTTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w2FPxr24UYSBdoGlT6jhSC8VjBOLFjj4gR46jE6EPIOLDcHOOz3JpuCCLMXHpIuQ7Z
         RNGGnADFM7E/TPcSxSY1uUYg5KedmwmUsOmI1C9y6ZgWH3LRfh6yswA9GBmTyP6vvtwj
         9PexklNSqVwIPLP7Q5xA/x5nkTwtizGQfeT5I=
Date: Mon, 31 Aug 2009 21:19:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: srostedt@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] tracing: remove mentioning of legacy latency_trace
	file from documentation
Message-ID: <20090831191937.GD6048@nowhere>
References: <1251744635-14926-1-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251744635-14926-1-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 08:50:35PM +0200, Albin Tonnerre wrote:
> The latency_trace file got removed a while back by commit
> 886b5b73d71e4027d7dc6c14f5f7ab102201ea6b. This patch fixes the
> documentation to stop mentioning it.
> 
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> ---
>  Documentation/trace/ftrace.txt |   55 +++++++++++++++++----------------------
>  1 files changed, 24 insertions(+), 31 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index a39b3c7..3f058ab 100644
> --- a/Documentation/trace/ftrace.txt
> +++ b/Documentation/trace/ftrace.txt
> @@ -85,26 +85,19 @@ of ftrace. Here is a list of some of the key files:
>  	This file holds the output of the trace in a human
>  	readable format (described below).
>  
> -  latency_trace:
> -
> -	This file shows the same trace but the information
> -	is organized more to display possible latencies
> -	in the system (described below).
> -
>    trace_pipe:
>  
>  	The output is the same as the "trace" file but this
>  	file is meant to be streamed with live tracing.
> -	Reads from this file will block until new data
> -	is retrieved. Unlike the "trace" and "latency_trace"
> -	files, this file is a consumer. This means reading
> -	from this file causes sequential reads to display
> -	more current data. Once data is read from this
> -	file, it is consumed, and will not be read
> -	again with a sequential read. The "trace" and
> -	"latency_trace" files are static, and if the
> -	tracer is not adding more data, they will display
> -	the same information every time they are read.
> +	Reads from this file will block until new data is
> +	retrieved.  Unlike the "trace" file, this file is a
> +	consumer. This means reading from this file causes
> +	sequential reads to display more current data. Once
> +	data is read from this file, it is consumed, and
> +	will not be read again with a sequential read. The
> +	"trace" file is static, and if the tracer is not
> +	adding more data,they will display the same
> +	information every time they are read.
>  
>    trace_options:
>  
> @@ -117,10 +110,10 @@ of ftrace. Here is a list of some of the key files:
>  	Some of the tracers record the max latency.
>  	For example, the time interrupts are disabled.
>  	This time is saved in this file. The max trace
> -	will also be stored, and displayed by either
> -	"trace" or "latency_trace".  A new max trace will
> -	only be recorded if the latency is greater than
> -	the value in this file. (in microseconds)
> +	will also be stored, and displayed by "trace".
> +	A new max trace will only be recorded if the
> +	latency is greater than the value in this
> +	file. (in microseconds)
>  
>    buffer_size_kb:
>  
> @@ -209,8 +202,7 @@ Here is the list of current tracers that may be configured.
>  	Traces the areas that disable interrupts and saves
>  	the trace with the longest max latency.
>  	See tracing_max_latency. When a new max is recorded,
> -	it replaces the old trace. It is best to view this
> -	trace via the latency_trace file.
> +	it replaces the old trace.
>  
>    "preemptoff"
>  
> @@ -307,8 +299,8 @@ the lowest priority thread (pid 0).
>  Latency trace format
>  --------------------
>  
> -For traces that display latency times, the latency_trace file
> -gives somewhat more information to see why a latency happened.
> +For traces that display latency times, the trace file gives
> +somewhat more information to see why a latency happened.
>  Here is a typical trace.
>  
>  # tracer: irqsoff
> @@ -382,7 +374,7 @@ The above is mostly meaningful for kernel developers.
>  
>    time: This differs from the trace file output. The trace file output
>  	includes an absolute timestamp. The timestamp used by the
> -	latency_trace file is relative to the start of the trace.
> +	trace file is relative to the start of the trace.


Not only is it wrong, but the sentence is now completely antithetic.

You can't update this documentation by just doing an s/latency_trace/trace
Especially since the latency_trace specifics are in essence different
from the trace file.

It's really nice to update the documentation according to the latest change,
but please take care about the end result.

Thanks,
Frederic.


