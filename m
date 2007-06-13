Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbXFMCt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbXFMCt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 22:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbXFMCts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 22:49:48 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55889 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbXFMCtr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 22:49:47 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH 2/5] Add RapidIO sector to MPC8641HPCN board dts file.
Date: Wed, 13 Jun 2007 10:49:30 +0800
Message-ID: <46B96294322F7D458F9648B60E15112C526D5D@zch01exm26.fsl.freescale.net>
In-Reply-To: <1181689112.9736.29.camel@pterry-fc6.micromemory.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/5] Add RapidIO sector to MPC8641HPCN board dts file.
Thread-Index: AcetRTuqBsC715nRQdObMSUzHNGREgAHpmuA
References: <11816389393593-git-send-email-wei.zhang@freescale.com> <1181638939310-git-send-email-wei.zhang@freescale.com> <11816389401714-git-send-email-wei.zhang@freescale.com> <1181689112.9736.29.camel@pterry-fc6.micromemory.com>
From: "Zhang Wei-r63237" <Wei.Zhang@freescale.com>
To: <pterry@micromemory.com>
Cc: <mporter@kernel.crashing.org>, <linuxppc-dev@ozlabs.org>,
       <paulus@samba.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Phil,

> > +++ b/arch/powerpc/boot/dts/mpc8641_hpcn.dts
> > @@ -329,6 +329,19 @@
> >  				>;
> >  		};
> >  
> > +		srio@c0000 {
> > +			device_type = "rapidio";
> > +			compatible = "fsl,rapidio-v1.0";
> > +			#address-cells = <2>;
> > +			reg = <c0000 20000>;
> > +			ranges = <0 0 c0000000 20000000>;
> 
> Don't understand the range setup... The code uses c0000000 as 
> the start
> and 20000000 as the size for the rapidio law. So whats the 0 0 for? 
> At first I thought address-cells 2 means that the range numbers are
> pairs expressing 64-bit numbers, eg start 0 0, size c0000000 20000000
> but thats not right...
> 

RapidIO address width is 34bits, so we use <2> for #address-cells.
"0 0" is the RapidIO bus address, since the #address-cells is 2, it's
double zero. "c0000000" is the parent bus address, which is memory
address. "20000000" is the size.
So, they means mapping the address of memory 0xc0000000 to RapidIO bus
address 0x0 and the size is 0x20000000.

> Sorry if I'm asking stupid questions....
> 
> And thanks for the patch, just what I need.
> 
> BTW do you have any notes/documentation on the space 
> allocation routines
> intended use. I'm trying to work it out but I don't see any 
> actual users
> of it yet... I need something like it for my distributed DMA driver,
> hence the interest.

Sorry, there is no documentation now. But I'll post an example for using
them.

> 
> Cheers
> Phil
> 
> > +			interrupt-parent = <&mpic>;
> > +			/* err_irq bell_outb_irq bell_inb_irq
> > +						msg1_tx_irq msg1_rx_irq
> > +						msg2_tx_irq 
> msg2_rx_irq */
> > +			interrupts = <30 2 31 2 32 2 35 2 36 2 
> 37 2 38 2>;
> > +		};
> > +
> >  		mpic: pic@40000 {
> >  			clock-frequency = <0>;
> >  			interrupt-controller;
> 
> 
> 
