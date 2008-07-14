Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYGNJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYGNJah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbYGNJa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:30:29 -0400
Received: from www.tglx.de ([62.245.132.106]:51379 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbYGNJa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:30:27 -0400
Date: Mon, 14 Jul 2008 11:30:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH, RFC] use hrtimer in sched_clock
In-Reply-To: <1215809727-28598-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
Message-ID: <alpine.LFD.1.10.0807141123450.3283@apollo.tec.linutronix.de>
References: <1215809727-28598-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1581213271-1216027802=:3283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1581213271-1216027802=:3283
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 11 Jul 2008, Uwe Kleine-König wrote:
> This should make it unnecessary to overwrite sched_clock for a higher
> precision.
> With this patch I get sub-jiffie timing with CONFIG_PRINTK_TIME=y.
> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> Hello,
> 
> I tested the patch on arch-arm/mach-ns9xxx and it seem seams to work.
> But I admit I didn't test it deeply and I didn't measure if there is any
> overhead.

There is lots of overhead and your approach is simply wrong. 

>  unsigned long long __attribute__((weak)) sched_clock(void)

The correct way to solve it is to override sched_clock() with a high
resolution implementation for your hardware platform. sched_clock is a
weak function to provide a default implementation based on jiffies.

If you do a grep -r sched_clock arch/arm you'll find a couple of
examples how to override sched_clock().

Thanks,

	tglx
--8323328-1581213271-1216027802=:3283--
