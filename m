Return-Path: <linux-kernel-owner+w=401wt.eu-S965153AbXDKTXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbXDKTXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965197AbXDKTXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:23:32 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:52976 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153AbXDKTXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:23:31 -0400
Message-ID: <461D3586.30003@cosmosbay.com>
Date: Wed, 11 Apr 2007 21:22:46 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Maxim Uvarov <muvarov@ru.mvista.com>
CC: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com>	<20070410102111.923b92a9.dada1@cosmosbay.com>	<461CCD94.6010507@ru.mvista.com> <20070411161536.926d79e1.dada1@cosmosbay.com> <461D047B.90800@ru.mvista.com>
In-Reply-To: <461D047B.90800@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 11 Apr 2007 21:22:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov a écrit :
> Eric Dumazet wrote:
> 
>  >Please check kernel/sys.c:k_getrusage() to see how getrusage() has to 
> sum *lot* of individual fields to get precise process numbers (even 
> counting stats for dead threads)
> 
> 
> 
> Thanks for helping me and for this link. But it is not enough clear for 
> me what do you mean at this time.  Inside of patch I am using 2 default 
> counters
> task_struct->nivcsw and task_struct->nvcsw. And also one new syscall 
> counter. And there is only one way to increment this counter, it is from 
> entry.S.
> 
> If you are speaking about locks,  in my point of view, they are not 
> needed in this code. Because increment syscall counter is atomic for X86 
> (just one assembly instruction) and in case with PPC (3 instructions) 
> there 1) nothing wrong will not happen in any case 2) only own thread 
> can increase it's syscall counter. So here should be not any race 
> conditions.

I was not speaking about locks.

> 
> I've tested this patch on x86,x86_64,and ppc_32. And I should work now 
> with ppc_64 (I didn't check).
> And  also updated description.
> 
> Best regards,
> Maxim Uvarov.
> 
> 
> ------------------------------------------------------------------------
> 
> Patch adds Process Performance Statistics.
> It make available to the user the following 
> thread performance statistics:
>    * Involuntary Context Switches (task_struct->nivcsw)
>    * Voluntary Context Switches (task_struct->nvcsw)
>    * Number of system calls (added new counter 
>      thread_info->sysc_cnt)
> 
> Statistics information is available from
> /proc/PID/status
>    
> This data is useful for detecting hyperactivity 
> patterns between processes.
> 

What I meant is : You falsely speak of 'PROCESS performance statistics'.

Your implementation only cares about threads, not processes.
There is a slight difference, that getrusage() can do.

So if you do "cat /proc/PID/status", you'll get counters not for the PROCESS, 
only the main thread of the process.

If you want an analogy, imagine a "ps aux" that doesnt show the cpu time of 
all threads of a process, but only the cpu time of the main thread. Quite 
meaningless isnt it ?

So either :

1) You change all your description to mention 'thread' instead of 'process'.

2) You change your implementation to match your claim.

