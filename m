Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZFJBr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZFJBr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbZFJBrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:47:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60313 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZFJBrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:47:21 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/4] Count the number of times zone_reclaim() scans and fails
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244566904-31470-4-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20090610104635.DDA6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Jun 2009 10:47:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I like this patch. thank you mel.

> @@ -2489,6 +2489,10 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	ret = __zone_reclaim(zone, gfp_mask, order);
>  	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
>  
> +	if (!ret) {
> +		count_vm_events(PGSCAN_ZONERECLAIM_FAILED, 1);
> +	}
> +
>  	return ret;


count_vm_event(PGSCAN_ZONERECLAIM_FAILED)?




