Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbZE1RCD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbZE1RCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:02:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbZE1RBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:01:54 -0400
Received: from www.tglx.de ([62.245.132.106]:54619 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028AbZE1RBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:01:53 -0400
Date: Thu, 28 May 2009 19:00:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@fifo99.com>
cc: Paul Mundt <lethal@linux-sh.org>, Peter Zijlstra <peterz@infradead.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Support current clocksource handling in fallback
 sched_clock().
In-Reply-To: <1243529547.28705.43.camel@desktop>
Message-ID: <alpine.LFD.2.00.0905281857420.3397@localhost.localdomain>
References: <20090527001543.GA8493@linux-sh.org>  <1243441525.28705.19.camel@desktop> <20090528091936.GA27545@linux-sh.org>  <1243503281.23657.80.camel@twins> <20090528110902.GA27884@linux-sh.org>  <alpine.LFD.2.00.0905281417500.3397@localhost.localdomain>
  <20090528124207.GA28830@linux-sh.org> <1243515570.6600.96.camel@laptop>  <1243527218.28705.35.camel@desktop> <1243528329.6645.77.camel@laptop>  <20090528164011.GA30104@linux-sh.org> <1243529547.28705.43.camel@desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Daniel Walker wrote:
> > > > Do any module based clocksources even exist right now?
> > > > clocksource_unregister only seems to be used 3 times..
> > > 
> > > Good point, it appears its not even exported.
> > > 
> > > Thomas mentioned modules, I assumed.
> > > 
> > The drivers/clocksource/ drivers in theory could be modular anyways.
> > Handling this transition properly is at least one less barrier to modular
> > clocksources, so I think it's progress regardless. I don't remember what
> > all of the other issues were though, John probably remembers.
> 
> I don't think it's an important case to consider right now ..
> clocksources are usually so integral to the system putting one in a
> module seems counterintuitive. 

That does not matter at all. If we have an unregister call then we
have to be prepared for 

     - the memory which contained the clocksource is freed 
     - the underlying hardware is going away. 

It does not matter at all if that happens in a compiled in or in a
modular driver.

Thanks,

	tglx
