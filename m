Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZKTApy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZKTApy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbZKTApx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:45:53 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57235 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZKTApw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:45:52 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANN1BUurR7Hu/2dsb2JhbAC9fZdphDsEgW8
X-IronPort-AV: E=Sophos;i="4.44,774,1249257600"; 
   d="scan'208";a="436391773"
From: Roland Dreier <rdreier@cisco.com>
To: "Sean Hefty" <sean.hefty@intel.com>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, <general@lists.openfabrics.org>,
       <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: infiniband tree build failure
References: <20091120110342.5128b8f8.sfr@canb.auug.org.au>
	<ada1vju6oa6.fsf@roland-alpha.cisco.com>
	<6307584467EB4D168602C43E0B185157@amr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 19 Nov 2009 16:45:58 -0800
In-Reply-To: <6307584467EB4D168602C43E0B185157@amr.corp.intel.com> (Sean
	Hefty's message of "Thu, 19 Nov 2009 16:30:55 -0800")
Message-ID: <adaocmy58hl.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Nov 2009 00:45:59.0010 (UTC) FILETIME=[D3940420:01CA697A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so I threw this into the ipv6 patch, I think it's right:

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 71e616a..fbdd731 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2083,6 +2083,7 @@ static int cma_get_port(struct rdma_id_private *id_priv)
 static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
 			       struct sockaddr *addr)
 {
+#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)
 	struct sockaddr_in6 *sin6;
 
 	if (addr->sa_family != AF_INET6)
@@ -2094,6 +2095,7 @@ static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
 			return -EINVAL;
 
 	dev_addr->bound_dev_if = sin6->sin6_scope_id;
+#endif
 	return 0;
 }
 
