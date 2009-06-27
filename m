Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZF0H5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZF0H5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 03:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZF0H5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 03:57:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZF0H5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 03:57:12 -0400
Subject: Re: [tip:perfcounters/urgent] perf stat: Add -n/--null option to
 run without counters
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-0cfb7a13b8e4e0afd4b856156ab16a182de7505b@git.kernel.org>
References: <new-submission>
	 <tip-0cfb7a13b8e4e0afd4b856156ab16a182de7505b@git.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 13:26:24 +0530
Message-Id: <1246089384.2961.5.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 04:31 +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  0cfb7a13b8e4e0afd4b856156ab16a182de7505b
> Gitweb:     http://git.kernel.org/tip/0cfb7a13b8e4e0afd4b856156ab16a182de7505b
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Sat, 27 Jun 2009 06:10:30 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 27 Jun 2009 06:11:24 +0200
> 
> perf stat: Add -n/--null option to run without counters
> 
> Allow a no-counters run. This can be useful to measure just
> elapsed wall-clock time - or to assess the raw overhead of perf
> stat itself, without running any counters.
> 

Why it better then $ time <command>

Any way this patch is broken. 

Why you are allocating :
memcpy(attrs, default_attrs, sizeof(attrs)); when null_run is set.

To get better picture and solution, Please check [PATCH] perf stat: fix
default attrs and nr_counters

which I send in "Re: [PATCH -tip] perf_counter tools: add support to set
of multiple events in one short" send on Fri, 26 Jun 2009 18:08:40 +0530

Thanks,

--
JSR
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  tools/perf/builtin-stat.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 8420ec5..cdcd058 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -70,6 +70,7 @@ static int			run_count			=  1;
>  static int			inherit				=  1;
>  static int			scale				=  1;
>  static int			target_pid			= -1;
> +static int			null_run			=  0;
>  
>  static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
>  
> @@ -461,6 +462,8 @@ static const struct option options[] = {
>  		    "be more verbose (show counter open errors, etc)"),
>  	OPT_INTEGER('r', "repeat", &run_count,
>  		    "repeat command and print average + stddev (max: 100)"),
> +	OPT_BOOLEAN('n', "null", &null_run,
> +		    "null run - dont start any counters"),
>  	OPT_END()
>  };
>  
> @@ -476,7 +479,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
>  	if (run_count <= 0 || run_count > MAX_RUN)
>  		usage_with_options(stat_usage, options);
>  
> -	if (!nr_counters)
> +	if (!null_run && !nr_counters)
>  		nr_counters = 8;
>  
>  	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

