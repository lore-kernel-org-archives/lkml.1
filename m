Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbXIMVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbXIMVA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbXIMVAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:00:47 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11344 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbXIMVAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:00:46 -0400
X-IronPort-AV: E=Sophos;i="4.20,251,1186383600"; 
   d="scan'208";a="217722117"
To: Shirley Ma <xma@us.ibm.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Message-Flag: Warning: May contain useful information
References: <OF79F6C618.02039854-ON87257355.00646A35-88257355.0064AB34@us.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Sep 2007 14:00:43 -0700
In-Reply-To: <OF79F6C618.02039854-ON87257355.00646A35-88257355.0064AB34@us.ibm.com> (Shirley Ma's message of "Thu, 13 Sep 2007 11:22:16 -0700")
Message-ID: <aday7fal1qc.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Sep 2007 21:00:43.0744 (UTC) FILETIME=[26359600:01C7F649]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >         Since ehca can support 4K MTU, we would like to see a patch in 
 > IPoIB to allow link MTU to be up to 4K instead of current 2K for 2.6.24 
 > kernel. The idea is IPoIB link MTU will pick up a return value from SM's 
 > default broadcast MTU. This patch should be a small patch, I hope you are 
 > OK with this.

It's actually not small, since it turns the skb allocation into a
4100-byte buffer, which ends up being more than 1 page usually, which
means it fails if memory is fragmented.

Anyway given the backlog anything substantial that hasn't been posted
already is almost surely going to have to wait until 2.6.25.
