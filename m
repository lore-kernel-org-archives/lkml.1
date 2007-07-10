Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXGJLBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXGJLBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758585AbXGJLBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:01:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48273 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756356AbXGJLBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:01:40 -0400
Date: Tue, 10 Jul 2007 20:01:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: mel@skynet.ie (Mel Gorman)
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       a.p.zijlstra@chello.nl, y-goto@jp.fujitsu.com, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans -- anti-fragmentation
Message-Id: <20070710200115.b5bbfb4a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070710102043.GA20303@skynet.ie>
References: <20070710102043.GA20303@skynet.ie>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 11:20:43 +0100
mel@skynet.ie (Mel Gorman) wrote:
> > memory-unplug-v7-migration-by-kernel.patch
> > memory-unplug-v7-isolate_lru_page-fix.patch
> > memory-unplug-v7-memory-hotplug-cleanup.patch
> > memory-unplug-v7-page-isolation.patch
> > memory-unplug-v7-page-offline.patch
> > memory-unplug-v7-ia64-interface.patch
> > 
> >  These are new, and are dependent on Mel's stuff.  Not for 2.6.23.
> > 
> 
> Specifically, they depend on grouping pages by mobility for the page
> isolation patch. Without grouping pages by mobility, that patch gets
> pretty messy. For the operation to succeed at all, it benefits from the
> ZONE_MOVABLE patches. Kamezawa is cc'd so he might comment further.
> 

In gerneal, there are 2 purpose for memory unplug.
(1) reduce amount of memory.
(2) plug some range of memory.

(1) is request from people who use some flexible environment, like virtual machine,
LPAR. (2) is request from people who want to remove physical DIMM deivces.

For (1), page movable type and page defragment works very well. Because memory unplug
interface allows removing a section of pages, we need to unplug the whole section.
By page grouping, pages are grouped into chunks and MOVABLE type chunk can be unplugged
very easily.

For (2), we need some method for specifing the range we will remove. For doing that,
ZONE seems to be good candidate.  Now we use "kernelcore=" boot option to create
ZONE_MOVABLE by hand. But this is the first step. I know Intel guy posted
his idea to specify Hotpluggable-Memory range in SRAT (by firmware). And I think that
other method may be introduced for node-hotplug. 

-Kame


-Kame




