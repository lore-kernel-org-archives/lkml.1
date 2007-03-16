Return-Path: <linux-kernel-owner+w=401wt.eu-S965828AbXCPSm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbXCPSm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbXCPSm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:42:26 -0400
Received: from gw.goop.org ([64.81.55.164]:50441 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbXCPSmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:42:25 -0400
Message-ID: <45FAE50B.7030004@goop.org>
Date: Fri, 16 Mar 2007 11:42:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack
 and unpack pagetable entries
References: <20070301232443.195603797@goop.org> <20070301232526.502172500@goop.org> <20070316093844.GT23174@elte.hu>
In-Reply-To: <20070316093844.GT23174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +static inline pmd_t native_make_pmd(unsigned long long val)
>> +{
>> +	return (pmd_t) { val };
>> +}
>> +static inline pte_t native_make_pte(unsigned long long val)
>> +{
>> +	return (pte_t) { .pte_low = val, .pte_high = (val >> 32) } ;
>> +}
>>     
>
> missing newlines between inline functions.
>   

OK.

>> +#ifndef CONFIG_PARAVIRT
>> +#define pmd_val(x)	native_pmd_val(x)
>> +#define __pmd(x)	native_make_pmd(x)
>> +#endif	/* !CONFIG_PARAVIRT */
>>     
>
> no need for the closing !CONFIG_PARAVIRT comment: this define is 2 lines 
> long so it's not that hard to find the start of the block. We typically 
> do the /* !CONFIG_XX */ comment only for larger blocks, and when 
> multiple #endif's intermix.
>   

Yeah, I tend to put them there reflexively.  Its so easy for an #endif
to drift away over time, and suddenly you have no idea what's going on. 
I agree its overkill in this case.

>>  #define HPAGE_SHIFT	22
>>  #include <asm-generic/pgtable-nopmd.h>
>> -#endif
>> +#endif	/* CONFIG_X86_PAE */
>>     
>
> (for example here the #endif comment is justified.)
>   

Yeah, and it probably started life much closer to the #ifdef...

    J
