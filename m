Return-Path: <linux-kernel-owner+w=401wt.eu-S1758088AbZKTAwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088AbZKTAwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbZKTAwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:52:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:48802 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbZKTAwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:52:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208";a="515666510"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Roland Dreier'" <rdreier@cisco.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
References: <20091120110342.5128b8f8.sfr@canb.auug.org.au>	<ada1vju6oa6.fsf@roland-alpha.cisco.com>	<6307584467EB4D168602C43E0B185157@amr.corp.intel.com> <adaocmy58hl.fsf@roland-alpha.cisco.com>
Subject: RE: linux-next: infiniband tree build failure
Date: Thu, 19 Nov 2009 16:52:10 -0800
Message-ID: <D77E1576A4E24759B7A602F5F3EAB2B6@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcppeteSm26yoHKWRe2jsTxlW9LDcwAAJQ4A
In-Reply-To: <adaocmy58hl.fsf@roland-alpha.cisco.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>OK, so I threw this into the ipv6 patch, I think it's right:

Looks correct - thanks.

>diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>index 71e616a..fbdd731 100644
>--- a/drivers/infiniband/core/cma.c
>+++ b/drivers/infiniband/core/cma.c
>@@ -2083,6 +2083,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
> static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
> 			       struct sockaddr *addr)
> {
>+#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
> 	struct sockaddr_in6 *sin6;
>
> 	if (addr->sa_family != AF_INET6)
>@@ -2094,6 +2095,7 @@ static int cma_check_linklocal(struct rdma_dev_addr
>*dev_addr,
> 			return -EINVAL;
>
> 	dev_addr->bound_dev_if = sin6->sin6_scope_id;
>+#endif
> 	return 0;
> }
>

