Return-Path: <linux-kernel-owner+w=401wt.eu-S965197AbXCQKdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965197AbXCQKdx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965309AbXCQKdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:33:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbXCQKdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:33:53 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Arjan van de Ven <arjan@infradead.org>
To: Len Brown <lenb@kernel.org>
Cc: tglx@linutronix.de, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
In-Reply-To: <200703162132.53906.lenb@kernel.org>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <200703162132.53906.lenb@kernel.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 17 Mar 2007 11:32:19 +0100
Message-Id: <1174127539.3538.207.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-16 at 21:32 -0400, Len Brown wrote:
> On Friday 16 March 2007 19:44, Thomas Gleixner wrote:
> > Maxim,
> > 
> > On Fri, 2007-03-16 at 12:30 +0200, Maxim Levitsky wrote:
> > > 3) Sometimes I get this (once in three boots or so)
> > > 
> > > [   36.217405] ENABLING IO-APIC IRQs
> > > [   36.217587] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > > [   36.433917] APIC timer disabled due to verification failure.
> > > 
> > > And NO_HZ is disabled due to that (I get 1000/s timer's interrupts)
> > > I haven't investigated that yet.
> > > It looks like another new test that my hardware fails to perform... 
> > 
> > Yes, this is probably caused by SMM code trying to emulate a PS/2
> > keyboard from a (maybe connected or not) USB keyboard. Unfortunately we
> > have no way to disable this BIOS misfeature in the early boot process. 
> > Arjan, Len ?????
> 
> Nope.  By definition, SMM is invisible to the OS -- we don't even
> get a bit that said it occurred (though we'd like one -- it would
> be really helpful to diagnose issues like this one)


well we can do the handshake to take ownership like we do much later in
boot, but that requires PCI to be there and fully discovered, which we
don't have this early.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

