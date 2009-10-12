Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZJLH7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZJLH7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZJLH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:59:47 -0400
Received: from aa002msb.fastweb.it ([85.18.95.81]:56344 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZJLH7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:59:47 -0400
Message-ID: <4AD2E1BB.80501@evidence.eu.com>
Date: Mon, 12 Oct 2009 09:58:51 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] atmel_serial: Fix bad BUILD_BUG_ON() usage
References: <1254845207-7608-1-git-send-email-haavard.skinnemoen@atmel.com> <4ACC94B4.1050600@atmel.com>
In-Reply-To: <4ACC94B4.1050600@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre ha scritto:
> Haavard Skinnemoen :
>> is_power_of_2() appears not to be constant enough for BUILD_BUG_ON()
>> after the latest rework, so replace it with an open-coded test.
>>
>> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>  drivers/serial/atmel_serial.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
>> index 3551c5c..9d948bc 100644
>> --- a/drivers/serial/atmel_serial.c
>> +++ b/drivers/serial/atmel_serial.c
>> @@ -1531,7 +1531,7 @@ static int __devinit atmel_serial_probe(struct platform_device *pdev)
>>  	void *data;
>>  	int ret;
>>  
>> -	BUILD_BUG_ON(!is_power_of_2(ATMEL_SERIAL_RINGSIZE));
>> +	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>>  
>>  	port = &atmel_ports[pdev->id];
>>  	port->backup_imr = 0;
> 
> 

Hi all,

    I was expecting this patch to be merged in 2.6.32-rc4...

Consider that without this change, the driver does not _even_ build 
(that's why I think we shouldn't wait the next merge window...).

Regards,

            Claudio

  	
