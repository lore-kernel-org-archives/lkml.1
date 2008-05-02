Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbYEBBtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbYEBBtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbYEBBtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:49:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:56210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbYEBBtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:49:00 -0400
Date: Fri, 2 May 2008 03:48:59 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] SLQB v2
Message-ID: <20080502014858.GB11844@wotan.suse.de>
References: <20080410193137.GB9482@wotan.suse.de> <20080415034407.GA9120@ubuntu> <20080501015418.GC15179@wotan.suse.de> <Pine.LNX.4.64.0805011226410.8738@schroedinger.engr.sgi.com> <20080502004325.GA30768@wotan.suse.de> <Pine.LNX.4.64.0805011813180.13527@schroedinger.engr.sgi.com> <20080502012321.GE30768@wotan.suse.de> <Pine.LNX.4.64.0805011825420.13697@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805011825420.13697@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 06:28:57PM -0700, Christoph Lameter wrote:
> On Fri, 2 May 2008, Nick Piggin wrote:
> 
> > But overloading struct page values happens in other places too. Putting
> > everything into struct page is not scalable. We could also make kmalloc
> 
> Well lets at least attempt to catch the biggest users.

You want to also put slab and slob in there? What about page allocator?
It is ridiculous for the sake of "being easy to inspect with debuggers".
How hard is (struct slub_page *) to type?

Here is a real benefit you get with clearly defined types for struct
page: type checking.


> Also makes code 
> clearer if you f.e. use page->first_page instead of page->private for 
> compound pages.

compound_page_head() is fine too.

 
> kmalloc is intended to return an arbitrary type. struct page has a defined 
> format that needs to be respected.

So does kmalloc if you take the union of all types it might possibly
be used as.
