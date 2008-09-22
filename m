Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYIVMbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYIVMbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 08:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIVMay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 08:30:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:36179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYIVMax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 08:30:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UeC/kaj0mq0YU5xJpGcQ4fP2VNCLk09XnaNFB8eXk3QhpH9sLbX7u2S6bwFwRkTytu
         ndfiNJD78bNPTEoJUvZBFy3A/1igrjQJEI2WAbRYTFLnN22OL0FqHfB+70cgaYWy/KLy
         RIeKqUpKPBVCzNkThHYHMBMSEdGBQWyhXu/sI=
Message-ID: <c62985530809220530g1716c366weee09fa2526475dc@mail.gmail.com>
Date: Mon, 22 Sep 2008 14:30:47 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [Patch 3/3] Tracing/ftrace: Replace none tracer by nop tracer
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Steven Noonan" <steven@uplinklabs.net>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080922094358.GB17258@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48D68F7E.5020609@gmail.com> <20080922094358.GB17258@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/22 Ingo Molnar <mingo@elte.hu>:
> btw., if people are interested in new tracers, it would be useful to
> have an initcall tracer which can capture boot delays and schedule
> events from bootup. -tip has the 'fastboot' feature topic which could
> make use of such a tracer.
>
> Right now fastboot profiling works like this: it (abu-)uses the
> initcall_debug boot parameter to get such special printouts in
> init/main.c:
>
>                printk("initcall %pF returned %d after %Ld msecs\n", fn,
>                        result, (unsigned long long) delta.tv64 >> 20);
>
> and relies on CONFIG_PRINTK_TIME to get event timestamps. Then, after
> bootup, scripts/bootgraph.pl can be used to draw a graph of bootup
> dependencies and timings.
>
> the efficiency of this mechanism could be extended significantly via an
> ftrace/fastboot plugin: it would allow non-initcall delays to be traced,
> plus the _reason_ for the delays as well. Stackframe tracing could be
> enabled by default (see 'stacktrace' / TRACE_ITER_STACKTRACE /
> __trace_stack() in kernel/tracing/trace.c - not to be confused with the
> stack-footprint tracer ftrace/stacktrace), and context-switch events
> could be / should be traced as well.
>
> the ideal workflow would be like this: developers optimizing fastboot
> details would enable a single kernel option: CONFIG_TRACE_BOOT, and that
> would be an 'all in one' switch. Tracing would occur by default (no
> extra boot parameters), and /debug/tracing/trace would have output
> suitable for scripts/bootgraph.pl parsing.
>
> (at least) one architectural detail that needs to be solved here is the
> fact that ftrace is initialized via an initcall right now. It should
> probably be initialized via an early-initcall instead.
>
> Hm?
>
>        Ingo
>

Sounds really interesting. I will try to write this tracer in next days.
But first I will try to solve this initcall problem...

(Sorry Ingo, I forgot to cc LKML)

Frédéric.
