Return-Path: <linux-kernel-owner+w=401wt.eu-S1753012AbYKXTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbYKXTSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbYKXTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:18:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53372 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbYKXTSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:18:37 -0500
Message-ID: <492AFE04.10404@redhat.com>
Date: Mon, 24 Nov 2008 14:18:28 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after swap_cluster_max
 pages
References: <20081116163915.F208.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <20081115235410.2d2c76de.akpm@linux-foundation.org>	 <20081122191258.26B0.KOSAKI.MOTOHIRO@jp.fujitsu.com>	 <49283A05.1060009@redhat.com> <2f11576a0811241112p494b28a6p720da1d60ac3438c@mail.gmail.com>
In-Reply-To: <2f11576a0811241112p494b28a6p720da1d60ac3438c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> 1. reclaim 32 page from ZONE_HIGHMEM
> 2. reclaim 32 page from ZONE_NORMAL
> 3. reclaim 32 page from ZONE_DMA
> 4. exit reclaim
> 5. another task call page alloc and it cause try_to_free_pages()
> 6. reclaim 32 page from ZONE_HIGHMEM
> 7. reclaim 32 page from ZONE_NORMAL
> 8. reclaim 32 page from ZONE_DMA

>> - have direct reclaim tasks continue when priority == DEF_PRIORITY
> 
> disagreed.
> it cause above bad scenario, I think.

I think I did not explain it clearly.  Let me illustrate
with a new patch.  (one moment :))

-- 
All rights reversed.
