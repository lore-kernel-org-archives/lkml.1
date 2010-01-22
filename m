Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824Ab0AVAxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0AVAxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667Ab0AVAxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:53:15 -0500
Received: from mail-iw0-f196.google.com ([209.85.223.196]:38353 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab0AVAxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PjPoXxtrmM6uo7hxY+tp9EUN7AD75g+5gxTWQV7Zm725a29AEFwEP3BL0eTPbzHkRh
         L5oN5+iiQX0aF8iKO20+d6okUoFskWXle/+yodW2uI/7Uqy0BbUzk4u/9w0cdQGJ1fsF
         WOksr8X8YTXl5bKwEK1aMXMSBOzaa5VOFH4PI=
MIME-Version: 1.0
In-Reply-To: <64bb37e1001192248nbcb2b55pf9bab5f3fb909354@mail.gmail.com>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B4A815A.60503@gmail.com>
	 <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
	 <4B536383.7090609@gmail.com>
	 <64bb37e1001171311u21c58fbj9a13b6aaeb7b2c3f@mail.gmail.com>
	 <64bb37e1001181251y733513cdm1be9850af880ee73@mail.gmail.com>
	 <4B55130D.8070503@gmail.com>
	 <64bb37e1001191220u72f7af29xdc1c39f1d114bc21@mail.gmail.com>
	 <51f3faa71001191900y521f2be3u3a5e341f3113559@mail.gmail.com>
	 <64bb37e1001192248nbcb2b55pf9bab5f3fb909354@mail.gmail.com>
Date: Thu, 21 Jan 2010 18:53:11 -0600
Message-ID: <51f3faa71001211653s6ec4b2eep9f63a44a4f1fe674@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Robert Hancock <hancockrwd@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:48 AM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
>>> Output of the __assign_irq:
>>> 4x PCIe bridge:
>>> [    1.759016] __assign_irq_vector:assigning irq 24 to vector 73
>>> [    1.764928] __assign_irq_vector:assigning irq 25 to vector 81
>>> [    1.770827] __assign_irq_vector:assigning irq 26 to vector 89
>>> [    1.776720] __assign_irq_vector:assigning irq 27 to vector 97
>>> sata_sil24 first gets 19:
>>> [    1.856245] __assign_irq_vector:assigning irq 19 to vector 105
>>> then switches to MSI-28:
>>> [    1.870768] __assign_irq_vector:assigning irq 28 to vector 113
>>> 3 normal interrupts for sata_nv:
>>> [    1.908504] __assign_irq_vector:assigning irq 23 to vector 121
>>> [    1.953848] __assign_irq_vector:assigning irq 22 to vector 129
>>> [    1.999155] __assign_irq_vector:assigning irq 21 to vector 137
>>>
>>> Writing failed again without a message, but the read test showed:
>>> [   85.695745] do_IRQ: 0.165 No irq handler for vector (irq -1)
>>> [   85.695763] do_IRQ: 1.165 No irq handler for vector (irq -1)
>>> [   85.695785] do_IRQ: 3.165 No irq handler for vector (irq -1)
>>> [   85.695800] do_IRQ: 2.165 No irq handler for vector (irq -1)
>>> Same vector in this error, but sata_sil24 had MSI irq 28 instead of 29!
>>> And the vector allocations where not even near 165!
>>
>> Hmm.. Can you send the output of lspci -vv with MSI in use?
>
> I had already done so at the start of this thread, both for MSI and
> the normal, working case:
> http://lkml.org/lkml/2009/12/25/12
> ( http://marc.info/?l=linux-kernel&m=126173296807440&w=2 might be
> better, als lkml.org seems to eat the attachment borders)
>
> For the minimal kernel with only the sata_nv and sata_sil24 drivers
> the output looks like this:

Well, that doesn't seem that illuminating. Still mysterious where 165
could be coming from.

Anyone have any ideas how random IRQ vectors could be showing up on
the APIC with MSI?
