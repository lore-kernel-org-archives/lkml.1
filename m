Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbYJDRoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbYJDRoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYJDRoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:44:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:9516 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbYJDRoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:44:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=feelLmMx3BB7bs17q6VNgQ//L26R3u5bbZXItMW6Egka8yJiBOMT8/q3CNd5FcGqlf
         8I6qe4RNyqXy+7at5FKRjjcj8Pm/fk5vJbBrJpAC07iaGkg98M+S4bRhnvu2pJzSJAD3
         aEcCI3hSV9++SAR4fonGQFsU1hJlu36DRoZyw=
Message-ID: <86802c440810041044m5b950721s8700bb6cd2fe75d@mail.gmail.com>
Date: Sat, 4 Oct 2008 10:44:00 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH] x86: make 64bit efi to use ioremap_cache for efi_ioremap
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Huang Ying" <ying.huang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223101400-8819-1-git-send-email-yhlu.kernel@gmail.com>
	 <851fc09e0810040235g2ab97bdai612c0a2829f83f5c@mail.gmail.com>
X-Google-Sender-Auth: 7846761b89c59302
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 2:35 AM, huang ying <huang.ying.caritas@gmail.com> wrote:
> Hi, Yinghai,
>
> On Sat, Oct 4, 2008 at 2:23 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> [...]
>> --- linux-2.6.orig/arch/x86/kernel/efi.c
>> +++ linux-2.6/arch/x86/kernel/efi.c
>> @@ -475,10 +475,7 @@ void __init efi_enter_virtual_mode(void)
>>                size = md->num_pages << EFI_PAGE_SHIFT;
>>                end = md->phys_addr + size;
>>
>> -               if (PFN_UP(end) <= max_low_pfn_mapped)
>> -                       va = __va(md->phys_addr);
>> -               else
>> -                       va = efi_ioremap(md->phys_addr, size);
>> +               va = efi_ioremap(md->phys_addr, size);
>
> Using __va and efi_ioremap() here is to make EFI support compatible
> with kexec. Because EFI provide only efi_enter_virtual_mode(), no
> efi_leave_virtual_mode(), we should make EFI runtime memory area
> mapped to same virtual memory area in original kernel and kexeced
> kernel, so that the EFI runtime services can be used in kexeced
> kernel.

so need to make efi range all under direct-mapping like E820-RAM?

if so we need to update
e820_end_of_low_ram_pfn to return correct max_low_pfn, and then
max_low_pfn_mapped...

YH
