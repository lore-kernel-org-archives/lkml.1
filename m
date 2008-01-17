Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYAQFr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYAQFr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 00:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYAQFrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 00:47:21 -0500
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:34909 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYAQFrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 00:47:20 -0500
Message-ID: <478EEBE4.40400@gmail.com>
Date: Wed, 16 Jan 2008 21:47:16 -0800
From: John Hubbard <john.hubbard@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Pravin Nanaware <p.nanaware@nihilent.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bitops source problem
References: <1145971D427D7F43B0DBDAE22221C4B5035FDDAC@nipns00a210.FPS.NIHILENT.COM>
In-Reply-To: <1145971D427D7F43B0DBDAE22221C4B5035FDDAC@nipns00a210.FPS.NIHILENT.COM>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a340b2e653f5c7e365dae0426e8fce169ef193a6bfc3dd488ada3a64a724b7f3a692ff6d7a9294dc7510c956a98deb90350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 70.231.151.186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pravin Nanaware wrote:
> Hi,
> 
> I was just going through the include file in the /usr/include/asm/bitops.h
> 
> The function description describes it as non-atomic but it seems it is not. 
> 
> static __inline__ void __change_bit(int nr, volatile void * addr)
> {
>         __asm__ __volatile__(
>                 "btcl %1,%0"
>                 :"=m" (ADDR)
>                 :"Ir" (nr));
> }
> 
> The kernel version I am using is 2.6.9-42. Is it right or am I missing something ?  
> 
> Thanks,
> Pravin
> 

The bitops.h comments are correct: the btc IA-32 instruction is only 
atomic if used with the lock prefix. The function above does not use the 
lock prefix, so it is not atomic.

thanks,
John Hubbard

