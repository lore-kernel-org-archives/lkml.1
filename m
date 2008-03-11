Return-Path: <linux-kernel-owner+w=401wt.eu-S1756295AbYCKLqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbYCKLqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYCKLql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:46:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42040 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYCKLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:46:40 -0400
Date: Tue, 11 Mar 2008 12:48:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for pageattr-test.c
Message-ID: <20080311114832.GE18917@one.firstfloor.org>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org> <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 12:41:13PM +0100, Thomas Gleixner wrote:
> 
> 
> On Tue, 11 Mar 2008, Andi Kleen wrote:
> 
> > On Tue, Mar 11, 2008 at 09:25:21AM +0100, Thomas Gleixner wrote:
> > > On Tue, 11 Mar 2008, Andi Kleen wrote:
> > > > Use an own random generator for pageattr-test.c
> > > > 
> > > > [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> > > > candidate because it fixes a subtle bug]
> > > 
> > > Care to point out which "subtle bug" is fixed ? 
> > > 
> > > You replace a random generator by another to get repeateable
> > > sequences. The non repeatability of the cpa test patterns is hardly a
> > > "subtle bug".
> > 
> > The subtle bug(s) are first that it is not repeatable (it really should),
> 
> As I said before. It's hardly a bug. In fact it is questionable
> whether fully reproducible test patterns are desired.

Ok then you won't be able to repeat the test ever.

I consider this bad practice in test code because it makes it impossible
to stabilize bugs and when I wrote it I tried to avoid by using the 
srandom32(). But I originally fell into the trap of assuming it had the 
same semantics of stdlib srandom() which it didn't. This patch was
my attempt to fix that mistake.

> 
> > then that it only initializes the CPU where the code first runs
> > (since srandom32 is per CPU) and later might change CPUs and then that it 
> > adds totally unnecessary state bits to CPU #0 (or whatever runs first).
> 
> Can you please elaborate why changing the seed of the random generator
> is a bug ? Networking reseeds the random generator itself, so what ?

It adds a non random seed which does not add any randomness only to CPU #0.
Strictly it doesn't hurt very much, but it's also not useful for anything.

-Andi

