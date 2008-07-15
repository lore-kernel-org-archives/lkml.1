Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbYGOPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbYGOPce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYGOPbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:31:37 -0400
Received: from sh.osrg.net ([192.16.179.4]:53701 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYGOPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:31:35 -0400
Date: Wed, 16 Jul 2008 00:30:43 +0900
To: mpatocka@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       davem@davemloft.net, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807150924250.21598@devserv.devel.redhat.com>
	<20080715231956A.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807151033040.25390@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080716003047P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 10:37:58 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> >>> This bug could happen on alpha, parisc, and sparc, which use VMERGE.
> >>
> >> Parisc doesn't use virtual merge accounting (there is variable for it but
> >> it's always 0).
> >
> > Hmm, really? Looks like PARISC IOMMUs (ccio-dma.c and sba_iomm.c) set
> > parisc_vmerge_boundary (CC'ed PARISC mailing list).
> 
> That's right, I looked only at arch and include.
> 
> >> On sparc64 it is broken anyway with or without your patch.
> >
> > Yeah, we need to modify SPARC64 IOMMU code (I'm not sure that it's
> > worth). Right now, the best fix is setting BIO_VMERGE_BOUNDARY to 0.
> 
> Even if we fix it now, the question is: how long it will stay fixed? Until 
> someone makes another change to struct device that restricts boundaries on 
> some wacky hardware.

I'm not sure how the boundary restriction of a device can break
the VMERGE accounting.
