Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYLWHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYLWHy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 02:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYLWHys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 02:54:48 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:44347 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbYLWHyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 02:54:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sqe7C5eRVTLg3V8C+CrbfqvTn2IO8qkfI7Y3e1OgvQpjRgwlYWMPAA1OvnJ9R666ex
         lsmX47bLU/NcD2u73PfLsvnyQNsIpWhNK17qUiAYIBC/3HyLziD8N8J0zxQUMslZ54st
         F1JtDq8Kj4VMl1MFZDyTuzyQeDDc7bG9906a8=
Message-ID: <3b5e77ad0812222354y5d4effe8xc6750d6620e20c75@mail.gmail.com>
Date: Tue, 23 Dec 2008 09:54:44 +0200
From: "Ron Livne" <ronli.voltaire@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.29
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
In-Reply-To: <aday6y7x2yr.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aday6y7x2yr.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

Any chance create_qp_flags will get in?

Thanks,
Ron


On Tue, Dec 23, 2008 at 12:25 AM, Roland Dreier <rdreier@cisco.com> wrote:
> I guess now is probably a good time to send out my plans for the
> 2.6.29 cycle.  I'm not operating at full speed (since I'm kind of on
> paternity leave and kind of on holiday break), but I'll try to get
> through as much of my backlog as possible.
>
> I should mention that I've changed the way I manage my git tree
> slightly.  I've started using "topic" branches to organize the patches
> I have queued; so for example I'll put IPoIB changes in my "ipoib"
> branch and ehca changes in my "ehca" branch.  Then I merge everything
> that I consider ready for the next merge window into my "for-next"
> branch (which is included as part of Stephen Rothwell's linux-next
> tree).  Any topics that I'm not sure are ready get to stay on their
> own branch until they are ready (or get dropped); for example, I've
> had an "xrc" branch for XRC work for a while now.
>
> Anyway, here are all the pending things that I'm aware of.  As usual,
> if something isn't already in my tree and isn't listed below, I
> probably missed it or dropped it by mistake.  Please remind me again
> in that case.
>
> As usual, when submitting a patch:
>
>  - Give a good changelog that explains what issue your patch
>   addresses, how you address the issue, how serious the issue is, and
>   any other information that would be useful to someone evaluating
>   your patch or reading it years from now.
>
>  - Please make sure that you include a "Signed-off-by:" line, and put
>   any extra junk that should not go into the final kernel log *after*
>   the "---" line so that git tools strip it off automatically.  Make
>   the subject line be appropriate for inclusion in the kernel log as
>   well once the leading "[PATCH ...]" stuff is stripped off.  I waste a
>   lot of time fixing patches by hand that could otherwise be spent
>   doing something productive like watching youtube.
>
>  - Run your patch through checkpatch.pl so I don't have to nag you to
>   fix trivial issues (or spend time fixing them myself).
>
>  - Read your patch over so I don't see a memory leak or deadlock as
>   soon as I look at it.
>
>  - Build your patch with sparse checking ("C=2 CF=-D__CHECK_ENDIAN__")
>   and make sure it doesn't introduce new warnings.  (A big bonus in
>   goodwill for sending patches that fix old warnings)
>
>  - Test your patch on a kernel with things like slab debugging and
>   lockdep turned on.
>
> And while you're waiting for me to get to your patch, I sure wouldn't
> mind if you read and commented on someone else's patch.  None of this
> means you shouldn't remind me about pending patches, since I often
> lose track of things and drop them accidentally.
>
> Core:
>
>  - Multiple CQ event vector support.  I don't see much progress on
>   making this actually usable or useful, but maybe the best way to
>   make progress on getting the correct interface for applications to
>   actually figure out which vector to use is to merge the multiple
>   vector support for some low-level drivers.  I have the mlx4 changes
>   merged, and I plan to try and do some analogous changes for mthca.
>   A resurrection of the ehca multiple vector support would be welcome
>   as well.
>
>  - I plan to merge Aleksey's patches for RDMA CM IPv6 support when I
>   have a version that applies to the current kernel.  Might be a good
>   idea for cxgb3 and nes guys to look at this and make sure that we
>   at least don't have any kernel crashes caused if someone tries to
>   make an IPv6 connection.
>
> ULPs:
>
>  - I sincerely appreciate everyone who resent IPoIB patches recently.
>   I will review them and apply this week most likely.
>
> HW specific:
>
>  - A bunch of ipath fixes.
>
>  - A bunch of nes cleanups and fixes.
>
>  - A few ehca fixes and cleanups.
>
> Here are a few topics that I believe will not be ready in time for the
> 2.6.29 window and will need to wait for 2.6.30 at least:
>
>  - Jack's XRC patch set.  I think we're getting closer to converging
>   here, but I still want to get a clean solution for the "free XRC
>   domain with other objects still associated because multiple
>   contexts share XRCDs" problem.
>
> Here all the patches I already have in my for-next branch:
>
> Chien Tung (2):
>      RDMA/nes: Add loopback check to make_cm_node()
>      RDMA/nes: Cleanup warnings
>
> Dave Olson (4):
>      IB/ipath: Don't count IB symbol and link errors unless link is UP
>      IB/ipath: Only do 1X workaround on rev1 chips
>      IB/ipath: Fix spi_pioindex value
>      IB/ipath: Add locking for interrupt use of ipath_pd contexts vs free
>
> David Disseldorp (1):
>      IB/iser: Avoid recv buffer exhaustion caused by unexpected PDUs
>
> Faisal Latif (6):
>      RDMA/nes: Cleanup cqp_request list usage
>      RDMA/nes: Lock down connected_nodes list while processing it
>      RDMA/nes: Avoid race between MPA request and reset event to rdma_cm
>      RDMA/nes: Forward packets for a new connection with stale APBVT entry
>      RDMA/nes: Fix TCP compliance test failures
>      RDMA/nes: Check cqp_avail_reqs is empty after locking the list
>
> Joachim Fenkes (1):
>      IB/ehca: Fix locking for shca_list_lock
>
> Julia Lawall (1):
>      IB/ehca: Remove redundant test of vpage
>
> Michael Ellerman (1):
>      IB/ipath: Fix pointer-to-pointer thinko in ipath_fs.c
>
> Ralph Campbell (3):
>      IB/ipath: Improve UD loopback performance by allocating temp array only once
>      IB/ipath: Fix PSN of send WQEs after an RDMA read resend
>      IB/ipath: Check return value of dma_map_single()
>
> Roland Dreier (1):
>      mlx4_core: Delete incorrect comment
>
> Stefan Roscher (1):
>      IB/ehca: Replace modulus operations in flush error completion path
>
> Yevgeny Petrilin (1):
>      mlx4_core: Add support for multiple completion event vectors
>
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general
>
