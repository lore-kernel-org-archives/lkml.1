Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZATM5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZATM5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATM5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:57:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbZATM5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:57:20 -0500
Date: Tue, 20 Jan 2009 13:56:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090120125652.GA1457@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232455343.4895.4.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0049]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> > This suggests some sort of KVM-specific problem. Scheduler latencies 
> > in the seconds that occur under normal load situations are noticed and 
> > reported quickly - and there are no such open regressions currently.
> 
> It at least suggests a problem with interaction between the scheduler 
> and kvm, otherwise reverting that scheduler patch wouldn't have made the 
> regression go away.

the scheduler affects almost everything, so almost by definition a 
scheduler change can tickle a race or other timing bug in just about any 
code - and reverting that change in the scheduler can make the bug go 
away. But yes, it could also be a genuine scheduler bug - that is always a 
possibility.

Could you please run a cfs-debug-info.sh session on a CONFIG_SCHED_DEBUG=y 
and CONFIG_SCHEDSTATS=y kernel, while you are experiencing those 
latencies:

  http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and post that (relatively large) somewhere, or send it as a reply after 
bzip2 -9 compressing it? It will include a lot of information about the 
delays your tasks are experiencing.

	Ingo
