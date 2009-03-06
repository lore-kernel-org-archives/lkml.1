Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZCFVRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZCFVRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZCFVR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:17:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZCFVR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:17:27 -0500
Date: Fri, 6 Mar 2009 13:16:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Woodman <lwoodman@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       peterz@infradead.org, fweisbec@gmail.com, linux-mm@kvack.org
Subject: Re: [Patch] mm tracepoints
Message-Id: <20090306131603.8cf0ab22.akpm@linux-foundation.org>
In-Reply-To: <1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
References: <497DD8E5.1040305@nortel.com>
	<20090126075957.69b64a2e@infradead.org>
	<497F5289.404@nortel.com>
	<m1vds0bj2j.fsf@fess.ebiederm.org>
	<20090128193813.GD1222@ucw.cz>
	<1233306324.11332.11.camel@nigel-laptop>
	<1236291400.1476.50.camel@dhcp-100-19-198.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Mar 2009 17:16:40 -0500
Larry Woodman <lwoodman@redhat.com> wrote:

> I've implemented several mm tracepoints to track page allocation and
> freeing, various types of pagefaults and unmaps, and critical page
> reclamation routines.  This is useful for debugging memory allocation
> issues and system performance problems under heavy memory loads:
> 
> # tracer: mm
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>          pdflush-624   [004]   184.293169: wb_kupdate:
> (mm_pdflush_kupdate) count=3e48
>          pdflush-624   [004]   184.293439: get_page_from_freelist:
> (mm_page_allocation) pfn=447c27 zone_free=1940910
>         events/6-33    [006]   184.962879: free_hot_cold_page:
> (mm_page_free) pfn=44bba9
>       irqbalance-8313  [001]   188.042951: unmap_vmas:
> (mm_anon_userfree) mm=ffff88044a7300c0 address=7f9a2eb70000 pfn=24c29a
>              cat-9122  [005]   191.141173: filemap_fault:
> (mm_filemap_fault) primary fault: mm=ffff88024c9d8f40 address=3cea2dd000
> pfn=44d68e
>              cat-9122  [001]   191.143036: handle_mm_fault:
> (mm_anon_fault) mm=ffff88024c8beb40 address=7fffbde99f94 pfn=24ce22
> ...

I'm struggling to think of any memory management problems which this
facility would have helped us solve.  Single-page tracing like this
isn't very interesting or useful.

What we generally are looking for when resolving MM
performance/correctness problems is a representation/visualisation of
aggregated results over a period of time.  That means synchronous or
downstream processing of large amounts of bulk data.

Now, possibly the above information could be used to generate the
needed information.  But the above rather random-looking and chaotic
data output would make it very hard to develop the needed
aggregation/representation tools.

And unless someone actually develops those tools (which is a lot of
work), there isn't much point in adding the kernel infrastructure to
generate the data for the non-existing tool.

I haven't looked at LTT in a while.  What sort of information does it
extract from the MM system?  Is it useful to MM developers?  If so, can
this newly-proposed facility do the same thing?


How about a test case - how could this patch help us (and our testers)
make some progress with the infamous
http://bugzilla.kernel.org/show_bug.cgi?id=12309 ?


Then again, maybe I'm wrong!  Maybe MM developers _do_ believe that
this tool would assist them in their work.  Given that MM develoeprs
are the target market for this feature, it would be sensible to cc the
linux-mm list, methinks?

