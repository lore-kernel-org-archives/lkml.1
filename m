Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYIMKVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYIMKVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbYIMKVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:21:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52667 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbYIMKVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:21:30 -0400
Date: Sat, 13 Sep 2008 11:20:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Eric Miao <eric.miao@marvell.com>, linux-kernel@vger.kernel.org,
       Rodolfo Giometti <giometti@linux.it>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/2] pxafb: frame buffer overlay support for PXA27x.
Message-ID: <20080913102033.GB24437@flint.arm.linux.org.uk>
References: <1221034056-16587-1-git-send-email-giometti@enneenne.com> <1221034056-16587-2-git-send-email-giometti@enneenne.com> <20080913030540.48341eae.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913030540.48341eae.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 13, 2008 at 03:05:40AM -0700, Andrew Morton wrote:
> > +static int overlay1fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
> > +{
> > +	struct overlayfb_info *fbi = (struct overlayfb_info *) info;
> > +	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
> >
> > +	if (off < info->fix.smem_len) {
> > +		vma->vm_pgoff += fbi->video_offset / PAGE_SIZE;
> > +		return dma_mmap_writecombine(o1_to_basefb(fbi)->dev, vma,
> > +					     fbi->map_cpu, fbi->map_dma,
> > +					     fbi->map_size);
> > +	}
> > +	return -EINVAL;
> > +}
> 
> No need to set VM_IO or VM_RESERVED, etc?

That's covered by dma_mmap_writecombine -> remap_pfn_range:

        vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
