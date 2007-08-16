Return-Path: <linux-kernel-owner+w=401wt.eu-S938178AbXHPD1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938178AbXHPD1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762426AbXHPD1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:27:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:6874 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761422AbXHPD12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:27:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,268,1183359600"; 
   d="scan'208";a="279547729"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Jeff Garzik'" <jeff@garzik.org>,
       "Steve Wise" <swise@opengridcomputing.com>
Cc: <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>,
       "David Miller" <davem@davemloft.net>
References: <46B883B5.8040702@opengridcomputing.com>	<46BB61D0.4090101@opengridcomputing.com>	<46BB89C0.4040303@ichips.intel.com><20070809.145534.102938208.davem@davemloft.net><46C310E1.7020503@opengridcomputing.com> <46C3B5EF.5060409@garzik.org>
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCP portsfrom the host TCP port space.
Date: Wed, 15 Aug 2007 20:27:26 -0700
Message-ID: <000001c7dfb5$5e6ced20$4dc8180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcffrPRzuhsWT/IeTHC+AIFxpDs3GAAArhiA
In-Reply-To: <46C3B5EF.5060409@garzik.org>
X-OriginalArrivalTime: 16 Aug 2007 03:27:26.0969 (UTC) FILETIME=[5E6DFE90:01C7DFB5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>It's not about being a niche.  It's about creating a maintainable
>software net stack that has predictable behavior.
>
>Needing to reach out of the RDMA sandbox and reserve net stack resources
>away from itself travels a path we've consistently avoided.

We need to ensure that we're also creating a maintainable kernel.  RDMA doesn't
use sockets, but that doesn't mean it's not part of the networking support
provided by the Linux kernel.  Making blanket statements that RDMA should stay
within a sandbox is equivalent to saying that RDMA should duplicate any network
related functionality that it might need.

>>> I will NACK any patch that opens up sockets to eat up ports or
>>> anything stupid like that.
>
>Ditto for me as well.

I agree that using a socket is the wrong approach, but my guess is that it was
suggested as a possibility because of the attempt to keep RDMA in its 'sandbox'.
The iWarp architecture implements RDMA over TCP; it just doesn't use sockets.
The Linux network stack doesn't easily support this possibility.  Are there any
reasonable ways to enable this to the degree necessary for iWarp?

- Sean
