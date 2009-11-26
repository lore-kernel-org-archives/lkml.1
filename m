Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbZKZH6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbZKZH6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbZKZH6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:58:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43198 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759136AbZKZH6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:58:08 -0500
Date: Thu, 26 Nov 2009 08:57:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/9] tracing: Convert some kmem events to DEFINE_EVENT
Message-ID: <20091126075758.GA8011@elte.hu>
References: <4B0E2807.4060102@cn.fujitsu.com>
 <4B0E286A.2000405@cn.fujitsu.com>
 <4B0E2D3A.1030509@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0E2D3A.1030509@cs.helsinki.fi>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Li Zefan kirjoitti:
> >Use TRACE_EVENT_TEMPLATE to remove duplicate code:
> >
> >   text    data     bss     dec     hex filename
> > 333987   69800   27228  431015   693a7 mm/built-in.o.old
> > 330030   69800   27228  427058   68432 mm/built-in.o
> >
> >8 events are converted:
> >
> >  kmem_alloc: kmalloc, kmem_cache_alloc
> >  kmem_alloc_node: kmalloc_node, kmem_cache_alloc_node
> >  kmem_free: kfree, kmem_cache_free
> >  mm_page: mm_page_alloc_zone_locked, mm_page_pcpu_drain
> >
> >Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> I have no idea what TRACE_EVENT_TEMPLATE is [...]

See these recent commits in tip:perf/core:

 75ec29a: tracing: Convert some sched trace events to DEFINE_EVENT and _PRINT
 e5bc972: tracing: Create new DEFINE_EVENT_PRINT
 ff038f5: tracing: Create new TRACE_EVENT_TEMPLATE

This introduces the new TRACE_EVENT_TEMPLATE + DEFINE_EVENT construct 
that allows one to 'clone' existing tracepoints into a new tracepoint 
that have the same parameters/format but differing callsites.

The existing TRACE_EVENT construct is there too (unchanged), it's 
equivalent to TRACE_EVENT_TEMPLATE()+DEFINE_EVENT().

It basically introduces a 'class'/'template' of tracepoints - which can 
then be used to create real tracepoints.

Btw., the fact that it wasnt entirely obvious for you from the patch 
what it does, there's one rename we should do, to have more consistent 
and more self-explanatory naming:

  DECLARE_EVENT_CLASS(class)

    DEFINE_EVENT(class, event1)
    DEFINE_EVENT(class, event2)
    DEFINE_EVENT(class, event3)

  DEFINE_SINGLE_EVENT(single_event)

Naming the 'standalone' variant like that signals this difference and 
encourages people to create classes/groups of events instead of creating 
many singular events.

> [...] but the space savings are convincing enough! I assume this is 
> going into -tip?

Yeah, tip:perf/core, with your ack.

> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks,

	Ingo
