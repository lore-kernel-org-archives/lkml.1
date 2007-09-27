Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbXI0UUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbXI0UUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbXI0UU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:20:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:20284 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbXI0UUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:20:25 -0400
X-IronPort-AV: E=Sophos;i="4.21,204,1188802800"; 
   d="scan'208";a="108525658"
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] [PATCH v3] iw_cxgb3: Support"iwarp-only"interfacesto avoid 4-tuple conflicts.
Date: Thu, 27 Sep 2007 16:19:51 -0400
Message-ID: <C98692FD98048C41885E0B0FACD9DFB80518755A@exnane01.hq.netapp.com>
In-Reply-To: <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] [PATCH v3] iw_cxgb3: Support"iwarp-only"interfacesto avoid 4-tuple conflicts.
Thread-Index: AcgBNb39CdY9HAUtQUu124X5QXdNWQAAU3bQAABRR9AAAobD0A==
References: <20070923203649.8324.64524.stgit@dell3.ogc.int><46FBF8AF.9040700@ichips.intel.com><C98692FD98048C41885E0B0FACD9DFB805187514@exnane01.hq.netapp.com> <000101c8013a$41b374f0$a7cc180a@amr.corp.intel.com>
From: "Kanevsky, Arkady" <Arkady.Kanevsky@netapp.com>
To: "Sean Hefty" <sean.hefty@intel.com>,
       "Sean Hefty" <mshefty@ichips.intel.com>,
       "Steve Wise" <swise@opengridcomputing.com>
Cc: <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
X-OriginalArrivalTime: 27 Sep 2007 20:19:54.0159 (UTC) FILETIME=[C3ED13F0:01C80143]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sean,
IB aside,
it looks like an ULP which is capable of being both RDMA aware and RDMA
not-aware,
like iSER and iSCSI, NFS-RDMA and NFS, SDP and sockets, 
will be treated as two separete ULPs.
Each has its own IP address, since there is a different IP address for
iWARP
port and "regular" Ethernet port. So it falls on the users of ULPs to
"handle" it
via DNS or some other services.
Is this "acceptable" to users? I doubt it.

Recall that ULPs are going in opposite directions by having a different
port number for RDMA aware and RDMA unaware versions of the ULP.
This way, ULP "connection manager" handles RDMA-ness under the covers,
while users plug an IP address for a server to connect to.
Thanks,

Arkady Kanevsky                       email: arkady@netapp.com
Network Appliance Inc.               phone: 781-768-5395
1601 Trapelo Rd. - Suite 16.        Fax: 781-895-1195
Waltham, MA 02451                   central phone: 781-768-5300
 

> -----Original Message-----
> From: Sean Hefty [mailto:sean.hefty@intel.com] 
> Sent: Thursday, September 27, 2007 3:12 PM
> To: Kanevsky, Arkady; Sean Hefty; Steve Wise
> Cc: netdev@vger.kernel.org; rdreier@cisco.com; 
> linux-kernel@vger.kernel.org; general@lists.openfabrics.org
> Subject: RE: [ofa-general] [PATCH v3] iw_cxgb3: 
> Support"iwarp-only"interfacesto avoid 4-tuple conflicts.
> 
> >What is the model on how client connects, say for iSCSI, when client 
> >and server both support, iWARP and 10GbE or 1GbE, and would like to 
> >setup "most" performant "connection" for ULP?
> 
> For the "most" performance connection, the ULP would use IB, 
> and all these problems go away.  :)
> 
> This proposal is for each iwarp interface to have its own IP 
> address.  Clients would need an iwarp usable address of the 
> server and would connect using rdma_connect().  If that call 
> (or rdma_resolve_addr/route) fails, the client could try 
> connecting using sockets, aoi, or some other interface.  I 
> don't see that Steve's proposal changes anything from the 
> client's perspective.
> 
> - Sean
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit 
> http://openib.org/mailman/listinfo/openib-general
> 
