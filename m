Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZCUFBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZCUFBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 01:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbZCUFAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 01:00:51 -0400
Received: from bowden.ucwb.org.au ([203.122.237.119]:41832 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZCUFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 01:00:50 -0400
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1237411441.5211.5.camel@kulgan.wumi.org.au>
References: <9nR7rAsBwYG.A.iEG.fOCvJB@chimera>
	 <qm8_cedJGaP.A.-NH.CPCvJB@chimera>
	 <1237107837.27699.27.camel@kulgan.wumi.org.au>
	 <49BE20B2.9070804@redhat.com> <1237207595.4964.31.camel@kulgan.wumi.org.au>
	 <20090316200736.GD8393@nowhere>
	 <1237244137.4964.54.camel@kulgan.wumi.org.au>
	 <20090318001955.GB5143@nowhere>
	 <1237338986.4801.11.camel@kulgan.wumi.org.au>
	 <1237411441.5211.5.camel@kulgan.wumi.org.au>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Sat, 21 Mar 2009 15:30:39 +1030
Message-Id: <1237611639.4933.4.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 07:54 +1030, Kevin Shanahan wrote:
> On Wed, 2009-03-18 at 11:46 +1030, Kevin Shanahan wrote:
> > On Wed, 2009-03-18 at 01:20 +0100, Frederic Weisbecker wrote:
> > > Ok, I've made a small script based on yours which could do this job.
> > > You will just have to set yourself a threshold of latency
> > > that you consider as buggy. I don't remember the latency you observed.
> > > About 5 secs right?
> > > 
> > > It's the "thres" variable in the script.
> > > 
> > > The resulting trace should be a mixup of the function graph traces
> > > and scheduler events which look like this:
> > > 
> > >  gnome-screensav-4691  [000]  6716.774277:   4691:120:S ==> [000]     0:140:R <idle>
> > >   xfce4-terminal-4723  [001]  6716.774303:   4723:120:R   + [001]  4289:120:S Xorg
> > >   xfce4-terminal-4723  [001]  6716.774417:   4723:120:S ==> [001]  4289:120:R Xorg
> > >             Xorg-4289  [001]  6716.774427:   4289:120:S ==> [001]     0:140:R <idle>
> > > 
> > > + is a wakeup and ==> is a context switch.
> > > 
> > > The script will loop trying some pings and will only keep the trace that matches
> > > the latency threshold you defined.
> > > 
> > > Tell if the following script work for you.
> 
> ...
> 
> > Either way, I'll try to get some results in my maintenance window
> > tonight.
> 
> Testing did not go so well. I compiled and booted
> 2.6.29-rc8-tip-02630-g93c4989, but had some problems with the system
> load when I tried to start tracing - it shot up to around 16-20 or so. I
> started shutting down VMs to try and get it under control, but before I
> got back to tracing again the machine disappeared off the network -
> unresponsive to ping.
> 
> When I got in this morning, there was nothing on the console, nothing in
> the logs to show what went wrong. I will try again, but my next chance
> will probably be Saturday. Stay tuned.

Okay, new set of traces have been uploaded to:

  http://disenchant.net/tmp/bug-12465/trace-3/

These were done on the latest tip, which I pulled down this morning:
2.6.29-rc8-tip-02744-gd9937cb.

The system load was very high again when I first tried to trace with
sevarl guests running, so I ended up only having the one guest running
and thankfully the bug was still reproducable that way.

Fingers crossed this set of traces is able to tell us something.

Regards,
Kevin.


