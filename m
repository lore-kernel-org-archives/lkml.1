Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYCCRjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYCCRjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759154AbYCCRcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:32:05 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53107 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958AbYCCRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:32:02 -0500
Date: Mon, 3 Mar 2008 09:31:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, davem@davemloft.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [patch] Re: using long instead of atomic_t when only set/read is required
Message-ID: <20080303173157.GC12453@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080303120842.GA28369@elf.ucw.cz> <Pine.LNX.4.44L0.0803031023550.3611-100000@iolanthe.rowland.org> <20080303155330.39e45ad4@core> <200803040416.33937.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803040416.33937.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 04:16:33AM +1100, Nick Piggin wrote:
> On Tuesday 04 March 2008 02:53, Alan Cox wrote:
> > > Atomicity of reads of write for pointers and integral types (other than
> > > long long) should be documented.
> >
> > NAK.
> >
> > Atomicity of reads or writes for pointers and integral types is NOT
> > guaranteed. Gcc doesn't believe in your guarantee.
> 
> Are you sure gcc doesn't? Or is it just "C"?
> 
> Linux wouldn't work today if gcc did something non-atomic there
> (presuming you're talking about naturally aligned pointers/ints).
> It is widely used and accepted.
> 
> RCU users are far from the only places to rely on this, although
> I guess they are the main ones when it comes to assigning pointers
> atomically.

It is true that gcc can refetch pointers/ints if it runs out of registers,
which is why rcu_dereference() recently had an ACCESS_ONCE() added to it.

But such refetching cannot result in a mish-mash of two different
pointer values, confusing though it might be to the affected code.

						Thanx, Paul
