Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbZEQUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbZEQUCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZEQUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:02:28 -0400
Received: from tservice.ru ([195.178.208.66]:40651 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZEQUC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:02:27 -0400
Date: Mon, 18 May 2009 00:02:23 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       davem@davemloft.net, dada1@cosmosbay.com, jeff.chua.linux@gmail.com,
       paulus@samba.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, benh@kernel.crashing.org, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH RFC] v5 expedited "big hammer" RCU grace periods
Message-ID: <20090517200223.GA31029@ioremap.net>
References: <20090517191141.GA25915@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090517191141.GA25915@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, May 17, 2009 at 12:11:41PM -0700, Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> Fifth cut of "big hammer" expedited RCU grace periods.  This uses per-CPU
> kthreads that are scheduled in parallel by a call to smp_call_function()
> by yet another kthread.  The synchronize_sched(), synchronize_rcu(),
> and synchronize_bh() primitives wake this kthread up and then wait for
> it to force the grace period.

I'm curious, but doesn't the fact that registered 'barrier' callback is
invoked mean grace period completion? I.e. why to bother with
rescheduling, waiting for thread to complete and so on, when we only
care in the fact that 'barrier' callback is invoked, and thus all
previous ones are completed?
Or it is done just for the simplicity, since all rescheduling machinery
already manages the rcu bits correctly, so you do not want to put it
directly into 'barrier' callback?

-- 
	Evgeniy Polyakov
