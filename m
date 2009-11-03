Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZKCHdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZKCHdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 02:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZKCHdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 02:33:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50239 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbZKCHdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 02:33:07 -0500
Date: Tue, 3 Nov 2009 08:32:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes and
	perf-probe syntax changes
Message-ID: <20091103073236.GB19928@elte.hu>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com> <4AEF4C29.2060501@redhat.com> <4AEF7B22.50705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF7B22.50705@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
>> Masami Hiramatsu wrote:
>>> Ingo Molnar wrote:
>>>> What we want here is two fold:
>>>>
>>>>     - enable kprobes event support when perf events is enabled and kprobes
>>>>       is enabled. We dont want another config option for it.
>>>
>>> Sure, at least that combination should enable kprobe-tracer forcibly.
>>
>> Hmm, someone may not want to enables kprobe-tracer. Perhaps,
>> "default y if (EVENT_PROFILE)" is enough, isn't it?
>
> Oops, this causes recursive dependency error :-(
>
> kernel/trace/Kconfig:90:error: found recursive dependency: TRACING ->
> EVENT_TRACING -> EVENT_PROFILE -> KPROBE_TRACER -> GENERIC_TRACER -> TRACING

This dependency problem can be resolved by simply making it 'default y' 
- the option itself depends on KPROBES already, which is default-off - 
so no need to also make it depend on EVENT_PROFILE.

btw., it would be nice to re-name it to 'KPROBE_EVENTS'. If the probe 
point is used as a count - like in the __switch_to example i cited - 
there's no tracing going on at all.

	Ingo
