Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbZERRzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbZERRzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZERRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:54:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55444 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbZERRy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:54:56 -0400
Date: Mon, 18 May 2009 10:54:10 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #13107] LTP 20080131 causes defunct processes w/2.6.30-rc1
Message-ID: <20090518175410.GA2713@us.ibm.com>
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera> <385Pu-agh7M.A.K7C._ZzDKB@chimera> <alpine.LFD.2.01.0905171206330.3301@localhost.localdomain> <20090518144132.GA18607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518144132.GA18607@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| Sorry for delay, I had a vacation.
| 
| On 05/17, Linus Torvalds wrote:
| >
| > On Sat, 16 May 2009, Rafael J. Wysocki wrote:
| > >
| > > This message has been generated automatically as a part of a report
| > > of recent regressions.
| > >
| > > The following bug entry is on the current list of known regressions
| > > from 2.6.29.  Please verify if it still should be listed and let me know
| > > (either way).
| > >
| > >
| > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13107
| > > Subject		: LTP 20080131 causes defunct processes w/2.6.30-rc1
| > > Submitter	: Kumar Gala <galak@kernel.crashing.org>
| > > Date		: 2009-04-09 15:43 (38 days old)
| > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3bfa0cba867f23365b81658b47efd906830879b
| > > References	: http://marc.info/?l=linux-kernel&m=123929187208953&w=4
| > > 		  http://lkml.org/lkml/2009/4/10/193
| > > Handled-By	: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| >
| > I think we have to revert that thing. I haven't heard of any fixes to that
| > commit.
| 
| I thought this was already resolved.

Yes, so did I. We had asked for more info/confirmation before, most recently
on Apr 25 http://lkml.org/lkml/2009/4/25/132, although finding the LTP
test like below would have helped :-)

| 
| And I don't think the kernel is buggy, this is expected behaviour. With
| this commit (actually, there were several patches) /sbin/init respects
| SIGSTOP if the caller has rights to send it, this change is intentional.
| I'd even say this is fix.
| 
| Note that even root can't stop init, SIGSTOP should be sent from the
| parent namespace, or from ptracer. And ptracer could obviously ptrace_stop()
| init even before this patch.
| 
| 
| But, Kumar, could you please provide more info? I downloaded
| ltp-full-20081130.tgz, and I see that ptrace03.c does:

I beleive Kumar was running an older version of LTP (20080131)

| 
|                         /* since Linux 2.6.26, it's allowed to trace init,
|                            so just skip this test case */
|                         if (i == 0 && tst_kvercmp(2,6,25) > 0) {
|                                 tst_resm(TCONF,
|                                          "this kernel allows to trace init");
|                                 continue;
|                         }
| 
| So, could you explain which test traces init?
| 
| Oleg.
