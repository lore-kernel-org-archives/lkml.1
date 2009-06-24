Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZFXBs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZFXBs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFXBsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:48:21 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:58045 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbZFXBsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=PH9MTCn2rWs/XYDley+URZZpiQS4EZyqWRB2SBDuUyiYcJbSMm8O/1Y3dNI0dAmZTv
         sYF7wYLNSjCgfvpcp8kr3KfkIS6yUxZmZ7dl5iMHQfHE5zKBEkCb+7bJbERYTaXf/8Bi
         izrpKHxx+jcvN1j6IOTi74mvVMozMm1eLsFEI=
MIME-Version: 1.0
In-Reply-To: <20090623154022.61e83c33.akpm@linux-foundation.org>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org> 
	<20090623154022.61e83c33.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 23 Jun 2009 21:48:03 -0400
Message-ID: <8bd0f97a0906231848u61d07a3j803f51cb26b72dab@mail.gmail.com>
Subject: Re: [PATCH 1/4] asm/sections: add text/data checking functions for 
	arches to override
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, rgetz@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 18:40, Andrew Morton wrote:
> On Wed, 17 Jun 2009 12:22:21 -0400 Mike Frysinger wrote:
>> Some ports (like the Blackfin arch) have a discontiguous memory map which
>> means there may be text or data that falls outside of the standard range
>> of the start/end text/data symbols.  Creating some helper functions allows
>> these non-standard ports to declare these regions without adversely
>> affecting anyone else.
>
> The patches look OK to me.
>
> I assumed they're for 2.6.32.

it's for whatever is easiest to merge

>> index 4ce48e8..ee19462 100644
>> --- a/include/asm-generic/sections.h
>> +++ b/include/asm-generic/sections.h
>> @@ -20,4 +20,20 @@ extern char __start_rodata[], __end_rodata[];
>>  #define dereference_function_descriptor(p) (p)
>>  #endif
>>
>> +/* random extra sections (if any).  Override
>> + * in asm/sections.h */
>> +#ifndef arch_is_kernel_text
>> +static inline int arch_is_kernel_text(unsigned long addr)
>> +{
>> +     return 0;
>> +}
>> +#endif
>> +
>> +#ifndef arch_is_kernel_data
>> +static inline int arch_is_kernel_data(unsigned long addr)
>> +{
>> +     return 0;
>> +}
>> +#endif
>
> I suppose that for completeness and consistency etc really we should have
>
> #define arch_is_kernel_text arch_is_kernel_text
> #define arch_is_kernel_data arch_is_kernel_data
>
> in here.

*shrug* other places that use this style dont include these defines
for completeness as the define muck is for the header to know about
(arches providing their own version), not any source code -- they
shouldnt know anything about the ifdef stuff.  i dont care much either
way.
-mike
