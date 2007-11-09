Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbXKILGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbXKILGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbXKILGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:06:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44081 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbXKILGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:06:18 -0500
Subject: Re: conflict between tickless and perfmon2
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@hpl.hp.com
Cc: perfmon2-devel@lists.sourceforge.net, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20071109104438.GB18909@frankl.hpl.hp.com>
References: <20071109104438.GB18909@frankl.hpl.hp.com>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 11:59:51 +0100
Message-Id: <1194605991.6289.162.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 02:44 -0800, Stephane Eranian wrote:
> Hello,
> 
> We have identified a conflict between TICKLESS (CONFIG_NO_HZ) and
> the current perfmon2 implementation. The problem impacts system-wide
> sessions using timeout-based event set multiplexing.
> 
> Event set multiplexing allows monitoring tools to measure more events
> than there are actual performance counters on the processor. Events
> are grouped in sets which are then multiplexed onto the actual counters.
> Switching can be triggered either by a timeout or by a counter overflow.
> This is supported for per-thread and system-wide sessions.
> 
> For timeout-based switching, the duration expressed in nanoseconds is
> meant to represent wall-clock time in system-wide mode, and execution
> time in per-thread mode. Granularity is limited by HZ.
> 
> The current implementation for timeout is a simple hook on the timer
> interrupt path in apic_*.c:smp_local_timer_interrupt(). Unfortunately,
> this does not work when tickless is enabled: we get much less set
> switches than expected on an idle system.
> 
> It looks like a solution would be to change the implementation of
> timeout-based switching to use HR timers instead. Similar to what is
> done for ITIMER_REAL and ITIMER_VIRTUAL.
> 
> Unless someone has a better proposal, I will experiment with this on
> 2.6.24-rc2.

Might help if you CC the tickless folks :-)

