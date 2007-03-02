Return-Path: <linux-kernel-owner+w=401wt.eu-S1161178AbXCBFAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161178AbXCBFAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964863AbXCBFAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:00:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42069 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964800AbXCBFAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:00:53 -0500
Date: Thu, 1 Mar 2007 21:00:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: support@coraid.com, "Ed L. Cashin" <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-Id: <20070301210044.d95bcd70.akpm@linux-foundation.org>
In-Reply-To: <20070302044910.GA22209@infradead.org>
References: <20070301231510.GC8524@coraid.com>
	<20070301174204.a550dd3a.akpm@linux-foundation.org>
	<20070302022919.GA26285@infradead.org>
	<20070301192245.bf034385.akpm@linux-foundation.org>
	<20070302043039.GA18651@infradead.org>
	<20070301204806.61225e2b.akpm@linux-foundation.org>
	<20070302044910.GA22209@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 04:49:10 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 01, 2007 at 08:48:06PM -0800, Andrew Morton wrote:
> > On Fri, 2 Mar 2007 04:30:39 +0000 Christoph Hellwig <hch@infradead.org> wrote:
> > 
> > > But in this case we'd really need to enforce this, and add a
> > > BUG_ON(PageSlab(page)) in bio_add_page to trip everyone submit
> > > this kind of pages.
> > 
> > That would be
> > 
> > 	BUG_ON(PageSlab(page) && page_count(page) == 0)?
> 
> No, all slab pages.  Currently they all have a reference count of
> zero, but we generally don't want people to pass in pages that
> come from a non-refcounted allocator.

I that case we're talking about different things.

I thought the proposal was to continue to use slab pages, but to take a ref
on them as they're added to the bio, drop that ref in bi_end_io()?

