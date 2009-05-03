Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbZECBfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbZECBfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 21:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZECBer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 21:34:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59716 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbZECBeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 21:34:46 -0400
Date: Sat, 2 May 2009 21:33:56 -0400
From: Rik van Riel <riel@redhat.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Elladan <elladan@eskimo.com>,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v3)
Message-ID: <20090502213356.2f620d81@riellaptop.surriel.com>
In-Reply-To: <20090503011540.GA5702@localhost>
References: <20090428044426.GA5035@eskimo.com>
	<20090428192907.556f3a34@bree.surriel.com>
	<1240987349.4512.18.camel@laptop>
	<20090429114708.66114c03@cuia.bos.redhat.com>
	<2f11576a0904290907g48e94e74ye97aae593f6ac519@mail.gmail.com>
	<20090429131436.640f09ab@cuia.bos.redhat.com>
	<20090503011540.GA5702@localhost>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 May 2009 09:15:40 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> In the worse scenario, it could waste half the memory that could
> otherwise be used for readahead buffer and to prevent thrashing, in a
> server serving large datasets that are hardly reused, but still slowly
> builds up its active list during the long uptime (think about a slowly
> performance downgrade that can be fixed by a crude dropcache action).

In the best case, the active list ends up containing all the
indirect blocks for the files that are occasionally reused,
and the system ends up being able to serve its clients with
less disk IO.

For systems like ftp.kernel.org, the files that are most
popular will end up on the active list, without being kicked
out by the files that are less popular.

-- 
All rights reversed.
