Return-Path: <linux-kernel-owner+w=401wt.eu-S1750998AbXCYLfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750998AbXCYLfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXCYLfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:35:07 -0400
Received: from comtv.ru ([217.10.32.17]:34196 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbXCYLfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:35:05 -0400
X-UCL: actv
Date: Sun, 25 Mar 2007 15:34:48 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Ingo Molnar <mingo@elte.hu>
cc: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>, zwane@infradead.org,
       ck list <ck@vds.kolivas.org>, ijuz@mannheim.wgermanyrulez.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <20070325075134.GA14453@elte.hu>
Message-ID: <Pine.LNX.4.64.0703251521270.11555@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org> <20070325075134.GA14453@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Ingo Molnar wrote:

>
> * Con Kolivas <kernel@kolivas.org> wrote:
>
>> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
>
> we want to do this - and we should do this to the vanilla scheduler
> first and check the results. I've back-merged the patch to before RSDL
> and have tested it - find the patch below. Vale, could you try this
> patch against a 2.6.21-rc4-ish kernel and re-test your testcase?

[..snip..]

Compilation failed with:
kernel/built-in.o(.sched.text+0x564): more undefined references to `__udivdi3' follow

$ gcc --version | head -1
gcc (GCC) 3.4.6

$ cat /proc/cpuinfo | grep cpu
cpu             : 7447A, altivec supported

Can't say i really understand why 64bit arithmetics suddenly became an
issue here.

Am i supposed to run the testcase and see if numbers in `/proc/stat'
now match the reality closer? To be really accurate `/proc/stat'
should be left alone methinks, because no matter how good you try the
fundamential fact that time(and consequently load percentage) is not
really devided in USER_HZ intervals will interfere with ones quest for
accurate statistics. (Wonder what this patch will do to slightly modified
hog that produced this: http://www.boblycat.org/~malc/apc/load-c2d-hog.png
but this will have to wait till i get to the PC at work)

-- 
vale (this is not name/nick/alias, this is latin for farewell)
