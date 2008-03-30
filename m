Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYC3Vh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYC3Vh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYC3VhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:37:18 -0400
Received: from www.tglx.de ([62.245.132.106]:45865 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYC3VhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:37:16 -0400
Date: Sun, 30 Mar 2008 23:36:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chr <chunkeey@web.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi-suse@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: The never ending BEEEEP/__smp_call_function_mask with
 2.6.25-rc7
In-Reply-To: <200803302309.52493.chunkeey@web.de>
Message-ID: <alpine.LFD.1.10.0803302315270.3219@apollo.tec.linutronix.de>
References: <200803302109.22219.chunkeey@web.de> <200803302218.52549.chunkeey@web.de> <alpine.LFD.1.10.0803302236180.3219@apollo.tec.linutronix.de> <200803302309.52493.chunkeey@web.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Chr wrote:
> > > it's "hpet" (in both cases...)
> >
> > Hmm. That should be stable. Which clock is jumping back and forth ?
> > The one in the logs or the system clock ?
> The one in the logs... (but it's because of the TSC, right?)

Yes. I thought this was fixed already in Linus tree, but I might be
wrong as usual.

Anyway, that's not the real problem; I read your original post in
meantime :)

> Ever since I went to the new 2.6.25-rcX ...

Did this problem start with 25-rc1 ? What is the latest version you
tried ?

> [ 5215.101875]  [<ffffffff80217d8f>] __smp_call_function_mask+0x90/0xc5
> [ 5215.108493]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> [ 5215.114422]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> [ 5215.120348]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> [ 5215.126276]  [<ffffffff80217e0d>] smp_call_function_mask+0x49/0x61
> [ 5215.132723]  [<ffffffff8029b433>] invalidate_bh_lru+0x0/0x42
> [ 5215.138649]  [<ffffffff802339a3>] on_each_cpu+0x10/0x2c
> [ 5215.144135]  [<ffffffff8029fb4b>] kill_bdev+0x1e/0x33
> [ 5215.149456]  [<ffffffff802a01da>] __blkdev_put+0x4f/0x128
> [ 5215.155124]  [<ffffffff8027dd93>] __fput+0xa1/0x164
> [ 5215.160272]  [<ffffffff8027b67d>] filp_close+0x5d/0x65
> [ 5215.165679]  [<ffffffff80231072>] put_files_struct+0x66/0xc4
> [ 5215.171607]  [<ffffffff802323ea>] do_exit+0x245/0x64c
> [ 5215.176925]  [<ffffffff80238b94>] __dequeue_signal+0xff/0x159
> [ 5215.182941]  [<ffffffff80232867>] do_group_exit+0x76/0x93
> [ 5215.188606]  [<ffffffff8023a0fd>] get_signal_to_deliver+0x2b9/0x2e5
> [ 5215.195141]  [<ffffffff8020a466>] do_notify_resume+0xaf/0x7e0
> [ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86
> [ 5215.201155]  [<ffffffff80291414>] mntput_no_expire+0x1f/0x86

You mentioned that you have tons of other logs. Can you please
upload those to some place? If you don't have a possiblity, please
contact me private and I'll provide you one.

Thanks,

	tglx
