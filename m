Return-Path: <linux-kernel-owner+w=401wt.eu-S936559AbYEBVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936559AbYEBVL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965130AbYEBVKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 17:10:53 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:57309 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965101AbYEBVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 17:10:52 -0400
Date: Fri, 2 May 2008 23:10:38 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: add pretty back strace
Message-ID: <20080502211038.GB22631@Chamillionaire.breakpoint.cc>
References: <200805010216.m412GcUQ004101@goober> <481B6B3D.9060200@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <481B6B3D.9060200@grupopie.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paulo Marques | 2008-05-02 20:27:57 [+0100]:

> Greg Ungerer wrote:
>> From: Sebastian Siewior <bigeasy@linutronix.de>
>> With this patch and
>>  CONFIG_FRAME_POINTER=y
>>  CONFIG_KALLSYMS=y
>> The backtrace shows resolved function names and their numeric
>> address.
>
> This is really not my area, but this patch reminds me of all the dwarf2 
> unwinder on x86 that caused so many problems in the beginning...
>
>> [...]
>> +#ifdef CONFIG_FRAME_POINTER
>> +	printk(KERN_EMERG "Call Trace:\n");
>> +
>> +	last_stack = stack - 1;
>> +	while (stack <= endstack && stack > last_stack) {
>> +
>> +		addr = *(stack + 1);
>> +		printk(KERN_EMERG " [%08lx] ", addr);
>> +		print_symbol(KERN_CONT "%s\n", addr);
>> +
>> +		last_stack = stack;
>> +		stack = (unsigned long *)*stack;
>>  	}
>>  	printk("\n");
>> +#else
>> +	printk(KERN_EMERG "CONFIG_FRAME_POINTER disabled, no symbolic call 
>> trace\n");
>
> You could probably fall back to the old method in this case, no?
The old method printed every value from stack which was in the text
range (you didn't get modules AFAIK). This might be the caller as well a
function pointer as argument as well something else. I tried to find to
find a pattern without frame pointers but I had no luck. I thing the
caller fixed the stack frame or something.
Greg did not complain about removing it. If you or others want the old
method in case of no frame pointers I can send a patch.

> Also, if the stack is slightly corrupted on the top, the new method might 
> just bail out without giving any indication about the path that lead there, 
> when instead it could also fall back to the old method.
You mean by slightly that the first caller ORed the address with
something? In that case we don't return safely. I don't know how I could
find out the right time for a fallback (in case of slightly corrupted
stack).

> Paulo Marques - www.grupopie.com
Sebastian
