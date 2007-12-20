Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbXLTNVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbXLTNVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbXLTNVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:21:39 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46838 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbXLTNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:21:38 -0500
Date: Thu, 20 Dec 2007 13:14:30 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Dave Hansen <haveblue@us.ibm.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
In-Reply-To: <1198084473.15321.48.camel@localhost>
Message-ID: <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
 <1198084473.15321.48.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Dave Hansen wrote:
> > --- linux-2.6.24-rc5/mm/page_alloc.c~memory-controller-move-to-bug-on-in-free_hot_cold_page     2007-12-19 11:31:46.000000000 +0530
> > +++ linux-2.6.24-rc5-balbir/mm/page_alloc.c     2007-12-19 11:33:45.000000000 +0530
> > @@ -995,7 +995,7 @@ static void fastcall free_hot_cold_page(
> >  
> >         if (!PageHighMem(page))
> >                 debug_check_no_locks_freed(page_address(page), PAGE_SIZE);
> > -       page_assign_page_cgroup(page, NULL);
> > +       VM_BUG_ON(page_get_page_cgroup(page));
> >         arch_free_page(page, 0);
> >         kernel_map_pages(page, 1, 0); 
> 
> Hi Balbir,
> 
> You generally want to do these like:
> 
> 	foo = page_assign_page_cgroup(page, NULL);
> 	VM_BUG_ON(foo);
> 
> Some embedded people have been known to optimize kernel size like this:
> 
> 	#define VM_BUG_ON(x) do{}while(0)

Balbir's patch looks fine to me: I don't get your point there, Dave.

Hugh
