Return-Path: <linux-kernel-owner+w=401wt.eu-S965724AbXDWKTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965724AbXDWKTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXDWKTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:19:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965724AbXDWKTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:19:06 -0400
Date: Mon, 23 Apr 2007 12:18:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: Re: crash with CFS v4 and qemu/kvm (was: [patch] CFS scheduler, v4)
Message-ID: <20070423101839.GA19599@elte.hu>
References: <20070420140457.GA14017@elte.hu> <200704231128.23594.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704231128.23594.mail@earthworm.de>
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


* Christian Hesse <mail@earthworm.de> wrote:

> On Friday 20 April 2007, Ingo Molnar wrote:
> > i'm pleased to announce release -v4 of the CFS patchset.
> 
> Hi Ingo, hi Avi, hi all,
> 
> I'm trying to use kvm-20 with cfs v4 and get a crash:
> 
> eworm@revo:~$ /usr/local/kvm/bin/qemu -snapshot /mnt/data/virtual/qemu/winxp.img
> kvm_run: failed entry, reason 7
> kvm_run returned -8
> 
> It works (though it is a bit slow) if I start qemu with strace, so for 
> me it looks like a race condition?

hm. Can you work it around with:

   echo 0 > /proc/sys/kernel/sched_granularity_ns

?

If yes then this is a wakeup race: some piece of code relies on the 
upstream scheduler preempting the waker task immediately in 99% of the 
cases.

and you might want to test -v5 too which i released earlier today. It 
has no bugfix in this area though, so it will likely still trigger this 
race - but it will also hopefully be even more pleasant to use than -v4 
;-)

	Ingo
