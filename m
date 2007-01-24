Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXAXC6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXAXC6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965633AbXAXC6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:58:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59865 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965632AbXAXC6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:58:42 -0500
Date: Wed, 24 Jan 2007 11:53:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: aubreylee@gmail.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       rgetz@blackfin.uclinux.org, Michael.Hennerich@analog.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Limit the size of the pagecache
Message-Id: <20070124115310.48cda374.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 16:49:55 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> If we enter reclaim and the number of page cache pages
> is too high then we switch off swapping during reclaim
> to avoid touching anonymous pages.

In general, I like this (kind of) feature.

> +	/*
> +	 * If the page cache is too big then focus on page cache
> +	 * and ignore anonymous pages
> +	 */
> +	if (sc->may_swap && zone_page_state(zone, NR_FILE_PAGES)
> +			> zone->max_pagecache_pages)
> +		sc->may_swap = 0;
> +


How about adding this (kind of) check ?

if (sc->may_swap &&
    zone_page_state(zone, NR_FILE_PAGES) &&
    !(curreht->flags & PF_MEMALLOC))
	sc->may_swap = 0;

-Kame

