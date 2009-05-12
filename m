Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZELPGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZELPGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZELPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:05:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbZELPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:05:43 -0400
Message-ID: <4A099013.6040708@kernel.org>
Date: Tue, 12 May 2009 08:04:51 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu>
In-Reply-To: <20090512145808.GA20587@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> [Ingo Molnar - Tue, May 12, 2009 at 01:22:05PM +0200]
>> | 
>> | this build bug is still unfixed:
>> | 
>> | drivers/pci/hotplug/ibmphp_core.c:165: error: expected identifier before ‘&’ token
>> | drivers/pci/hotplug/ibmphp_core.c:166: error: too few arguments to function ‘IO_APIC_get_PCI_irq_vector’
>> | 
>> | 	Ingo
>> | 
>>
>> Grrr... this line looks really suspicious inideed
>>
>> 			for (i = 0; i < 4; i++)
>> 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
>> --->						(int) (*cur_slot)->device, i.
>> 						&ioapic, &ioapic_pin,
>> 						&triggering, &polarity);
>>
>> but it's _not_ 'cause of this commit, since
>> we didn't even touch this file :) The point
>> symbol should be changed to comma. Just a
>> misprint I believe. Appened patch should do
>> the trick.
> 
> Yinghai touched it:
> 
> e20c06f: x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector()
> 
i put the fix in
[PATCH] x86: introduce io_apic_irq_attr -v2
<4A08ACD3.2070401@kernel.org>

YH
