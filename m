Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbZHYGgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbZHYGgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 02:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZHYGgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 02:36:37 -0400
Received: from mail-yw0-f183.google.com ([209.85.211.183]:38245 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbZHYGgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 02:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qpmrJngTW0a9IziqJ3phE74xHsF8B7OiG/v/ort0wrqSwQZEqOEzyHtRn/pYptgu9q
         BoyBiSy3AqpM8L8YZ7EId9ljjXQeQ1vcFQMEs3XWvWi2S27GQcfZx+M4b3zkYQh6CmIa
         Z9Zuo5AcBWtunQGZ2lv/4Y2cxvp6dasjSdrCQ=
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 02:36:38 -0400
Message-ID: <689eb3470908242336o6681b516uc21d07979099d8c8@mail.gmail.com>
Subject: All pages belonging to a process
From: Anupama Chandwani <anupama.chandwani@gmail.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I need to have a debug print for all pages belonging to a process, for
which i have the following code:

if (task->mm && task->mm->mmap)
{
      /* For all vma-s of a process */
      for (vma = task->mm->mmap; vma!=NULL; vma = vma->next)
      {
               pgd = pgd_offset(mm, address);
               if (!pgd_present(*pgd))
                    continue;

               pud = pud_offset(pgd, address);
               if (!pud_present(*pud))
                    continue;

               pmd = pmd_offset(pud, address);
               if (!pmd_present(*pmd))
                    continue;

              pte = pte_offset_map_lock (task->mm->vm_mm, pmd, address, &ptl);

              print pte_pfn(*pte) and other debug info;

              pte_unmap_unlock(pte, ptl);
      }
}

The code hangs. I do not get anything in dmesg.
Any pointers by observing the code?

--
Cheers,
Anupama Chandwani
