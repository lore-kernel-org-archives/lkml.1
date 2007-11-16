Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbXKPKqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbXKPKqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 05:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbXKPKqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 05:46:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbXKPKqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:46:20 -0500
Date: Fri, 16 Nov 2007 11:45:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Micah Dowty <micah@vmware.com>
Cc: Christoph Lameter <clameter@sgi.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071116104557.GA5453@elte.hu>
References: <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com> <20071115202425.GC4914@vmware.com> <Pine.LNX.4.64.0711151328090.29711@schroedinger.engr.sgi.com> <20071115213510.GA16079@vmware.com> <Pine.LNX.4.64.0711151830260.31691@schroedinger.engr.sgi.com> <20071116024408.GA20322@vmware.com> <20071116060700.GD16273@elte.hu> <20071116091904.GB31219@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116091904.GB31219@vmware.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Micah Dowty <micah@vmware.com> wrote:

> On Fri, Nov 16, 2007 at 07:07:00AM +0100, Ingo Molnar wrote:
> > > My best guess is that this has something to do with the timing with 
> > > which we sample the CPU's instantaneous load when calculating the load 
> > > averages.. but I still understand only the basics of the scheduler and 
> > > SMP balancer. All I really know for sure at this point regarding your 
> > > patch is that git-bisect found it for me.
> > 
> > hm, your code uses timeouts for this, right? The CPU load average that 
> > is used for SMP load balancing is sampled from the scheduler tick - and 
> > has been sampled from the scheduler tick for eons. v2.6.23 defaulted to 
> > a different method but v2.6.24 samples it from the tick again. So my 
> > guess is, your testcode behave similarly on 2.6.22 too, correct?
> 
> My sample program (and the VMware code which I originally observed
> this behaviour with) wakes up frequently using /dev/rtc.
> 
> I know the problem occurs on 2.6.20 and 2.6.23.1. I haven't tried 
> 2.6.22 yet, but I'll do so as soon as I can.

ok, if you see it on .20 then no need to try .22.

	Ingo
