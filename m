Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZFWUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZFWUCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZFWUBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:01:54 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:47826 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190AbZFWUBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:01:52 -0400
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [rt-preempt / powerpc] Looks like tick_sched_timer() is a major latency source
Date: Wed, 24 Jun 2009 00:01:47 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Alexander Kaliadin <akaliadin@mvista.com>
References: <200906232055.12412@zigzag.lvk.cs.msu.su> <alpine.LFD.2.00.0906231953480.2767@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906231953480.2767@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906240001.48924@blacky.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I tried hard to identify the latency source, and at some moment
> > discovered tick_sched_timer() from kernel/time/tick-sched.c. This
> > routine is called from timer interrupt with hardware interrupts
> > disabled, and may execute for 50 us and more.
> >
> > Could someone please comment on this?
>
> Did you have CONFIG_NOHZ enabled ? If yes, please disable.

I have disabled CONFIG_NOHZ long ago, since it really influences latency.

> > Is it possible to move (part of) tick_sched_timer() call tree out of
> > hardware-interrupts-disabled context without breaking things?
>
> Yes, we can move things out and split the irq disabled regions. One
> particular thing which can be split out is the time update, which we
> already had in the timer softirq at some point, but we moved it back
> as it showed problems with NTP stability. It's one of the things which
> can be revisited. The whole call chain needs some investigation, but
> that's not in my main focus now.

Is that code with time update split out available anywhere?

Nikita
