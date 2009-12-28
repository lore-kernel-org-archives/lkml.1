Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZL1I4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZL1I4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 03:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbZL1I4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 03:56:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZL1I4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 03:56:15 -0500
Subject: Re: [RFC PATCH] asynchronous page fault.
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org
In-Reply-To: <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091225105140.263180e8.kamezawa.hiroyu@jp.fujitsu.com>
	 <1261915391.15854.31.camel@laptop>
	 <20091228093606.9f2e666c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Dec 2009 09:55:33 +0100
Message-ID: <1261990533.7135.34.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 09:36 +0900, KAMEZAWA Hiroyuki wrote:
> Hmm ? for single-thread apps ? This patch's purpose is not for lockless
> lookup, it's just a part of work. My purpose is avoiding false-sharing.

False sharing in the sense of the mmap_sem cacheline containing other
variables? How could that ever be a problem for a single threaded
application?

For multi-threaded apps the contention on that cacheline is the largest
issue, and moving it to a vma cacheline doesn't seem like a big
improvement.

You want something much finer grained than vmas, there's lots of apps
working on a single (or very few) vma(s). Leaving you with pretty much
the same cacheline contention. Only now its a different cacheline.

