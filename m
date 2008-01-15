Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYAOCih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYAOCih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYAOCi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:38:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51319 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYAOCi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:38:26 -0500
Date: Tue, 15 Jan 2008 11:37:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115110631.4cab1e65.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080115100124.117B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115110631.4cab1e65.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080115112114.118E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KAME, 

> > +	notify_threshold = (zone->pages_high +
> > +			    zone->lowmem_reserve[MAX_NR_ZONES-1]) * 2;
> > +
> Why MAX_NR_ZONES-1 ?

this is intent to max lowmem_reserve.

in normal case, 
shrink_active_list isn't called when free_pages > pages_high.
but just after memory freed, it happened rarely.

I don't want incorrect notify at system enough free memory.

related discussion
  http://marc.info/?l=linux-mm&m=119878630211348&w=2


> > +	if (unlikely((prev_free <= notify_threshold) &&
> > +		     (zone_page_state(zone, NR_FREE_PAGES) > notify_threshold)))
> > +		memory_pressure_notify(zone, 0);
> >  }
> 
> How about this
> ==
> if (unlikely(zone->mem_notify_status && ...) 

Nice idea.
I will applied it at next post.

thank you!




