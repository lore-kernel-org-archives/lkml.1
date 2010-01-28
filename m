Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155Ab0A1KWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0A1KWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 05:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966Ab0A1KWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 05:22:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:47181 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0A1KWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 05:22:08 -0500
Subject: Re: [PATCH] Add type of locks to lock trace events
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, tglx@linutronix.de, gregkh@suse.de
In-Reply-To: <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1263799219.4283.0.camel@laptop>
	 <1264485404-6410-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 11:21:53 +0100
Message-ID: <1264674113.4283.2086.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 14:56 +0900, Hitoshi Mitake wrote:
> # Sorry, I wrote wrong Cc address. Previous mail was rejected by mailer-daemon.
> # This is second time sending, if you already received this, please discard it...
> 
> There's no need to add any member to lockdep_map
> for adding information of type of locks to lock trace events.
> 
> Example of perf trace:
> |       init-0     [001]   335.078670: lock_acquired: 0xffff8800059d6bd8 &rq->lock kernel/lockdep.c:2973 (0 ns)
> |       rb_consumer-424   [001]   335.078673: lock_acquire: 0xffff8800059d6bd8 1 &rq->lock kernel/lockdep.c:2973
> |                                                                            # ^ &rq->lock is spin lock!
> |       rb_consumer-424   [001]   335.078677: lock_acquire: 0xffff8800bba5e8e8 1 buffer->reader_lock_key kernel/trace/ring_
> |       rb_consumer-424   [001]   335.078679: lock_acquired: 0xffff8800bba5e8e8 buffer->reader_lock_key kernel/trace/ring_b
> |       rb_consumer-424   [001]   335.078684: lock_acquire: 0xffff8800059d12e8 1 &q->lock kernel/smp.c:83
> 
> Of course, as you told, type of lock dealing with is clear for human.
> But it is not clear for programs like perf lock.
> 
> What I want to do is limiting types of lock focus on.
> e.g. perf lock prof --type spin,rwlock
> 
> How do you think, Peter?

I still don't see the use for it, surely you're going to be familiar
with the code if you're looking at lock statistics?

