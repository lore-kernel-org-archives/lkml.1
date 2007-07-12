Return-Path: <linux-kernel-owner+w=401wt.eu-S1765753AbXGLQ1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765753AbXGLQ1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758536AbXGLQ05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:26:57 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:46855 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758383AbXGLQ04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:26:56 -0400
Message-Id: <46961E080200005A000276AE@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 12 Jul 2007 12:26:48 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <mingo@elte.hu>
Cc: <jim.houston@ccur.com>, <joe.korty@ccur.com>, <rostedt@goodmis.org>,
       <tglx@linutronix.de>, <dwalker@mvista.com>,
       "David Bahi" <DBahi@novell.com>, "Moiz Kohari" <MKohari@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <williams@redhat.com>, <abogani@texware.it>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 14:07 +0200, Ingo Molnar wrote:
> great! We had the upstream -rt port to .22 in the works too, it was just 
> held up by the hpet breakage - which Thomas managed to fix earlier 
> today. I've released the 2.6.22.1-rt1 patch to the usual place:
> 
>     http://redhat.com/~mingo/realtime-preempt/

Hi Ingo,
  For the most part, it seems you guys have resolved most of the issues
that we ran into as well (e.g. early-flush-tlb, relocated die-notifier,
etc, come to mind).  I found one patch that was missing that allows
debug configurations to build properly.  Heres that patch:

--- linux-2.6.21.orig/kernel/latency_trace.c
+++ linux-2.6.21/kernel/latency_trace.c
@@ -24,6 +24,7 @@
 #include <linux/utsrelease.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
+#include <asm/asm-offsets.h>
 #include <asm/rtc.h>
 #include <linux/stacktrace.h>

With this patch in place, I am able to build/boot both a 21.1-rt1 kernel
with a standard x86_64 PREEMPT_RT+SMP both with and without the usual
debug options, so that is great!

We did find a regression.  I was mistaken earlier when I mentioned our
T60p laptops couldn't boot.  It turns out that issue was resolved
somewhere along the way and our published patches based on 21.5-rt19 do
allow the laptop to boot event with acpi=on.  With 22.1-rt1 the laptop
crashes unless acpi=off.  Now that we have your queue we will bisect
this and post that fix as well.

Thanks!
-Greg


