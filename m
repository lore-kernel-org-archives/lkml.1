Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZEXNpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZEXNpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 09:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZEXNo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 09:44:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36223 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZEXNo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 09:44:57 -0400
Date: Sun, 24 May 2009 22:44:30 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Cc: kosaki.motohiro@jp.fujitsu.com, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0905210924520.31888@qirst.com>
References: <20090521090549.63B5.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0905210924520.31888@qirst.com>
Message-Id: <20090524223857.0852.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry I missed this mail

> > > Even with 128 nodes and 256 cpus, I _NEVER_ see the
> > > system swapping out before allocating off node so I can certainly not
> > > reproduce the situation you are seeing.
> >
> > hmhm. but I don't think we can assume hpc workload.
> 
> System swapping due to zone reclaim? zone reclaim only reclaims unmapped
> pages so it will not swap. Maybe some bug crept in in the recent changes?
> Or you overrode the defaults for zone reclaim?

I guess he use zone_reclaim_mode=7 or similar.

However, I have to explain recent zone reclaim change. current zone reclaim is

 1. zone reclaim can make high order reclaim (by hanns)
 2. determine file-backed page by get_scan_ratio

it mean, high order allocation makes lumpy zone reclaim. and shrink_inactive_list()
don't care may_swap. then, zone_reclaim_mode=1 can makes swap-out if your
driver makes high order allocation request.



