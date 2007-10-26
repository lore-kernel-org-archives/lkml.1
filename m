Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbXJZPWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbXJZPWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762242AbXJZPWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:22:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45374 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763055AbXJZPWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:22:41 -0400
Date: Fri, 26 Oct 2007 17:22:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.24-rc1: First impressions
Message-ID: <20071026152221.GA26619@elte.hu>
References: <796505.25770.qm@web32612.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796505.25770.qm@web32612.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Knoblauch <spamtrap@knobisoft.de> wrote:

> Hi ,
> 
>  just to give some feedback on 2.6.24-rc1. For some time I am tracking 
>  IO/writeback problems that hurt system responsiveness big-time. I 
>  tested Peters stuff together with Fenguangs additions and it looked 
>  promising. Therefore I was very happy to see Peters stuff going into 
>  2.6.24 and waited eagerly for rc1. In short, I am impressed. This 
>  really looks good. IO throughput is great and I could not reproduce 
>  the responsiveness problems so far.
> 
>  Below are a some numbers of my brute-force I/O tests that I can use 
>  to bring responsiveness down. My platform is a HP/DL380g4, dual CPUs, 
>  HT-enabled, 8 GB Memory, SmartaArray6i controller with 4x72GB SCSI 
>  disks as RAID5 (battery protected writeback cahe enabled) and gigabit 
>  networking (tg3). User space is 64-bit RHEL4.3
> 
>  I am basically doing copies using "dd" with 1MB blocksize. Local 
>  Filesystem ist ext2 (noatime). IO-Scheduler is dealine, as it tends 
>  to give best results. NFS3 Server is a Sun/T2000/Solaris10. The tests 
>  are:
> 
> dd1 - copy 16 GB from /dev/zero to local FS
> dd1-dir - same, but using O_DIRECT for output
> dd2/dd2-dir - copy 2x7.6 GB in parallel from /dev/zero to local FS
> dd3/dd3-dir - copy 3x5.2 GB in parallel from /dev/zero lo local FS
> net1 - copy 5.2 GB from NFS3 share to local FS
> mix3 - copy 3x5.2 GB from /dev/zero to local disk and two NFS3 shares
> 
>  I did the numbers for 2.6.19.2, 2.6.22.6 and 2.6.24-rc1. All units 
>  are MB/sec.
> 
> test           2.6.19.2     2.6.22.6    2.6.24.-rc1
> ----------------------------------------------------------------
> dd1                  28           50             96
> dd1-dir              88           88             86
> dd2              2x16.5         2x11         2x44.5
> dd2-dir            2x44         2x44           2x43
> dd3               3x9.8        3x8.7           3x30
> dd3-dir          3x29.5       3x29.5         3x28.5
> net1              30-33        50-55          37-52
> mix3              17/32        25/50          96/35 (disk/combined-network)

wow, really nice results! Peter does know how to make stuff fast :) Now 
lets pick up some of Peter's other, previously discarded patches as well
:-)

Such as the rewritten reclaim (clockpro) patches:

  http://programming.kicks-ass.net/kernel-patches/page-replace/

The improve-swap-performance (swap-token) patches:

  http://programming.kicks-ass.net/kernel-patches/swap_token/

His enable-swap-over-NFS [and other complex IO transports] patches:

  http://programming.kicks-ass.net/kernel-patches/vm_deadlock/

And the concurrent pagecache patches:

  http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/

as a starter :-) I think the MM should get out of deep-feature-freeze 
mode - there's tons of room to improve :-/

	Ingo "runs and hides" Molnar
