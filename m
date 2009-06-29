Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbZF2KLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbZF2KLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZF2KLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:11:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52525 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZF2KLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:11:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090629073423.GA1315@localhost>
References: <20090629073423.GA1315@localhost> <7561.1245768237@redhat.com> <26537.1246086769@redhat.com> <20090627125412.GA1667@cmpxchg.org> <20090628113246.GA18409@localhost> <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com> <28c262360906280636l93130ffk14086314e2a6dcb7@mail.gmail.com> <20090628142239.GA20986@localhost> <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com> <20090628151026.GB25076@localhost> <20090629091741.ab815ae7.minchan.kim@barrios-desktop> 
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Date: Mon, 29 Jun 2009 11:10:19 +0100
Message-ID: <17678.1246270219@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:

> Yes, good catch! (sorry I was in a hurry at the time..)

That doesn't compile:

mm/vmscan.c: In function 'do_try_to_free_pages':
mm/vmscan.c:1683: error: too many arguments to function 'zone_reclaimable_pages'
mm/vmscan.c: In function 'balance_pgdat':
mm/vmscan.c:1900: error: too many arguments to function 'zone_reclaimable_pages'
mm/vmscan.c:1944: error: too many arguments to function 'zone_reclaimable_pages'
mm/vmscan.c: In function 'global_reclaimable_pages':
mm/vmscan.c:2115: error: 'zone' undeclared (first use in this function)
mm/vmscan.c:2115: error: (Each undeclared identifier is reported only once
mm/vmscan.c:2115: error: for each function it appears in.)
mm/vmscan.c:2115: error: too many arguments to function 'global_page_state'
mm/vmscan.c:2116: error: too many arguments to function 'global_page_state'
mm/vmscan.c:2119: error: too many arguments to function 'global_page_state'
mm/vmscan.c:2120: error: too many arguments to function 'global_page_state'
mm/vmscan.c: At top level:
mm/vmscan.c:2126: error: conflicting types for 'zone_reclaimable_pages'
include/linux/vmstat.h:170: note: previous declaration of 'zone_reclaimable_pages' was here
make[1]: *** [mm/vmscan.o] Error 1

David
