Return-Path: <linux-kernel-owner+w=401wt.eu-S1755682AbZA1W0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbZA1W0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZA1WZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:25:45 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:41992 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbZA1WZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:25:43 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-03.arcor-online.net A56D22C2FAA
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090128125604.94ed3fe0.akpm@linux-foundation.org>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jan 2009 23:25:07 +0100
Message-Id: <1233181507.6988.14.camel@bugs-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 28.01.2009, 12:56 -0800 schrieb Andrew Morton: 

> (There's testcase code in the bugzilla report)
> 
> (Seems to be a regression)

There is a regression, because of the improved cpu switching. The problem exists in every kernel. 
I takes a lot of time to switch between the threads, when they are executed on different cores.
Perhaps of the big buffer size of 512KB?
 
> > Small improvement while using jiffies as clocksource instead of acpi_pm or hpet
> > (1.8 messages instead of 1.6). Disabling NO_HZ and HIGH_RESOLUTION_TIME gives
> > no improvement. Much higher performance with kernel <= 2.6.24, but still four
> > times slower.
> 
> Unclear.  What is four times slower than what?  You're saying that the
> app progresses four times faster when there are two instances of it
> running, rather than one instance?

About 4 messages every second, while executing only one instance and
about 8 message every second, while executing two instance of the test.
It makes 16 messages every second, when the two threads of a instance is
executed on only one core.

> Seems that 2.6.24 is faster than 2.6.28 with 20 messages, but 2.6.24
> and 2.6.28 run at the same speed when 200 messages are sent?

I have executed the test twenty times. It stays constant on 2.6.28. On
2.6.24 one of ten tests is executed slower.

******* kernel 2.6.28:
All threads finished: 20 messages in 12.853 seconds / 1.556 msg/s
real	0m12.857s
user	0m8.589s
sys	0m16.629s

******* kernel 2.6.24:
All threads finished: 20 messages in 4.939 seconds / 4.050 msg/s
real	0m4.942s
user	0m5.248s
sys	0m4.352s

One of ten executions is going down to 1.806 msg/s.
All threads finished: 20 messages in 11.074 seconds / 1.806 msg/s
real	0m11.077s
user	0m8.817s
sys	0m12.925s

> If so, that seems rather odd, doesn't it?  Is it possible that cpufreq
> does something bad once the CPU gets hot?

I have disabled the acpid, clocked the cpu to 2.4GHz and watched the
temperature of the cores and the frequency. The clock stay always at
2.4GHz and the temperature is always below 67°C. My cpu is clocking down
at 95°C.


