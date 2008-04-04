Return-Path: <linux-kernel-owner+w=401wt.eu-S1759145AbYDDT1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145AbYDDT1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYDDT1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:27:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63948 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYDDT1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:27:32 -0400
Message-ID: <47F68EDC.4050107@oracle.com>
Date: Fri, 04 Apr 2008 15:26:04 -0500
From: Richard Frank <richard.frank@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: tziporet@dev.mellanox.co.il, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's
 in infiniband.git)
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il> <adahcek2pru.fsf@cisco.com>
In-Reply-To: <adahcek2pru.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We want to add send with invalidate & mask compare and swap.
 > Eli will be able to send the patches next week and since they are
 > small I think they can be in for 2.6.26

We are very interested in these new operations and are moving in the 
direction of tightly integrating RDMA along with atomics (if available) 
into Oracle.  We plan on testing some early prototypes of the these in 
the few months.

Send with invalidate is an exact match for our current RDS V3 rdma 
driver - and should be more efficient than the current background 
syncing of the tpt  to ensure keys are invalidated.

We intend on exposing the atomics via the RDS driver along with simple 
low level rdma operations to Oracle's internal clients. If Oracle is 
running over a transport which exports atomics and rdma - Oracle will 
see a dramatic performance boost for several database operations.

Roland Dreier wrote:
>  > We want to add send with invalidate & mask compare and swap.
>  > Eli will be able to send the patches next week and since they are
>  > small I think they can be in for 2.6.26
>
> Send with invalidate should be OK.  Let's see about the masked atomics
> stuff -- we have a ton of new verbs and I think we might want to slow
> down and make sure it all makes sense.
>
>  > What about the split CQ for UD mode? It's improved the IPoIB
>  > performance for small messages significantly.
>
> Oh yeah... I'll try to get that in too.
>
>  > mlx4- we plan to send patches for the low level driver only to enable
>  > mlx4_en. These only affect our low level driver.
>
> No problem in principle, let's see the actual patches.
>
>  > I think we should try to push for XEC in 2.6.26 since there are
>  > already MPI implementation that use it and this ties them to use OFED
>  > only.
>  > Also this feature is stable and now being defined in IBTA
>  > Not taking it causing changes between OFED and the kernel and your
>  > libibverbs and we wish to avoid such gaps.
>  > Is there any thing we can do to help and make it into 2.6.26?
>
> I don't have a good feeling that the user-kernel interface is well
> thought out, so I want to consider XRC + ehca LL stuff + new iWARP verbs
> and make sure we have something that makes sense for the future.
>
>  - R.
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
>
> To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general
>   
