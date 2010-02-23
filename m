Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0BWURa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:17:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51551 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0BWUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:17:28 -0500
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Gary Hade <garyhade@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Iranna D Ankad <iranna.ankad@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201002221108.42847.trenn@suse.de> <4B826CA6.7060007@kernel.org>
	<201002221258.38506.trenn@suse.de> <4B839ACB.3000804@kernel.org>
	<4B842129.8020906@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 23 Feb 2010 12:17:11 -0800
In-Reply-To: <4B842129.8020906@kernel.org> (Yinghai Lu's message of "Tue\, 23 Feb 2010 10\:40\:41 -0800")
Message-ID: <m1eikbbtbs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Yinghai Lu <yinghai@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Other problem/regression with b9c61b70075c87a8612624736faf4a2de5b1ed30
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 02/23/2010 01:07 AM, Yinghai Lu wrote:
>> Gary,
>> 
>> can you check this patch on your x3950?
>
> Subject: [PATCH -v2] x86: fix out of order of gsi
>
> found IBM x3950 will have problem after
>
> |commit b9c61b70075c87a8612624736faf4a2de5b1ed30
> |
> |    x86/pci: update pirq_enable_irq() to setup io apic routing
>
> The problem is that with the patch, the machine freezes when
> console=ttyS0,... kernel serial parameter is passed.
> It seem to freeze at DVD initialization and the whole problem seem
> to be DVD/pata related, but somehow exposed through the serial
> parameter.
> Such apic problems can expose really weird behavior..
>
> <6>ACPI: IOAPIC (id[0x10] address[0xfecff000] gsi_base[0])
> <6>IOAPIC[0]: apic_id 16, version 0, address 0xfecff000, GSI 0-2
> <6>ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[3])
> <6>IOAPIC[1]: apic_id 15, version 0, address 0xfec00000, GSI 3-38
> <6>ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[39])
> <6>IOAPIC[2]: apic_id 14, version 0, address 0xfec01000, GSI 39-74
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 1 global_irq 4 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 5 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 3 global_irq 6 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 4 global_irq 7 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 6 global_irq 9 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 7 global_irq 10 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 8 global_irq 11 low edge)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 12 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 12 global_irq 15 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 13 global_irq 16 dfl dfl)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 17 low edge)
> <6>ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 18 dfl dfl)
>
> it turns out that system have three io apic controller. but put boot ioapic
> routing in second one. and that gsi_base is not 0. it is using bunch of INT_SRC_OVR...
>
> recent changes
> 1. one set routing for first io apic controller
> 2. assume irq = gsi
> will break theat system.
>
> so try to remap those gsi, need to seperate boot_ioapic_id detection out of enable_IO_APIC
> and call them early.
> introduce boot_ioapic_id, and remap_ioapic_gsi...
>
> -v2: shift gsi with delta instead of gsi_base of boot_ioapic_idx
>
> Reported-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
> Bisected-by: Iranna D Ankad <iranna.ankad@in.ibm.com>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: stable@kernel.org
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

> +int remap_ioapic_gsi(int ioapic, u32 gsi)
> +{
> +	int base_boot = mp_gsi_routing[boot_ioapic_idx].gsi_base;
> +	int base_x;
> +
> +	if (!base_boot)
> +		return gsi;
> +
> +	base_x = mp_gsi_routing[ioapic].gsi_base;
> +	if (base_x < base_boot) {
> +		int delta;
> +		delta = mp_gsi_routing[boot_ioapic_idx].gsi_end + 1;
> +		delta -= base_boot;
> +		gsi += delta;
> +	} else if (base_x == base_boot)
> +		gsi -= base_boot;
> +
> +	return gsi;
> +}

This looks like it is doing something very different from implementing a
one irq at a time override, and after the nasties remapping gsi have
caused in the past I find this function very scary.

Eric


