Return-Path: <linux-kernel-owner+w=401wt.eu-S2992655AbXDTIm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992655AbXDTIm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992648AbXDTIm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:42:26 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38240 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992642AbXDTImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:42:23 -0400
Date: Fri, 20 Apr 2007 18:42:06 +1000
From: David Chinner <dgc@sgi.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420084206.GO32602149@melbourne.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070420044718.GV2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420044718.GV2986@holomorphy.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:47:18PM -0700, William Lee Irwin III wrote:
> On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> > This patchset modifies the core VM so that higher order page cache pages
> > become possible. The higher order page cache pages are compound pages
> > and can be handled in the same way as regular pages.
> > The order of the pages is determined by the order set up in the mapping
> > (struct address_space). By default the order is set to zero.
> > This means that higher order pages are optional. There is no attempt here
> > to generally change the page order of the page cache. 4K pages are effective
> > for small files.
> 
> Oh dear. Per-file pagesizes are foul. Better to fix up the pagecache's
> radix tree than to restrict it like this.

How is this restrictive? This opens up much goodness to filesystems.
I *want* to be able to use different radix tree index orders for
different inodes in a single filesystem. Not just for data, either;
XFS has metadata constructs larger than a page that mean we have to
carry our own buffer cache around.  Being able to use the page cache
directly for these metadata constructs would enable us to remove a
good chunk of code from XFS....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
