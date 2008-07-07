Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYGGLTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYGGLTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 07:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYGGLTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 07:19:30 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:44917 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYGGLTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 07:19:30 -0400
Message-ID: <4871FBBC.4030004@linux.vnet.ibm.com>
Date: Mon, 07 Jul 2008 16:49:24 +0530
From: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       ego@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
       davej@codemonkey.org.uk
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug
 in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com> <87y74w41fp.fsf@skyscraper.fehenstaub.lan> <4860BB8E.2070505@linux.vnet.ibm.com> <87tzfh2t5l.fsf@skyscraper.fehenstaub.lan> <48638906.4090308@linux.vnet.ibm.com> <87y74l4scd.fsf@skyscraper.fehenstaub.lan> <87fxqp7nye.fsf@skyscraper.fehenstaub.lan> <4871E657.3040403@linux.vnet.ibm.com>
In-Reply-To: <4871E657.3040403@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nageswara R Sastry wrote:
> Hi Johannes,
>>>> =======================================================
>>>> [ INFO: possible circular locking dependency detected ]
>>>> 2.6.25.7.cpufreq_patch #2
>>>> -------------------------------------------------------
> [...]
>>> Okay, the problem is in cpufreq_conservative.c.  We
>>> cancel_delayed_work_sync() while holding the mutex, but the work itself
>>> tries to grab it and there it deadlocks; lockdep caught that right.
>>>
>>> The hunk for _ondemand is correct, but the one for _conservative is
>>> obviously wrong, sorry :/
>>>
>>> I will whip something up and get back to you.  Thanks a lot for
>>> testing!
>>
>> Could you try the attached patch instead of the one above?
>>
>> Dave, I dropped the mutex-grabbing from the conservative worker function
>> as well as I don't see a reason for it, please correct me if I'm wrong.
>>
>>     Hannes
>>
> 
> The script is running now for more than 6 hours successfully, I will 
> continue this and let you know if there are any failures.
> 
> * I am seeing the circular locking dependency with the above patch too.
> 

Seeing sysfs hang for second cpu this time while cat file 
/sys/devices/system/cpu/cpu2/cpufreq/scaling_governor

Just to summarize
1. Circular locking dependency issue and
2. sysfs hung for scaling_governor

Thanks!!
Regards
R.Nageswara Sastry


