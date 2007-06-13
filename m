Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbXFMI2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbXFMI2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbXFMI21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:28:27 -0400
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:58253 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756281AbXFMI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:28:26 -0400
In-Reply-To: <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net>
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org> <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <59453d80f2f111b72e8f24e7b489c23e@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>,
       <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Wed, 13 Jun 2007 10:28:12 +0200
To: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +    - device_type : Should be "rapidio"
>>
>> There is no OF binding, so no.
>
> So, we need to define it.

If you want to.  Until that has been done, don't use
a "device_type".  Linux won't use it, anyway.

>>> +    - compatible : Should be "fsl,rapidio-v0.0" or
>> "fsl,rapidio-v1.0"
>>> +      and so on. The version number is got from IP Block Revision
>>> +      Register of RapidIO controller.
>>
>> It's better to use real device names, just like everyone
>> else.
>
> Some silicons of Freescale processor are the same RapidIO controller,
> such as mpc8540/mpc8560 are the same (v0.0), mpc8548/mpc8641 are the
> same (v1.0). For v1.0 RapidIO controller, should we use mpc8548 or
> mpc8641? Those will make people confused.

Not at all.  On an 8641 it could be

	compatible = "fsl,mpc8641-rapidio" "fsl,mpc8548-rapidio";

which states "this is the 8641 thing and it is compatible
to the 8548 thing".  Perfectly clear.

> Using IP Block Revision is a
> clear choice.

I don't think so.  For one thing, it describes a version of
a cell design, not a version of an actual device.  For another
thing, if I hear "8641" I know what you're talking about (sort
of, anyway), but I draw a blank stare if you say "v1.0".  I'm
sure I'm not the only one.  Concrete names are good.

>>> +    - #address-cells : Address representation for
>> "rapidio" devices.
>>> +      This field represents the number of cells needed to represent
>>> +      the RapidIO address of the registers.  For
>> supporting more than
>>> +      36-bits RapidIO address, this field should be <2>.
>>
>> More than 32 bit?
>
> Yes, RapidIO bus address width is 34 bits.

You said "more than 36 bit", I tried to ask if that is a typo
perhaps.

>> No.  The format of an "interrupts" entry is defined by
>> the interrupt domain this device sits in, not by the
>> device itself.
>>
> Do you misunderstand the meaning of 'interrupts'?

Hahaha.  No, I don't misunderstand what the "interrupts" property
means.  Perhaps you do?

> These interrupts is
> issued from the RapidIO controller to the pic controller for tx, rx,
> err, doorbell and message.

But the rapidio node doesn't know or care what the interrupts
are connected to, and neither should it.  That's what the
interrupt mapping recommended practice is for.

>>> For this sector, interrupts order should be
>>> +      <err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
>>> +      msg2_tx_irq msg2_rx_irq ... msgN_tx_irq msgN_rx_irq>.
>>
>> That's to be defined in the binding for your specific device,
>> not in a more generic rapidio binding.
>
> These description is just for compatible="fsl,rapidio-v*.*" rapidio
> controller.

Okay, good.  Please make that way more obvious then :-)

>>> +		#address-cells = <2>;
>>
>> You want a #size-cells as well.
>
> The size is not used in this sector, so no defined.

The size _is_ used; in the "ranges" property in this node,
for example.  It is also needed to describe the "reg" for
any child node of this node.

A non-existant "#size-cells" means 1, and "#address-cells"
means 2, so in principle you could do without these
properties; but Linux doesn't parse the tree correctly in
that case (which reminds me, I have some more patches to
send).

> Thanks!

My pleasure,


Segher

