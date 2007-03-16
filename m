Return-Path: <linux-kernel-owner+w=401wt.eu-S965925AbXCPVAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965925AbXCPVAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965926AbXCPVAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:00:08 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41283 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965930AbXCPVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:00:05 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Dave Hansen <hansendc@us.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@mbligh.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu>
	 <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
	 <45F96B57.10206@mbligh.org>
	 <Pine.LNX.4.64.0703150858040.3816@woody.linux-foundation.org>
	 <20070315160648.GA11812@one.firstfloor.org>
	 <1173977264.7922.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0703152123480.29284@schroedinger.engr.sgi.com>
	 <20070316114415.GA26403@one.firstfloor.org>
	 <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 13:59:50 -0700
Message-Id: <1174078790.26166.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 13:15 -0700, Christoph Lameter wrote:
> On Fri, 16 Mar 2007, Andi Kleen wrote:
> > > x86_64 is going to acquire more functionality that will not be available 
> > > for i386. We plan f.e. to add virtual memmap support for x86_64. Virtual 
> > 
> > What advantage would that have over the current setup?
> > We already should handle holes between nodes reasonably efficiently
> > and with nonlinear memory even holes inside nodes shouldn't be a problem.
> 
> It is primarily a performance improvement since the sparsemem table 
> lookups would no longer be necessary and it also streamlines other 
> frequent cacheline uses. These page -> page_struct and vice versa 
> operations are key to the performance of various subsystem among them 
> the slab allocator.

Hi Christoph,

Yeah, those are horribly common operations.  But, have we actually
quantified how sparsemem hurts here?  I know that it look on the surface
like those lookups should kill you but, as far as I can tell, we've
never been able to show that they actually do.  We were worried on the
NUMAQ that we would see some performance regressions, but it somehow
slightly outperformed discontigmem.

Do you have any hard data that shows vmemmap killing sparsemem on some
of your workloads?  I'd love to try and fix some of the issues if we can
dig them up.

One of the reasons I really like sparsemem is that ports to new
architectures are something like 100 lines of code, including all of the
#defines.  It's really ridiculously easy to do.  One of the things that
I really worry about for vmemmap implementations is how complicated they
get to implement.  The fact that we can't easily do it for both i386 and
x86_64 at the same time speaks to this a bit.

-- Dave

