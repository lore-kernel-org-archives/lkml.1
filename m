Return-Path: <linux-kernel-owner+w=401wt.eu-S971086AbXFHU4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971086AbXFHU4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968436AbXFHU4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:56:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968484AbXFHU4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:56:11 -0400
Date: Fri, 8 Jun 2007 13:55:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Kleen <ak@suse.de>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 02/10] Library routine for pre-allocat pool
 handling
Message-Id: <20070608135555.e580ada3.akpm@linux-foundation.org>
In-Reply-To: <6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.510643000@askeshav-devel.jf.intel.com>
	<20070607162726.2236a296.akpm@linux-foundation.org>
	<20070608182156.GA24865@linux-os.sc.intel.com>
	<20070608120107.245eba96.akpm@linux-foundation.org>
	<6901450.1181335390183.SLOX.WebMail.wwwrun@imap-dhs.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 22:43:10 +0200 (CEST)
Andreas Kleen <ak@suse.de> wrote:

> > That's what kmem_cache_alloc() is for?!?!
> 
> Tradtionally that was not allowed in block layer path. Not sure
> it is fully obsolete with the recent dirty tracking work, probably not.
> 
> Besides it would need to be GFP_ATOMIC and the default
> atomic pools are not that big.

That in itself is a problem.  What do we have to do to be able
to make these allocations use the *much* stronger GFP_NOIO?

We could perhaps talk to Christoph about arranging for each slabcache to
have an optional private reserve page pool.  But fixing the GFP_ATOMIC
would be better.
