Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZGGNW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZGGNW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZGGNWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:22:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48808 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755769AbZGGNWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:22:49 -0400
Subject: Re: kmemleak not tainted
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20090707131725.GB3238@localdomain.by>
References: <20090707115128.GA3238@localdomain.by>
	 <1246970859.9451.34.camel@pc1117.cambridge.arm.com>
	 <20090707131725.GB3238@localdomain.by>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 07 Jul 2009 14:22:21 +0100
Message-Id: <1246972941.9451.44.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 13:22:22.0141 (UTC) FILETIME=[F5DA3ED0:01C9FF05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 16:17 +0300, Sergey Senozhatsky wrote:
> > On Tue, 2009-07-07 at 14:51 +0300, Sergey Senozhatsky wrote:
> > > kernel: [ 1917.133154] INFO: RCU detected CPU 0 stall (t=485140/3000 jiffies)
[...]
> > What I think happens is that the kmemleak thread runs for several
> > seconds for scanning the memory and there may not be any context
> > switches. I have a patch to add more cond_resched() calls throughout the
> > kmemleak_scan() function which I hope will get merged. 
[...]
> > I don't get any  of these messages with CONFIG_PREEMPT enabled.
> 
> It started with rc2-git1 (may be). Almost every scan ends with RCU pending.

Should I assume that CONFIG_PREEMPT is disabled on your system?

The branch with the pending kmemleak patches is below (I sent Linus a
pull request):

http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=kmemleak

You can try the "Add more cond_resched() calls..." patch and see if it
makes any difference.

> Hm.. Something is broken...
> cat /.../kmemleak
> [ 7933.537868] ================================================
> [ 7933.537873] [ BUG: lock held when returning to user space! ]
> [ 7933.537876] ------------------------------------------------
> [ 7933.537880] cat/2897 is leaving the kernel with locks still held!
> [ 7933.537884] 1 lock held by cat/2897:
> [ 7933.537887]  #0:  (scan_mutex){+.+.+.}, at: [<c10f717c>] kmemleak_open+0x4c/0x80

That the "Do not acquire scan_mutex in kmemleak_open()" patch in the
same branch.

-- 
Catalin

