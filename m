Return-Path: <linux-kernel-owner+w=401wt.eu-S965571AbXBFWOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbXBFWOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:14:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXBFWN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:13:58 -0500
Received: from www.osadl.org ([213.239.205.134]:49909 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965571AbXBFWNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:13:31 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170798879.3455.58.camel@dwalker1>
References: <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1> <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1> <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1>  <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 23:13:40 +0100
Message-Id: <1170800020.3785.41.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 13:54 -0800, Daniel Walker wrote:
> > The same happens when say a network driver implements NAPI: the IRQ 
> > count goes way, way down. Or if a driver starts supporing MSI - the IRQ 
> > line even moves to another one. Do we try to fix those counts up to 
> > match the 'previous behavior'? Of course not. What you are suggesting 
> > makes no sense, is against current kernel practices - as we pointed it 
> > out to you 7 mails ago.
> 
> I'm not saying we should "fake" anything .. I'm saying list what's
> really happening .. In a human readable way .

We do that. IRQ0 is not happening. So simply it does not increment the
interrupt count. And it is human readable.

> Your saying we should keep it unreadable, and let the users be that much
> more confused .. Which I don't agree with.

It is readable, as it reflects the reality which is going on in the
system and not some artificial view which you think is how the interrupt
count should be presented. /proc/interrupt _IS_ statistics about the
number of interrupts on particular interrupt numbers and nothing else. 

> Why is that not the case with lapic ? 

Local APIC is not really part of the interrupt subsystem as it uses a
seperate entry vector for historic reasons and therefor is not handled
by setup/request/free/... _irq() functions.

	tglx


