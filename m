Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYEMSvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYEMSvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbYEMSvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:51:46 -0400
Received: from www.tglx.de ([62.245.132.106]:44489 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYEMSvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:51:45 -0400
Date: Tue, 13 May 2008 20:51:38 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Johann Baudy <johaahn@gmail.com>
Cc: hjk@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: UIO: phys_mem_access_prot() miss?
Message-ID: <20080513185137.GA3342@local>
References: <7e0dd21a0805130655xd8b1c8ap9a329943e25fe6fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e0dd21a0805130655xd8b1c8ap9a329943e25fe6fb@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:55:29PM +0200, Johann Baudy wrote:
> Hi Hans, Greg,
> 
> I need some help on UIO driver.
> I have to add this below workaround (in uio.c) to be able to access
> phys memory from user space.
> I'm currently using PPC arch.
> Am I wrong? or Is it a miss?
> 
> static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
> {
> 
> ...
> 	switch (idev->info->mem[mi].memtype) {
> 		case UIO_MEM_PHYS:
> +       	vma->vm_page_prot = phys_mem_access_prot(filep,
> +            idev->info->mem[mi].addr >> PAGE_SHIFT,
> +						 vma->vm_end - vma->vm_start,
> +						 vma->vm_page_prot);
> 			return uio_mmap_physical(vma);
> 		case UIO_MEM_LOGICAL:
> ...
> 
> }
> 
> FYI: I've copied those lines from mem char driver in mmap_mem().

Hi Johann,
what kernel are you using? Similar problems were reported before, and
we've already applied a patch that should fix it. I think it hit
mainline shortly before the 2.6.25 release. uio_mmap() should work with
kernels >= 2.6.25 for PPC.

Thanks,
Hans

