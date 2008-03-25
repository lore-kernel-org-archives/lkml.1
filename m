Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYCYThT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYCYThT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756280AbYCYThI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:37:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53113 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbYCYThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:37:06 -0400
Date: Tue, 25 Mar 2008 19:30:05 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, paulus@samba.org,
       ralf@linux-mips.org, davem@davemloft.net, lethal@linux-sh.org,
       jdike@addtoit.com
Subject: Re: tick-common.c hack for s390 needed
Message-ID: <20080325193004.GA11412@flint.arm.linux.org.uk>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de> <20080322203223.GA31521@osiris.boeblingen.de.ibm.com> <20080323223455.GA746@flint.arm.linux.org.uk> <alpine.LFD.1.00.0803252002100.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803252002100.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 08:09:15PM +0100, Thomas Gleixner wrote:
> On Sun, 23 Mar 2008, Russell King wrote:
> 
> > On Sat, Mar 22, 2008 at 09:32:23PM +0100, Heiko Carstens wrote:
> > > Generic code is not supposed to include irq.h. Replace this include
> > > by linux/hardirq.h instead and add/replace an include of linux/irq.h
> > > in asm header files where necessary.
> > > This change should only matter for architectures that make use of
> > > GENERIC_CLOCKEVENTS.
> > > Architectures in question are mips, x86, arm, sh, powerpc, uml and sparc64.
> > > 
> > > I did some cross compile tests for mips, x86_64, arm, powerpc and sparc64.
> > > This patch fixes also build breakages caused by the include replacement in
> > > tick-common.h.
> > 
> > I generally dislike adding optional linux/* includes in asm/* includes -
> > I'm nervous about this causing include loops.
> > 
> > However, there's a separate point to be discussed here.
> > 
> > That is, what interfaces are expected of every architecture in the kernel.
> > If generic code wants to be able to set the affinity of interrupts, then
> > that needs to become part of the interfaces listed in linux/interrupt.h
> > rather than linux/irq.h.
> > 
> > So what I suggest is this approach instead (against Linus' tree of a
> > couple of days ago) - we move irq_set_affinity() and irq_can_set_affinity()
> > to linux/interrupt.h, change the linux/irq.h includes to linux/interrupt.h
> > and include asm/irq_regs.h where needed (asm/irq_regs.h is supposed to be
> > rarely used include since not much touches the stacked parent context
> > registers.)
> 
> That patch makes a lot of sense and resolves all the issues. 
> 
> I push it through hrt.git and add the GENERIC_HARDIRQS dependency
> which was requested by Heiko.

Okay.  Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
