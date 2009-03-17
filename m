Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZCQNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZCQNO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZCQNOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:14:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:47731 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbZCQNOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:14:50 -0400
Message-ID: <49BFA1D7.8020302@windriver.com>
Date: Tue, 17 Mar 2009 09:12:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of hpet_calibrate()
 against SMI.
References: <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com> <49BE215F.7040307@ladisch.de> <20090317185152.47CD.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20090317185152.47CD.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2009 13:13:50.0617 (UTC) FILETIME=[36B1E090:01C9A702]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> Sorry for late response.
>
>   
>> Yasunori Goto wrote:
>>     
>>>> I've no sense of feel for how long each calibration run would take.
>>>> Would doing it 5 times show up as a significant increase in the boot
>>>> time for those that care about boot time being as quick as possible?
>>>>         
>>> Hmm. The loop times is trade off against reliable value....
>>> Though SMI is rare interruption, I don't know how frequent
>>> hypervisor's switch is.
>>>       
>> Could you, just for testing, run the calibration five thousand times or
>> so instead of five times, and count how often you get insane values?
>> (And how much delay does such an SMI add?)
>>     
>
> I tried 50000 times. But insane value was nothing.
> I think SMI is very rare.
>
>   
>>> Each calibration of this has 1 milli second.
>>> Do you think 5 msec is too long?
>>>       
>> This shouldn't matter when booting.  Anyway, I think it's possible to
>> increase TICK_CALIBRATE without losing too much accuracy.
>>     
>
> Hmm. If the person who is trying to reduce boot time for fastboot dislikes this impact,
> then I'll try Vojtech-san's way.
>   

That probably makes sense -- if it is extremely rare, and if you get two
values that are the same (within some small delta) then you probably
are 99.99% confident that you have the right data.

Paul.

>
> Thanks.
>   

