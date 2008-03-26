Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYCZEcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYCZEcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 00:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYCZEcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 00:32:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40173 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYCZEcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 00:32:31 -0400
Message-ID: <47E9D1DC.6030201@garzik.org>
Date: Wed, 26 Mar 2008 00:32:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <20080325.203043.196469543.davem@davemloft.net>	<47E9C56F.2070508@pobox.com>	<47E9C784.6050807@garzik.org> <20080325.205331.02412053.davem@davemloft.net>
In-Reply-To: <20080325.205331.02412053.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> First, if you mention CPU instructions executed you're
> totally ignoring what I wrote.  Which is that we're
> about to sit spinning on hundreds of cycles doing a PIO
> read on a status register.
> 
> Those hand full of cycles doing the irqsave/irqrestore don't matter,
> at all.
> 
> Again, you're arguing for 18 cycles or so out of say 800.
> It's peanuts, at best.

No, I hear you.

I'm not focusing on cycles, but list examples of the negative effects of 
doing needless work for the sake of consistency:

* eliminates ability to compile-out spinlocks on UP
* code size increases (even if miniscule)
* CPU instructions in a hot path increases (even if lost in the noise)
* stack usage increases (even if miniscule)

But those are just examples of the principle:  don't do work you don't 
need to do.

I also think spin_lock -> spin_lock_irqsave amounts to a slight loss of 
information, too:  Use of spin_lock() rather than spin_lock_irqsave() 
potentially gives the -rt folks some additional flexibility, by 
advertising a different set of acceptable irq-disablement states.

Is the effect huge in this specific case?  No.

Does that give us license to add needless code to drivers?  No, again, IMO.

	Jeff


