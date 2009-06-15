Return-Path: <linux-kernel-owner+w=401wt.eu-S1764903AbZFORqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764903AbZFORqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZFORq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:46:29 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:46678 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbZFORq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:46:28 -0400
MIME-Version: 1.0
In-Reply-To: <4A366631.6090904@atmel.com>
References: <c8284b5b0906121802l4c944581r83e55d199f9a5b05@mail.gmail.com>
	 <4A366631.6090904@atmel.com>
Date: Mon, 15 Jun 2009 10:46:30 -0700
X-Google-Sender-Auth: 82c1a15feb8979c3
Message-ID: <c8284b5b0906151046g1e2787f3w76510bc22660219f@mail.gmail.com>
Subject: Re: [PATCH 1/6] Unified AVR32/AT91 MCI Driver
From: Rob Emanuele <poorarm@shoreis.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

> First of all thank you for this splitting effort. It is definitively the
> good way of presenting things and ease reading a lot.

My pleasure.

>> ---
>>  drivers/mmc/host/Kconfig     |   16 ++++++++++++----
>>  drivers/mmc/host/atmel-mci.c |   33 +++++++++++++++++++++++++++++----
>>  2 files changed, 41 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
>> index b4cf691..6e2f52b 100644
>> --- a/drivers/mmc/host/Kconfig
>> +++ b/drivers/mmc/host/Kconfig
>> @@ -124,6 +124,12 @@ config MMC_AU1X
>>
>>         If unsure, say N.
>>
>> +choice
>> +     prompt "Atmel MMC Driver"
>> +     default MMC_ATMELMCI
>> +     help
>> +       Choose which driver to use for the Atmel MCI Silicon
>
> I suggest :
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index b4cf691..e779049 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -124,6 +124,12 @@ config MMC_AU1X
>
>          If unsure, say N.
>
> +choice
> +       prompt "Atmel SD/MMC Driver"
> +       default MMC_ATMELMCI if AVR32
> +       help
> +         Choose which driver to use for the Atmel MCI Silicon
> +
>  config MMC_AT91
>        tristate "AT91 SD/MMC Card Interface support"
>        depends on ARCH_AT91
>
> It will keep present default configuration for both AVR32 and AT91.
>

Fine with me.

>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index cf6a100..497dd51 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -2,11 +2,13 @@
>>   * Atmel MultiMedia Card Interface driver
>>   *
>>   * Copyright (C) 2004-2008 Atmel Corporation
>> + * Copyright (C) 2009 Rob Emanuele
>
> I think you can add your copyright on a file that you create or copy and
> modify from another file.

Noted for future reference.  I wasn't sure what the ettiquete was.
Just wanted to make sure that if there were questions about the
changes I introduced people could find me.  Now that I know more about
the maintaining process I see that is unnecessary.

>>
>> -#define ATMCI_DATA_ERROR_FLAGS       (MCI_DCRCE | MCI_DTOE | MCI_OVRE | MCI_UNRE)
>> +#define ATMCI_DATA_ERROR_FLAGS       (MCI_RINDE | MCI_RDIRE | MCI_RCRCE  \
>> +                              | MCI_RENDE | MCI_RTOE | MCI_DCRCE \
>> +                              | MCI_DTOE | MCI_OVRE | MCI_UNRE)
>
> We will have to consider what Haavard said: some are not data errors.
> But indeed, if you experienced errors not beeing addressed, we have to
> deal with them.
>

We'll have to keep looking into this.  Would someone on the AVR side
be able to evaluate the effects of this on their platform?

I appreciate your time looking this over.  Will you need me to further
revise this patch or will you incorporate the parts that your
comfortable with?

Thank you,

Rob Emanuele
