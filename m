Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbXFTOUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbXFTOUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 10:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXFTOTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 10:19:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbXFTOTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 10:19:53 -0400
Message-ID: <467936FE.8050704@redhat.com>
Date: Wed, 20 Jun 2007 10:17:34 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Michal Schmidt <mschmidt@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] irq nobody cared workaround for i386
References: <4676CF81.2000205@redhat.com> <4677D7AF.7040700@redhat.com> <467932B4.6030800@redhat.com>
In-Reply-To: <467932B4.6030800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Schmidt wrote:
> Michal Schmidt wrote:

> I came to the conclusion that the IO-APICs which need the fix for the
> nobody cared bug don't have the issue ack_ioapic_quirk_irq is designed
> to work-around. It should be safe simply to use the normal
> ack_ioapic_irq as the .eoi method in pcix_ioapic_chip.
> So this is the port of Steven's fix for the nobody cared bug to i386. It
> works fine on IBM LS21 I have access to.
> 

Thanks Michal for doing this!

> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>


> @@ -1336,7 +1371,7 @@ static void __init setup_IO_APIC_irqs(vo
>  		if (IO_APIC_IRQ(irq)) {
>  			vector = assign_irq_vector(irq);
>  			entry.vector = vector;
> -			ioapic_register_intr(irq, vector, IOAPIC_AUTO);
> +			ioapic_register_intr(irq, vector, IOAPIC_AUTO, apic>0);

You want to make that "apic > 0".  Note the spacing. If it breaks
80 characters, then simply put it to a new line.

>  		
>  			if (!apic && (irq < 16))
>  				disable_8259A_irq(irq);
> @@ -2058,6 +2093,18 @@ static struct irq_chip ioapic_chip __rea
>  	.retrigger	= ioapic_retrigger_irq,
>  };
>  

[...]

>  static inline void init_IO_APIC_traps(void)
>  {
> @@ -2858,7 +2905,7 @@ int io_apic_set_pci_routing (int ioapic,
>  		mp_ioapics[ioapic].mpc_apicid, pin, entry.vector, irq,
>  		edge_level, active_high_low);
>  
> -	ioapic_register_intr(irq, entry.vector, edge_level);
> +	ioapic_register_intr(irq, entry.vector, edge_level, ioapic>0);

Again, add the spaces.

>  
>  	if (!ioapic && (irq < 16))
>  		disable_8259A_irq(irq);
> 
> 


ACK

-- Steve
