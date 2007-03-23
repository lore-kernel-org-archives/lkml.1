Return-Path: <linux-kernel-owner+w=401wt.eu-S934273AbXCWKcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934273AbXCWKcq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 06:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934279AbXCWKcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 06:32:46 -0400
Received: from mail.suse.de ([195.135.220.2]:42490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934273AbXCWKcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 06:32:45 -0400
Date: Fri, 23 Mar 2007 11:32:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [rfc][patch] queued spinlocks (i386)
Message-ID: <20070323103243.GE11577@wotan.suse.de>
References: <20070323085910.GA11577@wotan.suse.de> <20070323100418.GA30740@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323100418.GA30740@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:04:18AM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Implement queued spinlocks for i386. [...]
> 
> isnt this patented by MS? (which might not worry you SuSE/Novell guys, 
> but it might be a worry for the rest of the world ;-)

Hmm, it looks like they have implemented a system where the spinning
cpu sleeps on a per-CPU variable rather than the lock itself, and
the releasing cpu writes to that variable to wake it.  They do this
so that spinners don't continually perform exclusive->shared
transitions on the lock cacheline. They call these things queued
spinlocks.  They don't seem to be very patent worthy either, but
maybe it is what you're thinking of?

I'm not as concerned about the contended performance of spinlocks
for Linux as MS seems to be for windows (they seem to be very proud
of this lock). Because if it is a big problem then IMO it is a bug.

This was just something I had in mind when the hardware lock
starvation issue came up, so I thought I should quickly code it up
and RFC...  actually it makes contended performance worse, but I'm
not too worried about that because I'm happy I was able to implement
it without increasing data size or number of locked operations.
