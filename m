Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZH0Hc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZH0Hc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZH0Hc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:32:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34903 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbZH0HcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:32:25 -0400
Date: Thu, 27 Aug 2009 09:31:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Przemys??aw Pawe??czyk <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 08/18] tracing: Add kprobe-based event tracer
Message-ID: <20090827073139.GB2131@elte.hu>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-9-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251340337-5640-9-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Add kprobes-based event tracer on ftrace.
> 
> This tracer is similar to the events tracer which is based on 
> Tracepoint infrastructure. Instead of Tracepoint, this tracer is 
> based on kprobes (kprobe and kretprobe). It probes anywhere where 
> kprobes can probe(this
>  means, all functions body except for __kprobes functions).
> 
> Similar to the events tracer, this tracer doesn't need to be 
> activated via current_tracer, instead of that, just set probe 
> points via /sys/kernel/debug/tracing/kprobe_events. And you can 
> set filters on each probe events via 
> /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.

ok, one observation here: this should seemlessly merge into 
/debug/tracing/events/ and provide a record format descriptor in 
'format' to allow the automated fetching of the results of the 
probe. The PERF_SAMPLE_RAW gateway should work as well.
 
That way tooling that knows about /debug/tracing/events/ will 
automatically work with kprobes events as well. We can profile based 
on kprobes, etc. etc.

The _setting_ of the probe is still a separate channel - but if 
existing installed probes are merged into existing tooling that's a 
big step forward in terms of utility.

	Ingo
