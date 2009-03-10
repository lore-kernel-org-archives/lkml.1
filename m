Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZCJDmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZCJDmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 23:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZCJDmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 23:42:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39231 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZCJDmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 23:42:23 -0400
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
From: John Stultz <johnstul@us.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-s390@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200903100437.29280.elendil@planet.nl>
References: <200903080230.10099.elendil@planet.nl>
	 <1236654582.3792.7.camel@jstultz-laptop>
	 <200903100437.29280.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 20:38:08 -0700
Message-Id: <1236656288.3792.9.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 04:37 +0100, Frans Pop wrote:
> On Tuesday 10 March 2009, John Stultz wrote:
> > > After reverting 5cd1c9c5cf30 and the somewhat related 6c9bacb41c10 on
> > > top of 2.6.28.7, the system boots OK again [1].
> >
> > Huh. No clue right off. What clocksource is in use on this system?
> 
> $ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> tod
> (That's from 2.6.26.)
> 
> > Also can you provide the output with the following patch?
> 
> I already did something similar. Did you see my follow-up mail?

No, sorry, I must have missed it.


> I added:
> +       if (unlikely(clock->xtime_nsec < ((s64)xtime.tv_nsec << clock->shift)))
> +               printk("Negative result: %llu - %lld\n",
> +                       (unsigned long long)clock->xtime_nsec,
> +                       (long long)((s64)xtime.tv_nsec << clock->shift));
> 
> Which resulted in:
>    Negative result: 166039808000 - 166039808256
> 
> Would you still like me to try your patch?

No no, I'll try to look again at your data in the morning.

thanks
-john


