Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYCZXGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYCZXGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYCZXGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:06:42 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39666 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbYCZXGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:06:41 -0400
Date: Wed, 26 Mar 2008 22:47:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326224702.46b4d582@core>
In-Reply-To: <alpine.LFD.1.00.0803261524560.2775@woody.linux-foundation.org>
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
	<alpine.LFD.1.00.0803261524560.2775@woody.linux-foundation.org>
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

> I dunno. I'm not going to do anything in this area before 2.6.25 is out 
> because this *does* make me a bit nervous, but if somebody wants to think 
> about this and perhaps write patches for testing, that would be good.

One way to kill off some of the assumptions and gunge would be to add
pci_resource_assigned(resource) [or indeed just resource_assigned()].
Iomap has similar problems - we have no portable defined "not mapped" at
the moment, although we use NULL technically mmio maps of 0 end up at 0
in the implementation today.

Alan
