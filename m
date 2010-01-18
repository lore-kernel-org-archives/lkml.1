Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389Ab0ARCZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab0ARCZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461Ab0ARCZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:25:00 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56275 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab0ARCY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:24:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B53C466.4010103@redhat.com>
References: <28c262361001171810w544614b7rdd3df0f984692f35@mail.gmail.com> <4B53C466.4010103@redhat.com>
Message-Id: <20100118112359.AE3C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 11:24:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 01/17/2010 09:10 PM, Minchan Kim wrote:
> 
> > Absoultely right. I missed that. Thanks.
> > get_scan_ratio used lru_lock to get reclaim_stat->recent_xxxx.
> > But, it doesn't used lru_lock to get ap/fp.
> >
> > Is it intentional? I think you or Rik know it. :)
> > I think if we want to get exact value, we have to use lru_lock until
> > getting ap/fp.
> > If it isn't, we don't need lru_lock when we get the reclaim_stat->recent_xxxx.
> >
> > What do you think about it?
> 
> This is definately not intentional.

Really?
So, I'll post next patch.

Thanks.



> Getting race conditions in this code could throw off the
> statistics by a factor 2.  I do not know how serious that
> would be for the VM or whether (and how quickly) it would
> self correct.
> 
> -- 
> All rights reversed.



