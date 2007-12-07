Return-Path: <linux-kernel-owner+w=401wt.eu-S1751396AbXLGFH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbXLGFH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 00:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXLGFHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 00:07:14 -0500
Received: from gherkin.frus.com ([192.158.254.49]:58887 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbXLGFHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 00:07:12 -0500
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
In-Reply-To: <20071206163305.c3587675.akpm@linux-foundation.org>
 "from Andrew Morton at Dec 6, 2007 04:33:05 pm"
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 6 Dec 2007 23:07:08 -0600 (CST)
CC: Bob Tracy <rct@frus.com>, mingo@elte.hu, mcree@orcon.net.nz,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net,
       ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org,
       kay.sievers@vrfy.org, greg@kroah.com
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071207050709.110D2DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> commit 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> Merge: 2f1f53b... d90bf5a...
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Wed Nov 14 18:51:48 2007 -0800
> 
>     Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/n
>     
>     * 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6:
>       [NET]: rt_check_expire() can take a long time, add a cond_resched()
>       [ISDN] sc: Really, really fix warning
>       [ISDN] sc: Fix sndpkt to have the correct number of arguments
>       [TCP] FRTO: Clear frto_highmark only after process_frto that uses it
>       [NET]: Remove notifier block from chain when register_netdevice_notifier f
>       [FS_ENET]: Fix module build.
>       [TCP]: Make sure write_queue_from does not begin with NULL ptr
>       [TCP]: Fix size calculation in sk_stream_alloc_pskb
>       [S2IO]: Fixed memory leak when MSI-X vector allocation fails
>       [BONDING]: Fix resource use after free
>       [SYSCTL]: Fix warning for token-ring from sysctl checker
>       [NET] random : secure_tcp_sequence_number should not assume CONFIG_KTIME_S
>       [IWLWIFI]: Not correctly dealing with hotunplug.
>       [TCP] FRTO: Plug potential LOST-bit leak
>       [TCP] FRTO: Limit snd_cwnd if TCP was application limited
>       [E1000]: Fix schedule while atomic when called from mii-tool.
>       [NETX]: Fix build failure added by 2.6.24 statistics cleanup.
>       [EP93xx_ETH]: Build fix after 2.6.24 NAPI changes.
>       [PKT_SCHED]: Check subqueue status before calling hard_start_xmit
> 
> I'm struggling to see how any of those could have broken block device
> mounting on alpha.  Are you sure you bisected right?

Based on what's in that commit, it *does* appear something went wrong
with bisection.  If the implicated commit is the next one in time
sequence relative to

# good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better

then the test of whether I bisected correctly is as simple as applying
the commit and seeing if things break, because I'm running on the
kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right
now.  Let me give that a try and I'll report back.  Worst case, I'll
have to start over and write off the past four days...

Sorry about this...

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
