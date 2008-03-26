Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYCZXG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYCZXG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYCZXGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:06:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55519 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbYCZXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:06:20 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <alpine.LFD.1.00.0803261544210.2775@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	 <1206568675.6926.7.camel@pasglop>  <20080326221027.GA7959@elte.hu>
	 <1206570546.6926.30.camel@pasglop>
	 <alpine.LFD.1.00.0803261544210.2775@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 09:54:44 +1100
Message-Id: <1206572084.6926.34.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 15:47 -0700, Linus Torvalds wrote:
> > I was talking about IO not memory mostly here.
> 
> Yeah, low IO is also reserved on PC's (the low 256 IO ports are 
> motherboard resources and contain stuff like legacy DMA channel setup 
> etc)

Sure but can't that be in a kind of southbridge ? Like HT or PCIe
segment out of the CPU gets through a virtual P2P wich then hits the
"legacy" combo blob masquerading as a PCI device ? I remember seeing
that sort of thing in the past and I -think- it was some kind of x86
chipset hijacked on powerpc... 

> You could imagine having it behind a PCI bridge, but in practice it's 
> always on the NB/SB (and if you want to support some of the odder
> things 
> like the NMI reason and the i387 error ports, they pretty much have
> to 
> be - it would be insane to make a special PCI chips on a separate bus 
> that does things like that).

It's often all virtual inside a single chip.

Anyway, doesn't matter much at this stage I suppose, but it would be
nice to not use 0 as meaning invalid when sizing bridge windows and I'm
not sure at all about using "start" as an alignment indicator neither...
It will be much over-aligned in some cases, adding constraints to the
allocator where we didn't have any before no ?

Ben.


