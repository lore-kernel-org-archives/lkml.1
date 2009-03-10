Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbZCJDkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbZCJDkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 23:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZCJDj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 23:39:56 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:53542 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbZCJDjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 23:39:55 -0400
From: Frans Pop <elendil@planet.nl>
To: John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
Date: Tue, 10 Mar 2009 04:37:27 +0100
User-Agent: KMail/1.9.9
Cc: linux-s390@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080230.10099.elendil@planet.nl> <1236654582.3792.7.camel@jstultz-laptop>
In-Reply-To: <1236654582.3792.7.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903100437.29280.elendil@planet.nl>
X-OriginalArrivalTime: 10 Mar 2009 03:37:30.0033 (UTC) FILETIME=[8A2B4210:01C9A131]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 March 2009, John Stultz wrote:
> > After reverting 5cd1c9c5cf30 and the somewhat related 6c9bacb41c10 on
> > top of 2.6.28.7, the system boots OK again [1].
>
> Huh. No clue right off. What clocksource is in use on this system?

$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tod
(That's from 2.6.26.)

> Also can you provide the output with the following patch?

I already did something similar. Did you see my follow-up mail?

I added:
+       if (unlikely(clock->xtime_nsec < ((s64)xtime.tv_nsec << clock->shift)))
+               printk("Negative result: %llu - %lld\n",
+                       (unsigned long long)clock->xtime_nsec,
+                       (long long)((s64)xtime.tv_nsec << clock->shift));

Which resulted in:
   Negative result: 166039808000 - 166039808256

Would you still like me to try your patch?

Cheers,
FJP
