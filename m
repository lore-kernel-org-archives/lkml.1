Return-Path: <linux-kernel-owner+w=401wt.eu-S965890AbXCPU0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965890AbXCPU0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965891AbXCPU0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:26:04 -0400
Received: from dvhart.com ([64.146.134.43]:49826 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965890AbXCPU0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:26:01 -0400
Message-ID: <45FAFD57.90601@mbligh.org>
Date: Fri, 16 Mar 2007 13:25:59 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org> <45F96B57.10206@mbligh.org> <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org> <20070315160648.GA11812@one.firstfloor.org> <1173977264.7922.24.camel@localhost.localdomain> <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com> <20070316114415.GA26403@one.firstfloor.org> <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 16 Mar 2007, Andi Kleen wrote:
> 
>>> x86_64 is going to acquire more functionality that will not be available 
>>> for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 
>> What advantage would that have over the current setup?
>> We already should handle holes between nodes reasonably efficiently
>> and with nonlinear memory even holes inside nodes shouldn't be a problem.
> 
> It is primarily a performance improvement since the sparsemem table 
> lookups would no longer be necessary and it also streamlines other 
> frequent cacheline uses. These page -> page_struct and vice versa 
> operations are key to the performance of various subsystem among them 
> the slab allocator.

cc: apw

You have to do some sort of lookup anyway, and Andy seemed to have them
all folded into one.

Or are you trying to avoid this by going to back to the crud we had
in 2.4 where we pretend mem_map is one big array, indexed by pfn with
huge sparsely mapped holes in it?

Would be nice to work out (and document somewhere) what the pros and
cons of virtual memmap vs sparsemem were - ISTR one of the arguments
was extremely sparsely layed out machines, and you needed sparsemem
for that. But right now we have 3 solutions, which is not a good
situation.
