Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYGOCmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYGOCmZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbYGOCmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:42:14 -0400
Received: from sh.osrg.net ([192.16.179.4]:44252 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbYGOCmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:42:13 -0400
Date: Tue, 15 Jul 2008 11:40:46 +0900
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, andi@firstfloor.org,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0807141720350.30981@devserv.devel.redhat.com>
References: <20080713.202035.172246136.davem@davemloft.net>
	<20080715024424R.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807141720350.30981@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080715114058A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 17:26:38 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Tue, 15 Jul 2008, FUJITA Tomonori wrote:
> 
> > On Sun, 13 Jul 2008 20:20:35 -0700 (PDT)
> > David Miller <davem@davemloft.net> wrote:
> >
> >> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> >> Date: Mon, 14 Jul 2008 11:19:02 +0900
> >>
> >>> Now IOMMUs don't ignore the max_segment_size. We hit this problem.
> >>
> >> It seems simply that max_segment_size needs to propagate
> >> down into the block layer VMERGE code so that it can
> >> act accordingly.
> >
> > Yeah, I think so. I'll take care of that.
> >
> > But I think that even with the fix, SPARC64 IOMMU still hits the
> > problem.
> >
> > With the VMERGE accounting enabled,
> >
> > - an IOMMU must merge segments that the block layer expects the IOMMU
> > to merge.
> >
> > - an IOMMU must return an error if it can't merge such segments.
> >
> > But the current SPARC64 IOMMU code doesn't return an error if it can't
> > merge such segments (as POWER's IOMMU does, as you know).
> 
> BTW. what should the block device driver do when it receives a mapping 
> error? (if it aborts the request and it was write request, there will be 
> data corruption).

I'm not sure how a aborted request can corrupt data on disk.


> Is it even legal to return IOMMU error in case where no 
> real hardware error or overflow happened?

Of course, it's legal. It's a common event like kinda OOM. It's very
possible with old IOMMUs that have the small I/O space. A SCSI driver
retries a failed request later. But note that some drivers are still
not able to handle that.

http://marc.info/?l=linux-kernel&m=121300637114672&w=2
