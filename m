Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbXJVQmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbXJVQmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbXJVQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:42:30 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:48459 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXJVQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:42:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ERGnV2532ECLmzoJl3ZW3qutbMj2XduzaqTbIvnRJ6LvFkvdhzXjew5HMJgPAcQ/SNpX1gY6c0IALk2AjpDdT7HH3acy93TsdXGrGUmMdsYqgkXBBW2XDb0R3Ld3/oEygKi3NGPejBjsvk+CKITHEdJbqCuJY8FSkBUHlC27B30=
Message-ID: <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>
Date: Mon, 22 Oct 2007 09:42:28 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH] return hidden bug
Cc: "Roel Kluin" <12o3l@tiscali.nl>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071021214209.1a7567d7@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <471BF741.2020501@tiscali.nl>
	 <20071021214209.1a7567d7@bree.surriel.com>
X-Google-Sender-Auth: a4ce78dca50d7403
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/07, Rik van Riel <riel@redhat.com> wrote:
> On Mon, 22 Oct 2007 03:05:05 +0200
> Roel Kluin <12o3l@tiscali.nl> wrote:
>
> >     return hidden bug
> >
> >     Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> >
> > diff --git a/arch/alpha/kernel/pci_iommu.c
> > b/arch/alpha/kernel/pci_iommu.c index e1c4707..6a69425 100644
> > --- a/arch/alpha/kernel/pci_iommu.c
> > +++ b/arch/alpha/kernel/pci_iommu.c
> > @@ -365,8 +365,8 @@ pci_unmap_single(struct pci_dev *pdev, dma_addr_t
> > dma_addr, size_t size, printk(KERN_ERR "Bogus pci_unmap_single:
> > dma_addr %lx " " base %lx size %x\n", dma_addr, arena->dma_base,
> >                      arena->size);
> > -             return;
> >               BUG();
> > +             return;
> >       }
> >
> >       npages = calc_npages((dma_addr & ~PAGE_MASK) + size);
>
> BUG() will terminate the process that runs into it, so you can
> just remove the return alltogether.  If BUG() is hit, the return
> will never be reached.

I'm sorry, perhaps I poured myself a cup of stupid this morning, but
isn't the above patch effectively introducing a BUG where none could
be reached before? In other words, for the patch to have zero
behavioral change, wouldn't it have to remove the BUG() altogether?

Ray
