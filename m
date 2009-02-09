Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZBIXHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZBIXHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbZBIXGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:06:38 -0500
Received: from relay3.sgi.com ([192.48.171.31]:52546 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754697AbZBIXGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:06:37 -0500
Message-ID: <4990B6FB.5030803@sgi.com>
Date: Mon, 09 Feb 2009 15:06:35 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: include/linux/irq.h:452: error: implicit declaration of	function
 'cpu_to_node'
References: <20090121215306.GA10123@x200.localdomain> <4977B1F1.1090602@sgi.com> <20090209203502.GA7701@x200.localdomain> <4990A899.8070302@sgi.com> <4990A96A.3060603@sgi.com> <20090209224003.GA9795@x200.localdomain>
In-Reply-To: <20090209224003.GA9795@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Mon, Feb 09, 2009 at 02:08:42PM -0800, Mike Travis wrote:
>> Mike Travis wrote:
>>> Alexey Dobriyan wrote:
>>>> On Wed, Jan 21, 2009 at 03:38:25PM -0800, Mike Travis wrote:
>>>>> Alexey Dobriyan wrote:
>>>>>> On mips-malta:
>>>>>>
>>>>>>   CC      arch/mips/mti-malta/malta-int.o
>>>>>> In file included from arch/mips/mti-malta/malta-int.c:25:
>>>>>> include/linux/irq.h: In function 'init_alloc_desc_masks':
>>>>>> include/linux/irq.h:452: error: implicit declaration of function 'cpu_to_node'
>>>>>> include/linux/irq.h:454: error: 'GFP_ATOMIC' undeclared (first use in this function)
>>>>>>
>>>>>> I _think_ init_alloc_desc_masks() should be made out of line to fix this.
>>>>> Hi Alexey,
>>>>>
>>>>> Does adding #include <linux/slab.h> fix the error?  If so, I can add this to
>>>>> linux/irq.h.
>>>>>
>>>>> The primary reason it's inline is that unless CONFIG_CPUMASK_OFFSTACK=y, then the
>>>>> entire routine is a NOP which optimizes out more completely as an inline function.
>>>> linux/slab.h helps.
>>> Hi Alexey,
>>>
>>> Since you reported this problem a similar issue was discovered on s390.  However
>>> the fix for that was to include interrupt.h instead of irq.h.
>>>
>>> Could you try this as well?
>>>
>>> Here's a tail end pointer to the thread and Andrew's commit msg including the
>>> patch is below.
>>>
>>> http://marc.info/?l=linux-mm-commits&m=123360349631362&w=4
>> Sorry, I should have made a patch specific to mips, and here that is...
> 
> This is without slab.h in irq.h
> 
> But slab,h in irq.h is not enough for s390 sysrq.

Ahh, I thought it had already passed your testing.

So, you're saying that adding the include of slab.h to irq.h fixes the problem,
and that removing the include of irq.h in malta-int.c is meaningless?

This really is a maze of twisty little passages... ;-)

(Btw, maybe you should submit the fixup patch to Andrew, I seem to only be adding
to the confusion?)

Thanks,
Mike

> 
>   CC      kernel/irq/handle.o
> In file included from kernel/irq/handle.c:13:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/handle.o] Error 1
>   CC      kernel/irq/manage.o
> In file included from kernel/irq/manage.c:10:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/manage.o] Error 1
>   CC      kernel/irq/spurious.o
> In file included from kernel/irq/spurious.c:10:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/spurious.o] Error 1
>   CC      kernel/irq/resend.o
> In file included from kernel/irq/resend.c:16:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/resend.o] Error 1
>   CC      kernel/irq/chip.o
> In file included from kernel/irq/chip.c:13:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/chip.o] Error 1
>   CC      kernel/irq/autoprobe.o
> In file included from kernel/irq/autoprobe.c:9:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)
> make[3]: *** [kernel/irq/autoprobe.o] Error 1
>   CC      kernel/irq/proc.o
> In file included from kernel/irq/proc.c:9:
> include/linux/irq.h: In function 'init_alloc_desc_masks':
> include/linux/irq.h:444: error: implicit declaration of function 'cpu_to_node'
> include/linux/irq.h:446: error: 'GFP_ATOMIC' undeclared (first use in this function)
> include/linux/irq.h:446: error: (Each undeclared identifier is reported only once
> include/linux/irq.h:446: error: for each function it appears in.)

