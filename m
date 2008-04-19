Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbYDSWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbYDSWnd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762740AbYDSWnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:43:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:33726 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760253AbYDSWnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:43:23 -0400
Date: Sat, 19 Apr 2008 15:49:23 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: Thomas Gleixner <tglx@linutronix.de>
cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] Higer latency with dynamic tick (need for an io-ondemand
 govenor?)
In-Reply-To: <alpine.LFD.1.10.0804190839140.3261@apollo.tec.linutronix.de>
Message-ID: <alpine.DEB.1.10.0804191546430.4670@asgard>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <1179474567.12981.53.camel@chaos> <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com> <200804182045.56893.david-b@pacbell.net>
 <alpine.LFD.1.10.0804190839140.3261@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="8323328-307532848-1208589223=:3261"
Content-ID: <alpine.DEB.1.10.0804191546431.4670@asgard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-307532848-1208589223=:3261
Content-Type: TEXT/PLAIN; CHARSET=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.1.10.0804191546432.4670@asgard>

On Sat, 19 Apr 2008, Thomas Gleixner wrote:

> On Fri, 18 Apr 2008, David Brownell wrote:
>> On Friday 18 April 2008, Woodruff, Richard wrote:
>>> When capturing some traces with dynamic tick we were noticing the
>>> interrupt latency seems to go up a good amount. If you look at the trace
>>> the gpio IRQ is now offset a good amount.  Good news I guess is its
>>> pretty predictable.
>>
>> That is, about 24 usec on this CPU ... an ARM v7, which I'm guessing
>> is an OMAP34xx running fairly fast (order of 4x faster than most ARMs).
>>
>> Similar issues were noted, also using ETM trace, on an ARM920 core [1]
>> from Atmel.  There, the overhead of NO_HZ was observed to be more like
>> 150 usec of per-IRQ overhead, which is enough to make NO_HZ non-viable
>> in some configurations.
>>
>>
>>> I was wondering what thoughts of optimizing this might be.
>>
>> Cutting down the math implied by jiffies updates might help.
>> The 64 bit math for ktime structs isn't cheap; purely by eyeball,
>> that was almost 1/3 the cost of that 24 usec (mostly __do_div64).
>
> Hmm, I have no real good idea to avoid the div64 in the case of a long
> idle sleep. Any brilliant patches are welcome :)

how long is 'long idle sleep'? and how common are such sleeps? is it 
possibly worth the cost of a test in the hotpath to see if you need to do 
the 64 bit math or can get away with 32 bit math (at least on some 
platforms)

David Lang
--8323328-307532848-1208589223=:3261--
