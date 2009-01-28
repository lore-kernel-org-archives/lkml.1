Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZA1PGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZA1PGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 10:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZA1PGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 10:06:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:14268 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZA1PGD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:06:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=MyBNciInUXOm2TVycL6qtBhYJKkI27kq/5D+BaHuHTqiS/1mkp5ONyHPipERl5E+XV
         ZmluA/6qNimThUq2avg0JFexGg6cBnGLLvkmZYIBmQHv7z4PP1RNi3Cvxu/72a9fDp8B
         c3mBabsRhAOt16boJlHb8JwGtS/QcrMnu67Do=
MIME-Version: 1.0
In-Reply-To: <20090128150212.GB627@ghostprotocols.net>
References: <20090128150212.GB627@ghostprotocols.net>
Date: Wed, 28 Jan 2009 16:06:00 +0100
Message-ID: <c62985530901280706x61b4e4d1nbb43913f9b53e07@mail.gmail.com>
Subject: Re: [PATCH] trace: Use tracing_reset_online_cpus in more places
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/28 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> Impact: cleanup
>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index ca017e0..1284145 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -133,11 +133,7 @@ static void stop_branch_trace(struct trace_array *tr)
>
>  static int branch_trace_init(struct trace_array *tr)
>  {
> -       int cpu;
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -
> +       tracing_reset_online_cpus(tr);
>        start_branch_trace(tr);
>        return 0;
>  }
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 66fc7b8..c97594d 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -52,15 +52,11 @@ static struct tracer_flags tracer_flags = {
>
>  static int graph_trace_init(struct trace_array *tr)
>  {
> -       int cpu, ret;
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -
> -       ret = register_ftrace_graph(&trace_graph_return,
> +       int ret = register_ftrace_graph(&trace_graph_return,
>                                        &trace_graph_entry);
>        if (ret)
>                return ret;
> +       tracing_reset_online_cpus(tr);
>        tracing_start_cmdline_record();
>
>        return 0;
> diff --git a/kernel/trace/trace_nop.c b/kernel/trace/trace_nop.c
> index b9767ac..087b6cb 100644
> --- a/kernel/trace/trace_nop.c
> +++ b/kernel/trace/trace_nop.c
> @@ -47,12 +47,8 @@ static void stop_nop_trace(struct trace_array *tr)
>
>  static int nop_trace_init(struct trace_array *tr)
>  {
> -       int cpu;
>        ctx_trace = tr;
> -
> -       for_each_online_cpu(cpu)
> -               tracing_reset(tr, cpu);
> -
> +       tracing_reset_online_cpus(tr);
>        start_nop_trace(tr);
>        return 0;
>  }
>

Thanks :-)

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
