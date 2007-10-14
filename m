Return-Path: <linux-kernel-owner+w=401wt.eu-S1763538AbXJNXMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763538AbXJNXMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXJNXMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:12:22 -0400
Received: from gw.goop.org ([64.81.55.164]:36652 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbXJNXMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:12:22 -0400
Message-ID: <4712A254.4090604@goop.org>
Date: Sun, 14 Oct 2007 16:12:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_?= =?ISO-8859-1?Q?B=F8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com, nickpiggin@yahoo.com.au
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>
In-Reply-To: <20071014225618.GN23367404@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> You mean xfs_buf.c.
>   

Yes, sorry.

> And yes, we delay unmapping pages until we have a batch of them
> to unmap. vmap and vunmap do not scale, so this is batching helps
> alleviate some of the worst of the problems.
>   

How much performance does it cost?  What kind of workloads would it show
up under?

> Realistically, if this delayed release of vmaps is a problem for
> Xen, then I think that some generic VM solution is needed to this
> problem as vmap() is likely to become more common in future (think
> large blocks in filesystems). Nick - any comments?
>   

Well, the only real problem is that the pages are returned to the free
pool and reallocated while still being part of a mapping.  If the pages
are still owned by the filesystem/pagecache, then there's no problem.

What's the lifetime of things being vmapped/unmapped in xfs?  Are they
necessarily being freed when they're unmapped, or could unmapping of
freed memory be more immediate than other memory?

Maybe it just needs a notifier chain or something.

    J
