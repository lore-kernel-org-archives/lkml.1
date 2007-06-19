Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXFSM4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXFSM4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbXFSMzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:55:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33300 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbXFSMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:55:54 -0400
Date: Tue, 19 Jun 2007 21:54:47 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 5/7] Introduce a means of compacting memory within a zone
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
In-Reply-To: <20070618093002.7790.68471.sendpatchset@skynet.skynet.ie>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie> <20070618093002.7790.68471.sendpatchset@skynet.skynet.ie>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070619213927.AC83.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel-san.
This is very interesting feature.

Now, I'm testing your patches.

> +static int isolate_migratepages(struct zone *zone,
> +					struct compact_control *cc)
> +{
> +	unsigned long high_pfn, low_pfn, end_pfn, start_pfn;

(snip)

> +	/* Time to isolate some pages for migration */
> +	spin_lock_irq(&zone->lru_lock);
> +	for (; low_pfn < end_pfn; low_pfn++) {
> +		if (!pfn_valid_within(low_pfn))
> +			continue;
> +
> +		/* Get the page and skip if free */
> +		page = pfn_to_page(low_pfn);

I met panic at here on my tiger4.

I compiled with CONFIG_SPARSEMEM. So, CONFIG_HOLES_IN_ZONE is not set.
pfn_valid_within() returns 1 every time on this configuration.
(This config is for only virtual memmap)
But, my tiger4 box has memory holes in normal zone.

When it is changed to normal pfn_valid(), no panic occurs.

Hmmm.

Bye.
-- 
Yasunori Goto 


