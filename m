Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZCWKtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZCWKtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbZCWKta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:49:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZCWKt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:49:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090323001418.GA32758@cmpxchg.org>
References: <20090323001418.GA32758@cmpxchg.org> <20090321102044.GA3427@cmpxchg.org> <1237752784-1989-1-git-send-email-hannes@cmpxchg.org> <20090323084423.490C.A69D9226@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: dhowells@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 1/3] mm: decouple unevictable lru from mmu
Date: Mon, 23 Mar 2009 10:48:25 +0000
Message-ID: <12087.1237805305@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:

> David, why do we need two Kconfig symbols for mlock and the mlock page
> bit?  Don't we always provide mlock on mmu and never on nommu?

Because whilst the PG_mlocked doesn't exist if we don't have mlock() because
we're in NOMMU mode, that does not imply that it _does_ exist if we _do_ have
mlock() as it's also contingent on having the unevictable LRU.

Not only that, CONFIG_HAVE_MLOCK used in mm/internal.h to switch some stuff
out based on whether we have mlock() available or not - which is not the same
as whether we have PG_mlocked or not.

Mainly I thought it made the train of logic easier.

Note that neither symbol is actually manually adjustable.

David
