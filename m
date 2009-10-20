Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZJTKVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZJTKVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 06:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZJTKVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 06:21:52 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17995 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbZJTKVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:21:52 -0400
Message-ID: <4ADD8F24.30401@nokia.com>
Date: Tue, 20 Oct 2009 13:21:24 +0300
From: Aaro Koskinen <aaro.koskinen@nokia.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ext Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mfd: twl4030-power: do not allow negative or zero
 length script
References: <1255522550-15199-1-git-send-email-aaro.koskinen@nokia.com> <20091019163715.GG3885@sortiz.org>
In-Reply-To: <20091019163715.GG3885@sortiz.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Oct 2009 10:21:26.0118 (UTC) FILETIME=[14885860:01CA516F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Samuel Ortiz wrote:
> On Wed, Oct 14, 2009 at 03:15:49PM +0300, Aaro Koskinen wrote:
>> The script length cannot be negative. If the length is zero, return
>> an error.
>>
>> The patch eliminates the following compiler warning:
> Out of curiosity, which toolchain are you using ? I cross compile my mfd tree
> for ARM, and I dont get this error...

It seems I was accidentally using an older version of CodeSourcery
toolchain (2007q3-51). I tried now with the recent one and warnings
do not appear. I'm still not sure if they were totally bogus or not...

>> drivers/mfd/twl4030-power.c: In function 'twl4030_power_init':
> twl4030_power_init ? Isnt it twl4030_write_script ?

You are right, it seems the compiler does some inlining and
reports a wrong function name.

A.

> Cheers,
> Samuel.
> 
> 
>> drivers/mfd/twl4030-power.c:151: warning: 'err' may be used uninitialized in this function
>> drivers/mfd/twl4030-power.c:151: note: 'err' was declared here
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
>> ---
>>  drivers/mfd/twl4030-power.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
>> index d423e0c..eae6cda 100644
>> --- a/drivers/mfd/twl4030-power.c
>> +++ b/drivers/mfd/twl4030-power.c
>> @@ -146,9 +146,9 @@ out:
>>  }
>>  
>>  static int __init twl4030_write_script(u8 address, struct twl4030_ins *script,
>> -				       int len)
>> +				       unsigned len)
>>  {
>> -	int err;
>> +	int err = EINVAL;
>>  
>>  	for (; len; len--, address++, script++) {
>>  		if (len == 1) {
>> -- 
>> 1.6.0.4
>>
> 

