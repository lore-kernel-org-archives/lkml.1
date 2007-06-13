Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXFMJtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXFMJtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 05:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXFMJtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 05:49:08 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:38286 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753167AbXFMJtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 05:49:07 -0400
In-Reply-To: <46B96294322F7D458F9648B60E15112C526DF5@zch01exm26.fsl.freescale.net>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net> <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DF5@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <9f8ab14c257b414bba3fb47671f398d1@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>,
       <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Wed, 13 Jun 2007 11:48:53 +0200
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> +    - device_type : Should be "rapidio"
>>>>
>>>> There is no OF binding, so no.
>>>
>>> So, we need to define it.
>>
>> If you want to.  Until that has been done, don't use
>> a "device_type".  Linux won't use it, anyway.
>
> Do you have another ideas about that? Only remove it?

Yeah, remove it.

>>> Using IP Block Revision is a
>>> clear choice.
>>
>> I don't think so.  For one thing, it describes a version of
>> a cell design, not a version of an actual device.  For another
>> thing, if I hear "8641" I know what you're talking about (sort
>> of, anyway), but I draw a blank stare if you say "v1.0".  I'm
>> sure I'm not the only one.  Concrete names are good.
>>
>
>> From the different view ways, there are different results. Getting the
> version from RapidIO IP revision register is clear to me. :)

It's not in line with how all other "compatible" properties
are done though.

>> But the rapidio node doesn't know or care what the interrupts
>> are connected to, and neither should it.  That's what the
>> interrupt mapping recommended practice is for.
>
> There are no rapidio device in it. Doorbell, msg are all parts of
> rapidio controller.
> For example, 8641 rapidio controller have 2 msg unit: msg0 and msg1.
> They are not rapidio devices. Each msg unit has the tx_irq and rx_irq.

Ah, I think I understand what you mean now.  Yes, the binding
for this specific rapidio controller should define the _order_
of the interrupts in the "interrupts" property; but it cannot
define the format of the single entries, that is defined by
the interrupt controller node it is connected to already.

>>>> You want a #size-cells as well.
>>>
>>> The size is not used in this sector, so no defined.
>>
>> The size _is_ used; in the "ranges" property in this node,
>> for example.  It is also needed to describe the "reg" for
>> any child node of this node.
>>
>> A non-existant "#size-cells" means 1, and "#address-cells"
>> means 2, so in principle you could do without these
>> properties; but Linux doesn't parse the tree correctly in
>> that case (which reminds me, I have some more patches to
>> send).
>
> Ok, I'll add it in the next version for more religious.

It's not religious; true OF believers say leave the node
out if its value would be 1.  It's just that Linux doesn't
handle that properly yet, so you want to protect yourself :-)


Segher

