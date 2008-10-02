Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYJBJJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYJBJJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 05:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYJBJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 05:09:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51171 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYJBJJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 05:09:07 -0400
Date: Thu, 2 Oct 2008 11:05:17 +0200
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
Subject: [PATCH] ring-buffer: fix build error
Message-ID: <20081002090517.GA8708@elte.hu>
References: <20080930034603.GA13801@Krystal> <alpine.DEB.1.10.0809292359030.19533@gandalf.stny.rr.com> <20080930092001.69849210@bike.lwn.net> <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081002085145.GA3202@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > applied to tip/tracing/ftrace, with the extended changlog below - i 
> > think this commit warrants that extra mention.
> 
> that was for the type filter commit. The 3 patches i've picked up into 
> tip/tracing/ring-buffer are:
> 
>  b6eeea4: ftrace: preempt disable over interrupt disable
>  52abc82: ring_buffer: allocate buffer page pointer
>  da78331: ftrace: type cast filter+verifier

trivial build fix below.

	Ingo

>From 339ce9af3e6cbc02442b0b356c1ecb80a8ae92fb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 2 Oct 2008 11:04:14 +0200
Subject: [PATCH] ring-buffer: fix build error
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix:

 kernel/trace/ring_buffer.c: In function ‘rb_allocate_pages’:
 kernel/trace/ring_buffer.c:235: error: ‘cpu’ undeclared (first use in this function)
 kernel/trace/ring_buffer.c:235: error: (Each undeclared identifier is reported only once
 kernel/trace/ring_buffer.c:235: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9814571..54a3098 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -232,7 +232,7 @@ static int rb_allocate_pages(struct ring_buffer_per_cpu *cpu_buffer,
 
 	for (i = 0; i < nr_pages; i++) {
 		page = kzalloc_node(ALIGN(sizeof(*page), cache_line_size()),
-				    GFP_KERNEL, cpu_to_node(cpu));
+				    GFP_KERNEL, cpu_to_node(i));
 		if (!page)
 			goto free_pages;
 		list_add(&page->list, &pages);
