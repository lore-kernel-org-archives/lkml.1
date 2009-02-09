Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZBILis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZBILis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZBILii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:38:38 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:52054 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZBILih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:38:37 -0500
Date: Mon, 9 Feb 2009 11:38:29 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check_timer cleanup
In-Reply-To: <20090209081542.GF24420@elte.hu>
Message-ID: <alpine.LFD.1.10.0902091129150.12457@ftp.linux-mips.org>
References: <20090206220716.GA15319@elte.hu> <498D55A4.7000608@kernel.org> <20090207165901.GA32116@elte.hu> <498E6A3C.6020004@kernel.org> <20090209081542.GF24420@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Ingo Molnar wrote:

> > Impact: remove extra unmask, and pair disable/enable
> > 
> > for edge trigger io-apic routing, already unmasked via setup_IO_APIC_irq,
> > so don't unmask it again.
> > 
> > also do call local_irq_disable() between timer_irq_works(), between it does call
> > local_irq_enable() inside.
> > also remove not needed apic version reading for 64bit
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> > ---
> >  arch/x86/kernel/io_apic.c |   30 ++++++++++++++++++++++--------
> >  1 file changed, 22 insertions(+), 8 deletions(-)
> 
> applied to tip/x86/apic, thanks Yinghai. Maybe this even solves some of the spurious 
> detection troubles we had in this code.

 I'll see if I can find time to look into it in details, but it looks 
dodgy to me.  The thing is setup_timer_IRQ0_pin() is special -- due to 
line rerouting it may not necessarily be called for an input already set 
up by setup_IO_APIC_irqs().  I recall keeping this mask set until ready 
for a reason when doing the cleanup last year -- I think old code actually 
used to do what the change now reintroduces.  What's the reason of this 
change?

 And timer_irq_works() used to restore the local interrupt mask within 
itself -- perhaps it should be brought back rather than cluttering code 
with local_irq_disable() calls throughout?

 What problems are you referring to, Ingo?  Perhaps they should be looked 
into specifically?

  Maciej
