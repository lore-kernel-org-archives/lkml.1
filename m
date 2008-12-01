Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYLALA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYLALA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYLALAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:00:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46399 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYLALAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:00:14 -0500
Date: Mon, 1 Dec 2008 10:59:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] keypad/touchscreen driver events latencies using LTTng on ARM?
Message-ID: <20081201105956.GC28971@flint.arm.linux.org.uk>
References: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com> <20081201103502.GC25340@Krystal> <20081201104529.GB28971@flint.arm.linux.org.uk> <20081201105737.GE25340@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201105737.GE25340@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 05:57:37AM -0500, Mathieu Desnoyers wrote:
> Ok, so for LTTng on ARM it would make sense to use the same clock source
> as sched_clock for :
> mach-pxa, mach-realview, mach-sa1100, mach-versatile, plat-omap.
> 
> We basically have, for each of these build scenarios, to take the mmio
> clock used by sched_clock and use it through
> kernel/trace/trace-clock-32-to-64 to extend it to 64-bits. Therefore we
> won't suffer from any of the constrains linked to cnt32_to_63 and we
> would be sure that the trace clock is correct wrt SMP wrt memory
> barriers and cache line bouncing because it uses per-cpu data to keep
> the counters.

Just remember that MMIO clock sources are not available until after
setup_arch() has finished - in other words, they don't work when the
kernel initially boots.  Accessing them too early will cause a page
fault and hang the kernel.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
