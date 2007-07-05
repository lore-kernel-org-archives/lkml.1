Return-Path: <linux-kernel-owner+w=401wt.eu-S1758135AbXGEDxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135AbXGEDxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 23:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXGEDxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 23:53:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53485 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbXGEDxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 23:53:10 -0400
Date: Thu, 5 Jul 2007 12:54:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "tony.luck@intel.com" <tony.luck@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Christoph Lameter <clameter@sgi.com>, Mike.stroya@hp.com,
       GOTO <y-goto@jp.fujitsu.com>, dmosberger@gmail.com, hugh@veritas.com
Subject: Re: [BUGFIX][PATCH] DO flush icache before set_pte() on ia64.
Message-Id: <20070705125427.9a3b8e8b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <468C634D.9050306@yahoo.com.au>
References: <20070704150504.423f6c54.kamezawa.hiroyu@jp.fujitsu.com>
	<468B3EAA.9070905@yahoo.com.au>
	<20070704163826.d0b7465b.kamezawa.hiroyu@jp.fujitsu.com>
	<468C51A7.3070505@yahoo.com.au>
	<20070705114726.2449f270.kamezawa.hiroyu@jp.fujitsu.com>
	<468C634D.9050306@yahoo.com.au>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2007 13:19:41 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> >> From what I can work out, it is something like "at this point the page
> >>should be uptodate, so at least the icache won't contain *inconsistent*
> >>data, just old data which userspace should take care of flushing if it
> >>modifies". Is that always true?
> > 
> >  
> > I think it's true. But, in this case, i-cache doesn't contain *incositent* data.
> > There are inconsistency between L2-Dcache and L3-mixed-cache. At L2-icache-miss,
> > a cpu fetches data from L3 cache.
> > This case seems defficult to be generalized...
> 
> If there is something in the icache line that isn't the last data to
> be stored at that address, isn't that inconsistent?
> 
Hmm..do we have a chance to add do_flush_cache_if_not_filled_by_dma(page)
before SetPageUptodate(page) ?

-Kame

