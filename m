Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbZBYQVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbZBYQVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762065AbZBYQVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:21:20 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:33450 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZBYQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Yzlc9jFNJ4Q1a2F2/edoqsipYodjTND5aTKAMrb5hIxU2rIB69WSiHMNb2qmS7WtME
         mqWxyDAObIg0mbm1Wk8q1SaAsy0Cik/cNeE9Z7E43N/5xBibj23Ofd+kp4VKogj0rB+e
         ktXMkggcIH5+rkWWZZwYtG/jGJ8swZieC1WWk=
Date: Wed, 25 Feb 2009 17:21:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
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
Message-ID: <20090225162110.GB5862@nowhere>
References: <20090224194548.3effb746.akpm@linux-foundation.org> <alpine.DEB.2.00.0902242252480.12697@gandalf.stny.rr.com> <20090224203308.8d623e0b.akpm@linux-foundation.org> <20090225081118.GC15303@elte.hu> <20090225002852.5ef5b869.akpm@linux-foundation.org> <84144f020902250100k41e55dd7w8a9c8d2ca96908ea@mail.gmail.com> <20090225012250.db68e480.akpm@linux-foundation.org> <1235554387.3849.30.camel@penberg-laptop> <20090225014442.7b7b7726.akpm@linux-foundation.org> <20090225095623.GB12352@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225095623.GB12352@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 10:56:23AM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Plus...  it's all English-only.
> 
> Note that with bin+raw output you can already internationalize 
> tracepoints, if you want to.
> 
> I havent seen much interest in that, and the default tracing 
> output is in English indeed, and the reason is rather 
> fundamental: currently we've got 60,000+ kernel function 
> symbols, 99% of which are in English.


Neither do I use the raw/bin formats from ftrace personally, but
they are used by automated tools such as userspace side sysprof,
blktrace, ...

Frederic.

 
> Do you argue for them to be converted to some i8n format so that 
> the trace output becomes readable in other languages as well? 
> 
> I.e. do you suggest that this:
> 
> >  3)               |  handle_mm_fault() {
> >  3)               |    count_vm_event() {
> >  3)   0.243 us    |      test_ti_thread_flag();
> >  3)   0.754 us    |    }
> >  3)   0.249 us    |    pud_alloc();
> >  3)   0.251 us    |    pmd_alloc();
> >  3)               |    __do_fault() {
> >  3)               |      filemap_fault() {
> >  3)               |        find_lock_page() {
> >  3)               |          find_get_page() {
> >  3)   0.248 us    |            test_ti_thread_flag();
> >  3)   0.844 us    |          }
> >  3)   1.341 us    |        }
> >  3)   1.837 us    |      }
> >  3)   0.275 us    |	   _spin_lock();
> >  3)   0.257 us    |	   page_add_file_rmap();
> >  3)   0.233 us    |      native_set_pte_at();
> 
> and /proc/kallsysms to be internationalized? Should all oopses 
> and warnings that show up in the kernel log be translated as 
> well?
> 
> I dont think it's realistic - and arguing for anything less and 
> singling out tracing would be a double standard.
> 
> Currently being able to understand and hack the kernel means 
> being able to read some English - and the same holds for trace 
> output as well.
> 
> The default output of traces is just a mirror image of what is 
> the kernel status quo. If the kernel gets internationalized so 
> will ftrace be internationalized too.
> 
> > > So if you're arguing against specific ftrace plugins, go 
> > > ahead (you probably have a fair point there). But please 
> > > don't dismiss the while _concept_ of ftrace because of them.
> > 
> > Where on earth did that come from?
> > 
> > What I'm arguing against is putting English-only 
> > pretty-printers and pretty-parsers on wrong side of int 80.  
> > That's all.
> 
> Since the concept of a kernel tracing facility being 
> self-sufficient and being easy to use is an integral and key 
> concept to ftrace, dont you see why people take your suggestions 
> as a dismissal of the ftrace concept?
> 
> 	Ingo

