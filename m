Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0CAAg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 19:36:26 -0500
Received: from lo.gmane.org ([80.91.229.12]:37422 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0CAAgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 19:36:24 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH v1] compiler: prevent dead store elimination
Date: Sun, 28 Feb 2010 19:36:07 -0500
Message-ID: <4B8B0BF7.4060105@tmr.com>
References: <4B8984EE.8090605@gmail.com> <20100228095520.GA29531@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-149-162.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
In-Reply-To: <20100228095520.GA29531@one.firstfloor.org>
Cc: linux-crypto@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Every byte in the [p,p+n[ range must be used. If you only use the
>> first byte, via e.g. asm("" :: "m"(*(char*)p)), then the compiler
>> _will_ skip scrubbing bytes beyond the first. This works with
>> gcc-3.2.3 up to gcc-4.4.3.
> 
> You forgot to credit Mikael who did all the hard work figuring
> this out?
> 
>>  /*
>> + * Dead store elimination (DSE) is an optimization that may remove a write to
>> + * a buffer that is not used anymore. Use ARRAY_PREVENT_DSE after a write when
>> + * the scrub is required for security reasons.
>> + */
>> +#define ARRAY_PREVENT_DSE(p, n)				\
> 
> Maybe it's just me, but the name is ugly.
> 
>> +	do {						\
>> +		struct __scrub { char c[n]; };		\
> 
> 
> Better typeof(*p)[n]
> 
>> +++ b/include/linux/compiler-intel.h
>> @@ -14,9 +14,11 @@
>>   * It uses intrinsics to do the equivalent things.
>>   */
>>  #undef barrier
>> +#undef ARRAY_PREVENT_DSE
>>  #undef RELOC_HIDE
>>  
>>  #define barrier() __memory_barrier()
>> +#define ARRAY_PREVENT_DSE(p, n)
> 
> Who says the Intel compiler doesn't need this?
> 
> I'm sure it does dead store elimination too and it understands
> gcc asm syntax.
> 
According to the Intel forum, it not only doesn't, but a request for this as a 
feature was rejected, so it won't. Or am I misreading this?

http://software.intel.com/en-us/forums/showthread.php?t=46770

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

