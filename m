Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019Ab0AHTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0AHTnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977Ab0AHTnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:43:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941Ab0AHTnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:43:08 -0500
Date: Fri, 8 Jan 2010 11:42:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001081137210.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001081139490.7821@localhost.localdomain>
References: <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain> <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain>
 <1262969610.4244.36.camel@laptop> <alpine.LFD.2.00.1001080911340.7821@localhost.localdomain> <alpine.DEB.2.00.1001081138260.23727@router.home> <87my0omo3n.fsf@basil.nowhere.org> <alpine.DEB.2.00.1001081255100.26886@router.home>
 <alpine.LFD.2.00.1001081102120.7821@localhost.localdomain> <20100108192815.GB14141@basil.fritz.box> <alpine.LFD.2.00.1001081137210.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jan 2010, Linus Torvalds wrote:
> 
> Another fact is simply that you shouldn't write your app so that it needs 
> to do millions of page faults per second.

Side note: an app with lots of threads, and that needs to fault in lots of 
pages at startup time, and has performance problems, can - and should - 
likely use interfaces that are _designed_ for that.

There's things like madvise(WILLNEED) etc, which can batch up the filling 
of a memory area.

If you're doing a performance-sensitive application with hundreds of 
threads, and hundreds of gigabytes of data, you had better know about 
simple concepts like "batch fill", rather than whine about "oh my, my 
totally special-case app takes a few seconds to start because I'M A 
F*CKING MORON AND DID EVERYTHING WRONG".



			Linus
