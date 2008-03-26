Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbYCZWdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbYCZWdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 18:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbYCZWdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 18:33:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56392 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752978AbYCZWdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:33:01 -0400
Date: Wed, 26 Mar 2008 22:07:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: benh@kernel.crashing.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326220738.060d00ef@core>
In-Reply-To: <1206568675.6926.7.camel@pasglop>
References: <20080325201125.GD15330@elte.hu>
	<20080325202954.GA22007@elte.hu>
	<47E969E1.6080608@m3y3r.de>
	<alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	<20080326101450.GA9060@jurassic.park.msu.ru>
	<20080326135458.GA27621@elte.hu>
	<20080326180701.GA6249@us.ibm.com>
	<alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
	<20080326203012.GB6249@us.ibm.com>
	<alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
	<20080326205828.GA15225@jurassic.park.msu.ru>
	<alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
	<1206568675.6926.7.camel@pasglop>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PCI bridges at zero is perfectly valid indeed and I'm sure we have that
> around at least for IO space. In fact, I'm surprised you don't have that
> on x86. Typically, things like an HT segment with a P2P bridge and
> behind that bridge an ISA bridge could well have the P2P bridge with a
> resource forwarding 0...0x1000 IO downstream for example even on x86
> no ? (I'm not -that- familiar with the crazyness of legacy ISA on x86
> but I've definitely seen such setup on other archs).

On a PC system 0x00-0xFF are motherboard resources (sometimes chipset,
some even swallowed by the CPU in certain cases) so 0 as disabled is sort
of safe but as shown by the pci_enable_device_bars replacement code - not
a good idea neccessarily.

A lot of driver code does assume 0 == unavailable/off/disabled including
large chunks of serial, ata, ide and probably other subsystems.

Alan
