Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbZIOSvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbZIOSvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZIOSvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:51:12 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44661 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIOSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:51:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iWP13MNaBSZLY8qh11e1dWa1p0zbvxSb9fwYpQ71wWK1zWzG96HDqRIhXW1AOtq+pe
         i5R3SrKqQddQys1vckv6EUH+iArQ4CLEnOfgvhBk1eoTw/fyBVUXekmigBIqlbdf3zR5
         dlHU8ILBHDrZlDieDSr4aveV7KAvwFGiedER4=
Date: Tue, 15 Sep 2009 22:51:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [crash] kernel BUG at net/core/pktgen.c:3503!
Message-ID: <20090915185112.GA17587@lenovo>
References: <20090911.202543.52533792.davem@davemloft.net> <20090915183647.GA11628@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915183647.GA11628@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Tue, Sep 15, 2009 at 08:36:47PM +0200]
| 
| not sure which merge caused this, but i got this boot crash with latest 
| -git:
| 
| calling  flow_cache_init+0x0/0x1b9 @ 1
| initcall flow_cache_init+0x0/0x1b9 returned 0 after 64 usecs
| calling  pg_init+0x0/0x37c @ 1
| pktgen 2.72: Packet Generator for packet performance testing.
| ------------[ cut here ]------------
| kernel BUG at net/core/pktgen.c:3503!
| invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
| last sysfs file: 
| 

Hi Ingo,

just curious, will the following patch fix the problem?
I've been fixing problem with familiar symthoms on
system with custome virtual cpu implementation so
it may not help in mainline but anyway :)

	-- Cyrill
---
 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/net/core/pktgen.c
=====================================================================
--- linux-2.6.git.orig/net/core/pktgen.c
+++ linux-2.6.git/net/core/pktgen.c
@@ -3511,7 +3511,7 @@ static int pktgen_thread_worker(void *ar
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	BUG_ON(smp_processor_id() != cpu);
+	BUG_ON(task_cpu(current) != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
