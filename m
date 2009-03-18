Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZCRPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZCRPdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZCRPc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 11:32:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:65051 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZCRPc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 11:32:58 -0400
Message-ID: <49C11403.6010305@windriver.com>
Date: Wed, 18 Mar 2009 11:32:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate()
 against SMI. (take 2)
References: <49BFA1D7.8020302@windriver.com> <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com> <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com> <49C0FD63.2050900@windriver.com> <49C10F1B.9050809@ladisch.de>
In-Reply-To: <49C10F1B.9050809@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Mar 2009 15:32:22.0070 (UTC) FILETIME=[BB1EB560:01C9A7DE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Paul Gortmaker wrote:
>   
>> Yasunori Goto wrote:
>>     
>>> +	/*
>>> +	 * Try to calibrate until return value becomes stable small value.
>>> +	 * If SMI interruption occurs in calibration loop, the return value
>>> +	 * will be big. This avoids its impact.
>>> +	 */
>>> +	do {
>>> +		tmp = __hpet_calibrate(hpetp);
>>> +		if (ret <= tmp)
>>> +			break;
>>> +		ret = tmp;
>>> +	} while (1);
>>>       
>> For what it is worth, if a situation arose where continued calls to
>> hpet_calibrate() represented a monotonically decreasing function,
>> (perhaps some insane power management?) you could be stuck
>> in this function for an unbounded amount of time.
>>     
>
> On my machine, the number of iterations of the loop in __hpet_calibarate
> (the value of i) is about 400, and since HPET reads/writes go to the
> southbridge, it cannot get much higher than about 1000 even on faster
> machines.
>
> The value of (m - start) is approximately constant, as long as the loop
> runs for about 1 ms, so there cannot be too many distinct return values.
>
> Consequently, the only way for perverse SMIs to produce more
> monotonically decreasing calibration values is to introduce delays that
> make the loop run longer than 1 ms, i.e., to eat most of the CPU time
> for at least several seconds (or longer if you want unbounded time).
> Even in the real world ;-), no laptop manufacturer is that insane.
>   

Right - as I said, I didn't expect that it could ever happen, and your 
analysis
above seems to help reinforce that, so we probably should be OK.

Thanks,
Paul.

>
> Best regards,
> Clemens
>   

