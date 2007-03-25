Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXCYLrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXCYLrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXCYLrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:47:45 -0400
Received: from mail23.syd.optusnet.com.au ([211.29.133.164]:51648 "EHLO
	mail23.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbXCYLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:47:44 -0400
From: Con Kolivas <kernel@kolivas.org>
To: malc <av1474@comtv.ru>
Subject: Re: [patch] sched: accurate user accounting
Date: Sun, 25 Mar 2007 21:46:45 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       zwane@infradead.org, ck list <ck@vds.kolivas.org>,
       ijuz@mannheim.wgermanyrulez.de,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200703251159.03616.kernel@kolivas.org> <20070325075134.GA14453@elte.hu> <Pine.LNX.4.64.0703251521270.11555@linmac.oyster.ru>
In-Reply-To: <Pine.LNX.4.64.0703251521270.11555@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703252146.45721.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 21:34, malc wrote:
> On Sun, 25 Mar 2007, Ingo Molnar wrote:
> > * Con Kolivas <kernel@kolivas.org> wrote:
> >> For an rsdl 0.33 patched kernel. Comments? Overhead worth it?
> >
> > we want to do this - and we should do this to the vanilla scheduler
> > first and check the results. I've back-merged the patch to before RSDL
> > and have tested it - find the patch below. Vale, could you try this
> > patch against a 2.6.21-rc4-ish kernel and re-test your testcase?
>
> [..snip..]
>
> Compilation failed with:
> kernel/built-in.o(.sched.text+0x564): more undefined references to
> `__udivdi3' follow
>
> $ gcc --version | head -1
> gcc (GCC) 3.4.6
>
> $ cat /proc/cpuinfo | grep cpu
> cpu             : 7447A, altivec supported
>
> Can't say i really understand why 64bit arithmetics suddenly became an
> issue here.

Probably due to use of:

#define NS_TO_JIFFIES(TIME)	((TIME) / (1000000000 / HZ))
#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))

Excuse our 64bit world while we strive to correct our 32bit blindness and fix 
this bug.

>
> Am i supposed to run the testcase and see if numbers in `/proc/stat'
> now match the reality closer? To be really accurate `/proc/stat'
> should be left alone methinks, because no matter how good you try the
> fundamential fact that time(and consequently load percentage) is not
> really devided in USER_HZ intervals will interfere with ones quest for
> accurate statistics. (Wonder what this patch will do to slightly modified
> hog that produced this: http://www.boblycat.org/~malc/apc/load-c2d-hog.png
> but this will have to wait till i get to the PC at work)

It should far more accurately represent the cpu usage without any userspace 
changes.

-- 
-ck
