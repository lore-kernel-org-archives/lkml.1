Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbXIRHFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbXIRHFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 03:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbXIRHFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 03:05:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:62468 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbXIRHFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 03:05:22 -0400
From: Jack Morgenstein <jackm@dev.mellanox.co.il>
Organization: Mellanox
To: general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
Date: Tue, 18 Sep 2007 09:09:49 +0200
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, tziporet@mellanox.co.il
References: <adahclymos8.fsf@cisco.com>
In-Reply-To: <adahclymos8.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709180909.50029.jackm@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 20:57, Roland Dreier wrote:
> HW specific:
> 
>  - I already merged patches to enable MSI-X by default for mthca and
>    mlx4.  I hope there aren't too many systems that get hosed if a
>    MSI-X interrupt is generated.
> 
>  - Jack and Michael's mlx4 FMR support.  Will merge I guess, although
>    I do hope to have time to address the DMA API abuse that is being
>    copied from mthca, so that mlx4 and mthca work in Xen domU.
> 
>  - ehca patch queue.  Will merge, pending fixes for the few minor
>    issues I commented on.
> 
>  - Steve's mthca router mode support.  Would be nice to see a review
>    from someone at Mellanox.
> 
>  - Arthur's mthca doorbell alignment fixes.  I will experiment with a
>    few different approaches and post what I like (and fix mlx4 as
>    well).  I hope Arthur can review.
> 
>  - Michael's mlx4 WQE shrinking patch.  Not sure yet; I'll reply to
>    the latest patch directly.
> 
Missing from this list (IMPORTANT patch!):
[ofa-general] [PATCH 2 of 2] IB/mlx4: Handle new FW requirement for send request prefetching, for WQE sg lists
(Posted by me to list on Sept 4)
{patch header: 
This is an addendum to Roland's commit 0e6e74162164d908edf7889ac66dca09e7505745
(June 18). This addendum adds prefetch headroom marking processing for s/g segments.

We write s/g segments in reverse order into the WQE, in order to guarantee
that the first dword of all cachelines containing s/g segments is written last
(overwriting the headroom invalidation pattern). The entire cacheline will thus
contain valid data when the invalidation pattern is overwritten.
}
This patch series (1 of 2 is for libmlx4, the same issue).
============================================================

Also, I'm now posting (in a separate post) the following patch to mlx4, which is important:
  display the following device information via sysfs:
  board_id, fw_ver, hw_rev, hca_type.

  The info is displayed under directory /sys/class/infiniband/mlx4_x, where x is
  the pci bus sequence number (starting from zero).

  This patch makes information available to ibstat and ibv_devinfo under the
  same directory as is used for tavor/arbel/sinai -- thus requiring no userspace
  modifications.

- Jack


