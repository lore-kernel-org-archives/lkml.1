Return-Path: <linux-kernel-owner+w=401wt.eu-S935993AbXHNX3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935993AbXHNX3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936102AbXHNX2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:28:40 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:59283 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936067AbXHNX2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:28:38 -0400
Date: Tue, 14 Aug 2007 16:28:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Chris Snook <csnook@redhat.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
Message-ID: <20070814232835.GH8243@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com> <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com> <46C2325C.8040900@redhat.com> <Pine.LNX.4.64.0708141555300.579@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141555300.579@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 03:56:51PM -0700, Christoph Lameter wrote:
> On Tue, 14 Aug 2007, Chris Snook wrote:
> 
> > > volatile means that there is some vague notion of "read it now". But that
> > > really does not exist. Instead we control visibility via barriers (smp_wmb,
> > > smp_rmb). Would it not be best to not have volatile at all in atomic
> > > operations and let the barriers do the work?
> > 
> > From my reply in the other thread...
> > 
> > But barriers force a flush of *everything* in scope, which we generally don't
> > want.  On the other hand, we pretty much always want to flush atomic_*
> > operations.  One way or another, we should be restricting the volatile
> > behavior to the thing that needs it.  On most architectures, this patch set
> > just moves that from the declaration, where it is considered harmful, to the
> > use, where it is considered an occasional necessary evil.
> > 
> > If you really, *really* distrust the compiler that much, you shouldn't be
> > using barrier, since that uses volatile under the hood too.  You should just
> > go ahead and implement the atomic operations in assembler, like Segher
> > Boessenkool did for powerpc in response to my previous patchset.
> 
> >From my reply on the other thread:
> 
> Maybe we need two read functions? One volatile, one not?
> 
> The atomic_read()s that I have in slub really do not care about when the 
> variables are read. And if volatile creates overhead then I rather not have it.


The overhead due to volatile access is -way- small.  Not like barrier(),
which can flush out a fair fraction of the machine registers.

						Thanx, Paul
