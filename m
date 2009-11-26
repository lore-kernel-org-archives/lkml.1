Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbZKZI3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbZKZI3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759733AbZKZI3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:29:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58713 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759610AbZKZI3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:29:41 -0500
Subject: Re: [PATCH 2/9] tracing: Convert some kmem events to DEFINE_EVENT
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20091126075758.GA8011@elte.hu>
References: <4B0E2807.4060102@cn.fujitsu.com>
	 <4B0E286A.2000405@cn.fujitsu.com> <4B0E2D3A.1030509@cs.helsinki.fi>
	 <20091126075758.GA8011@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 03:29:46 -0500
Message-Id: <1259224186.21397.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 08:57 +0100, Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > Li Zefan kirjoitti:
> > >Use TRACE_EVENT_TEMPLATE to remove duplicate code:
> > >
> > >   text    data     bss     dec     hex filename
> > > 333987   69800   27228  431015   693a7 mm/built-in.o.old
> > > 330030   69800   27228  427058   68432 mm/built-in.o
> > >
> > >8 events are converted:
> > >
> > >  kmem_alloc: kmalloc, kmem_cache_alloc
> > >  kmem_alloc_node: kmalloc_node, kmem_cache_alloc_node
> > >  kmem_free: kfree, kmem_cache_free
> > >  mm_page: mm_page_alloc_zone_locked, mm_page_pcpu_drain
> > >
> > >Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > I have no idea what TRACE_EVENT_TEMPLATE is [...]

> 
> Btw., the fact that it wasnt entirely obvious for you from the patch 
> what it does, there's one rename we should do, to have more consistent 
> and more self-explanatory naming:
> 
>   DECLARE_EVENT_CLASS(class)
> 
>     DEFINE_EVENT(class, event1)
>     DEFINE_EVENT(class, event2)
>     DEFINE_EVENT(class, event3)
> 
>   DEFINE_SINGLE_EVENT(single_event)
> 
> Naming the 'standalone' variant like that signals this difference and 
> encourages people to create classes/groups of events instead of creating 
> many singular events.

I'm not really attached to the names, but I wouldn't go by it not being
obvious for Pekka as a reason for changing it. In the context of the
change log, if it were to say:

>Use DECLARE_EVENT_CLASS to remove duplicate code:
>
>   text    data     bss     dec     hex filename
> 333987   69800   27228  431015   693a7 mm/built-in.o.old
> 330030   69800   27228  427058   68432 mm/built-in.o
>
>8 events are converted:
>
>  kmem_alloc: kmalloc, kmem_cache_alloc
>  kmem_alloc_node: kmalloc_node, kmem_cache_alloc_node
>  kmem_free: kfree, kmem_cache_free
>  mm_page: mm_page_alloc_zone_locked, mm_page_pcpu_drain
>

I'm not sure it would make it any more obvious to what the
class/template does. ;-)

-- Steve


