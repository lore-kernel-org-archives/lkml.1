Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZKCMEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZKCMEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZKCMEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:04:39 -0500
Received: from mail.atmel.fr ([81.80.104.162]:43511 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752196AbZKCMEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:04:39 -0500
Message-ID: <4AF01C53.3070301@atmel.com>
Date: Tue, 03 Nov 2009 13:04:35 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
       akpm@linux-foundation.org, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91: at91sam9g20ek modify dual slot evaluation kit
References: <1256049173-17373-1-git-send-email-nicolas.ferre@atmel.com> <20091021152653.GF19714@game.jcrosoft.org>
In-Reply-To: <20091021152653.GF19714@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Christophe PLAGNIOL-VILLARD :
>> +	  that embeds only one SD/MMC slot.
>> +
>> +config MACH_AT91SAM9G20EK_2MMC
>> +	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
>> +	depends on ARCH_AT91SAM9G20
>> +	help
>> +	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
>> +	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
>> +	  onwards.
>>  
>>  config MACH_CPU9G20
>>  	bool "Eukrea CPU9G20 board"
>> @@ -392,7 +394,7 @@ config MTD_AT91_DATAFLASH_CARD
>>  
>>  config MTD_NAND_ATMEL_BUSWIDTH_16
>>  	bool "Enable 16-bit data bus interface to NAND flash"
>> -	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
>> +	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
> it's time to replace this by select it at machine config state

Ok patches are comming now on top of this one.

>> @@ -254,7 +257,11 @@ static void __init ek_board_init(void)
>>  	/* Ethernet */
>>  	at91_add_device_eth(&ek_macb_data);
>>  	/* MMC */
>> +#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
>>  	at91_add_device_mci(0, &ek_mmc_data);
>> +#else
>> +	at91_add_device_mmc(0, &ek_mmc_data);
>> +#endif
> do we really need to do this choice at board level?

Yes, you will choose on your board which driver will drive your sd/mmc
interface. The device file will give access to both of them.

Best regards,
-- 
Nicolas Ferre

