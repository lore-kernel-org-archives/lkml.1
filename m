Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYFPIJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYFPIJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYFPIJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:09:03 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:19469 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbYFPIJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=r047X8z3/uU07BimSQQ1//H7P4JwYn67ElyT3S2+d1sXLn1w5dZ4HqxNv3PENPw9q/
         7wUkWvYQm5BlIQ4YY5/e8kJDAeRmmL+hloYyjRVRMsCfBSNglCC0TeRYGA3Txbm1QYUG
         loKRMVSNr2/3Seg/ta/tLgCiC+P7ryN4YpvXM=
Message-ID: <a8e1da0806160108x3de46eafp545275eb9dfd4f98@mail.gmail.com>
Date: Mon, 16 Jun 2008 16:08:59 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel parameter vmalloc size fix
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <20080616080131.GC25632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
	 <20080616080131.GC25632@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2008 at 4:01 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> booting kernel with vmalloc=[any size<=16m] will oops.
>>
>> It's due to the vm area hole.
>>
>> In include/asm-x86/pgtable_32.h:
>> #define VMALLOC_OFFSET        (8 * 1024 * 1024)
>> #define VMALLOC_START (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
>>                        & ~(VMALLOC_OFFSET - 1))
>>
>> BUG_ON in arch/x86/mm/init_32.c will be triggered:
>> BUG_ON((unsigned long)high_memory             > VMALLOC_START);
>>
>> Fixed by return -EINVAL for invalid parameter
>
> hm. Why dont we instead add the size of the hole to the
> __VMALLOC_RESERVE value instead? There's nothing inherently bad about
> using vmalloc=16m. The VM area hole is really a kernel-internal
> abstraction that should not be visible in the usage of the parameter.

Good suggestion, thanks. I will rewrite the patch and send.

-- 
Regards
dave
