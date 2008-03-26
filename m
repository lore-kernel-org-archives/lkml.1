Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYCZWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYCZWbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbYCZWb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:31:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899AbYCZWb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:31:27 -0400
Date: Wed, 26 Mar 2008 23:30:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326223041.GA14050@elte.hu>
References: <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <1206568675.6926.7.camel@pasglop> <20080326221027.GA7959@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326221027.GA7959@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > PCI bridges at zero is perfectly valid indeed and I'm sure we have 
> > that around at least for IO space. In fact, I'm surprised you don't 
> > have that on x86. Typically, things like an HT segment with a P2P 
> > bridge and behind that bridge an ISA bridge could well have the P2P 
> > bridge with a resource forwarding 0...0x1000 IO downstream for 
> > example even on x86 no ? (I'm not -that- familiar with the crazyness 
> > of legacy ISA on x86 but I've definitely seen such setup on other 
> > archs).
> 
> 0..0x1000 physical memory (== bus memory on x86) is reserved to the 
> BIOS as RAM in essence and that legacy will be with us for at least 
> 100 or maybe 200 years ;-)

ah i was fixated on ioremap-ed memory resources - the PIO space is quite 
colorful indeed.

	Ingo
