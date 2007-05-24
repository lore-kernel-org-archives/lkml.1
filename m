Return-Path: <linux-kernel-owner+w=401wt.eu-S1750817AbXEXNm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750817AbXEXNm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbXEXNmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:42:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:57836 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbXEXNmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:42:19 -0400
Message-ID: <46559638.6@qumranet.com>
Date: Thu, 24 May 2007 16:42:16 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lhcs-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 4/7] SMP: Implement on_one_cpu()
References: <1180008615579-git-send-email-avi@qumranet.com> <11800086152009-git-send-email-avi@qumranet.com> <20070524133625.GA9863@osiris.ibm.com>
In-Reply-To: <20070524133625.GA9863@osiris.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> On Thu, May 24, 2007 at 03:10:12PM +0300, Avi Kivity wrote:
>   
>> This defines on_one_cpu() which is similar to smp_call_function_single()
>> except that it works if cpu happens to be the current cpu.  Can also be
>> seen as a complement to on_each_cpu() (which also doesn't treat the
>> current cpu specially).
>>
>> Signed-off-by: Avi Kivity <avi@qumranet.com>
>> ---
>>  include/linux/smp.h |   15 +++++++++++++++
>>  kernel/softirq.c    |   24 ++++++++++++++++++++++++
>>  2 files changed, 39 insertions(+), 0 deletions(-)
>>
>> +/*
>> + * Call a function on one processor
>> + */
>> +int on_one_cpu(int cpu, void (*func)(void *info), void *info,
>> +	       int retry, int wait);
>>
>>     
>
> Would you mind renaming that one to simply 'on_cpu'? It's even shorter and
> clearly everybody will know what its purpose is. Also I doubt we will ever
> have something like 'on_two_cpus'.
>   

That was my first choice, but then I went for symmetry with 
on_each_cpu().  I'll rename it to on_cpu() unless there are objections.


-- 
error compiling committee.c: too many arguments to function

