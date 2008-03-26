Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYCZDjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYCZDjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbYCZDjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:39:33 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:32809 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbYCZDjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:39:32 -0400
Message-ID: <47E9C56F.2070508@pobox.com>
Date: Tue, 25 Mar 2008 23:39:27 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: yang.shi@windriver.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B39C.5010502@pobox.com>	<20080325.194221.16658596.davem@davemloft.net>	<47E9BF7B.3030003@pobox.com> <20080325.203043.196469543.davem@davemloft.net>
In-Reply-To: <20080325.203043.196469543.davem@davemloft.net>
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
> Date: Tue, 25 Mar 2008 23:14:03 -0400
> 
>> David Miller wrote:
>>> From: Jeff Garzik <jgarzik@pobox.com>
>>> Date: Tue, 25 Mar 2008 22:23:24 -0400
>>>
>>>> This is bogus -- you should never need to slow down the hot path in such 
>>>> a way.
>>> Slow down in what way?  Even on x86 saving the flags is just
>>> about as expensive as a plain sti/cli.
>> Replacing spin_lock() [current 8139too.c] with spin_lock_irqsave() 
>> results in a larger interrupt handler... more CPU instructions for the 
>> same result.
> 
> Jeff, please be realistic.
> 
> These interrupt handlers about to do a PIO on a status register, which
> will consume on the order of a few hundred cpu cycles.
> 
> Counting an I-cache line or two, or 18 cycles here or there,
> is immaterial by comparison.

I am being realistic...  it's

* not needed
* increases code size
* increases number of CPU instructions executed
* not needed

Thus applying this consistency rule across N drivers needlessly 
increases the code size of N drivers.

Mainly I see such a change as a violation of a basic Linux principle: 
do what you must, and no more.

	Jeff



