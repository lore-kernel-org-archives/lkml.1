Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJCH37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJCH37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 03:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYJCH3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 03:29:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48625 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbYJCH3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 03:29:49 -0400
Date: Fri, 3 Oct 2008 09:27:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] ring_buffer: map to cpu not page
Message-ID: <20081003072722.GB4950@elte.hu>
References: <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810021917030.26504@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> My original patch had a compile bug when NUMA was configured. I 
> referenced cpu when it should have been cpu_buffer->cpu.
> 
> Ingo quickly fixed this bug by replacing cpu with 'i' because that was 
> the loop counter. Unfortunately, the 'i' was the counter of pages, not 
> CPUs. This caused a crash when the number of pages allocated for the 
> buffers exceeded the number of pages, which would usually be the case.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

>  	for (i = 0; i < nr_pages; i++) {
>  		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
> -				    GFP_KERNEL, cpu_to_node(i));
> +				    GFP_KERNEL, cpu_to_node(cpu_buffer->cpu));

oh, stupid typo of the year :-)

applied to tip/tracing/ring-buffer, thanks for tracking it down! I've 
reactivated the topic branch for tip/master and i'm running a few tests 
before pushing it out for wider testing.

	Ingo
