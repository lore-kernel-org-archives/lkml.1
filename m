Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114AbXCST5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbXCST5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbXCST5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:57:05 -0400
Received: from www.osadl.org ([213.239.205.134]:45730 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753114AbXCST5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:57:03 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
	 <1174332477.13341.561.camel@localhost.localdomain>
	 <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 21:04:06 +0100
Message-Id: <1174334646.13341.577.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 20:49 +0100, Stefan Prechtel wrote:
> > Can you please boot with 2.6.20 or earlier and check the output
> > of /proc/interrupts ?
> >
> > IRQ#0 and the LOC (local APIC timer) Interrupts should increment in the
> > same frequency.
> >
> >         tglx
> 
> Here is the output of /proc/interrupts on 2.6.20:
>            CPU0       CPU1
>   0:       7089          0  local-APIC-edge-fasteio   timer
> ....

Can you provide the numbers for LOC too ?
  0:   29801420   29793520    IO-APIC-edge  timer
...
LOC:  119180305  119180039

And please do a sleep 10; between two reads, so I can see the deltas.

> and this on 2.6.21-rc*:
>            CPU0       CPU1
>   0:        255          0  local-APIC-edge-fasteoi   timer
> ....
> 
> on 2.6.21-rc* the number "255" doesn't change.

Yes. I know. We rely on the local APIC, if the ACPI code does us not
tell to use the PIT broadcast, sigh.

> But if it is ACPI relevant, shouldn't it boot with acpi=off?
> I've tried with acpi=off and noapic but only with nolapic it started.
> 
> And the content of /proc/acpi/processor/C000/power shows only one
> c-state; shouldn't it show more C-states? (please correct me if I'm
> wrong)
> 
>  # cat /proc/acpi/processor/C000/power
> active state:            C1
> max_cstate:              C8
> bus master activity:     00000000
> maximum allowed latency: 2000 usec
> states:
>    *C1:                  type[C1] promotion[--] demotion[--]
> latency[000] usage[00000000] duration[00000000000000000000]

Yup. It should.

Thanks,

	tglx


