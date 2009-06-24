Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZFXJ3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZFXJ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZFXJ3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:29:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42451 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752999AbZFXJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:29:05 -0400
Date: Wed, 24 Jun 2009 10:29:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Miroslav Lichvar <mlichvar@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090624102915.4df3fa85@lxorguk.ukuu.org.uk>
In-Reply-To: <1245793316.3305.5.camel@localhost>
References: <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
	<1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
	<20090616090647.GD13771@elte.hu>
	<20090616125248.GA23541@localhost>
	<1245253102.6067.94.camel@jstultz-laptop>
	<20090617172325.GA32332@localhost>
	<20090617172601.GA3493@elte.hu>
	<20090618121320.GA13025@localhost>
	<20090623095745.GC30634@elte.hu>
	<20090623131628.GA11827@localhost>
	<20090623133625.GA3026@elte.hu>
	<1245793316.3305.5.camel@localhost>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-06-23 at 15:36 +0200, Ingo Molnar wrote:
> > The PPS patches i've seen just export IRQ timestamps to user-space.

Correct. They improve the sampling information quality and help cut down
on jitter between the IRQ sampling and using the timestamp. The jitter is
what matters most here and NTP can figure out constant latencies rather
well.

> At some point that stops being NTP. NTP has quite a bit of userland
> policy for filtering and managing a number of different network clocks
> (other ntp servers, PPS sources, etc).
> 
> >From what you're describing (direct offset from a hardware time device
> used to steer the clock directly in kernel), you might want to look at
> the STP code in s390 (stp_sync_clock).

And also hardware distributed timing systems like those that distribute a
clock with ethernet signals.

Alan
