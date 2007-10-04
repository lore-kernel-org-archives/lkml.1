Return-Path: <linux-kernel-owner+w=401wt.eu-S1761827AbXJDXdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761827AbXJDXdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJDXcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:32:55 -0400
Received: from waste.org ([66.93.16.53]:50104 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXJDXcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:32:54 -0400
Date: Thu, 4 Oct 2007 12:05:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: sata_sil24 broken since 2.6.23-rc4-mm1
Message-ID: <20071004170536.GY19691@waste.org>
References: <64bb37e0709292300t39028029n2375899d7ba1e8ce@mail.gmail.com> <46FFB412.20202@gmail.com> <64bb37e0709300919w3e9db6aci4c0b9df43407fff3@mail.gmail.com> <46FFDF64.1080005@gmail.com> <64bb37e0709301139h456a82d6u98630a4d1503eaf@mail.gmail.com> <64bb37e0710011100t2cd81a32g501435b98f783ba9@mail.gmail.com> <64bb37e0710030821u56157ad1s6252ee01e050c7d5@mail.gmail.com> <64bb37e0710030855t360f2216mb4c38cfab6d88f37@mail.gmail.com> <20071003163804.GR19691@waste.org> <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0710032232o71225bf6k8a0d493687eb80bd@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 07:32:52AM +0200, Torsten Kaiser wrote:
> On 10/3/07, Matt Mackall <mpm@selenic.com> wrote:
> > Well I can see no reason why the vma we just got to by the mm->mmap
> > would have a vm_mm != mm, but I've certainly been wrong before.
> >
> > Try changing it to:
> >
> >         for (vma = mm->mmap; vma; vma = vma->vm_next)
> >                 if (!is_vm_hugetlb_page(vma)) {
> >                         if (vma->vm_mm != mm)
> >                                 printk("WTF: vma->vm_mm %p mm %p\n",
> >                                         vma->vm_mm, mm);
> >                         walk_page_range(vma->vm_mm, vma->vm_start, vma->vm_end,
> >                                         &clear_refs_walk, vma);
> >         }
> 
> You were right.
> I was able to trigger the error with above printk added, but nothing
> was written to the syslog.
> 
> So now I'm rather out of ideas what to test... :(

I'd give your previous bisect step another try.

Looking back at the thread a bit, anything that requires the machine
to be off for more than a couple seconds to manifest stops looking
like software and firmware and starts looking like a heat-related
electrical or mechanical issue. Make sure your backups are current.

-- 
Mathematics is the supreme nostalgia of our time.
