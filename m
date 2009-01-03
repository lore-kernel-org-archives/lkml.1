Return-Path: <linux-kernel-owner+w=401wt.eu-S932539AbZACBLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbZACBLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbZACBLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:11:09 -0500
Received: from lucidpixels.com ([75.144.35.66]:45246 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287AbZACBLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:11:08 -0500
Date: Fri, 2 Jan 2009 20:11:07 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Kyle McMartin <kyle@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27/2.6.28: irqbalance dies shortly after starting the daemon
 on x86 but not x86_64, why?
In-Reply-To: <20090103010858.GD5181@bombadil.infradead.org>
Message-ID: <alpine.DEB.1.10.0901022010410.19502@p34.internal.lan>
References: <alpine.DEB.1.10.0812300706390.11356@p34.internal.lan> <495E93D4.3060401@linux.intel.com> <alpine.DEB.1.10.0901021931140.19502@p34.internal.lan> <20090103010858.GD5181@bombadil.infradead.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Jan 2009, Kyle McMartin wrote:

> On Fri, Jan 02, 2009 at 07:32:21PM -0500, Justin Piszcz wrote:
>> The CPU = E6700 so yep, so if there is one physical socket with 4 cores it
>> keeps?  For it to keep and not oneshot you need > 2 cores?
>>
>
> It depends... if your 4-core is laid out with four cores sharing one
> external cache, then it will terminate, if, say you had 4 cores with
> each pair sharing a cache (so two external caches) then it would
> continue as a daemon. (If you had 2 sockets with a processor in each
> one, it would continue running as well no matter how many cores on
> each.)
>
> If you run irqbalance --debug, it will show you the topology it detects.
> If you have multiple cache domains, and it is still exiting, then we
> have a bug. :)
>
> cheers, Kyle
>

Looks correct, just a single cache domain on this host-- thanks.

#  irqbalance --debug
Package 0:  cpu mask is 00000003 (workload 0)
         Cache domain 0: cpu mask is 00000003  (workload 0)
                 CPU number 0  (workload 0)
                 CPU number 1  (workload 0)
Interrupt 315 (class ethernet) has workload 20 
Interrupt 0 (class timer) has workload 0 
Interrupt 314 (class storage) has workload 11 
Interrupt 16 (class legacy) has workload 216 
Interrupt 17 (class legacy) has workload 122 
Interrupt 23 (class legacy) has workload 26 
Interrupt 19 (class legacy) has workload 18 
Interrupt 1 (class legacy) has workload 1 
Interrupt 18 (class legacy) has workload 0 
Interrupt 9 (class legacy) has workload 0 
Interrupt 6 (class legacy) has workload 0



-----------------------------------------------------------------------------
IRQ delta is 3963 
Package 0:  cpu mask is 00000003 (workload 2474)
         Cache domain 0: cpu mask is 00000003  (workload 2474)
                 CPU number 0  (workload 1343)
                   Interrupt 314 (storage/13)
                   Interrupt 16 (legacy/1080)
                   Interrupt 19 (legacy/245)
                   Interrupt 18 (legacy/0)
                   Interrupt 6 (legacy/0)
                 CPU number 1  (workload 1131)
                   Interrupt 315 (ethernet/132)
                   Interrupt 17 (legacy/689)
                   Interrupt 23 (legacy/291)
                   Interrupt 1 (legacy/14)
                   Interrupt 9 (legacy/0)


