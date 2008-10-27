Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbYJ0IFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbYJ0IFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYJ0IEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:04:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49735 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYJ0IEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:04:49 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: kosaki.motohiro@jp.fujitsu.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Rusty Russell <rusty@rustcorp.com.au>, mpm <mpm@selenic.com>
In-Reply-To: <1225094190.16159.3.camel@twins>
References: <20081027120405.1B45.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1225094190.16159.3.camel@twins>
Message-Id: <20081027170156.9659.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 27 Oct 2008 17:03:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-10-27 at 12:14 +0900, KOSAKI Motohiro wrote:
> > > Right, and would be about 4k+sizeof(task_struct), some people might be
> > > bothered, but most won't care.
> > > 
> > > > Perhaps, I misunderstand your intension. so can you point your
> > > > previous discussion url?
> > > 
> > > my google skillz fail me, but once in a while people complain that we
> > > have too many kernel threads.
> > > 
> > > Anyway, if we can re-use this per-cpu workqueue for more goals, I guess
> > > there is even less of an objection.
> > 
> > In general, you are right.
> > but this is special case. mmap_sem is really widely used various subsystem and drivers.
> > (because page fault via copy_user introduce to depend on mmap_sem)
> > 
> > Then, any work-queue reu-sing can cause similar dead-lock easily.
> 
> Yeah, I know, and the cpu-hotplug discussion needed another thread due
> to yet another locking incident. I was hoping these two could go
> together.

Yeah, I found its thread. (I think it is "work_on_cpu: helper for doing task on a CPU.", right?)
So I'll read it soon.

Please wait a bit.


> 
> Neither are general-purpose workqueues, both need to stay away from the
> normal eventd due to deadlocks.
> 
> ego, does you extra thread ever use mmap_sem?





