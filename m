Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbZFZH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbZFZH1t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFZH1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:27:42 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55389 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZFZH1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:27:42 -0400
Date: Fri, 26 Jun 2009 16:26:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090626072638.GA21610@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org> <20090624124542.GB32306@elte.hu> <20090624131440.GA9700@linux-sh.org> <20090624132447.GD6224@elte.hu> <1245999685.31755.157.camel@twins> <20090626072350.GI14078@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626072350.GI14078@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:23:50AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, 2009-06-24 at 15:24 +0200, Ingo Molnar wrote:
> > > 
> > > [ And long-term analysis ('perf stat' type of runs) dont need IRQs 
> > >   anyway - perfcounters reads outs the counts and summarizes them 
> > >   across the measured workload. ]
> > 
> > If the counter width is less than 64 bits we do need to have some 
> > interrupt to read them from before they cycle so we can accumulate 
> > the deltas into a proper u64.
> 
> Yeah - but even that can be driven from some housekeeping hrtimer.
> 
> > But for proper 64 bit hardware counters there is indeed no need 
> > for that.
> 
> Indeed - although they are rare.
> 
We have both full 64-bit counters as well as 48-bit, although they do
both at least set an overflow bit that can be looked at, even if there is
no exception associated with it. Optionally they can be split up in to
multiple 32-bit counters and half of them handed over to the bus
controller.
