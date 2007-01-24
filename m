Return-Path: <linux-kernel-owner+w=401wt.eu-S1030191AbXAXDUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030191AbXAXDUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 22:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030229AbXAXDUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 22:20:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32816 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030191AbXAXDUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 22:20:22 -0500
Date: Wed, 24 Jan 2007 12:13:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: aubreylee@gmail.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070124121318.6874f003.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


one more thing...

On Tue, 23 Jan 2007 16:49:55 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> @@ -1168,6 +1170,11 @@ zonelist_scan:
>  			!cpuset_zone_allowed_softwall(zone, gfp_mask))
>  				goto try_next_zone;
>  
> +		if ((gfp_mask & __GFP_PAGECACHE) &&
> +				zone_page_state(zone, NR_FILE_PAGES) >
> +					zone->max_pagecache_pages)
> +				goto try_next_zone;
> +

I don't prefer to cause zone fallback by this.
This may use ZONE_DMA before exhausing ZONE_NORMAL (ia64),
ZONE_NORMAL before ZONE_HIGHMEM (x86).
Very rapid page allocation can eats some amount of lower zone.

Regards,
-Kame

