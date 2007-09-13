Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbXIMSUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbXIMSUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXIMSUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:20:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:17568 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557AbXIMSUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,250,1186383600"; 
   d="scan'208";a="294281153"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Roland Dreier'" <rdreier@cisco.com>, <general@lists.openfabrics.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <adahclymos8.fsf@cisco.com>
Subject: RE: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
Date: Thu, 13 Sep 2007 11:20:38 -0700
Message-ID: <000401c7f632$c993e8e0$65cc180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <adahclymos8.fsf@cisco.com>
thread-index: Acf2L5ydZpn69raETVeIRmzEFqRNJgAAVztw
X-OriginalArrivalTime: 13 Sep 2007 18:20:40.0065 (UTC) FILETIME=[C9F87710:01C7F632]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> - My user_mad P_Key index support patch.  I'll test the ioctl to
>   change to the new mode and merge this I guess, since Hal and Sean
>   have tested this out.

I can give this patch a reviewed-by: too, and I will also try to review a couple
of the pending ipoib patches.

> - Sean's QoS changes.  These look fine at first glance, and I just
>   plan to understand the backwards compatibility story (ie how this
>   works with an old SM) and merge.  Anyone who objects let me know.

The new QoS fields fall into fields that are currently reserved, which should be
ignored by an older SM.  I've only tested this against openSM however.

> - Sean's IB CM MRA interface changes.  Don't know at this point.  It
>   seems OK but I'm not clear on what if any real-world improvement
>   this gives us.

This patch was generated in response to an Intel MPI issue.  We've seen MPI take
several minutes to respond to a connection request during the middle of large
application runs.  When this happens, the active side times out the connection.
In OFED, we added module parameters to adjust the rdma_cm connection timeout on
the active side, but I believe that sending an MRA from the passive side is a
better solution.

- Sean
