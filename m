Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbYDDTfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbYDDTfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 15:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbYDDTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 15:34:55 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:18069 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbYDDTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 15:34:54 -0400
X-IronPort-AV: E=Sophos;i="4.25,605,1199692800"; 
   d="scan'208";a="10254538"
From: Roland Dreier <rdreier@cisco.com>
To: Richard Frank <richard.frank@oracle.com>
Cc: tziporet@dev.mellanox.co.il, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what's in infiniband.git)
References: <adave31bayd.fsf@cisco.com> <47F37CA4.8000109@mellanox.co.il>
	<adahcek2pru.fsf@cisco.com> <47F68EDC.4050107@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 04 Apr 2008 12:34:52 -0700
In-Reply-To: <47F68EDC.4050107@oracle.com> (Richard Frank's message of "Fri,
	04 Apr 2008 15:26:04 -0500")
Message-ID: <adaiqyxs9b7.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Apr 2008 19:34:53.0262 (UTC) FILETIME=[F48D66E0:01C8968A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We are very interested in these new operations and are moving in the
 > direction of tightly integrating RDMA along with atomics (if
 > available) into Oracle.  We plan on testing some early prototypes of
 > the these in the few months.

And you need the ConnectX-only masked atomics?  Or do the standard IB
atomic operations work for you?  Of course using atomics at all means
that things don't work on iWARP.

 > Send with invalidate is an exact match for our current RDS V3 rdma
 > driver - and should be more efficient than the current background
 > syncing of the tpt  to ensure keys are invalidated.

How does send with invalidate interact with the current IB FMR stuff?
Seems that you would run into trouble keeping the state of the FMR
straight if the remote side is invalidating them.

Also I would think that send-with-invalidate would be much more
expensive than the current FMR method of batching up the invalidates,
since you don't get to amortize the cost of syncing up all the internal
HCA state.

 - R.
