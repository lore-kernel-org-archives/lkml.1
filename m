Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYJ0Ii1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYJ0Ii1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYJ0IiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:38:20 -0400
Received: from sh.osrg.net ([192.16.179.4]:53603 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbYJ0IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:38:19 -0400
Date: Mon, 27 Oct 2008 17:37:47 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mingo@elte.hu,
       jens.axboe@oracle.com
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
 BIOVEC_PHYS_MERGEABLE
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <49057A15.7030007@goop.org>
References: <4902371A.5050303@goop.org>
	<20081027125139I.fujita.tomonori@lab.ntt.co.jp>
	<49057A15.7030007@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081027173739Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 19:21:41 +1100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > The block layer always done the physical merge if possible. We don't
> > provide any kernel parameter to disable it.
> >
> > The iommu_bio_merge parameter had been used to enable the virtual
> > merge. As I wrote, the virtual merge feature was completely
> > removed. Effectively, the iommu_bio_merge parameter is meaningless
> > now.
> >   
> 
> Under Xen, pages which appear to be pseudo-physically adjacent are not 
> necessarily really physically adjacent.  We need to hook 
> BIOVEC_PHYS_MERGEABLE to prevent the bio layer from inappropriately 
> merging requests across non-contiguous page boundaries.

I'm not familiar with what Xen does but why can't Xen just override
BIOVEC_PHYS_MERGEABLE?

Why does Xen need to hook BIOVEC_PHYS_MERGEABLE to the iommu_bio_merge
parameter (as this patch does)? BIOVEC_PHYS_MERGEABLE and the
iommu_bio_merge parameter are not related at all.
