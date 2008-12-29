Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbYL2DpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbYL2DpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYL2Doy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:44:54 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:43543 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYL2Dox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:44:53 -0500
X-IronPort-AV: E=Sophos;i="4.36,293,1228089600"; 
   d="scan'208";a="220742973"
From: Roland Dreier <rdreier@cisco.com>
To: general@lists.openfabrics.org, Aleksey Senin <alekseys@voltaire.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: origin tree build failure
References: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 28 Dec 2008 19:44:52 -0800
In-Reply-To: <20081229114321.4b6baea5.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 29 Dec 2008 11:43:21 +1100")
Message-ID: <ada4p0nve4r.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Dec 2008 03:44:52.0705 (UTC) FILETIME=[CEB16510:01C96967]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
 > ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefined!
 > 
 > Caused by commit 38617c64bf9a10bf20e41d95b69bb81e8560fe9d ("RDMA/addr:
 > Add support for translating IPv6 addresses").  This requires a dependency
 > on IPV6.

So how do we want to fix this?  (This question is mostly directed to the
IB guys)  One possibility is to make all this depend on IPV6 in Kconfig,
but I think we want the RDMA CM to be buildable/usable even if IPv6
isn't enabled.  A better option is to just put all the IPv6 related
stuff into

#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)

and add a Kconfig dependency on (IPV6 || IPV6=n) as we did for IPoIB.

But then this leads to the behavior that loading the RDMA CM will cause
the ipv6 module to be loaded if IPV6=m in the kernel config, even if the
administrator doesn't want to enable IPv6, just as with IPoIB today.
And people already complain about that.

Anyone see a better solution (which we could use for IPoIB even)?

 - R.
