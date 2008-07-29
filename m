Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbYG2IRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbYG2IRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYG2IQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:16:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:12904 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbYG2IQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:16:41 -0400
Message-ID: <488ED165.5040203@oracle.com>
Date: Tue, 29 Jul 2008 16:14:29 +0800
From: Wenji Huang <wenji.huang@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
References: <20080729162300.733b3e09.sfr@canb.auug.org.au> <20080729080055.GA28916@elte.hu>
In-Reply-To: <20080729080055.GA28916@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi Dave,
>>
>> Today's linux-next build (sparc64 defconfig) failed like this:
>>
>> kernel/time/tick-common.c: In function `tick_check_new_device':
>> kernel/time/tick-common.c:210: error: invalid lvalue in unary `&'
>> kernel/time/tick-common.c:223: error: invalid lvalue in unary `&'
>> kernel/time/tick-common.c:255: error: invalid lvalue in unary `&'
>>
>> gcc is version 3.4.5 sparc64 cross compiler (powercp64 host).
>>
>> The below patch fixes it.
>>
>> when you take the address of the result.  Noticed on a sparc64 compile
>> using a version 3.4.5 cross compiler.
>>
>> kernel/time/tick-common.c: In function `tick_check_new_device':
>> kernel/time/tick-common.c:210: error: invalid lvalue in unary `&'
>> kernel/time/tick-common.c:223: error: invalid lvalue in unary `&'
>> kernel/time/tick-common.c:255: error: invalid lvalue in unary `&'
>>
>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> ---
>>  include/linux/cpumask.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index 96d0509..d3219d7 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -287,7 +287,7 @@ static inline const cpumask_t *get_cpu_mask(unsigned int cpu)
>>   * gcc optimizes it out (it's a constant) and there's no huge stack
>>   * variable created:
>>   */
>> -#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
>> +#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
> 
> hm, i'm wondering - is this a compiler bug?
> 
> 	Ingo

Same problem on x86/gcc 3.4.6, but will pass on gcc 4.x

Regards,
Wenji
