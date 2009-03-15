Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZCOQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZCOQFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 12:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZCOQFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 12:05:46 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:33489 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZCOQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 12:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D4YupLs3CKF0MPv7EttrK4D3m3uo1fEf+tO/tz6+iuaeMaZRDpXQ+s35cXApmR9BBt
         POfTlFEIvR0knTJoCvme7bHlNKDNVZln4857A6GXQyjWgnsIWfRrcR4Kk8HSWYNARBYZ
         wJyOIF6TnU3oQ/acDh6GRWntKPcb/XgoY+zng=
Date: Sun, 15 Mar 2009 17:05:40 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20090315160538.GE5105@nowhere>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com> <1236955332-10133-3-git-send-email-fweisbec@gmail.com> <20090314205306.cafe25c6.akpm@linux-foundation.org> <20090315053018.GB20949@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090315053018.GB20949@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 06:30:18AM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 13 Mar 2009 15:42:12 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > +static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
> > > +{
> > > +	struct syscall_metadata *start;
> > > +	struct syscall_metadata *stop;
> > > +	char str[KSYM_SYMBOL_LEN];
> > > +
> > > +
> > > +	start = (struct syscall_metadata *)__start_syscalls_metadata;
> > > +	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> > > +	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> > > +
> > > +	for ( ; start < stop; start++) {
> > > +		if (start->name && !strcmp(start->name, str))
> > > +			return start;
> > > +	}
> > > +	return NULL;
> > > +}
> > 
> > afacit this feature can be enabled when CONFIG_KALLSYMS=n.  
> > Does that make sense?
> 
> It does not make much sense - the function will return NULL and 
> we wont do any tracing. Frederic: FTRACE_SYSCALLS should either 
> select KALLSYMS in kernel/trace/Kconfig, like the STACK_TRACER 
> and FUNCTION_TRACER already does. Or perhaps, for really 
> puritane tracing, we should emit simplified, non-symbolic trace 
> data in the !KALLSYMS case.
> 
> 	Ingo

You're right. But it would be somewhat pointless to trace the syscalls
without their names.
I will make it select KALLSYMS, it seems to me a sane way to fix it.

Thanks.

