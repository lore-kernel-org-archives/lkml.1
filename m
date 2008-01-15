Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYAODJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYAODJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 22:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYAODI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 22:08:59 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41606 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYAODI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 22:08:58 -0500
Date: Tue, 15 Jan 2008 12:08:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115120012.0fcdd0f8.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080115112114.118E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115120012.0fcdd0f8.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080115120110.1194.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

> > > > +	notify_threshold = (zone->pages_high +
> > > > +			    zone->lowmem_reserve[MAX_NR_ZONES-1]) * 2;
> > > > +
> > > Why MAX_NR_ZONES-1 ?
> > 
> > this is intent to max lowmem_reserve.
> > 
> Ah, my point is.. how about this ?
> ==
> if (page_zoneid(page) != ZONE_DMA)
> 	notify_threshold = zone->pages_high +
>                    	zone->lowmem_reserve[page_zoneid(page) - 1] * 2;

your point out is very good point.

but judged by zone size is more better, may be.
on some 64bit system, ZONE_DMA is 4GB.
small memory system can't ignore it. 

fortunately, zone size check can at free_area_init_core().


- kosaki



