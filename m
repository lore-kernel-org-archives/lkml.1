Return-Path: <linux-kernel-owner+w=401wt.eu-S1762157AbZBYJ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157AbZBYJ71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762041AbZBYJ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:58:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50446 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762031AbZBYJ6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:58:43 -0500
Date: Wed, 25 Feb 2009 10:56:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] tracing: add event trace infrastructure
Message-ID: <20090225095623.GB12352@elte.hu>
References: <20090225025753.798204550@goodmis.org> <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <1235554387.3849.30.camel@penberg-laptop> <20090225014442.7b7b7726.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225014442.7b7b7726.akpm@linux-foundation.org>
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

> Plus...  it's all English-only.

Note that with bin+raw output you can already internationalize 
tracepoints, if you want to.

I havent seen much interest in that, and the default tracing 
output is in English indeed, and the reason is rather 
fundamental: currently we've got 60,000+ kernel function 
symbols, 99% of which are in English.

Do you argue for them to be converted to some i8n format so that 
the trace output becomes readable in other languages as well? 

I.e. do you suggest that this:

>  3)               |  handle_mm_fault() {
>  3)               |    count_vm_event() {
>  3)   0.243 us    |      test_ti_thread_flag();
>  3)   0.754 us    |    }
>  3)   0.249 us    |    pud_alloc();
>  3)   0.251 us    |    pmd_alloc();
>  3)               |    __do_fault() {
>  3)               |      filemap_fault() {
>  3)               |        find_lock_page() {
>  3)               |          find_get_page() {
>  3)   0.248 us    |            test_ti_thread_flag();
>  3)   0.844 us    |          }
>  3)   1.341 us    |        }
>  3)   1.837 us    |      }
>  3)   0.275 us    |	   _spin_lock();
>  3)   0.257 us    |	   page_add_file_rmap();
>  3)   0.233 us    |      native_set_pte_at();

and /proc/kallsysms to be internationalized? Should all oopses 
and warnings that show up in the kernel log be translated as 
well?

I dont think it's realistic - and arguing for anything less and 
singling out tracing would be a double standard.

Currently being able to understand and hack the kernel means 
being able to read some English - and the same holds for trace 
output as well.

The default output of traces is just a mirror image of what is 
the kernel status quo. If the kernel gets internationalized so 
will ftrace be internationalized too.

> > So if you're arguing against specific ftrace plugins, go 
> > ahead (you probably have a fair point there). But please 
> > don't dismiss the while _concept_ of ftrace because of them.
> 
> Where on earth did that come from?
> 
> What I'm arguing against is putting English-only 
> pretty-printers and pretty-parsers on wrong side of int 80.  
> That's all.

Since the concept of a kernel tracing facility being 
self-sufficient and being easy to use is an integral and key 
concept to ftrace, dont you see why people take your suggestions 
as a dismissal of the ftrace concept?

	Ingo
