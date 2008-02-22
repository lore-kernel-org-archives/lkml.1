Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbYBVMuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbYBVMuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYBVMtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:49:53 -0500
Received: from colin.muc.de ([193.149.48.1]:1174 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYBVMtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:49:52 -0500
Date: 22 Feb 2008 13:49:50 +0100
Date: Fri, 22 Feb 2008 13:49:50 +0100
From: Andi Kleen <ak@muc.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>
Subject: Re: arch/x86/kernel/vsyscall_64.c: overeager NOP of syscalls
Message-ID: <20080222124950.GA81921@muc.de>
References: <kjm4pc3d92p.fsf@pelargir.dolphinics.no> <20080221155852.GA42442@muc.de> <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802212039240.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 08:45:53PM +0100, Thomas Gleixner wrote:
> On Thu, 21 Feb 2008, Andi Kleen wrote:
> 
> > On Wed, Feb 20, 2008 at 02:57:34PM +0100, Arne Georg Gleditsch wrote:
> > > Hi,
> > > 
> > > I'm looking at 2.6.25-rc2.  vsyscall_sysctl_change contains code to NOP
> > > out the actual system call instructions of the vsyscall page when
> > > vsyscall64 is enabled.  This seems to interact badly with the fallback
> > > code in do_vgettimeofday which tries to call gettimeofday if the
> > > configured clock source does not support vread.  (In effect,
> > > gettimeofday() becomes a nop and time() always returns 0.  Not very
> > > useful.)
> > > 
> > > Is there a good reason to keep this?  Aren't the instructions in
> > > question avoided (or invoked) according to the vsyscall64 flag by the
> > > surrounding logic anyway?
> > 
> > Yes they are.  But a system call sequence at a known fixed address
> > is potentially useful to exploits. That is why it is nop'ed out when
> > it is not needed.
> 
> That's a nice intent, but the reality is that this code is broken as
> hell:

Well it worked when I wrote it, but it's quite possible it didn't survive
the clocksource conversion completely.

-Andi
