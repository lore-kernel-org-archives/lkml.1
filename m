Return-Path: <linux-kernel-owner+w=401wt.eu-S1752092AbZHRUxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbZHRUxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZHRUxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:53:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54272 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZHRUxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:53:11 -0400
Message-ID: <4A8B14AB.3020707@ti.com>
Date: Tue, 18 Aug 2009 15:52:59 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 2/2] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
References: <1250617512-23567-1-git-send-email-jon-hunter@ti.com> <1250617512-23567-2-git-send-email-jon-hunter@ti.com> <1250617512-23567-3-git-send-email-jon-hunter@ti.com> <alpine.LFD.2.00.0908182125590.3361@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908182125590.3361@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas Gleixner wrote:
> On Tue, 18 Aug 2009, Jon Hunter wrote:
>> diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
>> index 3a1dbba..8154bc6 100644
>> --- a/include/linux/clockchips.h
>> +++ b/include/linux/clockchips.h
>> @@ -77,8 +77,8 @@ enum clock_event_nofitiers {
>>  struct clock_event_device {
>>  	const char		*name;
>>  	unsigned int		features;
>> -	unsigned long		max_delta_ns;
>> -	unsigned long		min_delta_ns;
>> +	unsigned long long	max_delta_ns;
>> +	unsigned long long	min_delta_ns;
> 
> Can we please use u64 for this ?

John brought this up as well. There was some discussion sometime back 
about this. I did get some feedback that u64 was a different type 
between ppc64 and x86-64 which was causing problems with printk. The 
above variables are also used with printk in the kernel today.

See the following email:
http://marc.info/?l=linux-kernel&m=124041426203283&w=2

I am not sure if this is still the case and safer to stick with 
long-long for now. Let me know your thoughts.

Cheers
Jon








