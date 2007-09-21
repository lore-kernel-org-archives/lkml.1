Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbXIUTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbXIUTof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761952AbXIUTo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:44:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761825AbXIUTo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:44:27 -0400
Date: Fri, 21 Sep 2007 12:44:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709211241390.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211221560.17698@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211235220.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Sep 2007, Linus Torvalds wrote:
> 
> So for example, if you actually want to use quicklists in the "generic" 
> TLB-gather implementation, you should replace the
> 
> 	struct page *pages[FREE_PTE_NR];
> 
> entry in the "struct mmu_gather" with a set of quicklists instead. 

Side note: this would obviously require that the interfaces to the 
"quicklists" would have to be changed, and you'd have an actual head 
pointer rather than using explicitly numbered per-cpu variables, but that 
seems to be a good idea in itself.

Another option is to just not use quicklists AT ALL, but just have a 
simple list of pages that is purely internal to mmu_gather, and just teach 
pgd/pmd/pud_alloc about that list. That actually sounds like the most 
straightforward and least confusing approach. The quicklists code is 
pretty damn ugly in its mixing of "struct page" and the virtual address.

		Linus
