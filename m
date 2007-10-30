Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbXJ3R6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbXJ3R6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbXJ3R57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:57:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39724 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbXJ3R57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:57:59 -0400
Subject: Re: [PATCH] raise tsc clocksource rating
From: Zachary Amsden <zach@vmware.com>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, rusty@rustcorp.com.au, jeremy@goop.org,
       --cc@redhat.com, avi@quramnet.com, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
In-Reply-To: <47271D4A.8030707@redhat.com>
References: <11936994092607-git-send-email-gcosta@redhat.com>
	 <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com>
	 <20071029224852.GA27547@elte.hu>
	 <1193698505.9793.90.camel@bodhitayantram.eng.vmware.com>
	 <20071029230213.GA1982@elte.hu>
	 <1193699638.9793.97.camel@bodhitayantram.eng.vmware.com>
	 <47271D4A.8030707@redhat.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 10:58:50 -0700
Message-Id: <1193767130.9793.119.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-30 at 10:02 -0200, Glauber de Oliveira Costa wrote:

> > No, if no paravirt clocksource is detected, nothing can override the
> > perfect TSC hardware clocksource rating of 400.  And if a paravirt
> > clocksource is detected, it is always better than TSC.
> 
> Why always? tsc is the best possible alternative the _platform_ can
> provide. So the paravirt clocksource will be at best, as good as tsc.

What is the justification for this claim?  The TSC provides no
information about frequency.  The frequency must be measured from a
known fixed rate source.  This measurement is error prone, both on real
hardware, and even more so in a VM.

The TSC can only provide a single measure of elapsed periods.  It has no
concept to differentiate between elapsed periods of time spent in the
guest, which is relevant to the scheduler, and elapsed periods of time
spent in real time, which is relevant to timekeeping.

So a TSC can not drive both timekeeping and scheduling in a virtual
machine, or if it does, it does so inaccurately.


> And if it is the case: why bother with communication mechanisms of all
> kinds, calculations, etc, if we can just read the tsc?
> 
> Noting again: If the tsc does not arrive accurate to the guest, it will
> fail the tsc clocksource tests. So it will be rated zero anyway

You always need to provide a TSC, and it will always initially appear to
be accurate.  Long term, as time is reported via the TSC is an
approximation somewhere between real time and elapsed running time,
measurements made using it in a VM will drift, and it is impossible to
remove the inaccuracy from one end of the spectrum (by providing real
time exactly) without compromising it at the other end (by skewing
relative time measurement).

A paravirt clocksource is always better than a TSC because it
compensates for these effects.

Zach

