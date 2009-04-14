Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbZDNSQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbZDNSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZDNSQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:16:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56619 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbZDNSQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:16:15 -0400
Date: Tue, 14 Apr 2009 20:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090414181516.GA19814@elte.hu>
References: <20090414172337.280621613@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414172337.280621613@goodmis.org>
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

> Ingo,
> 
> This is the long awaited TRACE_EVENT for modules patch series.
> 
> Not only does it allow for modules to use the TRACE_EVENT 
> infrastructure, but it also cleans up the way TRACE_EVENTS are 
> used in core kernel code.

Really impressive!

I've got a small testing hickup with it:

  In file included from include/trace/lockdep.h:60,
                   from kernel/lockdep.c:51:
  include/trace/define_trace.h:57:43: error: trace/lock.h: No such file or directory

The patch below fixes it.

	Ingo

Index: linux/include/trace/lockdep.h
===================================================================
--- linux.orig/include/trace/lockdep.h
+++ linux/include/trace/lockdep.h
@@ -5,7 +5,7 @@
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
-#define TRACE_SYSTEM lock
+#define TRACE_SYSTEM lockdep
 
 #ifdef CONFIG_LOCKDEP
 
