Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbYARSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbYARSgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932347AbYARSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:35:48 -0500
Received: from mga06.intel.com ([134.134.136.21]:23085 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932145AbYARSfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:35:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,217,1199692800"; 
   d="scan'208";a="326852420"
Message-ID: <4790F172.5070907@linux.intel.com>
Date: Fri, 18 Jan 2008 10:35:30 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Roberto Fichera <kernel@tekno-soft.it>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Announce] Development release 0.1 of the LatencyTOP tool
References: <4790E3A6.7060807@linux.intel.com> <20080118182714.2DA32498006@tavolara.isolaweb.it>
In-Reply-To: <20080118182714.2DA32498006@tavolara.isolaweb.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roberto Fichera wrote:
> At 18.36 18/01/2008, Arjan van de Ven wrote:
>> The Intel Open Source Technology Center is pleased to announce the
>> release of version 0.1 of LatencyTOP, a tool for developers to visualize
>> system latencies.
>>
>> http://www.latencytop.org
>>
> 
> [...snip...]
> 
>> The most basic annotation looks like this (in the patches more complex
>> versions can be seen):
>>
>>  asmlinkage long sys_sync(void)
>>  {
>> +       struct latency_entry reason;
>> +       set_latency_reason("sync system call", &reason);
>>         do_sync(1);
>> +       restore_latency_reason(&reason);
>> +
>>         return 0;
>>  }
>>
> 
> I really like this patch :-)! Just a little note, why don't make 
> the parameter 'char *reason' as simple integer (reason_t)? 
> Making it as integer will automatically drop the strncmp() 
> and speeding up all the things. Could be also interesting to 
> define _externally_ the mapping of the reason so the 
> userspace tool could handle it easily.
> 

I thought about that, but the strncmp is still somewhat needed to deal with the argument
(the instrumentation above doesn't use that, but the mutex one does for example)
If we get rid of the argument entirely it'd be easier
(but then we get "blocking on mutex" rather than "blocking on inode->mutex")
