Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbZGIFIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbZGIFIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZGIFIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:08:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48908 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZGIFIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:08:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [RFC PATCH 2/2] Don't continue reclaim if the system have plenty  free memory
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <28c262360907070620n3e22801egd4493c149a263ecd@mail.gmail.com>
References: <20090707184714.0C73.A69D9226@jp.fujitsu.com> <28c262360907070620n3e22801egd4493c149a263ecd@mail.gmail.com>
Message-Id: <20090709140234.239F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 14:08:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, Kosaki.
> 
> On Tue, Jul 7, 2009 at 6:48 PM, KOSAKI
> Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> > Subject: [PATCH] Don't continue reclaim if the system have plenty free memory
> >
> > On concurrent reclaim situation, if one reclaimer makes OOM, maybe other
> > reclaimer can stop reclaim because OOM killer makes enough free memory.
> >
> > But current kernel doesn't have its logic. Then, we can face following accidental
> > 2nd OOM scenario.
> >
> > 1. System memory is used by only one big process.
> > 2. memory shortage occur and concurrent reclaim start.
> > 3. One reclaimer makes OOM and OOM killer kill above big process.
> > 4. Almost reclaimable page will be freed.
> > 5. Another reclaimer can't find any reclaimable page because those pages are
> > ? already freed.
> > 6. Then, system makes accidental and unnecessary 2nd OOM killer.
> >
> 
> Did you see the this situation ?
> Why I ask is that we have already a routine for preventing parallel
> OOM killing in __alloc_pages_may_oom.
>
> Couldn't it protect your scenario ?

Can you please see actual code of this patch?
Those two patches fix different problem.

1/2 fixes the issue of that concurrent direct reclaimer makes
too many isolated pages.
2/2 fixes the issue of that reclaim and exit race makes accidental oom.


> If it can't, Could you explain the scenario in more detail ?

__alloc_pages_may_oom() check don't effect the threads of already
entered reclaim. it's obvious.




