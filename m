Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZCOEF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZCOEF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbZCOEFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:05:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZCOEFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:05:09 -0400
Date: Sat, 14 Mar 2009 20:53:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
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
Message-Id: <20090314205306.cafe25c6.akpm@linux-foundation.org>
In-Reply-To: <1236955332-10133-3-git-send-email-fweisbec@gmail.com>
References: <1236955332-10133-1-git-send-email-fweisbec@gmail.com>
	<1236955332-10133-3-git-send-email-fweisbec@gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Mar 2009 15:42:12 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> +static struct syscall_metadata *find_syscall_meta(unsigned long *syscall)
> +{
> +	struct syscall_metadata *start;
> +	struct syscall_metadata *stop;
> +	char str[KSYM_SYMBOL_LEN];
> +
> +
> +	start = (struct syscall_metadata *)__start_syscalls_metadata;
> +	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
> +	kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> +
> +	for ( ; start < stop; start++) {
> +		if (start->name && !strcmp(start->name, str))
> +			return start;
> +	}
> +	return NULL;
> +}

afacit this feature can be enabled when CONFIG_KALLSYMS=n.  Does that make
sense?

