Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZE1Xhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZE1Xhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZE1Xhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:37:35 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39716 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZE1Xhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:37:34 -0400
Date: Fri, 29 May 2009 08:37:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090528233716.GB1122@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Walker <dwalker@fifo99.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	John Stultz <johnstul@linux.vnet.ibm.com>
References: <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop> <20090528165816.GA31688@linux-sh.org> <1243532324.28705.75.camel@desktop> <20090528175341.GA32118@linux-sh.org> <1243534252.28705.86.camel@desktop> <20090528182730.GA32767@linux-sh.org> <1243537463.28705.94.camel@desktop> <20090528193458.GA1122@linux-sh.org> <1243539663.28705.99.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243539663.28705.99.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 12:41:03PM -0700, Daniel Walker wrote:
> On Fri, 2009-05-29 at 04:34 +0900, Paul Mundt wrote:
> > > I'm still a little confused how kernel modules fit in here.. Are you
> > > saying a user would unload some certain driver which has a pin locked
> > > down and prevents the clocksource from working. Then the user would load
> > > the clocksource module which would now function, and that all would have
> > > to happen in order to enter a certain power state?
> > > 
> > Yes.
> 
> I'm assuming this isn't a low power state, this would be something more
> like suspend or hibernate right?
> 
Right, with the amount of hassle involved, it makes no sense for run-time
PM at least. So the suspend/hibernate use cases are mostly where it makes
sense.
