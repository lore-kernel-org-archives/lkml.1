Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYFWOMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYFWOMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYFWOMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:12:15 -0400
Received: from mail.atmel.fr ([81.80.104.162]:36030 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYFWOMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:12:14 -0400
Message-ID: <485FAF34.8000609@atmel.com>
Date: Mon, 23 Jun 2008 16:12:04 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Pierre Ossman <drzeus@drzeus.cx>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: sdio: bad CISTPL_FUNCE error
References: <485BCBB3.20405@atmel.com> <alpine.LFD.1.10.0806211045390.2979@xanadu.home>
In-Reply-To: <alpine.LFD.1.10.0806211045390.2979@xanadu.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre :
> On Fri, 20 Jun 2008, Nicolas Ferre wrote:
> 
>> Hi Pierre,
>>
>> While trying to setup a GPS SDIO card, I experience the following error:
>> "mmc0: bad CISTPL_FUNCE size 28 type 1"
> 
> Could you apply this patch and see what it shows:
> 
> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index d5e51b1..60ec4d3 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -149,8 +149,9 @@ static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
>  		ret = cistpl_funce_common(card, buf, size);
>  
>  	if (ret) {
> -		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
> -		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
> +		printk(KERN_ERR "%s: bad %s CISTPL_FUNCE size %u type %u\n",
> +		       mmc_hostname(card->host), func ? "function" : "common",
> +		       size, buf[0]);
>  		return ret;
>  	}
>  
> 
>> I use a combo card but without mirco sd card inserted.
>> http://www.spectec.com.tw/sdg810.htm
>>
>> Tracing in sdio_cis.c file, I print the tpl_code (line 216).
>> I have 3 successive codes : 0xff, 0x21 & 0x22.
> 
> Again that would be good to know if/when func is NULL when those are 
> parsed.

Here is the log :
mmc0: bad function CISTPL_FUNCE size 28 type 1

with code 0x22.

Thanks for your help. Regards,
-- 
Nicolas Ferre

