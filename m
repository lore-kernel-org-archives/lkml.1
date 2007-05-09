Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXEIJN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXEIJN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbXEIJNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:13:06 -0400
Received: from aun.it.uu.se ([130.238.12.36]:57010 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbXEIJNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:13:04 -0400
Date: Wed, 9 May 2007 11:11:17 +0200 (MEST)
Message-Id: <200705090911.l499BHJL016845@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: lenb@kernel.org, mikpe@it.uu.se
Subject: Re: Fw: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
Cc: ak@suse.de, johnstul@us.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 15:14:36 -0400, Len Brown wrote:
> On Friday 04 May 2007 03:42, Mikael Pettersson wrote:
> > On Thu, 03 May 2007 19:38:50 -0700, john stultz wrote:
> > > > 	So that slow acpi_pm on x86_64 seems to be connected w/ the idle loop.
> > > > I'm guessing the chipset halts the ACPI PM in lower C states. Do you
> > > > have any guesses as to what might differ between x86_64 and i386 ACPI
> > > > idle loops? Or might this be something different in what the BIOS
> > > > exports in x86_64 mode or i386 mode?
> > > 
> > > Mikael,
> > > 	Just trying to dig a bit more through the acpi_processor_idle code.
> > > Could you run "cat /proc/acpi/processor/CPU1/power" and reply w/ the
> > > output?
> > 
> > Here's that file with the x86-64 kernel:
> > 
> > active state:            C2
> > max_cstate:              C8
> > bus master activity:     00000000
> > maximum allowed latency: 20000 usec
> > states:
> >     C1:                  type[C1] promotion[C2] demotion[--] latency[000] usage[00107840] duration[00000000000000000000]
> >    *C2:                  type[C2] promotion[--] demotion[C1] latency[010] usage[-1987043693] duration[00000000003044809185]
> 
> it may be that the problem is C2, not C1 on this box and thus "idle=poll" may be
> overkill to workaround it.
> 
> You can disable C2 with "processor.max_cstate=1"
> 
> still a mystery, though, why this is different on i386 vs x86_64.
> what is in this file when booted in i386 mode?

With the i386 kernel it's as follows:

active state:            C2
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 20000 usec
states:
    C1:                  type[C1] promotion[C2] demotion[--] latency[000] usage[00004550] duration[00000000000000000000]
   *C2:                  type[C2] promotion[--] demotion[C1] latency[010] usage[00813483] duration[00000000023188005661]

/Mikael
