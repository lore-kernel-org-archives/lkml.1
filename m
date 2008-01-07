Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYAGWQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYAGWQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYAGWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:16:15 -0500
Received: from gw.goop.org ([64.81.55.164]:55538 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483AbYAGWQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:16:14 -0500
Message-ID: <4782A420.30807@goop.org>
Date: Mon, 07 Jan 2008 14:13:52 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 1 of 8] x86: page.h: unify constants
References: <patchbomb.1199391057@localhost> <ba0ec40a50a7aef1a315.1199391058@localhost> <20080107171712.GE2998@bingen.suse.de>
In-Reply-To: <20080107171712.GE2998@bingen.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +
>> +#define LARGE_PAGE_SIZE		(_AC(1,UL) << PMD_SHIFT)
>> +#define LARGE_PAGE_MASK		(~(LARGE_PAGE_SIZE-1))
>> +
>> +#define HPAGE_SHIFT		PMD_SHIFT
>> +#define HPAGE_SIZE		(_AC(1,UL) << HPAGE_SHIFT)
>> +#define HPAGE_MASK		(~(HPAGE_SIZE - 1))
>> +#define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
>>     
>
> This will actually stop being the same soon with GB pages which
> are only supported on 64bit.
>   

I was wondering about that.  Will you always use GB pages, or will there 
be two classes of huge pages, or will it be a runtime/compiletime config?

>> +
>> +#ifdef CONFIG_X86_64
>> +#define THREAD_ORDER	1
>> +#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
>> +#define CURRENT_MASK (~(THREAD_SIZE-1))
>> +
>> +#define EXCEPTION_STACK_ORDER 0
>> +#define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
>> +
>> +#define DEBUG_STACK_ORDER (EXCEPTION_STACK_ORDER + 1)
>> +#define DEBUG_STKSZ (PAGE_SIZE << DEBUG_STACK_ORDER)
>> +
>> +#define IRQSTACK_ORDER 2
>> +#define IRQSTACKSIZE (PAGE_SIZE << IRQSTACK_ORDER)
>>     
>
> This all seems hardly 64bit specific (except for THREAD_ORDER
> but you can probably handle that in Kconfig or just get rid
> of it for 32bit)
>   

They're only used by 64-bit at the moment, aren't they?  Or are you 
suggesting 32-bit could use them too?  There's no corresponding 
definitions on the 32-bit side at the moment.

>> +#define __PHYSICAL_START	CONFIG_PHYSICAL_START
>>     
>
> Also not 64bit specific
>   

It's use is 64-bit specific though, isn't it?

>> +#ifdef CONFIG_X86_PAE
>> +#define __PHYSICAL_MASK_SHIFT	36
>>     
>
> I originally added the PHYSICAL_MASK stuff to deal with masking off NX,
> but I must admit it wasn't the best idea I ever had. It would be probably
> better to just get rid of it and always mask off the high reserved flags bit
> explicitely. If you make that 0 then there should be no special
> case for PAE.
>   

Hm, OK.  I thought different 64-bit implementations might have different 
sized physical address spaces or something.


    J
