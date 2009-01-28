Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZA1OyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZA1OyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZA1Oxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 09:53:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:11724 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZA1Oxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 09:53:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=jDws+Lqb/8zWW2Vd+WiUfZWzQG8GxGL8WcZVy23c+PbbETKBZGFeq14P6Z3nefbgPa
         IBuXgfELnFwmMCWWFQ5WUyI1GdYSn7o5mBx+Fro2PuijB3gGEAF50BQrtteJLuPMpZg7
         UxsK4A+JksBRDFE2J5C1mtzZvQUW1VaeCILxE=
MIME-Version: 1.0
In-Reply-To: <20090128143356.GG15877@ghostprotocols.net>
References: <20090128143356.GG15877@ghostprotocols.net>
Date: Wed, 28 Jan 2009 15:53:48 +0100
Message-ID: <c62985530901280653p3febe22cu7897999dce8777e@mail.gmail.com>
Subject: Re: [PATCH tip 1/1] blktrace: Use tracing_reset_online_cpus
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Impact: cleanup
>
> Use tracing_reset_online_cpus instead of open coding it.
>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/block/blktrace.c b/block/blktrace.c
> index 1b2267c..04d81d3 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -1109,12 +1109,7 @@ static void blk_tracer_print_header(struct seq_file *m)
>
>  static void blk_tracer_start(struct trace_array *tr)
>  {
> -       int cpu;
> -
> -       tr->time_start = ftrace_now(tr->cpu);
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> +       tracing_reset_online_cpus(tr);
>
>        mutex_lock(&blk_probe_mutex);
>        if (atomic_add_return(1, &blk_probes_ref) == 1)
>

Adding Steven in Cc, he uses to relay tracing patches as patchsets
pull request to Ingo.
