Return-Path: <linux-kernel-owner+w=401wt.eu-S934162AbXCVSQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbXCVSQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934176AbXCVSQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:16:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162AbXCVSP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:15:59 -0400
Date: Thu, 22 Mar 2007 18:15:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Hellwig <hch@infradead.org>, Adam Litke <agl@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Ken Chen <kenchen@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: pagetable_ops: Hugetlb character device example
Message-ID: <20070322181537.GA8317@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mel Gorman <mel@skynet.ie>, Adam Litke <agl@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	William Lee Irwin III <wli@holomorphy.com>,
	Ken Chen <kenchen@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <1174506228.21684.41.camel@localhost.localdomain> <20070322103817.GA7348@infradead.org> <20070322154227.GA14366@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322154227.GA14366@skynet.ie>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:42:27PM +0000, Mel Gorman wrote:
> A year ago, I may have agreed with you. However, Linus not only veto'd it but
> stamped on it repeatadly at VM Summit. He couldn't have made it clearer if
> he wore a t-shirt a hat and held up a neon sign. The assertion at the time
> was that variable page support of any sort had to be outside of the core VM
> because automatic support will get it wrong in some cases and makes the core
> VM harder to understand (because it's super-clear at the moment). Others
> attending agreed with the position. That position rules out drivers or
> filesystems giving hints about superpage sizes in the foreseeable future.

Actually I think the only way to get it right is to do it in the core
(or inm the architecture code for the really nasty bits of course), but
then again this isn't the point I want to make here..

> What they did not have any problem with was providing better interfaces to
> program against as long as they were on the side of the VM like hugetlbfs
> and not in the core. The character device for private mappings is an
> example of an interface that is easier to program against than hugetlbfs.
> It's far easier for an application to mmap a file at a fixed location than
> trying to discover if hugetlbfs is mounted or not. However, to support that
> sort of interface, there needs to be a way of telling the VM to call the an
> alternative pagetable handler - hence Adam's patches.

.. and this is where we get into problems.  There should be no need to
use all kinds of pseudo-OO obsfucation to get there.  A VMA flag that
means 'this is hugetlb backed anonymous memory' is much nicer to archive
this.  Because it makes clear there is exactly one special case here
and no carte blanche for drivers to do whatever they want.  I would prefer
to even get rid of that single special case as mentioned above, but I'm
definitly set dead against at making this special case totally open for
random bits of the kernel to mess with.

> Someone with sufficient energy could try implementing variable page support
> entirely as a device using Adam's interface. 

Hopefully not, doing this in a driver would be utterly braindead and
certainly not mergeable.

