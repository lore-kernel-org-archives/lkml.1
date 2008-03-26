Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbYCZWAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbYCZWAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYCZWAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:00:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:59721 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbYCZWAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:00:03 -0400
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
In-Reply-To: <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
References: <20080325201125.GD15330@elte.hu>
	 <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>
	 <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
	 <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	 <20080326203012.GB6249@us.ibm.com>
	 <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	 <20080326205828.GA15225@jurassic.park.msu.ru>
	 <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 08:57:55 +1100
Message-Id: <1206568675.6926.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> NOTE! This will also consider a bridge resource at 0 to be an invalid 
> resource (since now the alignment will be zero), which is a bit odd and 
> makes me worry a bit. I wouldn't be surprised if some non-PC architectures 
> have PCI bridges at zero. But maybe they should be (or already are?) 
> marked IORESOURCE_PCI_FIXED?

PCI bridges at zero is perfectly valid indeed and I'm sure we have that
around at least for IO space. In fact, I'm surprised you don't have that
on x86. Typically, things like an HT segment with a P2P bridge and
behind that bridge an ISA bridge could well have the P2P bridge with a
resource forwarding 0...0x1000 IO downstream for example even on x86
no ? (I'm not -that- familiar with the crazyness of legacy ISA on x86
but I've definitely seen such setup on other archs).

For MMIO, it mostly depends whether the code gets to work on raw bus
values, in which case 0 will be around, or already fixed up values (ie,
translated in CPU bus space) in which case 0 is unlikely.

In the case of pdev_sort_resources(), it will manipulate already fixed
up resources, so MMIO should work, but I'm a bit worried by PIO.

Ben.


