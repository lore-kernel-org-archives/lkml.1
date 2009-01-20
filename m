Return-Path: <linux-kernel-owner+w=401wt.eu-S1760881AbZATLgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760881AbZATLgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758330AbZATLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:36:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46245 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZATLgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:36:19 -0500
Date: Tue, 20 Jan 2009 12:35:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>, Avi Kivity <avi@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Kevin Shanahan <kmshanah@flexo.wumi.org.au>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090120113546.GA26571@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232410363.4768.21.camel@kulgan.wumi.org.au>
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


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> On Mon, 2009-01-19 at 22:45 +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> > Subject		: KVM guests stalling on 2.6.28 (bisected)
> > Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> > Date		: 2009-01-17 03:37 (3 days old)
> 
> Yes, please keep this on the list.

This only seems to occur under KVM, right? I.e. you tested it with -no-kvm 
and the problem went away, correct?

This suggests some sort of KVM-specific problem. Scheduler latencies in 
the seconds that occur under normal load situations are noticed and 
reported quickly - and there are no such open regressions currently.

Avi, can you reproduce these latencies? A possibly theory would be some 
sort of guest wakeup problem/race triggered by a shift in 
preemption/scheduling patterns. Or something related to preempt-notifiers 
(which KVM is using). A genuine scheduler bug is in the cards too, but the 
KVM-only angle of this bug gives it a low probability.

	Ingo
