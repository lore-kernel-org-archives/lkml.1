Return-Path: <linux-kernel-owner+w=401wt.eu-S1031497AbXEHTQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031497AbXEHTQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031476AbXEHTQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:16:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031387AbXEHTQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:16:11 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: Fw: [BUG 2.6.21-rc7] acpi_pm clocksource loses time on x86-64
Date: Tue, 8 May 2007 15:14:36 -0400
User-Agent: KMail/1.9.5
Cc: johnstul@us.ibm.com, ak@suse.de, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
References: <200705040742.l447gJPR027148@harpo.it.uu.se>
In-Reply-To: <200705040742.l447gJPR027148@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705081514.36958.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 03:42, Mikael Pettersson wrote:
> On Thu, 03 May 2007 19:38:50 -0700, john stultz wrote:
> > > 	So that slow acpi_pm on x86_64 seems to be connected w/ the idle loop.
> > > I'm guessing the chipset halts the ACPI PM in lower C states. Do you
> > > have any guesses as to what might differ between x86_64 and i386 ACPI
> > > idle loops? Or might this be something different in what the BIOS
> > > exports in x86_64 mode or i386 mode?
> > 
> > Mikael,
> > 	Just trying to dig a bit more through the acpi_processor_idle code.
> > Could you run "cat /proc/acpi/processor/CPU1/power" and reply w/ the
> > output?
> 
> Here's that file with the x86-64 kernel:
> 
> active state:            C2
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 20000 usec
> states:
>     C1:                  type[C1] promotion[C2] demotion[--] latency[000] usage[00107840] duration[00000000000000000000]
>    *C2:                  type[C2] promotion[--] demotion[C1] latency[010] usage[-1987043693] duration[00000000003044809185]

it may be that the problem is C2, not C1 on this box and thus "idle=poll" may be
overkill to workaround it.

You can disable C2 with "processor.max_cstate=1"

still a mystery, though, why this is different on i386 vs x86_64.
what is in this file when booted in i386 mode?

-Len
