Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYKEJPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYKEJPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYKEJOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:14:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43220 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYKEJOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:14:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: next-20081103 - possible circular locking dependency detected while bring up eth1
Cc: kosaki.motohiro@jp.fujitsu.com,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       mel@csn.ul.ie
In-Reply-To: <1225871332.7803.2626.camel@twins>
References: <20081105071306.GB10881@linux.vnet.ibm.com> <1225871332.7803.2626.camel@twins>
Message-Id: <20081105181242.9688.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  5 Nov 2008 18:14:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [   31.989072] 2 locks held by events/3/18:
> > [   31.989072]  #0:  (events){--..}, at: [<c04367bf>] run_workqueue+0x80/0x189
> > [   31.989072]  #1:  ((linkwatch_work).work){--..}, at: [<c04367bf>] run_workqueue+0x80/0x189
> > [   31.989072] 
> > [   31.989072] stack backtrace:
> > [   31.989072] Pid: 18, comm: events/3 Not tainted 2.6.28-rc3-next-20081103-autotest #1
> > [   31.989072] Call Trace:
> > [   31.989072]  [<c0445662>] print_circular_bug_tail+0xa4/0xaf
> > [   31.989072]  [<c0445c10>] validate_chain+0x5a3/0xb35
> > [   31.989072]  [<c0446822>] __lock_acquire+0x680/0x70e
> > [   31.989072]  [<c04367bf>] ? run_workqueue+0x80/0x189
> > [   31.989072]  [<c044690d>] lock_acquire+0x5d/0x7a
> > [   31.989072]  [<c05e8ef5>] ? rtnl_lock+0xf/0x11
> > [   31.989072]  [<c0651c04>] mutex_lock_nested+0xdf/0x251
> > [   31.989072]  [<c05e8ef5>] ? rtnl_lock+0xf/0x11
> > [   31.989072]  [<c05e8ef5>] ? rtnl_lock+0xf/0x11
> > [   31.989072]  [<c05e8ef5>] rtnl_lock+0xf/0x11
> > [   31.989072]  [<c05ea07a>] linkwatch_event+0x8/0x27
> > [   31.989072]  [<c04367fd>] run_workqueue+0xbe/0x189
> > [   31.989072]  [<c04367bf>] ? run_workqueue+0x80/0x189
> > [   31.989072]  [<c05ea072>] ? linkwatch_event+0x0/0x27
> > [   31.989072]  [<c043713f>] ? worker_thread+0x0/0xbf
> > [   31.989072]  [<c04371f3>] worker_thread+0xb4/0xbf
> > [   31.989072]  [<c0439765>] ? autoremove_wake_function+0x0/0x33
> > [   31.989072]  [<c04396a6>] kthread+0x3b/0x61
> > [   33.690691] tg3: eth1: Link is up at 100 Mbps, full duplex.
> > [   33.690696] tg3: eth1: Flow control is off for TX and off for RX.
> > [   31.989072]  [<c043966b>] ? kthread+0x0/0x61
> > [   31.989072]  [<c040481b>] kernel_thread_helper+0x7/0x10
> > [   33.762336] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> > [  OK  ]
> 
> I think we have to go with Kosaki-san's vm workqueue...

Very sorry for my lazyness.
akpm did nak vm workqueue patch.

So I prepare new patch now. (it is under testing now)
I expect I can post it tommorow.

Thanks.




