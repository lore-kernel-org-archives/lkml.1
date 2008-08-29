Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbYH2Osd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbYH2Osd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYH2OsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:48:23 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:40016 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758517AbYH2OsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:48:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=GHzKYm7EuEOhSuNyARP4q5hHdYNx2VSTtMRsNlAn1RYV8ms7nLNSp4v7UId4yjsD7E/zEberpho+2YiaMnyv6JQIVLeuu1hZuSURgWtzSdhkh6ow/Cjc8LzfsuOVPnkoJYZlin/YoH0mWVsgQBQ7YOqeeX30rUoPrRa3CNOVmAs=;
X-YMail-OSG: GwcvRBAVM1m8O1HMz1wiVGqxIHJnY.hYSNy7YfeSh2mZNmSVsv1mEMckWUXzn7zBnMRgcErn9aWWsLWU6q9yUfqKY2c1Q1dU8VBvKzWflwxHpldDWxAKzczofORIRgI-
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Fri, 29 Aug 2008 07:48:20 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <860265.84823.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> I installed the kernel and it booted OK.  There was a delay when my
> MTA (exim4) loaded, but that happens sometimes.  However, I got a
> call trace I've never seen before.  This could just be a fluke, but
> I'm passing it along in case it's meaningful.  I grabbed the trace on
> TTY1 by logging in on TTY2 and using 'setterm -append 1':
> 
> ===== SETTERM OUTPUT =====
> Clocksource tsc unstable (delta = -98677795 ns)
> NETDEV WATCHDOG: eth0 (r8169): transmit timed out
> ------------[ cut here ]------------
> WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x21e/0x250()
> Modules linked in: ipv6 cpufreq_userspace pcspkr 8250_pnp 8250 serial_core evdev
> Pid: 0, comm: swapper Not tainted 2.6.27-rc4.080829.yh-patches-tip #1
> Call Trace:
>   [] warn_on_slowpath+0x64/0xb0
> [] printk+0x4e/0x5a
> [] lock_timer_base+0x34/0x70
> [] __mod_timer+0xb0/0xd0
> [] getnstimeofday+0x48/0xc0
> [] dev_watchdog+0x21e/0x250
> [] scheduler_tick+0xcf/0x220
> [] cascade+0x7b/0xa0
> [] dev_watchdog+0x0/0x250
> [] run_timer_softirq+0x13c/0x210
> [] ktime_get+0xc/0x50
> [] __do_softirq+0x73/0xf0
> [] call_softirq+0x1c/0x30
> [] do_softirq+0x35/0x70
> [] irq_exit+0x8d/0x90
> [] smp_apic_timer_interrupt+0x86/0xd0
> [] apic_timer_interrupt+0x66/0x70
>   [] lapic_next_event+0x0/0x20
> [] default_idle+0x3a/0x40
> [] c1e_idle+0x34/0xe0
> [] cpu_idle+0x56/0xa0
> ---[ end trace 28095e4c2b529c2a ]---
> r8169: eth0: link up
> ===== END SETTERM OUTPUT =====
> 
> Other than this strangeness, everything seems OK with your patches.  This
> looks like some random networking annoyance to me, not really related to
> the regression patches, but I'll let better minds be the judge of that.


Update:  this strangeness cannot be reproduced with a couple of reboots, so
I'm thinking it was just bad luck that it happened while testing your patches.


Thanks Yinghai,
DW
