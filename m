Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYAOC46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYAOC46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYAOC4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:56:49 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40984 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYAOC4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:56:48 -0500
Date: Tue, 15 Jan 2008 12:00:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Message-Id: <20080115120012.0fcdd0f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080115112114.118E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115100124.117B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115110631.4cab1e65.kamezawa.hiroyu@jp.fujitsu.com>
	<20080115112114.118E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 11:37:48 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi KAME, 
> 
> > > +	notify_threshold = (zone->pages_high +
> > > +			    zone->lowmem_reserve[MAX_NR_ZONES-1]) * 2;
> > > +
> > Why MAX_NR_ZONES-1 ?
> 
> this is intent to max lowmem_reserve.
> 
Ah, my point is.. how about this ?
==
if (page_zoneid(page) != ZONE_DMA)
	notify_threshold = zone->pages_high +
                   	zone->lowmem_reserve[page_zoneid(page) - 1] * 2;
==

Thanks,
-Kame

