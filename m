Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYJULGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYJULGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYJULGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:06:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60561 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbYJULGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:06:44 -0400
Message-ID: <48FDB7E7.4090007@redhat.com>
Date: Tue, 21 Oct 2008 07:07:19 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <pzijlstr@redhat.com>
Subject: Re: Scheduler on C2D CPU and latest 2.6.27 kernel
References: <c4e36d110810210259o38897783i2dc4bcb59e8d32e7@mail.gmail.com>
In-Reply-To: <c4e36d110810210259o38897783i2dc4bcb59e8d32e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> Hi
> 
> Recently I'm noticing bad behavior of the CPU scheduler on my T61 (2GB, C2D)
> 
> It looks like Linux concentrates all running tasks on one CPU and the
> second cpu is sleeping.
> 
> With recent changes to DRI - glxgears went up to 840FPS but also takes
> 100% (with Xorg) and when I run 'while :; do true; done' loop in
> parallel frame rate drops to 300FPS.
> 
> But as I have C2D CPU I would expect that there should be no such
> dramatic slowdown.
> 
> Xosview shows that only one CPU is fully loaded.
> 
> Here are my .config scheduler options:
> 
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> # CONFIG_GROUP_SCHED is not set
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_SCHED_SMT=y
> # CONFIG_SCHED_MC is not set
> CONFIG_SCHED_HRTICK=y
> # CONFIG_NET_SCHED is not set
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_SCHED_TRACER=y
> 
> 
> Am I missing something?

You're running a loop that does nothing except create new tasks that have no 
scheduling history, and then disappear before the scheduler can migrate them.

Try running 'openssl speed' to chew up CPU.  I promise you the scheduler will 
behave very nicely.

-- Chris
