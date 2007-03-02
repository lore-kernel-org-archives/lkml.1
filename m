Return-Path: <linux-kernel-owner+w=401wt.eu-S1422894AbXCBEtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422894AbXCBEtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422893AbXCBEtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:49:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36167 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422894AbXCBEtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:49:15 -0500
Date: Fri, 2 Mar 2007 04:49:10 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, support@coraid.com,
       "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070302044910.GA22209@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, support@coraid.com,
	"Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <20070301231510.GC8524@coraid.com> <20070301174204.a550dd3a.akpm@linux-foundation.org> <20070302022919.GA26285@infradead.org> <20070301192245.bf034385.akpm@linux-foundation.org> <20070302043039.GA18651@infradead.org> <20070301204806.61225e2b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301204806.61225e2b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 08:48:06PM -0800, Andrew Morton wrote:
> On Fri, 2 Mar 2007 04:30:39 +0000 Christoph Hellwig <hch@infradead.org> wrote:
> 
> > But in this case we'd really need to enforce this, and add a
> > BUG_ON(PageSlab(page)) in bio_add_page to trip everyone submit
> > this kind of pages.
> 
> That would be
> 
> 	BUG_ON(PageSlab(page) && page_count(page) == 0)?

No, all slab pages.  Currently they all have a reference count of
zero, but we generally don't want people to pass in pages that
come from a non-refcounted allocator.

