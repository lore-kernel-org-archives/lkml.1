Return-Path: <linux-kernel-owner+w=401wt.eu-S1945971AbXBPQ0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945971AbXBPQ0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945981AbXBPQ0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:26:55 -0500
Received: from h190.mvista.com ([63.81.120.158]:31765 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1945971AbXBPQ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:26:54 -0500
Subject: Re: Clock running at half speed in 2.6.20?
From: Daniel Walker <dwalker@mvista.com>
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200702161428.l1GESUw9008969@freya.yggdrasil.com>
References: <200702161428.l1GESUw9008969@freya.yggdrasil.com>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 08:24:54 -0800
Message-Id: <1171643094.3422.6.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 22:28 +0800, Adam J. Richter wrote:
> 	My system clock runs at approximately half speed in
> linux-2.6.20, 2.6.20-git10 and 2.6.20-git11.  That is, it takes about
> two hours for "date" to report that one hour has elapsed.  "hwclock"
> returns the correct time, of course.
> 
> 	I do not have this problem in linuux 2.6.18.1.  I will try to
> narrow down the kernel version where this problem began.
> 
> 	The motherboard in question is an asus p4v8000-x, running a
> 2.8GHz Pentium 4 that has two hyperthreads, which I suspect may be the
> problem.  I am just guessing, but perhaps some piece of code thinks
> the two hyperthreads are separate CPU's receving twice as many clock
> interrupts total.  I expect to try to some experimentation to check
> this theory.
> 
> 	For what it's worth, I am running CONFIG_PREEMPT=y,
> CONFIG_PREEMPT_BKL=y, CONFIG_HZ=1000.


if you run,

cat /sys/devices/system/clocksource/clocksource0/current_clocksource

it will tell you which hardware clock is being used by the kernel. You
can also run,

cat /sys/devices/system/clocksource/clocksource0/available_clocksource

which will tell you which clocks are available on your system. You
switch clocks by echoing the name of a clock into "current_clocksource"

As an example, the following switches to the acpi_pm clocksource,

echo "acpi_pm"> /sys/devices/system/clocksource/clocksource0/current_clocksource

The hardware clock that your using could be running to slow. I would
recommend switching the hardware clock and re-check if the time is still
half speed.

Daniel

