Return-Path: <linux-kernel-owner+w=401wt.eu-S935570AbXGMI3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570AbXGMI3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761920AbXGMI3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:29:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52482 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761026AbXGMI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:29:09 -0400
Date: Fri, 13 Jul 2007 01:29:06 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: joe.jin@oracle.com, bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com, Zwane Mwaikambo <zwane@arm.linux.org.uk>
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713012906.a6f63c90.pj@sgi.com>
In-Reply-To: <20070712235707.a08f0d42.akpm@linux-foundation.org>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<20070712235707.a08f0d42.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm scratching my head over that min_t in __first_node(), too.   I don't think
> it's possible for find_first_bit(..., N) to return anything >N _anyway_.  And if
> it does, we want to know about it.
> 
> <looks at Paul>

I'm not sure I've got this right, but looks like that min_t went in after
Zwane Mwaikambo, then <zwane@fsmlabs.com>, whom I am presuming is the same
person as now at <zwane@arm.linux.org.uk>, found a problem with the i386
find_next_bit implementation returning > N when merging i386 cpu hotplug.

See the thread:

  http://lkml.org/lkml/2004/7/31/102
  [PATCH][2.6] first/next_cpu returns values > NR_CPUS

I apparently lobbied at the time to mandate that find_first_bit(..., N)
return exactly N on failure to find a set bit, but gave up, after some
confusions on my part.

Adding Zwane to this thread -- the other participant on that thread,
Bill Irwin, is already on the CC list.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
