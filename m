Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbXEJIeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbXEJIeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756139AbXEJIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:34:08 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3621 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbXEJIeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:34:07 -0400
Message-ID: <4642D8D9.4020302@shadowen.org>
Date: Thu, 10 May 2007 09:33:29 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andy Whitcroft <apw@shadowen.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.21-mm1 -- x86 verify_cpu.S compile failure
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <464046EC.40301@shadowen.org> <20070508152415.GA16967@one.firstfloor.org> <4641F19F.605@shadowen.org>
In-Reply-To: <4641F19F.605@shadowen.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Andi Kleen wrote:
>> On Tue, May 08, 2007 at 10:46:20AM +0100, Andy Whitcroft wrote:
>>> We are seeing the following compile error on older x86 installs:
>>>
>>>   arch/i386/kernel/verify_cpu.S: Assembler messages:
>>>   arch/i386/kernel/verify_cpu.S:13: Error: `(%esp)' is
>>> 			 not a valid 16 bit base/index expression
>>>
>>> Seems to come from:
>>>
>>>   x86_64-mm-i386-verify-cpu
>>>
>>> Compiler:
>>>
>>>   gcc version 3.3.4 (Debian 1:3.3.4-3)
>> Your compiler must be a brother in spirit of Andrew's vaio.
>>
>> Does this patch help? 
>>
>> -Andi
>>
>>
>> Index: linux/arch/i386/kernel/verify_cpu.S
>> ===================================================================
>> --- linux.orig/arch/i386/kernel/verify_cpu.S
>> +++ linux/arch/i386/kernel/verify_cpu.S
>> @@ -10,7 +10,9 @@ verify_cpu:
>>  
>>  #if CONFIG_X86_MINIMUM_CPU_MODEL >= 4
>>  	pushfl
>> -	orl	$(1<<18),(%esp)		# try setting AC
>> +	pop	%eax
>> +	orl	$(1<<18),%eax		# try setting AC
>> +	push	%eax
>>  	popfl
>>  	pushfl
>>  	popl    %eax
>>
>>
> 
> Yep that gets us past the compile problems.  Of course she then blows up
> cause SLUB does not work on x86 in that version ... but ...
> 
> Acked-by: Andy Whitcroft <apw@shadowen.org>

I note that this problem is also up in mainline, since 2.6.21-git6.
Andi can you push this fix up too?

-apw
