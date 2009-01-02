Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbZABT73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbZABT73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758356AbZABT7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:59:13 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:3353 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbZABT7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:59:12 -0500
X-IronPort-AV: E=Sophos;i="4.36,319,1228089600"; 
   d="scan'208";a="126463562"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH -next] 9p: fix RDMA dependency
References: <20090102203303.f314a99a.sfr@canb.auug.org.au>
	<495E5A82.9000603@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 Jan 2009 11:59:07 -0800
In-Reply-To: <495E5A82.9000603@oracle.com> (Randy Dunlap's message of "Fri, 02
	Jan 2009 10:18:42 -0800")
Message-ID: <adawsddpjhw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Jan 2009 19:59:07.0308 (UTC) FILETIME=[9200F6C0:01C96D14]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  config NET_9P_RDMA
 > -	depends on INET && INFINIBAND && EXPERIMENTAL
 > +	depends on INET && INFINIBAND_ADDR_TRANS && EXPERIMENTAL
 >  	tristate "9P RDMA Transport (Experimental)"

This actually allows the broken config INFINIBAND=m and NET_9P_RDMA=y.
I think the answer is to add INFINIBAND_ADDR_TRANS but leave INFINIBAND
too.  The SUNRPC_XPRT_RDMA patch would have the same problem, but since
SUNRPC_XPRT_RDMA is a hidden option (with help text ?!) that gets set
automatically, there's no way to create the problem config.

 - R.
