Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXGBMqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXGBMqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 08:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbXGBMqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 08:46:14 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:50009 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbXGBMqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 08:46:13 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Subject: Re: [PATCH] mmc: at91_mci: fix hanging and rework to match flowcharts
Date: Mon, 2 Jul 2007 14:45:13 +0200
User-Agent: KMail/1.9.5
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <andrew@sanpeople.com>, Andreas Beier <mughat@gmail.com>,
       Hamish Guthrie <hamish@prodigi.ch>, wux@landicorp.com,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
References: <4688EC94.1090901@rfo.atmel.com>
In-Reply-To: <4688EC94.1090901@rfo.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021445.14316.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 July 2007 14:16, Nicolas Ferre wrote:
> Fixes hanging using multi block operations (seen during CMD25).
> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Verified working on at91rm9200 using 1 wire mode.

A small remark, only for future improvements:
> @@ -817,7 +834,11 @@ static int __init at91_mci_probe(struct 
>  
>  	mmc->ops = &at91_mci_ops;
>  	mmc->f_min = 375000;
> -	mmc->f_max = 25000000;
> +	if (cpu_is_at91sam9263())
> +		mmc->f_max = 50000000;
> +	else
> +		mmc->f_max = 25000000;
for at91rm9200 f_max is MCK/2 why don't use it?

Nice work, thanks

Regards

Marc
