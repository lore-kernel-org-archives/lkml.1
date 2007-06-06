Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbXFFQ1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbXFFQ1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXFFQ0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:26:53 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:33375 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXFFQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:26:53 -0400
Date: Wed, 6 Jun 2007 17:26:49 +0100
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, aaw@google.com, a.p.zijlstra@chello.nl
Subject: Re: 2.6.22-rc4-mm1
Message-ID: <20070606162649.GA9932@skynet.ie>
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4666ABD4.8050402@fr.ibm.com> <4666D050.7010603@googlemail.com> <4666DA55.5090405@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4666DA55.5090405@fr.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/06/07 18:01), Cedric Le Goater didst pronounce:
> > Same problem here
> > 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/console.log
> > 
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/mm-config2
> > 
> > 
> > l *__page_check_anon_rmap+0x49
> > 0xc1075ee5 is in __page_check_anon_rmap (mm/rmap.c:557).
> > 552              * over the call to page_add_new_anon_rmap.
> > 553              */
> > 554             struct anon_vma *anon_vma = vma->anon_vma;
> > 555             anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
> > 556             BUG_ON(page->mapping != (struct address_space *)anon_vma);
> > 557             BUG_ON(page->index != linear_page_index(vma, address));
> > 558     #endif
> > 559     }
> > 560
> > 561     /**
> > 
> > I'll try to revert
> > mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> 
> yes, i gave it a try that but it seems that this patch is heavily 
> interlaced with others. I assume Nick has a better understanding 
> of the issue.
> 

I do not believe this is Nick's problem. I encountered the same issue and
the bisect ended up here;

# BISECT HERE
mm-variable-length-argument-support.patch
mm-variable-length-argument-support-fix.patch
# BISECT BAD

Reverting those two patches boots ok on my standalone x86 laptop. Patch authors
cc'd. I have not read the patches yet to see what might be the problem.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
