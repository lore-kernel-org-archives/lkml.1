Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbYCOWAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbYCOWAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYCOWAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:00:17 -0400
Received: from phunq.net ([64.81.85.152]:59030 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754321AbYCOWAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:00:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sat, 15 Mar 2008 14:00:05 -0800
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803151417.13899.phillips@phunq.net> <20080315210308.72824eb3@the-village.bc.nu>
In-Reply-To: <20080315210308.72824eb3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803151500.05993.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 14:03, Alan Cox wrote:
> > > RAID controllers do not have half a terabyte of RAM.
> > 
> > And?  Either you have battery backed ram with critical data in it or
> > you do not.  Exactly how much makes little difference to the question.
> 
> It makes a lot of difference,

It makes a difference of degree, not of kind.

> and in addition raid controllers (good 
> ones) respect barrier ordering in their RAM cache so they'll take tags or
> similar interfaces and honour them.

Ramback should obviously respect barriers, and it does, though at
present only in the crude, default way of letting the block layer
handle it.

But interpreting a barrier to mean flush through to rotating media...
performance will drop to the millisecond per transaction zone, like a
normal disk.  Not what ramback users want in normal operating mode.
Flush mode, yes.

Even raid controllers... so you agree that some of them just don't
respond conservatively to tagged commands, either because the engineers
don't know how to implement that (unlikely) or because they want to win
the performance benchmarks, and they do trust their battery?

"Some raid controllers" is just as good for my argument as "all raid
controllers".  Nobody is telling you which raid controller to use in
your own personal system.  I will pick the fast one and you can pick
the slow one that does not trust its own battery circuits.

> > That is why I keep recommending that a ramback setup be replicated or
> > mirrored, which people in this thread keep glossing over.  When
> > replicated or mirrored, you still get the microsecond-level transaction
> > times, and you get the safety too.
> 
> Either you keep a mirror in sync and get normal data rates or you keep
> the mirror out of sync and then you need to sort your writeback process
> out to preserve ordering.
> 
> If you want ramback to be taken seriously then that is the interesting
> problem to solve and clearly has multiple solutions if you would start to
> take an objective look at your work.

Ramback already is taken seriously, just not by you.  That is fine, you
apparently do not need or want the speed.

Anyway, please do not get the impression that I am ignoring your ideas.
There are some nice, intermediate modes that ramback could and in my
opinion, should implement, to give users more options on how to trade
off performance against resilience.  I just need to make it clear that
ramback, as conceived, already gives system builders the capability
they need to achieve microsecond level transaction throughput and data
safety at the same time... given a reliable battery, which is where we
started.

Daniel
