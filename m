Return-Path: <linux-kernel-owner+w=401wt.eu-S1030321AbXCPXh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321AbXCPXh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030333AbXCPXh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:37:56 -0400
Received: from www.osadl.org ([213.239.205.134]:36948 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030321AbXCPXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:37:54 -0400
Subject: Re: [BUG] 2.6.21-rc1,2,3 regressions on my system that I found so
	far
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <200703161230.03712.maximlevitsky@gmail.com>
References: <200703161230.03712.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:44:46 +0100
Message-Id: <1174088686.13341.347.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim,

On Fri, 2007-03-16 at 12:30 +0200, Maxim Levitsky wrote:
> 3) Sometimes I get this (once in three boots or so)
> 
> [   36.217405] ENABLING IO-APIC IRQs
> [   36.217587] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [   36.433917] APIC timer disabled due to verification failure.
> 
> And NO_HZ is disabled due to that (I get 1000/s timer's interrupts)
> I haven't investigated that yet.
> It looks like another new test that my hardware fails to perform... 

Yes, this is probably caused by SMM code trying to emulate a PS/2
keyboard from a (maybe connected or not) USB keyboard. Unfortunately we
have no way to disable this BIOS misfeature in the early boot process. 
Arjan, Len ?????

I built in this test to rule out bogus LAPIC timer calibration values
which are sometimes off by factor 2-10.

But I also built in a calibration against the PM-Timer, which turned out
to be quite reliable and I think the additional verification step is
only necessary for sytems without PM-Timer.

That was a bit over cautious from my side. I send a patch to avoid this
when PM-Timer is available in a separate mail.

	tglx


