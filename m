Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJ0DPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJ0DPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 23:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYJ0DO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 23:14:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43346 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJ0DO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 23:14:56 -0400
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
In-Reply-To: <1225037872.32713.22.camel@twins>
References: <2f11576a0810260851h15cb7e1ahb454b70a2e99e1a8@mail.gmail.com> <1225037872.32713.22.camel@twins>
Message-Id: <20081027120405.1B45.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 27 Oct 2008 12:14:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, and would be about 4k+sizeof(task_struct), some people might be
> bothered, but most won't care.
> 
> > Perhaps, I misunderstand your intension. so can you point your
> > previous discussion url?
> 
> my google skillz fail me, but once in a while people complain that we
> have too many kernel threads.
> 
> Anyway, if we can re-use this per-cpu workqueue for more goals, I guess
> there is even less of an objection.

In general, you are right.
but this is special case. mmap_sem is really widely used various subsystem and drivers.
(because page fault via copy_user introduce to depend on mmap_sem)

Then, any work-queue reu-sing can cause similar dead-lock easily.


So I think we have two choices (nick explained it at this thread).

(1) own workqueue (the patch)
(2) avoid lru_add_drain_all completely


if you really strongly hate (1), we should target to (2) IMO.

Thought?



