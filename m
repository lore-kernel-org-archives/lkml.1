Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYGaWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYGaWCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbYGaWBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:01:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50241 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682AbYGaWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:01:34 -0400
Date: Thu, 31 Jul 2008 22:57:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       vatsa@linux.vnet.ibm.com, efault@gmx.de, linux-kernel@vger.kernel.org,
       Bill Gatliff <bgat@billgatliff.com>
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Message-ID: <20080731215703.GA5392@flint.arm.linux.org.uk>
References: <20080729223105.GK10982@flint.arm.linux.org.uk> <20080729154605.d540cf6d.akpm@linux-foundation.org> <20080731213741.GJ2729@elte.hu> <1217540875.8157.105.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217540875.8157.105.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 11:47:55PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-07-31 at 23:37 +0200, Ingo Molnar wrote:
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Tue, 29 Jul 2008 23:31:05 +0100
> > > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > > 
> > > > But then some bright spark thought it would be a good idea to get
> > > > rid of printk_clock().
> > > 
> > > <does git-log, searches for printk_clock>
> > 
> > i think this is a fresh regression via the introduction of 
> > kernel/sched_clock.c. We lost the (known) early-init behavior of 
> > cpu_clock() in the !UNSTABLE_SCHED_CLOCK case. The fix would be to 
> > restore that, not to reintroduce printk_clock().
> > 
> > Peter, any ideas?
> 
> How about something like this, it builds an atificial delay, exactly
> like we already have for the HAVE_UNSTABLE_SCHED_CLOCK case.
> 
> This keeps cpu_clock() 0 until after sched_clock_init().
> 
> Russell, Bill, is this sufficient?

It looks like it should.  Bill - can you test the patch in Peter's mail
please?

Thanks.
