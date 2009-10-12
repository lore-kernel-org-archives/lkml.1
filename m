Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbZJLPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbZJLPP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZJLPP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:15:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33429 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZJLPP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:15:26 -0400
Date: Mon, 12 Oct 2009 17:14:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012151431.GC14004@elte.hu>
References: <20091012113758.GB11035@elte.hu> <20091012140149.6789efab@marrow.netinsight.se> <20091012120951.GA16799@elte.hu> <20091012142714.56362465@marrow.netinsight.se> <20091012123210.GB22766@elte.hu> <20091012140821.5dfa1598@lxorguk.ukuu.org.uk> <20091012132503.GD25464@elte.hu> <1255354342.30919.17.camel@macbook.infradead.org> <20091012142634.GB4565@elte.hu> <1255358181.9111.14.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255358181.9111.14.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2009-10-12 at 16:26 +0200, Ingo Molnar wrote:

> > Not if the failure is say a s2ram hang that requires a power cycle. 
> > Also there are certain classes of bugs that only occur on cold boot. 
> > Plus there's the "need to unplug the battery to revive the system" 
> > class of bugs (but they are rare).
> 
> So you need to build in enough ECC to cope with the decay which 
> happens when RAM isn't being refreshed for a few seconds... :)

[ hey, i think you should line up with BIOS writers at that wall ;-) ]

> > So i think the MTD / flash stuff is powerful.
> 
> Yeah, definitely. I was just pointing out that we can actually do a 
> lot better on today's commodity hardware too.

I wish it worked on any of the 10+ x86 systems i have. Is there anyone 
who'd be interested in exploring whether warm BIOS reboots work 
_anywhere_?

A simple patch with a new (default-off) CONFIG_DEBUG_ feature that just 
puts a signature into a predictable spot in RAM, switches the reboot 
method over to warm reboot (reboot=w) and prints some friendly "yay, 
this BIOS rocks!" message if the signature is still there after a reboot 
and not zeroed out.

If that works _anywhere_ we could complete it: we could cache the dmesg 
buffer address (__log_buf[]) across reboots (and maybe the printk tail 
offset (log_end)), and that would be an _excellent_ debuggability 
feature for a large class of otherwise undebuggable crashes ...

We could use that to preserve a kernel function trace (or a branch 
execution hardware trace using BTS on Intel CPUs) across crashes, etc. 
etc.

	Ingo
