Return-Path: <linux-kernel-owner+w=401wt.eu-S1750853AbXB0HiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750853AbXB0HiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 02:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXB0HiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 02:38:18 -0500
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:59165 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853AbXB0HiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 02:38:17 -0500
Date: Tue, 27 Feb 2007 02:38:15 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@mvista.com>, mbligh@google.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI handler
Message-ID: <20070227073815.GA25894@Krystal>
References: <1164585589.16871.52.camel@localhost.localdomain> <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com> <20070226205304.GA30800@Krystal> <1172525261.5517.69.camel@imap.mvista.com> <20070226221423.GA2286@Krystal> <1172531521.5517.138.camel@imap.mvista.com> <20070227035456.GA15444@Krystal> <1172550161.5517.210.camel@imap.mvista.com> <20070227062913.GC1259@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070227062913.GC1259@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 02:32:49 up 24 days, 21:40,  4 users,  load average: 1.24, 1.29, 1.33
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > The pit clocksource could be dropped pretty easy with my clocksource 
> > update patches, which I'm still working on but you could easily drop 
> > clock sources that aren't atomic like the pit .. Also the pit is 
> > generally undesirable, so it's not going to be missed.
> 
> that's totally unacceptable, and i'm amazed you are even suggesting it - 
> often the PIT ends up being the most reliable hardware clock in a PC. 
> Btw., what's wrong with the spinlock that is protecting PIT access? It 
> expresses the non-atomic property of the PIT just fine.
> 

I am concerned about the automatic fallback to the PIT when no other
clock source is available. A clocksource read would be atomic when TSC
or HPET are available, but would fall back on PIT otherwise. There
should be some way to specify that a caller is only interested in atomic
clock sources (if none are available, the call should simply return an
error, or 0).

I still think that an RCU style update mechanism would be a good way  to
fix the current clocksource read issue. Another, slower and non NMI
safe way to do this would be with a read seqlock and with IRQ disabling.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
