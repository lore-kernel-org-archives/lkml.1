Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXIUTFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXIUTFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758265AbXIUTFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:05:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44393 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbXIUTFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:05:00 -0400
Date: Fri, 21 Sep 2007 12:05:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Sep 2007, Linus Torvalds wrote:
> 
> On Fri, 21 Sep 2007, Christoph Lameter wrote:
> > 
> > The quicklists collect pages while we gather pages for TLB flushing. 
> > These pages must be kept until the actual TLB flush has occurred. The 
> > optimization of releasing off node pages early is therefore not valid.
> 
> That should be the "mmu_gather" structure, not the quicklists.

Oh, and I see what's wrong: you not only switched "free_page()" to 
"quicklist_free()", you *also* switched "tlb_remove_page()" to 
"quicklist_free()".

Ok, that commit is totally and utterly broken. Will revert.

		Linus
