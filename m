Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYHAJN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYHAJN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYHAJNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:13:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34334
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752274AbYHAJNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:13:49 -0400
Date: Fri, 01 Aug 2008 02:13:48 -0700 (PDT)
Message-Id: <20080801.021348.233313767.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [git pull] scheduler fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080801090100.GA25142@elte.hu>
References: <20080731.155504.167792984.davem@davemloft.net>
	<20080801.011122.32782916.davem@davemloft.net>
	<20080801090100.GA25142@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 1 Aug 2008 11:01:00 +0200

> I'm wondering, does this mean that Peter's:
> 
>     lockdep: change scheduler annotation
> 
> is still not good enough yet?

It doesn't work, the problem is this:

[ 7819.764377] =============================================
[ 7819.775495] [ INFO: possible recursive locking detected ]
[ 7819.780969] 2.6.27-rc1-lockdep #12
[ 7819.786256] ---------------------------------------------
[ 7819.791548] cc1/29466 is trying to acquire lock:
[ 7819.796685]  (&rq->lock/1){.+..}, at: [<0000000000455548>] double_lock_balance+0x78/0x90
[ 7819.806849] 
[ 7819.806859] but task is already holding lock:
[ 7819.815871]  (&rq->lock/1){.+..}, at: [<0000000000455538>] double_lock_balance+0x68/0x90
[ 7819.825448] 
[ 7819.825456] other info that might help us debug this:
[ 7819.834373] 1 lock held by cc1/29466:
[ 7819.838709]  #0:  (&rq->lock/1){.+..}, at: [<0000000000455538>] double_lock_balance+0x68/0x90
[ 7819.847818] 
[ 7819.847827] stack backtrace:
[ 7819.855832] Call Trace:
[ 7819.859696]  [000000000047ecac] __lock_acquire+0xbdc/0xf98
[ 7819.863669]  [000000000047f7c4] lock_acquire+0x64/0x7c
[ 7819.867613]  [00000000006d67d4] _spin_lock_nested+0x1c/0x58
[ 7819.871612]  [0000000000455548] double_lock_balance+0x78/0x90
[ 7819.875600]  [00000000006d3afc] schedule+0x324/0x8d0
[ 7819.879536]  [00000000004c089c] pipe_wait+0x58/0x8c
[ 7819.883462]  [00000000004c0c94] pipe_write+0x3c4/0x480
[ 7819.887597]  [00000000004ba150] do_sync_write+0x80/0xd0
[ 7819.891460]  [00000000004ba92c] vfs_write+0x70/0x10c
[ 7819.895264]  [00000000004bad18] sys_write+0x2c/0x60
[ 7819.899073]  [0000000000406294] linux_sparc_syscall32+0x34/0x40
