Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbZGTFhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbZGTFhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 01:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbZGTFhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 01:37:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55443 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZGTFhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 01:37:40 -0400
Date: Mon, 20 Jul 2009 14:37:09 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5] Use add_page_to_lru_list() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1247833128.15751.41.camel@twins>
References: <20090716173921.9D54.A69D9226@jp.fujitsu.com> <1247833128.15751.41.camel@twins>
Message-Id: <20090720143352.747E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1241,7 +1241,6 @@ static void move_active_pages_to_lru(str
> >  			spin_lock_irq(&zone->lru_lock);
> >  		}
> >  	}
> > -	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> >  	if (!is_active_lru(lru))
> >  		__count_vm_events(PGDEACTIVATE, pgmoved);
> >  }
> 
> This is a net loss, you introduce pgmoved calls to __inc_zone_state,
> instead of the one __mod_zone_page_state() call.

max pgmoved is 32. 32 times __inc_zone_state() make 0 or 1 time
atomic operation (not much than two).
I don't think it reduce performance.




