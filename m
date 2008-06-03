Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYFCGuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYFCGuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYFCGuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:50:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:58898 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYFCGue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:50:34 -0400
Subject: Re: MMIO and gcc re-ordering issue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       tpiepho@freescale.com
In-Reply-To: <200806031611.13817.nickpiggin@yahoo.com.au>
References: <1211852026.3286.36.camel@pasglop>
	 <200806031416.18195.nickpiggin@yahoo.com.au>
	 <1212467551.9496.23.camel@pasglop>
	 <200806031611.13817.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 16:48:50 +1000
Message-Id: <1212475730.9496.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 16:11 +1000, Nick Piggin wrote:
> >       - readl is synchronous (ie, makes the CPU think the
> >           data was actually used before executing subsequent
> >           instructions, thus waits for the data to come back,
> >           for example to ensure that a read used to push out
> >           post buffers followed by a delay will indeed happen
> >           with the right delay).
> 
> So your readl can pass an earlier cacheable store or earlier writel?

I forgot to mention that all MMIO are ordered vs. each other and I
do prevent readl from passing earlier cacheable stores too in my
current implementation but I'n not 100% we want to "guarantee" that,
unless we have stupid devices that trigger DMA's on reads with side
effects.. anyway, it is guaranteed in the current case.

Ben.


