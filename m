Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbZEGRT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbZEGRT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbZEGRTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:19:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:49855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZEGRTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:19:17 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1241716422.6311.1524.camel@laptop>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <1241716053.6311.1514.camel@laptop>  <1241716422.6311.1524.camel@laptop>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:18:38 +0200
Message-Id: <1241716718.6311.1531.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 19:13 +0200, Peter Zijlstra wrote:
> On Thu, 2009-05-07 at 19:09 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-05-07 at 10:13 -0400, Christoph Lameter wrote:
> > > I think we need to reduce the general tick frequency to be as low as
> > > possible. With high resolution timers the tick frequency is just the
> > > frequency with which the timer interrupt disturbs a running application.
> > > 
> > > Are there any benefits remaining from frequent timer interrupts? I would
> > > think that 60 HZ would be sufficient.
> > > 
> > > It would be good if the kernel would be truly tickless. Scheduler events
> > > would be driven by the scheduling intervals and not the invokations of the
> > > scheduler softirq.
> > 
> > The only thing that's driven by the softirq is load-balancing, there's
> > way more to the scheduler-tick than kicking that thing awake every so
> > often.
> > 
> > The problem is that running the scheduler of off hrtimers is too
> > expensive. We have the code, we tried it, people complained.
> 
> Therefore, decreasing the HZ value to say 50, we'd get a minimum
> involuntary preemption granularity of 20ms, something on the high end of
> barely usable.

Another user is RCU, the grace period is tick driven, growing these
ticks by a factor 50 or so might require some tinkering with forced
grace periods when we notice our batch queues getting too long.

