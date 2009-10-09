Return-Path: <linux-kernel-owner+w=401wt.eu-S934484AbZJIVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbZJIVc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934475AbZJIVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:32:25 -0400
Received: from mail-pz0-f177.google.com ([209.85.222.177]:51470 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934453AbZJIVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=Pqk9JYijQXvF9Nah3W0WaVPjXOUExxTr8zbW0+cVcrBE/yEgFkdb/QQn6XmyPOsfTN
         ILIiaiwStRCJIr1DWzesr54sDycxOZ1uAf/PNYyKTwoPY3ka9lHacNVTsVN70NVwWOrY
         Z3lmV24M1Sjc+E/qbwK92A2JPYnQfBnWTGpqM=
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors, incorrect include files
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Bruce B <bbeare1@gmail.com>
In-Reply-To: <20091009211610.GA5005@suse.de>
Date: Fri, 9 Oct 2009 14:31:46 -0700
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <936929F4-6F9E-4DE2-B3C1-1B2E16D2AEC2@gmail.com>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com> <20091009211610.GA5005@suse.de>
To: Greg KH <gregkh@suse.de>
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Oct 9, 2009, at 2:16 PM, Greg KH wrote:

>
> Try changing one thing at a time per patch please.
>
> There's some bugs in here:
>
>> -		struct config_t dig_in_config[32];
>> -		struct config_t dig_out_config[32];
>> -		struct config_t chan_in_config[32];
>> -		struct config_t chan_out_config[32];
>> 		int i;
>> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
>
> Shouldn't that be:
> 		config_data = kmalloc(sizeof(struct config_data_t)*32, GFP_KERNEL);


The structure already has the [32]'s copied from the original defn's.
If you like... I can still break up the commit into two patches. Also,  
moving the *32 out isn't a bad idea; were I
to break it up, I would likely do so.


>
> Otherwise you overflow your buffer here:
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
> Or am I mistaken?
>
> thanks,
>
> greg k-h

