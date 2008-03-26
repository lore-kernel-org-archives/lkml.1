Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbYCZWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbYCZWgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYCZWgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:36:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:54379 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYCZWgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:36:36 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <20080326221027.GA7959@elte.hu>
References: <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	 <1206568675.6926.7.camel@pasglop>  <20080326221027.GA7959@elte.hu>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 09:29:06 +1100
Message-Id: <1206570546.6926.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 23:10 +0100, Ingo Molnar wrote:
> > PCI bridges at zero is perfectly valid indeed and I'm sure we have 
> > that around at least for IO space. In fact, I'm surprised you don't 
> > have that on x86. Typically, things like an HT segment with a P2P 
> > bridge and behind that bridge an ISA bridge could well have the P2P 
> > bridge with a resource forwarding 0...0x1000 IO downstream for example 
> > even on x86 no ? (I'm not -that- familiar with the crazyness of legacy 
> > ISA on x86 but I've definitely seen such setup on other archs).
> 
> 0..0x1000 physical memory (== bus memory on x86) is reserved to the BIOS 
> as RAM in essence and that legacy will be with us for at least 100 or 
> maybe 200 years ;-)

I was talking about IO not memory mostly here. MMIO wouldn't be a
problem on powerpc as I said because we offset MMIO resources early
after probe so that they contain effectively a CPU bus address, and in
that case, 0 is definitely not going to happen for PCI devices or busses
(even if it may on the bus, but the code we are talking about won't see
it).

Cheers,
Ben.
 

