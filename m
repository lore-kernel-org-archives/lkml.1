Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbXJSRgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbXJSRgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXJSRfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:35:53 -0400
Received: from rtr.ca ([76.10.145.34]:1962 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935424AbXJSRfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:35:52 -0400
Message-ID: <4718EAF5.6000700@rtr.ca>
Date: Fri, 19 Oct 2007 13:35:49 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.23.1 Freezes on GB data transfers
References: <12bfabe40710170420m6882ea8eg3b8e6e7db72a0cdd@mail.gmail.com>	 <2c0942db0710190858n647192d6t270e43b2a3075320@mail.gmail.com>	 <4718DB8F.3070903@rtr.ca> <2c0942db0710191018n894a773mc2b0400067c0fdf@mail.gmail.com>
In-Reply-To: <2c0942db0710191018n894a773mc2b0400067c0fdf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On 10/19/07, Mark Lord <lkml@rtr.ca> wrote:
>
>> I believe this is now the forth report of blinking-leds lockup with 2.6.23.1.
>>
>> I wonder what's causing it?
>> My system has this as well, totally random, once every day or so.
>> New behaviour since 2.6.23-rc9 (I posted previously about this).
> 
> Boy, there's just not a lot between 2.6.23-rc9 and 2.6.23 proper.
> There are two things that kinda pop out, but this is at best a WAG.

Yeah, I looked at the changes and it's all very innocent looking.
More likely in my case, I suppose, is that the bug was there earlier
and then some timing changed somewhere and now it triggers more often.

One supporting evidence of that, is that with the powertop patches applied,
it crashes much less often.  And all that those do is adjust timings in
various places.

> First, are you on x86-32 and happen to have CONFIG_HIGHPTE set?

Core2Duo, 2GB, x86-32, CONFIG_HIGHPTE is not set.

> Second is another memory thing, where in filemap_fault we now do a
> page_cache_release where we didn't before, but that appears to only be
> in a case where we send a sigbus, so I wouldn't expect that to be
> hitting.

It seems to happen most often here on resume from suspend (RAM),
and when hotplugging hardware.  But it's infrequent enough that this
may not be a reliable clue.

Cheers
