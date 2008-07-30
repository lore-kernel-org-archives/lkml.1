Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYG3H4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYG3H4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYG3H4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:56:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:53368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYG3H4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:56:17 -0400
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks
	PXA270 (at least)?
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, vatsa@linux.vnet.ibm.com,
       efault@gmx.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1217401810.6364.3.camel@twins>
References: <20080729223105.GK10982@flint.arm.linux.org.uk>
	 <20080729154605.d540cf6d.akpm@linux-foundation.org>
	 <20080729225623.GO10982@flint.arm.linux.org.uk>
	 <1217401810.6364.3.camel@twins>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 09:55:54 +0200
Message-Id: <1217404554.6364.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 09:10 +0200, Peter Zijlstra wrote:
> On Tue, 2008-07-29 at 23:56 +0100, Russell King - ARM Linux wrote:
> > On Tue, Jul 29, 2008 at 03:46:05PM -0700, Andrew Morton wrote:
> > > On Tue, 29 Jul 2008 23:31:05 +0100
> > > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > 
> > > > But then some bright spark thought it would be a good idea to get
> > > > rid of printk_clock().
> > > 
> > > <does git-log, searches for printk_clock>
> > > 
> > >   commit 86faf39d0fc04272b05fab1db6d683f3ac7199d1
> > >   Author: Ingo Molnar <mingo@elte.hu>
> > >   Date:   Fri Jan 25 21:07:59 2008 +0100
> > >   
> > >       sched: remove printk_clock references from ia64
> > >       
> > >       remove remaining printk_clock references from ia64.
> > >       
> > >       Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > >   
> > >   commit b842271fbb9c8b5fd0e1c3e1895a3b67ba5bcc54
> > >   Author: Ingo Molnar <mingo@elte.hu>
> > >   Date:   Fri Jan 25 21:07:59 2008 +0100
> > >   
> > >       sched: remove printk_clock()
> > >       
> > >       printk_clock() is obsolete - it has been replaced with cpu_clock().
> > >       
> > >       Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > >   
> > > 
> > > That's it?  It rates a 0.5/10 for changelogging :(
> > > 
> > > Looking further on...
> > > 
> > >   commit e97126cd9056b3b42cdc862ace2ed66f8026f55b
> > >   Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> > >   Date:   Mon Jan 8 19:49:12 2007 +0000
> > >   
> > >       [ARM] Provide basic printk_clock() implementation
> > >       
> > >       Current sched_clock() implementations on ARM cause unbootable kernels
> > >       with PRINTK_TIME support enabled.  To avoid this, provide a basic
> > >       printk_clock() implementation which avoids sched_clock() being called
> > >       before the page tables have been set up.
> > >   
> > > 
> > > which I assume is why arm is crashing again?
> > 
> > Precisely - Ingo has effectively progressively backed out my bug fix
> > in a round-about manner by making printk require a working sched_clock
> > again.
> > 
> > > Really, I think arch-overrideable printk_clock() was a good idea. 
> > > printk is just _special_.  It's called wildly early and it is called in
> > > all conceivable contexts and it just must work no matter what.  It's
> > > totally understandable that an architecture would need to override
> > > printk's timestamp generator.
> > 
> > That's one solution, the other is to have that commit reverted.  I
> > don't really mind which, only that we have a solution ASAP so that
> > the current popular ARM SoCs have a bootable kernel again.
> 
> Can't you make sched_clock() return 0 when its called before its up and
> running? Otherwise - 

> perhaps you can play with the location of
> sched_clock_init(). cpu_clock() will return 0 before that.

Sorry - that's only relevant for HAVE_UNSTABLE_SCHED_CLOCK and x86 seems
to be the only one using that (which just shows the platforms quality
</sarcasm>).



