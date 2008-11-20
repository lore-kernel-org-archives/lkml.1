Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYKTRGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYKTRGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756695AbYKTRGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:06:04 -0500
Received: from gw.goop.org ([64.81.55.164]:44590 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbYKTRGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:06:03 -0500
Message-ID: <492598F9.8040103@goop.org>
Date: Thu, 20 Nov 2008 09:06:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 36 of 38] xen: route hardware irqs via Xen
References: <patchbomb.1226603398@abulafia.goop.org> <00079eee3818aa0205e2.1226603434@abulafia.goop.org> <20081120093159.GA6885@elte.hu>
In-Reply-To: <20081120093159.GA6885@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +#ifdef CONFIG_XEN_PCI
>> +	irq = xen_register_gsi(gsi, triggering, polarity);
>> +	if ((int)irq >= 0)
>> +		return irq;
>> +#endif
>>     
>
> why not change irq to 'int' and avoid the cast?
>   

Yeah, OK.

> also, please eliminate the #ifdef by turning xen_register_gsi() into a 
> 'return -1' inline on !CONFIG_XEN_PCI.
>   

OK.

>> +#ifdef CONFIG_XEN_PCI
>> +	xen_pci_init();
>> +#endif
>>     
>
> hide the #ifdef in a header please. (like you already properly do for
> xen_setup_pirqs())
>   

OK.

>> +	if (rc != 0) {
>>  		if (!probing_irq(irq))
>>  			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
>>  			       irq);
>> +		dump_stack();
>>     
>
> generally it's better to use WARN() or WARN_ONCE() to get good debug 
> feedback and stackdumps. (they also document the reason for the dump)
>   

That was really just a temp debug hack; it shouldn't be dumping stack 
for probes anyway.

>> @@ -523,8 +526,6 @@
>>  	} else
>>  		irq = find_unbound_irq();
>>  
>> -	spin_unlock(&irq_mapping_update_lock);
>> -
>>  	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
>>  				      handle_level_irq, "pirq");
>>     
>
> hm, looks like a stray bugfix?
>   

Erm, yep.

    J
