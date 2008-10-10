Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbYJJREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbYJJREt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758926AbYJJREl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:04:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbYJJREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:04:40 -0400
Date: Fri, 10 Oct 2008 19:04:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #2 - PAT updates
Message-ID: <20081010170426.GA5947@elte.hu>
References: <20081009234951.GA24349@elte.hu> <alpine.LFD.2.00.0810100920370.3503@nehalem.linux-foundation.org> <20081010164537.GA23664@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010164537.GA23664@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> v2 worked well in testing:
> 
>   http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/2375.html
> 
> So it's basically a v1 -> v2 sequence, with artificial reverts 
> surviving unintentionally. That's why there were no revert messages 
> either: i never intended them to become public. I even rember having 
> taken a good look at "git diff 6b5b551..6e3e492", which the v1->v2 
> delta was.

here's the linearized history of the commits (older commits go last):

6e3e492: x86: track memtype for RAM in page struct
09543b6d: x86, cpa: srlz cpa(), global flush tlb after splitting big page and before doing cpa
eaaa6c4: x86, cpa: remove cpa pool code
ef91bf0: x86, cpa: no need to check alias for __set_pages_p/__set_pages_np
8e1701f: x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
065ae73: x86, cpa: make the kernel physical mapping initialization a two pass sequence
eb60b73: x86, cpa: remove USER permission from the very early identity mapping attribute
fabf99f: x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
abfae7f6: Revert "x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot"
f279399: Revert "x86, cpa: remove USER permission from the very early identity mapping attribute"
153eb23: Revert "x86, cpa: make the kernel physical mapping initialization a two pass sequence"
f5c3489: Revert "x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC"
c613e65: Revert "x86, cpa: fix taking the pgd_lock with interrupts off"
e64b1f1: Revert "x86, cpa: remove cpa pool code"
94448e3: Revert "x86, cpa: global flush tlb after splitting large page and before doing cpa"
aca9b5f: Revert "x86: track memtype for RAM in page struct"
6375b67: Revert "x86: handle error returns in set_memory_*()"
6b5b551: x86: handle error returns in set_memory_*()
5f25f5b: x86: track memtype for RAM in page struct
3196625: x86, cpa: global flush tlb after splitting large page and before doing cpa
79abc89: x86, cpa: remove cpa pool code
e96d59b: x86, cpa: fix taking the pgd_lock with interrupts off
888fdd9: x86, cpa: dont use large pages for kernel identity mapping with DEBUG_PAGEALLOC
e579af6: x86, cpa: make the kernel physical mapping initialization a two pass sequence
c86eefc: x86, cpa: remove USER permission from the very early identity mapping attribute
e8729a5: x86, cpa: rename PTE attribute macros for kernel direct mapping in early boot
f81b691: Merge commit 'v2.6.27-rc6' into x86/pat

e8729a5..6b5b551 was v1, fabf99f..6e3e492 is v2. The reverts in 
6375b67..abfae7f6 are a mirror image of v1 and were supposed to be 
squashed together into a delta commit.

the time gap between v1 and v2 was rather large, 10 days:

 CommitDate: Sun Sep 14 17:50:41 2008 +0200
 CommitDate: Wed Sep 24 10:07:52 2008 +0200

because it took time to find and track down the lockup, and it also took 
time to come up with the fix. So i definitely wanted a delta fix (we 
handle another 150 append-only commits in a 10 day timespan so a delta 
fix is the right approach), but messed up its generation.

	Ingo
