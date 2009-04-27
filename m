Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZD0SZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZD0SZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbZD0SZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:25:22 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:44557 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZD0SZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:25:21 -0400
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome> <20090426153100.GA7481@srcf.ucam.org>
Message-ID: <cone.1240856738.129532.5316.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Acer Aspire One Fan Control
Date: Mon, 27 Apr 2009 20:25:38 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthey,

thanks for your email. A modified patch will follow soon.

Matthew Garrett writes:
>> +	  For more information about this driver see
>> +	  <http://piie.net/files/acerhdf_README.txt>
> 
> Maybe include the readme in Documentation/laptop?

I would like to leave it this way for the moment.

>> +/* if you want the module to be started in kernelmode,
>> + * uncomment following line */
>> +/* #define START_IN_KERNEL_MODE */
> 
> Maybe a module parameter?

I'll leave it with the define and add the kernelmode variable to the 
parameters. This way it's easy for people who want to compile the module 
with kernelmode enabled and it's also easy for those who simply want to load 
the module.

>> +	/* silly hack - let the polling thread disable
>> +	 * kernelmode. This ensures, that the polling thread
>> +	 * doesn't switch off the fan again */
> 
> Is this still needed?

I need this hack for the new "polling" way of the thermal api. I can't 
disable polling from outside. I can change the polling delay, but the next 
polling shot is already assigned. So when I switch on the fan (to BIOS 
mode), this assigned last shot will just switch it off again (if the 
temperature is low). And then neither the BIOS nor the kernel module care 
about the fan anymore :-( The variable just prevents the last shot from 
switching off the fan.

>> +	/* print out bios data */
>> +	printk(KERN_NOTICE "acerhdf: version: %s compilation date: %s %s\n",
>> +			VERSION, __DATE__, __TIME__);
>> +	printk(KERN_NOTICE "acerhdf: biosvendor:%s\n", vendor);
>> +	printk(KERN_NOTICE "acerhdf: biosversion:%s\n", version);
>> +	printk(KERN_NOTICE "acerhdf: biosrelease:%s\n", release);
>> +	printk(KERN_NOTICE "acerhdf: biosproduct:%s\n", product);
> 
> Perhaps only do this if verbose mode is enabled? 5 lines of output for 
> one driver seems excessive.

You are right, will 2 lines in non-verbose mode be ok?

>> +		printk(KERN_NOTICE
>> +			"acerhdf: kernelmode disabled\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: to enable kernelmode:\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: echo -n \"enabled\" > "
>> +			"/sys/class/thermal/thermal_zone0/mode\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: for more information read:\n");
>> +		printk(KERN_NOTICE
>> +			"acerhdf: http://piie.net/files/acerhdf_README.txt\n");
> 
> This is the default behaviour, right? So that's another 5 lines by 
> default. I don't think it's really necessary :)

I added these lines as I got lot's of emails when I set the user mode to 
default. People were complaining that the module wouldn't work, but they 
just didn't know how to switch to kernel mode and were too lazy to read the 
code or the documentation. So I think this information should stay there. I 
can try to cut it to 2 lines. Or do you have another idea to manage this?

best regards,
--peter
