Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbZGIOvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbZGIOvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZGIOv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:51:27 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:21498 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759070AbZGIOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:51:26 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] netpoll: Fix carrier detection for drivers that are
 using phylib
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1247150580.21295.937.camel@calx>
References: <20090707235812.GA12824@oksana.dev.rtsoft.ru>
	 <20090708005000.GA12380@redhat.com> <1247034263.9777.24.camel@twins>
	 <alpine.LFD.2.01.0907080907210.3210@localhost.localdomain>
	 <20090708141024.f8b581c5.akpm@linux-foundation.org>
	 <20090708213331.GA9346@oksana.dev.rtsoft.ru>
	 <20090708144744.5555b88d.akpm@linux-foundation.org>
	 <20090708222003.GA12318@oksana.dev.rtsoft.ru>
	 <alpine.LFD.2.01.0907081701050.3352@localhost.localdomain>
	 <1247145977.21295.899.camel@calx>  <1247147206.7439.2.camel@twins>
	 <1247149093.21295.915.camel@calx>  <1247149862.12784.6.camel@twins>
	 <1247150580.21295.937.camel@calx>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 16:51:19 +0200
Message-Id: <1247151079.12784.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 09:43 -0500, Matt Mackall wrote:

> Yeah, that's what I had in mind. Probably throw in a define:
> 
> /* for disabling scheduling in early boot */
> #define PREEMPT_EARLY (1 + PREEMPT_ACTIVE)
> 
> and slap a comment on the sub_preempt_count().

Right, and visit all the other arch init code ;-)

I'll wait to see if Ingo has anything to say about it and then complete
this thing.

> Does anything actually use scheduler_running yet? Perhaps my tree is
> old.

# git grep scheduler_running
kernel/sched.c:static __read_mostly int scheduler_running;
kernel/sched.c: scheduler_running = 1;
kernel/sched_rt.c:      if (unlikely(!scheduler_running))
kernel/sched_rt.c:      if (unlikely(!scheduler_running))

If memory serves there used to be more, but I think that migrated into
kernel/sched_clock.c, which has sched_clock_running.

> Also, might_sleep's use of system_state probably bears revisiting.

Yeah, all that code is from long before we had scheduler_running (which
was introduced around CFS/.23).

