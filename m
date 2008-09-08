Return-Path: <linux-kernel-owner+w=401wt.eu-S1753451AbYIHGlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbYIHGlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 02:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbYIHGkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 02:40:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:46280 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYIHGkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 02:40:53 -0400
Subject: Re: [Bug #11209] 2.6.27-rc1 process time accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
In-Reply-To: <200809080002.09381.rjw@sisk.pl>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik>
	 <Wz8EH5sroeE.A.mUD.WswwIB@albercik>
	 <1220778273.8687.20.camel@twins.programming.kicks-ass.net>
	 <200809080002.09381.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 08:40:46 +0200
Message-Id: <1220856046.8687.106.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 (2.23.91-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-08 at 00:02 +0200, Rafael J. Wysocki wrote:
> On Sunday, 7 of September 2008, Peter Zijlstra wrote:
> > On Sat, 2008-09-06 at 23:30 +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.26.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
> > > Subject		: 2.6.27-rc1 process time accounting
> > > Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> > > Date		: 2008-07-31 10:43 (38 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
> > > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > Should be fixed in the latest -git
> 
> Thanks for the update.
> 
> Does any specific commit fix it or just a series of recent commits?

commit 49048622eae698e5c4ae61f7e71200f265ccc529
Author: Balbir Singh <balbir@linux.vnet.ibm.com>
Date:   Fri Sep 5 18:12:23 2008 +0200

    sched: fix process time monotonicity

    Spencer reported a problem where utime and stime were going negative despite
    the fixes in commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. The suspected
    reason for the problem is that signal_struct maintains it's own utime and
    stime (of exited tasks), these are not updated using the new task_utime()
    routine, hence sig->utime can go backwards and cause the same problem
    to occur (sig->utime, adds tsk->utime and not task_utime()). This patch
    fixes the problem

commit 56c7426b3951e4f35a71d695f1c982989399d6fd
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Sep 1 16:44:23 2008 +0200

    sched_clock: fix NOHZ interaction

    If HLT stops the TSC, we'll fail to account idle time, thereby inflating the
    actual process times. Fix this by re-calibrating the clock against GTOD when
    leaving nohz mode.




