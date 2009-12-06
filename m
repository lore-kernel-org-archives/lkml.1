Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZLFMwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZLFMwQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZLFMwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:52:14 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51948 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbZLFMwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:52:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fMVB9EE2lsRDpFAk+T5zQF7M8bvonQqqClaGguzCYEQx3kAdVB/6RsnF68KdyeUzTn
         +NNYLdJEBYiLsCpB72HHLFtmHrUTjubvJfIiAtzZqo212dQwjDS+/3y0t/3pX4UgMQLA
         tX8qIsS+9D4OK+hR3FKu++YH7vH1Au2Nojk+w=
Message-ID: <4B1BA900.4040402@gmail.com>
Date: Sun, 06 Dec 2009 14:52:16 +0200
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Unable to use tools/perf sched and timechart correctly
References: <4B18E2AD.3070507@gmail.com> <4B1B8A66.6040302@cn.fujitsu.com>
In-Reply-To: <4B1B8A66.6040302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-12-06 12:41, Xiao Guangrong wrote:
> Török Edwin wrote:
>   
>> Hi,
>>
>> I installed 2.6.32 and tried its tools/perf.
>> I noticed two problems so far, please tell me if I am doing anything
>> wrong here:
>>
>> 1. 'perf sched replay' segfaults on any recorded workload
>> I tested like this:
>> $ sudo ./perf sched record
>> ^C[ perf record: Woken up 1 times to write data ]                  
>> [ perf record: Captured and wrote 0.295 MB perf.data (~12869 samples) ]
>> $ sudo perf sched replay
>> run measurement overhead: 1258 nsecs                             
>> sleep measurement overhead: 55232 nsecs                          
>> the run test took 999778 nsecs                                   
>> the sleep test took 1055791 nsecs                                
>> nr_run_events:        182                                        
>> nr_sleep_events:      209                                        
>> nr_wakeup_events:     103                                        
>> target-less wakeups:  12
>> [...]
>> task     25 (         icedove-bin:      8757), nr_events: 3
>> task     26 (            events/0:        15), nr_events: 3
>> ------------------------------------------------------------
>> Segmentation fault
>>     
>
> You should enable "CONFIG_SCHED_DEBUG", because we use
> "/proc/<pid>/sched" file to get the task's cpu usage.
>   

Thanks, that got rid of the segfault, and perf sched replay runs without
crashing now.

Am I missing a config option for 'perf timechart' to work?
I tried running 4 infloop executables (on a 4-core box), the last one as
argument to perf timechart record.
Only one of those processes has shown up, as using CPU for 26.5ms, and
then sleeping (when in fact it was running the entire time).
The CPU graphs are mostly white, with a thicker blue line where a.out
shown up, and some scarce thin blue lines.


Best regards,
--Edwin
