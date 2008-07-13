Return-Path: <linux-kernel-owner+w=401wt.eu-S1756752AbYGMVcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752AbYGMVcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYGMVcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:32:23 -0400
Received: from gw.goop.org ([64.81.55.164]:53073 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbYGMVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:32:23 -0400
Message-ID: <487A745A.3010902@goop.org>
Date: Sun, 13 Jul 2008 14:32:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@timesys.com
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
References: <200807130127.36706.jozwicki@aster.pl> <200807131517.51795.jozwicki@aster.pl> <487A3F75.5010405@goop.org> <200807132053.30849.jozwicki@aster.pl>
In-Reply-To: <200807132053.30849.jozwicki@aster.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub W. Jozwicki wrote:
> Sunday, 13 of July 2008 19:46:29 Jeremy Fitzhardinge napisał(a):
>   
>> Jakub W. Jozwicki wrote:
>>     
>>> Sorry, this was for -rt only.
>>>
>>> [   17.012011] BUG: sleeping function called from invalid context
>>> IRQ-14(5732) at arch/x86/mm/highmem_32.c:8
>>> [   17.012011] in_atomic():0 [00000000], irqs_disabled():1
>>> [   17.012011] Pid: 5732, comm: IRQ-14 Not tainted 2.6.25.10-rtXXX #11
>>> [   17.012011]  [<c0120fc4>] __might_sleep+0xf1/0xf8
>>> [   17.012011]  [<c011c035>] kmap+0x47/0x5a
>>>       
>> The subject says kmap_atomic, but this is kmap.  It definitely makes no
>> sense to call kmap in an IRQ, regardless of the locking.  There seems to
>> be a larger structural problem here.
>>
>>     
>
> --- linux-2.6.25.8-rt7.orig/include/asm-x86/highmem.h   2008-06-23 
> 19:12:47.000000000 -0400
> +++ linux-2.6.25.8-rt7/include/asm-x86/highmem.h        2008-06-23 
> 19:13:58.000000000 -0400
>
>
> +/*
> + * on PREEMPT_RT kmap_atomic() is a wrapper that uses kmap():
>   

OK, I guess the "structural problem" is RT ;)

    J
