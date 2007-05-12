Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXELP1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXELP1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXELP06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:26:58 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:36191 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbXELP06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:26:58 -0400
Message-ID: <4645DCA2.80408@cosmosbay.com>
Date: Sat, 12 May 2007 17:26:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Esben Nielsen <nielsen.esben@googlemail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
References: <20070511131541.992688403@chello.nl>  <Pine.LNX.4.64.0705121120210.26287@frodo.shire> <1178964103.6810.55.camel@twins> <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
In-Reply-To: <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 12 May 2007 17:26:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Esben Nielsen a écrit :
> 
> 
> On Sat, 12 May 2007, Peter Zijlstra wrote:
> 
>> On Sat, 2007-05-12 at 11:27 +0200, Esben Nielsen wrote:
>>>
>>> On Fri, 11 May 2007, Peter Zijlstra wrote:
>>>
>>>>
>>>> I was toying with a scalable rw_mutex and found that it gives ~10% 
>>>> reduction in
>>>> system time on ebizzy runs (without the MADV_FREE patch).
>>>>
>>>
>>> You break priority enheritance on user space futexes! :-(
>>> The problems is that the futex waiter have to take the mmap_sem. And as
>>> your rw_mutex isn't PI enabled you get priority inversions :-(
>>
>> Do note that rwsems have no PI either.
>> PI is not a concern for mainline - yet, I do have ideas here though.
>>
>>
> If PI wasn't a concern for mainline, why is PI futexes merged into the 
> mainline?

If you really care about futexes and mmap_sem, just use private futexes, since 
they dont use mmap_sem at all.


