Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYFLVLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYFLVLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYFLVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:11:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7756 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYFLVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=HAJAPXvroVLHhTfPymiSWm6M225GY4PGDmxprjFocQ6xiz5YyU38pbnIgemZFTmOqC
         Q6n4HPHeOwFHOc86aiQUZMwRkWOwrpGIfocu+/ye8GVHbioBjO+Hj/NLi27O0jikilR0
         5uFi5xzukwA6FcvVVbjmHbDLN/Omy7dtR6B+4=
Message-ID: <485190AC.3060107@gmail.com>
Date: Thu, 12 Jun 2008 23:10:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: pnp changes -> suspend oops [Was: 2.6.26-rc5-mm2]
References: <20080609223145.5c9a2878.akpm@linux-foundation.org> <485014B5.7080305@gmail.com> <200806111303.39267.bjorn.helgaas@hp.com>
In-Reply-To: <200806111303.39267.bjorn.helgaas@hp.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2008 09:03 PM, Bjorn Helgaas wrote:
> On Wednesday 11 June 2008 12:08:53 pm Jiri Slaby wrote:
>> On 06/10/2008 07:31 AM, Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc5/2.6.26-rc5-mm2/
>> I face problems after some of the pnp changes. If this is not known, I may 
>> bisect it, it's 100% reproducible. I have no real logs, It panics prior to 
>> network is woken up to see something on netconsole, I just captured a function 
>> name and an offset of place where it oopses.
>>
>> pnpacpi_encode_resources, ACPI_RESOURCE_TYPE_DMA case, pnp_get_resource(dev, 
>> IORESOURCE_DMA, dma) returns NULL, which is dereferenced at pnpacpi_encode_dma 
>> at p->flags.
>>
>> It happens on resume after mem > /sys/power/state.
> 
> Thanks for the report, I hadn't heard about this.
> 
> We used to always have a resource from the static table to encode
> (assuming the table was big enough), even if that resource was
> disabled or unassigned.  But now we don't keep those around, so
> we can end up with null pointers like you're seeing.
> 
> Before you go to all the trouble of bisecting it, can you turn on
> CONFIG_PNP_DEBUG and try the following debug patch?  I think this
> will prevent the oops, but it's just papering over the real problem,
> so please capture the complete dmesg log.

ACPI: PCI interrupt for device 0000:00:02.0 disabled
serial 00:07: disabled
serial 00:06: disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
...
serial 00:06:   no dma resource to encode!
serial 00:06: activated
serial 00:07:   no dma resource to encode!
serial 00:07: activated
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16

