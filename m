Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbYDSHOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbYDSHOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 03:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbYDSHOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 03:14:46 -0400
Received: from www.tglx.de ([62.245.132.106]:59839 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYDSHOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 03:14:46 -0400
Date: Sat, 19 Apr 2008 09:13:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: linux-pm@lists.linux-foundation.org,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Higer latency with dynamic tick (need for an io-ondemand
 govenor?)
In-Reply-To: <200804182045.56893.david-b@pacbell.net>
Message-ID: <alpine.LFD.1.10.0804190839140.3261@apollo.tec.linutronix.de>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <1179474567.12981.53.camel@chaos> <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> <200804182045.56893.david-b@pacbell.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-307532848-1208589223=:3261"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-307532848-1208589223=:3261
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 18 Apr 2008, David Brownell wrote:
> On Friday 18 April 2008, Woodruff, Richard wrote:
> > When capturing some traces with dynamic tick we were noticing the
> > interrupt latency seems to go up a good amount. If you look at the trace
> > the gpio IRQ is now offset a good amount.  Good news I guess is its
> > pretty predictable.
> 
> That is, about 24 usec on this CPU ... an ARM v7, which I'm guessing
> is an OMAP34xx running fairly fast (order of 4x faster than most ARMs).
> 
> Similar issues were noted, also using ETM trace, on an ARM920 core [1]
> from Atmel.  There, the overhead of NO_HZ was observed to be more like
> 150 usec of per-IRQ overhead, which is enough to make NO_HZ non-viable
> in some configurations.
> 
> 
> > I was wondering what thoughts of optimizing this might be.
> 
> Cutting down the math implied by jiffies updates might help.
> The 64 bit math for ktime structs isn't cheap; purely by eyeball,
> that was almost 1/3 the cost of that 24 usec (mostly __do_div64).

Hmm, I have no real good idea to avoid the div64 in the case of a long
idle sleep. Any brilliant patches are welcome :)

Thanks,
	tglx
--8323328-307532848-1208589223=:3261--
