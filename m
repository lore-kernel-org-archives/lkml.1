Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYEOHp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYEOHp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 03:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbYEOHpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 03:45:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:52527 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbYEOHpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 03:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y8FMvFldignYZ0G2mdPgntVqPMtiFL7HQQFVVqQ0J7B/FiYuNargb5daXrPgU3QpPcToO21975tbvYEbNJsjPUEJUq1zbK0OvaHVwFY30oN2goPtVifWgWRHXcS+GaK8FEAYRO8GEEvyK2gM+f1GkpNobWWE2p7oHaP0qN0qTNc=
Message-ID: <7e0dd21a0805150045p573825ceqdcdbff42aca30c04@mail.gmail.com>
Date: Thu, 15 May 2008 09:45:08 +0200
From: "Johann Baudy" <johaahn@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: UIO: phys_mem_access_prot() miss?
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080513185137.GA3342@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7e0dd21a0805130655xd8b1c8ap9a329943e25fe6fb@mail.gmail.com>
	 <20080513185137.GA3342@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many thanks Hans,

Sorry for late reply. I'm currently using linux-2.6.24-rc8-xlnx (git.xilinx.com)
I will try to rebase and let you know.

Best regards,
Johann

On Tue, May 13, 2008 at 8:51 PM, Hans J. Koch <hjk@linutronix.de> wrote:
> On Tue, May 13, 2008 at 03:55:29PM +0200, Johann Baudy wrote:
>> Hi Hans, Greg,
>>
>> I need some help on UIO driver.
>> I have to add this below workaround (in uio.c) to be able to access
>> phys memory from user space.
>> I'm currently using PPC arch.
>> Am I wrong? or Is it a miss?
>>
>> static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
>> {
>>
>> ...
>>       switch (idev->info->mem[mi].memtype) {
>>               case UIO_MEM_PHYS:
>> +             vma->vm_page_prot = phys_mem_access_prot(filep,
>> +            idev->info->mem[mi].addr >> PAGE_SHIFT,
>> +                                              vma->vm_end - vma->vm_start,
>> +                                              vma->vm_page_prot);
>>                       return uio_mmap_physical(vma);
>>               case UIO_MEM_LOGICAL:
>> ...
>>
>> }
>>
>> FYI: I've copied those lines from mem char driver in mmap_mem().
>
> Hi Johann,
> what kernel are you using? Similar problems were reported before, and
> we've already applied a patch that should fix it. I think it hit
> mainline shortly before the 2.6.25 release. uio_mmap() should work with
> kernels >= 2.6.25 for PPC.
>
> Thanks,
> Hans
>
>



-- 
Johann Baudy
johaahn@gmail.com
