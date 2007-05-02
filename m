Return-Path: <linux-kernel-owner+w=401wt.eu-S1767070AbXEBSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767070AbXEBSKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767076AbXEBSKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:10:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54684 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767070AbXEBSKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:10:15 -0400
Subject: Re: Fw: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
From: john stultz <johnstul@us.ibm.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <200704291524.l3TFOL9j013216@harpo.it.uu.se>
References: <200704291524.l3TFOL9j013216@harpo.it.uu.se>
Content-Type: text/plain
Date: Wed, 02 May 2007 11:10:09 -0700
Message-Id: <1178129409.6183.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 17:24 +0200, Mikael Pettersson wrote:
> On Thu, 26 Apr 2007 15:42:44 -0700, john stultz wrote:
> >Another shot in the dark:
> >
> >I wonder if the ACPI PM counter is halting in idle. Does booting w/
> >idle=poll change the behavior? (Please do this while your laptop is
> >plugged in, as it will run the cpu at full speed all the time).
> 
> Bingo!

Awesome! Finally, some progress! Thanks again for putting up w/ all my
testing requests.

> I booted the x86-64 2.6.21 final kernel with idle=poll and let the
> laptop idle for an hour. The ondemand cpufreq governor did reduce
> the CPU's clock frequency, but that shouldn't have affected the
> chipset or the ACPI PM counter.
> 
> Anyway, after 60 minutes `date' and `hwclock' were still in perfect
> sync and matched actual time.
> 
> Any ideas why this halting in idle doesn't happen with the 32-bit kernel?

No clue. Time to ask Len. :)

Hey Len,
	So that slow acpi_pm on x86_64 seems to be connected w/ the idle loop.
I'm guessing the chipset halts the ACPI PM in lower C states. Do you
have any guesses as to what might differ between x86_64 and i386 ACPI
idle loops? Or might this be something different in what the BIOS
exports in x86_64 mode or i386 mode?

Any suggestions on how to dig through this?


Thomas: Heads up, the ACPI PM might be flakier then we thought.

thanks
-john



