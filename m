Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYHUOxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYHUOxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYHUOxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:53:39 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51799 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbYHUOxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:53:38 -0400
Date: Thu, 21 Aug 2008 07:53:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, jmerkey@wolfmountaingroup.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Howells <dhowells@redhat.com>
Subject: Re: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc4
	released
Message-ID: <20080821145333.GF6690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200808210250.m7L2obNX028353@wolfmountaingroup.com> <1219313231.8651.101.camel@twins> <48AD4A0B.8020805@s5r6.in-berlin.de> <1219316568.8651.107.camel@twins> <20080821114745.GD21089@linux.vnet.ibm.com> <1219320206.8651.116.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219320206.8651.116.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:03:26PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-08-21 at 04:47 -0700, Paul E. McKenney wrote:
> > On Thu, Aug 21, 2008 at 01:02:48PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2008-08-21 at 12:57 +0200, Stefan Richter wrote:
> > > > Peter Zijlstra wrote:
> > > > > On Wed, 2008-08-20 at 20:50 -0600, jmerkey@wolfmountaingroup.com wrote:
> > > > > 
> > > > >>  volatiles left in the code due to the previously stated
> > > > >>  (and still present) severe breakage of the GNU compiler with SMP 
> > > > >>  shared data.  most of the barrier() functions are just plain broken
> > > > >>  and do not result in proper compiler behavior in this tree. 
> > > > > 
> > > > > Can you provide explicit detail?
> > > > > 
> > > > > By using barrier() the compiler should clobber all its memory and
> > > > > registers therefore forcing a write/reload of the variable.
> > > > 
> > > > I hope Jeff didn't try mere barrier()s only.  smp_wmb() and smp_rmb()
> > > > are the more relevant barrier variants for mdb, from what I remember
> > > > when I last looked at it.
> > > 
> > > Sure, but volatile isn't a replacement for memory barriers.
> > 
> > Let's face it, the C standard does not support concurrency, so we are
> > all in a state of sin in any case, forced to rely on combinations of
> > gcc-specific non-standard language extensions and assembly language.
> 
> Hehe, still, a little birdie told me they are working on it and perhaps
> someone with clue could enlighten us on their direction.

Well, I guess you guys will be the judge of that.  Or one of the judges,
at least.  ;-)

One advantage of the current c++0x approach is that it allows extremely
weak memory barriers to be used in many cases that would require smp_rmb()
in current Linux kernel.  If you are crazy enough to want to see a
sneak preview in standardese, try all 10MB of:

	http://open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2691.pdf

Section 1.10 (physical page 25, logical page 11) describes the memory model.
Sections 29 and 30 describe the operations (physical page 1155, logical
page 1141).  The C and C++ guys got together ahead of time and agreed to
work together towards a compatible solution.

And rcu_dereference() would be implemented in terms of memory_order_consume,
for whatever that is worth.

> Still, I'd like Jeff to show his C, the resulting asm and the intent for
> the volatile and barrier versions of his code (well, little snippets of
> his code obviuosly).
> 
> Either he doesn't understand barriers (nothing to be ashamed about), or
> we might have more trouble lurking in the rest of the kernel.

Sounds fair to me!

							Thanx, Paul
