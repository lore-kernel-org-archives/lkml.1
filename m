Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZCTO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZCTO1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZCTO1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:27:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:10838 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbZCTO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:27:29 -0400
Message-ID: <49C3A7CA.8040500@monstr.eu>
Date: Fri, 20 Mar 2009 15:27:22 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu> <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu> <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C3A346.5040202@monstr.eu> <alpine.LFD.2.00.0903201508470.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903201508470.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
> Michal,
> 
> On Fri, 20 Mar 2009, Michal Simek wrote:
>>> I guess the problem is in your chip->xxx functions.
>> I fixed it. There were one additional line.
>> + I set GENERIC_HARDIRQS_NO__DO_IRQ=y.
> 
> Cool.

:-)

NO_HZ works too. Here is the log.

# cat /proc/interrupts
                CPU0
  3:       3827     level     INTC  timer
  8:       1834      edge     INTC  uartlite
# uptime
 00:16:47 up 16 min, load average: 0.00, 0.00, 0.00
# uptime
 00:17:53 up 17 min, load average: 0.00, 0.00, 0.00
# cat /proc/interrupts
                CPU0
  3:       4105     level     INTC  timer
  8:       1913      edge     INTC  uartlite
# uptime
 00:21:44 up 21 min, load average: 0.00, 0.00, 0.00
# cat /proc/interrupts
                CPU0
  3:       4615     level     INTC  timer
  8:       1970      edge     INTC  uartlite
#

> 
>> BTW: Below is full chip description where function enable is unmask
>> and disable is mask. Do I have keep there enable and disable function pointers?
>> I commented them and works without them too.
> 
> Right. The generic code does:
> 
>         if (!chip->enable)
>                 chip->enable = default_enable;
>         if (!chip->disable)
>                 chip->disable = default_disable;

I look at default implementation and seems to me that I can save some
instruction when I use my enable function not generic one and for disabling is
default function faster because do nothing.
I am going to send one email with full intc.c + 2 changes - one in irq.c and
second in Kconfig.

Thanks,
Michal

> 
> Thanks,
> 
> 	tglx


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
