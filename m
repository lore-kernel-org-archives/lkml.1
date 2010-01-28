Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656Ab0A1HzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0A1HzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944Ab0A1HzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:55:10 -0500
Received: from abydos.nerdbox.net ([216.151.149.55]:59903 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab0A1HzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:55:09 -0500
Date: Wed, 27 Jan 2010 23:16:49 -0800 (PST)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Minchan Kim <minchan.kim@gmail.com>
cc: Wu Fengguang <fengguang.wu@intel.com>, Chris Frost <frost@cs.ucla.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <steved@redhat.com>, David Howells <dhowells@redhat.com>,
       Xu Chenfeng <xcf@ustc.edu.cn>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/readahead.c: update the LRU positions of in-core
 pages, too
In-Reply-To: <28c262361001262309x332a895aoa906dda0bc040859@mail.gmail.com>
Message-ID: <alpine.DEB.1.00.1001272300120.2909@abydos.NerdBox.Net>
References: <20100120215536.GN27212@frostnet.net>  <20100121054734.GC24236@localhost> <28c262361001262309x332a895aoa906dda0bc040859@mail.gmail.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, Minchan Kim wrote:

> This patch effect happens when inactive file list is small, I think.
> It means it's high memory pressure. so if we move ra pages into

This patch does the same thing regardless of memory pressure - it
doesn't just apply in high memory pressure situations.  Is your concern
that in high memory pressure situations this patch with make things worse?

> head of inactive list, other application which require free page urgently
> suffer from latency or are killed.

I don't think this patch will affect the number of pages reclaimed, only
which pages are reclaimed.  In extreme cases it could increase the time
needed to reclaim that many pages, but the inactive list would have to be
very short.

> If VM don't have this patch, of course ra pages are discarded and
> then I/O performance would be bad. but as I mentioned, it's time
> high memory pressure. so I/O performance low makes system
> natural throttling. It can help out of  system memory pressure.

Even in low memory situations, improving I/O performance can help the
overall system performance.  For example if most of the inactive list 
is dirty, needlessly discarding pages, just to refetch them will clog
I/O and increase the time needed to write out the dirty pages.

> In summary I think it's good about viewpoint of I/O but I am not sure
> it's good about viewpoint of system.

In this case, I think what's good for I/O is good for the system.
Please help me understand if I am missing something.  Thanks

--
Steve
