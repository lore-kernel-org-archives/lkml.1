Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbZLNXvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbZLNXvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZLNXvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:51:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59288 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZLNXvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:51:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 6/8] Stop reclaim quickly when the task reclaimed enough lots pages
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <4B264F77.6040603@redhat.com>
References: <20091214213103.BBC0.A69D9226@jp.fujitsu.com> <4B264F77.6040603@redhat.com>
Message-Id: <20091215084903.CDAA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 08:51:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/14/2009 07:31 AM, KOSAKI Motohiro wrote:
> >
> >  From latency view, There isn't any reason shrink_zones() continue to
> > reclaim another zone's page if the task reclaimed enough lots pages.
> 
> IIRC there is one reason - keeping equal pageout pressure
> between zones.
> 
> However, it may be enough if just kswapd keeps evening out
> the pressure, now that we limit the number of concurrent
> direct reclaimers in the system.
> 
> Since kswapd does not use shrink_zones ...

Sure. That's exactly my point.
plus, balance_pgdat() scan only one node. then zone balancing is
meaingfull. but shrink_zones() scan all zone in all node. we don't
need inter node balancing. it's vmscan's buisiness.


> > Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>

Thanks.


