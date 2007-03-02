Return-Path: <linux-kernel-owner+w=401wt.eu-S1422664AbXCBAtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422664AbXCBAtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422661AbXCBAtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:49:50 -0500
Received: from gw.goop.org ([64.81.55.164]:50530 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422666AbXCBAtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:49:49 -0500
Message-ID: <45E774AB.5090103@goop.org>
Date: Thu, 01 Mar 2007 16:49:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include
 return register
References: <20070301232443.195603797@goop.org> <20070301232527.755495278@goop.org> <45E7738D.5090607@vmware.com>
In-Reply-To: <45E7738D.5090607@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Jeremy Fitzhardinge wrote:
>> Fix a few clobbers to include the return register.  The clobbers set
>> is the set of all registers modified (or may be modified) by the code
>> snippet, regardless of whether it was deliberate or accidental.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Zachary Amsden <zach@vmware.com>
>>
>> ---
>>  include/asm-i386/paravirt.h |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> ===================================================================
>> --- a/include/asm-i386/paravirt.h
>> +++ b/include/asm-i386/paravirt.h
>> @@ -556,7 +556,7 @@ static inline unsigned long __raw_local_
>>                         "popl %%edx; popl %%ecx")
>>                   : "=a"(f): "m"(paravirt_ops.save_fl),
>>                     paravirt_type(PARAVIRT_PATCH(save_fl)),
>> -                   paravirt_clobber(CLBR_NONE)
>> +                   paravirt_clobber(CLBR_EAX)
>>                   : "memory", "cc");
>>      return f;
>>   
>
> Has this been tested on older gcc's?  I seem to recall them barfing
> over things like this.

Things like what?  Do you mean the %[foo] asm parameter syntax?  I think
those versions are no longer supported - Arjan posted a patch a few days
ago to convert a pile of asms to this form.  Or do you mean something else?

    J
