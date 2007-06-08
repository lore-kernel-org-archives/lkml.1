Return-Path: <linux-kernel-owner+w=401wt.eu-S968939AbXFHLdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968939AbXFHLdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968434AbXFHLdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:33:40 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37892 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968090AbXFHLdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:33:39 -0400
Message-ID: <46693620.7080401@linux.vnet.ibm.com>
Date: Fri, 08 Jun 2007 16:27:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com, haveblue@us.ibm.com,
       xemul@sw.ru, dev@sw.ru, rohitseth@google.com, pj@sgi.com,
       devel@openvz.org, ebiederm@xmission.com, mbligh@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, menage@google.com,
       svaidy@linux.vnet.ibm.com, cpw@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] Per container statistics (containerstats)
References: <20070606115813.GA32197@linux.vnet.ibm.com> <20070607155445.edd5fded.akpm@linux-foundation.org> <4668BD18.7090603@linux.vnet.ibm.com> <46693488.3070601@linux.vnet.ibm.com>
In-Reply-To: <46693488.3070601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Balbir Singh wrote:
>>>>  	return *(pid_t *)a - *(pid_t *)b;
>>>> diff -puN kernel/sched.c~containers-taskstats kernel/sched.c
>>>> --- linux-2.6.22-rc2-mm1/kernel/sched.c~containers-taskstats	2007-06-05 17:21:57.000000000 +0530
>>>> +++ linux-2.6.22-rc2-mm1-balbir/kernel/sched.c	2007-06-05 17:21:57.000000000 +0530
>>>> @@ -4280,11 +4280,13 @@ void __sched io_schedule(void)
>>>>  {
>>>>  	struct rq *rq = &__raw_get_cpu_var(runqueues);
>>>>  
>>>> +	delayacct_set_flag(DELAYACCT_PF_BLKIO);
>>>>  	delayacct_blkio_start();
>>> Would it be suitable and appropriate to embed the delayacct_set_flag() call
>>> inside delayacct_blkio_start()?
>>>
>> Yes, I should have done that, will do.
>>
>>
> 
> My last reply was wrong, the flag needs to be set outside so that we know the
> context that initiated block I/O. We use this flag to track the time used
> by the swap block I/O. 
> 

Please ignore this email.. it escaped my drafts folder... my fault.. apologies.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
