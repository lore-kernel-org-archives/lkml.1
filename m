Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbXI1VfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbXI1VfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 17:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbXI1VfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 17:35:01 -0400
Received: from mga06.intel.com ([134.134.136.21]:57694 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567AbXI1VfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 17:35:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,211,1188802800"; 
   d="scan'208";a="235255200"
Message-ID: <46FD7380.6050107@ichips.intel.com>
Date: Fri, 28 Sep 2007 14:34:56 -0700
From: Sean Hefty <mshefty@ichips.intel.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: "Kanevsky, Arkady" <Arkady.Kanevsky@netapp.com>
CC: Steve Wise <swise@opengridcomputing.com>,
       Sean Hefty <sean.hefty@intel.com>, netdev@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH v3] iw_cxgb3: Support"iwarp-only"interfacesto
 avoid 4-tuple conflicts.
References: <20070923203649.8324.64524.stgit@dell3.ogc.int><46FBF8AF.9040700@ichips.intel.com><C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com> <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com> <C98692FD98048C41885E0B0FACD9DFB80518755A@exnane01.hq.netapp.com> <46FD5A2F.7010409@opengridcomputing.com> <C98692FD98048C41885E0B0FACD9DFB805187762@exnane01.hq.netapp.com>
In-Reply-To: <C98692FD98048C41885E0B0FACD9DFB805187762@exnane01.hq.netapp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kanevsky, Arkady wrote:
> Exactly,
> it forces the burden on administrator.
> And one will be forced to try one mount for iWARP and it does not
> work issue another one TCP or UDP if it fails.
> Yack!
> 
> And server will need to listen on different IP address and simple
> * will not work since it will need to listen in two different domains.

The server already has to call listen twice.  Once for the rdma_cm and 
once for sockets.  Similarly on the client side, connect must be made 
over rdma_cm or sockets.  I really don't see any impact on the 
application for this approach.

We just end up separating the port space based on networking addresses, 
rather than keeping the problem at the transport level.  If you have an 
alternate approach that will be accepted upstream, feel free to post it.

- Sean
