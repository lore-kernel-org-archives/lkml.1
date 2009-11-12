Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZKLL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZKLL3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZKLL3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:29:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:33806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZKLL3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:29:19 -0500
Subject: Re: [patch] sched: fix/add missing update_rq_clock() calls
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091112112734.GE24684@elte.hu>
References: <1258020464.6491.2.camel@marge.simson.net>
	 <1258023705.4039.103.camel@laptop>  <20091112112734.GE24684@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 12:29:23 +0100
Message-ID: <1258025363.4039.104.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 12:27 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2009-11-12 at 11:07 +0100, Mike Galbraith wrote:
> > > sched: fix/add missing update_rq_clock() calls.
> > > 
> > > kthread_bind(), migrate_task() and sched_fork were missing updates, and
> > > try_to_wake_up() was updating after having already used the stale clock.
> > 
> > 
> > I'm almost at the point where I think we should ditch rq->clock 
> > alltogether and simply call cpu_clock() directly when we need it. This 
> > trying to optimize and avoid calling it game has brought way too many 
> > head-aches.
> 
> It's not just about optimization - it's also accounting precision - we 
> want to handle the full act of schedule() at a single timestamp - not a 
> series of timestamps.
> 
> But ... we can get rid of it if it can be done sanely.

Ah, good point, hard to do for the migration paths though.

