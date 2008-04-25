Return-Path: <linux-kernel-owner+w=401wt.eu-S1758052AbYDYDq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbYDYDq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYDYDqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:46:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49156
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753355AbYDYDqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:46:20 -0400
Date: Thu, 24 Apr 2008 20:46:20 -0700 (PDT)
Message-Id: <20080424.204620.88617191.davem@davemloft.net>
To: mingo@elte.hu
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] scheduler/misc fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080424225530.GA8717@elte.hu>
References: <20080424225530.GA8717@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 25 Apr 2008 00:55:30 +0200

> 
> Linus, please pull the latest scheduler/misc fixes git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-fixes.git for-linus
> 
> a scheduler fix, a (long-standing) seqlock fix and a softlockup+nohz 
> fix.

Correction, the softlock+nohz patch here doesn't actually fix the
reported regression.  It fixes some other theoretical bug you
discovered while trying to fix the regression reports.

Ingo, you've known exactly which changeset adds the regression for
more than 4 days now.

It's a small changeset, and you have no idea what the problem is.  The
changeset in question is labelled as a bug fix, but it's pointless for
it to be there if it adds problems too.

Please revert this change until you understand the problem better.
Please!  I even gave Peter Z. access to my Niagara2 system, so you can
ask him to help you figure out the reason for all of these softlockup
regressions added by the sched merge 4 days ago.

Please also add the trivial regression fix I posted to you earlier,
included again below, you seem to be selectively reading email from me
and missing bug fix patches in the process.

sched: Use alloc_bootmem() instead of alloc_bootmem_low()

There is no guarentee that there is physical ram below 4GB, and in
fact many boxes don't have exactly that.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/kernel/sched.c b/kernel/sched.c
index 0014b03..09ca69b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8128,7 +8128,7 @@ void __init sched_init(void)
 	 * we use alloc_bootmem().
 	 */
 	if (alloc_size) {
-		ptr = (unsigned long)alloc_bootmem_low(alloc_size);
+		ptr = (unsigned long)alloc_bootmem(alloc_size);
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 		init_task_group.se = (struct sched_entity **)ptr;
