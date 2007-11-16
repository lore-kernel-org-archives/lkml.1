Return-Path: <linux-kernel-owner+w=401wt.eu-S1764710AbXKPNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764710AbXKPNxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXKPNxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:53:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:52706 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756297AbXKPNxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:53:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4nvkmDtG4Tlt2AEqByyEY34OmfCj0Mf3MbBxj1I
	EiOHhqc1Y2crdS
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl, Len Brown <lenb@kernel.org>
In-Reply-To: <20071116112317.GA12724@elte.hu>
References: <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca>
	 <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca>
	 <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu>
	 <473CC6D4.2010909@rtr.ca> <20071116055531.GA16273@elte.hu>
	 <20071116071522.GA1453@elte.hu> <20071116082146.GA14685@elte.hu>
	 <20071116112317.GA12724@elte.hu>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 06:53:13 -0500
Message-Id: <1195213993.4037.21.camel@Knoppix>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 12:23 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > once that tracer bug was fixed, the best method to generate a trace 
> > was to do this:
> > 
> >    echo 1 > /proc/sys/kernel/stackframe_tracing
> >    echo 1 > /proc/sys/kernel/syscall_tracing
> >    ./trace-cmd bash -c "echo mem > /sys/power/state" > trace.txt
> 
> so here's an UP suspend+resume trace i did:
> 
>   http://redhat.com/~mingo/latency-tracing-patches/misc/trace-suspend-long.txt.bz2
> 
> tons of detail - which might be interesting to other folks as well. Fact 
> is, our suspend-to-RAM+resume cycle is very, very slow, even on fast 
> hardware - and this trace shows all the reasons why.
> 
> This was a fully cached system - i.e. i've done a suspend+resume before 
> to warm up the caches. (not that suspend+resume does much IO normally.)
> 
> The trace shows that a suspend+resume cycle is 7.95 seconds long 
> (without counting the time the box spent suspended) - ouch! This was a 
> T60 with Core2Duo 1.83GHz.

Ouch?  That's an order of magnitude faster than my 3GHz P4 :)

	-Mike

