Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211Ab0AJK1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0AJK1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 05:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922Ab0AJK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 05:27:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:32914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0AJK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 05:27:14 -0500
Date: Sun, 10 Jan 2010 11:26:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ananth@in.ibm.com, suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
Message-ID: <20100110102638.GA7838@elte.hu>
References: <20100109101038.GA17555@in.ibm.com>
 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
 <20100110023015.GA2253@in.ibm.com>
 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sat, Jan 9, 2010 at 6:30 PM, Ananth N Mavinakayanahalli
> <ananth@in.ibm.com> wrote:
> > On Sat, Jan 09, 2010 at 01:13:39PM -0800, Yinghai Lu wrote:
> >> On Sat, Jan 9, 2010 at 2:10 AM, Ananth N Mavinakayanahalli
> >> <ananth@in.ibm.com> wrote:
> >> > On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
> >> > kernels fails at:
> >> >
> >> > ...
> >> > CPU0: Intel(R) Xeon(R) CPU ? ? ? ? ? X7350 ?@ 2.93GHz stepping 0b
> >> > Booting Node ? 0, Processors ?#1 #2 #3 #4 #5 #6 #7 Ok.
> >> > Brought up 8 CPUs
> >> > Total of 8 processors activated (46906.05 BogoMIPS).
> >> >
> >> > Git bisect showed 2fbd07a5f as the offending commit.
> >> >
> >> > With the patch below, I am able to boot the latest Linus' git tree on
> >> > the machine. If this patch is correct, it needs to get into the stable
> >> > tree too.
> >> >
> >> > Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> >> > ---
> >> > Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c ? ? ?2010-01-09 14:54:29.000000000 +0530
> >> > +++ linux-2.6/arch/x86/kernel/apic/probe_64.c ? 2010-01-09 14:57:53.000000000 +0530
> >> > @@ -70,7 +70,7 @@
> >> > ? ? ? ?if (apic == &apic_flat) {
> >> > ? ? ? ? ? ? ? ?switch (boot_cpu_data.x86_vendor) {
> >> > ? ? ? ? ? ? ? ?case X86_VENDOR_INTEL:
> >> > - ? ? ? ? ? ? ? ? ? ? ? if (num_processors > 8)
> >> > + ? ? ? ? ? ? ? ? ? ? ? if (num_processors >= 8)
> >> > ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?apic = &apic_physflat;
> >> > ? ? ? ? ? ? ? ? ? ? ? ?break;
> >> > ? ? ? ? ? ? ? ?case X86_VENDOR_AMD:
> >>
> >> can you send out whole bootlog with apic=debug?
> >
> > Here it is:
> > ACPI: LAPIC (acpi_id[0x00] lapic_id[0x0c] enabled)
> > ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] enabled)
> > ACPI: LAPIC (acpi_id[0x02] lapic_id[0x0d] enabled)
> > ACPI: LAPIC (acpi_id[0x03] lapic_id[0x11] enabled)
> > ACPI: LAPIC (acpi_id[0x04] lapic_id[0x0e] enabled)
> > ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
> > ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0f] enabled)
> > ACPI: LAPIC (acpi_id[0x07] lapic_id[0x13] enabled)
> ...
> > Setting APIC routing to flat
> > Getting VERSION: 50014
> > Getting VERSION: 50014
> > Getting ID: c000000
> > Getting ID: f3000000
> > Getting LVT0: 700
> > Getting LVT1: 400
> > enabled ExtINT on CPU#0
> > ESR value before enabling vector: 0x00000040 ?after: 0x00000000
> > ENABLING IO-APIC IRQs
> > ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> > CPU0: Intel(R) Xeon(R) CPU ? ? ? ? ? X7350 ?@ 2.93GHz stepping 0b
> ...
> 
> the BSP's physical apic id is 0x0c instead of 0.
> 
> not sure Suresh test that or not.

In any case this commit needs to be reverted as the assumption that it's safe 
to do this optimization is evidently not true.

	Ingo
