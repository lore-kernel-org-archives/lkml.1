Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbZEOKMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbZEOKMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760061AbZEOKMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:12:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60114 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709AbZEOKMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:12:38 -0400
Date: Fri, 15 May 2009 12:18:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Subject: Re: [PATCH] Physical Memory Management [0/1]
Message-ID: <20090515101811.GC16682@one.firstfloor.org>
References: <op.utu26hq77p4s8u@amdc030> <20090513151142.5d166b92.akpm@linux-foundation.org> <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop> <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop> <op.utw7yhv67p4s8u@amdc030> <20090514100718.d8c20b64.akpm@linux-foundation.org> <1242321000.6642.1456.camel@laptop> <op.utyudge07p4s8u@amdc030>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.utyudge07p4s8u@amdc030>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Correct me if I'm wrong, but if I understand correctly, currently only
> one size of huge page may be defined, even if underlaying architecture

That's not correct, support for multiple huge page sizes was recently
added. The interface is a bit clumpsy admittedly, but it's there.

However for non fragmentation purposes you probably don't
want too many different sizes anyways, the more sizes, the worse
the fragmentation. Ideal is only a single size.

> largest blocks that may ever be requested and then waste a lot of
> memory when small pages are requested or (ii) define smaller huge
> page size but then special handling of large regions need to be
> implemented.

If you don't do that then long term fragmentation will
kill you anyways. it's easy to show that pre allocation with lots
of different sizes is about equivalent what the main page allocator
does anyways.

> So to sum up, if I understand everything correctly, hugetlb would be a
> great solution when working with buffers of similar sizes.  However, it's
> not so good when size of requested buffer may vary greatly.

As Peter et.al. explained earlier varying buffer sizes don't work
anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
