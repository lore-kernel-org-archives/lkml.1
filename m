Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZGIXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZGIXlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZGIXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:41:08 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:54581 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGIXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fR8FzjbZjeFfNPX+VQD5EBClKs8jNdAyvVo7DbhmmfeKcKUbGbHj7BjvVy6w1+Xxhe
         zXxvnsDhHk7U9pB1I2/sjXAbOudleeYS6FVsfXmvwTkAkpSFMjPL4lN9sk+u66LkZ0tB
         FHv8PO4BPlZoCDHd8PWIJa4DhDTbhrLGr8uFE=
Message-ID: <4A56801B.7070504@gmail.com>
Date: Thu, 09 Jul 2009 17:41:15 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Rob van de Voort <rob.van.der.voort@Prodrive.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCIe dma-able memory location in physical memory for Intel Nehalem
 + Tylersburg architecture
References: <4CD35CD1F8085945B597F80EEC894213030C20F6@exc01.bk.prodrive.nl>
In-Reply-To: <4CD35CD1F8085945B597F80EEC894213030C20F6@exc01.bk.prodrive.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2009 03:04 AM, Rob van de Voort wrote:
> Hello,
>
> I have the following question regarding the (re-)allocation of dma-able
> memory for a PCIe device. I wish to know on which CPU / Memory
> controller the dma-able memory will be allocated. In addition i would
> like to know how i can control this allocation process, or how to
> reroute it to another CPU / Memory controller.
>
> The system i use contains two Nehalem processors connected via intel QPI
> bus. Both processors have 3GB of DDR3 RAM in their memory banks. The
> PCIe bus is controlled by a tylersburg io hub which is also connected to
> the intel QPI bus
>
> The system runs a 64bit linux kernel. Furthermore a PCIe device which
> can only use 32 bit addressing is connected to the PCIe bus. I want to
> allocate dma-able memory for this device using a driver, i know how to
> do this. For maximal performance i would like to control the allocation
> of dma-able memory, in particular the allocation to a certain CPU /
> memory controller. The tylersburg IO hub has an influence on this
> allocation but can i influence this.
>
> So my questions are:
> -1- How can i know were our dma-able memory is allocated in physical
> memory?
> -2- How can i control / redirect this allocation to a certain memory
> controller / CPU?
>
> Thanks for any reply,
>
> Rob van de Voort
>
> P.S  I'd be grateful if people could point me in the direction of
> resources I could read. Thus far I have gone over the PCI / DMA
> documentation in
> the kernel, and a couple of articles on lwn.
> If this is the wrong mailing list for this type of question i hope you
> can redirect me to the correct one.

I believe that dma_alloc_coherent, etc. normally try to allocate DMA 
memory on the same node as the device is connected to. For that to 
actually happen, the motherboard's ACPI tables have to be set up to 
indicate the proper node to memory allocations. As well, since your 
device can only address 32-bit memory (below 4GB) this may prevent 
memory that gets allocated from being on the optimal CPU.
