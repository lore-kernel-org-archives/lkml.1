Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZK0Fy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZK0Fy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZK0FyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:54:25 -0500
Received: from sparc.brc.ubc.ca ([137.82.2.12]:49290 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZK0FyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:54:25 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Nov 2009 00:54:25 EST
Date: Thu, 26 Nov 2009 21:54:29 -0800 (PST)
From: Vincent Li <macli@brc.ubc.ca>
X-X-Sender: root@kernalhack.brc.ubc.ca
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vincent Li <macli@brc.ubc.ca>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] vmscan: make lru_index() helper function
In-Reply-To: <20091127144636.A7E4.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911262153080.15015@kernalhack.brc.ubc.ca>
References: <20091127091755.A7CF.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911262138310.14657@kernalhack.brc.ubc.ca> <20091127144636.A7E4.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Nov 2009, KOSAKI Motohiro wrote:

> > > @@ -1373,10 +1378,8 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> > >  	 */
> > >  	reclaim_stat->recent_rotated[file] += nr_rotated;
> > >  
> > > -	move_active_pages_to_lru(zone, &l_active,
> > > -						LRU_ACTIVE + file * LRU_FILE);
> > > -	move_active_pages_to_lru(zone, &l_inactive,
> > > -						LRU_BASE   + file * LRU_FILE);
> > > +	move_active_pages_to_lru(zone, &l_active, lru_index(1, file));
> > > +	move_active_pages_to_lru(zone, &l_inactive, lru_index(0, file));
> > 
> > How about:
> > 	move_active_pages_to_lru(zone, &l_active, lru_index(LRU_ACTIVE, file));
> > 	move_active_pages_to_lru(zone, &l_inactive, lru_index(LRU_BASE, file));
> > ?
> 
> No. lru_index mean convert two boolean to one index. it shoudn't be passed
> lru index itself.

Yeah, you are right, I immediately realized I am wrong after replying, 
sorry.

Vincent

