Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDWDJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDWDJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526AbXDWDJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:09:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50314 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXDWDJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:09:06 -0400
Date: Mon, 23 Apr 2007 05:08:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070423030800.GC10407@elte.hu>
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423012509.GA25162@wotan.suse.de> <200704222239.40818.gene.heskett@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704222239.40818.gene.heskett@gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gene Heskett <gene.heskett@gmail.com> wrote:

> I haven't approached that yet, but I just noticed, having been booted 
> to this for all of 5 minutes, that although I told it not to renice x 
> when my script ran 'make oldconfig', and I answered n, but there it 
> is, sitting at -19 according to htop.
> 
> The .config says otherwise:
> [root@coyote linux-2.6.21-rc7-CFS-v5]# grep RENICE .config
> # CONFIG_RENICE_X is not set
> 
> So v5 reniced X in spite of the 'no' setting.

Hmm, apparently your X uses ioperm() while mine uses iopl(), and i only 
turned off the renicing for iopl. (I fixed this in my tree and it will 
show up in -v6.)

> Although I hadn't noticed it, one way or the other, I just set it (X) 
> back to the default -1 so that I'm comparing the same apples when I do 
> compare.

note that CFS handles negative nice levels differently from other 
schedulers, so the disadvantages of agressively reniced X (lost 
throughput due to overscheduling, worse interactivity) do _not_ apply to 
CFS.

I think the 'fair' setting would be whatever the scheduler writer 
recommends: for SD, X probably performs better at around nice 0 (i'll 
let Con correct me if his experience is different). On CFS, nice -10 is 
perfectly fine too, and you'll have a zippier desktop under higher 
loads. (on servers this might be unnecessary/disadvantegous so there 
this can be turned off.)

(also, in my tree i've changed the default from -19 to -10 to make it 
less scary to people and to leave more levels to the sysadmin, this 
change too will show up in -v6.)

	Ingo
