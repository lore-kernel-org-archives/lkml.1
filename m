Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYKRLl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYKRLl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYKRLlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:41:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63378 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYKRLls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:41:48 -0500
Message-ID: <4922A93B.6060102@cn.fujitsu.com>
Date: Tue, 18 Nov 2008 19:38:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH V2 1/4] vmalloc: introduce vfree_atomic()
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org> <492281F7.3000107@cn.fujitsu.com> <200811182019.44064.nickpiggin@yahoo.com.au>
In-Reply-To: <200811182019.44064.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Tuesday 18 November 2008 19:51, Lai Jiangshan wrote:
>> fdtable and sysipc use vfree() in RCU callback. this patch
>> introduce vfree_atomic() for them.
> 
> AFAIKS, vfree is usable from atomic context? What am I missing?

Hi, Nick Piggin,

Sorry for misled you.

fdtable and sysipc use vfree() in RCU callback.(_but defer it by schedule_work()_)
current vfree() is not usable from atomic context, so this patches are worthy.

even if vfree() is usable from atomic context soon,
[PATCH 3/4] [PATCH 4/4] are still worthy now. Because these two patches are
independent from vfree().(just needs to be changed one or two lines
when vfree() is usable from atomic context)

I suggest we can use vfree_atomic() before vfree() is available
for atomic context. Because fdtable and sysipc need a grace way for
using RCU and vmalloc/vfree. (actually, fdtable and sysipc have implemented
they own "vfree_atomic()", but it's very ugly)

Thanx, Lai.

> Actually, one could argue that we don't want to perform such
> costly operations in the atomic context, however with lazy
> unmapping, vfree is very cheap now (amortized, at least).
>

I'm looking forward to vfree() is available for atomic context.

> But it should be much cheaper on average not to schedule this in
> another context.
> 
> If there was any concern about the TLB flush from atomic context,
> we should just defer the lazy flushing, rather than every single
> vunmap.
> 
> 
> 


