Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZFWTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZFWTNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZFWTNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:13:07 -0400
Received: from www.tglx.de ([62.245.132.106]:39845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZFWTNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:13:07 -0400
Date: Tue, 23 Jun 2009 21:11:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
cc: linux-kernel@vger.kernel.org, Alexander Kaliadin <akaliadin@mvista.com>
Subject: Re: [rt-preempt / powerpc] Looks like tick_sched_timer() is a major
 latency source
In-Reply-To: <200906232055.12412@zigzag.lvk.cs.msu.su>
Message-ID: <alpine.LFD.2.00.0906231953480.2767@localhost.localdomain>
References: <200906232055.12412@zigzag.lvk.cs.msu.su>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Nikita V. Youshchenko wrote:
> I tried hard to identify the latency source, and at some moment discovered 
> tick_sched_timer() from kernel/time/tick-sched.c. This routine is called 
> from timer interrupt with hardware interrupts disabled, and may execute 
> for 50 us and more.
> 
> Could someone please comment on this?

Did you have CONFIG_NOHZ enabled ? If yes, please disable.

> Is it possible to move (part of) tick_sched_timer() call tree out of 
> hardware-interrupts-disabled context without breaking things?

Yes, we can move things out and split the irq disabled regions. One
particular thing which can be split out is the time update, which we
already had in the timer softirq at some point, but we moved it back
as it showed problems with NTP stability. It's one of the things which
can be revisited. The whole call chain needs some investigation, but
that's not in my main focus now.

Thanks,

	tglx


