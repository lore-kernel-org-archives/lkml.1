Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYCKLmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYCKLmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 07:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYCKLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 07:42:09 -0400
Received: from www.tglx.de ([62.245.132.106]:33795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbYCKLmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 07:42:08 -0400
Date: Tue, 11 Mar 2008 12:41:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for
 pageattr-test.c
In-Reply-To: <20080311104531.GB18917@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Mar 2008, Andi Kleen wrote:

> On Tue, Mar 11, 2008 at 09:25:21AM +0100, Thomas Gleixner wrote:
> > On Tue, 11 Mar 2008, Andi Kleen wrote:
> > > Use an own random generator for pageattr-test.c
> > > 
> > > [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> > > candidate because it fixes a subtle bug]
> > 
> > Care to point out which "subtle bug" is fixed ? 
> > 
> > You replace a random generator by another to get repeateable
> > sequences. The non repeatability of the cpa test patterns is hardly a
> > "subtle bug".
> 
> The subtle bug(s) are first that it is not repeatable (it really should),

As I said before. It's hardly a bug. In fact it is questionable
whether fully reproducible test patterns are desired.

> then that it only initializes the CPU where the code first runs
> (since srandom32 is per CPU) and later might change CPUs and then that it 
> adds totally unnecessary state bits to CPU #0 (or whatever runs first).

Can you please elaborate why changing the seed of the random generator
is a bug ? Networking reseeds the random generator itself, so what ?

Thanks,
	tglx
