Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZCFC0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZCFC0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 21:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZCFC0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 21:26:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCFC0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 21:26:16 -0500
Date: Thu, 5 Mar 2009 21:26:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Larry Woodman <lwoodman@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [Patch] mm tracepoints
In-Reply-To: <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0903052124240.14535@gandalf.stny.rr.com>
References: <1233306324.11332.11.camel@nigel-laptop> <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com> <20090306105627.3EF0.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Mar 2009, KOSAKI Motohiro wrote:

> > I've implemented several mm tracepoints to track page allocation and
> > freeing, various types of pagefaults and unmaps, and critical page
> > reclamation routines.  This is useful for debugging memory allocation
> > issues and system performance problems under heavy memory loads:
> > 
> > # tracer: mm
> > #
> > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > #              | |       |          |         |
> >          pdflush-624   [004]   184.293169: wb_kupdate:
> > (mm_pdflush_kupdate) count=3e48
> >          pdflush-624   [004]   184.293439: get_page_from_freelist:
> > (mm_page_allocation) pfn=447c27 zone_free=1940910
> >         events/6-33    [006]   184.962879: free_hot_cold_page:
> > (mm_page_free) pfn=44bba9
> >       irqbalance-8313  [001]   188.042951: unmap_vmas:
> > (mm_anon_userfree) mm=ffff88044a7300c0 address=7f9a2eb70000 pfn=24c29a
> >              cat-9122  [005]   191.141173: filemap_fault:
> > (mm_filemap_fault) primary fault: mm=ffff88024c9d8f40 address=3cea2dd000
> > pfn=44d68e
> >              cat-9122  [001]   191.143036: handle_mm_fault:
> > (mm_anon_fault) mm=ffff88024c8beb40 address=7fffbde99f94 pfn=24ce22
> > ...
> 
> Hi Larry,
> 
> I've started to evaluate your patch.
> 
> firstly, this patch can't apply tip/master.
> secondly, I don't think the address of mm_struct and pfn help to analysis.
> administrator don't know the page is which file's cache.

The mm_struct may not be helpful since there should be a 1 to 1 mapping 
between user tasks and the mm struct. Hmm, maybe not, due to threads?

But the pfn is helpful since it is a unique identifier for what physical 
page was mapped.

-- Steve

