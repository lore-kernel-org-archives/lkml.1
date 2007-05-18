Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbXERM4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbXERM4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbXERM4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:56:08 -0400
Received: from www.osadl.org ([213.239.205.134]:38758 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754335AbXERM4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:56:07 -0400
Subject: Re: [BUG] local_softirq_pending storm
From: Thomas Gleixner <tglx@linutronix.de>
To: Anant Nitya <kernel@prachanda.info>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705171211.23350.kernel@prachanda.hub>
References: <200705091942.22920.kernel@prachanda.hub>
	 <d95aa510705100453y666cf310ic9ee4dc609f099f1@mail.gmail.com>
	 <1178834326.22481.18.camel@localhost.localdomain>
	 <200705171211.23350.kernel@prachanda.hub>
Content-Type: text/plain
Date: Fri, 18 May 2007 15:01:17 +0200
Message-Id: <1179493277.12981.69.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 12:11 +0530, Anant Nitya wrote:
> On Friday 11 May 2007 03:28:46 Thomas Gleixner wrote:
> 
> > Ok, that's consistent with earlier reports. The problem surfaces when
> > one of the SMT-"cpus" goes idle. The problem goes away when you disable
> > hyperthreading.
> Yes with HT disabled in BIOS there is no local_softirq_pending messages. BTW 
> why does this problem persist only with X ? 

No idea. I uploaded a debug patch against 2.6.22-rc1 to

http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch

Can you give it a try and report the output ?

> > When you apply the ratelimit patch, does the softlockup problem
> > persist ?
> >
> Yes, though softlockup is rare and mostly hit when system is under high load. 
> Apart of that I am also getting following messages consistently across 
> multiple boot cycles with NOHZ=y and ratelimit patch applied.
> 
> May 15 11:51:22 rudra kernel: [ 2594.341068] Clocksource tsc unstable (delta = 
> 28111260302 ns)
> May 15 11:51:22 rudra kernel: [ 2594.343194] Time: acpi_pm clocksource has 
> been installed.

That's informal. The TSC is detected to be unstable and replaced by the
pm timer. Nothing to worry about. It happens with NOHZ=n as well,
right ?

	tglx


