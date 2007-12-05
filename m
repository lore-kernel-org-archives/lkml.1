Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXLEXxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXLEXxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbXLEXw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:52:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLEXw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:52:57 -0500
Date: Thu, 6 Dec 2007 00:52:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: akpm@linux-foundation.org, krh@redhat.com,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/18] ieee1394: nopage
Message-ID: <20071205235256.GE5617@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.360419000@nick.local0.net> <4756A31C.5060405@s5r6.in-berlin.de> <4756A477.1020903@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756A477.1020903@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 02:15:35PM +0100, Stefan Richter wrote:
> > npiggin@suse.de wrote:
> >> @@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
> >>  	if (!dma->kvirt)
> >>  		return -EINVAL;
> >>  
> >> -	/* must be page-aligned */
> >> +	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
> >>  	if (vma->vm_pgoff != 0)
> >>  		return -EINVAL;
> >>  
> > 
> > Are you sure that the comment is wrong?  Could it be that there are
> > assumptions elsewhere which require page alignment?  (I should be able
> > to answer that, but I'm not.)
> 
> PS:  Assumed the comment is wrong, is the code wrong then too?

The mmap / fault code _seems_ OK. The check here is only wrong in that it
doesn't prevent non-page-aligned mappings (the core VM code already does).
