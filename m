Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZHNKH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZHNKH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 06:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZHNKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 06:07:25 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53397 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbZHNKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JdhfTNG4/sVAkqM4lfH5PMnkxKAihlK96tsVCpbKlZDl8/YPlkuHN0i/0JZRODaWKY
         xHwDB0cbIJNBVl/em3p+gUKKWde+qnrCNz7WExCKA0+J3AX4SEgiuLMqY7XPVtyGXaRV
         Ja8e0elPGIycO3I3xtfANQxP8SySkKVSNgnuI=
Date: Fri, 14 Aug 2009 12:07:22 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/2] perf tools: Add a general option to enable raw
	sample records
Message-ID: <20090814100721.GB5992@nowhere>
References: <1250244300-6343-1-git-send-email-fweisbec@gmail.com> <1250244300-6343-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250244300-6343-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore this one, it has been resent by mistake :-(

On Fri, Aug 14, 2009 at 12:05:00PM +0200, Frederic Weisbecker wrote:
> While we can enable the perf sample records per tracepoint counter,
> we may also want to enable this option for every tracepoint
> counters to open, so that we don't need to add a :record flag
> for all of them.
> 
> Add the -R, --raw-samples options for this purpose.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> ---
>  tools/perf/builtin-record.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 3be0301..e67c4fa 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -35,6 +35,7 @@ static int			output;
>  static const char		*output_name			= "perf.data";
>  static int			group				= 0;
>  static unsigned int		realtime_prio			= 0;
> +static int			raw_samples			= 0;
>  static int			system_wide			= 0;
>  static int			profile_cpu			= -1;
>  static pid_t			target_pid			= -1;
> @@ -400,6 +401,8 @@ static void create_counter(int counter, int cpu, pid_t pid)
>  	if (call_graph)
>  		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
>  
> +	if (raw_samples)
> +		attr->sample_type	|= PERF_SAMPLE_RAW;
>  
>  	attr->mmap		= track;
>  	attr->comm		= track;
> @@ -632,6 +635,8 @@ static const struct option options[] = {
>  		    "record events on existing pid"),
>  	OPT_INTEGER('r', "realtime", &realtime_prio,
>  		    "collect data with this RT SCHED_FIFO priority"),
> +	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
> +		    "collect raw sample records from all opened counters"),
>  	OPT_BOOLEAN('a', "all-cpus", &system_wide,
>  			    "system-wide collection from all CPUs"),
>  	OPT_BOOLEAN('A', "append", &append_file,
> -- 
> 1.6.2.3
> 

