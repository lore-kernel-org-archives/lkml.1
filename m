Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbXKZI5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbXKZI5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 03:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbXKZI5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 03:57:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:40180 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXKZI5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 03:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uGGjl2hrpMN7Zm+93k9OdPR2JqrSaHTto5WitgnHa6hPReUOxvApDu5+A+cCZV2CuXUXGRUycKVkDCChlwBPMvcLO7vMSh7UVuY+o27kAaNm0EKGVDeiU2QBkLu1llxuQ6YVN805grSbi//hkLfIzV8WmLD2IhxtpjwDHZRlnFQ=
Message-ID: <474A8A82.6040303@gmail.com>
Date: Mon, 26 Nov 2007 09:57:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Rudolf Marek <r.marek@assembler.cz>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [lm-sensors] broken suspend [Was: 2.6.24-rc2-mm1]
References: <4741EB91.9080000@assembler.cz> <Pine.LNX.4.44L0.0711191521170.3129-100000@iolanthe.rowland.org> <20071120131520.GC12077@jupiter.solarsys.private> <200711210100.43049.rjw@sisk.pl>
In-Reply-To: <200711210100.43049.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2007 01:00 AM, Rafael J. Wysocki wrote:
> On Tuesday, 20 of November 2007, Mark M. Hoffman wrote:
>> commit ce9c7b78c839a6304696d90083eac08baad524ce
>> Author: Mark M. Hoffman <mhoffman@lightlink.com>
>> Date:   Tue Nov 20 07:51:50 2007 -0500
>>
>>     hwmon: (coretemp) fix suspend/resume hang
>>     
>>     Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
> 
> I'd do it like this:
> 
>> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
>> index 5c82ec7..afe2d31 100644
>> --- a/drivers/hwmon/coretemp.c
>> +++ b/drivers/hwmon/coretemp.c
>> @@ -338,10 +338,12 @@ static int coretemp_cpu_callback(struct notifier_block *nfb,
>>  	switch (action) {
>>  	case CPU_ONLINE:
>>  	case CPU_ONLINE_FROZEN:
>> +	case CPU_DOWN_FAILED:
>>  		coretemp_device_add(cpu);
> +	case CPU_DOWN_FAILED_FROZEN: 
>>  		break;
>> -	case CPU_DEAD:
>> -	case CPU_DEAD_FROZEN:
>> +	case CPU_DOWN_PREPARE:
>>  		coretemp_device_remove(cpu);
> +	case CPU_DOWN_PREPARE_FROZEN:
>>  		break;
>>  	}

Sorry for the delay, this (trimmed version) solves the problem!

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
