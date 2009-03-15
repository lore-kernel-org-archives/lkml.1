Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZCOFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZCOFbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 01:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZCOFbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 01:31:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZCOFbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 01:31:13 -0400
Date: Sun, 15 Mar 2009 06:30:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Jason Baron <jbaron@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>, Michael Davidson <md@google.com>
Subject: Re: [PATCH 2/2 v2] tracing/syscalls: support for syscalls tracing
	on x86-64
Message-ID: <20090315053018.GB20949@elte.hu>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-3-git-send-email-fweisbec@gmail.com> <20090314205306.cafe25c6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314205306.cafe25c6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 13 Mar 2009 15:42:12 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > +static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
> > +{
> > +	struct syscall_metadata *start;
> > +	struct syscall_metadata *stop;
> > +	char str[KSYM_SYMBOL_LEN];
> > +
> > +
> > +	start = (struct syscall_metadata *)__start_syscalls_metadata;
> > +	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> > +	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> > +
> > +	for ( ; start < stop; start++) {
> > +		if (start->name && !strcmp(start->name, str))
> > +			return start;
> > +	}
> > +	return NULL;
> > +}
> 
> afacit this feature can be enabled when CONFIG_KALLSYMS=n.  
> Does that make sense?

It does not make much sense - the function will return NULL and 
we wont do any tracing. Frederic: FTRACE_SYSCALLS should either 
select KALLSYMS in kernel/trace/Kconfig, like the STACK_TRACER 
and FUNCTION_TRACER already does. Or perhaps, for really 
puritane tracing, we should emit simplified, non-symbolic trace 
data in the !KALLSYMS case.

	Ingo
