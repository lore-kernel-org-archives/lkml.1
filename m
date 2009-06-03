Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbZFCPLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbZFCPLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbZFCPKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:10:52 -0400
Received: from mail.atmel.fr ([81.80.104.162]:54692 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759091AbZFCPKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:10:51 -0400
Message-ID: <4A269251.8090706@atmel.com>
Date: Wed, 03 Jun 2009 17:10:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Rob Emanuele <poorarm@shoreis.com>
CC: Joey Oravec <joravec@drewtech.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] New AT91 MCI Driver that supports both MCI slots used
 at 	the same time
References: <c8284b5b0905281440hd2e4993re3d0d8c590713fa0@mail.gmail.com>	 <4A1FFEFB.6050104@drewtech.com> <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
In-Reply-To: <c8284b5b0906020953o7c112b4hc264b5520cc3aed1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Emanuele :
> Greetings Joey,

>>> +       if (host->need_reset) {
>>> +               at91_mci_write(host, AT91_MCI_CR, AT91_MCI_SWRST);
>>> +               at91_mci_write(host, AT91_MCI_CR, AT91_MCI_MCIEN);
>>> +               at91_mci_write(host, AT91_MCI_MR, host->mode_reg);
>>> +               host->need_reset = false;
>>> +       }
>>>
>> In my experience some at91s need a reset after every single command,
>> otherwise bad things happen. I think the need_reset logic is too
>> conservative in this driver.
> 
> I'll try this and probably make it an option to always reset before
> each command.

This systematic reset was remove by Haavard with this comment:
"Also, don't reset the controller between each transfer. That was an
attempt to work around earlier bugs, and it never really worked very
well."

http://lkml.org/lkml/2008/10/5/152

This reset remains in at91_mci and it does improve things on this driver
but I do not know it a better written driver can prevent from doing this...

>>> +               /*
>>> +                * WRPROOF and RDPROOF prevent overruns/underruns by
>>> +                * stopping the clock when the FIFO is full/empty.
>>> +                * This state is not expected to last for long.
>>> +                */
>>> +               host->mode_reg = (AT91_MCI_CLKDIV & clkdiv) |
>>> AT91_MCI_WRPROOF
>>> +                                       | AT91_MCI_RDPROOF;
>>>
>> These registers are not in all at91 chips especially the at91sam9261.
> 
> I'll look into this but will not be able to test every case.

Only at91rm9200 & at91sam9261/9261s are unable to setup these
functionalities.

Best regards,
-- 
Nicolas Ferre

