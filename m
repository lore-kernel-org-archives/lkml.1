Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXCWKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXCWKkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422782AbXCWKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:40:46 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:37820 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422778AbXCWKkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:40:46 -0400
Date: Fri, 23 Mar 2007 11:40:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-Id: <20070323114047.b60f2acc.dada1@cosmosbay.com>
In-Reply-To: <20070323103243.GE11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de>
	<20070323100418.GA30740@elte.hu>
	<20070323103243.GE11577@wotan.suse.de>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 11:32:44 +0100
Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Implement queued spinlocks for i386. [...]
> > 
> > isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
> > but it might be a worry for the rest of the world ;-)
> 
> Hmm, it looks like they have implemented a system where the spinning
> cpu sleeps on a per-CPU variable rather than the lock itself, and
> the releasing cpu writes to that variable to wake it.  They do this
> so that spinners don't continually perform exclusive->shared
> transitions on the lock cacheline. They call these things queued
> spinlocks.  They don't seem to be very patent worthy either, but
> maybe it is what you're thinking of?
> 
> I'm not as concerned about the contended performance of spinlocks
> for Linux as MS seems to be for windows (they seem to be very proud
> of this lock). Because if it is a big problem then IMO it is a bug.
> 
> This was just something I had in mind when the hardware lock
> starvation issue came up, so I thought I should quickly code it up
> and RFC...  actually it makes contended performance worse, but I'm
> not too worried about that because I'm happy I was able to implement
> it without increasing data size or number of locked operations.

Sure, but please note that you should rename your patch to :

"Implement queued spinlocks for i486"

:)
