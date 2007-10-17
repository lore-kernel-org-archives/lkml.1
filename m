Return-Path: <linux-kernel-owner+w=401wt.eu-S933342AbXJQJJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342AbXJQJJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 05:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757702AbXJQJJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 05:09:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:34470 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221AbXJQJJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 05:09:06 -0400
Subject: Re: [PATCH] PHYLIB: IRQ event workqueue handling fixes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andy Fleming <afleming@freescale.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071017085809.GA1658@ff.dom.local>
References: <20071015125301.GC3015@ff.dom.local>
	 <Pine.LNX.4.64N.0710151737250.16262@blysk.ds.pg.gda.pl>
	 <20071016062108.GB1000@ff.dom.local>
	 <Pine.LNX.4.64N.0710161759050.22596@blysk.ds.pg.gda.pl>
	 <20071017085809.GA1658@ff.dom.local>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 19:08:44 +1000
Message-Id: <1192612124.11899.165.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Btw., since, because of this patch, I've had a one more look at phy.c
> and there are a few more doubts, so this time I'll try to bother you
> for real:

 .../...

While there... is somebody interested in making the whole PHY lib
operate a task level and use mutexes instead of spinlock ? I need that
for drivers like EMAC (who use their own PHY layer for now), and I might
even give a go at adapting phylib myself, but I'd like to take the
temperature about it first.

Basically, there is nothing in phylib that is performance critical or
such that requires it to run at irq time and/or use locks. On the other
hand, it complicates things in various areas. The most obvious one being
that it prevents the network driver mii access callbacks from sleeping
which can be annoying as MDIO can be slow, and some drivers have fancy
muxes in there that are better off mutexed than spinlocked.

Ben.
 

