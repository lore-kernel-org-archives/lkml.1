Return-Path: <linux-kernel-owner+w=401wt.eu-S1161618AbXEDSr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161618AbXEDSr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161605AbXEDSr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:47:29 -0400
Received: from mta16.mail.adelphia.net ([68.168.78.211]:47480 "EHLO
	mta16.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161618AbXEDSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:47:27 -0400
Message-ID: <463B7FBC.3090907@acm.org>
Date: Fri, 04 May 2007 13:47:24 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from
 the LSR and MSR
References: <20070504131532.GA12265@localdomain> <200705041304.02618.gene.heskett@gmail.com>
In-Reply-To: <200705041304.02618.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> On Friday 04 May 2007, Corey Minyard wrote:
>   
>> I did think of one other thing: if you clear the MSR delta flags while
>> polling the serial console, you need to call the routine to check the
>> modem status since the interrupt will not happen.  So here's the
>> patch...
>>
>> Subject: Serial 8250: Handle saving the clear-on-read bits from the LSR and
>> MSR
>>
>>     
> I applied this patch because I was curious to see what effect if any it had on 
> some serial based acessories I use here, like a cm11 x10 controller with 
> heyu, and a belkin ups with its supplied software.
>
> But at first boot, its not 100% operationally safe, but please read on.
>
> 1) heyu (the x10 control program) is now stuck in a loop, repeating the last 
> command issued, at about 40 second repeat intervals.  AND it is using 90%+ of 
> the cpu while it executes each loop, which takes about 7 to 10 seconds each 
> time.  heyu is interfacing to the world via /dev/ttyUSB0, through an FTDI 
> adapter so I'm not able to make a mental connection here between this patch 
> and that effect.
>
> 2) HOWEVER!  The belkin upsd daemon, which started being a cpu hog, using 40% 
> of the cpu continuously since something in the 2.6.20 to 2.6.21 time frame, 
> and this was regardless of whether it was talking through a /dev/ttyUSB# port 
> and either a pl2303, or an FTDI adaptor, or direct through /dev/ttyS0, is at 
> least for /dev/ttyS0, now operating normally and apparently 100% stable.  So 
> I pulled out another FTDI adaptor, and reconfigured the daemon to 
> use /dev/ttyUSB1, and that is also operating 100% normally now.
>
> Can someone explain 1) above?  Even odder still, I'd killed and restarted heyu 
> several times to no avail before I tried putting upsd on /dev/ttyUSB1, but 
> after moving the upsd access from /dev/ttyS0 to /dev/ttyUSB1, then heyu, 
> running through /dev/ttyUSB0, is now operating 100% normally.  ???
>
> Does anyone have any idea what kind of bait I should put out to kill this 
> nilmerg?  I'm happy, its all working again for a change, but I'll be damned 
> if I ain't totally bumfuzzled.  And I wonder if it will survive a reboot...
>
>   
I really doubt that this patch had anything to do with these issues, 
especially
the ones over USB.  However, if you can reliably remove the patch, test, and
reapply the patch, and test, and the issues remain the same, then it's 
perhaps
something significant, though I would be at a loss to know what it was.

-corey
