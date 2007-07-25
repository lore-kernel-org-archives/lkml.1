Return-Path: <linux-kernel-owner+w=401wt.eu-S1765354AbXGYXRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765354AbXGYXRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 19:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761038AbXGYXRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 19:17:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:37118 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760155AbXGYXRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 19:17:23 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1/JYU9e30nJUT90+Gs0eHAvGC0koj3ndYjnAkchlU
	jarvRF1MdXv5kM
Date: Thu, 26 Jul 2007 01:17:14 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: Len Brown <lenb@kernel.org>
Cc: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Message-ID: <20070725231714.GA24867@alice>
References: <20070723221630.GA28951@alice> <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com> <20070725113349.GB5469@alice> <200707251250.22469.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707251250.22469.lenb@kernel.org>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22.1 (x86_64)
X-Uptime: 01:14:56 up 14:27,  6 users,  load average: 0.63, 0.60, 0.51
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown (lenb@kernel.org) wrote:
> > > > > [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> > > > > [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
> 
> Note that these are just noise -- new code being verbose when looking for an optional feature.
> 
> The fact that hitting the power button a bunch of times
> to make the system move along suggests some sort of missing interrupt problem --
> most likely the timer itself.
> 
> [   13.868574] Probing IDE interface ide0...
> [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> 
> 5-minutes -- a long probe:-)
> 
> > CONFIG_NO_HZ=y
> 
> does CONFIG_NO_HZ=n make a difference?

[   41.007654] EXT3 FS on hda1, internal journal
[  322.133656] Clocksource tsc unstable (delta = 276476174785 ns)
Boot went fine but the system got pretty unresponsive later, 2-3 seconds
delay after keypresses on an idle system and a hang during shutdown which i had to resolve by
pressing the power button (not to switch it of the hard way, but to keep it rebooting)

> > CONFIG_HIGH_RES_TIMERS=y
> 
> does CONFIG_HIGH_RES_TIMERS=n make a difference?

doesnt change anything

> does "irqpoll" make any difference?
> does "notsc" make any difference?
> does "idle=poll" make any difference?

I tried these with the HIGH_RES_TIMERS=n, irqpoll and notsc dont change
a thing, idle=poll makes it boot normally


Greetings, Eric
