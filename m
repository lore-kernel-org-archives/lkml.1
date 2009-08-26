Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZHZUfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZHZUfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZHZUfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:35:14 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:55796 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZHZUfN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gz+rvmgdToEl/2A/btbuHFPiV7IwhWMg5M2DPJztbsBtZB7DDXQRXiNijptXHxi6KR
         8Lq3fhTGDHhFkTmOGnTWDt/hKODbETt3Nq0lY/bGqcvHKdyQ73IM/KZVVKyYR29/m0Bk
         NwXh3/y9/VV2znKuHqNXIbrFe0iP9KoqV3Jig=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0908251443230.11692@twin.jikos.cz>
References: <689eb3470908242336o6681b516uc21d07979099d8c8@mail.gmail.com>
	 <alpine.LRH.2.00.0908251443230.11692@twin.jikos.cz>
Date: Wed, 26 Aug 2009 13:28:05 -0700
Message-ID: <689eb3470908261328m51e00168x144cf4c7241051f3@mail.gmail.com>
Subject: Re: All pages belonging to a process
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

>>       /* For all vma-s of a process */
>>       for (vma = task->mm->mmap; vma!=NULL; vma = vma->next)
>
> you mean vma->vm_next?

Sorry for the typo, it is vma = vma->vm_next

>
>>       {
>>                pgd = pgd_offset(mm, address);
>>                if (!pgd_present(*pgd))
>>                     continue;
>>
>>                pud = pud_offset(pgd, address);
>>                if (!pud_present(*pud))
>>                     continue;
>>
>>                pmd = pmd_offset(pud, address);
>>                if (!pmd_present(*pmd))
>>                     continue;
>>
>>               pte = pte_offset_map_lock (task->mm->vm_mm, pmd, address, &ptl);
>>
>>               print pte_pfn(*pte) and other debug info;
>>
>>               pte_unmap_unlock(pte, ptl);
>>       }
>> }
>>
>> The code hangs. I do not get anything in dmesg.
>
> Do you have mmap_sem locked?

I didnt, but that didnt solve the problem.

>
> --
> Jiri Kosina
> SUSE Labs
>



-- 
Cheers,
Anupama Chandwani
