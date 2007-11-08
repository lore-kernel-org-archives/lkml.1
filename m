Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXKHPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXKHPGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759031AbXKHPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:06:09 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:40399 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbXKHPGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:06:07 -0500
Message-ID: <473325EB.5090907@us.ibm.com>
Date: Thu, 08 Nov 2007 09:06:19 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <4732A8E5.6090307@qumranet.com> <47331531.8070709@us.ibm.com> <47331F47.70304@qumranet.com>
In-Reply-To: <47331F47.70304@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> If a pci device is capable of dma (or issuing interrupts), it will be 
> useless with pv pci.

Hrm, I think we may be talking about different things.  Are you thinking 
that the driver I posted allows you to do PCI pass-through over virtio?  
That's not what it is.

The driver I posted is a virtio implementation that uses a PCI device.  
This lets you use virtio-blk and virtio-net under KVM.  The alternative 
to this virtio PCI device would be a virtio transport built with 
hypercalls like lguest has.  I choose a PCI device because it ensured 
that each virtio device showed up like a normal PCI device.

Am I misunderstanding what you're asking about?

Regards,

Anthony Liguori

>
>>>  I think that with Amit's pvdma patches you
>>> can support dma-capable devices as well without too much fuss.
>>>   
>>
>> What is the use case you're thinking of?  A semi-paravirt driver that 
>> does dma directly to a device?
>
> No, an unmodified driver that, by using clever tricks with dma_ops, 
> can do dma directly to guest memory.  See Amit's patches.
>
> In fact, why do a virtio transport at all?  It can be done either with 
> trap'n'emulate, or by directly mapping the device mmio space into the 
> guest.
>
>
> (what use case are you considering? devices without interrupts and 
> dma? pci door stoppers?)
>

