Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZFXNIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZFXNIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZFXNIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:08:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZFXNIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:08:09 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090624023251.GA16483@localhost>
References: <20090624023251.GA16483@localhost> <20090620043303.GA19855@localhost> <32411.1245336412@redhat.com> <20090517022327.280096109@intel.com> <2015.1245341938@redhat.com> <20090618095729.d2f27896.akpm@linux-foundation.org> <7561.1245768237@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>, "riel@redhat.com" <riel@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class citizen
Date: Wed, 24 Jun 2009 14:07:19 +0100
Message-ID: <3901.1245848839@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay, I've bisected it down to a narrow range of 60 commits, which include
various mm patches from Fengguang and Rik.

	bad: b8d9a86590fb334d28c5905a4c419ece7d08e37d
	good: 03347e2592078a90df818670fddf97a33eec70fb

The bad one is definitely bad; the good one is very probably good (the V4L
commit list branched from there, and survived about 40 iterations of LTP
without coughing up an OOM).

I've attached my bisection log to this point, and I'm continuing trying to
narrow it down.

git bisect visualise produces a nice linear list of commits between the bounds
it's currently working.  Is there any way to produce that as a text dump?

David
---
git bisect start
# bad: [c868d550115b9ccc0027c67265b9520790f05601] mm: Move pgtable_cache_init() earlier
git bisect bad c868d550115b9ccc0027c67265b9520790f05601
# good: [300df7dc89cc276377fc020704e34875d5c473b6] Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2
git bisect good 300df7dc89cc276377fc020704e34875d5c473b6
# good: [e1f5b94fd0c93c3e27ede88b7ab652d086dc960f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect good e1f5b94fd0c93c3e27ede88b7ab652d086dc960f
# bad: [b8d9a86590fb334d28c5905a4c419ece7d08e37d] Documentation/accounting/getdelays.c intialize the variable before using it
git bisect bad b8d9a86590fb334d28c5905a4c419ece7d08e37d

