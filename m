Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZESJRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZESJRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZESJRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:17:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbZESJRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:17:48 -0400
Date: Tue, 19 May 2009 11:16:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090519091631.GB31404@elte.hu>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.K7C._ZzDKB@chimera> <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain> <20090518144132.GA18607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518144132.GA18607@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> Sorry for delay, I had a vacation.
> 
> On 05/17, Linus Torvalds wrote:
> >
> > On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> > >
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.29.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> > > Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> > > Submitter	: Kumar Gala <galak@kernel.crashing.org>
> > > Date		: 2009-04-09 15:43 (38 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> > > References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> > > 		  http://lkml.org/lkml/2009/4/10/193
> > > Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> >
> > I think we have to revert that thing. I haven't heard of any fixes to that
> > commit.
> 
> I thought this was already resolved.
> 
> And I don't think the kernel is buggy, this is expected behaviour. 
> With this commit (actually, there were several patches) /sbin/init 
> respects SIGSTOP if the caller has rights to send it, this change 
> is intentional. I'd even say this is fix.
> 
> Note that even root can't stop init, SIGSTOP should be sent from 
> the parent namespace, or from ptracer. And ptracer could obviously 
> ptrace_stop() init even before this patch.

There's one important aspect here: _if_ a change results in 
user-space visible behavioral change, it does not matter how correct 
it is in the grand scheme of things. (beyond plain bugfixes solving 
crashes, etc.) What matters is whether there's any app out there 
that might possibly rely on the old behavior.

The LTP testcase might be synthetic, and it could be fixed and the 
commit might even end up being correct - but some thought should be 
expended on compatibility and real-life impact (and scope) here - 
not just on strict 'correctness'.

	Ingo
