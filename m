Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZE1WS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZE1WS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZE1WSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:18:21 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:38429 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZE1WSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:18:20 -0400
X-IronPort-AV: E=Sophos;i="4.41,267,1241395200"; 
   d="scan'208";a="191641623"
From: Roland Dreier <rdreier@cisco.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rolandd@cisco.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] IB/mthca: replace dma_sync_single with dma_sync_single_for_cpu
References: <20090528100943L.fujita.tomonori@lab.ntt.co.jp>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 28 May 2009 15:18:21 -0700
In-Reply-To: <20090528100943L.fujita.tomonori@lab.ntt.co.jp> (FUJITA
	Tomonori's message of "Thu, 28 May 2009 10:10:43 +0900")
Message-ID: <adaeiu86fde.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2009 22:18:22.0641 (UTC) FILETIME=[367B1A10:01C9DFE2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > This replaces dma_sync_single() with dma_sync_single_for_cpu() because
 > dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
 > 
 > /* Backwards compat, remove in 2.7.x */

Thanks for pointing this out... however I think sync_single_for_cpu
looks wrong in these cases -- I think there should be a pair of
sync_single_for_cpu/sync_single_for_device around this stuff.

I'll take a closer look in the next day or too.

 - R.
