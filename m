Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXFEL5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXFEL5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 07:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbXFEL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 07:57:37 -0400
Received: from mailgw3.ericsson.se ([193.180.251.60]:58726 "EHLO
	mailgw3.ericsson.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXFEL5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 07:57:36 -0400
X-AuditID: c1b4fb3c-a94ecbb0000073d5-90-46654faf5646 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Tue, 5 Jun 2007 13:57:30 +0200
Message-ID: <A6D19A13FE030A409EC4362C172E091F016F51B1@eseldmw101.eemea.ericsson.se>
In-Reply-To: <7VXmfiOJ.1181030230.9946640.samuel@sortiz.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Thread-Index: AcenRxsgeDt5HciGTAeDxHuJNI2+cgAIHq8A
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <7VXmfiOJ.1181030230.9946640.samuel@sortiz.org>
From: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
To: "Samuel Ortiz" <samuel@sortiz.org>, <arvidjaar@mail.ru>
Cc: <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       <ambx1@neo.rr.com>, <bjorn.helgaas@hp.com>
X-OriginalArrivalTime: 05 Jun 2007 11:57:30.0734 (UTC) FILETIME=[B1F3F0E0:01C7A768]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam wrote:

> Andrey, in addition to Bjorn's patch, could you also apply 
> this one and try again:
> 
> diff --git a/drivers/net/irda/smsc-ircc2.c 
> b/drivers/net/irda/smsc-ircc2.c index 31c6233..800562a 100644
> --- a/drivers/net/irda/smsc-ircc2.c
> +++ b/drivers/net/irda/smsc-ircc2.c
> @@ -2463,7 +2463,7 @@ static struct 
> smsc_ircc_subsystem_configuration subsystem_
>                 .subvendor = 0x1179,
>                 .subdevice = 0xffff, /* 0xffff is "any" */
>                 .sir_io = 0x02e8,
> -               .fir_io = 0x02f8,
> +               .fir_io = 0x100,

You don't need to alter the defaults for the Toshiba ALi, the 
preconfigure will respect the settings from the commandline,
e.g. modprobe smsc-ircc2 ircc_fir=0x100,ircc_sir=0x02e8.

BUT this value just won't work: we don't know how to tell the ALi 1533
to use any other ports than 0x130,0x178,0x03f8,0x02f8 or 0x02e8.
The code in preconfigure_ali_port() is from the smscinit tool
and I have no idea of how that was initially developed (reverse
engineering likely). Since 0x0130 and 0x170 seem to be the same setting,
0x100 could be equal to one of the others as well so I would
try feeding some different ircc_fir=x settings and see what happens.

The problem is we don't have any documentation for this
bridge and even though I've requested a datasheet from ALi they
refuse to provide one. I even tried buying one in the grey market
and failed, if someone has it, please forward.

Linus Walleij
