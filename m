Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXJDFdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXJDFdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXJDFcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:32:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:31499 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbXJDFcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kmCMYJgOtz+goZ5Cv9IgMjkfU/ToifR6gph8TV1BngZzPsqNnmmQBErS9JZBHtV2WgZ3rH+pkyfYJmf9rhD0IxACL4Dfv/aq6+MY72SWm1uLbp6oUnkKbQGWnY1+B5oU5lj+i+PSZtZCB01c6IQBB7+zXxJyQ6Qp4MogB5RUNuA=
Message-ID: <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
Date: Thu, 4 Oct 2007 07:32:52 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Matt Mackall" <mpm@selenic.com>
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Cc: "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20071003163804.GR19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46FC1104.8080105@gmail.com>
	 <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com>
	 <46FFB412.20202@gmail.com>
	 <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com>
	 <46FFDF64.1080005@gmail.com>
	 <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com>
	 <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com>
	 <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com>
	 <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com>
	 <20071003163804.GR19691@waste.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/3/07, Matt Mackall <mpm@selenic.com> wrote:
> Well I can see no reason why the vma we just got to by the mm->mmap
> would have a vm_mm != mm, but I've certainly been wrong before.
>
> Try changing it to:
>
>         for (vma = mm->mmap; vma; vma = vma->vm_next)
>                 if (!is_vm_hugetlb_page(vma)) {
>                         if (vma->vm_mm != mm)
>                                 printk("WTF: vma->vm_mm %p mm %p\n",
>                                         vma->vm_mm, mm);
>                         walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
>                                         &clear_refs_walk, vma);
>         }

You were right.
I was able to trigger the error with above printk added, but nothing
was written to the syslog.

So now I'm rather out of ideas what to test... :(

Torsten
