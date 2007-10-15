Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbXJOIdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbXJOIdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXJOIc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:32:57 -0400
Received: from verein.lst.de ([213.95.11.210]:47885 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbXJOIc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:32:56 -0400
Date: Mon, 15 Oct 2007 10:31:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs-masters@oss.sgi.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, David Chinner <dgc@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten B?geskov <xen-users@morten.bogeskov.dk>
Subject: Re: [xfs-masters] Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071015083141.GA20851@lst.de>
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org> <200710151726.08387.nickpiggin@yahoo.com.au> <4712E1AA.501@goop.org> <20071015041133.GH995458@sgi.com> <4712EA09.6000102@goop.org> <20071015042546.GI995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015042546.GI995458@sgi.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 02:25:46PM +1000, David Chinner wrote:
> > Hm, well I saw the problem with a filesystem made with mkfs.xfs with no
> > options, so there must be at least *some* vmapping going on there.
> 
> Sorry - I should have been more precise - vmap should never be used in
> performance critical paths on default configs.  Log recovery will
> trigger vmap/vunmap usage, so this is probably what you are seeing.

The iclogs are also vmapped, but they aren't unmapped until unmount so
this optimizations doesn't matter either.

