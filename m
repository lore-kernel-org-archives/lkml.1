Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665Ab0AMXuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0AMXuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728Ab0AMXuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:50:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37812 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab0AMXuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:50:11 -0500
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
In-Reply-To: <28c262361001130231k29b933der4022f4d1da80b084@mail.gmail.com>
References: <20100113171953.B3E5.A69D9226@jp.fujitsu.com> <28c262361001130231k29b933der4022f4d1da80b084@mail.gmail.com>
Message-Id: <20100114084659.D713.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 08:50:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Hi, Kosaki.
> 
> On Wed, Jan 13, 2010 at 5:21 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > Changelog
> >  from v1
> >  - get_anon_scan_ratio don't tak zone->lru_lock anymore
> >   because zoneinfo_show_print takes zone->lock.
> 
> When I saw this changelog first, I got confused.
> That's because there is no relation between lru_lock and lock in zone.
> You mean zoneinfo is allowed to have a stale data?
> Tend to agree with it.

Well. zone->lock and zone->lru_lock should be not taked at the same time.
[1/4] of my last version removed zone->lock, then get_anon_scan_ratioo()
can take zone->lru_lock. but I dropped it. thus get_anon_scan_ration() can't
take zone->lru_lock.

Thus, I added need_update parameter.


