Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZAHNSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZAHNSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 08:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZAHNSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 08:18:23 -0500
Received: from mercury.realtime.net ([205.238.132.86]:39979 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZAHNSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 08:18:23 -0500
In-Reply-To: <20090108123619.3543719f@lxorguk.ukuu.org.uk>
References: <hvc-console-29-3@bga.com> <hvc-console-29-3-1@bga.com> <20090108123619.3543719f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <455ca36e8b5778fd4c7218ef31fca07c@bga.com>
Content-Transfer-Encoding: 7bit
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Joe Peterson <joe@skyrush.com>, lkml <linux-kernel@vger.kernel.org>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] hvc_console: do not set low_latency
Date: Thu, 8 Jan 2009 07:25:14 -0600
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.624)
X-Originating-IP: 205.232.218.56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8, 2009, at 6:36 AM, Alan Cox wrote:

>> v2.6.16-rc1 via 33f0f88f1c51ae5c2d593d26960c760ea154c2e2
>>     [PATCH] TTY layer buffering revamp
>>
>> added this new api.
>
> No - tty_flip_buffer_push is from 2.1.66 and with the same constraints
> from the day it was added.
>
Yes but wrappers were added and this this and many ohter drivers were  
converted to use them:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git; 
a=commitdiff;h=33f0f88f1c51ae5c2d593d26960c760ea154c2e2

And they were slightly buggy leading to the buggy workaround.

>
>> Having the flag set for purely polled drivers will save delaying
>> the work when receiving input for 1 jiffie.
>>
>>
>> Index: work.git/drivers/char/hvc_console.c
>> ===================================================================
>> --- work.git.orig/drivers/char/hvc_console.c	2009-01-08  
>> 03:01:24.000000000 -0600
>> +++ work.git/drivers/char/hvc_console.c	2009-01-08 03:01:51.000000000  
>> -0600
>> @@ -318,7 +318,8 @@ static int hvc_open(struct tty_struct *t
>>  	} /* else count == 0 */
>>
>>  	tty->driver_data = hp;
>> -	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
>> +	if (!hp->irq_requested)
>> +		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
>>
>>  	hp->tty = tty;
>
> Looks good to me

Thanks, I guess that is an Ack?

milton

