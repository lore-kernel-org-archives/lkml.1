Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZI3Xgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZI3Xgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZI3Xgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:36:38 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54590 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZI3Xgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Okp61FRX+8dRU8nikmvzeqTRcv200zG0CD7xaplIZJc8cDMNdaWaW3ISQ9JYfR/I2Q
         J0XlYvHa1O7gOTvRYYbYGO0Pu/7gT3n3lD3dhQhs3xtRG31SkKwL2b0w6Fit0suulLDX
         jhB7F+p9NmuhrexoEY4TPhNv/TwR/AbLioFe8=
MIME-Version: 1.0
In-Reply-To: <0b59b7dd4a320d3be58bc74455932cc0.squirrel@www.hardc0re.org.uk>
References: <4AC2604C.2060803@hardc0re.org.uk> <4AC2A300.1040001@gmail.com>
	 <0b59b7dd4a320d3be58bc74455932cc0.squirrel@www.hardc0re.org.uk>
Date: Wed, 30 Sep 2009 17:36:40 -0600
Message-ID: <51f3faa70909301636k6496e5eav1ae65f68038c1ceb@mail.gmail.com>
Subject: Re: VIA VT6330 PCI-E Combo Controller not fully supported
From: Robert Hancock <hancockrwd@gmail.com>
To: chrisfu@mastodon.hardc0re.org.uk
Cc: linux-kernel@vger.kernel.org, Chris M <chrisfu@hardc0re.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 6:23 AM,  <chrisfu@mastodon.hardc0re.org.uk> wrote:
>>>  From the info on the URL above, it appears that the PATA functionality
>>> is identical to that of the VT6415 PATA controller, support for which
>>> was added in 2.6.28. The mailing list post made regarding the patch that
>>> was submitted can be found here:
>>> http://lkml.indiana.edu/hypermail/linux/kernel/0902.2/01428.html
>>
>> If it is similar enough to the existing controllers then you may be able
>> to just add the device ID into pata_via in a similar fashion..
>>
>
> Thanks for your feedback Robert.  I went to do exactly that yesterday
> evening,
> and found some interesting stuff.  The PATA functionality of the VT6330
> identifies itself as the VT6415 and uses the exact same pci_id, meaning that
> support was already added in the mailing list post I quoted in my original
> mail.
>
> The perplexing thing is that the device is unclaimed even though that by all
> accounts, it should be picked up.
>
> A snippet from dmesg:
>
> [    4.970261] pata_via 0000:01:00.1: version 0.3.3
> [    4.970637] ACPI: PCI Interrupt Link [LN6A] enabled at IRQ 19
> [    4.970643] pata_via 0000:01:00.1: PCI INT A -> Link[LN6A] -> GSI 19
> (level,
> low) -> IRQ 19
> [    4.970709] pata_via 0000:01:00.1: PCI INT A disabled
> [    4.970774] pata_acpi 0000:01:00.1: PCI INT A -> Link[LN6A] -> GSI 19
> (level,
> low) -> IRQ 19
> [    4.970799] pata_acpi 0000:01:00.1: setting latency timer to 64
> [    4.970809] pata_acpi 0000:01:00.1: PCI INT A disabled
>
> I guess I'll just keep probing and see what I can come up with.  The next
> step
> is trying to find out if the changes to support the VT6415 worked for
> *anyone*. :)

I think the PCI ID portion is OK, you wouldn't even get the lines
about enabling the interrupt if it wasn't detecting a matching device.
I'm suspecting that ata_pci_sff_init_one is failing out for some
reason, you might need to scatter some printks around in that code to
figure out why..
