Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYESNZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYESNZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760259AbYESNSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:44 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:10547
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759066AbYESNSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:39 -0400
Message-ID: <48317E2B.2030304@qumranet.com>
Date: Mon, 19 May 2008 16:18:35 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080519130151.GE13546@elte.hu>
In-Reply-To: <20080519130151.GE13546@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>   
>> +/*
>> + * Define LIST_POISON[12] as pointers that cannot be dereferenced.
>> + */
>> +#ifdef CONFIG_X86_84
>> +#  undef LIST_POISON1
>> +#  undef LIST_POISON2
>> +#  define LIST_POISON1 ((void *)0x8001000100010001L)
>> +#  define LIST_POISON2 ((void *)0x8002000200020002L)
>> +#endif
>>     
>
> i'd suggest to add an ARCH_ILLEGAL_POINTER define instead, which 
> defaults to zero and gets added to pointer-ish poison values. That makes 
> it both simpler and also it does not need any include/asm changes 
> because ARCH_ILLEGAL_POINTER can be set from the Kconfig space.
>   

Right.

How much unmapped space do we have on i386 or other archs?  The deltas 
added to ARCH_ILLEGAL_POINTER will have to be limited to that.

Maybe have ARCH_ILLEGAL_POINTER_BASE and ARCH_ILLEGAL_POINTER_RANGE, 
defaulting to 0 and (say) 4MB, and use the range to mask the deltas to 
avoid overflows into legal pointer range.

-- 
error compiling committee.c: too many arguments to function

