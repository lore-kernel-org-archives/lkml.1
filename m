Return-Path: <linux-kernel-owner+w=401wt.eu-S1946189AbXBPSYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946189AbXBPSYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946194AbXBPSYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:24:46 -0500
Received: from [221.217.24.227] ([221.217.24.227]:56884 "EHLO
	freya.yggdrasil.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946189AbXBPSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:24:44 -0500
Date: Sat, 17 Feb 2007 02:26:42 +0800
From: "Adam J. Richter" <adam@yggdrasil.com>
Message-Id: <200702161826.l1GIQg9j019462@freya.yggdrasil.com>
To: dwalker@mvista.com
Subject: Re: Clock running at half speed in 2.6.20?
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 08:24:54 -0800, Daniel Walker wrote:
>On Fri, 2007-02-16 at 22:28 +0800, Adam J. Richter wrote:
>> 	My system clock runs at approximately half speed in
>> linux-2.6.20, 2.6.20-git10 and 2.6.20-git11.
[...]

>cat /sys/devices/system/clocksource/clocksource0/current_clocksource

tsc

>cat /sys/devices/system/clocksource/clocksource0/available_clocksource

acpi_pm jiffies tsc

	When I rebooted with "max_cpus=1", available_clocksource included a
fourth option "pit".

       I have some bad news.  The problem is sporadic.  Here are the
logs of the tests that I have made, in the order in which I recall
making them:

2.6.20-git11		problem occurred
2.6.20-git10		problem occurred
2.6.20			problem occurred
2.6.18.1		no problem
	[At this point, I made my original posting.]

2.6.20-git11 maxcpus=1	no problem
	...checked current_clocksource, was tsc			   

2.6.18.1		no problem
	...checked current_clocksource, was tsc			   

2.6.20-git11		no problem (this is bad!)
	checked current_clocksource, was tsc
	set clocksource=acpi_pm, still no problem
	set clocksource=jiffies, still no problem

power cycled computer, unplugging power supply and powered down monitor

2.6.20-git11		no problem (this is bad!)
	checked current_clocksource, was tsc

	At first, I was very happy to see the problem disappear after
rebooting 2.6.20-git11 with "max_cpus=1", as this would tend to
indicate some mistake related to hyperthreading, but, after that I
have been unable to reproduce the problem, so I really don't know that
booting with maxcpus=1 fixed it.  Perhaps the previous boot to
2.6.18.1 did.

	I should also mention, that around the time that I first
noticed the problem, I observed audio stuttering under 2.6.20-git11
regularly, in intervals of perhaps 300 milliseconds, which I suspect
is a symptom of the slow system clock causing the audio driver not to
fill output buffers in time.  Now, when I cannot reproduce the clock
slowdown problem, audio is playing fine under the same 2.6.20-git11
kernel.

	I have observed the audio stuttering a few times in the past
week or so.  The next time it happens, I'll see if the clock slowdown
has returned and I'll record and experiment with the other clock
sources.

	I'll let you know when I have more useful information or mske
other progress related to this problem.

	Thank you for your help!

Adam Richter
