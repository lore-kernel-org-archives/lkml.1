Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZBOKOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZBOKOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZBOKOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:14:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZBOKN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:13:59 -0500
Date: Sun, 15 Feb 2009 11:13:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215101351.GA23274@elte.hu>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215095128.GA3234@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Damien Wyart <damien.wyart@free.fr> wrote:

> > > Load average is between 0.30 and 0.60 when the machine is idle, the
> > > two ksoftirqd threads get a very high total running time in top.
> > > This is on a P4 machine. On a recent laptop, the load is not as
> > > high, but the ksoftirqd threads also get a very high total running
> > > time.
> 
> > Mind having a look at this anomaly with the function graph tracer? We are
> > interested in a representative trace that shows the weird ksoftirq activities.
> > [ which trace could possibly pinpoint their origin. ]
> 
> > Here's the tracing quickstart:
> 
> >    http://redhat.com/~mingo/tip.git/tracing-quickstart.txt
> 
> > Also attached below. Let me know if you have trouble getting a good trace,
> > or if any of the steps were non-intuitive or burdensome to you.
> 
> Thanks for your feedback & explanations; I will try to have a look at
> all this material asap, I think tomorrow.

Note that if the box you test this on is multi-core or HT, then interpreting
traces is easier if there's just a single CPU to look at. In that case i'd 
suggest to reproduce with just a single core, by turning the second one off:

   echo 0 > /sys/devices/system/cpu/cpu1/online

Or, if the problem only occurs with two cpus, restrict tracing to CPU#1:

   echo 2 > /debug/tracing/tracing_cpumask 

	Ingo
