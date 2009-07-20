Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZGTH16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZGTH16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 03:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZGTH15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 03:27:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZGTH14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 03:27:56 -0400
Subject: Re: [PATCH 4/5] Use add_page_to_lru_list() helper function
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090720143352.747E.A69D9226@jp.fujitsu.com>
References: <20090716173921.9D54.A69D9226@jp.fujitsu.com>
	 <1247833128.15751.41.camel@twins>
	 <20090720143352.747E.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 20 Jul 2009 09:28:31 +0200
Message-Id: <1248074911.15751.8023.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 14:37 +0900, KOSAKI Motohiro wrote:
> > > @@ -1241,7 +1241,6 @@ static void move_active_pages_to_lru(str
> > >  			spin_lock_irq(&zone->lru_lock);
> > >  		}
> > >  	}
> > > -	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
> > >  	if (!is_active_lru(lru))
> > >  		__count_vm_events(PGDEACTIVATE, pgmoved);
> > >  }
> > 
> > This is a net loss, you introduce pgmoved calls to __inc_zone_state,
> > instead of the one __mod_zone_page_state() call.
> 
> max pgmoved is 32. 32 times __inc_zone_state() make 0 or 1 time
> atomic operation (not much than two).
> I don't think it reduce performance.

its not just atomics, count calls and branches too. It simply adds a ton
of code for no particular reason.
