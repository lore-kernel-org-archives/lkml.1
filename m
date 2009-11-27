Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZK0FsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZK0FsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZK0Fr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:47:59 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44750 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZK0Fr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:47:59 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vincent Li <macli@brc.ubc.ca>
Subject: Re: [PATCH 2/4] vmscan: make lru_index() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0911262138310.14657@kernalhack.brc.ubc.ca>
References: <20091127091755.A7CF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911262138310.14657@kernalhack.brc.ubc.ca>
Message-Id: <20091127144636.A7E4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 14:47:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1373,10 +1378,8 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> >  	 */
> >  	reclaim_stat->recent_rotated[file] += nr_rotated;
> >  
> > -	move_active_pages_to_lru(zone, &l_active,
> > -						LRU_ACTIVE + file * LRU_FILE);
> > -	move_active_pages_to_lru(zone, &l_inactive,
> > -						LRU_BASE   + file * LRU_FILE);
> > +	move_active_pages_to_lru(zone, &l_active, lru_index(1, file));
> > +	move_active_pages_to_lru(zone, &l_inactive, lru_index(0, file));
> 
> How about:
> 	move_active_pages_to_lru(zone, &l_active, lru_index(LRU_ACTIVE, file));
> 	move_active_pages_to_lru(zone, &l_inactive, lru_index(LRU_BASE, file));
> ?

No. lru_index mean convert two boolean to one index. it shoudn't be passed
lru index itself.




