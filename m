Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZCBPsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZCBPsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 10:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZCBPrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 10:47:52 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40688 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbZCBPrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 10:47:51 -0500
Date: Mon, 2 Mar 2009 08:47:48 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Message-ID: <20090302154748.GB14217@parisc-linux.org>
References: <1235996477.5330.174.camel@laptop> <20090302144303.GA30136@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302144303.GA30136@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 03:43:03PM +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> > Hi Linus,
> > 
> > Would you be willing to take such a patch?
> > 
> > Its a rather big one, but if you think its a good idea, I can 
> > generate one against whatever tree is needed.
> > 
> > Provided I didn't break any !genirq stuff.. then again, that 
> > might be a nice incentive to fix up those last few archs.
> 
> look good IMO. If there are no objections, and given that it 

Perhaps someone could explain why we want to remove it?  I just added
it to AHCI for good reason, so I'd like to know why we think it should
be taken away.

I added it because I was adding support for per-port interrupts.
In the interrupt handler, we take the *host* lock (not the port lock).
With multiple interrupt handlers per host, we would have to disable
interrupts in the interrupt handler before taking the lock.  Which is
foolish because we've just re-enabled interrupts in the genirq code.
Specifying IRQF_DISABLED means we just run with interrupts disabled.

You can argue that libata/ahci should be using a per-port lock, and
I wouldn't disagree.  But I'd still like to know why IRQF_DISABLED is
being removed.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
