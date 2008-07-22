Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYGVQb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYGVQb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbYGVQbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:31:49 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53403 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750794AbYGVQbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:31:48 -0400
Message-ID: <48860B72.10402@sgi.com>
Date: Tue, 22 Jul 2008 09:31:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
References: <200807211836.27282.yhlu.kernel@gmail.com>	 <200807212208.22116.yhlu.kernel@gmail.com>	 <20080722070734.GA16085@elte.hu> <20080722071324.GA2664@elte.hu> <86802c440807220109s63307f28uc0658402cb26cfea@mail.gmail.com>
In-Reply-To: <86802c440807220109s63307f28uc0658402cb26cfea@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Tue, Jul 22, 2008 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>>> v2: fix compiling when CONFIG_ACPI is not set
>>> applied to tip/x86/x2apic - thanks Yinghai.
>>>
>>>> +static struct genapic *apic_probe[] __initdata = {
>>>> +   &apic_x2apic_uv_x,
>>>> +   &apic_x2apic_phys,
>>>> +   &apic_x2apic_cluster,
>>>> +   &apic_physflat,
>>>> +   NULL,
>>>> +};
>>> very nice generalization!
>> btw.:
>>
>>   apic_probe[i]->acpi_madt_oem_check
>>
>> should probably be renamed to something more neutral like "->probe" -
>> there's nothing ACPI about it and some weird boxes could use PCI or
>> other probing mechanisms to discover the type of APIC they want to use.
> 
> 32bit has acpi_madt_oem_check and mps_oem_check
> 64bit should only have acpi_madt_oem_check
> 
>> plus i guess genapic_32.h and genapic_64.h should be unified and struct
>> apic_ops should be put into struct genapic?
> 
> yes.
> 
> hope to call acpi_madt_oem_check and mps_oem_check right after
> acpi_boot_table_init
> to decide apic_ops and genapic as early as possible.
> 
> 
> Jack/Mike,
> does your big box support SRAT? it seems it calling is_uv_system
> before acpi_madt_oem_check is called.
> I like to call early_acpi_boot_init, before acpi_numa_init so
> acpi_madt_oem_check is called before srat is used. can you check
> attached patch on your system?
> 
> YH
> 

Hi,

Yes, I believe so though the final BIOS is not yet complete.

Next chance I get, I'll try out your patch.

Thanks,
Mike
