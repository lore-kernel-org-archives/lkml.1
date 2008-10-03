Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYJCFVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYJCFVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYJCFUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:20:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49004 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYJCFUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:20:54 -0400
Date: Fri, 3 Oct 2008 01:20:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] x86 Topology cpu_to_node parameter check
In-Reply-To: <20081003045607.GA5940@Krystal>
Message-ID: <alpine.DEB.1.10.0810030117280.26504@gandalf.stny.rr.com>
References: <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
 <20081003045607.GA5940@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 3 Oct 2008, Mathieu Desnoyers wrote:

> ---
>  include/asm-x86/topology.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/include/asm-x86/topology.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-x86/topology.h	2008-10-03 00:37:05.000000000 -0400
> +++ linux-2.6-lttng/include/asm-x86/topology.h	2008-10-03 00:45:52.000000000 -0400
> @@ -182,9 +182,9 @@ extern int __node_distance(int, int);
>  
>  #else /* !CONFIG_NUMA */
>  
> -#define numa_node_id()		0
> -#define	cpu_to_node(cpu)	0
> -#define	early_cpu_to_node(cpu)	0
> +#define	numa_node_id()		0
> +#define	cpu_to_node(cpu)	((void)(cpu),0)
> +#define	early_cpu_to_node(cpu)	cpu_to_node(cpu)

Actually the proper way would be to have:

static inline int cpu_to_node(int cpu)
{
	return 0;
}

static inline int early_cpu_to_node(int cpu)
{
	return 0;
}

This way you also get typechecks.

-- Steve

>  
>  static inline const cpumask_t *_node_to_cpumask_ptr(int node)
>  {
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
