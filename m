Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbXHCO46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbXHCO46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763466AbXHCO4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:56:48 -0400
Received: from mail.tpi.com ([198.107.51.143]:3705 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763420AbXHCO4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:56:47 -0400
X-Greylist: delayed 2278 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Aug 2007 10:56:47 EDT
Message-ID: <46B33947.7020800@canonical.com>
Date: Fri, 03 Aug 2007 08:18:47 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ben Collins <ben.collins@ubuntu.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit kernel
References: <1186150484.8105.57.camel@cunning>
In-Reply-To: <1186150484.8105.57.camel@cunning>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One other option that allows these systems to boot is 'acpi=off', though
that is hardly useful on a laptop.

rtg

Ben Collins wrote:
> Tim and I have both experienced this problem. With 2.6.20 things worked
> perfectly fine on these systems. The two machines are a Dell 1501 Turion
> X2 and Dell 1521 Turion X2.
> 
> With 2.6.22 the kernel hangs shortly after starting up, but after
> several minutes, you can get activity by tapping keyboard (generating
> interrupts). We have NO_HZ and HIGH_RES enabled, but even disabling this
> doesn't help.
> 
> I've tried every combination of boot param revolving around clocksource
> and interrupts. The only thing that gets me booting is nolapic, but then
> again, that knocks me down to a single cpu. Setting maxcpus=1 or nosmp
> doesn't fix it.
> 
> We both bisected (separately I might add) down to this commit:
> 
> commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Feb 16 01:28:04 2007 -0800
> 
>     [PATCH] clockevents: i386 drivers
> 
>     Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
>     the timer IRQ to call into the PIT/HPET driver's event handler and the
>     lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
>     timer functionality is delegated to the core framework code and replaces the
>     compile and runtime evalution in do_timer_interrupt_hook()
> 
>     Use the clockevents broadcast support and implement the lapic_broadcast
>     function for ACPI.
> 
>     No changes to existing functionality.
> 
> Note, the problem doesn't happen when using an x86_64 kernel with the
> same basic config, on the same machine.
> 
> Hoping to get some tips to test something a bit more specific in this
> patch.
> 


-- 
Tim Gardner tim.gardner@ubuntu.com
