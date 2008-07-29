Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbYG2N3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbYG2N3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYG2N3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:29:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbYG2N3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:29:03 -0400
Date: Tue, 29 Jul 2008 09:28:53 -0400
From: Rik van Riel <riel@redhat.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Message-ID: <20080729092853.0ddf7013@bree.surriel.com>
In-Reply-To: <87y73k4yhg.fsf@saeurebad.de>
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080728105742.50d6514e@cuia.bos.redhat.com>
	<20080728164124.8240eabe.akpm@linux-foundation.org>
	<20080728195713.42cbceed@cuia.bos.redhat.com>
	<20080728200311.2218af4e@cuia.bos.redhat.com>
	<87y73k4yhg.fsf@saeurebad.de>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 15:21:47 +0200
Johannes Weiner <hannes@saeurebad.de> wrote:

> Here is my original patch that just gets rid of it.  It did not cause
> any problems to me on high pressure.  Rik, you said on IRC that you now
> also think the patch is safe..?

Yes.  Removing the "+ 1" is safe because we do not scan until
zone->lru[l].nr_scan reaches swap_cluster_max, which means that
the scan counter for small lists will also slowly increase and
no list will be left behind.

> From: Johannes Weiner <hannes@saeurebad.de>
> Subject: mm: don't accumulate scan pressure on unrelated lists
> 
> During each reclaim scan we accumulate scan pressure on unrelated
> lists which will result in bogus scans and unwanted reclaims
> eventually.

This patch fixes the balancing issues that we have been seeing
with the split LRU VM currently in -mm.

It is my preferred patch because it removes magic from the VM,
instead of adding some.

> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
