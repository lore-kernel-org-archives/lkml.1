Return-Path: <linux-kernel-owner+w=401wt.eu-S1422892AbXCBEsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422892AbXCBEsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422891AbXCBEsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:48:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41717 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422893AbXCBEsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:48:16 -0500
Date: Thu, 1 Mar 2007 20:48:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: support@coraid.com, "Ed L. Cashin" <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-Id: <20070301204806.61225e2b.akpm@linux-foundation.org>
In-Reply-To: <20070302043039.GA18651@infradead.org>
References: <20070301231510.GC8524@coraid.com>
	<20070301174204.a550dd3a.akpm@linux-foundation.org>
	<20070302022919.GA26285@infradead.org>
	<20070301192245.bf034385.akpm@linux-foundation.org>
	<20070302043039.GA18651@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 04:30:39 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> But in this case we'd really need to enforce this, and add a
> BUG_ON(PageSlab(page)) in bio_add_page to trip everyone submit
> this kind of pages.

That would be

	BUG_ON(PageSlab(page) && page_count(page) == 0)?


> > So we have a few options to look at:
> > 
> > a) kludge things in AOE.  Unpleasing, and might cause memory leaks
> >    (although it won't, because the caller hasn't run bi_end_io yet).
> > 
> > b) Take a ref on slab pages in slab.  A bit costly, perhaps.
> > 
> > c) teach ext3 and XFS to take a ref on these pages as they are added to
> >    the BIOs, undo that ref in bi_end_io.
> > 
> > I think c)?
> 
> Yes.  I'm perfectly fine with this as long as we document and enforce
> this.

And write the patch ;)
