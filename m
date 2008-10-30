Return-Path: <linux-kernel-owner+w=401wt.eu-S1753372AbYJ3Eh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbYJ3Eh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 00:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYJ3EhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 00:37:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:58750 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYJ3EhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 00:37:12 -0400
Cc: Kay Sievers <kay.sievers@vrfy.org>, Pierre Ossman <drzeus@drzeus.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Message-Id: <C4E7021A-E5BA-4204-BDC1-D2DCA8CCEE1A@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <1225331284.5496.12.camel@brick>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: mmc: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Thu, 30 Oct 2008 05:37:07 +0100
References: <1225329600.5970.72.camel@nga.site> <1225331284.5496.12.camel@brick>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

>> diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
>> index ee6e822..403aa50 100644
>> --- a/include/linux/mmc/card.h
>> +++ b/include/linux/mmc/card.h
>> @@ -130,7 +130,7 @@ struct mmc_card {
>> #define mmc_card_set_blockaddr(c) ((c)->state |= MMC_STATE_BLOCKADDR)
>>
>> #define mmc_card_name(c)	((c)->cid.prod_name)
>> -#define mmc_card_id(c)		((c)->dev.bus_id)
>> +#define mmc_card_id(c)		(dev_name(&(c)->dev))
>>
>> #define mmc_list_to_card(l)	container_of(l, struct mmc_card, node)
>> #define mmc_get_drvdata(c)	dev_get_drvdata(&(c)->dev)
>> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
>> index bde891f..f842f23 100644
>> --- a/include/linux/mmc/host.h
>> +++ b/include/linux/mmc/host.h
>> @@ -176,7 +176,7 @@ static inline void *mmc_priv(struct mmc_host  
>> *host)
>>
>> #define mmc_dev(x)	((x)->parent)
>> #define mmc_classdev(x)	(&(x)->class_dev)
>> -#define mmc_hostname(x)	((x)->class_dev.bus_id)
>> +#define mmc_hostname(x)	(dev_name(&(x)->class_dev))
>>
>> extern int mmc_suspend_host(struct mmc_host *, pm_message_t);
>> extern int mmc_resume_host(struct mmc_host *);
>> diff --git a/include/linux/mmc/sdio_func.h b/include/linux/mmc/ 
>> sdio_func.h
>> index 07bee4a..451bdfc 100644
>> --- a/include/linux/mmc/sdio_func.h
>> +++ b/include/linux/mmc/sdio_func.h
>> @@ -63,7 +63,7 @@ struct sdio_func {
>>
>> #define sdio_func_set_present(f) ((f)->state |= SDIO_STATE_PRESENT)
>>
>> -#define sdio_func_id(f)		((f)->dev.bus_id)
>> +#define sdio_func_id(f)		(dev_name(&(f)->dev))
>>
>> #define sdio_get_drvdata(f)	dev_get_drvdata(&(f)->dev)
>> #define sdio_set_drvdata(f,d)	dev_set_drvdata(&(f)->dev, d)
>>
>
> A lot of these helpers don't seem to add that much, would you care for
> a patch removing them Pierre?
>
> Specifically sdio_func_id, sdio_get/set_drvdata don't have that many
> users.

I prefer if we keep them. Since they take the proper parameter.  
Otherwise the driver has to always got func->dev for everything. Most  
SDIO drivers care of the function and not about the struct device  
underneath it.

Regards

Marcel

