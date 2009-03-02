Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbZCBQA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbZCBQA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 11:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZCBQAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 11:00:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:50623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbZCBQAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 11:00:05 -0500
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
From: Peter Zijlstra <peterz@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090302154748.GB14217@parisc-linux.org>
References: <1235996477.5330.174.camel@laptop>
	 <20090302144303.GA30136@elte.hu>  <20090302154748.GB14217@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:59:48 +0100
Message-Id: <1236009588.5330.729.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 08:47 -0700, Matthew Wilcox wrote:
> On Mon, Mar 02, 2009 at 03:43:03PM +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > Hi Linus,
> > > 
> > > Would you be willing to take such a patch?
> > > 
> > > Its a rather big one, but if you think its a good idea, I can 
> > > generate one against whatever tree is needed.
> > > 
> > > Provided I didn't break any !genirq stuff.. then again, that 
> > > might be a nice incentive to fix up those last few archs.
> > 
> > look good IMO. If there are no objections, and given that it 
> 
> Perhaps someone could explain why we want to remove it?  I just added
> it to AHCI for good reason, so I'd like to know why we think it should
> be taken away.
> 
> I added it because I was adding support for per-port interrupts.
> In the interrupt handler, we take the *host* lock (not the port lock).
> With multiple interrupt handlers per host, we would have to disable
> interrupts in the interrupt handler before taking the lock.  Which is
> foolish because we've just re-enabled interrupts in the genirq code.
> Specifying IRQF_DISABLED means we just run with interrupts disabled.
> 
> You can argue that libata/ahci should be using a per-port lock, and
> I wouldn't disagree.  But I'd still like to know why IRQF_DISABLED is
> being removed.

The idea is to mandate IRQF_DISABLED for everybody, and since it doesn't
do any good to have it a flag if you have it always enabled, remove
it ;-)



