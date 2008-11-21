Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYKUXHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYKUXHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYKUXGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:06:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37269
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752361AbYKUXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:06:53 -0500
Date: Fri, 21 Nov 2008 15:06:52 -0800 (PST)
Message-Id: <20081121.150652.143573683.davem@davemloft.net>
To: hawk@diku.dk
Cc: tglx@linutronix.de, jdb@comx.dk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Robert.Olsson@data.slu.se, mingo@elte.hu
Subject: Re: Regression: Bisected, IRQ and MSI allocations screwed without
 sparse irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0811212022520.29808@ask.diku.dk>
References: <1227263614.25811.25.camel@localhost.localdomain>
	<alpine.LFD.2.00.0811210838360.3232@localhost.localdomain>
	<Pine.LNX.4.64.0811212022520.29808@ask.diku.dk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <hawk@diku.dk>
Date: Fri, 21 Nov 2008 20:35:32 +0100 (CET)

> On Fri, 21 Nov 2008, Thomas Gleixner wrote:
> 
> > On Fri, 21 Nov 2008, Jesper Dangaard Brouer wrote:
> >>> Can you please try the attached patch ?
> >>
> >> I have tried the patch and it solved the problem! :-)
> >>
> >> I'll gladly test other patches from your.  Guess this patch needs to be
> >> brushed up before a mainline patch is ready.
> >
> > Ok, I queue it for mainline. This solves just the number of irqs
> > limitation, the rmmod problem still persists, right ?
> 
> It solves both the irq limit and the NIU driver unload bug.

I think it "solves" the unload BUG because the driver never has
to fallback to IO_APIC irqs and abort trying to use MSI-X
any longer.

Only the IRQ limit bug is fixed by Thomas's patch.
