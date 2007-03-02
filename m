Return-Path: <linux-kernel-owner+w=401wt.eu-S964800AbXCBFEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964800AbXCBFEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 00:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964863AbXCBFD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 00:03:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964800AbXCBFD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 00:03:59 -0500
Date: Fri, 2 Mar 2007 05:03:51 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, support@coraid.com,
       "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: PATCH 2.6.21-rc1 aoe: handle zero _count pages in bios
Message-ID: <20070302050351.GA24705@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, support@coraid.com,
	"Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <20070301231510.GC8524@coraid.com> <20070301174204.a550dd3a.akpm@linux-foundation.org> <20070302022919.GA26285@infradead.org> <20070301192245.bf034385.akpm@linux-foundation.org> <20070302043039.GA18651@infradead.org> <20070301204806.61225e2b.akpm@linux-foundation.org> <20070302044910.GA22209@infradead.org> <20070301210044.d95bcd70.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301210044.d95bcd70.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 09:00:44PM -0800, Andrew Morton wrote:
> I that case we're talking about different things.
> 
> I thought the proposal was to continue to use slab pages, but to take a ref
> on them as they're added to the bio, drop that ref in bi_end_io()?

That would give you silent memory corruption in case the networking code
hold a reference after the memory gets returned to slab and reused.

We need to either stop allowing to pass slab memory to the block layer,
or document that drivers need to handle it specially and give them a
way to find out about them. (Or do the horrible slab refcounting hack
I wrote up above)

