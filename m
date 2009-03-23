Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZCWKys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZCWKys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZCWKyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:54:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54718 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZCWKyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:54:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1237752784-1989-3-git-send-email-hannes@cmpxchg.org>
References: <1237752784-1989-3-git-send-email-hannes@cmpxchg.org> <20090321102044.GA3427@cmpxchg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 3/3] mm: keep pages from unevictable mappings off the LRU lists
Date: Mon, 23 Mar 2009 10:53:27 +0000
Message-ID: <12135.1237805607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:

> -		if (page_is_file_cache(page))
> +		if (mapping_unevictable(mapping))
> +			add_page_to_unevictable_list(page);
> +		else if (page_is_file_cache(page))

It would be nice to avoid adding an extra test and branch in here.  This
function is used a lot, and quite often we know the answer to the first test
before we even get here.

David
