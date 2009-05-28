Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbZE1Qcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbZE1Qcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 12:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753769AbZE1Qc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 12:32:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:59658 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbZE1Qc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 12:32:27 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
In-Reply-To: <1243527218.28705.35.camel@desktop>
References: <1243348681.23657.14.camel@twins>
	 <alpine.LFD.2.00.0905262209160.1762@localhost.localdomain>
	 <20090526230855.GA27218@linux-sh.org>
	 <alpine.LFD.2.00.0905270140030.1762@localhost.localdomain>
	 <20090527001543.GA8493@linux-sh.org> <1243441525.28705.19.camel@desktop>
	 <20090528091936.GA27545@linux-sh.org> <1243503281.23657.80.camel@twins>
	 <20090528110902.GA27884@linux-sh.org>
	 <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
	 <20090528124207.GA28830@linux-sh.org>  <1243515570.6600.96.camel@laptop>
	 <1243527218.28705.35.camel@desktop>
Content-Type: text/plain
Date: Thu, 28 May 2009 18:32:09 +0200
Message-Id: <1243528329.6645.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 09:13 -0700, Daniel Walker wrote:
> On Thu, 2009-05-28 at 14:59 +0200, Peter Zijlstra wrote:
> 
> > 
> > 
> > CPU0                           CPU1
> > 
> > clock = ACCESS_ONCE(sched_clocksource);
> > 
> >                                unload module
> >                                  clocksource_unregister()
> >                                    sched_clocksource = jiffies
> >                                  unmap data/text
> > 
> > cyc2ns(clock, clocksource_read(clock)) <--- fireworks
> > 
> > 
> 
> Do any module based clocksources even exist right now?
> clocksource_unregister only seems to be used 3 times..

Good point, it appears its not even exported.

Thomas mentioned modules, I assumed.

