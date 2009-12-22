Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZLVLcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZLVLcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 06:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZLVLcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 06:32:41 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:59667 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZLVLck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 06:32:40 -0500
Message-ID: <4B30AE47.7040703@gmail.com>
Date: Tue, 22 Dec 2009 12:32:23 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Kevin Constantine <kevin.constantine@gmail.com>, netdev@vger.kernel.org,
       linux kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: Kernel Panics in the network stack
References: <4B309AED.7080601@gmail.com> <1261480105.29570.15.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1261480105.29570.15.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 22 Dec 2009 12:32:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22/12/2009 12:08, Catalin Marinas a écrit :
> On Tue, 2009-12-22 at 10:09 +0000, Eric Dumazet wrote:
>> __switch_to:
>>
>> ...
>>         ldm r4, {r4, r5, r6, r7, r8, r9, sl, fp, sp, pc}
> 
> It looks to me like it is possible to get an interrupt after SP was
> loaded but before PC, the stack could be corrupted and PC would be
> loaded with garbage. One instance of your oops messages looks like PC
> corruption but the other may be caused by something else. What ARM CPU
> are you using?

I saw other very strange corruptions (registers R6 & R7) as well, on Kevin supplied traces.

> 
> I'm cc'ing Russell as well, it's strange that we haven't got any issue
> with this so far.

Oh well, it seems I CC'ed Rusty Russel instead :)

> 
> You could try #undef'ing __ARCH_WANT_INTERRUPTS_ON_CTXSW in
> arch/arm/include/asm/system.h as a sanity check for your aborts.
> 

Kevin uses linuxstamp card, from open circuits :

http://www.opencircuits.com/Linuxstamp

It's a AT91RM9200 processor (Arm9 with MMU, 180MHz )

Thanks
