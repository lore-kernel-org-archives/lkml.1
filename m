Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbYFECXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbYFECXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYFECXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 22:23:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44218 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYFECXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 22:23:04 -0400
Date: Thu, 05 Jun 2008 11:23:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/5] page reclaim throttle v7
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080605110637.d50af953.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com> <20080605110637.d50af953.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20080605110925.9C29.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kame-san,

> I like this series and I'd like to support this under memcg when
> this goes to mainline. (it seems better to test this for a while
> before adding some memcg-related changes.)
> 
> Then, please give me inputs.
> What do you think do I have to do for supporting this in memcg ?
> Handling the case of scan_global_lru(sc)==false is enough ?

my patch have 2 improvement.
1. ristrict reclaiming parallerism of #task (throttle)
2. reclaiming cut off if other task already freed enough memory.

we already consider #1 on memcg and works well.
but we doesn't support #2 on memcg because balbir-san's said
"memcg doesn't need it".

if you need improvement of #2, please change blow portion of my patch.

> +	/* reclaim still necessary? */
> +	if (scan_global_lru(sc) &&
> +	    freed - sc->was_freed >= threshold) {
> +		if (zone_watermark_ok(zone, sc->order, zone->pages_high,
> +				      gfp_zone(sc->gfp_mask), 0)) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +		sc->was_freed = freed;
> +	}
> 


