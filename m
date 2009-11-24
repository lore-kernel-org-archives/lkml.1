Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZKXIi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZKXIi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKXIi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:38:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:54103 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZKXIiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:38:25 -0500
Subject: Re: [PATCH] irq: Add node_affinity CPU masks for smarter
 irqbalance hints
From: Peter Zijlstra <peterz@infradead.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.jf.intel.com" <arjan@linux.jf.intel.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <Pine.WNT.4.64.0911231529240.10056@ppwaskie-MOBL2.amr.corp.intel.com>
References: <20091123064630.7385.30498.stgit@ppwaskie-hc2.jf.intel.com>
	 <2674af740911222332i65c0d066h79bf2c1ca1d5e4f0@mail.gmail.com>
	 <1258968980.2697.9.camel@ppwaskie-mobl2> <1258995923.4531.715.camel@laptop>
	 <Pine.WNT.4.64.0911231529240.10056@ppwaskie-MOBL2.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:38:22 +0100
Message-ID: <1259051902.4531.1053.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 15:32 -0800, Waskiewicz Jr, Peter P wrote:

> Unfortunately, a driver can't.  The irq_set_affinity() function isn't 
> exported.  I proposed a patch on netdev to export it, and then to tie down 
> an interrupt using IRQF_NOBALANCING, so irqbalance won't touch it.  That 
> was rejected, since the driver is enforcing policy of the interrupt 
> balancing, not irqbalance.

Why would a patch touching the irq subsystem go to netdev?

What is wrong with exporting irq_set_affinity(), and wtf do you need
IRQF_NOBALANCING for?

> I and Jesse Brandeburg had a meeting with Arjan about this.  What we came 
> up with was this interface, so drivers can set what they'd like to see, if 
> irqbalance decides to honor it.  That way interrupt affinity policies are 
> set only by irqbalance, but this interface gives us a mechanism to hint to 
> irqbalance what we'd like it to do.

If all you want is to expose policy to userspace then you don't need any
of this, simply expose the NICs home node through a sysfs device thingy
(I was under the impression its already there somewhere, but I can't
ever find anything in /sys).

No need what so ever to poke at the IRQ subsystem.

> Also, if you use the /proc interface to change smp_affinity on an 
> interrupt without any of these changes, irqbalance will override it on its 
> next poll interval.  This also is not desirable.

This all sounds backwards.. we've got a perfectly functional interface
for affinity -- which people object to being used for some reason. So
you add another interface on top, and that is ok?

All the while not CC'ing the IRQ folks,.. brilliant approach.

