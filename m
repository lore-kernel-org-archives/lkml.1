Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZFVDi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZFVDi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 23:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFVDiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 23:38:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57052 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZFVDiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 23:38:06 -0400
Date: Mon, 22 Jun 2009 12:37:09 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: [Patch] mm tracepoints update - use case.
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rostedt@goodmis.org
In-Reply-To: <1245352954.3212.67.camel@dhcp-100-19-198.bos.redhat.com>
References: <20090616170811.99A6.A69D9226@jp.fujitsu.com> <1245352954.3212.67.camel@dhcp-100-19-198.bos.redhat.com>
Message-Id: <20090622115756.21F3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Thanks for the feedback Kosaki!
> 
> 
> > Scenario 1. OOM killer happend. why? and who bring it?
> 
> Doesnt the showmem() and stack trace to the console when the OOM kill
> occurred show enough in the majority of cases?  I realize that direct
> alloc_pages() calls are not accounted for here but that can be really
> invasive.

showmem() display _result_ of memory usage and fragmentation.
but Administrator often need to know the _reason_.

Plus, kmemtrace already trace slab allocate/free activity.
You mean you think this is really invasive?


> > Scenario 2. page allocation failure by memory fragmentation
> 
> Are you talking about order>0 allocation failures here?  Most of the
> slabs are single page allocations now.

Yes, order>0.
but I confused. Why do you talk about slab, not page alloc?

Note, non-x86 architecture freqently use order-1 allocation for
making stack.



> > Scenario 3. try_to_free_pages() makes very long latency. why?
> 
> This is available in the mm tracepoints, they all include timestamps.

perhaps, no.
Administrator need to know the reason. not accumulated time. it's the result.

We can guess some reason
  - IO congestion
  - memory eating speed is fast than reclaim speed
  - memory fragmentation

but it's only guess. we often need to get data.


> > Scenario 4. sar output that free memory dramatically reduced at 10 minute ago, and
> >             it already recover now. What's happen?
> 
> Is this really important?  It would take buffering lots of data to
> figure out what happened in the past.

ok, my scenario description is a bit wrong.

if userland process explicitly  consume memory or explicitely write
many data, it is true.

Is this more appropriate?

"userland process take the same action periodically, but only 10 minute ago
free memory reduced, why?"



> >   - suspects
> >     - kernel memory leak
> 
> Other than direct callers to the page allocator isnt that covered with
> the kmemtrace stuff?

Yeah.
perhaps, kmemtrace enhance to cover page allocator is good approach.


> >     - userland memory leak
> 
> The mm tracepoints track all user space allocations and frees(perhaps
> too many?).

hmhm.


> 
> >     - stupid driver use too much memory
> 
> hopefully kmemtrace will catch this?

ditto.
I agree with kmemtrace enhancement is good idea.

> 
> >     - userland application suddenly start to use much memory
> 
> The mm tracepoints track all user space allocations and frees.

ok.


> >   - what information are valuable?
> >     - slab usage information (kmemtrace already does)
> >     - page allocator usage information
> >     - rss of all processes at oom happend
> >     - why recent try_to_free_pages() can't reclaim any page?
> 
> The counters in the mm tracepoints do give counts but not the reasons
> that the pagereclaim code fails.

That's very important key point. please don't ignore.



