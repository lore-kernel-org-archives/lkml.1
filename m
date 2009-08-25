Return-Path: <linux-kernel-owner+w=401wt.eu-S1750834AbZHYMo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbZHYMo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 08:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZHYMo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 08:44:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:44138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZHYMoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 08:44:25 -0400
Date: Tue, 25 Aug 2009 14:44:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Anupama Chandwani <anupama.chandwani@gmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: All pages belonging to a process
In-Reply-To: <689eb3470908242336o6681b516uc21d07979099d8c8@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0908251443230.11692@twin.jikos.cz>
References: <689eb3470908242336o6681b516uc21d07979099d8c8@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-829977352-1251204267=:11692"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-829977352-1251204267=:11692
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Aug 2009, Anupama Chandwani wrote:

>       /* For all vma-s of a process */
>       for (vma = task->mm->mmap; vma!=NULL; vma = vma->next)

you mean vma->vm_next?

>       {
>                pgd = pgd_offset(mm, address);
>                if (!pgd_present(*pgd))
>                     continue;
> 
>                pud = pud_offset(pgd, address);
>                if (!pud_present(*pud))
>                     continue;
> 
>                pmd = pmd_offset(pud, address);
>                if (!pmd_present(*pmd))
>                     continue;
> 
>               pte = pte_offset_map_lock (task->mm->vm_mm, pmd, address, &ptl);
> 
>               print pte_pfn(*pte) and other debug info;
> 
>               pte_unmap_unlock(pte, ptl);
>       }
> }
> 
> The code hangs. I do not get anything in dmesg.

Do you have mmap_sem locked?

-- 
Jiri Kosina
SUSE Labs

---1747641777-829977352-1251204267=:11692--
