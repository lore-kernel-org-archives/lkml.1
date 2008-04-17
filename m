Return-Path: <linux-kernel-owner+w=401wt.eu-S934434AbYDQSOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434AbYDQSOF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756278AbYDQSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:13:54 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:54742 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763001AbYDQSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:13:53 -0400
Message-ID: <48079356.2090307@nortel.com>
Date: Thu, 17 Apr 2008 12:13:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jack Harvard <jack.harvard@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: gettimeofday() in 2.6.24
References: <a72f6a3c0804171031qbba17d6pb470119d5f2ff010@mail.gmail.com>
In-Reply-To: <a72f6a3c0804171031qbba17d6pb470119d5f2ff010@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Apr 2008 18:13:46.0953 (UTC) FILETIME=[C7605390:01C8A0B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Harvard wrote:

> http://lxr.linux.no/linux+v2.6.24/arch/arm/kernel/time.c#L240
>  239#ifndef CONFIG_GENERIC_TIME
>  240void do_gettimeofday(struct timeval *tv)
>  241{
>  242        unsigned long flags;
>  243        unsigned long seq;
>  244        unsigned long usec, sec;
>  245
>  246        do {
>  247                seq = read_seqbegin_irqsave(&xtime_lock, flags);
>  248                usec = system_timer->offset();
>  249                sec = xtime.tv_sec;
>  250                usec += xtime.tv_nsec / 1000;
>  251        } while (read_seqretry_irqrestore(&xtime_lock, seq, flags));


> but I haven't quite figured out how gettimeofday() actually gets time
> from this added timer, also how xtime is updated?


system_timer->offset() uses the added timer to return the number of 
usecs since the last timer tick.  It's potentially different for each 
specific type of arm blade, and the function often has "gettimeoffset" 
in the name.

"xtime" is updated in the core kernel code.

Chris
