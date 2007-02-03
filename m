Return-Path: <linux-kernel-owner+w=401wt.eu-S1751534AbXBCUVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbXBCUVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 15:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXBCUVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 15:21:30 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:35278 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXBCUV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 15:21:29 -0500
Message-ID: <45C4EDF9.7050804@joow.be>
Date: Sat, 03 Feb 2007 21:18:01 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Dan Dennedy <dan@dennedy.org>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] ieee1394: cycle timer read extension for raw1394/libraw1394
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de> <45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de> <45C4DC97.3050101@s5r6.in-berlin.de>
In-Reply-To: <45C4DC97.3050101@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: weequay 20001; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> I wrote:
>> +++ linux/drivers/ieee1394/raw1394.h	2007-02-03 13:47:34.000000000 +0100
>> @@ -178,4 +178,14 @@ struct raw1394_iso_status {
>>  	__s16 xmit_cycle;
>>  };
>>  
>> +/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
>> +struct raw1394_cycle_timer {
>> +	/* contents of Isochronous Cycle Timer register,
>> +	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
>> +	__u32 cycle_timer;
>> +
>> +	/* local time in microseconds since Epoch,
>> +	   simultaneously read with cycle timer */
>> +	__u64 local_time;
>> +};
>>  #endif /* IEEE1394_RAW1394_H */
> 
> Pieter,
> one more thing. Do you want to hand out the cycle_timer bitfield to
> userspace as-is, or would it make sense to postprocess it in some way?
I like it as is. most of the time I convert it into ticks, but sometimes 
I just need the cycles.

Another reason not to postprocess is that it gives userspace more 
freedom in how accurate they want to use the cycle time. I'm probably 
going to throw away the seconds field altogether, because one second is 
a huge timeframe in my application. Throwing away the seconds field 
saves me quite some calculations.

Pieter
