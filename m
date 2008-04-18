Return-Path: <linux-kernel-owner+w=401wt.eu-S1758063AbYDROt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063AbYDROt5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYDROtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:49:45 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:41604 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbYDROto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:49:44 -0400
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2008 10:49:44 EDT
Message-ID: <4808B1C8.2060601@nortel.com>
Date: Fri, 18 Apr 2008 08:35:52 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jack Harvard <jack.harvard@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() in 2.6.24
References: <a72f6a3c0804171031qbba17d6pb470119d5f2ff010@mail.gmail.com> <48079356.2090307@nortel.com> <a72f6a3c0804180154x28d0b528gc1cbd3d11279c4a1@mail.gmail.com>
In-Reply-To: <a72f6a3c0804180154x28d0b528gc1cbd3d11279c4a1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2008 14:35:56.0116 (UTC) FILETIME=[82F6A140:01C8A161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Harvard wrote:
> On Thu, Apr 17, 2008 at 7:13 PM, Chris Friesen <cfriesen@nortel.com>
> wrote:

>> system_timer->offset() uses the added timer to return the number of
>> usecs since the last timer tick.  It's potentially different for
>> each specific type of arm blade, and the function often has
>> "gettimeoffset" in the name.

>> "xtime" is updated in the core kernel code.


> is "xtime" updated by the time tick clock timer, i.e., the timer
> which generates interrupts every 1/HZ second to the kernel. Put it in
>  another way, does gettimeofday get time in two parts 1) seconds from
> xtime.tv_sec, updated by timer0, 2) microseconds from xtime.tv_nsec +
>  system_timer->offset(), updated by timer0 and timer3.

Yes, I think xtime is updated by the tick timer.

system_timer->offset() may be updated by different mechanisms, depending 
on the specific arm subarch.

> Do you mean the code here 
> "http://lxr.linux.no/linux+v2.6.24/kernel/time/timekeeping.c#L45"

No.  As I said, the function usually has "gettimeoffset" in the name and 
it's specific to arm so it would be under arch/arm.  For instance, on 
Xscale boards it's ixp2000_gettimeoffset() in arch/arm/mach-ixp2000/core.c.

For more information you might want to look at the code in arch/arm or 
else talk to the arm developers on the linux-arm-kernel mailing list.

Chris
