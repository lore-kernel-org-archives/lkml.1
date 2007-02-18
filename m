Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbXBRRUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbXBRRUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXBRRUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:20:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXBRRUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:20:46 -0500
Date: Sun, 18 Feb 2007 18:20:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jeff Muizelaar <jeff@infidigm.net>, linux-kernel@vger.kernel.org
Subject: Re: Using sched_clock for mmio-trace
Message-ID: <20070218172043.GA7340@one.firstfloor.org>
References: <20070216013024.GA32287@infidigm.net> <y0mr6sq2hfj.fsf@ton.toronto.redhat.com> <p73fy95g99w.fsf@bingen.suse.de> <20070216212630.GC27135@redhat.com> <20070217145655.GA15662@one.firstfloor.org> <1171725598.30834.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171725598.30834.125.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 04:19:58PM +0100, Thomas Gleixner wrote:
> On Sat, 2007-02-17 at 15:56 +0100, Andi Kleen wrote:
> > > This is one of the reasons why we don't just use good old
> > > do_gettimeofday(), since it takes locks and can lead to lock recursion
> > > if parts of itself are probed.
> > 
> > do_gettimeofday doesn't take locks.
> > 
> > Only restriction is that you can't single step it with long 
> > pauses between instructions.
> 
> Err, it uses read side of xtime lock, so you can not call it from a
> place which write locks xtime lock.

Err, you can -- seqlocks never deadlock.

The only thing that doesn't work is to single step with long enough
pauses with interrupts on inbetween that the sequence numbers increase:
you get a livelock then.

-Andi
