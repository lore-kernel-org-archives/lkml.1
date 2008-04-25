Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbYDYJWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbYDYJWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbYDYJW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:22:28 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:7918 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbYDYJW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:22:27 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67113015"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA
Date: Fri, 25 Apr 2008 17:22:20 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA0164BC7A@chinexm1.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA
Thread-Index: AcimULgvgHhCDp5MRkO47mz+sp+IfAAMiRku
References: <200804241929.m3OJToSE021045@hera.kernel.org> <20080424215004.34517136@the-village.bc.nu>
From: "Yang, Graf" <Graf.Yang@analog.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: <graf.yang@analog.com>
X-OriginalArrivalTime: 25 Apr 2008 09:22:25.0878 (UTC) FILETIME=[E0145760:01C8A6B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan,

Thanks for your suggestions!


Have the tty patches that you mentioned been checked in? Would you please give a link about "the tty patches as they move the tty driver operations out of the tty driver ..."?

I made and tested this patch on 2.6.24.4 kernel, it works, although is ugly.
Blackfin serial driver register as a UART driver, which will call tty_set_operations(...,&uart_ops), while uart_ops hasn't set_ldisc function.
Do you mean I should declare a tty_ops and call tty_set_operations(..., &tty_ops) in bfin_5xx.c to register my set_ldisc?


BRs,
Graf
-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
Sent: Fri 4/25/2008 4:50 AM
To: Linux Kernel Mailing List
Cc: graf.yang@analog.com
Subject: Re: Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA
 
O>     Blackfin Serial Driver: Enable IR function when user application (irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline N_IRDA

>  	if (ret == 0) {
> +		bfin_serial_reg.tty_driver->set_ldisc = bfin_set_ldisc;
>  		ret = platform_driver_register(&bfin_serial_driver);

This will not work when combined with the tty patches as they move the
tty driver operations out of the tty driver and also make them shared and
const. You need to declare two sets of tty_ops and register the correct
one for your device.

Alan
