Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbYCZDOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbYCZDOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbYCZDOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:14:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59825 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbYCZDOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:14:16 -0400
Message-ID: <47E9BF83.8070006@pobox.com>
Date: Tue, 25 Mar 2008 23:14:11 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yshi <yang.shi@windriver.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B115.9060109@windriver.com>	<47E9B39C.5010502@pobox.com> <20080325.194221.16658596.davem@davemloft.net> <47E9BA6C.2010502@windriver.com>
In-Reply-To: <47E9BA6C.2010502@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yshi wrote:
> David Miller 写道:
>> From: Jeff Garzik <jgarzik@pobox.com>
>> Date: Tue, 25 Mar 2008 22:23:24 -0400
>>
>>  
>>> This is bogus -- you should never need to slow down the hot path in 
>>> such a way.
>>>     
>>
>> Slow down in what way?  Even on x86 saving the flags is just
>> about as expensive as a plain sti/cli.
>>
>> I would in fact prefer to see drivers unconditionally use
>> spin_lock_irqsave() et al. in the interrupt handler, for
>> consistency.
>>   
> Yes, I agree. Many NIC drivers do the same thing, like Gianfar, E1000, etc.

No, I just looked.  Neither gianfar nor e1000 nor e1000e does this.

In fact, gfar_transmit() is precisely an example of what I'm talking 
about:  you only need to use spin_lock() there.

	Jeff



