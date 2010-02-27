Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832Ab0B0VbO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:31:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48023 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934887Ab0B0VbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:31:07 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
References: <4B882182.4030205@kernel.org>
	<tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org>
	<20100227130113.GA18661@elte.hu> <m1y6ieo5zw.fsf@fess.ebiederm.org>
	<4B897537.5050406@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 27 Feb 2010 13:30:50 -0800
In-Reply-To: <4B897537.5050406@kernel.org> (Yinghai Lu's message of "Sat\, 27 Feb 2010 11\:40\:39 -0800")
Message-ID: <m1zl2ue585.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> the x3950 has strange gsi base 
>
> ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
> IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
> ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
> IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
> ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
> IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
>
> and BIOS using INT_SRC_OVR to map back gsi  3 - 18 to irq 0 - 15
>
> ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
> if we dont have this patch to do the remap (swap some mapping between ioapic), and only assume irq = gsi,
> the irq from first ioapic controller will be blocked.

Bah.  I was hoping Len Brown would have looked at this earlier.
I just read through the relevant sections of the ACPI spec
1.0, 2.0 and 3.0 so I can understand what is really going on.

What the x3950 firmware does is stupid, and probably needs to be
changed but it is in spec.

I see two issues here.
- You broke x3950 by only initializing the first ioapic.
  We should be able to fix that by having setup_IO_APIC_irqs
  loop through all of the irqs and setup setup any irq with
  pin_2_irq < 16.  It is fragile and out of spec to assume only
  one ioapic will have all of the isa irqs connected to it.
  Plus extending your loop should be simpler and less intrusive
  patch than what you have posted.

  Although I suspect your patch to find the boot_ioapic_idx is
  good enough for now.

- The fact that our current code makes 3 gsis/irqs on the x3950 unusable.
  This is the justification for the remapping and unless this is
  also a regression I don't think we should fix this in the
  current merge window.

acpi guarantees there will be a 1 to 1 mapping between gsi's and
isa interrupts but it does not guarantee what that mapping will be.
acpi also specified that interrupt source overrides will only be
provided for the isa irqs.

linux irqs 0-15 must be the ISA irqs.

So to handle anything that is legitimate according to the acpi spec we
do need a mapping between gsi and irqs. Grrrr.

Something like:

/* By default isa irqs are identity mapped to gsis */
unsigned int isa_irq_to_gsi[16] = {
	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
};

unsigned int gsi_to_irq(unsigned int gsi)
{
	unsigned int irq = gsi + 16;
	unsigned int i;
	for (i = 0; i < 16; i++) {
		if (isa_irq_to_gsi[i] == gsi)
			irq = i;
	}
	return irq;
}

unsigned int irq_to_gsi(unsigned int irq)
{
	unsigned int gsi;
	if (irq < 16) {
		gsi = isa_irq_to_gsi[irq];
	} else {
        	gsi = irq - 16;
        }
        return gsi;
}

When we process the interrupt source overrides we just need to
update the little isa_irq_to_gsi table.

I expect finding all of the places where we need to do a mapping
for gsi number to irq numbers is going to take some time to do
cleanly which suggests it is not a good idea for this merge window.

YH your current remapping patch looks like a pretty horrible hack
instead of real solution to the problem.  I honestly think starting
with it will just obscure what is going and make it harder to
introduce a clean gsi_to_irq/irq_to_gsi.

> so far this patch only affect (fix ) x3950.
>
> all other platform will all have boot_ioapic_idx's gsi_base == 0, 
> the function will just still return gsi.
>
> other solution will ask IBM to fix their bios, so we can get

The IBM x3950 clearly fails to be conservative in the tables it
generates which is a justification for fixing it if IBM is
so inclined.  I don't see how they will ever get the first
3 irqs to be used in older linux releases (aka Enterprise kernels)
if IBM doesn't update the firmware.

I wonder if we can get qemu to emulate a system with a twisted acpi
setup like this to give us an easier platform to test this kind of
code.

> ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[36])
> IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 36-38
> ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
> IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 0-35
> ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
> IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
> then they don't need append that bunch of OVR.

Eric
