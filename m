Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbYCZDOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbYCZDOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYCZDOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:14:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59820 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYCZDOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:14:07 -0400
Message-ID: <47E9BF7B.3030003@pobox.com>
Date: Tue, 25 Mar 2008 23:14:03 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B115.9060109@windriver.com>	<47E9B39C.5010502@pobox.com> <20080325.194221.16658596.davem@davemloft.net>
In-Reply-To: <20080325.194221.16658596.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jgarzik@pobox.com>
> Date: Tue, 25 Mar 2008 22:23:24 -0400
> 
>> This is bogus -- you should never need to slow down the hot path in such 
>> a way.
> 
> Slow down in what way?  Even on x86 saving the flags is just
> about as expensive as a plain sti/cli.

Replacing spin_lock() [current 8139too.c] with spin_lock_irqsave() 
results in a larger interrupt handler... more CPU instructions for the 
same result.


> I would in fact prefer to see drivers unconditionally use
> spin_lock_irqsave() et al. in the interrupt handler, for
> consistency.

The entire spin_lock() apparatus in the interrupt handler disappears 
nicely on uniprocessor machines.

Plus, you are not competing with any other interrupts other than your 
own, which is the only major class of problems where spin_lock_irqsave() 
in interrupt handler is really needed (PS/2 kbd + mouse is an example).

Or more simply, it's not needed, so nothing is gained by doing 
additional work in the hot path for the sake of consistency.

	Jeff


