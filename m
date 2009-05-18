Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbZEROrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbZEROrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbZEROqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:46:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbZEROqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:46:54 -0400
Date: Mon, 18 May 2009 16:41:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090518144132.GA18607@redhat.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.K7C._ZzDKB@chimera> <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, I had a vacation.

On 05/17, Linus Torvalds wrote:
>
> On Sat, 16 May 2009, Rafael J. Wysocki wrote:
> >
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
> > Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
> > Submitter	: Kumar Gala <galak@kernel.crashing.org>
> > Date		: 2009-04-09 15:43 (38 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
> > References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
> > 		  http://lkml.org/lkml/2009/4/10/193
> > Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>
> I think we have to revert that thing. I haven't heard of any fixes to that
> commit.

I thought this was already resolved.

And I don't think the kernel is buggy, this is expected behaviour. With
this commit (actually, there were several patches) /sbin/init respects
SIGSTOP if the caller has rights to send it, this change is intentional.
I'd even say this is fix.

Note that even root can't stop init, SIGSTOP should be sent from the
parent namespace, or from ptracer. And ptracer could obviously ptrace_stop()
init even before this patch.


But, Kumar, could you please provide more info? I downloaded
ltp-full-20081130.tgz, and I see that ptrace03.c does:

                        /* since Linux 2.6.26, it's allowed to trace init,
                           so just skip this test case */
                        if (i == 0 && tst_kvercmp(2,6,25) > 0) {
                                tst_resm(TCONF,
                                         "this kernel allows to trace init");
                                continue;
                        }

So, could you explain which test traces init?

Oleg.

