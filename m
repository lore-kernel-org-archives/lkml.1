Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0BHKHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:07:32 -0500
Received: from www.tglx.de ([62.245.132.106]:51907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab0BHKHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:07:31 -0500
Date: Mon, 8 Feb 2010 11:06:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
 (2.6.33-rc6/7)
In-Reply-To: <20100208093719.GA15428@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain>
 <20100208093719.GA15428@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Andreas Mohr wrote:
> > Nope, the NMI watchdog is not involved. It merily tells us that the
> > task is stuck.
> 
> OK.
> And after that message debug_locks is zeroed and kwatchdog is gone
> from the process list (probably during debug_locks change).

Oh, no. kwatchdog is a run once thread. It always exits after work is
done, but I'm pretty confused about the NMI watchdog output.

EIP: 0060:[<c1045170>] EFLAGS: 00000082 CPU: 0
EIP is at timekeeping_forward_now+0x116/0x139

I don't see what might make the machine stuck here. Can you decode the
source line with "addr2line -e vmlinux c1045170" please ?

> I'll explain what I think might be happening:
> bootup switches to acpi_pm, timekeeping gets borked, NMI watchdog complains
> due to timekeeping issues, brutally yanks the waiting acpi_pm switchover
> (thereby NOT releasing clocksource_mutex),

No, the NMI watchdog does not yank anything. It just reports.

Thanks,

	tglx
