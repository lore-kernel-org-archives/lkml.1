Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYAOCDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYAOCDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYAOCDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:03:24 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37936 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYAOCDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:03:23 -0500
Date: Tue, 15 Jan 2008 11:06:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Message-Id: <20080115110631.4cab1e65.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080115100124.117B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115100124.117B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 10:02:30 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> +
> +	notify_threshold = (zone->pages_high +
> +			    zone->lowmem_reserve[MAX_NR_ZONES-1]) * 2;
> +
Why MAX_NR_ZONES-1 ?


> +	if (unlikely((prev_free <= notify_threshold) &&
> +		     (zone_page_state(zone, NR_FREE_PAGES) > notify_threshold)))
> +		memory_pressure_notify(zone, 0);
>  }

How about this
==
if (unlikely(zone->mem_notify_status && ...) 


Thanks,
-Kame

