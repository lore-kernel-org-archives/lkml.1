Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654Ab0AYCPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0AYCPq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 21:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423Ab0AYCPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 21:15:46 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:58404 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0AYCPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 21:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SrPoFx8WYOqVN9ynhSpC5wNx4L0uR5pTcOakNaTL4pLWnw2WmgSVhrFYzMnGFGmR4N
         9XQJdjh6WeABfESkjlIJr730mLdbmBOiF2nqAJ/v+/cRx3UA6lmpNpuGroFFzGDzWFs2
         dyWxo2HBWtKpzi576uw+a7mi/kmTLtLdoqTfQ=
Message-ID: <4B5CFEBE.2070906@gmail.com>
Date: Sun, 24 Jan 2010 21:15:26 -0500
From: Vikram Dhillon <opensolarisdev@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8pre) Gecko/20100120 Shredder/3.0.2pre
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Eric Miao <eric.miao@marvell.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100125013421.GL26562@trinity.fluff.org>
In-Reply-To: <20100125013421.GL26562@trinity.fluff.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2010 08:34 PM, Ben Dooks wrote:
> On Fri, Jan 22, 2010 at 06:03:57PM +0100, Uwe Kleine-König wrote:
>    
>> This fixes a warning on several pxa based machines:
>>
>> 	arch/arm/mach-pxa/ssp.c:475: warning: initialization discards qualifiers from pointer target type
>>      
> this looks sane to me.
>
>    
>> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
>> Cc: Eric Miao<eric.miao@marvell.com>
>> Cc: Greg Kroah-Hartman<gregkh@suse.de>
>> ---
>>   drivers/base/platform.c         |    2 +-
>>   include/linux/platform_device.h |    4 ++--
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index 58efaf2..962246c 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -578,7 +578,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
>>   }
>>
>>   static const struct platform_device_id *platform_match_id(
>> -			struct platform_device_id *id,
>> +			const struct platform_device_id *id,
>>   			struct platform_device *pdev)
>>   {
>>   	while (id->name[0]) {
>> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
>> index 71ff887..3a6201e 100644
>> --- a/include/linux/platform_device.h
>> +++ b/include/linux/platform_device.h
>> @@ -21,7 +21,7 @@ struct platform_device {
>>   	u32		num_resources;
>>   	struct resource	* resource;
>>
>> -	struct platform_device_id	*id_entry;
>> +	const struct platform_device_id	*id_entry;
>>
>>   	/* arch specific additions */
>>   	struct pdev_archdata	archdata;
>> @@ -62,7 +62,7 @@ struct platform_driver {
>>   	int (*suspend)(struct platform_device *, pm_message_t state);
>>   	int (*resume)(struct platform_device *);
>>   	struct device_driver driver;
>> -	struct platform_device_id *id_table;
>> +	const struct platform_device_id *id_table;
>>   };
>>
>>   extern int platform_driver_register(struct platform_driver *);
>> -- 
>> 1.6.6
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>      
>    
Look alright here too :) so:
Cc: Vikram Dhillon <dhillonv10@gmail.com>

--
Regards,
Vikram
