Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbXB0Swf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbXB0Swf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 13:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXB0Swf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 13:52:35 -0500
Received: from gw.goop.org ([64.81.55.164]:48982 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXB0Swe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 13:52:34 -0500
Message-ID: <45E47DEF.70405@goop.org>
Date: Tue, 27 Feb 2007 10:52:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/26] Xen-paravirt_ops: Add pagetable accessors to pack
 and unpack pagetable entries
References: <20070227081337.434798469@goop.org> <20070227081630.311681690@goop.org> <20070227100850.GA10827@elte.hu>
In-Reply-To: <20070227100850.GA10827@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> ===================================================================
>> --- a/arch/i386/kernel/vmlinux.lds.S
>> +++ b/arch/i386/kernel/vmlinux.lds.S
>> @@ -21,6 +21,9 @@
>>  #include <asm/page.h>
>>  #include <asm/cache.h>
>>  #include <asm/boot.h>
>> +
>> +#undef ENTRY
>> +#undef ALIGN
>>     
>
> hm, what's this? The reason is not documented.
>   
Good point; I'll add some comments.  The reason is that asm/linkage.h
ends up being included as a result of the other header file changes, and
it conflicts with the use of ENTRY and ALIGN here.  But its possible
that asm/linkage isn't needed anymore; that would be ideal if true.

>> +#ifdef CONFIG_PARAVIRT
>> +/* After pte_t, etc, have been defined */
>> +#include <asm/paravirt.h>
>> +#endif
>>     
>
> hm - there's already a CONFIG_PARAVIRT conditional in 
> asm-i386/paravirt.h.
>   

Yes, but it happens after asm/paravirt.h has already included some
things, and it ends up causing problems.  paravirt.h still defines
various stub functions in the !CONFIG_PARAVIRT case, so it needs to do
the includes either way.

    J
