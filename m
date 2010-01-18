Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487Ab0ARCO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0ARCO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281Ab0ARCO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:14:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0ARCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:14:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
References: <20100118104910.AE2D.A69D9226@jp.fujitsu.com> <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com>
Message-Id: <20100118111337.AE33.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 11:14:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> It can make stale data when high memory pressure happens.
> >
> > ?? why? and when?
> > I think it depend on what's stale mean.
> >
> > Currently(i.e. before the patch), get_scan_ratio have following fomula.
> > in such region, recent_scanned is not protected by zone->lru_lock.
> >
> >        ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
> >        ap /= reclaim_stat->recent_rotated[0] + 1;
> >        fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
> >        fp /= reclaim_stat->recent_rotated[1] + 1;
> >        percent[0] = 100 * ap / (ap + fp + 1);
> >        percent[1] = 100 - percent[0];
> >
> > It mean, shrink_zone() doesn't use exactly recent_scanned value. then
> > zoneinfo can use the same unexactly value.
> 
> Absoultely right. I missed that. Thanks.
> get_scan_ratio used lru_lock to get reclaim_stat->recent_xxxx.
> But, it doesn't used lru_lock to get ap/fp.
> 
> Is it intentional? I think you or Rik know it. :)
> I think if we want to get exact value, we have to use lru_lock until
> getting ap/fp.
> If it isn't, we don't need lru_lock when we get the reclaim_stat->recent_xxxx.
> 
> What do you think about it?

I believe the current code is intentional.



