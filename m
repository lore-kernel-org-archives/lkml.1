Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXKHOjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXKHOjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 09:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758609AbXKHOjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 09:39:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:39111 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXKHOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 09:39:00 -0500
Message-ID: <47331F47.70304@qumranet.com>
Date: Thu, 08 Nov 2007 16:37:59 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <4732A8E5.6090307@qumranet.com> <47331531.8070709@us.ibm.com>
In-Reply-To: <47331531.8070709@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>> Anthony Liguori wrote:
>>  
>>> This is a PCI device that implements a transport for virtio.  It 
>>> allows virtio
>>> devices to be used by QEMU based VMMs like KVM or Xen.
>>>
>>>       
>>
>> Didn't see support for dma.
>
> Not sure what you're expecting there.  Using dma_ops in virtio_ring?
>

If a pci device is capable of dma (or issuing interrupts), it will be 
useless with pv pci.


>>  I think that with Amit's pvdma patches you
>> can support dma-capable devices as well without too much fuss.
>>   
>
> What is the use case you're thinking of?  A semi-paravirt driver that 
> does dma directly to a device?

No, an unmodified driver that, by using clever tricks with dma_ops, can 
do dma directly to guest memory.  See Amit's patches.

In fact, why do a virtio transport at all?  It can be done either with 
trap'n'emulate, or by directly mapping the device mmio space into the guest.


(what use case are you considering? devices without interrupts and dma? 
pci door stoppers?)

-- 
error compiling committee.c: too many arguments to function

