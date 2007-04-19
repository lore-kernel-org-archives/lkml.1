Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbXDSSqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbXDSSqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbXDSSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:46:21 -0400
Received: from 1wt.eu ([62.212.114.60]:2029 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXDSSqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:46:21 -0400
Date: Thu, 19 Apr 2007 20:45:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419184534.GA29096@1wt.eu>
References: <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419151803.GB30959@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 05:18:03PM +0200, Ingo Molnar wrote:
> 
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > You can certainly script it with -geometry. But it is the wrong 
> > application for this matter, because you benchmark X more than 
> > glxgears itself. What would be better is something like a line 
> > rotating 360 degrees and doing some short stuff between each degree, 
> > so that X is not much sollicitated, but the CPU would be spent more on 
> > the processes themselves.
> 
> at least on my setup glxgears goes via DRI/DRM so there's no X 
> scheduling inbetween at all, and the visual appearance of glxgears is a 
> direct function of its scheduling.

OK, I thought that somethink looking like a clock would be useful, especially
if we could tune the amount of CPU spent per task instead of being limited by
graphics drivers.

I searched freashmeat for a clock and found "orbitclock" by Jeremy Weatherford,
which was exactly what I was looking for :
  - small
  - C only
  - X11 only
  - needed less than 5 minutes and no knowledge of X11 for the complete hack !
  => Kudos to its author, sincerely !

I hacked it a bit to make it accept two parameters :
  -R <run_time_in_microsecond> : time spent burning CPU cycles at each round
  -S <sleep_time_in_microsecond> : time spent getting a rest

It now advances what it thinks is a second at each iteration, so that it makes
it easy to compare its progress with other instances (there are seconds,
minutes and hours, so it's easy to visually count up to around 43200).

The modified code is here :

  http://linux.1wt.eu/sched/orbitclock-0.2bench.tgz

What is interesting to note is that it's easy to make X work a lot (99%) by
using 0 as the sleeping time, and it's easy to make the process work a lot
by using large values for the running time associated with very low values
(or 0) for the sleep time.

Ah, and it supports -geometry ;-)

It could become a useful scheduler benchmark !

Have fun !
Willy

