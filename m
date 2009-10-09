Return-Path: <linux-kernel-owner+w=401wt.eu-S934445AbZJIVaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934445AbZJIVaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbZJIV37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:29:59 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:45291 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbZJIV36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=H+CDC5EzJKv71f7xG8yHNRLtDOAbTykiOlXPTWuTxwZRdxncS/K116YaS3dVUB5374
         E5TM39HYwDEPj6PEYA33asmIdEw+xGAfsNAu5Ys3BqJNXvmBVP220zi+zs1LueQ3h2b2
         xu0Mlpqm2+ECSvJomLyKIzMGGHIim0DSxKJi8=
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors, incorrect include files
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Bruce B <bbeare1@gmail.com>
In-Reply-To: <20091009142303.c807a531.randy.dunlap@oracle.com>
Date: Fri, 9 Oct 2009 14:29:19 -0700
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D0384E25-2A85-442D-95C5-115A12514110@gmail.com>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com> <20091009142303.c807a531.randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 9, 2009, at 2:23 PM, Randy Dunlap wrote:

> On Fri,  9 Oct 2009 14:11:38 -0700 Bruce Beare wrote:
>
>> ---
>> drivers/staging/comedi/drivers/serial2002.c |  342 ++++++++++ 
>> +---------------
>> 1 files changed, 145 insertions(+), 197 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/ 
>> staging/comedi/drivers/serial2002.c
>> index a219679..0232186 100644
>> --- a/drivers/staging/comedi/drivers/serial2002.c
>> +++ b/drivers/staging/comedi/drivers/serial2002.c
>> @@ -413,34 +408,37 @@ static void serial_2002_open(struct  
>> comedi_device *dev)
>> 			int min;
>> 			int max;
>> 		};
>> +		struct config_data_t {
>> +			struct config_t dig_in_config[32];
>> +			struct config_t dig_out_config[32];
>> +			struct config_t chan_in_config[32];
>> +			struct config_t chan_out_config[32];
>> +		} *config_data = NULL;
>>
>> -		struct config_t dig_in_config[32];
>> -		struct config_t dig_out_config[32];
>> -		struct config_t chan_in_config[32];
>> -		struct config_t chan_out_config[32];
>> 		int i;
>> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
>
> what happens when the kmalloc() fails??

Nothing good. The driver ignores the return code in numerous places  
and the open routine in this case is defined to be a void return.
I considered it to be a general cleanup subject for this driver at a  
later date.
>
>
>>
>> 		for (i = 0; i < 32; i++) {
>> -			dig_in_config[i].kind = 0;
>> -			dig_in_config[i].bits = 0;
>> -			dig_in_config[i].min = 0;
>> -			dig_in_config[i].max = 0;
>> -			dig_out_config[i].kind = 0;
>> -			dig_out_config[i].bits = 0;
>> -			dig_out_config[i].min = 0;
>> -			dig_out_config[i].max = 0;
>> -			chan_in_config[i].kind = 0;
>> -			chan_in_config[i].bits = 0;
>> -			chan_in_config[i].min = 0;
>> -			chan_in_config[i].max = 0;
>> -			chan_out_config[i].kind = 0;
>> -			chan_out_config[i].bits = 0;
>> -			chan_out_config[i].min = 0;
>> -			chan_out_config[i].max = 0;
>> +			config_data->dig_in_config[i].kind = 0;
>> +			config_data->dig_in_config[i].bits = 0;
>> +			config_data->dig_in_config[i].min = 0;
>> +			config_data->dig_in_config[i].max = 0;
>> +			config_data->dig_out_config[i].kind = 0;
>> +			config_data->dig_out_config[i].bits = 0;
>> +			config_data->dig_out_config[i].min = 0;
>> +			config_data->dig_out_config[i].max = 0;
>> +			config_data->chan_in_config[i].kind = 0;
>> +			config_data->chan_in_config[i].bits = 0;
>> +			config_data->chan_in_config[i].min = 0;
>> +			config_data->chan_in_config[i].max = 0;
>> +			config_data->chan_out_config[i].kind = 0;
>> +			config_data->chan_out_config[i].bits = 0;
>> +			config_data->chan_out_config[i].min = 0;
>> +			config_data->chan_out_config[i].max = 0;
>> 		}
>
>
> ---
> ~Randy

