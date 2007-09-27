Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbXI0TMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbXI0TMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbXI0TLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:11:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:41571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578AbXI0TLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:11:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="234335780"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Kanevsky, Arkady'" <Arkady.Kanevsky@netapp.com>,
       "Sean Hefty" <mshefty@ichips.intel.com>,
       "Steve Wise" <swise@opengridcomputing.com>
Cc: <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
References: <20070923203649.8324.64524.stgit@dell3.ogc.int><46FBF8AF.9040700@ichips.intel.com> <C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com>
Subject: RE: [ofa-general] [PATCH v3] iw_cxgb3: Support "iwarp-only"interfacesto avoid 4-tuple conflicts.
Date: Thu, 27 Sep 2007 12:11:49 -0700
Message-ID: <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com>
Thread-Index: AcgBNb39CdY9HAUtQUu124X5QXdNWQAAU3bQAABRR9A=
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-OriginalArrivalTime: 27 Sep 2007 19:11:50.0420 (UTC) FILETIME=[41D3F540:01C8013A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>What is the model on how client connects, say for iSCSI,
>when client and server both support, iWARP and 10GbE or 1GbE,
>and would like to setup "most" performant "connection" for ULP?

For the "most" performance connection, the ULP would use IB, and all these
problems go away.  :)

This proposal is for each iwarp interface to have its own IP address.  Clients
would need an iwarp usable address of the server and would connect using
rdma_connect().  If that call (or rdma_resolve_addr/route) fails, the client
could try connecting using sockets, aoi, or some other interface.  I don't see
that Steve's proposal changes anything from the client's perspective.

- Sean
