Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYHWKng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYHWKng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 06:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYHWKn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 06:43:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbYHWKn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 06:43:26 -0400
Date: Sat, 23 Aug 2008 12:43:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Joshua Hoblitt <j_kernel@hoblitt.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bug 11388] New: 2.6.27-rc3 warns about MTRR range; only 3 of
	16gb of memory is usable
Message-ID: <20080823104311.GC25904@elte.hu>
References: <20080822011055.GI23377@hoblitt.com> <86802c440808211855h50ea65faudc169e48f83e18e2@mail.gmail.com> <20080822021512.GJ23377@hoblitt.com> <86802c440808211926k1ec5b2a2g2bec1b7faee7ebbb@mail.gmail.com> <86802c440808212024v3ccd2a7ey6517c180464275f0@mail.gmail.com> <20080822035024.GB30284@elte.hu> <20080822035609.GD30284@elte.hu> <86802c440808212148k74e56fa2mdb2e329ed4df1271@mail.gmail.com> <20080823002235.GL23377@hoblitt.com> <86802c440808222252j6f900f1dlfbf1378a7bc35ee4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808222252j6f900f1dlfbf1378a7bc35ee4@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Aug 22, 2008 at 5:22 PM, Joshua Hoblitt <j_kernel@hoblitt.com> wrote:
> > I've confirmed that the boards in these systems are Tyan Tempest 
> > i5400PW (S5397)s.  We've discovered a workload that will deadlock 
> > the system under both 2.6.24.2 and -tip kernel with the mtrr masking 
> > patch.  The only thing unusual about this workload is that one of 
> > the binaries in it constantly segvs...  Is it possible that these 
> > deadlocks (no kernel oops on console) are caused by MSR setup 
> > wierdness or is it likely unrelated?
> 
> could be other problem.
> 
> cpu should be smarter enough to understand the missing bits in mask. 
> at least amd cpu. remember that we didn't set mask bits to 40bits with 
> opteron with LinuxBIOS, and everything still works well.

yeah. Is the deadlock debuggable? (does nmi_watchdog=1 produce anything 
useful, or does the enabling of CONFIG_PROVE_LOCKING=y show anything 
weird in the syslog during light, non-deadlocking use of this workload?)

	Ingo
