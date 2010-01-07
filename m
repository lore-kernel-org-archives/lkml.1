Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367Ab0AGUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0AGUOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154Ab0AGUOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:14:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab0AGUOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:14:15 -0500
Date: Thu, 7 Jan 2010 12:13:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001071207040.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001071208550.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105054536.44bf8002@infradead.org>  <alpine.DEB.2.00.1001050916300.1074@router.home>  <20100105192243.1d6b2213@infradead.org>  <alpine.DEB.2.00.1001071007210.901@router.home>
  <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <1262884960.4049.106.camel@laptop> <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain> <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain> <alpine.LFD.2.00.1001071031440.7821@localhost.localdomain>
 <alpine.DEB.2.00.1001071308320.2981@router.home> <alpine.LFD.2.00.1001071207040.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> Again, it doesn't matter. Old or new - if some other thread looks up the 
> vma, either is fine.

Btw, don't get me wrong. That patch may compile (I checked it), but I am 
not in any way claiming that it is anything else than a total throw-away 
"this is something we could look at doing" suggestion.

For example, I'm not at all wedded to using 'mm->page_table_lock': I in 
fact wanted to use a per-vma lock, but I picked a lock we already had. The 
fact that picking a lock we already had also means that it serializes page 
table updates (sometimes) is actually a downside, not a good thing. 

So the patch was meant to get people thinking about alternatives, rather 
than anything else.

The point being that there are things we can play with on mmap_sem, that 
don't involve getting rid of it - just being a bit more aggressive in how 
we use it.

			Linus
