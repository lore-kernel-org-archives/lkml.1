Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbYFPIw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbYFPIw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYFPIwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:52:18 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:22072 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYFPIwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=U7ARMOHr0xSBfOTrGKaM0idsGm8z3hF85hYZooLFuECilpdsB7eMWmo97fcze9f46P
         aq5kFJppCv+GNsOdcl+8r3hoUX5R6tRPKJD1Of89/h8ByKitq0l2zuzY6sjW+AKCa5qn
         tDAqKCDIjnP0EZvEUfDrlKav9COHAX2t6YG5M=
Message-ID: <a8e1da0806160152j202dba59y214f23993b5c8bbf@mail.gmail.com>
Date: Mon, 16 Jun 2008 16:52:16 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <a8e1da0806160108x3de46eafp545275eb9dfd4f98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
	 <20080616080131.GC25632@elte.hu>
	 <a8e1da0806160108x3de46eafp545275eb9dfd4f98@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 4:08 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Mon, Jun 16, 2008 at 4:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> * Dave Young <hidave.darkstar@gmail.com> wrote:
>>
>>> booting kernel with vmalloc=[any size<=16m] will oops.
>>>
>>> It's due to the vm area hole.
>>>
>>> In include/asm-x86/pgtable_32.h:
>>> #define VMALLOC_OFFSET        (8 * 1024 * 1024)
>>> #define VMALLOC_START (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
>>>                        & ~(VMALLOC_OFFSET - 1))
>>>
>>> BUG_ON in arch/x86/mm/init_32.c will be triggered:
>>> BUG_ON((unsigned long)high_memory             > VMALLOC_START);
>>>
>>> Fixed by return -EINVAL for invalid parameter
>>
>> hm. Why dont we instead add the size of the hole to the
>> __VMALLOC_RESERVE value instead? There's nothing inherently bad about
>> using vmalloc=16m. The VM area hole is really a kernel-internal
>> abstraction that should not be visible in the usage of the parameter.

I built with:
__VMALLOC_RESERVE = memparse(arg, &arg) + 2 * VMALLOC_OFFSET;

But it doesn't work, still oops at ie. vmalloc=4M (BUT vmalloc=8M is ok)
I can't figure out what's wrong with it.

Regards
dave
