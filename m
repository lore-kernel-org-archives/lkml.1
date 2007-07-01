Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXGAHlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXGAHlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbXGAHiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:38:12 -0400
Received: from newpeace.netnation.com ([204.174.223.7]:60241 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757037AbXGAHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:38:08 -0400
X-Greylist: delayed 2440 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jul 2007 03:38:08 EDT
Date: Sat, 30 Jun 2007 23:57:26 -0700
From: Simon Kirby <sim@netnation.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: run_posix_cpu_timers panic on v2.6.22-rc6
Message-ID: <20070701065726.GA20619@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Having recently upgraded our Asterisk server, I figured it would be a
good time to try a NO_HZ kernel.  Everything was running well, until...
it decided to panic.
 
All I have is a fuzzy picture of the console to work from.  The panic
was a fatal exception in interrupt, with EIP within run_posix_cpu_timers.
I can't quite read the offsets, but the stack backtrace was:

	run_rebalance_domains
	scheduler_tick
	tick_periodic
	tick_handle_periodic
	smp_apic_timer_interrupt
	apic_timer_interrupt
	default_idle
	default_idle
	cpu_idle
	start_kernel

Seeing as this is all new code and the box has been otherwise stable for
the past 3 years, there is probably a problem stil lurking in the NO_HZ
code somewhere.  But, it looks like I don't have any other info.  I'll
try to get a better shot of the Oops next time...

Simon-
