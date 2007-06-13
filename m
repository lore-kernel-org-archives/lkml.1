Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbXFMIPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbXFMIPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 04:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXFMIOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 04:14:55 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:52596 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbXFMIOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 04:14:53 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Date: Wed, 13 Jun 2007 16:14:44 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C526DD9@zch01exm26.fsl.freescale.net>
In-Reply-To: <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
Thread-Index: AceteApfcQ4q8nraSmCLF3FxBS3mbgAGKdNw
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <39c7d60cebf03badd106d7f75a08f449@kernel.crashing.org>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: "Segher Boessenkool" <segher@kernel.crashing.org>
Cc: <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <mporter@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Segher, 

> -----Original Message-----
> Subject: Re: [PATCH 1/5] Add the explanation and sample of 
> RapidIO DTS sector to the document of booting-without-of.txt file.
> 
> > +   k) RapidIO
> > +
> > +   Required properties:
> > +
> > +    - device_type : Should be "rapidio"
> 
> There is no OF binding, so no.

So, we need to define it.

> 
> > +    - compatible : Should be "fsl,rapidio-v0.0" or 
> "fsl,rapidio-v1.0"
> > +      and so on. The version number is got from IP Block Revision
> > +      Register of RapidIO controller.
> 
> It's better to use real device names, just like everyone
> else.

Some silicons of Freescale processor are the same RapidIO controller,
such as mpc8540/mpc8560 are the same (v0.0), mpc8548/mpc8641 are the
same (v1.0). For v1.0 RapidIO controller, should we use mpc8548 or
mpc8641? Those will make people confused. Using IP Block Revision is a
clear choice.

> 
> > +    - #address-cells : Address representation for 
> "rapidio" devices.
> > +      This field represents the number of cells needed to represent
> > +      the RapidIO address of the registers.  For 
> supporting more than
> > +      36-bits RapidIO address, this field should be <2>.
> 
> More than 32 bit?

Yes, RapidIO bus address width is 34 bits.

> 
> > +    - interrupt-parent : the phandle for the interrupt 
> controller that
> > +      services interrupts for this device.
> 
> Not required, depends on the interrupt tree of the system.
> 
> > +    - interrupts : <a b> where a is the interrupt number and b is a
> > +      field that represents an encoding of the sense and level
> > +      information for the interrupt.
> 
> No.  The format of an "interrupts" entry is defined by
> the interrupt domain this device sits in, not by the
> device itself.
> 
Do you misunderstand the meaning of 'interrupts'? These interrupts is
issued from the RapidIO controller to the pic controller for tx, rx,
err, doorbell and message.


> > For this sector, interrupts order should be
> > +      <err_irq bell_outb_irq bell_inb_irq msg1_tx_irq msg1_rx_irq
> > +      msg2_tx_irq msg2_rx_irq ... msgN_tx_irq msgN_rx_irq>.
> 
> That's to be defined in the binding for your specific device,
> not in a more generic rapidio binding.

These description is just for compatible="fsl,rapidio-v*.*" rapidio
controller.

> 
> > +		#address-cells = <2>;
> 
> You want a #size-cells as well.
> 

The size is not used in this sector, so no defined.

Thanks!
Wei.
