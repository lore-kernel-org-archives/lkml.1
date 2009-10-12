Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbZJLTPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbZJLTPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbZJLTPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:15:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbZJLTPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:15:53 -0400
Date: Mon, 12 Oct 2009 21:14:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] panic.c: export panic_on_oops
Message-ID: <20091012191453.GK17138@elte.hu>
References: <20091012120951.GA16799@elte.hu> <1255349748.10605.13.camel@macbook.infradead.org> <20091012122023.GA19365@elte.hu> <20091012150650.51a4b4dc@marrow.netinsight.se> <20091012131528.GC25464@elte.hu> <20091012153937.0dcd73e5@marrow.netinsight.se> <alpine.LFD.2.01.0910120828390.3438@localhost.localdomain> <20091012110954.67d7d8d8.akpm@linux-foundation.org> <20091012182346.GH17138@elte.hu> <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 12 Oct 2009, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > Perhaps oops_enter() is a good place to mark the start of the log, and 
> > > flush it within oops_exit().
> > 
> > Simplest would be to do the last 2K in oops_exit()? That gives the 
> > oops, and the history leading up to it. Since the blocking is 2K, 
> > the extra log output is for free.
> 
> I agree, except I don't think it should be fixed to 2k.

Yeah - i cited 2K only because that is what mtdoops uses.

>       	void dump_kmsg(void)
> [...]
>
> Look ma, no locking, no buffer allocations, no nothing.

Neat ...

This could also be used for a warm-reboot preserve-memory thing as well. 
A well-known 4K (or so) area to preserve and print out during the next 
bootup after a crash. dump_kmsg() could copy the kernel's last will out 
to that area, or so.

That would be cross-kernel compatible and the newly booted kernel image 
wouldnt overwrite this area. (which it does currently via its 
__log_buf[])

	Ingo
