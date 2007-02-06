Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXBFVym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXBFVym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965544AbXBFVym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:54:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:22706 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965543AbXBFVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:54:41 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
Reply-To: dwalker@mvista.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070206214131.GA1176@elte.hu>
References: <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1>  <20070206214131.GA1176@elte.hu>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 13:54:39 -0800
Message-Id: <1170798879.3455.58.camel@dwalker1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 22:41 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > we could make this clearer by renaming 'LOC' (which stands for 
> > > 'LOCal timer interupts' and was added [and misnamed] by yours truly 
> > > many moons ago) to 'apic-timer' and 'timer' to 'PIT-timer' but 
> > > /that/ would be more of a userspace visible change than the change 
> > > in the counter rates.
> > 
> > If we change the current "timer" entry to be listed as "lapic-timer" 
> > and not "IO-APIC-edge" (or one of the other names) and replace it with 
> > the count from LOC , [...]
> 
> doing that would not fake the old behavior (which is your suggestion), 
> LOC is per CPU, while the PIT timer irq that was there is global.
> 
> But, as per the previous mails, the new behavior is just fine, because 
> /proc/interrupts just reflects reality. And the way the kernel utilizes 
> the hardware has just changed - for the better.
> 
> The same happens when say a network driver implements NAPI: the IRQ 
> count goes way, way down. Or if a driver starts supporing MSI - the IRQ 
> line even moves to another one. Do we try to fix those counts up to 
> match the 'previous behavior'? Of course not. What you are suggesting 
> makes no sense, is against current kernel practices - as we pointed it 
> out to you 7 mails ago.

I'm not saying we should "fake" anything .. I'm saying list what's
really happening .. In a human readable way .

Your saying we should keep it unreadable, and let the users be that much
more confused .. Which I don't agree with.

> > [...] that would make sense cause that field already changes depending 
> > if you have a io-apic or not ..
> 
> (that is something else: it's different because a different irq-chip is 
> behind it.)

Why is that not the case with lapic ? 

Daniel

