Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZBCB6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZBCB6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZBCB6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:58:05 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:31789 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZBCB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BOtVsZozdxrY8W1en6l7kkXwQu2BZxmn36XDanyVDixIgPw1S86Q9Lo6G3Kp1PRjsr
         eLzKtfbYVfAl9RXxMGjZmXd9aokOirwTUIMUUhn+W6h2iEZ1Tf9PUD2kWrptKxes4KYH
         1Mfd5yOnqNc+Bak+T+v92pxHXgI7E+gK0mX9c=
Date: Tue, 3 Feb 2009 10:57:44 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] fix mlocked page counter mismatch
Message-ID: <20090203015744.GA16179@barrios-desktop>
References: <20090202061622.GA13286@barrios-desktop> <1233594995.17895.144.camel@lts-notebook> <20090202232719.GC13532@barrios-desktop> <1233625686.17895.219.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233625686.17895.219.camel@lts-notebook>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Thank you for testing. 
> 
> I did test this on 29-rc3 on a 4 socket x dual core x86_64 platform and
> it seems to resolve the statistics miscount.  How do you want to
> proceed.  Do you want to repost with this version of patch?  Or shall I?

I will repost this patch with your ACK and tested-by if you allow it. 

> 
> Regards,
> Lee
> 
> > > 
> > > 
> > > Index: linux-2.6.29-rc3/mm/rmap.c
> > > ===================================================================
> > > --- linux-2.6.29-rc3.orig/mm/rmap.c	2009-01-30 14:13:56.000000000 -0500
> > > +++ linux-2.6.29-rc3/mm/rmap.c	2009-02-02 11:27:11.000000000 -0500
> > > @@ -1072,7 +1072,8 @@ static int try_to_unmap_file(struct page
> > >  	spin_lock(&mapping->i_mmap_lock);
> > >  	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
> > >  		if (MLOCK_PAGES && unlikely(unlock)) {
> > > -			if (!(vma->vm_flags & VM_LOCKED))
> > > +			if (!((vma->vm_flags & VM_LOCKED) &&
> > > +			      page_mapped_in_vma(page, vma)))
> > >  				continue;	/* must visit all vmas */
> > >  			ret = SWAP_MLOCK;
> > >  		} else {
> > > 
> > 

-- 
Kinds Regards
MinChan Kim

