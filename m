Return-Path: <linux-kernel-owner+w=401wt.eu-S1422852AbXBASFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422852AbXBASFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422867AbXBASFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:05:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422852AbXBASFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:05:12 -0500
Date: Thu, 1 Feb 2007 19:02:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070201180247.GA561@elte.hu>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <20070201130234.GA15257@elte.hu> <20070201131903.GA24683@infradead.org> <20070201135215.GA23477@elte.hu> <45C21FCC.7040406@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C21FCC.7040406@rtr.ca>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3314]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark Lord <lkml@rtr.ca> wrote:

> >also, we context-switch kernel threads in 350 nsecs on current 
> >hardware and the -rt kernel is certainly happy with that and runs all 
> >hardirqs
> 
> Ingo, how relevant is that "350 nsecs on current hardware" claim?
> 
> I don't mean that in a bad way, but my own experience suggests that 
> most people doing real hard RT (or tight soft RT) are not doing it on 
> x86 architectures.  But rather on lowly 1GHz (or less) ARM based 
> processors and the like.

it's not relevant to those embedded boards, but it's relevant to the AIO 
discussion, which centers around performance.

> For RT issues, those are the platforms I care more about, as those are 
> the ones that get embedded into real-time devices.

yeah. Nevertheless if you want to use -rt on your desktop (under Fedora 
4/5/6) you can track an rpmized+distroized full kernel package quite 
easily, via 3 easy commands:

   cd /etc/yum.repos.d
   wget http://people.redhat.com/~mingo/realtime-preempt/rt.repo

   yum install kernel-rt.x86_64   # on x86_64
   yum install kernel-rt          # on i686

which is closely tracking latest upstream -git. (for example, the 
current kernel-rt-2.6.20-rc7.1.rt3.0109.i686.rpm is based on 
2.6.20-rc7-git1, so if you want to run a kernel rpm that has all of 
Linus' latest commits from yesterday, this might be for you.)

it's rumored to be a quite smooth kernel ;-) So in this sense, because 
this also runs on all my testboxes by default, it matters on modern 
hardware too, at least to me. Today's commodity hardware is tomorrow's 
embedded hardware. If a kernel is good on today's colorful desktop 
hardware then it will be perfect for tomorrow's embedded hardware.

	Ingo
