Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbYKEHtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbYKEHtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYKEHtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:49:32 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:1319 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbYKEHtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:49:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Rj2fhzD/oaVc3a/mlAruXbtJ3GhDNVpna6pa91aa7bVC6/tw5FwUo/13nD3lEWdlN1
         5sOsZk9qdslTN3Ps7S24TFPGEDbFb4nLa0aAPaKbJp6xh7Iij6nV5s08Fv/nVUe8Oi4B
         ewVGsYPlNq57Is+GW50FKsZGeeL6fF4YLbXps=
Message-ID: <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
Date: Wed, 5 Nov 2008 13:19:29 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: sharing interrupt between PCI device
Cc: linux-pci@vger.kernel.org, "Robert Hancock" <hancockr@shaw.ca>,
       jirislaby@gmail.com
In-Reply-To: <4910E8AC.7050407@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
	 <4910E8AC.7050407@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is the system information X86_64 platform Xeon dual core processor.

I saw the pci_disable_device () it is calling pcibios_disable_device
() and this is is defined as

void pcibios_disable_device (struct pci_dev *dev)
{
        pcibios_disable_resources(dev);
        if (pcibios_disable_irq)
                pcibios_disable_irq(dev);
}

In i386 platform, I could not find a definition for these calls in
x86_64 platform, i think it is using i386 platform code.

Thanks
Nobin Mathew





On Wed, Nov 5, 2008 at 5:58 AM, Robert Hancock <hancockr@shaw.ca> wrote:
> Nobin Mathew wrote:
>>
>> Hi,
>>
>> I think this question is already asked in this mailing list and Sorry
>> for asking this again.
>>
>> My problem is this:
>>
>> I have two PCI devices ( also two kernel drivers for those) which
>> shares the interupt. When I remove one driver other device stops
>> working, which is happening due to pci_disable_device () in removed
>> driver. This call is disabling the shared interrupt.
>
> pci_disable_device shouldn't be disabling the interrupt line, at least not
> in this case. Without more details on the platform or drivers, it's
> difficult to say why this would happen.
>
>>
>> We can avoid this by just removing the pci_disable_device () in the
>> driver, but i dont think this is a good way (correct me if I am
>> wrong).
>>
>> Can you suggest some ways to overcome this issue.
>
>
