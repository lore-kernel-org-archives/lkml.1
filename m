Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbXGTHMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbXGTHMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbXGTHL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:11:59 -0400
Received: from za-gw.sanpeople.com ([196.211.225.226]:2419 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbXGTHL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:11:58 -0400
Subject: Re: [PATCH 1/1][RESEND] Driver for the Atmel on-chip SSC on AT32AP
	and AT91.
From: Andrew Victor <andrew@sanpeople.com>
To: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kernel-avr32 <kernel@avr32linux.org>,
       David Brownell <david-b@pacbell.net>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Hans-Christian Egtvedt <egtvedt@samfundet.no>
In-Reply-To: <1184913868.16760.21.camel@localhost.localdomain>
References: <469E6C00.3060506@atmel.com>
	 <1184833759.15007.33.camel@fuzzie.sanpeople.com>
	 <1184913868.16760.21.camel@localhost.localdomain>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1184914542.15002.113.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 20 Jul 2007 08:55:42 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi Hans-Christian,

> Just an example from sound/soc/at91/at91-ssc.c
> 
> rcmr =	  (( ssc_p->rcmr_period		<< 24) & AT91_SSC_PERIOD)
> 			| (( 1				<< 16) & AT91_SSC_STTDLY)
> 			| (( AT91_SSC_START_FALLING_RF	     ) & AT91_SSC_START)
> 			| (( AT91_SSC_CK_RISING		     ) & AT91_SSC_CKI)
> 			| (( AT91_SSC_CKO_NONE		     ) & AT91_SSC_CKO)
> 			| (( AT91_SSC_CKS_DIV		     ) & AT91_SSC_CKS);

Well, I didn't write the above, so it's more complex than it needs to
be.

For bitfields where the user can input any value we would usually add to
the header:
   #define AT91_SSC_STTDLY_(x)   ((x) << 16)
   #define AT91_SSC_PERIOD_(x)   ((x) << 24)

Then it can simply be re-written as:

rcmr = AT91_SSC_PERIOD(ssc_p->rcmr_period)
	| AT91_SSC_STTDLY(1)
	| AT91_SSC_START_FALLING_RF
	| AT91_SSC_CK_RISING
	| AT91_SSC_CKO_NONE
	| AT91_SSC_CKS_DIV;


> Would with the header style for atmel-ssc be:
> 
> rcmr = SSC_BF(RCMR_PERIOD, ssc_p->rcmr_period)
> 		| SSC_BF(RCMR_STTDLY, 1)
> 		| SSC_BF(RCMR_START, 4)
> 		| SSC_BF(RCMR_CKI, 1)
> 		| SSC_BF(RCMR_CKO, 0)
> 		| SSC_BF(RCMR_CKS, 0);
> 
> I find the latter more readable and compact, the user also does not need
> to know the offset of the different bit-fields.

But the user does then constantly have to refer to the datasheet to
determine what CKI = 1 or CKS = 0 means.


Regards,
  Andrew Victor


