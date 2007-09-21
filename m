Return-Path: <linux-kernel-owner+w=401wt.eu-S1761979AbXIUSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761979AbXIUSsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbXIUSsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:48:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374AbXIUSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:48:45 -0400
Date: Fri, 21 Sep 2007 11:48:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <20070921180742.GH20863@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Sep 2007, Siddha, Suresh B wrote:
>
> git commit 34feb2c83beb3bdf13535a36770f7e50b47ef299 started using quicklists
> for freeing page table pages and removed the usage of tlb_remove_page()
> 
> And looking at quicklist_free() and quicklist_free_page(), on a NUMA platform,
> this can potentially free the page before the corresponding TLB caches
> are flushed.

Hmm? We only add them to the quicklists in the exact same places where we 
*used* to just free them entirely. So I don't see why semantics would have 
changed..

> Can we revert this commit for 2.6.23 and look at this code post 2.6.23?

I'll happily revert it, but I want to understand this better, so more of 
an explanation of the codepath that actually does something wrong, please.

		Linus
