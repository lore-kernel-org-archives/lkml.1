Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbYJ0H5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbYJ0H5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbYJ0H5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:57:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46961 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYJ0H5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:57:12 -0400
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
 schedule_on_each_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Gautham Shenoy <ego@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Rusty Russell <rusty@rustcorp.com.au>, mpm <mpm@selenic.com>
In-Reply-To: <20081027120405.1B45.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <2f11576a0810260851h15cb7e1ahb454b70a2e99e1a8@mail.gmail.com>
	 <1225037872.32713.22.camel@twins>
	 <20081027120405.1B45.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Oct 2008 08:56:30 +0100
Message-Id: <1225094190.16159.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 12:14 +0900, KOSAKI Motohiro wrote:
> > Right, and would be about 4k+sizeof(task_struct), some people might be
> > bothered, but most won't care.
> > 
> > > Perhaps, I misunderstand your intension. so can you point your
> > > previous discussion url?
> > 
> > my google skillz fail me, but once in a while people complain that we
> > have too many kernel threads.
> > 
> > Anyway, if we can re-use this per-cpu workqueue for more goals, I guess
> > there is even less of an objection.
> 
> In general, you are right.
> but this is special case. mmap_sem is really widely used various subsystem and drivers.
> (because page fault via copy_user introduce to depend on mmap_sem)
> 
> Then, any work-queue reu-sing can cause similar dead-lock easily.

Yeah, I know, and the cpu-hotplug discussion needed another thread due
to yet another locking incident. I was hoping these two could go
together.

Neither are general-purpose workqueues, both need to stay away from the
normal eventd due to deadlocks.

ego, does you extra thread ever use mmap_sem?
