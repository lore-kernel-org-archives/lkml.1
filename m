Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbZINPke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbZINPke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZINPkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:40:33 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16998 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZINPkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:40:32 -0400
Message-ID: <4AAE63E7.90909@caviumnetworks.com>
Date: Mon, 14 Sep 2009 08:40:23 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Michael Buesch <mb@bu3sch.de>, linuxppc-dev@lists.ozlabs.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-s390@vger.kernel.org,
       linux-am33-list@redhat.com, Helge Deller <deller@gmx.de>,
       x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
       Mike Frysinger <vapier@gentoo.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-alpha@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH 01/10] Add support for GCC-4.5's __builtin_unreachable()
 	to compiler.h
References: <4AA991C1.1050800@caviumnetworks.com>	 <1252627011-2933-1-git-send-email-ddaney@caviumnetworks.com>	 <200909111633.00665.mb@bu3sch.de>	 <4AAA73A4.9010601@caviumnetworks.com> <10f740e80909120022m72ad5ea7t692fba93cd3114e9@mail.gmail.com>
In-Reply-To: <10f740e80909120022m72ad5ea7t692fba93cd3114e9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2009 15:40:24.0988 (UTC) FILETIME=[AD5125C0:01CA3551]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Fri, Sep 11, 2009 at 17:58, David Daney<ddaney@caviumnetworks.com> wrote:
>> Michael Buesch wrote:
>>> On Friday 11 September 2009 01:56:42 David Daney wrote:
>>>> +/* Unreachable code */
>>>> +#ifndef unreachable
>>>> +# define unreachable() do { for (;;) ; } while (0)
>>>> +#endif
>>> # define unreachable() do { } while (1)
>>>
>>> ? :)
>> Clearly I was not thinking clearly when I wrote that part.  RTH noted the
>> same thing.  I will fix it.
> 
> However, people are so used to seeing the `do { } while (0)' idiom,
> that they might miss
> there's a `1' here, not a `0'.
> 
> So perhaps it's better to use plain `for (;;)' for infinite loops?
> 

I don't think so.  The only valid token that can follow 'do { } while 
(1)' is ';', any statement may follow 'for (;;)', so there is a greater 
possibility to silently screw things up with the for(;;) form.

David Daney

