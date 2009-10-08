Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZJHNTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZJHNTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 09:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbZJHNTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 09:19:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:33155 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758136AbZJHNTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 09:19:23 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198IVUTxtJ84THPaGT6C2vlF8JE9IkrZqXbvqjPYt
	QH1pixbGe0r7O2
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910081509.05394.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
	 <1255001062.7500.1.camel@marge.simson.net>
	 <200910081509.05394.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 15:18:33 +0200
Message-Id: <1255007913.8381.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 15:09 +0200, Frans Pop wrote:
> On Thursday 08 October 2009, Mike Galbraith wrote:
> > Care to try a patch?
> >
> > latencytop: only account on-runqueue wait time as being scheduler
> > latency.
> >
> > Latencytop was accounting uninterruptible and interruptible sleep time
> > up to 5ms, which is not the latency the user is looking for.  Account
> > time waiting on-runqueue instead.  Also add a clock update to
> > update_curr() for the case where there's nobody home.  When coming out
> > of idle with NO_HZ, not updating the clock leads to bogus max latency
> > report.
> 
> With this patch the high values for iwlagn and phy0 are gone. The values 
> now match roughly with the output of your script.
> 
> If (un)interruptible sleep is worth displaying in latencytop then maybe it 
> should be identified as a separate cause instead of lumped under "waiting 
> for CPU"?

That's what I was just thing about trying, add a cause sleep.

> > TODO: Figure out where the heck empty braces come from.
> 
> I also see these lines with "[]" sometimes; looks to come from 'sleep'.
> 
> And I still see lines with only a "." as the cause; this seems specific to 
> targets marked with the penguin (work queues?).
> 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > Arjan van de Ven <arjan@infradead.org>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > LKML-Reference: <new-submission>
> 
> If Arjan is happy with the patch, please add my:

Probably just a diagnostic, but...

> Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Saved.

	-Mike

