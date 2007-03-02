Return-Path: <linux-kernel-owner+w=401wt.eu-S1422784AbXCBFJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422784AbXCBFJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422801AbXCBFJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:09:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42529 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422784AbXCBFJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:09:51 -0500
Date: Thu, 1 Mar 2007 21:09:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: support@coraid.com, "Ed L. Cashin" <ecashin@coraid.com>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-Id: <20070301210942.ebf40993.akpm@linux-foundation.org>
In-Reply-To: <20070302050351.GA24705@infradead.org>
References: <20070301231510.GC8524@coraid.com>
	<20070301174204.a550dd3a.akpm@linux-foundation.org>
	<20070302022919.GA26285@infradead.org>
	<20070301192245.bf034385.akpm@linux-foundation.org>
	<20070302043039.GA18651@infradead.org>
	<20070301204806.61225e2b.akpm@linux-foundation.org>
	<20070302044910.GA22209@infradead.org>
	<20070301210044.d95bcd70.akpm@linux-foundation.org>
	<20070302050351.GA24705@infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 05:03:51 +0000 Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 01, 2007 at 09:00:44PM -0800, Andrew Morton wrote:
> > I that case we're talking about different things.
> > 
> > I thought the proposal was to continue to use slab pages, but to take a ref
> > on them as they're added to the bio, drop that ref in bi_end_io()?
> 
> That would give you silent memory corruption in case the networking code
> hold a reference after the memory gets returned to slab and reused.

Well, given that bi_end_io() is called after the "io" has completed, I'm
assuming that networking has completely finished with the memory by the
time bi_end_io() gets called.

I guess one can envisage situations where that might not happen, but they'd
be terribly buggy ones, surely.

> We need to either stop allowing to pass slab memory to the block layer,
> or document that drivers need to handle it specially and give them a
> way to find out about them. (Or do the horrible slab refcounting hack
> I wrote up above)

OK.  So you're proposing that XFS and ext3 simply stop sing slab for this
memory?

